local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasgbw/Frostzxx7-hub/refs/heads/main/README.md"))()

local Window = redzlib:MakeWindow({

  Title = "Neomi hub💰",

  SubTitle = "by Pombadelux, luckystarz",

  SaveFolder = "testando | redz lib v5.lua"

})

Window:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://82010511141880", -- imagem do botão
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 60, 0, 60)
    },
    Corner = {
        CornerRadius = UDim.new(0, 15) -- deixa arredondado tipo "squirrel"
    }
})

-- ID do som a ser reproduzido quando o código for executado
local soundId = "rbxassetid://113190382670194"

-- Função para tocar o som
local function playSound()
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = game.Workspace -- Coloque no Workspace para garantir que seja ouvido
    sound:Play()
end

-- Tocar o som assim que o script for executado
playSound()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

-- === CONFIG ===
local LineCount = 4
local Radius = 7
local LineLength = 15
local NeonRed = Color3.fromRGB(255, 0, 60) -- vermelho neon suave
local Black = Color3.fromRGB(0, 0, 0)
local LabelText = "legend"

-- === CROSSHAIR OBJECTS ===
local CrosshairLines = {}

for i = 1, LineCount do
	local line = Drawing.new("Line")
	line.Color = NeonRed
	line.Thickness = 2.5
	line.Visible = true
	table.insert(CrosshairLines, line)
end

local Dot = Drawing.new("Circle")
Dot.Radius = 3
Dot.Filled = true
Dot.Color = NeonRed
Dot.Visible = true

-- Borda preta pra dar efeito neon
local DotOutline = Drawing.new("Circle")
DotOutline.Radius = 5
DotOutline.Filled = false
DotOutline.Thickness = 2
DotOutline.Color = Black
DotOutline.Visible = true

local Label = Drawing.new("Text")
Label.Text = LabelText
Label.Size = 18
Label.Center = true
Label.Outline = true
Label.Color = NeonRed
Label.Visible = true
Label.Font = 2

-- === MOUSE HIDING ===
local function hideMouse()
	UserInputService.MouseIconEnabled = false
end

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	hideMouse()
end)

hideMouse()

-- === MAIN ANIMATION LOOP ===
local angle = 0
RunService.RenderStepped:Connect(function()
	local mousePos = UserInputService:GetMouseLocation()
	local center = Vector2.new(mousePos.X, mousePos.Y)

	for i, line in ipairs(CrosshairLines) do
		local a = angle + (math.pi * 2 / LineCount) * (i - 1)
		local from = Vector2.new(center.X + math.cos(a) * Radius, center.Y + math.sin(a) * Radius)
		local to = Vector2.new(center.X + math.cos(a) * (Radius + LineLength), center.Y + math.sin(a) * (Radius + LineLength))
		line.From = from
		line.To = to
	end

	-- Dot neon (preto por fora + vermelho dentro)
	Dot.Position = center
	DotOutline.Position = center

	-- Label abaixo
	Label.Position = Vector2.new(center.X, center.Y + 28)

	-- animação girando
	angle += 0.05
end)


local Tab1 = Window:MakeTab({"Player", "user"})

Tab1:AddSlider({
  Name = "velocidade 🏁",
  Min = 1,
  Max = 100,
  Increase = 1,
  Default = 16,
  Callback = function(Value)
    -- Obtém o jogador local
    local player = game.Players.LocalPlayer
    -- Verifica se o personagem existe
    if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
      -- Define a velocidade de caminhada do humanoide para o valor do slider
      player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
    end
  end
})

Tab1:AddSlider({
  Name = "Pulo🦘",
  Min = 1,
  Max = 100,
  Increase = 1,
  Default = 16,
  Callback = function(Value)
    -- Obtém o jogador local
    local player = game.Players.LocalPlayer
    -- Verifica se o personagem existe
    if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
      local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
      humanoid.WalkSpeed = Value
      humanoid.JumpPower = Value -- Agora o pulo também ajusta conforme o slider
    end
  end
})

local fovValue = 70 -- valor padrão do FOV

Tab1:AddTextBox({
  Name = "Fov player👁️",
  Description = "", 
  PlaceholderText = "99999",
  Callback = function(Value)
    -- Armazena o valor do TextBox em uma variável global/local
    fovValue = tonumber(Value) or 70
  end
})

