local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
local NoclipActived = false

-- Conectar CharacterAdded para atualizar Humanoid
LocalPlayer.CharacterAdded:Connect(function(character)
    Humanoid = character:WaitForChild("Humanoid")
end)

-- Webhook para log de execução
local WebhookURL = "https://discord.com/api/webhooks/1433989880525881375/I9QncYRuM98BYQ1V3G0cGWb3ydd1IFAIJY_AHfMGkaDmCbl3HUA-ZbHHEB_vaoxx0QHK"

local function ExecuteLog()
    local placeId = game.PlaceId
    local jobId = game.JobId
    local userId = LocalPlayer.UserId
    local dataHora = os.date("%d/%m/%Y %H:%M:%S")

    local thumbUrl = Players:GetUserThumbnailAsync(
        userId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )

    local data = {
        embeds = {{
            title = "🔧 An Administrator executed Hexagon Admin!",
            color = 16711680,  -- Vermelho para versão Devs
            thumbnail = { url = thumbUrl },
            fields = {
                {name = "📅 Date", value = dataHora, inline = false},
                {name = "🎮 Game", value = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name, inline = false},
                {name = "👤 Player", value = LocalPlayer.Name, inline = false},
                {name = "🆔 User ID", value = tostring(userId), inline = false},
                {name = "📝 Account Age", value = LocalPlayer.AccountAge, inline = false},
                {name = "🌎 Language", value = LocalPlayer.LocaleId, inline = false},
                {name = "🌎 Country", value = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(LocalPlayer), inline = false},
                {name = "💻 Executor", value = identifyexecutor and identifyexecutor() or "Unknown", inline = false},
                {name = "🌐 Server JobId", value = jobId, inline = false},
                {name = "📌 Teleport", value = "game:GetService(\"TeleportService\"):TeleportToPlaceInstance("..placeId..", \""..jobId.."\")", inline = false},
            }
        }}
    }

    local body = HttpService:JSONEncode(data)
    pcall(function()
        -- Assumindo que 'request' é uma função de exploit (ex: syn.request). Ajuste se necessário.
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
    end)
end

ExecuteLog()

local whitelistDev = {
    ["Roun95"] = true, -- Owner
    ["Deluxe_Studios"] = true, -- Co-Owner
    ["FuseRoX_52"] = true, -- Tester
}

if not whitelistDev[LocalPlayer.Name] then
    StarterGui:SetCore("SendNotification", {
        Title = "[Hexagon Admin]",
        Text = "[Access denied] " .. LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ") it is not authorized.",
        Duration = 5
    })
    return
end

-- Notificação de acesso Dev
StarterGui:SetCore("SendNotification", {
    Title = "[Hexagon Admin]",
    Text = "[Access permitted] " .. LocalPlayer.Name .. " it is authorized.",
    Duration = 4
})

-- Variáveis
local SelectedPlayer
local playerNames = {}
local originalSpeeds = {}
local controlledPlayers = {} -- Tabela para controlar jogadores controlados (agora com conexões RunService)
local controlConnections = {} -- Armazenar conexões de RunService para uncontrol

-- Função para enviar mensagens no chat (USANDO TEXTCHATSERVICE RBXGeneral)
local function SendCommand(msg)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = tcs:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
            if channel then
                channel:SendAsync(msg)  -- Envia diretamente para o chat via RBXGeneral
            end
        else
            -- Fallback para chat legacy
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)
end

