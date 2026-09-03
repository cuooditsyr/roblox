-- =============================================
-- 1. 获取游戏服务
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- =============================================
-- 2. 创建独立的自瞄系统表
-- =============================================
local Aimbot = {
    -- 状态开关
    Enabled = false,             -- 是否开启
    Target = nil,                -- 当前锁定的目标玩家
    TargetPart = "Head",         -- 瞄准部位（Head / HumanoidRootPart）
    
    -- 参数配置（你可以在这里手动修改数值）
    Range = 1000,                 -- 最大锁定距离
    Fov = 110,                   -- 视野角度（360 = 全屏）
    Smoothness = 5,              -- 平滑度（1~20，数值越小越平滑，20为瞬瞄）
    Prediction = 0.5,            -- 移动预测强度（0~1）
    
    -- 过滤开关
    WallCheck = true,            -- 是否检测墙体遮挡
    TeamCheck = true,            -- 是否区分队友（防止打队友）
    
    -- 本地玩家和相机
    LocalPlayer = nil,
    
    -- 墙体检测缓存（防止每帧重复射线检测，优化性能）
    RaycastCache = {},
    CacheExpiry = 0.1,           -- 缓存有效期（秒）
}

-- =============================================
-- 3. 队伍检测
-- =============================================
function Aimbot:isEnemy(player)
    if not self.TeamCheck then return true end
    local myTeam = self.LocalPlayer.Team
    local targetTeam = player.Team
    if not myTeam or not targetTeam then return true end
    return myTeam ~= targetTeam
end

-- =============================================
-- 4. 墙体检测（带缓存）
-- =============================================
function Aimbot:isPlayerVisible(player)
    if not self.WallCheck then return true end
    
    local cacheKey = player.UserId
    local cached = self.RaycastCache[cacheKey]
    if cached and (tick() - cached.time) < self.CacheExpiry then
        return cached.visible
    end
    
    local myChar = self.LocalPlayer.Character
    local targetChar = player.Character
    if not myChar or not targetChar then return false end
    
    local myHead = myChar:FindFirstChild("Head")
    local targetHead = targetChar:FindFirstChild("Head")
    if not myHead or not targetHead then return false end
    
    -- 射线检测参数（忽略自己和目标的身体，防止打到衣服/配件）
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {myChar, targetChar}
    params.IgnoreWater = true
    
    local direction = (targetHead.Position - myHead.Position)
    local result = Workspace:Raycast(myHead.Position, direction, params)
    
    local visible = false
    if not result then
        visible = true
    else
        -- 如果射到的部位属于目标角色，也算可见（比如手指或衣服）
        if result.Instance and result.Instance:IsDescendantOf(targetChar) then
            visible = true
        end
    end
    
    self.RaycastCache[cacheKey] = { visible = visible, time = tick() }
    return visible
end

-- =============================================
-- 5. 移动预测（核心算法）
-- 根据目标当前速度和距离，估算他下一帧的位置
-- =============================================
function Aimbot:predictTargetPosition(player)
    if not player or not player.Character then return nil end
    
    local char = player.Character
    local part = char:FindFirstChild(self.TargetPart)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not part or not root then return nil end
    
    local velocity = root.Velocity
    local currentPos = part.Position
    local camera = Workspace.CurrentCamera
    
    -- 估算子弹飞到目标所需的时间（粗略计算）
    local distance = (currentPos - camera.CFrame.Position).Magnitude
    local timeToHit = distance / 1000  -- 假设子弹速度 1000 单位/秒
    
    -- 预测位置 = 当前位置 + (速度 × 飞行时间 × 预测强度)
    local predictedPos = currentPos + (velocity * timeToHit * self.Prediction)
    
    return predictedPos
end

-- =============================================
-- 6. 寻找最佳目标（FOV筛选 + 距离筛选）
-- =============================================
function Aimbot:getNearestVisiblePlayer()
    local myChar = self.LocalPlayer.Character
    if not myChar then return nil end
    local myHead = myChar:FindFirstChild("Head")
    if not myHead then return nil end
    
    local bestPlayer = nil
    local bestDistance = self.Range
    local camera = Workspace.CurrentCamera
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == self.LocalPlayer then continue end
        if not self:isEnemy(player) then continue end
        
        local char = player.Character
        if not char then continue end
        
        local targetPart = char:FindFirstChild(self.TargetPart)
        local humanoid = char:FindFirstChild("Humanoid")
        if not targetPart or not humanoid or humanoid.Health <= 0 then continue end
        
        -- 距离检测
        local distance = (targetPart.Position - myHead.Position).Magnitude
        if distance > bestDistance then continue end
        
        -- 墙体检测
        if not self:isPlayerVisible(player) then continue end
        
        -- FOV 检测（如果 Fov >= 360，则无视屏幕角度）
        if self.Fov < 360 then
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            
            local viewportSize = camera.ViewportSize
            local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            local screenVec = Vector2.new(screenPos.X, screenPos.Y)
            local distToCenter = (screenVec - center).Magnitude
            
            -- 计算 FOV 对应的屏幕半径
            local fovRadius = (viewportSize.Y / 2) * math.tan(math.rad(self.Fov / 2))
            if distToCenter > fovRadius then continue end
        end
        
        -- 通过所有检测，选为最佳目标
        bestPlayer = player
        bestDistance = distance
    end
    
    return bestPlayer
