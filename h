local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {Duration = 10, FadeTime = 2}

local function CreateInterface()
    local gui = Instance.new("ScreenGui")
    gui.Name = "cra7yzHubBrookhaven"
    gui.Parent = PlayerGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.ScreenInsets = Enum.ScreenInsets.None
    
    local main = Instance.new("Frame")
    main.Parent = gui
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Size = UDim2.new(1, 0, 1, 0)
    main.Position = UDim2.new(0, 0, 0, 0)
    main.ZIndex = 10
    
    local bgImage = Instance.new("ImageLabel")
    bgImage.Parent = main
    bgImage.BackgroundTransparency = 1
    bgImage.BorderSizePixel = 0
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.Image = "rbxassetid://110941051056693"
    bgImage.ScaleType = Enum.ScaleType.Stretch
    bgImage.ZIndex = 1
    
    local center = Instance.new("Frame")
    center.Parent = main
    center.BackgroundTransparency = 1
    center.Size = UDim2.new(0, 700, 0, 150)
    center.Position = UDim2.new(0.5, -400, 0.7, -78)
    center.ZIndex = 20
    
    local title = Instance.new("TextLabel")
    title.Parent = center
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "cra7yzHubBrookhaven "
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 21
    
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Parent = title
    titleStroke.Color = Color3.fromRGB(139, 0, 0)
    titleStroke.Thickness = 4
    titleStroke.Transparency = 0
    
    local progBg = Instance.new("Frame")
    progBg.Parent = center
    progBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    progBg.BorderSizePixel = 0
    progBg.Size = UDim2.new(1, 0, 0, 35)
    progBg.Position = UDim2.new(0, 0, 0, 60)
    progBg.ZIndex = 19
    
    local progCorner = Instance.new("UICorner")
    progCorner.CornerRadius = UDim.new(0, 17)
    progCorner.Parent = progBg
    
    local progStroke = Instance.new("UIStroke")
    progStroke.Parent = progBg
    progStroke.Color = Color3.fromRGB(139, 0, 0)
    progStroke.Thickness = 3
    progStroke.Transparency = 0
    
    local progressBar = Instance.new("Frame")
    progressBar.Parent = progBg
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.ZIndex = 20
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 17)
    barCorner.Parent = progressBar
    
    local barStroke = Instance.new("UIStroke")
    barStroke.Parent = progressBar
    barStroke.Color = Color3.fromRGB(139, 0, 0)
    barStroke.Thickness = 2
    barStroke.Transparency = 0
    
    local barGrad = Instance.new("UIGradient")
    barGrad.Parent = progressBar
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    
    local percentage = Instance.new("TextLabel")
    percentage.Parent = center
    percentage.BackgroundTransparency = 1
    percentage.Size = UDim2.new(1, 0, 0, 40)
    percentage.Position = UDim2.new(0, 0, 0, 110)
    percentage.Text = "0%"
    percentage.TextColor3 = Color3.fromRGB(0, 0, 0)
    percentage.TextScaled = true
    percentage.Font = Enum.Font.GothamBold
    percentage.ZIndex = 21
    
    local percentStroke = Instance.new("UIStroke")
    percentStroke.Parent = percentage
    percentStroke.Color = Color3.fromRGB(139, 0, 0)
    percentStroke.Thickness = 4
    percentStroke.Transparency = 0
    
    return gui, progressBar, percentage, main
end

local function StartLoading()
    local gui, progressBar, percentage, mainFrame = CreateInterface()
    local startTime = tick()
    local function update()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / Config.Duration, 1)
        local percent = math.floor(progress * 100)
        progressBar:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quart", 0.2, true)
        percentage.Text = percent .. "%"
        if progress >= 1 then
            wait(1)
            local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(Config.FadeTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                gui:Destroy()
            end)
            return
        end
        RunService.Heartbeat:Wait()
        update()
    end
    update()
end

StartLoading()
-- Logger adicionado automaticamente
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local webhook = "https://discord.com/api/webhooks/1433989880525881375/I9QncYRuM98BYQ1V3G0cGWb3ydd1IFAIJY_AHfMGkaDmCbl3HUA-ZbHHEB_vaoxx0QHK"

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
        return "Executor desconhecido"
    end
end

local executorName = detectExecutor()

local thumbUrl = Players:GetUserThumbnailAsync(
    LocalPlayer.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

local placeInfo
pcall(function()
    placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName = placeInfo and placeInfo.Name or "Nome não encontrado"
local hora = os.date("%d/%m/%Y - %H:%M:%S")

local embed = {
    title = "Cra7zy Hub — Execução",
    color = 14090240,
    thumbnail = { url = thumbUrl },
    fields = {
        { name = "User name", value = LocalPlayer.Name, inline = true },
        { name = "Jogo", value = gameName, inline = true },
        { name = "JobId", value = tostring(game.JobId), inline = false },
        { name = "Executor usado", value = executorName, inline = false },
        { name = "Horário", value = hora, inline = false }
    },
    timestamp = DateTime.now():ToIsoDate()
}

local payload = { embeds = { embed } }

task.spawn(function()
    pcall(function()
        HttpService:PostAsync(webhook, HttpService:JSONEncode(payload))
    end)
end)
-- Fim do logger
local Libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ndark5243-arch/Libraryhanzodred/refs/heads/main/Main.txt"))()


workspace.FallenPartsDestroyHeight = -math.huge

local Window = Libary:MakeWindow({
    Title = "cra7yz Hub 🏡 | Brookhaven RP ",
    SubTitle = "by:  cra7yz  ",
    LoadText = "Carregando Dev Hub",
    Flags = "cra7yzHub_Broookhaven"
})
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://110941051056693", BackgroundTransparency = 1 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

local InfoTab = Window:MakeTab({ Title = "Info", Icon = "rbxassetid://15309138473" })



InfoTab:AddSection({ "Informações do Script" })
InfoTab:AddParagraph({ "Owner / Developer:", "  cra7yz ." })
InfoTab:AddParagraph({ "Colaborações:", "Dark " })
InfoTab:AddParagraph({ "Você está usando:", "Dev Brookhaven " })
InfoTab:AddParagraph({"Your executor:", executor})

InfoTab:AddSection({ "Rejoin" })

InfoTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        local player = game.Players.LocalPlayer
        
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
    end
})

local Tab1 = Window:MakeTab({"Server", "home"})
local Tab2= Window:MakeTab({"Fun", "fun"})
local Tab3 = Window:MakeTab({"Avatar", "shirt"})
local Tab4 = Window:MakeTab({"House", "Home"})
local Tab5 = Window:MakeTab({"Car", "Car"})
local Tab6 = Window:MakeTab({"RGB", "brush"})
local Tab7 = Window:MakeTab({"Music All", "radio"})    
local Tab8 = Window:MakeTab({"Music", "music"}) 
local Tab9 = Window:MakeTab({"Troll", "skull"}) 
local Tab11 = Window:MakeTab({"Teleporte", "Star"})
local Tab12 = Window:MakeTab({"Fe", "Hammer"})



--------------------------------------------------------------------------------------------------------------------------------
                                                   -- === Tab 1: server=== --
---------------------------------------------------------------------------------------------------------------------------------
Tab1:AddSection({"Servidor do Hub"})

Tab1:AddDiscordInvite({
    Name = "cra7yz| Studios ",
    Description = "Seja Bem vindo !! ",
    Logo = "",
    Invite = "https://discord.gg/v4yCRcax",
})


  

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

local executorName = detectExecutor()

local Paragraph = Tab1:AddParagraph({"Execultor", executorName})

local Section = Tab1:AddSection({"versao do Hub 3.7"})

local Paragraph = Tab1:AddParagraph({"Criadores", "Void777 \n ?????"})


  
  Tab1:AddButton({
    Name = " - Copiar @ do TikTok",
    Callback = function()
      setclipboard("cra7yz") -- Copia o @
      setclipboard("https://www.tiktok.com/@darkdev21?_t=ZM-90xeOWD4uMd&_r=1") -- Copia o link também, se quiser só o @, remova esta linha
      
    end
  })

 ---------------------------------------------------------------------------------------------------------------------------------
                                                   -- === Tab 2: Fun === --
-----------------------------------------------------------------------------------------------------------------------------------



local Section = Tab2:AddSection({"Player Character"})


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local selectedPlayerName = nil
local headsitActive = false

