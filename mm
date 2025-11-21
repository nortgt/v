-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Variáveis
local savedPosition = nil
local teleportLoop = false
local speedLoop = false
local noclipEnabled = false
local loopDelay = 0.05
local soundsEnabled = true

-- Gui
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "👾painel pixel👾"

-- Janela principal
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 210)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false
Frame.ClipsDescendants = true
Frame.BackgroundTransparency = 0

-- Cantos arredondados
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 16)

-- Borda RGB
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 3

task.spawn(function()
	while true do
		for hue = 0, 1, 0.01 do
			UIStroke.Color = Color3.fromHSV(hue, 1, 1)
			task.wait(0.05)
		end
	end
end)

-- Botão de abrir/fechar
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Menu"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local function playSound()
	if soundsEnabled then
		local sound = Instance.new("Sound", LocalPlayer:WaitForChild("PlayerGui"))
		sound.SoundId = "rbxassetid://452267918"
		sound:Play()
		game:GetService("Debris"):AddItem(sound, 2)
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	playSound()
	if Frame.Visible then
		local tween = TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
		tween:Play()
		tween.Completed:Wait()
		Frame.Visible = false
	else
		Frame.Visible = true
		TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
	end
end)

-- Criador de botões
local function createButton(name, pos, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = pos
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.MouseButton1Click:Connect(function()
		playSound()
		callback()
	end)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

-- Speed Boost em loop
local speedButton = createButton("Speed Loop (120)", UDim2.new(0, 25, 0, 20), function()
	speedLoop = not speedLoop
	if speedLoop then
		task.spawn(function()
			while speedLoop do
				Humanoid.WalkSpeed = 120
				task.wait(0.1)
			end
		end)
	else
		Humanoid.WalkSpeed = 16
	end
end)

-- Copiar Posição
local copyButton = createButton("Copiar Posição", UDim2.new(0, 25, 0, 60), function()
	if HumanoidRootPart then
		savedPosition = HumanoidRootPart.Position
	end
end)

-- Teleportar
local tpButton = createButton("Teleporte", UDim2.new(0, 25, 0, 100), function()
	if savedPosition then
		HumanoidRootPart.CFrame = CFrame.new(savedPosition)
	end
end)

-- Toggle Loop Teleport
local loopButton = createButton("Loop Teleporte", UDim2.new(0, 25, 0, 140), function()
	teleportLoop = not teleportLoop
	if teleportLoop then
		task.spawn(function()
			while teleportLoop and savedPosition do
				HumanoidRootPart.CFrame = CFrame.new(savedPosition)
				playSound()
				task.wait(loopDelay)
			end
		end)
	end
end)

-- Toggle Noclip
local noclipButton = createButton("Noclip", UDim2.new(0, 25, 0, 180), function()
	noclipEnabled = not noclipEnabled
end)

-- Loop Noclip
RunService.Stepped:Connect(function()
	if noclipEnabled and Character then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)
