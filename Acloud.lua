-- 获取 Roblox 服务：玩家服务
local Players = game:GetService("Players")
-- 获取本地玩家
local LocalPlayer = Players.LocalPlayer
-- 获取本地玩家的 PlayerGui（用于显示 UI）
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
-- 获取 TweenService 用于动画
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService") -- 用于彩色循环
local mouse = LocalPlayer:GetMouse() -- 获取鼠标服务
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Aimbot = require(script.Parent.Aimbot) -- 导入自瞄模块

-- ======================================== 滑块配置 ========================================
local sliderWidth = 230   -- 轨道宽度
local sliderHeight = 10   -- 轨道高度
local handleSize = 20     -- 拖动按钮的尺寸
local minValue = 0        -- 最小值
local maxValue = 360      -- 最大值
local defaultValue = 110   -- 默认值


-- ======================================== 创建主界面 ScreenGui ========================================
-- 创建一个 ScreenGui 作为 UI 的根容器
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuUI"          -- 命名
ScreenGui.Parent = PlayerGui          -- 放置在玩家 GUI 中
ScreenGui.ResetOnSpawn = false        -- 玩家重生时不重置此 GUI
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 控制层级行为

-- ======================================== 创建主面板 ========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.5, 0, 0.8, 0)        -- 占据屏幕一半宽度，80% 高度
MainFrame.Position = UDim2.new(0.25, 0, 1, 300) -- 位置
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 50) -- 深色背景
MainFrame.BorderSizePixel = 0                      -- 无边框
MainFrame.Active = true                            -- 允许交互
MainFrame.Parent = ScreenGui

-- 添加描边
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 35, 60)       -- 描边颜色
MainStroke.Thickness = 10 -- 描边粗细
MainStroke.Transparency = 0.6 -- 描边透明度
MainStroke.Parent = MainFrame
-- 入场动画
local Entrance_animation = TweenService:Create(MainFrame, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.25, 0, 0.05, 0)
})
Entrance_animation:Play()

-- UI信息
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "云客 × UI"
Title.TextColor3 = Color3.fromRGB(220, 220, 240) -- 文字颜色
Title.TextSize = 100 -- 文字大小
Title.Font = Enum.Font.GothamSemibold -- 字体样式
Title.TextTransparency = 0.5 -- 文字透明度
Title.BackgroundTransparency = 1 -- 背景透明度
Title.Parent = MainFrame

-- ======================================== 功能分区 ========================================
-- 左侧功能类选项面板
local Functional_panel = Instance.new("ScrollingFrame")
Functional_panel.Size = UDim2.new(0.20, 0, 1, 0)
Functional_panel.Position = UDim2.new(0, 0, 0, 0)
Functional_panel.BackgroundTransparency = 0.6 -- 背景透明度
Functional_panel.ScrollingEnabled = true               -- 允许滚动
Functional_panel.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
Functional_panel.ScrollBarThickness = 1                -- 滚动条粗细
Functional_panel.Parent = Title

-- 左侧功能类选项按钮
-- 主页类按钮🏠
local Home_button = Instance.new("TextButton")
Home_button.Size = UDim2.new(0, 70, 0, 50)
Home_button.Position = UDim2.new(0, 0, 0, 0)
Home_button.Text = "🏠 主页"
Home_button.BackgroundTransparency = 0.9
Home_button.TextSize = 15 -- 文字大小
Home_button.TextColor3 = Color3.fromRGB(20, 25, 50) -- 文字颜色
Home_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Home_button.Parent = Functional_panel

-- 战斗类按钮⚔️
local Combat_button = Instance.new("TextButton")
Combat_button.Size = UDim2.new(0, 70, 0, 50)
Combat_button.Position = UDim2.new(0, 0, 0, 52)
Combat_button.Text = "⚔️ 战斗"
Combat_button.BackgroundTransparency = 0.9
Combat_button.TextSize = 15 -- 文字大小
Combat_button.TextColor3 = Color3.fromRGB(20, 25, 50) -- 文字颜色
Combat_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Combat_button.Parent = Functional_panel