Tab1:AddButton({
  Name = "Fov",
  Callback = function()
    -- Aplica o FOV na câmera do jogador
    local camera = workspace.CurrentCamera
    if camera and typeof(fovValue) == "number" then
      camera.FieldOfView = fovValue
    end
  end
})

local Section = Tab1:AddSection({"Exclusivo 🔋"})

Tab1:AddButton({"Chat bypass🔋 (você pode escrever no chat sem HASHTAGS.)", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-byterpass-CHAT-BYPASSER-47366"))()
end})

Tab1:AddButton({"esp script🔋(ver jogadores criado por mim)", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Utility-esp-46427"))()
end})

local Section = Tab1:AddSection({"--FLY SCRIPTS🦅--"})

Tab1:AddButton({"Fly gui🦅", function(Value)
print("Hello World!")getgenv().rotationSpeed = 0.08

loadstring(game:HttpGet("https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/BetterFlyGUI.lua"))()

end})

Tab1:AddButton({"Fly gui VH🦅", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://fromhatai.neocities.org/Fly.lua"))()

end})

Tab1:AddButton({"fly Gui V2🦅", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Hotdog120823/FlyGuiV2/refs/heads/main/FlyGui"))()

end})

Tab1:AddButton({"Fly Gui v3🦅 ", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

end})

Tab1:AddButton({"fly Gui v4🦅", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/RileyBeeRBLX5/Script/refs/heads/main/FlyGuiV4.lua"))()

end})

Tab1:AddButton({"fly Gui v5🦅", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Hotdog120823/FlyGuiV5/refs/heads/main/FlyGui"))()

end})

Tab1:AddButton({"fly Gui v7🦅", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/RealBatu20/AI-Scripts-2025/refs/heads/main/FlyGUI_v7.lua", true))()
end})

local Section = Tab1:AddSection({"🩸Scripts criados por mim!🩸"})

Tab1:AddButton({"Fire hub🩸", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasgbw/FIREHUB_2025/refs/heads/main/README.md"))()
end})

Tab1:AddButton({"neo pixel hub🩸", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/67961fd773468f6da2d42ae30859ee56"))()

end})

Tab1:AddButton({"Saturno hub🩸 brookhaven", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasgbw/saturno-hub-new-2025/refs/heads/main/README.md"))()

end})

Tab1:AddButton({"☄️Dinamicus hub ☄️ brookhaven🩸", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/e941b180042e0e83668d25685101e12d"))()
end})

local Tab1 = Window:MakeTab({"👋Bem vindos👋", "cherry"})


Tab1:AddDiscordInvite({
    Name = "Discord server",
    Description = "entrem no server",
    Logo = "rbxassetid://96688638199828",
    Invite = "https://discord.gg/UdDB7eCYT9",
})

local Paragraph = Tab1:AddParagraph({"Sejam vindos!🔱", "🔱Luckystarz hub🔱"})

local Paragraph = Tab1:AddParagraph({"Aqui você encontra..", "scripts de Brookhaven,universal, blox fruits, steal a brainrot, blox fruits,grow a garden em breve!"})

local Tab1 = Window:MakeTab({"EXECUTORES☠️", "cherry"})

local Paragraph = Tab1:AddParagraph({"ATENÇÃO ⚠️⚠️", "Se você quiser o delta e for clicar no botão do delta, vai aparecer um link copiado no seu teclado(mobile) entre no seu navegador(qualquer um) e cole o link copiado e já tá baixando seu executor!!👾"})

Tab1:AddDiscordInvite({
    Name = "DELTA EXECUTOR ATUALIZADO!!👾",
    Description = "👇👇👇👇",
    Logo = "rbxassetid://80760485810776",
    Invite = "https://cdngloopup.cc/delta_android/",
})

Tab1:AddDiscordInvite({
    Name = "KRNL EXECUTOR ATUALIZADO!!👾",
    Description = "👇👇👇👇",
    Logo = "rbxassetid://94692985192322",
    Invite = "https://wrdcdn.net/r/54921/1754432648085/krnl_release_2.684.688_2025.8.6_41.apk",
})

Tab1:AddDiscordInvite({
    Name = "RONIX EXECUTOR ATUALIZADO!!👾",
    Description = "Clique aqui!",
    Logo = "rbxassetid://93096230936357",
    Invite = "https://wrdcdn.net/r/154522/1754357527605/Ronix_684_(arm64).apk",
})