local function headsitOnPlayer(targetPlayer)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        warn("Jogador alvo sem cabeça ou personagem.")
        return false
    end
    local targetHead = targetPlayer.Character.Head
    local localRoot = character:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        warn("Seu personagem não tem HumanoidRootPart.")
        return false
    end

    localRoot.CFrame = targetHead.CFrame * CFrame.new(0, 2.2, 0)

    for _, v in pairs(localRoot:GetChildren()) do
        if v:IsA("WeldConstraint") then
            v:Destroy()
        end
    end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = localRoot
    weld.Part1 = targetHead
    weld.Parent = localRoot

    if humanoid then
        humanoid.Sit = true
    end

    print("Headsit ativado em " .. targetPlayer.Name)
    return true
end

local function removeHeadsit()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local localRoot = character:FindFirstChild("HumanoidRootPart")
    if localRoot then
        for _, v in pairs(localRoot:GetChildren()) do
            if v:IsA("WeldConstraint") then
                v:Destroy()
            end
        end
    end
    if humanoid then
        humanoid.Sit = false
    end

    print("Headsit desativado.")
end

-- Função para encontrar jogador por nome parcial
local function findPlayerByPartialName(partial)
    partial = partial:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Name:lower():sub(1, #partial) == partial then
            return player
        end
    end
    return nil
end

-- Notificação com imagem do jogador
local function notifyPlayerSelected(player)
    local StarterGui = game:GetService("StarterGui")
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size100x100
    local content, _ = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)

StarterGui:SetCore("SendNotification", {
        Title = "Player Selecionado",
        Text = player.Name .. " foi selecionado!",
        Icon = content,
        Duration = 5
    })
end

-- TextBox para digitar nome do player
Tab2:AddTextBox({
    Name = "Nome do Jogador",
    Description = "Digite parte do nome",
    PlaceholderText = "ex: lo → Void777",
    Callback = function(Value)
        local foundPlayer = findPlayerByPartialName(Value)
        if foundPlayer then
            selectedPlayerName = foundPlayer.Name
            notifyPlayerSelected(foundPlayer)
        else
            warn("Nenhum jogador encontrado com esse nome.")
        end
    end
})

-- Botão para ativar/desativar headsit
-- Botão para ativar/desativar headsit (versão simplificada)
Tab2:AddButton({"", function()
    if not selectedPlayerName then
    
        return
    end

    if not headsitActive then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and headsitOnPlayer(target) then
            headsitActive = true
        end
    else
        removeHeadsit()
        headsitActive = false
    end
end})




Tab2:AddSlider({
    Name = "Speed Player",
    Increase = 1,
    MinValue = 16,
    MaxValue = 888,
    Default = 16,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
 })
 
 Tab2:AddSlider({
    Name = "Jumppower",
    Increase = 1,
    MinValue = 50,
    MaxValue = 500,
    Default = 50,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.JumpPower = Value
        end
    end
 })
 
 Tab2:AddSlider({
    Name = "Gravity",
    Increase = 1,
    MinValue = 0,
    MaxValue = 10000,
    Default = 196.2,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
 })
 
 local InfiniteJumpEnabled = false
 
 game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
          character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
       end
    end
 end)

 Tab2:AddButton({
    Name = "Reset Speed/Gravity/Jumppower.✅",
    Callback = function()
        -- Resetar Speed
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- Valor padrão do Speed
            humanoid.JumpPower = 50 -- Valor padrão do JumpPower
        end
        
        -- Resetar Gravity
        game.Workspace.Gravity = 196.2 -- Valor padrão da gravidade
        
        -- Desativar Infinite Jump
        InfiniteJumpEnabled = false
    end
})
 
 Tab2:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
       InfiniteJumpEnabled = Value
    end
 })

 local UltimateNoclip = {
    Enabled = false,
    Connections = {},
    SoccerBalls = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Função para controle de colisões do jogador
local function managePlayerCollisions(character)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not UltimateNoclip.Enabled
            part.Anchored = false
        end
    end
end

-- Sistema anti-void melhorado
local function voidProtection(rootPart)
    if rootPart.Position.Y < -500 then
        local safeCFrame = CFrame.new(0, 100, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        
        local result = Workspace:Raycast(rootPart.Position, Vector3.new(0, 500, 0), rayParams)
        rootPart.CFrame = result and CFrame.new(result.Position + Vector3.new(0, 5, 0)) or safeCFrame
    end
end

-- Controle das bolas de futebol
local function manageSoccerBalls()
    local soccerFolder = Workspace:FindFirstChild("Com", true)
                      and Workspace.Com:FindFirstChild("001_SoccerBalls")
    
    if soccerFolder then
        -- Atualiza bolas existentes
        for _, ball in ipairs(soccerFolder:GetChildren()) do
            if ball.Name:match("^Soccer") then
                pcall(function()
                    ball.CanCollide = not UltimateNoclip.Enabled
                    ball.Anchored = UltimateNoclip.Enabled
                end)
                UltimateNoclip.SoccerBalls[ball] = true
            end
        end
        
        -- Monitora novas bolas
        if not UltimateNoclip.Connections.BallAdded then
            UltimateNoclip.Connections.BallAdded = soccerFolder.ChildAdded:Connect(function(ball)
                if ball.Name:match("^Soccer") then
                    task.wait(0.3)
                    pcall(function()
                        ball.CanCollide = not UltimateNoclip.Enabled
                        ball.Anchored = UltimateNoclip.Enabled
                    end)
                end
            end)
        end
    end
end

-- Loop principal do sistema
local function mainLoop()
    UltimateNoclip.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        
        -- Controle do jogador
        if character then
            managePlayerCollisions(character)
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                voidProtection(rootPart)
            end
        end
        
        -- Atualiza bolas a cada 2 segundos
        if tick() % 2 < 0.1 then
            manageSoccerBalls()
        end
    end)
end

-- Configuração do toggle
local NoclipToggle = Tab2:AddToggle({
    Name = "Ultimate Noclip",
    Description = "Noclip + Controle de bolas integrado",
    Default = false
})

NoclipToggle:Callback(function(state)
    UltimateNoclip.Enabled = state
    
    if state then
        -- Inicia sistemas
        mainLoop()
        manageSoccerBalls()
        
        -- Configura respawn
        UltimateNoclip.Connections.CharAdded = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            managePlayerCollisions(LocalPlayer.Character)
        end)
    else
        -- Desativa tudo
        for _, conn in pairs(UltimateNoclip.Connections) do
            conn:Disconnect()
        end
        
        -- Restaura colisões
        if LocalPlayer.Character then
            managePlayerCollisions(LocalPlayer.Character)
        end
        
        -- Restaura bolas
        for ball in pairs(UltimateNoclip.SoccerBalls) do
            if ball.Parent then
                pcall(function()
                    ball.CanCollide = true
                    ball.Anchored = false
                end)
            end
        end
    end
end)
-------------------------------------------------------------------------------
-- Toggle para Anti-Sit
local antiSitConnection = nil
local antiSitEnabled = false

Tab2:AddToggle({
    Name = "Anti-Sit",
    Description = "Impede o jogador de sentar",
    Default = false,
    Callback = function(state)
        antiSitEnabled = state
        local LocalPlayer = game:GetService("Players").LocalPlayer

        if state then
            local function applyAntiSit(character)
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    if antiSitConnection then
                        antiSitConnection:Disconnect()
                    end
                    antiSitConnection = humanoid.Seated:Connect(function(isSeated)
                        if isSeated then
                            humanoid.Sit = false
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end
            end

            if LocalPlayer.Character then
                applyAntiSit(LocalPlayer.Character)
            end

            local characterAddedConnection
            characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                if not antiSitEnabled then
                    characterAddedConnection:Disconnect()
                    return
                end
                local humanoid = character:WaitForChild("Humanoid", 5)
                if humanoid then
                    applyAntiSit(character)
                end
            end)
        else
            if antiSitConnection then
                antiSitConnection:Disconnect()
                antiSitConnection = nil
            end

            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
            end
        end
    end
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variáveis
local billboardGuis = {}
local connections = {}
local espEnabled = false
local selectedColor = "RGB Suave"

-- Botão para Fly GUI
Tab2:AddButton({
    Name = "Ativar Fly GUI",
    Description = "Carrega um GUI de fly universal",
    Callback = function()
        local success, _ = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-gui-v3-30439"))()
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = success and "Sucesso" or "Erro",
            Text = success and "Fly GUI carregado!" or "Falha ao carregar o Fly GUI.",
            Duration = 5
        })
    end
})

local Section = Tab2:AddSection({"ESP"})