-- 透视类按钮🧠
local Perspective_button = Instance.new("TextButton")
Perspective_button.Size = UDim2.new(0, 70, 0, 50)
Perspective_button.Position = UDim2.new(0, 0, 0, 104)
Perspective_button.Text = "🧠 透视"
Perspective_button.BackgroundTransparency = 0.9
Perspective_button.TextSize = 15 -- 文字大小
Perspective_button.TextColor3 = Color3.fromRGB(20, 25, 50) -- 文字颜色
Perspective_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Perspective_button.Parent = Functional_panel

-- 高级类按钮🔱
local Advanced_button = Instance.new("TextButton")
Advanced_button.Size = UDim2.new(0, 70, 0, 50)
Advanced_button.Position = UDim2.new(0, 0, 0, 156)
Advanced_button.Text = "🔱 高级"
Advanced_button.BackgroundTransparency = 0.9
Advanced_button.TextSize = 15 -- 文字大小
Advanced_button.TextColor3 = Color3.fromRGB(20, 25, 50) -- 文字颜色
Advanced_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Advanced_button.Parent = Functional_panel

-- 设置类按钮⚙️
local Settings_button = Instance.new("TextButton")
Settings_button.Size = UDim2.new(0, 70, 0, 50)
Settings_button.Position = UDim2.new(0, 0, 0, 208)
Settings_button.Text = "⚙️ 设置"
Settings_button.BackgroundTransparency = 0.9
Settings_button.TextSize = 15 -- 文字大小
Settings_button.TextColor3 = Color3.fromRGB(20, 25, 50) -- 文字颜色
Settings_button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Settings_button.Parent = Functional_panel

-- 特效跟踪
local VFX_Tracking = Instance.new("Frame")
VFX_Tracking.Size = UDim2.new(0, 60, 0, 40) 
VFX_Tracking.Position = UDim2.new(0, 5, 0, 5) -- 初始化主页类按钮位置
VFX_Tracking.BackgroundTransparency = 1
VFX_Tracking.Parent = Functional_panel
-- 添加描边
local VFX_Tracking_Stroke = Instance.new("UIStroke")
VFX_Tracking_Stroke.Thickness = 5 -- 描边粗细
VFX_Tracking_Stroke.Parent = VFX_Tracking

-- 右测功能内容
-- 功能内容按钮函数
-- （parent_container = 父容器 / X = 位置宽度像素 / Y = 位置高度像素 / Fill_bar = 填充条对象名 / sphere = 圆球对象名 / button = 按钮对象名）
local function Button_creation_function(parent_container, X, Y)
    -- Structure是按钮的主体结构背景和边框
    local Structure = Instance.new("Frame")
    Structure.Size = UDim2.new(0, 48, 0, 18) -- 大小
    Structure.Position = UDim2.new(0, X, 0, Y) -- 位置
    Structure.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- 灰色背景颜色
    Structure.BackgroundTransparency = 0.5 -- 半明度
    Structure.Parent = parent_container -- 绑定父容器
    -- Structure圆角
    local Structure_Corner = Instance.new("UICorner")
    Structure_Corner.CornerRadius = UDim.new(1, 0)
    Structure_Corner.Parent = Structure
    -- Structure描边
    local Structure_Stroke = Instance.new("UIStroke")
    Structure_Stroke.Color = Color3.fromRGB(0, 150, 255)       -- 描边颜色（蓝）
    Structure_Stroke.Thickness = 1 -- 描边粗细
    Structure_Stroke.Parent = Structure
    
    -- 填充条
    local Fill_bar = Instance.new("Frame")
    Fill_bar.Size = UDim2.new(0.38, 0, 1, 0) -- 大小
    Fill_bar.Position = UDim2.new(0, 0, 0, 0) -- 位置
    Fill_bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- 填充条颜色（绿）
    Fill_bar.BorderSizePixel = 0                              -- 无边框
    Fill_bar.Parent = Structure
    -- 填充条圆角
    local Fill_bar_Corner = Instance.new("UICorner")
    Fill_bar_Corner.CornerRadius = UDim.new(1, 0)
    Fill_bar_Corner.Parent = Fill_bar
    
    -- 填充条同步的圆球
    local sphere = Instance.new("Frame")
    sphere.Size = UDim2.new(0.38, 0, 1, 0) -- 大小
    sphere.Position = UDim2.new(0, 0, 0, 0) -- 位置
    sphere.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- 圆球背景颜色（白）
    sphere.BorderSizePixel = 0                              -- 无边框
    sphere.Parent = Structure
    -- 圆球圆角
    local sphere_Corner = Instance.new("UICorner")
    sphere_Corner.CornerRadius = UDim.new(1, 0)
    sphere_Corner.Parent = sphere
    
    -- 按钮
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0) -- 大小
    button.Position = UDim2.new(0, 0, 0, 0) -- 位置
    button.Text = ""
    button.BackgroundTransparency = 1 -- 背景透明度
    button.Parent = Structure
    return button, Fill_bar, sphere