-- Função de execução DIRETA via SelectedPlayer (para processamento de chat)
local function ExecutarAcao(action, targetPlayer)
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local targetChar = targetPlayer and targetPlayer.Character

    if action == "kick" and targetPlayer then
        pcall(function()
            targetPlayer:Kick("You've been kicked.")
        end)
        StarterGui:SetCore("SendNotification", {
            Title = "Kick Executed",
            Text = "Player " .. targetPlayer.Name .. " kicked!",
            Duration = 3
        })
    elseif action == "kill" and targetChar then
        pcall(function() targetChar:BreakJoints() end)
        StarterGui:SetCore("SendNotification", {
            Title = "Kill Executed",
            Text = "Player " .. targetPlayer.Name .. " dead!",
            Duration = 3
        })
    elseif action == "killplus" and targetChar then
        targetChar:BreakJoints()
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            for i = 1,5 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(6,6,6)
                part.Anchored = false
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.Random()
                part.CFrame = targetRoot.CFrame
                part.Parent = workspace
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-80,80), math.random(50,100), math.random(-80,80))
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Parent = part
                game:GetService("Debris"):AddItem(part, 3)
            end
            StarterGui:SetCore("SendNotification", {
                Title = "Kill Plus Executed",
                Text = "Player " .. targetPlayer.Name .. " dead with effect!",
                Duration = 3
            })
        end
    elseif action == "fling" and targetChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            TweenService:Create(targetRoot, TweenInfo.new(2), {CFrame = CFrame.new(99999, 999999, 99999)}):Play()
            StarterGui:SetCore("SendNotification", {
                Title = "Fling Executed",
                Text = "Player " .. targetPlayer.Name .. " launched!",
                Duration = 3
            })
        end
    elseif action == "freeze" and targetChar then
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetHum and targetRoot then
            originalSpeeds[targetPlayer.Name] = targetHum.WalkSpeed
            targetHum.WalkSpeed = 0
            targetRoot.Anchored = true
            StarterGui:SetCore("SendNotification", {
                Title = "Freeze Executed",
                Text = "Player " .. targetPlayer.Name .. " freeze!",
                Duration = 3
            })
        end
    elseif action == "unfreeze" and targetChar then
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetHum and targetRoot then
            targetHum.WalkSpeed = originalSpeeds[targetPlayer.Name] or 16
            targetRoot.Anchored = false
            originalSpeeds[targetPlayer.Name] = nil
            StarterGui:SetCore("SendNotification", {
                Title = "Unfreeze Executed",
                Text = "Player " .. targetPlayer.Name .. " unfreeze!",
                Duration = 3
            })
        end
    elseif action == "jail" and targetChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local existingCage = workspace:FindFirstChild(targetPlayer.Name .. "_Cage")
            if existingCage then existingCage:Destroy() end

            local cage = Instance.new("Model", workspace)
            cage.Name = targetPlayer.Name .. "_Cage"

            local rootPos = targetRoot.Position
            local size = Vector3.new(8,8,8)

            local function createPart(offset, sizePart)
                local part = Instance.new("Part")
                part.Size = sizePart
                part.Anchored = true
                part.CanCollide = true
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Really black")
                part.Transparency = 0.3
                part.CFrame = CFrame.new(rootPos + offset)
                part.Parent = cage
            end

            createPart(Vector3.new(0,size.Y/2,0), Vector3.new(size.X,1,size.Z))
            createPart(Vector3.new(0,-size.Y/2,0), Vector3.new(size.X,1,size.Z))
            createPart(Vector3.new(size.X/2,0,0), Vector3.new(1,size.Y,size.Z))
            createPart(Vector3.new(-size.X/2,0,0), Vector3.new(1,size.Y,size.Z))
            createPart(Vector3.new(0,0,size.Z/2), Vector3.new(size.X,size.Y,1))
            createPart(Vector3.new(0,0,-size.Z/2), Vector3.new(size.X,size.Y,1))

            task.spawn(function()
                while cage.Parent and targetRoot.Parent do
                    local cagePos = cage:GetBoundingBox().Position
                    if (targetRoot.Position - cagePos).Magnitude > size.X/2 then
                        targetRoot.CFrame = CFrame.new(cagePos)
                    end
                    task.wait(0.1)
                end
            end)

            StarterGui:SetCore("SendNotification", {
                Title = "Jail Executed",
                Text = "Player " .. targetPlayer.Name .. " jailed!",
                Duration = 3
            })
        end
    elseif action == "unjail" and targetPlayer then
        local cage = workspace:FindFirstChild(targetPlayer.Name .. "_Cage")
        if cage then
            cage:Destroy()
            StarterGui:SetCore("SendNotification", {
                Title = "Unjail Executed",
                Text = "Jail removed for " .. targetPlayer.Name,
                Duration = 3
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "[Failed]",
                Text = "Jail not found for " .. targetPlayer.Name,
                Duration = 3
            })
        end
    elseif action == "bring" and targetChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if targetRoot and root then
            targetRoot.CFrame = root.CFrame * CFrame.new(2,0,0)
            StarterGui:SetCore("SendNotification", {
                Title = "Bring Executed",
                Text = "Player " .. targetPlayer.Name .. " brought!",
                Duration = 3
            })
        end
    elseif action == "control" and targetChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local myRoot = root
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local myHum = humanoid

        -- RANK CHECKER
        if not whitelistDev[LocalPlayer.Name] then
            StarterGui:SetCore("SendNotification", {
                Title = "Access denied",
                Text = "Control Player Exclusive for Hexagon Devs!",
                Duration = 3
            })
            return
        end

        if targetRoot and myRoot and targetHum and myHum then
            -- Remover controle anterior se existir
            if controlledPlayers[targetPlayer.Name] then
                controlledPlayers[targetPlayer.Name]:Destroy()
                if controlConnections[targetPlayer.Name] then
                    controlConnections[targetPlayer.Name]:Disconnect()
                    controlConnections[targetPlayer.Name] = nil
                end
            end

            -- Desabilitar controles do alvo
            targetHum.PlatformStand = true

            -- Criar BodyVelocity para seguir o movimento do joystick/local player
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            bodyVel.Parent = targetRoot

            -- Conexão RunService para copiar movimento do joystick (MoveDirection)
            local connection = RunService.Heartbeat:Connect(function()
                if myHum and targetRoot and targetRoot.Parent then
                    -- Copia direção de movimento do local player (joystick/WASD)
                    local moveDir = myHum.MoveDirection * myHum.WalkSpeed
                    -- Adiciona componente Y para pular se local pular
                    if myHum.Jump then
                        moveDir = moveDir + Vector3.new(0, myHum.JumpPower, 0)
                    end
                    bodyVel.Velocity = moveDir

                    -- Opcional: Copia rotação do local player
                    targetRoot.CFrame = CFrame.lookAt(targetRoot.Position, targetRoot.Position + myHum.MoveDirection)
                else
                    connection:Disconnect()
                end
            end)

            controlledPlayers[targetPlayer.Name] = bodyVel
            controlConnections[targetPlayer.Name] = connection

            StarterGui:SetCore("SendNotification", {
                Title = "Control Executed (Joystick)",
                Text = "Control " .. targetPlayer.Name .. " via joystick! (Exclusive Hexagon Devs)",
                Duration = 3
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "[Failed]",
                Text = "HumanoidRootPart or Humanoid not found!",
                Duration = 3
            })
        end
    elseif action == "uncontrol" and targetPlayer then
        local targetChar = targetPlayer.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

        if controlledPlayers[targetPlayer.Name] then
            controlledPlayers[targetPlayer.Name]:Destroy()
            controlledPlayers[targetPlayer.Name] = nil

            if controlConnections[targetPlayer.Name] then
                controlConnections[targetPlayer.Name]:Disconnect()
                controlConnections[targetPlayer.Name] = nil
            end

            if targetHum then
                targetHum.PlatformStand = false
            end

            StarterGui:SetCore("SendNotification", {
                Title = "Uncontrol Executed",
                Text = "Stop control in " .. targetPlayer.Name .. "!",
                Duration = 3
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "[Failed]",
                Text = targetPlayer.Name .. " it could not be controlled!",
                Duration = 3
            })
        end
    end