Tab1:AddDiscordInvite({
    Name = "RONIX EXECUTOR ATUALIZADO!!👾(PARA PC)",
    Description = "Clique aqui!",
    Logo = "rbxassetid://93096230936357",
    Invite = "https://wrdcdn.net/r/154522/1754777066094/release%20(4).zip",
})

Tab1:AddDiscordInvite({
    Name = "ARCEUS X V5 ATUALIZADO!!👾",
    Description = "ARCEUS X",
    Logo = "rbxassetid://75104002795867",
    Invite = "https://arceusx.com/",
})

local Tab1 = Window:MakeTab({"Universal🌐", "triangle"})

Tab1:AddButton({"Painel deluxe🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/e99aa838a2383cf38e91b9367a723324"))()

end})

Tab1:AddButton({"Chat spam🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Spam-Chat-from-caruno-19546"))()

end})

Tab1:AddButton({"esp🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/d1b495c9c6553ef2160d798b60fb17b9"))()

end})

Tab1:AddButton({"fly gui🔱", function(Value)

print("Hello World!")getgenv().rotationSpeed = 0.08

loadstring(game:HttpGet("https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/BetterFlyGUI.lua"))()

end})

Tab1:AddButton({"System broken🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-System-broken-script-32501"))()

end})

Tab1:AddButton({"Dex explorer🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-dex-explorer-working-32529"))()

end})

Tab1:AddButton({"painel de colocar musica nos carros (Brookhaven)🔰", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://pastefy.app/utKST1CY/raw"))()
end})