end

-- =============================================
-- 7. 执行瞄准（平滑插值 + 瞬瞄）
-- =============================================
function Aimbot:aimAtPlayer(player)
    if not player or not player.Character then return end
    
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    
    -- 获取预测后的目标位置
    local targetPos = self:predictTargetPosition(player)
    if not targetPos then return end
    
    -- 计算从相机指向目标的方向向量
    local direction = (targetPos - currentCFrame.Position).Unit
    
    -- 计算平滑因子：Smoothness = 1 时最平滑，= 20 时几乎瞬瞄
    local smoothFactor = math.clamp(self.Smoothness / 20, 0.01, 1)
    local currentLook = currentCFrame.LookVector
    local smoothDirection = currentLook:Lerp(direction, smoothFactor)
    
    -- 应用瞄准
    if self.Smoothness >= 20 then
        -- 高强度：直接对准（瞬瞄）
        camera.CFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + direction)
    else
        -- 普通：平滑移动
        camera.CFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + smoothDirection)
    end
end

-- =============================================
-- 8. 自瞄心跳（每帧执行）
-- =============================================
function Aimbot:startHeartbeat()
    if self.HeartbeatConnection then return end
    
    self.HeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        local target = self:getNearestVisiblePlayer()
        if target then
            self.Target = target
            self:aimAtPlayer(target)
        else
            self.Target = nil
        end
    end)
end

function Aimbot:stopHeartbeat()
    if self.HeartbeatConnection then
        self.HeartbeatConnection:Disconnect()
        self.HeartbeatConnection = nil
    end
    self.Target = nil
end

-- =============================================
-- 9. 开关自瞄（按 Q 键切换）
-- =============================================
function Aimbot:toggle()
    self.Enabled = not self.Enabled
    if self.Enabled then
        self:startHeartbeat()
    else
        self:stopHeartbeat()
    end
end

-- =============================================
-- 10. 按键绑定（默认 Q 键）
-- =============================================
function Aimbot:setupKeybind()
    -- 注意：这里使用 InputBegan 和 InputEnded 实现“按下开启，松开关闭”的效果
    -- 如果你喜欢“按一下切换”，可以把下面的逻辑改成只在 InputBegan 里调用 toggle()
    
    self.KeyBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Q then  -- 按 Q 开启
            if not self.Enabled then
                self:startHeartbeat()
                self.Enabled = true
                print("[自瞄] 开启（按键中）")
            end
        end
    end)
    
    self.KeyEndedConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Q then  -- 松 Q 关闭
            if self.Enabled then
                self:stopHeartbeat()
                self.Enabled = false
                print("[自瞄] 关闭（按键释放）")
            end
        end
    end)
end

-- =============================================
-- 11. 初始化
-- =============================================
function Aimbot:init()
    self.LocalPlayer = Players.LocalPlayer
    
    -- 清理之前的缓存（防止脚本重复执行时冲突）
    self:stopHeartbeat()
    if self.KeyBeganConn then self.KeyBeganConn:Disconnect() end
    if self.KeyEndedConn then self.KeyEndedConn:Disconnect() end
    
    -- 绑定按键
    self:setupKeybind()
    
    -- 设置玩家离开时清理缓存
    Players.PlayerRemoving:Connect(function(player)
        self.RaycastCache[player.UserId] = nil
        if self.Target == player then
            self.Target = nil
        end
    end)
    
    print("[自瞄] 已加载，按 Q 键开启/关闭（按住开启，松开关闭）")
end

-- =============================================
-- 12. 启动
-- =============================================
Aimbot:init()
return Aimbot
-- 如果你想把 Aimbot 暴露到全局，方便调试，可以取消下一行的注释：
-- getgenv().Aimbot = Aimbot