end

-- 主页功能内容
local Homepage_features = Instance.new("ScrollingFrame")
Homepage_features.Size = UDim2.new(0.81, -1, 1, 0)
Homepage_features.Position = UDim2.new(0.19, 1, 0, 0)
Homepage_features.BackgroundTransparency = 0.6
Homepage_features.BorderSizePixel = 0                   -- 描边粗细
Homepage_features.ScrollingEnabled = true               -- 允许滚动
Homepage_features.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
Homepage_features.ScrollBarThickness = 1                -- 滚动条粗细
Homepage_features.Visible = true                           -- 隐藏（true = 不隐藏）（false = 隐藏）
Homepage_features.Parent = Title

-- 战斗功能内容
local Combat_features = Instance.new("ScrollingFrame")
Combat_features.Size = UDim2.new(0.81, -1, 1, 0)
Combat_features.Position = UDim2.new(0.19, 1, 0, 0)
Combat_features.BackgroundTransparency = 0.6
Combat_features.BorderSizePixel = 0                   -- 描边粗细
Combat_features.ScrollingEnabled = true               -- 允许滚动
Combat_features.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
Combat_features.ScrollBarThickness = 1                -- 滚动条粗细
Combat_features.Visible = false                       -- 隐藏（true = 不隐藏）（false = 隐藏）
Combat_features.Parent = Title
-- 自瞄文字提示
local Auto_aim_text = Instance.new("TextLabel")
Auto_aim_text.Size = UDim2.new(0.8, 0, 0.2, 0)
Auto_aim_text.Position = UDim2.new(0, 0, 0, 0)
Auto_aim_text.Text = "================================= 自瞄"
Auto_aim_text.BackgroundTransparency = 1
Auto_aim_text.TextColor3 = Color3.fromRGB(135, 206, 235) -- 文字颜色
Auto_aim_text.Parent = Combat_features
-- 自瞄按钮
local aimbot, Aimbot_Fill_Bar, Aimbot_Sphere = Button_creation_function(Combat_features, 240, 17)
-- 自瞄瞄准范围滑块
-- 创建轨道
local track = Instance.new("Frame")
track.Size = UDim2.new(0, sliderWidth, 0, sliderHeight)
track.Position = UDim2.new(0, 0, 0.2, 0)
track.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
track.BorderSizePixel = 0
track.Parent = Combat_features
-- 轨道添加圆角
local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = track
-- 创建填充条
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.Position = UDim2.new(0, 0, 0, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
fill.BorderSizePixel = 0
fill.Parent = track
-- 填充条添加圆角
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill
-- 创建拖动按钮
local handle = Instance.new("TextButton")
handle.Size = UDim2.new(0, handleSize, 0, handleSize)
handle.Position = UDim2.new(0, 0, 0.5, -handleSize/2) -- 初始在轨道左端
handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
handle.BorderSizePixel = 0
handle.Text = ""
handle.AutoButtonColor = false -- 防止按下时变色
handle.Parent = track
-- 拖动按钮添加圆角
local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = handle
-- 创建数值显示标签
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(0, 50, 0, 50)
valueLabel.Position = UDim2.new(0, 240, 0.2, 0)
valueLabel.BackgroundTransparency = 1
valueLabel.Text = tostring(defaultValue)
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.TextScaled = true
valueLabel.Font = Enum.Font.SourceSansBold
valueLabel.Parent = Combat_features

-- 透视功能内容
local X_ray_features = Instance.new("ScrollingFrame")
X_ray_features.Size = UDim2.new(0.81, -1, 1, 0)
X_ray_features.Position = UDim2.new(0.19, 1, 0, 0)
X_ray_features.BackgroundTransparency = 0.6
X_ray_features.BorderSizePixel = 0                   -- 描边粗细
X_ray_features.ScrollingEnabled = true               -- 允许滚动
X_ray_features.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
X_ray_features.ScrollBarThickness = 1                -- 滚动条粗细
X_ray_features.Visible = false                       -- 隐藏（true = 不隐藏）（false = 隐藏）
X_ray_features.Parent = Title
-- 透视测试
local Perspective_Test = Instance.new("TextLabel")
Perspective_Test.Size = UDim2.new(0.3, 0, 0.2, 0)
Perspective_Test.Position = UDim2.new(0, 0, 0, 0)
Perspective_Test.Text = "=== 透视 ==="
Perspective_Test.BackgroundTransparency = 1
Perspective_Test.Parent = X_ray_features

-- 高级功能内容
local Advanced_features = Instance.new("ScrollingFrame")
Advanced_features.Size = UDim2.new(0.81, -1, 1, 0)
Advanced_features.Position = UDim2.new(0.19, 1, 0, 0)
Advanced_features.BackgroundTransparency = 0.6
Advanced_features.BorderSizePixel = 0                   -- 描边粗细
Advanced_features.ScrollingEnabled = true               -- 允许滚动
Advanced_features.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
Advanced_features.ScrollBarThickness = 1                -- 滚动条粗细
Advanced_features.Visible = false                       -- 隐藏（true = 不隐藏）（false = 隐藏）
Advanced_features.Parent = Title
-- 高级测试
local Advanced_Test = Instance.new("TextLabel")
Advanced_Test.Size = UDim2.new(0.3, 0, 0.2, 0)
Advanced_Test.Position = UDim2.new(0, 0, 0, 0)
Advanced_Test.Text = "=== 高级 ==="
Advanced_Test.BackgroundTransparency = 1
Advanced_Test.Parent = Advanced_features

-- 设置功能内容
local Settings_features = Instance.new("ScrollingFrame")
Settings_features.Size = UDim2.new(0.81, -1, 1, 0)
Settings_features.Position = UDim2.new(0.19, 1, 0, 0)
Settings_features.BackgroundTransparency = 0.6
Settings_features.BorderSizePixel = 0                   -- 描边粗细
Settings_features.ScrollingEnabled = true               -- 允许滚动
Settings_features.CanvasSize = UDim2.new(0, 0, 1, 16)  -- 内容总高度
Settings_features.ScrollBarThickness = 1                -- 滚动条粗细
Settings_features.Visible = false                       -- 隐藏（true = 不隐藏）（false = 隐藏）
Settings_features.Parent = Title
-- 设置测试
local Set_up_the_test = Instance.new("TextLabel")
Set_up_the_test.Size = UDim2.new(0.3, 0, 0.2, 0)
Set_up_the_test.Position = UDim2.new(0, 0, 0, 0)
Set_up_the_test.Text = "=== 设置 ==="
Set_up_the_test.BackgroundTransparency = 1
Set_up_the_test.Parent = Settings_features

-- ======================================== 折叠展开按钮 ========================================
local Toggle_button = Instance.new("TextButton")
Toggle_button.Size = UDim2.new(0, 50, 0, 40)
Toggle_button.Position = UDim2.new(0.45, 0, 0, -60)
Toggle_button.Text = "关"
Toggle_button.BorderSizePixel = 0
Toggle_button.TextSize = 20 -- 文字大小
Toggle_button.BackgroundColor3 = Color3.fromRGB(20, 25, 50)
Toggle_button.Font = Enum.Font.GothamBold
Toggle_button.Parent = ScreenGui

-- 圆角
local Collapse_Expand_Corner = Instance.new("UICorner")
Collapse_Expand_Corner.CornerRadius = UDim.new(0.05, 0)
Collapse_Expand_Corner.Parent = Toggle_button

-- 描边
local Collapse_Expand_Stroke = Instance.new("UIStroke")
Collapse_Expand_Stroke.Thickness = 1
Collapse_Expand_Stroke.Parent = Toggle_button

-- ==================== Toast 消息系统 ====================
local TOAST_W, TOAST_H = 230, 44          -- Toast 宽度和高度（像素）
local TOAST_GAP = 6                        -- Toast 之间的间距
local TOAST_HOLD = 1.8                     -- 显示持续时间（秒）
local TOAST_FADE = 0.60                    -- 淡入淡出持续时间
local MAX_TOAST = 4                        -- 最大同时显示的 Toast 数量

-- 创建 Toast 容器（位于屏幕右下角）
local ToastContainer = Instance.new("Frame")
ToastContainer.Name = "ToastContainer"
ToastContainer.Size = UDim2.new(0, TOAST_W, 0, 0)        -- 宽度固定，高度自动
ToastContainer.Position = UDim2.new(1, -16, 1, -16)      -- 右下角，距边缘16像素
ToastContainer.AnchorPoint = Vector2.new(1, 1)           -- 锚点在右下角
ToastContainer.BackgroundTransparency = 1
ToastContainer.ZIndex = 100
ToastContainer.Parent = ScreenGui

-- 使用 UIListLayout 自动排列 Toast（从下往上？但 SortOrder 为 LayoutOrder 默认从上到下，但 AnchorPoint 在右下角，所以实际从下往上排列）
local ToastList = Instance.new("UIListLayout")
ToastList.SortOrder = Enum.SortOrder.LayoutOrder         -- 按 LayoutOrder 排序
ToastList.Padding = UDim.new(0, TOAST_GAP)               -- 间距
ToastList.HorizontalAlignment = Enum.HorizontalAlignment.Right -- 右对齐
ToastList.Parent = ToastContainer

-- 当内容尺寸变化时，自动调整容器高度
ToastList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ToastContainer.Size = UDim2.new(0, TOAST_W, 0, ToastList.AbsoluteContentSize.Y)
end)