Tab1:AddButton({"Abacate executor executor🔱", function(Value)

print("Hello World!")-- Executor de Script com Imagem ao Lado (Saturno)

-- Coloque este LocalScript dentro de StarterGui

local SaturnYellow = Color3.fromRGB (0, 255, 0)

local SaturnBrown = Color3.fromRGB(34, 139, 34)

local SaturnIcon = "rbxassetid://15466359812" -- Ícone Saturno (canto)

local SideImageId = "rbxassetid://83621666834480" -- Imagem decorativa ao lado (altere para o que quiser)

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui", player.PlayerGui)

gui.Name = "SaturnExecutor"

gui.ResetOnSpawn = false

-- Main container (maior para caber a imagem ao lado)

local main = Instance.new("Frame", gui)

main.Size = UDim2.new(0, 600, 0, 280)

main.Position = UDim2.new(0.5, -300, 0.5, -140)

main.BackgroundColor3 = SaturnYellow

main.BorderSizePixel = 0

main.Active = true

main.Draggable = true

local mainCorner = Instance.new("UICorner", main)

mainCorner.CornerRadius = UDim.new(0, 18)

-- Frame da interface (esquerda)

local leftFrame = Instance.new("Frame", main)

leftFrame.Size = UDim2.new(0, 460, 1, 0)

leftFrame.Position = UDim2.new(0, 0, 0, 0)

leftFrame.BackgroundTransparency = 1

-- Barra de título

local titleBar = Instance.new("Frame", leftFrame)

titleBar.Size = UDim2.new(1, 0, 0, 42)

titleBar.Position = UDim2.new(0, 0, 0, 0)

titleBar.BackgroundColor3 = Color3.fromRGB(168, 144, 51)

titleBar.BorderSizePixel = 0

titleBar.Name = "TitleBar"

local titleBarCorner = Instance.new("UICorner", titleBar)

titleBarCorner.CornerRadius = UDim.new(0, 16)

-- Ícone Saturno

local icon = Instance.new("ImageLabel", titleBar)

icon.Size = UDim2.new(0, 34, 0, 34)

icon.Position = UDim2.new(0, 6, 0, 4)

icon.BackgroundTransparency = 1

icon.Image = SaturnIcon

-- Título

local title = Instance.new("TextLabel", titleBar)

title.Size = UDim2.new(1, -60, 1, 0)

title.Position = UDim2.new(0, 46, 0, 0)

title.BackgroundTransparency = 1

title.Text = "Abacate executor"

title.Font = Enum.Font.GothamBold

title.TextSize = 24

title.TextColor3 = SaturnBrown

title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Minimizar

local minBtn = Instance.new("TextButton", titleBar)

minBtn.Size = UDim2.new(0, 32, 0, 32)

minBtn.Position = UDim2.new(1, -74, 0, 5)

minBtn.BackgroundColor3 = Color3.fromRGB(255, 223, 106)

minBtn.Text = "-"

minBtn.Font = Enum.Font.GothamBold

minBtn.TextSize = 24

minBtn.TextColor3 = SaturnBrown

local minBtnCorner = Instance.new("UICorner", minBtn)

minBtnCorner.CornerRadius = UDim.new(0, 8)

-- Botão Fechar

local closeBtn = Instance.new("TextButton", titleBar)

closeBtn.Size = UDim2.new(0, 32, 0, 32)

closeBtn.Position = UDim2.new(1, -36, 0, 5)

closeBtn.BackgroundColor3 = Color3.fromRGB(255, 124, 124)

closeBtn.Text = "X"

closeBtn.Font = Enum.Font.GothamBold

closeBtn.TextSize = 20

closeBtn.TextColor3 = SaturnBrown

local closeBtnCorner = Instance.new("UICorner", closeBtn)

closeBtnCorner.CornerRadius = UDim.new(0, 8)

-- Caixa de Script

local scriptBox = Instance.new("TextBox", leftFrame)

scriptBox.Size = UDim2.new(0.95, 0, 0, 120)

scriptBox.Position = UDim2.new(0.025, 0, 0.22, 0)

scriptBox.BackgroundColor3 = Color3.fromRGB(255, 245, 200)

scriptBox.TextColor3 = SaturnBrown

scriptBox.Font = Enum.Font.Code

scriptBox.TextSize = 18

scriptBox.Text = "Coloque seu script aqui"

scriptBox.ClearTextOnFocus = false

scriptBox.MultiLine = true

scriptBox.TextWrapped = true

scriptBox.TextXAlignment = Enum.TextXAlignment.Left

scriptBox.TextYAlignment = Enum.TextYAlignment.Top

local scriptCorner = Instance.new("UICorner", scriptBox)

scriptCorner.CornerRadius = UDim.new(0, 8)

-- Botão Executar

local execBtn = Instance.new("TextButton", leftFrame)

execBtn.Size = UDim2.new(0.35, 0, 0, 38)

execBtn.Position = UDim2.new(0.11, 0, 0.76, 0)

execBtn.BackgroundColor3 = Color3.fromRGB(181, 148, 39)

execBtn.Text = "Executar"

execBtn.Font = Enum.Font.GothamSemibold

execBtn.TextSize = 20

execBtn.TextColor3 = Color3.fromRGB(255,255,255)

local execBtnCorner = Instance.new("UICorner", execBtn)

execBtnCorner.CornerRadius = UDim.new(0, 8)

-- Botão Limpar

local clearBtn = Instance.new("TextButton", leftFrame)

clearBtn.Size = UDim2.new(0.35, 0, 0, 38)

clearBtn.Position = UDim2.new(0.54, 0, 0.76, 0)

clearBtn.BackgroundColor3 = Color3.fromRGB(208, 184, 86)

clearBtn.Text = "Limpar"

clearBtn.Font = Enum.Font.GothamSemibold

clearBtn.TextSize = 20

clearBtn.TextColor3 = SaturnBrown

local clearBtnCorner = Instance.new("UICorner", clearBtn)

clearBtnCorner.CornerRadius = UDim.new(0, 8)

-- Resultado

local resultLabel = Instance.new("TextLabel", leftFrame)

resultLabel.Size = UDim2.new(0.95, 0, 0, 27)

resultLabel.Position = UDim2.new(0.025, 0, 0.63, 0)

resultLabel.BackgroundTransparency = 1

resultLabel.Text = ""

resultLabel.TextColor3 = SaturnBrown

resultLabel.Font = Enum.Font.Gotham

resultLabel.TextSize = 16

resultLabel.TextWrapped = true

-- Imagem decorativa ao lado (direita)

local sideImage = Instance.new("ImageLabel", main)

sideImage.Size = UDim2.new(0, 120, 0, 120)

sideImage.Position = UDim2.new(0, 470, 0.5, -60)

sideImage.BackgroundTransparency = 1

sideImage.Image = SideImageId

-- Minimizar funcionalidade

local minimized = false

minBtn.MouseButton1Click:Connect(function()

    minimized = not minimized

    if minimized then

        scriptBox.Visible = false

        execBtn.Visible = false

        resultLabel.Visible = false

        clearBtn.Visible = false

        main.Size = UDim2.new(0, 600, 0, 56)

        sideImage.Visible = false

    else

        scriptBox.Visible = true

        execBtn.Visible = true

        resultLabel.Visible = true

        clearBtn.Visible = true

        main.Size = UDim2.new(0, 600, 0, 280)

        sideImage.Visible = true

    end

end)

-- Fechar funcionalidade

closeBtn.MouseButton1Click:Connect(function()

    gui:Destroy()

end)

-- Limpar funcionalidade

clearBtn.MouseButton1Click:Connect(function()

    scriptBox.Text = ""

    resultLabel.Text = ""

end)

-- Execução de scripts

execBtn.MouseButton1Click:Connect(function()

    local scriptToRun = scriptBox.Text

    resultLabel.Text = ""

    if scriptToRun:lower():find("game:shutdown") or scriptToRun:lower():find("while true do") then

        resultLabel.Text = "Script bloqueado por segurança."

        return

    end

    local success, err = pcall(function()

        loadstring(scriptToRun)()

    end)

    if success then

        resultLabel.Text = "Script executado com sucesso!"

    else

        resultLabel.Text = "Erro: " .. tostring(err)

    end

end)

-- Arrastar pela barra de título (melhor do que por toda a janela)

local UIS = game:GetService("UserInputService")

local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true

        dragStart = input.Position

        startPos = main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then

                dragging = false

            end

        end)

    end

end)