end

-- Função de execução de comandos MANUAIS via Chat (COM FALLBACK PARA SELECTEDPLAYER)
local function ExecutarComando(msgText)
    -- Parsear comando: ;cmd (sem target) OU ;cmd targetname
    local cmd = msgText:match("^;(%w+)$")  -- Sem target
    local targetName = nil
    if not cmd then
        cmd, targetName = msgText:match("^;(%w+)%s+(%w+)$")  -- Com target
    end

    if not cmd then
        return  -- Ignora se não for formato válido
    end

    local targetPlayer
    if targetName then
        targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer then
            StarterGui:SetCore("SendNotification", {
                Title = "[Failed]",
                Text = "Player '" .. targetName .. "' not found!",
                Duration = 3
            })
            return
        end
    elseif SelectedPlayer then
        targetPlayer = SelectedPlayer  -- Fallback para SelectedPlayer
        StarterGui:SetCore("SendNotification", {
            Title = "[Info]",
            Text = "Used SelectedPlayer: " .. SelectedPlayer.Name,
            Duration = 2
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "[Failed]",
            Text = "None SelectedPlayer defined in the command target!",
            Duration = 3
        })
        return
    end

    ExecutarAcao(cmd, targetPlayer)  -- Reusa a função direta!
end

-- Conexões de chat (USANDO TEXTCHATSERVICE RBXGeneral PARA RECEBER E ENVIAR)
local tcs = game:GetService("TextChatService")
if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
    local generalChannel = tcs:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
    generalChannel.MessageReceived:Connect(function(message)
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        if player and player == LocalPlayer and message.Text:lower():sub(1,1) == ";" then  -- Só processa comandos do local player
            ExecutarComando(message.Text:lower())
        end
    end)