-- 创建单个 Toast（内部函数）
local function CreateToast(message)
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, TOAST_W, 0, 0)              -- 高度为0，通过动画展开
	toast.BackgroundTransparency = 1
	toast.ClipsDescendants = true                         -- 裁剪子元素，防止溢出
	toast.Parent = ToastContainer

	-- 渐变色背景
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(Color3.fromRGB(255, 215, 90), Color3.fromRGB(235, 170, 40))
	gradient.Rotation = 90
	gradient.Parent = toast

	-- 圆角
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toast

	-- 描边
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(180, 130, 20)
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = toast

	-- 图标（💡）
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 28, 1, 0)
	icon.Position = UDim2.new(0, 8, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = "💡"
	icon.TextSize = 18
	icon.Font = Enum.Font.GothamMedium
	icon.TextWrapped = true
	icon.Parent = toast

	-- 文本内容
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -40, 1, 0)
	text.Position = UDim2.new(0, 40, 0, 0)
	text.BackgroundTransparency = 1
	text.Text = message
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextSize = 14
	text.Font = Enum.Font.GothamBold
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextStrokeTransparency = 0.4
	text.TextStrokeColor3 = Color3.fromRGB(120, 80, 0)
	text.Parent = toast

	-- 动画控制：展开 -> 等待 -> 收起 -> 销毁
	task.spawn(function()
		-- 展开（高度从0到TOAST_H，透明度从1到0）
		local expand = TweenService:Create(toast, TweenInfo.new(TOAST_FADE, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, TOAST_W, 0, TOAST_H),
			BackgroundTransparency = 0
		})
		expand:Play()
		expand.Completed:Wait()

		task.wait(TOAST_HOLD)  -- 保持显示

		-- 收起
		local collapse = TweenService:Create(toast, TweenInfo.new(TOAST_FADE, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, TOAST_W, 0, 0),
			BackgroundTransparency = 1
		})
		collapse:Play()
		collapse.Completed:Wait()

		toast:Destroy()  -- 移除
	end)

	return toast