titleBar.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement then

        dragInput = input

    end

end)

UIS.InputChanged:Connect(function(input)

    if input == dragInput and dragging then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

    end

end)

end})

Tab1:AddButton({"Fe ring🔱", function(Value)

print("Hello World!")--super ring v3.5 update 

loadstring(game:HttpGet("https://pastebin.com/raw/q6Sv8qK3"))() 

end})

Tab1:AddButton({"Blackhole🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Best-Blackhole-script-23680"))()

end})

Tab1:AddButton({"Infinite yield 🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

end})

Tab1:AddButton({"Shiftlock🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://pastebin.com/raw/6ShMYvki"))()end})

Tab1:AddButton({"nameless admin Rework!🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()end})

Tab1:AddButton({"God mode🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()end})

Tab1:AddButton({"Fe emotes🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://yarhm.mhi.im/scr?channel=afem", false))()end})

Tab1:AddButton({"Music player🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source'))()Ioad('7208e39603889391caf77f6ff7d21e01')()end})

Tab1:AddButton({"Speed gui🔱", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/e31dcfa2d2f980f9e0753520a8671287"))()

end})

Tab1:AddButton({"aimbot script🔱", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://pastebin.com/raw/qtZt0Nzb"))()
end})

Tab1:AddButton({"SIGMA spy🔱", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Sigma-Spy/refs/heads/main/Main.lua"))()

end})

Tab1:AddButton({"anti fling🔱", function(Value)
print("Hello World!")--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
    Anti-Fling & Anti-Sit Script (One-Time Check)
    ---------------------------------------------
    1. Prevents being flung by moving unanchored parts.
       - Checks all unanchored parts not part of your character.
       - If moving faster than 16 studs/sec (linear) OR spinning faster than 70 rad/sec (rotational), disables collisions.

    2. Disables sitting entirely for your character.
       - Uses Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
       - Prevents forced sitting from seats or scripts.

    3. Uses getgenv().AntiFlingRunning to ensure the script only starts once.
    4. Notifies when protection is enabled or already running.
--]]

local StarterGui = game:GetService("StarterGui")

if getgenv().AntiFlingRunning then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Anti-Fling",
            Text = "Script is already running",
            Duration = 3
        })
    end)
    return
end
getgenv().AntiFlingRunning = true

local checkDelay = 0.1 -- more if you're laggy

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Disable sitting
humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

-- Notify
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Anti-Fling",
        Text = "Protection Enabled",
        Duration = 3
    })
end)
end})



local Tab1 = Window:MakeTab({"Scripts brookhaven rp 🏡", "Brookhaven rp"})

Tab1:AddButton({"Tiger x🏡 ", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Tiger-X-39488"))()
end})

Tab1:AddButton({"all freeze all kill🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-FREEZE-ALL-FE-SOUND-MAP-KILL-NO-KEY-45235"))()

end})

Tab1:AddButton({"saturno hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasgbw/saturno-hub-new-2025/refs/heads/main/README.md"))()

end})

Tab1:AddButton({"Demonz hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Projects/main/Protected_7879157622599299.lua.txt"))()

end})

Tab1:AddButton({"Coquette hub🏡🎀", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Daivd977/Deivd999/refs/heads/main/pessal"))()

end})