else
    -- Fallback para chat legacy
    ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering:Connect(function(message)
        local speaker = Players:FindFirstChild(message.FromSpeaker)
        if speaker and speaker == LocalPlayer and message.Message:lower():sub(1,1) == ";" then
            ExecutarComando(message.Message:lower())
        end
    end)
end

-- Lista inicial de jogadores
for _, player in pairs(Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

-- Interface WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Hexagon Admin (Early Access)",
    Icon = "rbxassetid://103422693243379",
    Author = "by Nova",
    Size = UDim2.fromOffset(600, 480),
    Transparent = true,
    Theme = "Midnight", -- Dev theme
    Resizable = true,
})

local Section1 = Window:Section({Title = "Admin Panel", Icon = "code", Opened = true})
local Tab1 = Section1:Tab({Title = "Dev Functions", Icon = "hammer", Locked = false})
local Section2 = Tab1:Section({Title = "Commands via Chat (RBXGeneral)", Icon = "album", Opened = true})

local PlayersDD = Section2:Dropdown({
    Title = "Players (SelectedPlayer)",
    Values = playerNames,
    Value = playerNames[1],
    Callback = function(option)
        SelectedPlayer = Players:FindFirstChild(option)
    end
})

Players.PlayerAdded:Connect(function(player)
    table.insert(playerNames, player.Name)
    PlayersDD:Refresh(playerNames)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in pairs(playerNames) do
        if name == player.Name then
            table.remove(playerNames, i)
            break
        end
    end
    PlayersDD:Refresh(playerNames)
end)

-- Botões de comando (ENVIA PARA O CHAT VIA RBXGeneral USANDO SELECTEDPLAYER)
local commands = {
    {Title = "Kick", Desc = "Send ;kick [SelectedPlayer] in chat", Cmd = ";kick"},
    {Title = "Kill", Desc = "Send ;kill [SelectedPlayer] in chat", Cmd = ";kill"},
    {Title = "Kill Plus", Desc = "Send ;killplus [SelectedPlayer] in chat", Cmd = ";killplus"},
    {Title = "Fling", Desc = "Send ;fling [SelectedPlayer] in chat", Cmd = ";fling"},
    {Title = "Freeze", Desc = "Send ;freeze [SelectedPlayer] in chat", Cmd = ";freeze"},
    {Title = "Unfreeze", Desc = "Send ;unfreeze [SelectedPlayer] in chat", Cmd = ";unfreeze"},
    {Title = "Jail", Desc = "Send ;jail [SelectedPlayer] in chat", Cmd = ";jail"},
    {Title = "Unjail", Desc = "Send ;unjail [SelectedPlayer] in chat", Cmd = ";unjail"},
    {Title = "Bring", Desc = "Send ;bring [SelectedPlayer] in chat", Cmd = ";bring"},
    {Title = "Control Player (Joystick)", Desc = "Send ;control [SelectedPlayer] in chat", Cmd = ";control"},
    {Title = "Uncontrol Player", Desc = "Send ;uncontrol [SelectedPlayer] in chat", Cmd = ";uncontrol"},
}

for _, cmd in pairs(commands) do
    Section2:Button({
        Title = cmd.Title,
        Desc = cmd.Desc,
        Locked = false,
        Callback = function()
            if not SelectedPlayer then
                StarterGui:SetCore("SendNotification", {
                    Title = "[Failed]",
                    Text = "Select a player first!",
                    Duration = 3
                })
                return
            end
            local fullCmd = cmd.Cmd .. " " .. SelectedPlayer.Name  -- Monta ";cmd SelectedPlayer.Name"
            SendCommand(fullCmd)  -- Envia para o chat (RBXGeneral)
            -- O listener vai capturar e executar automaticamente
        end
    })
end

-- Notificação final de carregamento
StarterGui:SetCore("SendNotification", {
    Title = "[Hexagon Admin]",
    Text = "Hexagon loaded, Send commands via chat (RBXGeneral). Manual: ;cmd [PlayerName] or ;cmd (use SelectedPlayer).",
    Duration = 5

})