end

-- 对外暴露的 ShowToast 函数
function ShowToast(message)
	-- 获取当前所有 Toast（只统计 Frame 类型）
	local children = ToastContainer:GetChildren()
	local toasts = {}
	for _, child in ipairs(children) do
		if child:IsA("Frame") and child ~= ToastContainer then
			table.insert(toasts, child)
		end
	end
	-- 如果超过最大数量，移除最早的
	if #toasts >= MAX_TOAST then
		toasts[1]:Destroy()
	end
	-- 创建新 Toast
	CreateToast(message)
end

-- ======================================== 彩色循环函数 ========================================
-- 彩色循环
RunService.Heartbeat:Connect(function(deltaTime)
    local hue = (tick() * 0.2) % 1
    VFX_Tracking_Stroke.Color = Color3.fromHSV(hue, 1, 1)
    Collapse_Expand_Stroke.Color = Color3.fromHSV(hue, 1, 1)
end)

-- ======================================== 特效跟踪动画函数 ========================================
-- 实现特效跟踪动画函数
local function special_effects_animation(y)
    local animation = TweenService:Create(VFX_Tracking, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 5, 0, y)
	})
	animation:Play()
end

-- ======================================== 滑块核心代码 ========================================
-- 辅助函数：根据值更新填充条和手柄位置
local function updateSlider(value)
    -- 限制值在最小值和最大值之间
    value = math.clamp(value, minValue, maxValue)
    
    -- 计算比例（0 到 1）
    local ratio = (value - minValue) / (maxValue - minValue)
    
    -- 更新填充条宽度
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    
    -- 更新手柄位置
    -- 手柄中心应该在轨道左端 + ratio * (轨道宽度 - 手柄宽度)
    local handleX = ratio * (sliderWidth - handleSize)
    handle.Position = UDim2.new(0, handleX, 0.5, -handleSize/2)
    
    -- 更新数值显示
    valueLabel.Text = tostring(math.floor(value))
    Aimbot.Fov = tostring(math.floor(value)) -- 滑块修改自瞄FOV范围