Tab1:AddButton({"Nytherune Hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/wx-sources/spacecomm/refs/heads/main/nytheruneplus"))()

end})

Tab1:AddButton({"Braxus hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Lindao10/BRUXUS-HUB/refs/heads/main/BRUXUS%20HUB.LUA"))()

end})

Tab1:AddButton({"Uwu hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Execute666j/TESTE/refs/heads/main/zinac%20luraph.txt"))()

end})

Tab1:AddButton({"SP hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven"))()

end})

Tab1:AddButton({"K.O hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/MS7top/Diverse/refs/heads/main/Krar.txt"))()

--[[

Not The Best But This Is Good For The First Time

  Gui By Krar

]]

end})

Tab1:AddButton({"R4D hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script'))()

end})

Tab1:AddButton({"zoe🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet(("https://raw.githubusercontent.com/martinng5/martin/refs/heads/main/Protected_7412983690886157.lua.txt")))()

end})

Tab1:AddButton({"TrollX hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmidd409/I606n_lio/refs/heads/main/Hi-hi"))()

end})

Tab1:AddButton({"Ghim hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/mhmdsx/Ghim/refs/heads/main/Protected_7584917074525196.lua.txt"))()

end})

Tab1:AddButton({"gumball hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/JaozinScripts/Gumball-Hub/refs/heads/main/GumballHubRetorn2.1.1.1.lua"))()

end})

Tab1:AddButton({"Gvtz hub🏡", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://pastefy.app/jOuhpYUJ/raw"))()

end})

Tab1:AddButton({"SHNAMX HUB🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/joelmadasilvademorais-glitch/Fffgy/refs/heads/main/SHNMAX%20Texto.txt"))()

end})

Tab1:AddButton({"CYA HUB🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/PHGS971/CYA-STUDIOS-HUB-BROOKHAVEN-v1.1/refs/heads/main/CYA-STUDIOS%20HUB.lua"))()

end})

Tab1:AddButton({"Krware hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/dabpaul/KRWARE-hub/refs/heads/main/KRWare%20Hub%20Loader.lua"))()

end})

Tab1:AddButton({"music player green(precisa de gamepass)🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/ecaee11da56acbbc6c187dcdda7557a5"))()

end})

Tab1:AddButton({"Vodica hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Super-XXX-Source/VODICA-V3.4/refs/heads/main/Brookhaven%20Gui"))()

end})

Tab1:AddButton({"Fúria Hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Dboas123432sx/bsx_hub/refs/heads/main/FURIAHUB-v1"))()

end})

Tab1:AddButton({"SANDER x", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/kigredns/testUIDK/refs/heads/main/panel.lua"))()

end})


Tab1:AddButton({"Chaos Hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Venom-devX/ChaosHub/main/loader.lua"))();

end})

Tab1:AddButton({"brutos hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/codenixstudios/brutus-hub/script/Games/brookhaven.lua"))()
end})

Tab1:AddButton({"STELARUS hub🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/hamsterdev9/StelariumHubs/refs/heads/main/StelariumObfuscated.lua"))()

end})

Tab1:AddButton({"☄️Dinamicus Hub☄️(beta)🏡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/e941b180042e0e83668d25685101e12d"))()
end})

local Tab1 = Window:MakeTab({"🍈blox fruits🍈", "apple"})

Tab1:AddButton({"BEST SCRIPT FOR BLOX FRUITS!🍈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"))() 

end})

Tab1:AddButton({"mukuro hub🍈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/QuartyzScript/main/Loader.lua"))()

end})

Tab1:AddButton({"cokka hub🍈", function(Value)

print("Hello World!")loadstring(game:HttpGet"https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")()

end})

Tab1:AddButton({"Nexon hub🍈", function(Value)

print("Hello World!")repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().Team = "Pirates" -- Marines

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/bf92d246f65d7d0e0d684a81d4e59fa3.lua"))()

end})

Tab1:AddButton({"Speed Hub x🍈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()

end})

local Tab1 = Window:MakeTab({"Steal a brainrot🦈", "square"})

Tab1:AddButton({"moon hub🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/KaspikScriptsRb/steal-a-brainrot/refs/heads/main/.lua'))()

end})

Tab1:AddButton({"LURK V4🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Steal-a-Brainrot-steal-a-brainrot-LURK-V4-BEST-SCRIPT-43956"))()

end})

Tab1:AddButton({"Sw1ft🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://oreofdev.github.io/Sw1ftSync/Raw/SSXBr/"))()

