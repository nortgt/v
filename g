--// GABS HUB | WindUI Complete //--
-- Criado por GONER 😎
-- Script pronto para copiar/colar em um executor compatível (WindUI)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/WindUI.lua"))()
workspace.FallenPartsDestroyHeight = -math.huge

local Window = WindUI:MakeWindow({
    Title = "Gabs Hub | Brookhaven RP",
    SubTitle = "by: GONER",
    LoadText = "Carregando Gabs Hub",
    Config = "GabsHub_Brookhaven"
})
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://139276358786261", BackgroundTransparency = 1 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- ================= INFO TAB =================
local InfoTab = Window:MakeTab({ Title = "Info", Icon = "rbxassetid://15309138473" })
InfoTab:AddSection({ Title = "Informações do Script" })
InfoTab:AddParagraph({ Title = "Owner / Developer:", Content = "GONER" })
InfoTab:AddParagraph({ Title = "Vocês estão usando:", Content = "Gabs Hub Brookhaven" })
InfoTab:AddParagraph({ Title = "Versão:", Content = "1.0" })
InfoTab:AddParagraph({ Title = "Your executor:", Content = "Detectando..." })

-- Rejoin
InfoTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
    end
})

-- Discord Invite (exemplo)
InfoTab:AddDiscordInvite({
    Name = "Gabs Hub | Discord",
    Description = "discord.gg/xxxxx",
    Logo = "rbxassetid://89957678433585",
    Invite = "https://discord.gg/xxxxx",
})

-- detect executor and update paragraph
local function detectExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif is_sirhurt_closure then
        return "SirHurt"
    elseif pebc_execute then
        return "ProtoSmasher"
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Executor Desconhecido"
    end
end

spawn(function()
    task.wait(0.8)
    local execName = detectExecutor()
    InfoTab:AddParagraph({ Title = "Executor Detectado:", Content = execName })
end)

-- ================= PLAYER TAB =================
local PlayerTab = Window:MakeTab({ Title = "Player", Icon = "rbxassetid://6023426915" })
local selectedPlayerName = nil
local headsitActive = false
local InfiniteJumpEnabled = false
local antiSitEnabled = false
local antiSitConnection = nil

-- helper: find player by part of name
local function findPlayerByPartialName(partial)
    if not partial then return nil end
    partial = partial:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Name:lower():sub(1, #partial) == partial then
            return p
        end
    end
    return nil
end

-- notify
local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
    end)
end

-- select player textbox
PlayerTab:AddTextBox({
    Name = "Nome do Jogador",
    Description = "Digite parte do nome",
    PlaceholderText = "ex: Void",
    Callback = function(Value)
        local p = findPlayerByPartialName(Value)
        if p then
            selectedPlayerName = p.Name
            Notify("Selecionado", p.Name .. " selecionado")
        else
            Notify("Erro", "Nenhum jogador encontrado")
        end
    end
})

-- headsit functions
local function headsitOnPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    if not hrp or not targetHead then return false end

    -- remove existing welds
    for _, v in pairs(hrp:GetChildren()) do if v:IsA("WeldConstraint") then v:Destroy() end end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = targetHead
    weld.Parent = hrp

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = true end
    return true
end

local function removeHeadsit()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do if v:IsA("WeldConstraint") then v:Destroy() end end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = false end
end

PlayerTab:AddButton({
    Name = "Headsit On/Off",
    Callback = function()
        if not selectedPlayerName then Notify("Erro", "Nenhum jogador selecionado") return end
        local target = Players:FindFirstChild(selectedPlayerName)
        if not headsitActive then
            if headsitOnPlayer(target) then headsitActive = true Notify("Headsit", "Ativado em " .. selectedPlayerName) end
        else
            removeHeadsit()
            headsitActive = false
            Notify("Headsit", "Desativado")
        end
    end
})

-- speed/jump/gravity sliders
PlayerTab:AddSlider({ Name = "Speed Player", Increase = 1, MinValue = 16, MaxValue = 888, Default = 16, Callback = function(Value)
    local char = localPlayer.Character
    if char then local h = char:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = Value end end
end })

PlayerTab:AddSlider({ Name = "Jump Power", Increase = 1, MinValue = 50, MaxValue = 500, Default = 50, Callback = function(Value)
    local char = localPlayer.Character
    if char then local h = char:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = Value end end
end })

PlayerTab:AddSlider({ Name = "Gravity", Increase = 1, MinValue = 0, MaxValue = 10000, Default = 196.2, Callback = function(Value)
    workspace.Gravity = Value
end })

-- reset button
PlayerTab:AddButton({ Name = "Reset Speed/Jump/Gravity", Callback = function()
    local char = localPlayer.Character
    if char then local h = char:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 h.JumpPower = 50 end end
    workspace.Gravity = 196.2
    InfiniteJumpEnabled = false
    Notify("Reset", "Valores restabelecidos")
end })