end

-- 初始化滑块为默认值
updateSlider(defaultValue)

-- 处理拖动事件
local dragging = false

handle.MouseButton1Down:Connect(function()
    dragging = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    dragging = false
end)

mouse.Move:Connect(function()
    if dragging then
        -- 获取鼠标在轨道坐标系中的 X 位置
        local mouseX = mouse.X
        local trackAbsolutePos = track.AbsolutePosition.X
        local trackAbsoluteSize = track.AbsoluteSize.X
        
        -- 计算相对于轨道左端的偏移
        local relativeX = mouseX - trackAbsolutePos
        -- 限制在轨道范围内（考虑手柄宽度，让手柄不超出轨道）
        local clampedX = math.clamp(relativeX, 0, trackAbsoluteSize - handleSize)
        
        -- 计算比例
        local ratio = clampedX / (trackAbsoluteSize - handleSize)
        -- 转换为实际值
        local newValue = minValue + ratio * (maxValue - minValue)
        
        updateSlider(newValue)
    end
end)

-- ======================================== 功能内容切换逻辑 ========================================
-- 功能内容切换逻辑函数
local function Feature_Content_Toggle_Logic(Homepage_features1, Combat_features2, X_ray_features3, Advanced_features4, Settings_features5)
    Homepage_features.Visible = Homepage_features1
    Combat_features.Visible = Combat_features2
    X_ray_features.Visible = X_ray_features3
    Advanced_features.Visible = Advanced_features4
    Settings_features.Visible = Settings_features5
