local LocalPlayer = game.Players.LocalPlayer

pcall(function() LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Hexagon"):Destroy() end)

local Blur = Instance.new("BlurEffect", game.Lighting)
Blur.Size = 20

local function newGradient(parent)
	local Gradient = Instance.new("UIGradient")
	Gradient.Parent = parent
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 150, 230)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 110, 225))
	}
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "Hexagon"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Background = Instance.new("Frame")
Background.Parent = ScreenGui
Background.Size = UDim2.new(0, 380, 0, 190)
Background.Position = UDim2.new(0.28, 0, 0.28, 0)
Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
newGradient(Background)

local bgCorner = Instance.new("UICorner")
bgCorner.Parent = Background
bgCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = Background
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, -20)
Title.BackgroundTransparency = 1
Title.Text = "HEXAGON"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
newGradient(Title)

local Desc = Instance.new("TextLabel")
Desc.Parent = Background
Desc.Size = UDim2.new(1, 0, 1, 0)
Desc.Position = UDim2.new(0, 0, 0, 5)
Desc.BackgroundTransparency = 1
Desc.Text = "by Roun95"
Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
Desc.Font = Enum.Font.Gotham
Desc.TextSize = 16

local messages = {
	"by Roun95",
	"Loading assets...",
	"Optimizing scripts...",
	"Finalizing setup..."
}

task.spawn(function()
	while ScreenGui do
		for _, msg in ipairs(messages) do
			Desc.Text = msg
			task.wait(2)
		end
	end
end)

local BarContainer = Instance.new("Frame")
BarContainer.Parent = Background
BarContainer.Position = UDim2.new(0, 20, 1, -30)
BarContainer.Size = UDim2.new(1, -40, 0, 6)
BarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BarContainer.BorderSizePixel = 0

local BarContainerCorner = Instance.new("UICorner")
BarContainerCorner.Parent = BarContainer
BarContainerCorner.CornerRadius = UDim.new(0.5,0)

local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = BarContainer
ProgressBar.Position = UDim2.new(0, 0, 0, 0)
ProgressBar.Size = UDim2.new(0, 0, 0, 6)
ProgressBar.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
ProgressBar.BorderSizePixel = 0
newGradient(ProgressBar)

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.Parent = ProgressBar
ProgressCorner.CornerRadius = UDim.new(0.5,0)

local PercentText = Instance.new("TextLabel")
PercentText.Parent = Background
PercentText.Size = UDim2.new(1, 0, 1, 0)
PercentText.Position = UDim2.new(0, 0, 0, 50)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = Color3.fromRGB(150, 150, 150)
PercentText.Font = Enum.Font.Gotham
PercentText.TextSize = 12

local totalTime = 6.5 -- Seconds
local steps = 100
local delayPerStep = totalTime / steps

for i = 1, steps do
    ProgressBar.Size = UDim2.new(i/steps, 0, 0, 6)
    PercentText.Text = i .. "%"
    wait(delayPerStep)
end

PercentText.Text = "100%"
Desc.Text = "Done!"

task.wait(0.5)
ScreenGui:Destroy()
Blur:Destroy()