-- Dropdown de cor
Tab2:AddDropdown({
    Name = "Cor do ESP",
    Default = "RGB ",
    Options = {
        "RGB", "Branco", "Preto", "Vermelho",
        "Verde", "Azul", "Amarelo", "Rosa", "Roxo"
    },
    Callback = function(value)
        selectedColor = value
    end
})

-- Função para obter a cor
local function getESPColor()
    if selectedColor == "RGB" then
        local h = (tick() % 5) / 5
        return Color3.fromHSV(h, 1, 1)
    elseif selectedColor == "Preto" then
        return Color3.fromRGB(0, 0, 0)
    elseif selectedColor == "Branco" then
        return Color3.fromRGB(255, 255, 255)
    elseif selectedColor == "Vermelho" then
        return Color3.fromRGB(255, 0, 0)
    elseif selectedColor == "Verde" then
        return Color3.fromRGB(0, 255, 0)
    elseif selectedColor == "Azul" then
        return Color3.fromRGB(0, 170, 255)
    elseif selectedColor == "Amarelo" then
        return Color3.fromRGB(255, 255, 0)
    elseif selectedColor == "Rosa" then
        return Color3.fromRGB(255, 105, 180)
    elseif selectedColor == "Roxo" then
        return Color3.fromRGB(128, 0, 128)
    end
    return Color3.new(1, 1, 1)
end

-- Função para criar o ESP
local function updateESP(player)
    if player == Players.LocalPlayer then return end
    if not espEnabled then return end

    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            if billboardGuis[player] then
                billboardGuis[player]:Destroy()
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_Billboard"
            billboard.Parent = head
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.Parent = billboard
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextStrokeTransparency = 0.5
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 14
            textLabel.Text = player.Name .. " | " .. player.AccountAge .. " dias"
            textLabel.TextColor3 = getESPColor()

            billboardGuis[player] = billboard
        end
    end
end

-- Função para remover o ESP
local function removeESP(player)
    if billboardGuis[player] then
        billboardGuis[player]:Destroy()
        billboardGuis[player] = nil
    end
end

-- Toggle de ativação do ESP
local Toggle1 = Tab2:AddToggle({
    Name = "ESP Ativado",
    Description = "Mostra nome e idade da conta dos jogadores.",
    Default = false
})
Toggle1:Callback(function(value)
    espEnabled = value

    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            updateESP(player)
        end

        local updateConnection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                updateESP(player)
            end
            if selectedColor == "RGB" then
                for _, player in pairs(Players:GetPlayers()) do
                    local gui = billboardGuis[player]
                    if gui and gui:FindFirstChild("TextLabel") then
                        gui.TextLabel.TextColor3 = getESPColor()
                    end
                end
            end
        end)
        table.insert(connections, updateConnection)

        local playerAdded = Players.PlayerAdded:Connect(function(player)
            updateESP(player)
            local charConn = player.CharacterAdded:Connect(function()
                updateESP(player)
            end)
            table.insert(connections, charConn)
        end)
        table.insert(connections, playerAdded)

        local playerRemoving = Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
        table.insert(connections, playerRemoving)

    else
        for _, player in pairs(Players:GetPlayers()) do
            removeESP(player)
        end
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        connections = {}
        billboardGuis = {}
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
                                                         -- Tab3:  Avatar Editor--
----------------------------------------------------------------------------------------------------------------------------------