end

-- 按钮事件链接
-- 主页类按钮事件
Home_button.MouseButton1Click:Connect(function()
    Feature_Content_Toggle_Logic(true, false, false, false, false)
    special_effects_animation(5)
end)

-- 战斗类按钮事件
Combat_button.MouseButton1Click:Connect(function()
    Feature_Content_Toggle_Logic(false, true, false, false, false)
	special_effects_animation(57)
end)

-- 透视类按钮事件
Perspective_button.MouseButton1Click:Connect(function()
    Feature_Content_Toggle_Logic(false, false, true, false, false)
	special_effects_animation(109)
end)

-- 高级类按钮事件
Advanced_button.MouseButton1Click:Connect(function()
    Feature_Content_Toggle_Logic(false, false, false, true, false)
	special_effects_animation(161)
end)

-- 设置类按钮事件
Settings_button.MouseButton1Click:Connect(function()
    Feature_Content_Toggle_Logic(false, false, false, false, true)
	special_effects_animation(213)
end)

-- ======================================== 折叠展开逻辑 ========================================
-- 折叠展开按钮事件
local Toggle_state = true -- 折叠展开状态（false = 折叠 / true = 展开）
Toggle_button.MouseButton1Click:Connect(function()
    Toggle_state = not Toggle_state
    if Toggle_state then
        Toggle_button.Text = "关"
        local Expand = TweenService:Create(MainFrame, TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		    Position = UDim2.new(0.25, 0, 0.05, 0)
	    })
	    Expand:Play()
    else
        Toggle_button.Text = "开"
        local Collapse = TweenService:Create(MainFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		    Position = UDim2.new(0.25, 0, 0, -300)
	    })
	    Collapse:Play()
    end
end)

-- ======================================== 功能按钮逻辑 ========================================
-- 按钮动画（开启 / 关闭）逻辑函数
-- 按钮开启动画函数
local function Start_animation(Fill_bar_object_name, Sphere_object_name) -- （Fill_bar_object_name = 填充条对象名 / Sphere_object_name = 圆球对象名）
    -- 填充条
    local Start_Progress_bar = TweenService:Create(Fill_bar_object_name, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	    Size = UDim2.new(1, 0, 1, 0)
	})
	-- 圆球
	local Start_Ball = TweenService:Create(Sphere_object_name, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	    Position = UDim2.new(0.62, 0, 0, 0)
	})
	Start_Progress_bar:Play()
	Start_Ball:Play()
end

-- 按钮关闭动画函数
local function Stop_animation(Fill_bar_object_name, Sphere_object_name) -- （Fill_bar_object_name = 填充条对象名 / Sphere_object_name = 圆球对象名）
    -- 填充条
    local Start_Progress_bar = TweenService:Create(Fill_bar_object_name, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	    Size = UDim2.new(0.38, 0, 1, 0)
	})
	-- 圆球
	local Start_Ball = TweenService:Create(Sphere_object_name, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	    Position = UDim2.new(0, 0, 0, 0)
	})
	Start_Progress_bar:Play()
	Start_Ball:Play()
end

-- 自瞄功能
local Auto_aim_status = false -- false = 关闭 / true = 开启
aimbot.MouseButton1Click:Connect(function()
    Auto_aim_status = not Auto_aim_status
    if Auto_aim_status then
        Start_animation(Aimbot_Fill_Bar, Aimbot_Sphere)
        Aimbot:toggle() -- 开启自瞄
        ShowToast("自瞄已开启¤")
    else
        Stop_animation(Aimbot_Fill_Bar, Aimbot_Sphere)
        Aimbot:toggle() -- 关闭自瞄
        ShowToast("自瞄已关闭¤")
    end
end)


-- ========================================  ========================================