end})

Tab1:AddButton({"steal a brainrot script🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/m00ndiety/Steal-a-brainrot/refs/heads/main/Steal-a-Brainrot'))()

end})

Tab1:AddButton({"best script for steal a brainrot 🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/7d8a2a1a9a562a403b52532e58a14065.lua"))()

end})

Tab1:AddButton({"NOXHUB🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/VayziYT/Steal-a-Brainrot-Rayfield/refs/heads/main/StealABrainrot"))()

end})

Tab1:AddButton({"chilii hub🦈", function(Value)

print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()

end})

local Tab1 = Window:MakeTab({"Build a BOAT for teasure⛵🗝️", "boat"})

Tab1:AddButton({"ultimate  B3BFT⛵🗝️", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Build-A-Boat-For-Treasure-Ultimte-B3BFT-Script-28601"))()
end})


Tab1:AddButton({"ther hub⛵🗝️", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"))()
end})

Tab1:AddButton({"auto Farm ⛵🗝️", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://pastebin.com/raw/jaSMzAMj"))()

end})

  

local Section = Tab1:AddSection({"Em breve..."})



local Tab1 = Window:MakeTab({"👩‍🌾Grow a garder", "circle"})

Tab1:AddButton({"Grow a garden script👩‍🌾", function(Value)

print("Hello World!")-- //discord.gg/wZ4hBXSrxY

loadstring(game:HttpGet('https://raw.githubusercontent.com/m00ndiety/Grow-a-garden/refs/heads/main/Grow-A-fkin-Garden.txt'))()

end})

Tab1:AddButton({"Best script Grow a garden 👩‍🌾", function(Value)
print("Hello World!")
end})

Tab1:AddButton({"blackhub auto👩‍🌾", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/FischMain"))() 

end})

local Tab1 = Window:MakeTab({"99 NOITES NA FLORESTA🌲👻", "cherry"})

Tab1:AddButton({"VEX OP🌲👻", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/yoursvexyyy/VEX-OP/refs/heads/main/99%20nights%20in%20the%20forest"))()
end})

Tab1:AddButton({"H4X HUB🌲👻", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", true))()
end})

Tab1:AddButton({"script 99 nuggets🌲👻", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptCentral-br/SCU/refs/heads/main/sc.md",true))()
end})

Tab1:AddButton({"huntao hub🌲👻", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://soluna-script.vercel.app/99-Nights-in-the-Forest.lua",true))()
end})

Tab1:AddButton({"STELARUS HUB🌲👻", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://github.com/contateste8/StelariumXS99NightsInTheForest/raw/refs/heads/main/StelariumXS99NightsInTheForest.lua"))()

end})

local Tab1 = Window:MakeTab({"Vox seas⚡", "cherry"})

Tab1:AddButton({"Vellure hub⚡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/NyxaSylph/Vellure/refs/heads/main/Loader.lua"))()

end})

Tab1:AddButton({"auto chest⚡", function(Value)
print("Hello World!")_G._hello_la_xin_chao = {
    ["Team"] = "Pirate", -- or Marine (Auto choose selcted team)
    ["Hop"] = true, -- or fasle (Hop if there are no more chests)
    ["FPS"] = true, -- or false (Run a graphics reduction script)
    ["Webhook"] = "" -- (Send webhook before hop)
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/meobeo8/type/main/VoxSeasAutoChest.lua"))()

end})

Tab1:AddButton({"Brutus hub⚡", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://raw.githubusercontent.com/codenixstudios/brutus-hub/BRUTUS_TEAM/Games/VoxSeas.lua"))()

end})


local Tab1 = Window:MakeTab({"Animações FE🕺💃", "cherry"})



Tab1:AddButton({"jrk of🕺", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end})

Tab1:AddButton({"r15 silly car🕺", function(Value)
print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/Unkn0wnKnown/Silly-Car-FE/refs/heads/main/Silly%20Car%20FE'))()

end})

Tab1:AddButton({"Golden Freddy 🕺", function(Value)
print("Hello World!")loadstring(game:HttpGet('https://raw.githubusercontent.com/Unkn0wnKnown/Golden-Freddy-FE/refs/heads/main/Golden%20Freddy%20FE'))()
end})

Tab1:AddButton({"Fe emotes universal 🕺", function(Value)
print("Hello World!")loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-900-Animations-R15-48323"))()
end})    


     