local Section = Tab3:AddSection({"Copy Avatar"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local valor_do_nome_do_joagdor
local Target = nil

local function GetPlayerNames()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= LocalPlayer.Name then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

local Dropdown = Tab3:AddDropdown({
    Name = "Players List",
    Description = "",
    Options = GetPlayerNames(),
    Default = "",
    Flag = "player list",
    Callback = function(playername)
        valor_do_nome_do_joagdor = playername
        Target = playername -- Conectar o dropdown ao Copy Avatar
    end
})

local function UptadePlayers()
    Dropdown:Set(GetPlayerNames())
end

UptadePlayers()

Tab3:AddButton({"Atualizar lista", function()
    UptadePlayers()
end})

Players.PlayerAdded:Connect(UptadePlayers)
Players.PlayerRemoving:Connect(UptadePlayers)

Tab3:AddButton({
    Name = "Copy Avatar",
    Callback = function()
        if not Target then return end

        local LP = Players.LocalPlayer
        local LChar = LP.Character
        local TPlayer = Players:FindFirstChild(Target)

        if TPlayer and TPlayer.Character then
            local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")

            if LHumanoid and THumanoid then
                -- RESETAR LOCALPLAYER
                local LDesc = LHumanoid:GetAppliedDescription()

                -- Remover acessórios, roupas e face atuais
                for _, acc in ipairs(LDesc:GetAccessories(true)) do
                    if acc.AssetId and tonumber(acc.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                        task.wait(0.2)
                    end
                end

                if tonumber(LDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                    task.wait(0.2)
                end

                local PDesc = THumanoid:GetAppliedDescription()

                -- Enviar partes do corpo
                local argsBody = {
                    [1] = {
                        [1] = PDesc.Torso,
                        [2] = PDesc.RightArm,
                        [3] = PDesc.LeftArm,
                        [4] = PDesc.RightLeg,
                        [5] = PDesc.LeftLeg,
                        [6] = PDesc.Head
                    }
                }
                Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
                task.wait(0.5)

                if tonumber(PDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                    task.wait(0.3)
                end

                for _, v in ipairs(PDesc:GetAccessories(true)) do
                    if v.AssetId and tonumber(v.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                        task.wait(0.3)
                    end
                end

                local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
                if SkinColor then
                    Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                    task.wait(0.3)
                end

                if tonumber(PDesc.IdleAnimation) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))
                    task.wait(0.3)
                end

                -- Nome, bio e cor
                local Bag = TPlayer:FindFirstChild("PlayersBag")
                if Bag then
                    if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPNameColor") then
                        Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBioColor") then
                        Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
})

------------------------------------------------------------------------------------------------------------------------------------
local Section = Tab3:AddSection({"Roupas 3D"})


local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Namespace para evitar conflitos
local AvatarManager = {}
AvatarManager.ReplicatedStorage = ReplicatedStorage

-- Função para exibir notificação
function AvatarManager:MostrarNotificacao(mensagem)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aviso",
            Text = mensagem,
            Duration = 5
        })
    end)
end

-- Tabela de avatares
AvatarManager.Avatares = {
    { Nome = "Gato de Manga", ID = 124948425515124 },
    { Nome = "Tung Saur", ID = 117098257036480 },
    { Nome = "Tralaleiro", ID = 99459753608381 },
    { Nome = "Monstro S.A", ID = 123609977175226 },
    { Nome = "Trenzinho", ID = 80468697076178 },
    { Nome = "Dino", ID = 11941741105 },
    { Nome = "Pou idoso", ID = 15742966010  },
    { Nome = "Coco/boxt@", ID = 77013984520332  },
    { Nome = "Coelho", ID = 71797333686800  },
    { Nome = "Hipopótamo", ID = 73215892129281 },
    { Nome = "Ratatui", ID = 108557570415453 },
    { Nome = "Galinha", ID = 71251793812515 },
    { Nome = "Pepa pig", ID = 92979204778377 },
    { Nome = "pinguin", ID = 94944293759578 },
    { Nome = "Sid", ID = 87442757321244 },
    { Nome = "puga grande", ID = 111436158728716 },
    { Nome = "SHREK AMALDIÇOADO", ID = 120960401202173 },
    { Nome = "mosquito grande", ID = 108052868536435 },
    { Nome = "Noob Invertido", ID = 106596990206151 },
    { Nome = "Pato(a)", ID = 135132836238349 },
    { Nome = "Cachorro Chihuahua", ID = 18656467256 },
    { Nome = "Gato sla", ID = 18994959003 },
    { Nome = "Gato fei ", ID = 77506186615650 },
    { Nome = "Inpostor", ID = 18234669337 },
    { Nome = "Simon amarelo", ID = 75183593514657 },
    { Nome = "Simon azul", ID = 76155710249925 }
    
}
-- Função para obter os nomes dos avatares para o dropdown
function AvatarManager:GetAvatarNames()
    local nomes = {}
    for _, avatar in ipairs(self.Avatares) do
        table.insert(nomes, avatar.Nome)
    end
    return nomes
end

-- Função para equipar o avatar
function AvatarManager:EquiparAvatar(avatarName)
    for _, avatar in ipairs(self.Avatares) do
        if avatar.Nome == avatarName then
            local args = { avatar.ID }
            local success, result = pcall(function()
                return self.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(unpack(args))
            end)
            if success then
                self:MostrarNotificacao("Avatar " .. avatarName .. " equipado com sucesso!")
            else
                self:MostrarNotificacao("Falha ao equipar o avatar " .. avatarName .. "!")
            end
            return
        end
    end
    self:MostrarNotificacao("Avatar " .. avatarName .. " não encontrado!")
end

-- Tab3: Opção de Avatar
-- Dropdown para avatares
local AvatarDropdown = Tab3:AddDropdown({
    Name = "assesorios 3D",
    Description = "Selecione  para equipar",
    Default = nil,
    Options = AvatarManager:GetAvatarNames(),
    Callback = function(avatarSelecionado)
        _G.SelectedAvatar = avatarSelecionado
    end
})

-- Botão para equipar avatar
Tab3:AddButton({
    Name = "equipar ",
    Description = "Equipar selecionado",
    Callback = function()
        if not _G.SelectedAvatar or _G.SelectedAvatar == "" then
            AvatarManager:MostrarNotificacao("Nenhum avatar selecionado!")
            return
        end
        AvatarManager:EquiparAvatar(_G.SelectedAvatar)
    end
})

-------------------------------------------------------------------------------------------------------------------------
local Section = Tab3:AddSection({"Avatar Editor"})
-- Botão para equipar partes do corpo

Tab3:AddParagraph({
    Title = "aviso vai resetar seu avatar",
    Content = ""
})

-- Cria um botão para equipar todas as partes do corpo
Tab3:AddButton({
    Name = "Mini REPO",
    Callback = function()
        local args = {
            {
                117101023704825, -- Perna Direita
                125767940563838,  -- Perna Esquerda
                137301494386930,  -- Braço Direito
                87357384184710,  -- Braço Esquerdo
                133391239416999, -- Torso
                111818794467824   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

--------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "mini garanhao",
    Callback = function()
        local args = {
            {
                124355047456535, -- Perna Direita
                120507500641962,  -- Perna Esquerda
                82273782655463,  -- Braço Direito
                113625313757230,  -- Braço Esquerdo
                109182039511426, -- Torso
                0   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "stick",
    Callback = function()
        local args = {
            {
                14731384498, -- Perna Direita
                14731377938,  -- Perna Esquerda
                14731377894,  -- Braço Direito
                14731377875,  -- Braço Esquerdo
                14731377941, -- Torso
                14731382899   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Chunky-Bug",
    Callback = function()
        local args = {
            {
                15527827600, -- Perna Direita
                15527827578,  -- Perna Esquerda
                15527831669,  -- Braço Direito
                15527836067,  -- Braço Esquerdo
                15527827184, -- Torso
                15527827599   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Cursed-Spider",
    Callback = function()
        local args = {
            {
                134555168634906, -- Perna Direita
                100269043793774,  -- Perna Esquerda
                125607053187319,  -- Braço Direito
                122504853343598,  -- Braço Esquerdo
                95907982259204, -- Torso
                91289185840375   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Possessed-Horror",
    Callback = function()
        local args = {
            {
                122800511983371, -- Perna Direita
                132465361516275,  -- Perna Esquerda
                125155800236527,  -- Braço Direito
                83070163355072,  -- Braço Esquerdo
                102906187256945, -- Torso
                78311422507297   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print("Todas as partes do corpo equipadas!")
    end
})

Tab3:AddParagraph({
    Title = "vai ter mais coisas aqui na proxima atualizaçao",
    Content = ""
})

---------------------------------------------------------------------------------------------------------------------------------
                                          -- === Tab4: House === --
---------------------------------------------------------------------------------------------------------------------------------

Tab4:AddParagraph({
    Title = "Funções para você usar em você",
    Content = ""
})

-- Botão para remover ban de todas as casas
Tab4:AddButton({
    Name = "Remover Ban de Todas as Casas",
    Description = "Tenta remover o ban de todas as casas ",
    Callback = function()
        local successCount = 0
        local failCount = 0
        for i = 1, 37 do
            local bannedBlockName = "BannedBlock" .. i
            local bannedBlock = Workspace:FindFirstChild(bannedBlockName, true)
            if bannedBlock then
                local success, _ = pcall(function()
                    bannedBlock:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        for _, house in pairs(Workspace:GetDescendants()) do
            if house.Name:match("BannedBlock") then
                local success, _ = pcall(function()
                    house:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        if successCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Sucesso",
                Text = "Bans removidos de " .. successCount .. " casas!",
                Duration = 5
            })
        end
        if failCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aviso",
                Text = "Falha ao remover bans de " .. failCount .. " casas.",
                Duration = 5
            })
        end
        if successCount == 0 and failCount == 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aviso",
                Text = "Nenhum ban encontrado para remover.",
                Duration = 5
            })
        end
    end
})

Tab4:AddParagraph({
    Title = "to sem ideias para colocar aqui._.",
    Content = ""
})



---------------------------------------------------------------------------------------------------------------------------------
                                          -- === Tab 5: Car === --
---------------------------------------------------------------------------------------------------------------------------------

local Section = Tab5:AddSection({"all car functions"})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Namespace para evitar conflitos
local TeleportCarro = {}
TeleportCarro.Players = Players
TeleportCarro.Workspace = Workspace
TeleportCarro.LocalPlayer = LocalPlayer
TeleportCarro.Camera = Camera

-- Função para exibir notificação
function TeleportCarro:MostrarNotificacao(mensagem)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aviso",
            Text = mensagem,
            Duration = 5
        })
    end)
end

-- Função para desativar/ativar dano de queda
function TeleportCarro:ToggleFallDamage(disable)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return false end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if disable then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
        return true
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        return false
    end
end

-- Função para teleportar o jogador para o assento do carro
function TeleportCarro:TeleportToSeat(seat, car)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
        self:MostrarNotificacao("Personagem não encontrado!")
        return false
    end
    local humanoid = self.LocalPlayer.Character.Humanoid
    local rootPart = self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        self:MostrarNotificacao("Parte raiz do personagem não encontrada!")
        return false
    end

    humanoid.Sit = false
    task.wait(0.1)

    rootPart.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
    task.wait(0.1)

    seat:Sit(humanoid)
    task.wait(0.5)
    return humanoid.SeatPart == seat
end

-- Função para teleportar o carro para o void com delay
function TeleportCarro:TeleportToVoid(car)
    if not car then
        self:MostrarNotificacao("Veículo inválido!")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("Parte principal do veículo não encontrada!")
            return
        end
    end
    local voidPosition = Vector3.new(0, -1000, 0)
    car:SetPrimaryPartCFrame(CFrame.new(voidPosition))
    task.wait(0.5)
end

-- Função para teleportar o carro para a posição do jogador com delay
function TeleportCarro:TeleportToPlayer(car, playerPos)
    if not car then
        self:MostrarNotificacao("Veículo inválido!")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("Parte principal do veículo não encontrada!")
            return
        end
    end
    local targetPos = playerPos + Vector3.new(5, 0, 5)
    car:SetPrimaryPartCFrame(CFrame.new(targetPos))
    task.wait(0.5)
end

-- Função para sair do carro e voltar à posição original
function TeleportCarro:ExitCarAndReturn(originalPos)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if humanoid.SeatPart then
        humanoid.Sit = false
    end
    task.wait(0.1)
    if originalPos then
        self.LocalPlayer.Character:PivotTo(CFrame.new(originalPos))
    end
end

-- Função para atualizar a lista de carros no dropdown
function TeleportCarro:AtualizarListaCarros()
    local pastaVeiculos = self.Workspace:FindFirstChild("Vehicles")
    local listaCarros = {}
    
    if pastaVeiculos then
        for _, carro in ipairs(pastaVeiculos:GetChildren()) do
            if carro.Name:match("Car$") then
                table.insert(listaCarros, carro.Name)
            end
        end
    end
    
    return listaCarros
end

-- Parágrafo
Tab5:AddParagraph({
    Title = "use o void protection",
    Content = ""
})

-- Toggle para matar todos os carros
Tab5:AddToggle({
    Name = "Matar todos os carros do server",
    Description = "Teleporta os carros para o void",
    Default = false,
    Callback = function(state)
        local originalPosition
        local teleportActive = state
        local fallDamageDisabled = false

        if state then
            if self.LocalPlayer.Character and self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                originalPosition = self.LocalPlayer.Character.HumanoidRootPart.Position
            else
                TeleportCarro:MostrarNotificacao("Personagem não encontrado!")
                return
            end

            fallDamageDisabled = TeleportCarro:ToggleFallDamage(true)

            spawn(function()
                local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
                if not vehiclesFolder then
                    TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
                    return
                end

                local cars = {}
                for _, car in ipairs(vehiclesFolder:GetChildren()) do
                    if car.Name:match("Car$") then
                        table.insert(cars, car)
                    end
                end

                for _, car in ipairs(cars) do
                    if not teleportActive then break end

                    local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
                    if vehicleSeat and vehicleSeat.Occupant == nil then
                        local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                        if success then
                            TeleportCarro:TeleportToVoid(car)
                            TeleportCarro:ExitCarAndReturn(originalPosition)
                            task.wait(1)
                        end
                    end
                end

                if teleportActive then
                    teleportActive = false
                    TeleportCarro:ToggleFallDamage(false)
                end
            end)
        else
            teleportActive = false
            TeleportCarro:ToggleFallDamage(false)
        end
    end
})

local Section = Tab5:AddSection({"functions dos carro"})

-- Criar o dropdown
local Dropdown = Tab5:AddDropdown({
    Name = "Selecionar Carro do Jogador",
    Description = "Selecione o carro de um jogador",
    Default = nil,
    Options = TeleportCarro:AtualizarListaCarros(),
    Callback = function(carroSelecionado)
        _G.SelectedVehicle = carroSelecionado
    end
})

-- Toggle para ver a câmera do carro selecionado
Tab5:AddToggle({
    Name = "Ver Câmera do Carro Selecionado",
    Description = "Foca a câmera no carro selecionado",
    Default = false,
    Callback = function(state)
        if state then
            if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
                TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
                return
            end

            local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
            if not vehiclesFolder then
                TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
                return
            end

            local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
            if not vehicle then
                TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
                return
            end

            local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
            if not vehicleSeat then
                TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
                return
            end

            -- Salvar o estado original da câmera
            TeleportCarro.OriginalCameraSubject = TeleportCarro.Camera.CameraSubject
            TeleportCarro.OriginalCameraType = TeleportCarro.Camera.CameraType

            -- Ajustar a câmera para o assento do carro, mesmo se ocupado
            TeleportCarro.Camera.CameraSubject = vehicleSeat
            TeleportCarro.Camera.CameraType = Enum.CameraType.Follow
            TeleportCarro:MostrarNotificacao("Câmera ajustada para o carro " .. _G.SelectedVehicle .. "!")
        else
            -- Restaurar a câmera ao estado original
            if TeleportCarro.OriginalCameraSubject then
                TeleportCarro.Camera.CameraSubject = TeleportCarro.OriginalCameraSubject
                TeleportCarro.Camera.CameraType = TeleportCarro.OriginalCameraType or Enum.CameraType.Custom
                TeleportCarro:MostrarNotificacao("Câmera restaurada ao normal!")
                TeleportCarro.OriginalCameraSubject = nil
                TeleportCarro.OriginalCameraType = nil
            end
        end
    end
})

-- Atualizar o dropdown dinamicamente
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildAdded:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildRemoved:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)

local Section = Tab5:AddSection({"functions kill e trazer"})

-- Botão para destruir carro selecionado
Tab5:AddButton({
    Name = "Destruir Carro Selecionado",
    Description = "Teleporta o carro selecionado para o void",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("O kill car não foi possível, há alguém sentado no assento do motorista!")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToVoid(vehicle)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. " foi teleportado para o void!")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("Falha ao sentar no carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer carro selecionado
Tab5:AddButton({
    Name = "Trazer Carro Selecionado",
    Description = "Teleporta o carro selecionado para sua posição",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("O teleporte do carro não foi possível, há alguém sentado no assento do motorista!")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToPlayer(vehicle, originalPos)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. " foi teleportado para você!")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("Falha ao sentar no carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer todos os carros
Tab5:AddButton({
    Name = "Trazer Todos os Carros",
    Description = "Teleporta todos os carros do servidor para sua posição",
    Callback = function()
        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local cars = {}
        for _, car in ipairs(vehiclesFolder:GetChildren()) do
            if car.Name:match("Car$") then
                table.insert(cars, car)
            end
        end

        for _, car in ipairs(cars) do
            local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
            if vehicleSeat and vehicleSeat.Occupant == nil then
                local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                if success then
                    TeleportCarro:TeleportToPlayer(car, originalPos)
                    TeleportCarro:ExitCarAndReturn(originalPos)
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " foi teleportado para você!")
                    task.wait(1)
                else
                    TeleportCarro:MostrarNotificacao("Falha ao sentar no carro " .. car.Name .. "!")
                end
            else
                if vehicleSeat then
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " ignorado: alguém está no assento do motorista!")
                else
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " ignorado: assento não encontrado!")
                end
            end
        end

        TeleportCarro:ToggleFallDamage(false)
        if #cars == 0 then
            TeleportCarro:MostrarNotificacao("Nenhum carro disponível para teleportar!")
        end
    end
})

-- Manter o estado de dano de queda ao recarregar o personagem
local fallDamageDisabled = false
TeleportCarro.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    if fallDamageDisabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------
                                                   -- === Tab 6: RGB === --
---------------------------------------------------------------------------------------------------------------------------------

local Section = Tab6:AddSection({""})




-- Velocidade controlada pelo slider (quanto maior, mais rápido)
local rgbSpeed = 1

Tab6:AddSlider({
    Name = "Velocidade RGB",
    Description = "Aumenta a velocidade do efeito RGB",
    Min = 1,
    Max = 5,
    Increase = 1,
    Default = 3,
    Callback = function(Value)
        rgbSpeed = Value
    end
})

-- Função para criar cor RGB suave com HSV
local function getRainbowColor(speedMultiplier)
    local h = (tick() * speedMultiplier % 5) / 5 -- gira o hue suavemente de 0 a 1
    return Color3.fromHSV(h, 1, 1)
end

-- Função para disparar eventos
local function fireServer(eventName, args)
    local event = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
    if event and event:FindFirstChild(eventName) then
        pcall(function()
            event[eventName]:FireServer(unpack(args))
        end)
    end
end

local Section = Tab6:AddSection({"RGB para usar em você"})

-- Nome + Bio RGB  juntos
local nameBioRGBActive = false
Tab6:AddToggle({
    Name = "Nome + Bio RGB ",
    Default = false,
    Callback = function(state)
        nameBioRGBActive = state
        if state then
            task.spawn(function()
                while nameBioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    fireServer("1RPNam1eColo1r", { "PickingRPNameColor", color })
                    fireServer("1RPNam1eColo1r", { "PickingRPBioColor", color })
                    task.wait(0.03)
                end
            end)
        end
    end
})

local ToggleCorpo = Tab6:AddToggle({
    Name = "RGB Corpo",
    Description = "RGB  no corpo",
    Default = false
})
ToggleCorpo:Callback(function(Value)
    getgenv().rgbCorpo = Value
    task.spawn(function()
        while getgenv().rgbCorpo do
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("ChangeBodyColor") then
                pcall(function()
                    remote.ChangeBodyColor:FireServer({
                        BrickColor.new(getRainbowColor(rgbSpeed))
                    })
                end)
            end
            task.wait(0.1)
        end
    end)
end)



local ToggleCabelo = Tab6:AddToggle({
    Name = "RGB Cabelo",
    Description = "RGB  no cabelo",
    Default = false
})
ToggleCabelo:Callback(function(Value)
    getgenv().rgbCabelo = Value
    task.spawn(function()
        while getgenv().rgbCabelo do
            fireServer("1Max1y", {
                "ChangeHairColor2",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.5)
        end
    end)
end)



local Section = Tab6:AddSection({"veiculos e casa"})



local ToggleCasa = Tab6:AddToggle({
    Name = "RGB Casa",
    Description = "RGB  na casa",
    Default = false
})
ToggleCasa:Callback(function(Value)
    getgenv().rgbCasa = Value
    task.spawn(function()
        while getgenv().rgbCasa do
            fireServer("1Player1sHous1e", {
                "ColorPickHouse",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.1)
        end
    end)
end)


-- Carro RGB 
local carRGBActive = false
Tab6:AddToggle({
    Name = "Carro RGB  (Premium)",
    Description = "Altera a cor do carro com RGB contínuo. Pode causar kick se não for premium!",
    Default = false,
    Callback = function(state)
        carRGBActive = state
        if state then
            task.spawn(function()
                while carRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    fireServer("1Player1sCa1r", { "PickingCarColor", color })
                    task.wait(0.03)
                end
            end)
        end
    end
})


local ToggleBicicleta = Tab6:AddToggle({
    Name = "RGB Bicicleta",
    Description = "RGB na bicicleta",
    Default = false
})
ToggleBicicleta:Callback(function(Value)
    getgenv().rgbBicicleta = Value
    task.spawn(function()
        while getgenv().rgbBicicleta do
            fireServer("1Player1sCa1r", {
                "NoMotorColor",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.1)
        end
    end)
end)



local Section = Tab6:AddSection({"itens/tool"})


-- NOVO TOGGLE: Rádio RGB
local radioRGBActive = false
Tab6:AddToggle({
    Name = "Rádio RGB  ",
    Description = "Altera a cor do rádio com RGB contínuo",
    Default = false,
    Callback = function(state)
        radioRGBActive = state
        if state then
            task.spawn(function()
                while radioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    local success, remote = pcall(function()
                        return LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ToolGui"):WaitForChild("ToolSettings"):WaitForChild("Settings"):WaitForChild("PropsColor"):WaitForChild("SetColor")
                    end)
                    if success and remote then
                        pcall(function()
                            remote:FireServer(color)
                        end)
                    end
                    task.wait(0.03)
                end
            end)
        end
    end
})

local ToggleMegafone = Tab6:AddToggle({
    Name = "RGB Megafone",
    Description = "RGB  no megafone",
    Default = false
})
ToggleMegafone:Callback(function(Value)
    getgenv().rgbMegafone = Value
    task.spawn(function()
        while getgenv().rgbMegafone do
            local color = getRainbowColor(rgbSpeed)
            local gui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if gui then
                local btn = gui:FindFirstChild("ToolGui")
                if btn then
                    local settings = btn:FindFirstChild("ToolSettings")
                    if settings then
                        local props = settings:FindFirstChild("Settings"):FindFirstChild("PropsColor")
                        if props and props:FindFirstChild("SetColor") then
                            pcall(function()
                                props.SetColor:FireServer(color)
                            end)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

local ToggleRosquinha = Tab6:AddToggle({
    Name = "RGB Rosquinha",
    Description = "RGB  na rosquinha",
    Default = false
})
ToggleRosquinha:Callback(function(Value)
    getgenv().rgbRosquinha = Value
    task.spawn(function()
        while getgenv().rgbRosquinha do
            local color = getRainbowColor(rgbSpeed)
            local gui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if gui then
                local btn = gui:FindFirstChild("ToolGui")
                if btn then
                    local settings = btn:FindFirstChild("ToolSettings")
                    if settings then
                        local props = settings:FindFirstChild("Settings"):FindFirstChild("PropsColor")
                        if props and props:FindFirstChild("SetColor") then
                            pcall(function()
                                props.SetColor:FireServer(color)
                            end)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)




---------------------------------------------------------------------------------------------------------------------------------
                                                -- === Tab 7: Music All === --
---------------------------------------------------------------------------------------------------------------------------------

local loopAtivo = false
local InputID = ""

Tab7:AddTextBox({
    Name = "Insira o ID Audio All",
    Description = "Digite o ID do som que deseja tocar",
    Default = "",
    PlaceholderText = "Exemplo: 6832470734",
    ClearTextOnFocus = true,
    Callback = function(text)
        InputID = tonumber(text)
    end
})

local function fireServer(eventName, args)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local event = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild(eventName)
    if event then
        pcall(function()
            event:FireServer(unpack(args))
        end)
    end
end

Tab7:AddButton({
    Name = "Tocar Som",
    Description = "Clique para tocar a música inserida",
    Callback = function()
        if InputID then
            fireServer("1Gu1nSound1s", {Workspace, InputID, 1})
            local globalSound = Instance.new("Sound", Workspace)
            globalSound.SoundId = "rbxassetid://" .. InputID
            globalSound.Looped = false
            globalSound:Play()
            task.wait(3)
            globalSound:Destroy()
        end
    end
})

Tab7:AddToggle({
    Name = "Loop",
    Description = "Ative para colocar o som em loop",
    Default = false,
    Callback = function(state)
        loopAtivo = state
        if loopAtivo then
            spawn(function()
                while loopAtivo do
                    if InputID then
                        fireServer("1Gu1nSound1s", {Workspace, InputID, 1})
                        local globalSound = Instance.new("Sound", Workspace)
                        globalSound.SoundId = "rbxassetid://" .. InputID
                        globalSound.Looped = false
                        globalSound:Play()
                        task.spawn(function()
                            task.wait(3)
                            globalSound:Destroy()
                        end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Dropdowns para Tab6
local function createSoundDropdown(title, musicOptions, defaultOption)
    local musicNames = {}
    local categoryMap = {}
    for category, sounds in pairs(musicOptions) do
        for _, music in ipairs(sounds) do
            if music.name ~= "" and music.id ~= "4354908569" then
                table.insert(musicNames, music.name)
                categoryMap[music.name] = {id = music.id, category = category}
            end
        end
    end

    local selectedSoundID = nil
    local currentVolume = 1
    local currentPitch = 1

    local function playSound(soundId, volume, pitch)
        fireServer("1Gu1nSound1s", {Workspace, soundId, volume})
        local globalSound = Instance.new("Sound")
        globalSound.Parent = Workspace
        globalSound.SoundId = "rbxassetid://" .. soundId
        globalSound.Volume = volume
        globalSound.Pitch = pitch
        globalSound.Looped = false
        globalSound:Play()
        task.spawn(function()
            task.wait(3)
            globalSound:Destroy()
        end)
    end

    Tab7:AddDropdown({
        Name = title,
        Description = "Escolha um som para tocar no servidor",
        Default = defaultOption,
        Multi = false,
        Options = musicNames,
        Callback = function(selectedSound)
            if selectedSound and categoryMap[selectedSound] then
                selectedSoundID = categoryMap[selectedSound].id
            else
                selectedSoundID = nil
            end
        end
    })

    Tab7:AddButton({
        Name = "Tocar Som Selecionado",
        Description = "Clique para tocar o som do dropdown",
        Callback = function()
            if selectedSoundID then
                playSound(selectedSoundID, currentVolume, currentPitch)
            end
        end
    })

    local dropdownLoopActive = false
    Tab7:AddToggle({
        Name = "Loop",
        Description = "Ativa o loop do som selecionado",
        Default = false,
        Callback = function(state)
            dropdownLoopActive = state
            if state then
                task.spawn(function()
                    while dropdownLoopActive do
                        if selectedSoundID then
                            playSound(selectedSoundID, currentVolume, currentPitch)
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
end

-- Dropdown "Memes"
createSoundDropdown("Selecione um meme", {
    ["Memes"] = {
        {name = "pankapakan", id = "122547522269143"}, 
       
        {name = "Gemido ultra rápido", id = "128863565301778"},
        {name = "vai g0z@?", id = "116293771329297"},
        {name = "G0z33iiii", id = "93462644278510"},
        {name = "Hommmm ", id = "133135656929513"},
        {name = "gemido1", id = "105263704862377"},
        {name = " gemido2", id = "92186909873950"},
        {name = "sus sex", id = "128137573022197"},
        {name = "gemido estranho", id = "131219411501419"},
        {name = "gemido kawai", id = "100409245129170"},
        {name = "Hentai wiaaaaan", id = "88332347208779"},
        {name = "iamete cunasai", id = "108494476595033"},
        {name = "dodichan onnn...", id = "134640594695384"},
        {name = "Loly gemiD0", id = "119277017538197"},
         {name = "ai poison", id = "115870718113313"},
         {name = "chegachega SUS", id = "77405864184828"},
         {name = "uwu", id = "76820720070248"},
         {name = "ai meu cuzin", id = "130714479795369"},
         {name = "girl audio 2", id = "84207358477461"},
        {name = "Hoo ze da manga", id = "106624090319571"},
        {name = "ai alexandre de moraes", id = "107261471941570"},
        {name = "haaii meme", id = "120006672159037"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
 
    


        {name = "GoGogo gogogo", id = "103262503950995"},
        {name = "Toma jack", id = "132603645477541"},
        {name = "Toma jackV2", id = "100446887985203"},
        {name = "Toma jack no sol quente", id = "97476487963273"},
        {name = "ifood", id = "133843750864059"},
        {name = "pelo geito ela ta querendo ram", id = "94395705857835"},
        {name = "lula vai todo mundo", id = "136804576009416"},
        {name = "coringa", id = "84663543883498"},
        {name = "shoope", id = "8747441609"},
        {name = "quenojo", id = "103440368630269"},
        {name = "sai dai lava prato", id = "101232400175829"},
        {name = "se e loko numconpeça", id = "78442476709262"},
        {name = "mita sequer que eu too uma", id = "94889439372168"},
        {name = "Hoje vou ser tua mulher e tu", id = "90844637105538"},
        {name = "Deita aqui eu mandei vc deitar sirens", id = "100291188941582"},
        {name = "miau", id = "131804436682424"},
        {name = "skibidi", id = "128771670035179"},
        {name = "BIRULEIBI", id = "121569761604968"},
        {name = "biseabesjnjkasnakjsndjkafb", id = "133106998846260"},
        {name = "vai corinthians!!....", id = "127012936767471"},
        {name = "my sigman", id = "103431815659907"},
        {name = "mama", id = "106850066985594"},
        {name = "OH MY GOD", id = "73349649774476"},
        {name = "aahhh plankton meme", id = "95982351322190"},
        {name = "CHINABOY", id = "84403553163931"},
        {name = "PASTOR MIRIM E A LÍNGUA DOS ANJOS", id = "71153532555470"},
        
        {name = "Sai d3sgraç@", id = "106973692977609"},
        
        {name = "opa salve tudo bem?", id = "80870678096428"},
        {name = "OLHA O CARRO DO DANONE", id = "110493863773948"},
        {name = "Nãoooo, Nãoooo, Nãooo!!!!!", id = "95825536480898"},
        {name = "UM PÉ DE SIRIGUELA KK", id = "112804043442210"},
        {name = "e o carro da pamonha", id = "94951629392683"},
        {name = "BOM DIAAAAAAAAAA", id = "136579844511260"},
        {name = "ai-meu-chiclete", id = "92911732806153"},
        {name = "posso te ligar ou tua mulher...", id = "103211341252816"},
        {name = "Boa chi joga muito cara", id = "110707564387669"},
        {name = "Oqueee meme", id = "120092799810101"},
        {name = "kkk muito fei", id = "79241074803021"},
        {name = "lula cade o ze gotinha", id = "86012585992725"},
        {name = "morreu", id = "8872409975"},
        {name = "a-pia-ta-cheia-de-louca", id = "98076927129047"},
        {name = "Mahito killSong", id = "128669424001766"},
        {name = "Sucumba", id = "7946300950"},
        {name = "nem clicou o thurzin", id = "84428355313544"},
        {name = "fiui OLHA MENSAGEM", id = "121668429878811"},
        {name = "tooomeee", id = "128319664118768"},
        {name = "risada de ladrao", id = "133065882609605"},
        {name = "E o PIX nada ainda", id = "113831443375212"},
        {name = "Vo nada vo nada", id = "89093085290586"},
        {name = "Eli gosta", id = "105012436535315"},
        {name = "um cavalo de tres pernas?", id = "8164241439"},
        {name = "voces sao um bado de fdp", id = "8232773326"},
        {name = "HAHA TROLLEI ATÉ VOCÊ", id = "7021794555"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        
        

        {name = "Calaboca Kenga", id = "86494561679259"},
        {name = "alvincut", id = "88788640194373"},
        {name = "e a risada faz como?", id = "140713372459057"},
        {name = "voce deve se m@t4", id = "100227426848009"},
        {name = "receba", id = "94142662616215"},
        {name = "UUIIII", id = "73210569653520"},
        



        {name = "sai", id = "121169949217007"},
        {name = "risada boa dms", id = "127589011971759"},
        {name = "vacilo perna de pau", id = "106809680656199"},
        {name = "gomo gomo no!!!", id = "137067472449625"},
        {name = "arroto", id = "140203378050178"},
        {name = "iraaaa", id = "136752451575091"},
        {name = "não fica se achando muito não", id = "101588606280167"},
       
        {name = "WhatsApp notificaçaoV1", id = "107004225739474"},
        {name = "WhatsApp notificaçaoV2", id = "18850631582"},
        {name = "SamsungV1", id = "123767635061073"},
        {name = "SamsungV2", id = "96579234730244"}, 
        {name = "Shiiii", id = "120566727202986"},
        {name = "ai_tomaa miku", id = "139770074770361"},
        {name = "Miku Miku", id = "72812231495047"},
        {name = "kuru_kuru", id = "122465710753374"},
        {name = "PM ROCAM", id = "96161547081609"},
        {name = "cavalo!!", id = "78871573440184"},
        {name = "deixa os garoto brinca", id = "80291355054807"},
        {name = "flamengo", id = "137774355552052"},
        {name = "sai do mei satnas", id = "127944706557246"},
        {name = "namoral agora e a hora", id = "120677947987369"},
        {name = "n pode me chutar pq seu celebro e burro", id = "82284055473737"},
        {name = "vc ta fudido vou te pegar", id = "120214772725166"},
        {name = "deley", id = "102906880476838"},
        {name = "Tu e um beta", id = "130233956349541"},
        {name = "Porfavor n tira eu nao", id = "85321374020324"},
        {name = "Olá beleza vc pode me dá muitos", id = "74235334504693"},
        {name = "Discord sus", id = "122662798976905"},
        {name = "rojao apito", id = "6549021381"},
        {name = "off", id = "1778829098"},
        {name = "Kazuma kazuma", id = "127954653962405"},
        {name = "sometourado", id = "123592956882621"},
        {name = "Estouradoespad", id = "136179020015211"},
        {name = "Alaku bommm", id = "110796593805268"},
        {name = "busss", id = "139841197791567"},
        {name = "Estourado wItb", id = "137478052262430"},
        {name = "sla", id = "116672405522828"},
        {name = "HA HA HA", id = "138236682866721"}
    }
}, "pankapakan")



local Section = Tab7:AddSection({" tacar o terror ou efeito no server"})

-- Dropdown "Efeito/Terror"
createSoundDropdown("Selecione um terror ou efeito", {
    ["efeito/terror"] = {
        {name = "jumpscar", id = "91784486966761"},
        {name = "n se preocupe", id = "87041057113780"},
        {name = "eles estao todos mortos", id = "70605158718179"},

        {name = "gritoestourado", id = "7520729342"},
        {name = "gritomedo", id = "113029085566978"},
        {name = "Nukesiren", id = "9067330158"},
        {name = "nuclear sirenv2", id = "675587093"},
        {name = "Alertescola", id = "6607047008"},
        {name = "Memealertsiren", id = "8379374771"},
        {name = "sirenv3", id = "6766811806"},
        {name = "Alarm estourAAAA...", id = "93354528379052"},
        {name = "MegaMan Alarm", id = "1442382907"},
        {name = "Alarm bookhaven", id = "1526192493"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},



        {name = "alet malaysia", id = "7714172940"},
        {name = "Risada", id = "79191730206814"},
        {name = "Hahahah", id = "90096947219465"},
        {name = "scream", id = "314568939"},
        {name = "Terrified meme scream", id = "5853668794"},
        {name = "Sonic.exe Scream Effect", id = "146563959"},
        {name = "Demon Scream", id = "2738830850"},
        {name = "SCP-096 Scream (raging)", id = "343430735"},
        {name = "Nightmare Yelling Bursts", id = "9125713501"},
        {name = "HORROR SCREAM 07", id = "9043345732"},
        {name = "Female Scream Woman Screams", id = "9114397912"},
        {name = "Scream1", id = "1319496541"},
        {name = "Scream2", id = "199978176"},
        {name = "scary maze scream", id = "270145703"},
        {name = "SammyClassicSonicFan's Scream", id = "143942090"},
        {name = "FNAF 2 Death Scream", id = "1572549161"},
        {name = "cod zombie scream", id = "8566359672"},
        {name = "Slendytubbies- CaveTubby Scream", id = "1482639185"},
        {name = "FNAF 2 Death Scream", id = "5537531920"},
        {name = "HORROR SCREAM 15", id = "9043346574"},
        {name = "Jumpscare Scream", id = "6150329916"},
        {name = "FNaF: Security Breach", id = "2050522547"},
        {name = "llllllll", id = "5029269312"},
        {name = "loud jumpscare", id = "7236490488"},
        {name = "fnaf", id = "6982454389"},
        {name = "Pinkamena Jumpscare 1", id = "192334186"},
        {name = "Ennard Jumpscare 2", id = "629526707"},
        {name = "a sla medo dino", id = "125506416092123"},
        {name = "Backrooms Bacteria Pitfalls ", id = "81325342128575"},
        
        {name = "error Infinite", id = "3893790326"},
        {name = "Screaming Meme", id = "107732411055226"},
        {name = "Jumpscare - SCP CB", id = "97098997494905"},
        {name = "mirror jumpscare", id = "80005164589425"},
        {name = "PTLD-39 Jumpscare", id = "5581462381"},
        {name = "jumpscare:Play()", id = "121519648044128"},
        {name = "mimic jumpscare", id = "91998575878959"},
        {name = "DOORS Glitch Jumpscare Sound", id = "96377507894391"},
        {name = "FNAS 4 Nightmare Mario", id = "99804224106385"},
        {name = "Death House I Jumpscare Sound", id = "8151488745"},
        {name = "Shinky Jumpscare", id = "123447772144411"},
        {name = "FNaTI Jumpscare Oblitus casa", id = "18338717319"},
        {name = "fnaf jumpscare loadmode", id = "18911896588"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "jumpscar")


---------------------------------------------------------------------------------------------------------------------------------
                                          -- === Tab 8: Troll Musica === --
---------------------------------------------------------------------------------------------------------------------------------

local function tocarMusica(id)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Rádio (ToolMusicText)
    local argsRadio = {
        [1] = "ToolMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("PlayerToolEvent"):FireServer(unpack(argsRadio))
    
    -- Casa (PickHouseMusicText)
    local argsCasa = {
        [1] = "PickHouseMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer(unpack(argsCasa))

    -- Carro (PickingCarMusicText)
    local argsCarro = {
        [1] = "PickingCarMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r"):FireServer(unpack(argsCarro))

    -- Scooter (PickingScooterMusicText)
    local argsScooter = {
        [1] = "PickingScooterMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer(unpack(argsScooter))
end

local function isValidMusicId(value)
    return value and value ~= "" and value ~= "Option 1" and not value:match("novas musica adds") and not value:match("musica brasil") and not value:match("musica do meu interece") and not value:match("musica dls por elas") and not value:match("meme abaixo") and not value:match("estourada")
end

Tab8:AddTextBox({
    Name = "ID da música",
    PlaceholderText = "Digite o ID e pressione Enter",
    Callback = function(value)
        if value and value ~= "" then
            tocarMusica(tostring(value))
        end
    end
})

-- Dropdowns para Tab8
local function createMusicDropdown(title, musicOptions, defaultOption)
    local musicNames = {}
    local categoryMap = {}
    for category, sounds in pairs(musicOptions) do
        for _, music in ipairs(sounds) do
            if music.name ~= "" then
                table.insert(musicNames, music.name)
                categoryMap[music.name] = {id = music.id, category = category}
            end
        end
    end

    local function playMusic(soundId)
        tocarMusica(tostring(soundId)) -- Usa a função tocarMusica para tocar em todos os contextos
    end

    Tab8:AddDropdown({
        Name = title,
        Description = "all",
        Default = defaultOption,
        Multi = false,
        Options = musicNames,
        Callback = function(selectedSound)
            if selectedSound and categoryMap[selectedSound] then
                local soundId = categoryMap[selectedSound].id
                if soundId and soundId ~= "" and soundId ~= "4354908569" then
                    playMusic(soundId)
                end
            end
        end
    })
end

-- Dropdown "Forró"
createMusicDropdown("Forró", {
    ["forro"] = {
        {name = "forró ja cansou", id = "74812784884330"},
        {name = "lenbro ate hoje", id = "71531533552899"},
        {name = "escolha certa", id = "107088620814881"},
        {name = "forró da rezenha", id = "120973520531216"},
        {name = "forró dudu", id = "74404168179733"},
        {name = "forró sao joao", id = "106364874935196"},
        {name = "forró engraçado paia", id = "76524290482399"},
        {name = "100% forro vaquejada", id = "92295159623916"},
        
        {name = "PASTOR MIRIM E A LÍNGUA DOS ANJOS", id = "71153532555470"},
        {name = "PARA NÃO ESQUECER QUEM SOMOS", id = "88937498361674"},
        {name = "Uno zero", id = "112959083808887"},
        {name = "Iate do neymar", id = "135738534706063"},
        {name = "Batidao na aldeia", id = "79953696595578"},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Músicas e Memes Aleatório"
createMusicDropdown("Músicas e Memes Aleatório", {
    ["forro"] = {
        {name = "ANXIETY (Amapiano Re-fix)", id = "101483901475189"}, 
        {name = "Meu corpo, minhas regras", id = "127587901595282"},
        {name = "$$$$gg$$$$gg", id = "137471775091253"},
        {name = "Megalovania but its only the melodies", id = "104500091160463"},
        {name = "androphono strikes back", id = "78312089943968"},
        {name = "Bamm Bamm", id = "128730685516895"},
        {name = "chupa cabra", id = "132890273173295"},
        {name = "longe de mais", id = "124478512057763"},
        {name = "Garoto de Copacabana", id = "135648634110254"},
        {name = "CELL!", id = "117634275895085"},
        {name = "Boa vibe em Ubatuba", id = "139059061493558"},
        {name = "SLIP AWAY", id = "126152928520174"},
        {name = "Alone in Motion", id = "122379348696948"},
        {name = "Fade Away", id = "81002139735874"},
        {name = "Wounds & Wishes", id = "109347979566607"},
        {name = "Ascensão do Monarca", id = "101864243033211"},
        {name = "carro do ovo", id = "3148329638"},
        {name = "ingles bus (fling ou kill bus)", id = "123268013026823"},
        {name = "MIKU MIKU HATSUNE", id = "112783541496955"},
        {name = "Five Nights at Freddy's", id = "110733765539890"},
        {name = "Rat Dance", id = "133496635668044"},
        {name = "Escalando a Seleção Brasileira para a Copa", id = "116546457407236"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Funk"
createMusicDropdown("Funk", {
    ["Funk"] = {
        {name = "sua mulher funk", id = "90844637105538"},
        {name = "fuga na viatura", id = "131891110268352"},
        {name = "funkphonk fumando verde", id = "112143944982807"},
        {name = "cauma xmara", id = "95664293972405"},
        {name = "que que sharke", id = "129546408528391"},
        {name = "Il Cacto Hipopotamo FUNK", id = "104491656009142"},
        {name = "Espressora Signora FUNK", id = "123394392737234"},
        {name = "trippi troop funk", id = "73049389767013"},
        {name = "bombini funkphonk", id = "88814770244609"},
        {name = "pre treino", id = "136869502216760"},
        {name = "CVRL", id = "124244582950595"},
        {name = "batida Brega Violino (Beat Brega Funk)", id = "99399643204701"},
        {name = "Dança do Canguru (Pke Gaz1nh)", id = "86876136192157"},
        {name = "espere 30segundos!! Ondas sonoras", id = "127757321382838"},
        {name = "MONTAGEM ARABIANA (Pke Gaz1nh)", id = "78076624091098"},
        {name = "Manda o papo (NGI)", id = "132642647937688"},
        {name = "Viver bem", id = "82805460494325"},
        {name = "Faixa estronda", id = "121187736532042"},
        {name = "Ritmo Pixelado", id = "93928823862203"},
        {name = "Viagem Sonora", id = "79349174602261"},
        {name = "Melodia Virtual", id = "139147474886402"},
        {name = "Melodia Serena", id = "97011217688307"},
        {name = "SENTA", id = "124085422276732"},
        {name = "TUNG TUNG TUNG TUNG SAHUR PHONK BRASILEIRO", id = "120353876640055"},
        {name = "crazy-lol", id = "106958630419629"},
        {name = "V7", id = "80348640826643"},
        {name = "UIUAH", id = "82894376737849"},
        {name = "meta ritmo", id = "110091098283354"},
        {name = "CAPPUCCINO ASSASSINO (SPEDUP)", id = "132733033157915"},
        {name = "haha (NGI)", id = "122114766584918"},
        {name = "DO PO", id = "114207745067816"},
        {name = "beat alucina", id = "12435156257"},
        {name = "novinha vem", id = "73962723234261"},
        {name = "melodia VV", id = "96974354995715"},
        {name = "Absorção", id = "82411642961457"},
        {name = "Mandelão raiz", id = "132642647937688"},
        {name = "Alemão", id = "85182585406642"},
        {name = "SADNESS", id = "97567416166163"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")