-- infinite jump toggle
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) InfiniteJumpEnabled = Value end })

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- anti-sit
PlayerTab:AddToggle({ Name = "Anti-Sit", Default = false, Callback = function(state)
    antiSitEnabled = state
    if state then
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.Sit = false
            h:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            if antiSitConnection then antiSitConnection:Disconnect() end
            antiSitConnection = h.Seated:Connect(function(isSeated)
                if isSeated then h.Sit = false h:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end)
        end
        Notify("Anti-Sit", "Ativado")
    else
        if antiSitConnection then antiSitConnection:Disconnect() antiSitConnection = nil end
        Notify("Anti-Sit", "Desativado")
    end
end })

-- ================= MUSIC TAB =================
local MusicTab = Window:MakeTab({ Title = "Music", Icon = "rbxassetid://6026663699" })
local music = Instance.new("Sound", workspace)
music.Name = "GabsHubMusic"
local musicList = {
    { Name = "Believer - Imagine Dragons", ID = "3678859271" },
    { Name = "Stay - The Kid LAROI & Justin Bieber", ID = "7263442258" },
    { Name = "Enemy - Imagine Dragons", ID = "8446565835" },
    { Name = "Industry Baby - Lil Nas X", ID = "7253841620" },
    { Name = "Bones - Imagine Dragons", ID = "8406785943" },
}

MusicTab:AddButton({ Name = "Stop Music", Callback = function() music:Stop() Notify("Music", "Parado") end })
for _, s in ipairs(musicList) do
    MusicTab:AddButton({ Name = s.Name, Callback = function()
        music.SoundId = "rbxassetid://" .. s.ID
        music.Volume = 5
        music.Looped = true
        music:Play()
        Notify("Music", "Tocando: " .. s.Name)
    end })
end

-- ================= TROLL TAB =================
local TrollTab = Window:MakeTab({ Title = "Troll Players", Icon = "rbxassetid://6447748947" })
TrollTab:AddButton({ Name = "Fling Player", Callback = function()
    if not selectedPlayerName then Notify("Erro", "Nenhum jogador selecionado") return end
    local target = Players:FindFirstChild(selectedPlayerName)
    if target and target.Character and localPlayer.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,500,0) Notify("Troll", "Fling aplicado em "..target.Name) end
    end
end })

TrollTab:AddButton({ Name = "Por Kill Player", Callback = function()
    if not selectedPlayerName then Notify("Erro", "Nenhum jogador selecionado") return end
    local target = Players:FindFirstChild(selectedPlayerName)
    if target and target.Character then
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 Notify("Troll", "Kill aplicado em "..target.Name) end
    end
end })

-- ================= PROTECTION TAB =================
local ProtectionTab = Window:MakeTab({ Title = "Proteção (PD)", Icon = "rbxassetid://6026663699" })
local UltimateNoclip = { Enabled = false, Connections = {} }

local function managePlayerCollisions(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not UltimateNoclip.Enabled
            part.Anchored = false
        end
    end
end

local function voidProtection(rootPart)
    if rootPart and rootPart.Position.Y < -500 then
        rootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

ProtectionTab:AddToggle({ Name = "Ultimate Noclip + Void Protection", Default = false, Callback = function(state)
    UltimateNoclip.Enabled = state
    if state then
        UltimateNoclip.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
            local char = localPlayer.Character
            if char then
                managePlayerCollisions(char)
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if rootPart then voidProtection(rootPart) end
            end
        end)
        Notify("Proteção", "Ultimate Noclip ativado")
    else
        for _, c in pairs(UltimateNoclip.Connections) do pcall(function() c:Disconnect() end) end
        UltimateNoclip.Connections = {}
        if localPlayer.Character then managePlayerCollisions(localPlayer.Character) end
        Notify("Proteção", "Ultimate Noclip desativado")
    end
end })

-- ================= TELEPORT TAB =================
local TeleportTab = Window:MakeTab({ Title = "Teleportes", Icon = "rbxassetid://6076260610" })
local teleportLocations = {
    ["Casa Principal"] = CFrame.new(-101,5,42),
    ["Loja"] = CFrame.new(-8,5,-33),
    ["Banco"] = CFrame.new(162,5,-12),
    ["Polícia"] = CFrame.new(101,5,23),
    ["Hospital"] = CFrame.new(64,5,-15),
    ["Supermercado"] = CFrame.new(-18,5,-60),
    ["Praia"] = CFrame.new(300,5,0),
    ["Shopping"] = CFrame.new(200,5,100),
    ["Escola"] = CFrame.new(25,5,200),
}

for name, cf in pairs(teleportLocations) do
    TeleportTab:AddButton({ Name = name, Callback = function()
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = cf Notify("Teleporte", "Indo para "..name) end
    end })
end

-- Final
Notify("Gabs Hub", "Carregado com sucesso! Criador: GONER")
