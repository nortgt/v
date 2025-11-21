print("Thunder Hub MM2 Loading...")
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.52/main.lua"))()

function missing(type_str, value, default)
	if type(value) == type_str then
		return value
	end
	return default
end

newflyspeed = 50
local flyCharacter = nil
local flyHumanoid = nil
local flyBodyVelocity = nil
local flyBodyAngularVelocity = nil
local flyCamera = nil
local isFlying = false
local flyConnection = nil
local flyMovement = {
	W = false,
	S = false,
	A = false,
	D = false,
	Moving = false
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getExecutorName = identifyexecutor or getexecutorname or function()
	return "Another Executor 1.2"
end
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

function sendnotification(content)
	WindUI:Notify({
		Title = "Thunder Hub MM2",
		Content = content,
		Icon = "scroll-text",
		Duration = 3,
		Background = "rbxassetid://116379998454359"
	})
end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
FlingPower = 70000
proverka = false
AllBool = false
permit = false
moveSpeed = 25
local LocalCharacter = LocalPlayer.Character
local LocalHumanoid = LocalCharacter and LocalCharacter:FindFirstChildOfClass("Humanoid")

function getOrCreatesusSound()
	local susSound = ReplicatedStorage:FindFirstChild("susSound")
	if not susSound then
		susSound = Instance.new("Sound")
		susSound.Name = "susSound"
		susSound.SoundId = "rbxassetid://2027986581"
		susSound.Parent = ReplicatedStorage
	end
	return susSound
end

local susSound = getOrCreatesusSound()

function startFly()
	if not LocalPlayer.Character or not LocalPlayer.Character.Head or isFlying then
		return
	end
	flyCharacter = LocalPlayer.Character
	flyHumanoid = flyCharacter.Humanoid
	flyHumanoid.PlatformStand = true
	flyCamera = Workspace:WaitForChild("Camera")
	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyAngularVelocity = Instance.new("BodyAngularVelocity")
	local zeroVector = Vector3.new(0, 0, 0)
	local maxForceVector = Vector3.new(10000, 10000, 10000)
	flyBodyVelocity.P = 1000
	flyBodyVelocity.MaxForce = maxForceVector
	flyBodyVelocity.Velocity = zeroVector
	flyBodyAngularVelocity.P = 1000
	flyBodyAngularVelocity.MaxTorque = maxForceVector
	flyBodyAngularVelocity.AngularVelocity = zeroVector
	flyBodyVelocity.Parent = flyCharacter.Head
	flyBodyAngularVelocity.Parent = flyCharacter.Head
	isFlying = true
	flyHumanoid.Died:connect(function()
		isFlying = false
	end)
end

function endFly()
	if not LocalPlayer.Character or not isFlying then
		return
	end
	flyHumanoid.PlatformStand = false
	flyBodyVelocity:Destroy()
	flyBodyAngularVelocity:Destroy()
	isFlying = false
end

function setVec(vec)
	return vec * newflyspeed / vec.Magnitude
end

function CleanupFling()
	print("Вызов функции CleanupFling()")
	if getgenv().FPDH then
		Workspace.FallenPartsDestroyHeight = getgenv().FPDH
	end
	local camera = Workspace:FindFirstChildOfClass("Camera")
	if not camera then
		warn("Камера не найдена.")
		return
	end
	if BV and BV.Parent then
		BV:Destroy()
		BV = nil
	end
	local player = game:GetService("Players").LocalPlayer
	local humanoid = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
	if humanoid then
		camera.CameraSubject = humanoid
		humanoid:ChangeState(Enum.HumanoidStateType.Seated)
	else
		warn("Humanoid не найден, камера не сброшена.")
	end
end

local function flingPlayerLogic(targetPlayer)
	if not LocalPlayer or not LocalPlayer.Character then
		CleanupFling()
		return
	end
	local localCharacter = LocalPlayer.Character
	local localHumanoid = localCharacter:FindFirstChildOfClass("Humanoid")
	local localRootPart = localHumanoid and localHumanoid.RootPart
	if not targetPlayer or not targetPlayer.Character then
		CleanupFling()
		return
	end
	local targetCharacter = targetPlayer.Character
	local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
	local targetRootPart = targetHumanoid and targetHumanoid.RootPart
	local targetHead = targetCharacter:FindFirstChild("Head")
	local targetAccessory = targetCharacter:FindFirstChildOfClass("Accessory")
	local targetHandle = targetAccessory and targetAccessory:FindFirstChild("Handle")
	if not targetHumanoid then
		CleanupFling()
		return sendnotification("Target has no Humanoid. Fling Stopped")
	end
	if not localCharacter or not localHumanoid or not localRootPart then
		CleanupFling()
		return sendnotification("Local character setup incomplete. Fling Stopped")
	end
	if localRootPart.Velocity.Magnitude < 50 then
		getgenv().OldPos = localRootPart.CFrame
	end
	if targetHumanoid and targetHumanoid.SeatPart and not AllBool then
		CleanupFling()
		return sendnotification("Target is sitting. Fling Stopped")
	end
	if targetHead then
		Workspace.CurrentCamera.CameraSubject = targetHead
	elseif targetHandle then
		Workspace.CurrentCamera.CameraSubject = targetHandle
	elseif targetHumanoid then
		Workspace.CurrentCamera.CameraSubject = targetHumanoid
	end
	if not targetCharacter:FindFirstChildWhichIsA("BasePart") then
		CleanupFling()
		return sendnotification("Target has no BaseParts. Fling Stopped")
	end
	local function setCFrameAndVelocity(part, offsetCFrame, angleCFrame)
		if not localRootPart or not part then
			return
		end
		local newCFrame = CFrame.new(part.Position) * offsetCFrame * angleCFrame
		localRootPart.CFrame = newCFrame
		if localCharacter and localCharacter.PrimaryPart then
			localCharacter:SetPrimaryPartCFrame(newCFrame)
		end
		localRootPart.Velocity = Vector3.new(FlingPower, FlingPower * 2, FlingPower)
		localRootPart.RotVelocity = Vector3.new(FlingPower, FlingPower, FlingPower)
	end
	local function flingLoop(part)
		if not part then
			CleanupFling()
			return
		end
		local flingDuration = 2
		local startTime = tick()
		local rotation = 0
		local loopStartTime = os.clock()
		while localRootPart and targetPlayer and targetPlayer.Parent and os.clock() - loopStartTime <= 10 do
			if localHumanoid.Health <= 0 or tick() - startTime > flingDuration then
				break
			end
			if not (targetHumanoid and targetHumanoid.SeatPart) then
				if part.Velocity.Magnitude < 50 then
					rotation = rotation + 100
					local angle = CFrame.Angles(math.rad(rotation), 0, 0)
					local moveDirOffset = targetHumanoid.MoveDirection * part.Velocity.Magnitude / 1.25
					setCFrameAndVelocity(part, CFrame.new(0, 1.5, 0) + moveDirOffset, angle)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0) + moveDirOffset, angle)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(2.25, 1.5, -2.25) + moveDirOffset, angle)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(-2.25, -1.5, 2.25) + moveDirOffset, angle)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection, angle)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection, angle)
					task.wait()
				else
					local walkSpeedOffset = CFrame.new(0, 1.5, targetHumanoid.WalkSpeed)
					local velocityOffset = CFrame.new(0, 1.5, targetRootPart.Velocity.Magnitude / 1.25)
					local angle90 = CFrame.Angles(math.rad(90), 0, 0)
					local angle0 = CFrame.Angles(0, 0, 0)
					local angleNeg90 = CFrame.Angles(math.rad(-90), 0, 0)
					setCFrameAndVelocity(part, walkSpeedOffset, angle90)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, -targetHumanoid.WalkSpeed), angle0)
					task.wait()
					setCFrameAndVelocity(part, walkSpeedOffset, angle90)
					task.wait()
					setCFrameAndVelocity(part, velocityOffset, angle90)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, -targetRootPart.Velocity.Magnitude / 1.25), angle0)
					task.wait()
					setCFrameAndVelocity(part, velocityOffset, angle90)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0), angle90)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0), angle0)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0), angleNeg90)
					task.wait()
					setCFrameAndVelocity(part, CFrame.new(0, -1.5, 0), angle0)
					task.wait()
				end
				if part.Velocity.Magnitude > 500 then
					break
				end
			else
				break
			end
		end
	end
	if not getgenv().FPDH then
		getgenv().FPDH = Workspace.FallenPartsDestroyHeight
	end
	Workspace.FallenPartsDestroyHeight = -5000
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Name = "EpixVel"
	bodyVelocity.Parent = localRootPart
	bodyVelocity.Velocity = Vector3.new(FlingPower, FlingPower, FlingPower)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	if targetRootPart and targetHead then
		if (targetRootPart.Position - targetHead.Position).Magnitude > 5 then
			flingLoop(targetHead)
		else
			flingLoop(targetRootPart)
		end
	elseif targetRootPart then
		flingLoop(targetRootPart)
	elseif targetHead then
		flingLoop(targetHead)
	elseif targetHandle then
		flingLoop(targetHandle)
	else
		sendnotification("Target is missing everything. Fling Stopped")
	end
	if bodyVelocity and bodyVelocity.Parent then
		bodyVelocity:Destroy()
	end
	localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
	Workspace.CurrentCamera.CameraSubject = localHumanoid
	if getgenv().OldPos and localCharacter and localCharacter:FindFirstChildWhichIsA("BasePart") then
		local resetStartTime = os.clock()
		while localRootPart and localCharacter do
			local resetCFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
			localRootPart.CFrame = resetCFrame
			if localCharacter.PrimaryPart then
				localCharacter:SetPrimaryPartCFrame(resetCFrame)
			end
			localHumanoid:ChangeState("GettingUp")
			for i, v in pairs(localCharacter:GetChildren()) do
				if v:IsA("BasePart") then
					v.Velocity = Vector3.new()
					v.RotVelocity = Vector3.new()
				end
			end
			task.wait()
			if os.clock() - resetStartTime > 5 or (localRootPart.Position - getgenv().OldPos.Position).Magnitude < 25 then
				break
			end
		end
	end
	CleanupFling()
end

function gradient(text, color1, color2)
	local result = ""
	local textLength = #text
	for i = 1, textLength do
		local ratio = (i - 1) / math.max((textLength - 1), 1)
		local r = math.floor((color1.R + (color2.R - color1.R) * ratio) * 255)
		local g = math.floor((color1.G + (color2.G - color1.G) * ratio) * 255)
		local b = math.floor((color1.B + (color2.B - color1.B) * ratio) * 255)
		result = result .. "<font color=\"rgb(" .. r .. ", " .. g .. ", " .. b .. ")\">" .. text:sub(i, i) .. "</font>"
	end
	return result
end

local HttpService = game:GetService("HttpService")
local hasFileIO = missing("function", readfile, false) and missing("function", writefile, false)
local currentLanguage = "en"
if hasFileIO and (syn and isfile("configlanguage.json") or isfile and isfile("configlanguage.json")) then
	local success, result = pcall(function()
		return HttpService:JSONDecode(readfile("configlanguage.json"))
	end)
	if success and result and result.language then
		currentLanguage = result.language
	end
elseif getgenv().choice then
	currentLanguage = getgenv().choice
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/snapsanix/Secrethub/refs/heads/main/OtherSCRIPTS/Statusforinfo"))()
local LocalizationData = {
	Enabled = true,
	Prefix = "loc:",
	ru = {
		ver = "Версия " .. versionn,
		autofarm_info = "Анти-АФК режим включён по умолчанию. Наслаждайтесь автофармом монет!",
		report_how = "Вы пишете мне в Telegram с сообщением об ошибке. Ваш ник, выбранная категория и текст жалобы будут отображены.",
		status_script = "Статус скрипта: " .. statusmm2,
		product_type = "Тип продукта: " .. scriptfree,
		script_version = "Версия скрипта: " .. versionn,
		launched_from = "Запущен с: " .. launched,
		executor = "Исполнитель: " .. getExecutorName(),
		script_tester = "Тестер скрипта: zsharki, qwizkoffc и rdiz890",
		age = "Возраст аккаунта " .. LocalPlayer.AccountAge .. " [День]",
		CHARACTER = "Персонаж",
		TELEPORT = "Телепорт",
		COMBAT = "Бой",
		TROLLING = "Троллинг",
		ESP = "Валлхак",
		VISUAL = "Визуал",
		EMOTES = "Эмоции",
		OTHER = "Другое",
		AUTOFARM = "Автофарм",
		REPORT_BUGS = "Фидбэк",
		HUB_STATUS = "Статус хаба",
		ABOUT_SCRIPT = "О скрипте",
		ANOTHER_SCRIPT = "Вторая ссылка",
		SETTINGS = "Настройки",
		ws = "Скорость ходьбы",
		togws = "Включить скорость ходьбы",
		jump = "Сила прыжка",
		togjump = "Включить силу прыжка",
		fly = "Полет",
		flyspeed = "Скорость полета",
		noclip = "Проход сквозь стены",
		infjump = "Бесконечный прыжок",
		fov = "Поле зрения",
		unlockcam = "Разблокировать камеру",
		reset = "Умереть",
		tpgunmode = "Телепорт к оружию (режим)",
		grabgun = "Подобрать оружие",
		grabgunkey = "Клавиша для подбора оружия",
		toggrabgunkey = "Вкл/Выкл клавишу подбора оружия",
		autograbgun = "Автоподбор оружия [нестабильно]",
		tptomap = "Телепорт к карте",
		tptovote = "Телепорт в комнату голосования",
		tptolobby = "Телепорт в лобби",
		tptosecret = "Телепорт в секретку",
		tptorandom = "Телепорт к случайному игроку",
		tptoplayer = "Телепорт к игроку",
		tptomurder = "Телепорт к убийце",
		tptosheriff = "Телепорт к шерифу",
		autododge = "Автоманс от ножей",
		godmode = "Режим Бога",
		descgodmode = "Две жизни",
		freeemotes = "Бесплатные эмоции с Маркетплейса",
		descfreeemotes = "Горячая клавиша - запятая",
		fakeknife = "Создать фейковый нож",
		sprint = "Бег",
		shootmurder = "Выстрелить в убийцу",
		viewsheriff = "Смотреть за шерифом",
		silentaimtype = "Тип тихого аима",
		togsilentaim = "Вкл/Выкл тихий аим Клавиша",
		silentaim = "Тихий Аим Клавиша",
		aimbot = "Аимбот",
		prediction = "Предсказание движения",
		fovradius = "Радиус FOV",
		autokillall = "Авто убийство всех",
		selectplayers = "Выбрать игроков",
		autokillselected = "Авто убийство выбранных",
		killsheriff = "Убить шерифа",
		autokillsheriff = "Авто убийство шерифа",
		viewmurder = "Смотреть за убийцей",
		knifeaura = "Аура ножа",
		knifeaurarange = "Радиус ауры ножа",
		selectplayerfling = "Выбрать игрока",
		flingplayer = "Флинговать игрока",
		flingmurder = "Флинговать убийцу",
		flingsheriff = "Флинговать шерифа",
		flingstrenght = "Сила флинга",
		layonback = "Лечь на спину",
		sitdown = "Сесть",
		espplayers = "ESP всех игроков [старый]",
		esptrans = "ESP Прозрачность [старый]",
		playersnameesp = "ESP Имена",
		espdropgun = "Показать упавшее оружие",
		innoesp = "Показать Мирных",
		sheresp = "Показать Шерифа",
		murdesp = "Показать Убийцу",
		showdead = "Показать Мертвых",
		boxesmurd = "Показать боксы Убийцы",
		boxessher = "Показать боксы Шерифа",
		boxesinno = "Показать боксы Мирных",
		xray = "Рентген",
		xraytrans = "Прозрачность рентгена",
		improvefps = "Оптимизация FPS",
		boombox = "Бумбокс",
		hitboxexpander = "Расширитель хитбоксов",
		hitboxsize = "Размер хитбокса",
		hitboxcolor = "Цвет хитбокса",
		skyboxselector = "Выбор неба",
		customcursor = "Кастомный курсор",
		ninja = "Ниндзя",
		sit = "Сидеть",
		headless = "Безголовый",
		dab = "Дэб",
		zen = "Дзен",
		floss = "Флосс",
		zombie = "Зомби",
		wave = "Привет!",
		cheer = "Аплодировать",
		laugh = "Смеяться",
		breakgun = "Сломать пистолет",
		autobreakgun = "Авто ломание пистолета",
		antitrap = "Анти-ловушка",
		antifling = "Анти-флинг",
		antiafk = "Анти-афк",
		gundropnotify = "Уведомление об появлении пистолета",
		exposeroles = "Разоблачить роли в чат",
		devconsole = "Консоль разработчика",
		rejoin = "Переподключиться",
		serverhop = "Сменить сервер",
		autofarm = "Автофарм",
		descautofarm = "Автоматический фарм монет/мячиков",
		endround = "Закончить раунд после фарма или смерти",
		descendround = "Мирный = флинг убийцу \nШериф = флинг убийцу",
		endroundkill = "Убить всех после фарма",
		descendroundkill = "Убийца = убить всех",
		farmspeed = "Скорость автофарма",
		descfarmspeed = "Рекомендуется 25, чтобы избежать античита",
		reportcategory = "Выберите категорию жалобы",
		placeholderreport = "Опишите проблему (на английском или русском)",
		sendreport = "Отправить жалобу",
		youtube = "Мой ютуб Канал",
		openhub = "Клавиша для открытия скрипта",
		selecttheme = "Выбрать тему",
		selectbackground = "Выбрать фон",
		backgroundtrans = "Прозрачность фона",
		config = "Конфиги [Скоро]",
		language = "Сменить язык",
		forgot = "Забыть язык",
		invis = "Невидимость",
		ragdoll = "Создать инструмент рэгдола",
		bang = "Трахнуть",
		inputbang = "Имя цели",
		getsuck = "Выебать в рот",
		boxesdead = "Показать боксы мертвых"
	},
	en = {
		ver = "Version " .. versionn,
		autofarm_info = "Anti-AFK mode is already enabled by default. Enjoy the coin autofarm!",
		report_how = "You ping me on Telegram with a message about your report. Your nickname, selected category, and message will be displayed.",
		status_script = "Status of the script: " .. statusmm2,
		product_type = "Product type: " .. scriptfree,
		script_version = "Script version: " .. versionn,
		launched_from = "Launched from: " .. launched,
		executor = "Executor: " .. getExecutorName(),
		script_tester = "Script tester: zsharki, qwizkoffc and rdiz890",
		age = "Account Age " .. LocalPlayer.AccountAge .. " [Day]",
		CHARACTER = "Character",
		TELEPORT = "Teleport",
		COMBAT = "Combat",
		TROLLING = "Trolling",
		ESP = "ESP",
		VISUAL = "Visual",
		EMOTES = "Emotes",
		OTHER = "Other",
		AUTOFARM = "Autofarm",
		REPORT_BUGS = "Report Bugs",
		HUB_STATUS = "Hub Status",
		ABOUT_SCRIPT = "About Script",
		ANOTHER_SCRIPT = "Another Script",
		SETTINGS = "Settings",
		ws = "Walkspeed",
		togws = "Enable Walkspeed",
		jump = "Jumppower",
		togjump = "Enable Jumppower",
		fly = "Fly",
		flyspeed = "Fly Speed",
		noclip = "Noclip",
		infjump = "Infinite Jump",
		fov = "FOV",
		unlockcam = "Unlock Camera",
		reset = "Respawn",
		tpgunmode = "Tp To Gun Mode",
		grabgun = "Grab Gun",
		grabgunkey = "Grab Gun Keybind",
		toggrabgunkey = "Toggle Grab Gun Keybind",
		autograbgun = "Auto Grab Gun [unstable]",
		tptomap = "Teleport to Map",
		tptovote = "Teleport to Voting Room",
		tptolobby = "Teleport to Lobby",
		tptosecret = "Teleport to Secret",
		tptorandom = "Teleport to Random Player",
		tptoplayer = "Teleport to Player",
		tptomurder = "Teleport to Murderer",
		tptosheriff = "Teleport to Sheriff",
		autododge = "Auto Dodge Knives",
		godmode = "Godmode",
		descgodmode = "Two Lives",
		freeemotes = "Free Emotes from Marketplace",
		descfreeemotes = "Keybind is comma [,]",
		fakeknife = "Create Fake Knife",
		sprint = "Sprint",
		shootmurder = "Shoot Murderer",
		viewsheriff = "View Sheriff",
		silentaimtype = "Silent Aim Type",
		togsilentaim = "Toggle Silent Aim",
		silentaim = "Silent Aim Keybind",
		aimbot = "Aimbot",
		prediction = "Prediction Movement",
		fovradius = "FOV Radius",
		autokillall = "Auto Kill All",
		selectplayers = "Select Players",
		autokillselected = "Auto Kill Selected Players",
		killsheriff = "Kill Sheriff",
		autokillsheriff = "Auto Kill Sheriff",
		viewmurder = "View Murderer",
		knifeaura = "Knife Aura",
		knifeaurarange = "Knife Aura Range",
		selectplayerfling = "Select Player",
		flingplayer = "Fling Player",
		flingmurder = "Fling Murderer",
		flingsheriff = "Fling Sheriff",
		flingstrenght = "Fling Strength",
		layonback = "Lay On Back",
		sitdown = "Sit Down",
		espplayers = "ESP All [old]",
		esptrans = "ESP Transparency [old]",
		playersnameesp = "ESP Names",
		espdropgun = "ESP Dropped Gun",
		innoesp = "Innocent ESP",
		sheresp = "Sheriff ESP",
		murdesp = "Murderer ESP",
		showdead = "Dead ESP",
		boxesmurd = "Show Boxes Murderer",
		boxessher = "Show Boxes Sheriff",
		boxesinno = "Show Boxes Innocents",
		xray = "X-Ray",
		xraytrans = "X-Ray Transparency",
		improvefps = "Improve FPS",
		boombox = "Boombox",
		hitboxexpander = "Hitbox Expander",
		hitboxsize = "Hitbox Size",
		hitboxcolor = "Hitbox Color",
		skyboxselector = "Skybox Selector",
		customcursor = "Custom Cursor",
		ninja = "Ninja",
		sit = "Sit",
		headless = "Headless",
		dab = "Dab",
		zen = "Zen",
		floss = "Floss",
		zombie = "Zombie",
		wave = "Wave",
		cheer = "Cheer",
		laugh = "Laugh",
		breakgun = "Break Gun",
		autobreakgun = "Auto Break Gun",
		antitrap = "Anti-Trap",
		antifling = "Anti-Fling",
		antiafk = "Anti-AFK",
		gundropnotify = "Gun Drop Notify",
		exposeroles = "Expose Roles",
		devconsole = "Developer Console",
		rejoin = "Rejoin",
		serverhop = "Server Hop",
		autofarm = "Autofarm",
		descautofarm = "Automatically farms Coins/BeachBalls",
		endround = "End round when you're done farming or died",
		descendround = "Innocent = fling murderer \nSheriff = fling murderer",
		endroundkill = "Kill all when you're done farming",
		descendroundkill = "Murderer = kill all",
		farmspeed = "Farm Speed",
		descfarmspeed = "Recommended: 25 to avoid Anticheat",
		reportcategory = "Select a Report Category",
		placeholderreport = "Describe the problem (English or Russian)",
		sendreport = "Send Report",
		youtube = "My YouTube Channel",
		openhub = "Keybind to Open hub",
		selecttheme = "Select Theme",
		selectbackground = "Select Background",
		backgroundtrans = "Background Transparency",
		config = "Config [Soon]",
		language = "Change language",
		forgot = "Forget language",
		invis = "Invisible",
		ragdoll = "Create Ragdoll Tool",
		bang = "Bang",
		inputbang = "Target name",
		getsuck = "Fuck in the mouth",
		boxesdead = "Show Boxes Dead"
	}
}
WindUI:Localization(LocalizationData)
WindUI:SetLanguage(currentLanguage)
local MainWindow = WindUI:CreateWindow({
	Title = "Thunder Hub MM2" .. icon1,
	Icon = "square-code",
	Author = gradient("by Kavo", Color3.fromHex("#6a329f"), Color3.fromHex("#ffd966")),
	Folder = "Thunder MM2",
	Size = UDim2.fromOffset(580, 460),
	Transparent = true,
	Theme = "Rose",
	Background = "",
	BackgroundImageTransparency = "",
	User = {
		Enabled = true,
		Callback = function()
			print("clicked")
		end,
		Anonymous = false
	},
	SideBarWidth = 200,
	HasOutline = true
})
MainWindow:SetToggleKey(Enum.KeyCode.G)
MainWindow:Tag({
	Title = "loc:ver",
	Color = Color3.fromHex("#30ff6a")
})
local Tabs = {}
Tabs.character = MainWindow:Tab({
	Title = "loc:CHARACTER",
	Icon = "person-standing"
})
Tabs.teleport = MainWindow:Tab({
	Title = "loc:TELEPORT",
	Icon = "arrow-left-right"
})
Tabs.combat = MainWindow:Tab({
	Title = "loc:COMBAT",
	Icon = "swords"
})
Tabs.troll = MainWindow:Tab({
	Title = "loc:TROLLING",
	Icon = "angry"
})
Tabs.esp = MainWindow:Tab({
	Title = "loc:ESP",
	Icon = "person-standing"
})
Tabs.visual = MainWindow:Tab({
	Title = "loc:VISUAL",
	Icon = "eye"
})
Tabs.emotes = MainWindow:Tab({
	Title = "loc:EMOTES",
	Icon = "smile"
})
Tabs.other = MainWindow:Tab({
	Title = "loc:OTHER",
	Icon = "power"
})
Tabs.autofarm = MainWindow:Tab({
	Title = "loc:AUTOFARM",
	Icon = "puzzle"
})
Tabs.report = MainWindow:Tab({
	Title = "loc:REPORT_BUGS",
	Icon = "bug"
})
Tabs.status = MainWindow:Tab({
	Title = "loc:HUB_STATUS",
	Icon = "siren"
})
Tabs.changelog = MainWindow:Tab({
	Title = "loc:ABOUT_SCRIPT",
	Icon = "file-json-2"
})
Tabs.another = MainWindow:Tab({
	Title = "loc:ANOTHER_SCRIPT",
	Icon = "unlink"
})
Tabs.divider1 = MainWindow:Divider()
Tabs.settings = MainWindow:Tab({
	Title = "loc:SETTINGS",
	Icon = "settings"
})
Tabs.be = MainWindow:Divider()
MainWindow:SelectTab(2)
defualtwalkspeed = 16
defualtjumppower = 50
newwalkspeed = defualtwalkspeed
newjumppower = defualtjumppower
Tabs.character:Slider({
	Title = "loc:ws",
	Value = {
		Min = 16,
		Max = 500,
		Default = 16
	},
	Callback = function(value)
		newwalkspeed = tonumber(value)
	end
})
Tabs.character:Toggle({
	Title = "loc:togws",
	Value = false,
	Callback = function(value)
		loopwalkspeed = value
		while loopwalkspeed do
			local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
			humanoid.WalkSpeed = newwalkspeed
			wait()
		end
		wait()
		LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = defualtwalkspeed
		wait()
	end
})
Tabs.character:Slider({
	Title = "loc:jump",
	Value = {
		Min = 50,
		Max = 500,
		Default = 50
	},
	Callback = function(value)
		newjumppower = tonumber(value)
	end
})
Tabs.character:Toggle({
	Title = "loc:togjump",
	Value = false,
	Callback = function(value)
		loopjumppower = value
		while loopjumppower do
			local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
			humanoid.JumpPower = newjumppower
			wait()
		end
		wait()
		LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = defualtjumppower
		wait()
	end
})
Tabs.character:Slider({
	Title = "loc:flyspeed",
	Value = {
		Min = 50,
		Max = 500,
		Default = 50
	},
	Callback = function(value)
		newflyspeed = tonumber(value)
	end
})
Tabs.character:Toggle({
	Title = "loc:fly",
	Value = false,
	Callback = function(value)
		if flyfirst ~= true then
			flyfirst = true
			game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessed)
				if gameProcessed then
					return
				end
				for key, _ in pairs(flyMovement) do
					if key ~= "Moving" and input.KeyCode == Enum.KeyCode[key] then
						flyMovement[key] = true
						flyMovement.Moving = true
					end
				end
			end)
			game:GetService("UserInputService").InputEnded:connect(function(input, gameProcessed)
				if gameProcessed then
					return
				end
				local isMoving = false
				for key, _ in pairs(flyMovement) do
					if key ~= "Moving" then
						if input.KeyCode == Enum.KeyCode[key] then
							flyMovement[key] = false
						end
						if flyMovement[key] then
							isMoving = true
						end
					end
				end
				flyMovement.Moving = isMoving
			end)
			game:GetService("RunService").Heartbeat:connect(function(deltaTime)
				if isFlying and flyCharacter and flyCharacter.PrimaryPart then
					local pos = flyCharacter.PrimaryPart.Position
					local camCFrame = flyCamera.CFrame
					local rx, ry, rz = camCFrame:toEulerAnglesXYZ()
					flyCharacter:SetPrimaryPartCFrame(CFrame.new(pos.x, pos.y, pos.z) * CFrame.Angles(rx, ry, rz))
					if flyMovement.Moving then
						local moveVector = Vector3.new()
						if flyMovement.W then
							moveVector = moveVector + setVec(camCFrame.lookVector)
						end
						if flyMovement.S then
							moveVector = moveVector - setVec(camCFrame.lookVector)
						end
						if flyMovement.A then
							moveVector = moveVector - setVec(camCFrame.rightVector)
						end
						if flyMovement.D then
							moveVector = moveVector + setVec(camCFrame.rightVector)
						end
						flyCharacter:TranslateBy(moveVector * deltaTime)
					end
				end
			end)
		end
		if value == true then
			startFly()
		elseif value == false then
			endFly()
		end
	end
})
Tabs.character:Toggle({
	Title = "loc:noclip",
	Value = false,
	Callback = function(value)
		loopnoclip = value
		while loopnoclip do
			local function loopnoclipfix()
				for i, v in pairs(game.Workspace:GetChildren()) do
					if v.Name == game.Players.LocalPlayer.Name then
						for _, part in pairs(game.Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
							if part:IsA("BasePart") then
								part.CanCollide = false
							end
						end
					end
				end
				wait()
			end
			wait()
			pcall(loopnoclipfix)
		end
	end
})
local UserInputService = game:GetService("UserInputService")
local infiniteJumpEnabled = false
Tabs.character:Toggle({
	Title = "loc:infjump",
	Compact = true,
	Callback = function(value)
		infiniteJumpEnabled = value
	end
})
UserInputService.JumpRequest:Connect(function()
	if infiniteJumpEnabled and LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState("Jumping")
		end
	end
end)
Tabs.character:Slider({
	Title = "loc:fov",
	Value = {
		Min = 0,
		Max = 120,
		Default = 70
	},
	Callback = function(value)
		game:GetService("Workspace").Camera.FieldOfView = value
	end
})
Tabs.character:Toggle({
	Title = "loc:unlockcam",
	Value = false,
	Callback = function(value)
		local player = game.Players.LocalPlayer
		if value then
			player.CameraMaxZoomDistance = 99999999999
			player.CameraMinZoomDistance = 0.5
		else
			player.CameraMaxZoomDistance = 15
			player.CameraMinZoomDistance = 0.5
		end
	end
})
Tabs.character:Button({
	Title = "loc:reset",
	Desc = "",
	Callback = function()
		game.Players.LocalPlayer.Character.Humanoid.Health = 0
	end
})
Tabs.teleport:Section({
	Title = "Grabber"
})
getfiretouchinterest = missing("function", firetouchinterest)
gunsupport = false
local gunModeDropdown = Tabs.teleport:Dropdown({
	Title = "loc:tpgunmode",
	Values = {
		"Default",
		"Remote"
	},
	Value = "Default",
	Callback = function(value)
		if value == "Remote" then
			gunsupport = true
		elseif value == "Default" then
			gunsupport = false
		end
	end
})
if not getfiretouchinterest then
	gunModeDropdown:Lock()
	sendnotification("firetouchinterest not supported, locked to default teleport")
end
function isMurderer()
	local char = LocalPlayer.Character
	local backpack = LocalPlayer.Backpack
	if not char and not backpack then
		return false
	end
	for _, container in ipairs({
		char,
		backpack
	}) do
		if container then
			for _, item in ipairs(container:GetChildren()) do
				if item:IsA("Tool") and item.Name == "Knife" then
					return true
				end
			end
		end
	end
	return false
end
function teleportToGun()
	if isMurderer() then
		return
	end
	local gunModel = nil
	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("GunDrop") then
			gunModel = v
			break
		end
	end
	if not gunModel then
		sendnotification("Wait for the Sheriff's death to grab the gun")
		return
	end
	local gunDrop = gunModel:FindFirstChild("GunDrop")
	if not gunDrop then
		sendnotification("Wait for the Sheriff's death to grab the gun")
		return
	end
	local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
	local originalPos = rootPart.Position
	rootPart.CFrame = gunDrop.CFrame
	wait(0.2)
	rootPart.CFrame = CFrame.new(originalPos.X, originalPos.Y + 5, originalPos.Z)
	local player = game.Players.LocalPlayer
	local humanoid = (player.Character or player.CharacterAdded:Wait()):WaitForChild("Humanoid")
	if humanoid then
		humanoid.PlatformStand = true
		wait(0.1)
		humanoid.PlatformStand = false
	end
end
local function remoteGrabGun()
	if isMurderer() then
		return
	end
	local gunModel = nil
	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("GunDrop") then
			gunModel = v
			break
		end
	end
	if not gunModel then
		sendnotification("Wait for the Sheriff's death to grab the gun")
		return
	end
	local gunDrop = gunModel:FindFirstChild("GunDrop")
	if not gunDrop then
		sendnotification("Wait for the Sheriff's death to grab the gun")
		return
	end
	local rootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	firetouchinterest(rootPart, gunDrop, 0)
	task.wait(0.1)
	firetouchinterest(rootPart, gunDrop, 1)
end
Tabs.teleport:Button({
	Title = "loc:grabgun",
	Callback = function()
		if gunsupport then
			remoteGrabGun()
		else
			teleportToGun()
		end
	end
})
Tabs.teleport:Keybind({
	Title = "loc:grabgunkey",
	Value = "R",
	Callback = function()
		if grabber == true then
			if gunsupport then
				remoteGrabGun()
			else
				teleportToGun()
			end
		end
	end
})
Tabs.teleport:Toggle({
	Title = "loc:toggrabgunkey",
	Value = false,
	Callback = function(value)
		if value == true then
			grabber = true
		end
		if value == false then
			grabber = false
		end
	end
})
local autoGrabGunSettings = {}
autoGrabGunSettings.Enabled = false
Workspace.DescendantAdded:Connect(function(descendant)
	if autoGrabGunSettings.Enabled and descendant.Name == "GunDrop" then
		if gunsupport then
			remoteGrabGun()
		else
			teleportToGun()
		end
	end
end)
Tabs.teleport:Toggle({
	Title = "loc:autograbgun",
	Compact = true,
	Callback = function(value)
		autoGrabGunSettings.Enabled = value
		if value then
			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant.Name == "GunDrop" then
					if gunsupport then
						remoteGrabGun()
					else
						teleportToGun()
					end
				end
			end
		end
	end
})
Tabs.teleport:Section({
	Title = "Teleport To Coordinate"
})
Tabs.teleport:Button({
	Title = "loc:tptomap",
	Callback = function()
		for _, descendant in pairs(Workspace:GetDescendants()) do
			if descendant.Name == "Spawn" then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
			elseif descendant.Name == "PlayerSpawn" then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
			end
		end
	end
})
Tabs.teleport:Button({
	Title = "loc:tptovote",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(174.615936, 142.622971, 77.796272)
	end
})
Tabs.teleport:Button({
	Title = "loc:tptolobby",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(111.494614, 140.25296, 43.869976)
	end
})
Tabs.teleport:Button({
	Title = "loc:tptosecret",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(91.923607, 140.247971, -24.833168)
	end
})
local function getOtherPlayerNames()
	local names = {}
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player ~= game.Players.LocalPlayer then
			table.insert(names, player.Name)
		end
	end
	return names
end
Tabs.teleport:Button({
	Title = "loc:tptorandom",
	Compact = true,
	Callback = function()
		local otherPlayers = getOtherPlayerNames()
		if #otherPlayers > 0 then
			local randomPlayer = game:GetService("Players")[otherPlayers[math.random(1, #otherPlayers)]]
			if randomPlayer then
				if randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
					WindUI:Notify({
						Title = "Teleported",
						Content = "Teleported to: " .. randomPlayer.Name,
						Duration = 3
					})
				else
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-94.952538, 138.297989, -6.388918)
					WindUI:Notify({
						Title = "Teleported",
						Content = randomPlayer.Name .. " has no character. Moved to spawn instead.",
						Duration = 3
					})
				end
			end
		else
			WindUI:Notify({
				Title = "Error",
				Content = "No players to teleport to!",
				Duration = 3
			})
		end
	end
})
Tabs.teleport:Section({
	Title = "Teleport To Humanoid"
})
teleportPlayerList = {}
killPlayerList = {}
flingPlayerList = {}
table.insert(teleportPlayerList, "playerlist updated")
table.insert(killPlayerList, "playerlist updated")
table.insert(flingPlayerList, "All")
for _, player in pairs(game.Players:GetPlayers()) do
	if player ~= game.Players.LocalPlayer then
		table.insert(teleportPlayerList, player.Name)
	end
end
for _, player in pairs(game.Players:GetPlayers()) do
	if player ~= game.Players.LocalPlayer then
		table.insert(killPlayerList, player.Name)
	end
end
for _, player in pairs(game.Players:GetPlayers()) do
	if player ~= game.Players.LocalPlayer then
		table.insert(flingPlayerList, player.Name)
	end
end
local teleportPlayerDropdown = Tabs.teleport:Dropdown({
	Title = "loc:tptoplayer",
	Values = teleportPlayerList,
	Callback = function(value)
		if value ~= "playerlist updated" then
			local player = game.Players:FindFirstChild(value)
			if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(player.Character.HumanoidRootPart.Position)
			end
		end
	end
})
Tabs.teleport:Button({
	Title = "loc:tptomurder",
	Callback = function()
		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			if player.Character and (player.Character:FindFirstChild("Knife") or player.Backpack and player.Backpack:FindFirstChild("Knife")) then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
			end
		end
	end
})
Tabs.teleport:Button({
	Title = "loc:tptosheriff",
	Callback = function()
		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			if player.Character and (player.Character:FindFirstChild("Gun") or player.Backpack and player.Backpack:FindFirstChild("Gun")) then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
			end
		end
	end
})
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local TaskManager = {}
local activeTasks = {}
function TaskManager:MakeTask(name, event, callback)
	if activeTasks and not activeTasks[name] then
		activeTasks[name] = event:Connect(callback)
	end
end
function TaskManager:RemoveTask(name)
	if activeTasks and activeTasks[name] then
		activeTasks[name]:Disconnect()
		activeTasks[name] = nil
	end
end
local function getPlayerRootPart(player)
	if player and player.Character then
		return player.Character:FindFirstChild("PrimaryPart") or player.Character:FindFirstChild("HumanoidRootPart")
	end
end
Tabs.combat:Section({
	Title = gradient("Combat Universal", Color3.fromHex("#8FCE00"), Color3.fromHex("#8FCE00"))
})
Tabs.combat:Toggle({
	Title = "loc:autododge",
	Value = false,
	Callback = function(value)
		if value then
			TaskManager:MakeTask("Auto Dodge Knives", Workspace.ChildAdded, function(child)
				if child.Name == "ThrowingKnife" and child:IsA("Model") and Stats ~= "Murderer" then
					local dodged = false
					while not dodged and child do
						task.wait()
						local rootPart = getPlayerRootPart(LocalPlayer)
						if rootPart then
							local knifePos = child:GetPivot().Position
							if (rootPart.Position - knifePos).Magnitude < 15 then
								local xOffset = rootPart.Position.X - knifePos.X
								if rootPart.Position.Y - knifePos.Y < 4.35 then
									rootPart.CFrame = rootPart.CFrame * CFrame.new(-xOffset * 1.5, 0, 0)
									dodged = true
								end
							end
						end
					end
				end
			end)
		else
			TaskManager:RemoveTask("Auto Dodge Knives")
		end
	end
})
local invisPos = Vector3.new(-25.95, 84, 3537.55)
function setTransparency(model, transparency)
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") then
			descendant.Transparency = transparency
		end
	end
end
local function getLocalRootPart()
	local char = LocalPlayer.Character
	if not char then
		return nil
	end
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if rootPart and rootPart:IsA("BasePart") then
		return rootPart
	end
	return nil
end
Tabs.combat:Toggle({
	Title = "loc:invis",
	Value = false,
	Callback = function(value)
		if not LocalPlayer.Character then
			return
		end
		if value then
			local rootPart = getLocalRootPart()
			if not rootPart then
				return
			end
			local originalCFrame = rootPart.CFrame
			LocalPlayer.Character:MoveTo(invisPos)
			task.wait(0.15)
			local seat = Instance.new("Seat")
			seat.Name = "invischair"
			seat.Anchored = false
			seat.CanCollide = false
			seat.Transparency = 1
			seat.Position = invisPos
			seat.Parent = Workspace
			local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
			if torso then
				local weld = Instance.new("Weld")
				weld.Part0 = seat
				weld.Part1 = torso
				weld.Parent = seat
			end
			task.wait()
			seat.CFrame = originalCFrame
			setTransparency(LocalPlayer.Character, 0.5)
		else
			local seat = Workspace:FindFirstChild("invischair")
			if seat then
				seat:Destroy()
			end
			if LocalPlayer.Character then
				setTransparency(LocalPlayer.Character, 0)
			end
		end
	end
})
Tabs.combat:Button({
	Title = "loc:godmode",
	Desc = "loc:descgodmode",
	Callback = function()
		if LocalPlayer.Character then
			if LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.Name = "1"
			end
			local newHumanoid = LocalPlayer.Character["1"]:Clone()
			newHumanoid.Parent = LocalPlayer.Character
			newHumanoid.Name = "Humanoid"
			wait(0.1)
			LocalPlayer.Character["1"]:Destroy()
			Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
			LocalPlayer.Character.Animate.Disabled = true
			wait(0.1)
			LocalPlayer.Character.Animate.Disabled = false
		end
	end
})
Tabs.combat:Button({
	Title = "loc:freeemotes",
	Desc = "loc:descfreeemotes",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Gi7331/scripts/main/Emote.lua"))()
	end
})
local fakeKnifeTool = nil
local fakeKnifeHandle = nil
local slashAnim1 = Instance.new("Animation")
slashAnim1.AnimationId = "rbxassetid://2467567750"
local slashAnim2 = Instance.new("Animation")
slashAnim2.AnimationId = "rbxassetid://1957890538"
local slashAnims = {
	slashAnim1,
	slashAnim2
}
local fakeKnifeConnections = {}
local function createFakeKnife()
	if not LocalPlayer.Character then
		return
	end
	local nikilisKnifePart = nil
	local success, _ = pcall(function()
		nikilisKnifePart = Workspace:WaitForChild("Lobby"):WaitForChild("Build"):WaitForChild("Nikilis"):WaitForChild("Knife")
	end)
	if not success or not nikilisKnifePart then
		warn("Не найден Part ножа в workspace.Lobby.Build.Nikilis.Knife")
		return
	end
	fakeKnifeTool = Instance.new("Tool")
	fakeKnifeTool.Name = "Fake Knife"
	fakeKnifeTool.CanBeDropped = false
	fakeKnifeTool.Grip = CFrame.new(0, -1.16999984, 0.0699999481, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	fakeKnifeTool.GripForward = Vector3.new(0, 0, -1)
	fakeKnifeTool.GripPos = Vector3.new(0, -1.17, 0.0699999)
	fakeKnifeTool.GripRight = Vector3.new(1, 0, 0)
	fakeKnifeTool.GripUp = Vector3.new(0, 1, 0)
	fakeKnifeHandle = nikilisKnifePart:Clone()
	fakeKnifeHandle.Name = "Handle"
	fakeKnifeHandle.Size = Vector3.new(0.310638815, 3.42103457, 1.08775854)
	fakeKnifeHandle.Transparency = 0
	fakeKnifeHandle.CanCollide = false
	fakeKnifeHandle.Anchored = false
	fakeKnifeHandle.Parent = fakeKnifeTool
	local slashSound = Instance.new("Sound")
	slashSound.SoundId = "rbxassetid://142247768"
	slashSound.Volume = 1
	if LocalPlayer.Character then
		slashSound.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	end
	table.insert(fakeKnifeConnections, LocalPlayer:GetMouse().Button1Down:Connect(function()
		if fakeKnifeTool and fakeKnifeTool.Parent == LocalPlayer.Character then
			LocalPlayer.Character.Humanoid:LoadAnimation(slashAnims[math.random(1, 2)]):Play()
		end
	end))
	local function onTouched(hit)
		local parent = hit.Parent
		if parent:FindFirstChildOfClass("Humanoid") and parent ~= LocalPlayer.Character then
			slashSound:Stop()
			slashSound:Play()
		end
	end
	local function setupTouchEvents(char)
		for _, handName in ipairs({
			"RightHand",
			"LeftHand"
		}) do
			local hand = char:FindFirstChild(handName, true)
			if hand and hand:IsA("BasePart") then
				table.insert(fakeKnifeConnections, hand.Touched:Connect(onTouched))
			end
		end
	end
	setupTouchEvents(LocalPlayer.Character)
	fakeKnifeTool.Parent = LocalPlayer.Backpack
	table.insert(fakeKnifeConnections, LocalPlayer.CharacterAdded:Connect(function(char)
		if fakeKnifeTool then
			fakeKnifeTool.Parent = LocalPlayer.Backpack
			slashSound.Parent = char:WaitForChild("HumanoidRootPart")
			setupTouchEvents(char)
		end
	end))
end
local function cleanupFakeKnife()
	for _, connection in ipairs(fakeKnifeConnections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	fakeKnifeConnections = {}
end
Tabs.combat:Toggle({
	Title = "loc:fakeknife",
	Value = false,
	Callback = function(value)
		if value then
			if not fakeKnifeTool then
				createFakeKnife()
			end
		else
			if fakeKnifeTool then
				fakeKnifeTool:Destroy()
				fakeKnifeTool = nil
				fakeKnifeHandle = nil
			end
			cleanupFakeKnife()
		end
	end
})
Tabs.combat:Toggle({
	Title = "loc:sprint",
	Value = false,
	Callback = function(value)
		if value then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
		else
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end
})
Tabs.combat:Section({
	Title = gradient("Combat Sheriff", Color3.fromHex("#2986CC"), Color3.fromHex("#2986CC"))
})
local function getMurderer()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and (player.Character:FindFirstChild("Knife") or player.Backpack and player.Backpack:FindFirstChild("Knife")) then
			return player
		end
	end
	return nil
end
local function predictPosition(targetPlayer, predictionAmount)
	local success, _ = pcall(function()
		if not targetPlayer.Character then
			print("No murderer to predict position.")
			return
		end
	end)
	local torso = targetPlayer.Character:FindFirstChild("UpperTorso")
	local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
	if not torso or not humanoid then
		return Vector3.new(0, 0, 0), "Could not find the player's HumanoidRootPart."
	end
	local velocity = torso.AssemblyLinearVelocity
	local moveDirection = humanoid.MoveDirection
	return torso.Position + velocity * Vector3.new(0, 0.5, 0) * predictionAmount / 15 + moveDirection * predictionAmount
end
function getSheriff()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and (player.Character:FindFirstChild("Gun") or player.Backpack and player.Backpack:FindFirstChild("Gun")) then
			return player
		end
	end
	return nil
end
local predictionAmount = 2.8
local function shootMurderer()
	local murderer = getMurderer()
	if murderer then
		local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
		local originalCFrame = rootPart.CFrame
		rootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
		wait(0.18)
		if getSheriff() ~= LocalPlayer then
			print("You're not sheriff/hero.")
			return
		end
		local currentMurderer = getMurderer()
		if not currentMurderer then
			print("No murderer to shoot.")
			return
		end
		if not LocalPlayer.Character:FindFirstChild("Gun") then
			local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if LocalPlayer.Backpack:FindFirstChild("Gun") then
				humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Gun"))
			else
				print("You don't have the gun..?")
				return
			end
		end
		if not currentMurderer.Character:FindFirstChild("HumanoidRootPart") then
			print("Could not find the murderer's HumanoidRootPart.")
			return
		end
		LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, predictPosition(currentMurderer, predictionAmount), "AH2")
		rootPart.CFrame = originalCFrame
	else
		print("no murder")
	end
end
Tabs.combat:Button({
	Title = "loc:shootmurder",
	Callback = function()
		if LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun") then
			shootMurderer()
		else
			sendnotification("You re not a Sheriff/Hero")
		end
	end
})
Tabs.combat:Toggle({
	Title = "loc:viewsheriff",
	Value = false,
	Callback = function(value)
		if value then
			local sheriff = nil
			for _, player in pairs(game.Players:GetPlayers()) do
				if player.Character and (player.Character:FindFirstChild("Gun") or player.Backpack and player.Backpack:FindFirstChild("Gun")) then
					sheriff = player
					break
				end
			end
			if sheriff then
				game.Workspace.CurrentCamera.CameraSubject = sheriff.Character:WaitForChild("Humanoid")
			else
				game.Workspace.CurrentCamera.CameraSubject = nil
			end
		else
			game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
		end
	end
})
local silentAimEnabled = false
local silentAimType = "Seismic"
Tabs.combat:Dropdown({
	Title = "loc:silentaimtype",
	Values = {
		"Seismic",
		"Overflow",
		"Dynamic",
		"Regular"
	},
	Value = "Seismic",
	Callback = function(value)
		silentAimType = value
	end
})
Tabs.combat:Toggle({
	Title = "loc:togsilentaim",
	Value = false,
	Callback = function(value)
		silentAimEnabled = value
	end
})
Tabs.combat:Keybind({
	Title = "loc:silentaim",
	Value = "Q",
	Callback = function()
		if silentAimEnabled == true then
			if getSheriff() ~= LocalPlayer then
				print("You're not sheriff/hero.")
				return
			end
			local murderer = getMurderer()
			if not murderer then
				print("No murderer to shoot.")
				return
			end
			if not LocalPlayer.Character:FindFirstChild("Gun") then
				local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
				if LocalPlayer.Backpack:FindFirstChild("Gun") then
					humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Gun"))
				else
					print("You don't have the gun..?")
					return
				end
			end
			local murdererRootPart = murderer.Character:FindFirstChild("HumanoidRootPart")
			if not murdererRootPart then
				print("Could not find the murderer's HumanoidRootPart.")
				return
			end
			local targetPos = nil
			local velocity = murdererRootPart.AssemblyLinearVelocity
			local moveDir = murderer.Character.Humanoid.MoveDirection
			if silentAimType == "Seismic" then
				if velocity.Magnitude == 0 then
					targetPos = murdererRootPart.Position
				else
					local offset = velocity.Unit * murdererRootPart.Velocity.Magnitude / 16.5
					local yOffset = offset.Y
					if yOffset > 2.65 then
						yOffset = 2.65
					elseif yOffset < -2 then
						yOffset = -2
					end
					targetPos = murdererRootPart.Position + Vector3.new(offset.X, yOffset, offset.Z / 1.25)
				end
			elseif silentAimType == "Overflow" then
				if velocity.Magnitude == 0 then
					targetPos = murdererRootPart.Position
				else
					local offset = velocity.Unit * murdererRootPart.Velocity.Magnitude / 17 + moveDir
					local yOffset = offset.Y
					if yOffset > 2.5 then
						yOffset = 2.5
					elseif yOffset < -2 then
						yOffset = -2
					end
					targetPos = murdererRootPart.Position + Vector3.new(offset.X, yOffset, offset.Z)
				end
			elseif silentAimType == "Dynamic" then
				targetPos = murdererRootPart.Position + moveDir
			elseif silentAimType == "Regular" then
				targetPos = murdererRootPart.Position
			end
			LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
		end
	end
})
aimbotEnabled = false
predictionEnabled = false
Tabs.combat:Toggle({
	Title = "loc:aimbot",
	Value = false,
	Callback = function(value)
		aimbotEnabled = value
	end
})
fovRadius = 240
aimbotTargetPart = "HumanoidRootPart"
Tabs.combat:Toggle({
	Title = "loc:prediction",
	Value = false,
	Callback = function(value)
		predictionEnabled = value
	end
})
Tabs.combat:Slider({
	Title = "loc:fovradius",
	Value = {
		Min = 80,
		Max = 340,
		Default = 240
	},
	Callback = function(value)
		fovRadius = tonumber(value)
	end
})
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local predictionOffset = Vector3.new(0, 0.1, 0)
local predictionTime = 0.2
function GetClosestPlayerToMouse()
	local closestDist = fovRadius
	local closestPlayer = nil
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and (player.Character:FindFirstChild("Knife") ~= nil or player.Backpack and player.Backpack:FindFirstChild("Knife") ~= nil) and player.Character:FindFirstChild(aimbotTargetPart) and player ~= LocalPlayer and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
			local pos, onScreen = Camera:WorldToViewportPoint(player.Character[aimbotTargetPart].Position)
			if onScreen then
				local dist = (Vector2.new(tonumber(Mouse.X), tonumber(Mouse.Y)) - Vector2.new(pos.X, pos.Y)).Magnitude
				if dist < closestDist then
					closestPlayer = player.Character
					closestDist = dist
				end
			end
		end
	end
	return closestPlayer, closestDist < fovRadius
end
function LockCursor()
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end
function UnlockCursor()
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
		local target, inFov = GetClosestPlayerToMouse()
		if inFov then
			LockCursor()
		end
		while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) do
			if aimbotEnabled and target then
				local targetCFrame
				if predictionEnabled then
					targetCFrame = target[aimbotTargetPart].CFrame + target[aimbotTargetPart].Velocity * predictionTime + predictionOffset or target[aimbotTargetPart].CFrame
				else
					targetCFrame = target[aimbotTargetPart].CFrame
				end
				Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetCFrame.Position)
			else
				break
			end
			task.wait()
		end
		UnlockCursor()
	end
end)
Tabs.combat:Section({
	Title = gradient("Combat Murderer", Color3.fromHex("#FF0000"), Color3.fromHex("#FF0000"))
})
function Stab()
	game:GetService("Players").LocalPlayer.Character.Knife.Stab:FireServer("Down")
end
function EquipTool()
	for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if tool.Name == "Knife" then
			game.Players.LocalPlayer.Backpack.Knife.Parent = game.Players.LocalPlayer.Character
		end
	end
end
Tabs.combat:Toggle({
	Title = "loc:autokillall",
	Value = false,
	Callback = function(value)
		autokillallloop = value
		while autokillallloop do
			local function autokillallloopfix()
				EquipTool()
				wait()
				local char = game.Players.LocalPlayer.Character
				local knife = char and char:FindFirstChild("Knife")
				wait()
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player ~= game.Players.LocalPlayer then
						wait()
						local targetChar = player.Character
						local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
						if targetRoot then
							Stab()
							firetouchinterest(targetRoot, knife.Handle, 1)
							firetouchinterest(targetRoot, knife.Handle, 0)
						end
					end
				end
				wait()
			end
			wait()
			pcall(autokillallloopfix)
		end
	end
})
local killPlayerDropdown = Tabs.combat:Dropdown({
	Title = "loc:selectplayers",
	Values = killPlayerList,
	Value = {
		" playerlist updated "
	},
	Multi = true,
	AllowNone = false
})
Tabs.combat:Toggle({
	Title = "loc:autokillselected",
	Value = false,
	Callback = function(value)
		autokillSelectedRunning = value
		task.spawn(function()
			while autokillSelectedRunning do
				pcall(function()
					EquipTool()
					task.wait()
					local char = game.Players.LocalPlayer.Character
					local knife = char and char:FindFirstChild("Knife")
					if not knife then
						return
					end
					if not killPlayerDropdown.Value or type(killPlayerDropdown.Value) ~= "table" then
						return
					end
					for playerName, isSelected in pairs(killPlayerDropdown.Value) do
						if isSelected then
							print("Selected:", playerName)
						end
					end
					for playerName, isSelected in pairs(killPlayerDropdown.Value) do
						if isSelected then
							local player = game.Players:FindFirstChild(playerName)
							if player and player.Character then
								local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
								if targetRoot then
									Stab()
									firetouchinterest(targetRoot, knife.Handle, 1)
									firetouchinterest(targetRoot, knife.Handle, 0)
								end
							end
							task.wait(0.1)
						end
					end
				end)
				task.wait(0.5)
			end
		end)
	end
})
Tabs.combat:Button({
	Title = "loc:killsheriff",
	Callback = function()
		local player = game:GetService("Players").LocalPlayer
		if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
			pcall(function()
				EquipTool()
				task.wait()
				local char = player.Character
				local knife = char and char:FindFirstChild("Knife")
				if not knife then
					return
				end
				local sheriff = getSheriff()
				if sheriff then
					local targetChar = sheriff.Character
					local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
					if targetRoot then
						Stab()
						firetouchinterest(targetRoot, knife.Handle, 1)
						firetouchinterest(targetRoot, knife.Handle, 0)
					end
				end
			end)
		else
			sendnotification("You are not a murderer!")
		end
	end
})
Tabs.combat:Toggle({
	Title = "loc:autokillsheriff",
	Value = false,
	Callback = function(value)
		autokillshloop = value
		while autokillshloop do
			pcall(function()
				EquipTool()
				wait()
				local char = game.Players.LocalPlayer.Character
				local knife = char and char:FindFirstChild("Knife")
				if not knife then
					return
				end
				local sheriff = getSheriff()
				if sheriff then
					local targetChar = sheriff.Character
					local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
					if targetRoot then
						Stab()
						firetouchinterest(targetRoot, knife.Handle, 1)
						firetouchinterest(targetRoot, knife.Handle, 0)
					end
				end
			end)
			wait(0.2)
		end
	end
})
Tabs.combat:Toggle({
	Title = "loc:viewmurder",
	Value = false,
	Callback = function(value)
		if value then
			local murderer = nil
			for _, player in pairs(game.Players:GetPlayers()) do
				if player.Character and (player.Character:FindFirstChild("Knife") or player.Backpack and player.Backpack:FindFirstChild("Knife")) then
					murderer = player
					break
				end
			end
			if murderer then
				game.Workspace.CurrentCamera.CameraSubject = murderer.Character:WaitForChild("Humanoid")
			else
				game.Workspace.CurrentCamera.CameraSubject = nil
			end
		else
			game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
		end
	end
})
Tabs.combat:Toggle({
	Title = "loc:knifeaura",
	Value = false,
	Callback = function(value)
		knifeauraloop = value
		while knifeauraloop do
			local function knifeAuraLoopFix()
				for _, player in pairs(game.Players:GetPlayers()) do
					if player ~= game.Players.LocalPlayer and game.Players.LocalPlayer:DistanceFromCharacter(player.Character.HumanoidRootPart.Position) < kniferangenum then
						EquipTool()
						wait()
						local char = game.Players.LocalPlayer.Character
						local knife = char and char:FindFirstChild("Knife")
						wait()
						local targetChar = player.Character
						local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
						if targetRoot then
							Stab()
							firetouchinterest(targetRoot, knife.Handle, 1)
							firetouchinterest(targetRoot, knife.Handle, 0)
						end
					end
				end
			end
			wait()
			pcall(knifeAuraLoopFix)
		end
	end
})
Tabs.combat:Slider({
	Title = "loc:knifeaurarange",
	Value = {
		Min = 5,
		Max = 300,
		Default = 20
	},
	Callback = function(value)
		kniferangenum = tonumber(value)
	end
})
Tabs.troll:Section({
	Title = "Fling"
})
local flingPlayerDropdown = Tabs.troll:Dropdown({
	Title = "loc:selectplayerfling",
	Values = flingPlayerList,
	Callback = function(value)
		Flingtarget = value
	end
})
Tabs.troll:Button({
	Title = "loc:flingplayer",
	Callback = function()
		print("flinging..")
		local targetName = Flingtarget
		if not targetName then
			sendnotification("No player selected to fling.")
			return
		end
		local targetPlayer = Players:FindFirstChild(targetName)
		if targetPlayer and targetPlayer ~= LocalPlayer then
			flingPlayerLogic(targetPlayer)
		elseif targetName == "All" then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					flingPlayerLogic(player)
				end
			end
		else
			sendnotification("Invalid or no player selected.")
		end
		print("Flinged")
	end
})
Tabs.troll:Button({
	Title = "loc:flingmurder",
	Callback = function()
		if LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")) then
			print("You murd bro")
			sendnotification("You are the Murderer! Fling Stopped")
			return
		end
		print("flinging..")
		local murderer = getMurderer()
		if murderer then
			flingPlayerLogic(murderer)
			print("Flinged")
		else
			sendnotification("Murderer not found. Fling Stopped")
			print("Murder not found. Stopped")
		end
	end
})
Tabs.troll:Button({
	Title = "loc:flingsheriff",
	Callback = function()
		if LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")) then
			print("You sher bro")
			sendnotification("You are the Sheriff! Fling Stopped")
			return
		end
		print("flinging..")
		local sheriff = getSheriff()
		if sheriff then
			flingPlayerLogic(sheriff)
			print("Flinged")
		else
			sendnotification("Sheriff not found. Fling Stopped")
			print("Sheriff not found. Stopped")
		end
	end
})
Tabs.troll:Slider({
	Title = "loc:flingstrenght",
	Value = {
		Min = 2000,
		Max = 100000,
		Default = FlingPower
	},
	Callback = function(value)
		FlingPower = tonumber(value)
	end
})
Tabs.troll:Section({
	Title = "Gang Bang"
})
local bangTargetName = ""
local bangTargetPlayer = nil
local bangEnabled = false
local bangAnimationId = "10714068222"
local bangAnimationTrack = nil
local bangCoroutine = nil
local bangConnection = nil
local suckEnabled = false
local suckAnimationId = "5918726674"
local suckAnimationTrack = nil
local suckCoroutine = nil
local suckConnection = nil
local originalGravity = nil
Tabs.troll:Input({
	Title = "loc:inputbang",
	Type = "Input",
	Placeholder = "...",
	Callback = function(value)
		bangTargetName = value:lower()
		print("Target set to:", bangTargetName)
	end
})
local function findBangTarget()
	for _, player in pairs(Players:GetPlayers()) do
		if (string.find(player.Name:lower(), bangTargetName) or string.find(player.DisplayName:lower(), bangTargetName)) and player ~= LocalPlayer then
			return player
		end
	end
	return nil
end
local function playAnimation(humanoid, animId)
	if humanoid then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. animId
		local track = humanoid:LoadAnimation(anim)
		track:Play()
		return track
	end
end
function stopBang()
	bangEnabled = false
	if bangAnimationTrack then
		bangAnimationTrack:Stop()
		bangAnimationTrack = nil
	end
	bangCoroutine = nil
	if bangConnection then
		bangConnection:Disconnect()
		bangConnection = nil
	end
end
local function stopSuck()
	suckEnabled = false
	if suckAnimationTrack then
		suckAnimationTrack:Stop()
		suckAnimationTrack = nil
	end
	if suckCoroutine then
		suckCoroutine = nil
	end
	if suckConnection then
		suckConnection:Disconnect()
		suckConnection = nil
	end
	if originalGravity then
		Workspace.Gravity = originalGravity
		originalGravity = nil
	end
end
Tabs.troll:Toggle({
	Title = "loc:bang",
	Value = false,
	Callback = function(value)
		if not value then
			stopBang()
			return
		end
		bangTargetPlayer = findBangTarget()
		if not bangTargetPlayer then
			print("Target not found for Bang!")
			stopBang()
			return
		end
		bangEnabled = true
		bangCoroutine = coroutine.wrap(function()
			while bangEnabled do
				local char = LocalPlayer.Character
				local humanoid = char and char:FindFirstChildOfClass("Humanoid")
				local rootPart = char and char:FindFirstChild("HumanoidRootPart")
				local targetChar = bangTargetPlayer.Character
				local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
				if humanoid and rootPart and targetRoot then
					if not bangAnimationTrack or not bangAnimationTrack.IsPlaying then
						bangAnimationTrack = playAnimation(humanoid, bangAnimationId)
						bangAnimationTrack:AdjustSpeed(2)
					end
					local targetCFrame = targetRoot.CFrame * CFrame.new(0, 0, 2.5)
					TweenService:Create(rootPart, TweenInfo.new(0.2), {
						CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
					}):Play()
					wait(0.2)
					TweenService:Create(rootPart, TweenInfo.new(0.2), {
						CFrame = targetCFrame
					}):Play()
					wait(0.2)
				end
				wait(0.5)
			end
			if bangAnimationTrack then
				bangAnimationTrack:Stop()
				bangAnimationTrack = nil
			end
		end)
		bangCoroutine()
		bangConnection = LocalPlayer.CharacterAdded:Connect(function(char)
			if bangEnabled then
				local humanoid = char:WaitForChild("Humanoid")
				if bangAnimationTrack then
					bangAnimationTrack:Stop()
				end
				bangAnimationTrack = playAnimation(humanoid, bangAnimationId)
				bangAnimationTrack:AdjustSpeed(2)
			end
		end)
	end
})
Tabs.troll:Toggle({
	Title = "loc:getsuck",
	Value = false,
	Callback = function(value)
		if not value then
			stopSuck()
			return
		end
		bangTargetPlayer = findBangTarget()
		if not bangTargetPlayer then
			print("Target not found for Get Sucked!")
			stopSuck()
			return
		end
		suckEnabled = true
		originalGravity = Workspace.Gravity
		Workspace.Gravity = 0
		suckCoroutine = coroutine.wrap(function()
			local char = LocalPlayer.Character
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			if humanoid then
				suckAnimationTrack = playAnimation(humanoid, suckAnimationId)
				suckAnimationTrack:AdjustSpeed(1)
			end
			while suckEnabled do
				local localChar = LocalPlayer.Character
				local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
				local targetRoot = bangTargetPlayer.Character and bangTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
				if localRoot and targetRoot then
					localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 2.3, -1.1) * CFrame.Angles(0, math.pi, 0)
					localRoot.Velocity = Vector3.new(0, 0, 0)
				else
					wait(0.5)
				end
				RunService.Heartbeat:Wait()
			end
			if suckAnimationTrack then
				suckAnimationTrack:Stop()
				suckAnimationTrack = nil
			end
			if originalGravity then
				Workspace.Gravity = originalGravity
				originalGravity = nil
			end
		end)
		suckCoroutine()
		suckConnection = LocalPlayer.CharacterAdded:Connect(function(char)
			if suckEnabled then
				local humanoid = char:WaitForChild("Humanoid")
				if suckAnimationTrack then
					suckAnimationTrack:Stop()
				end
				suckAnimationTrack = playAnimation(humanoid, suckAnimationId)
				suckAnimationTrack:AdjustSpeed(1)
			end
		end)
	end
})
Tabs.troll:Section({
	Title = "Fake Die"
})
Tabs.troll:Button({
	Title = "loc:layonback",
	Callback = function()
		local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		humanoid.Sit = true
		task.wait(0.1)
		humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			track:Stop()
		end
		wait()
	end
})
Tabs.troll:Button({
	Title = "loc:sitdown",
	Callback = function()
		game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
		wait()
	end
})
local ragdollMoveSpeed = 6000
local ragdollConnections = {}
local ragdollTool = nil
local ragdollHandle = nil
local isRagdolled = false
local moveDirection = Vector3.zero
local moveForce = nil
local inputBeganConn, inputEndedConn, spacebarConn, renderSteppedConn
local originalMotor6Ds = {}
local function stopToolNoneAnims()
	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				table.insert(ragdollConnections, animator.AnimationPlayed:Connect(function(track)
					local animId = track.Animation.AnimationId
					if animId:match("507766388") or animId:match("507766666") or track.Name:lower():match("toolnone") then
						track:Stop()
					end
				end))
			end
		end
	end
end
local function createMoveForce(parent)
	moveForce = Instance.new("BodyForce")
	moveForce.Name = "MoveForce"
	moveForce.Force = Vector3.zero
	moveForce.Parent = parent
	renderSteppedConn = RunService.RenderStepped:Connect(function()
		if isRagdolled and moveForce and Workspace.CurrentCamera then
			local camera = Workspace.CurrentCamera
			local forceDirection = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit * moveDirection.Z + Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z).Unit * moveDirection.X
			if forceDirection.Magnitude > 0 then
				forceDirection = forceDirection.Unit
			end
			moveForce.Force = forceDirection * ragdollMoveSpeed
		end
	end)
end
local function removeMoveForce()
	if renderSteppedConn then
		renderSteppedConn:Disconnect()
	end
	if moveForce then
		moveForce:Destroy()
	end
	moveForce = nil
end
local function setupRagdollControls(char)
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if rootPart then
		createMoveForce(rootPart)
	end
	inputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.W then
				moveDirection = Vector3.new(moveDirection.X, 0, 1)
			end
			if input.KeyCode == Enum.KeyCode.S then
				moveDirection = Vector3.new(moveDirection.X, 0, -1)
			end
			if input.KeyCode == Enum.KeyCode.A then
				moveDirection = Vector3.new(-1, 0, moveDirection.Z)
			end
			if input.KeyCode == Enum.KeyCode.D then
				moveDirection = Vector3.new(1, 0, moveDirection.Z)
			end
		end
	end)
	inputEndedConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
				moveDirection = Vector3.new(moveDirection.X, 0, 0)
			elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
				moveDirection = Vector3.new(0, 0, moveDirection.Z)
			end
		end
	end)
	spacebarConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.KeyCode == Enum.KeyCode.Space and isRagdolled then
			removeMoveForce()
			inputBeganConn:Disconnect()
			inputEndedConn:Disconnect()
			spacebarConn:Disconnect()
			for _, descendant in ipairs(char:GetDescendants()) do
				if (descendant:IsA("BallSocketConstraint") and descendant.Name == "RagdollConstraint") or (descendant:IsA("Attachment") and descendant.Name:match("RagdollAttachment")) then
					descendant:Destroy()
				end
			end
			for _, data in ipairs(originalMotor6Ds) do
				local motor = Instance.new("Motor6D")
				motor.Name = data.Name
				motor.Part0 = data.Part0
				motor.Part1 = data.Part1
				motor.C0 = data.C0
				motor.C1 = data.C1
				motor.Parent = data.Parent
			end
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid then
				for _, state in ipairs({
					Enum.HumanoidStateType.GettingUp,
					Enum.HumanoidStateType.Jumping,
					Enum.HumanoidStateType.Freefall,
					Enum.HumanoidStateType.Flying,
					Enum.HumanoidStateType.Running,
					Enum.HumanoidStateType.Climbing,
					Enum.HumanoidStateType.Landed
				}) do
					humanoid:SetStateEnabled(state, true)
				end
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				humanoid.PlatformStand = false
			end
			isRagdolled = false
		end
	end)
end
local function enableRagdoll(char)
	if isRagdolled then
		return
	end
	isRagdolled = true
	originalMotor6Ds = {}
	for _, descendant in ipairs(char:GetDescendants()) do
		if descendant:IsA("Motor6D") and descendant.Part0 and descendant.Part1 then
			table.insert(originalMotor6Ds, {
				Name = descendant.Name,
				Parent = descendant.Parent,
				Part0 = descendant.Part0,
				Part1 = descendant.Part1,
				C0 = descendant.C0,
				C1 = descendant.C1
			})
			local att0 = Instance.new("Attachment", descendant.Part0)
			att0.Name = "RagdollAttachment0"
			att0.CFrame = descendant.C0
			local att1 = Instance.new("Attachment", descendant.Part1)
			att1.Name = "RagdollAttachment1"
			att1.CFrame = descendant.C1
			local constraint = Instance.new("BallSocketConstraint", descendant.Part0)
			constraint.Name = "RagdollConstraint"
			constraint.Attachment0 = att0
			constraint.Attachment1 = att1
			descendant:Destroy()
		end
	end
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.CanCollide = true
		end
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		for _, state in ipairs({
			Enum.HumanoidStateType.GettingUp,
			Enum.HumanoidStateType.Jumping,
			Enum.HumanoidStateType.Freefall,
			Enum.HumanoidStateType.Flying,
			Enum.HumanoidStateType.Running,
			Enum.HumanoidStateType.Climbing,
			Enum.HumanoidStateType.Landed
		}) do
			humanoid:SetStateEnabled(state, false)
		end
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		humanoid.PlatformStand = true
	end
	setupRagdollControls(char)
end
local function createRagdollTool()
	ragdollTool = Instance.new("Tool")
	ragdollTool.Name = "Ragdoll"
	ragdollTool.CanBeDropped = false
	ragdollTool.RequiresHandle = true
	ragdollHandle = Instance.new("Part")
	ragdollHandle.Name = "Handle"
	ragdollHandle.Size = Vector3.new(1, 1, 1)
	ragdollHandle.Transparency = 1
	ragdollHandle.CanCollide = false
	ragdollHandle.Parent = ragdollTool
	ragdollTool.Equipped:Connect(function()
		stopToolNoneAnims()
		if isRagdolled then
			setupRagdollControls(LocalPlayer.Character)
		end
	end)
	local debounce = false
	ragdollTool.Activated:Connect(function()
		if not debounce and not isRagdolled then
			debounce = true
			enableRagdoll(LocalPlayer.Character)
			wait(0.5)
			debounce = false
		end
	end)
	ragdollTool.Unequipped:Connect(function()
		if inputBeganConn then
			inputBeganConn:Disconnect()
		end
		if inputEndedConn then
			inputEndedConn:Disconnect()
		end
		if spacebarConn then
			spacebarConn:Disconnect()
		end
		coroutine.wrap(function()
			for _, conn in ipairs(ragdollConnections) do
				conn:Disconnect()
			end
			ragdollConnections = {}
		end)()
		removeMoveForce()
		isRagdolled = false
	end)
	ragdollTool.Parent = LocalPlayer.Backpack
	LocalPlayer.CharacterAdded:Connect(function()
		if ragdollTool then
			ragdollTool.Parent = LocalPlayer.Backpack
		end
	end)
end
Tabs.troll:Toggle({
	Title = "loc:ragdoll",
	Value = false,
	Callback = function(value)
		if value and not ragdollTool then
			createRagdollTool()
		elseif ragdollTool then
			if isRagdolled and LocalPlayer.Character then
				local char = LocalPlayer.Character
				for _, descendant in ipairs(char:GetDescendants()) do
					if (descendant:IsA("BallSocketConstraint") and descendant.Name == "RagdollConstraint") or (descendant:IsA("Attachment") and descendant.Name:match("RagdollAttachment")) then
						descendant:Destroy()
					end
				end
				for _, data in ipairs(originalMotor6Ds) do
					local motor = Instance.new("Motor6D")
					motor.Name = data.Name
					motor.Part0 = data.Part0
					motor.Part1 = data.Part1
					motor.C0 = data.C0
					motor.C1 = data.C1
					motor.Parent = data.Parent
				end
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				if humanoid then
					for _, state in ipairs({
						Enum.HumanoidStateType.GettingUp,
						Enum.HumanoidStateType.Jumping,
						Enum.HumanoidStateType.Freefall,
						Enum.HumanoidStateType.Flying,
						Enum.HumanoidStateType.Running,
						Enum.HumanoidStateType.Climbing,
						Enum.HumanoidStateType.Landed
					}) do
						humanoid:SetStateEnabled(state, true)
					end
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					humanoid.PlatformStand = false
				end
				if inputBeganConn then
					inputBeganConn:Disconnect()
				end
				if inputEndedConn then
					inputEndedConn:Disconnect()
				end
				if spacebarConn then
					spacebarConn:Disconnect()
				end
				removeMoveForce()
				isRagdolled = false
			end
			ragdollTool:Destroy()
			ragdollTool = nil
			ragdollHandle = nil
		end
	end
})
Tabs.esp:Section({
	Title = "Esp"
})
function CreateHighlight()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer and player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character:FindFirstChild("ESP_Highlight") then
			local highlight = Instance.new("Highlight", player.Character)
			highlight.Name = "ESP_Highlight"
			highlight.FillColor = Color3.fromRGB(160, 160, 160)
			highlight.OutlineTransparency = 1
			highlight.FillTransparency = applyesptrans
		end
	end
end
function UpdateHighlights()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer and player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("ESP_Highlight") then
			local highlight = player.Character:FindFirstChild("ESP_Highlight")
			if player.Name == Sheriff and IsAlive(player) then
				highlight.FillColor = Color3.fromRGB(0, 0, 225)
				highlight.FillTransparency = applyesptrans
			elseif player.Name == Murder and IsAlive(player) then
				highlight.FillColor = Color3.fromRGB(225, 0, 0)
				highlight.FillTransparency = applyesptrans
			elseif player.Name == Hero and IsAlive(player) and player.Backpack:FindFirstChild("Gun") then
				highlight.FillColor = Color3.fromRGB(255, 255, 0)
				highlight.FillTransparency = applyesptrans
			elseif player.Name == Hero and IsAlive(player) and player.Character:FindFirstChild("Gun") then
				highlight.FillColor = Color3.fromRGB(255, 255, 0)
				highlight.FillTransparency = applyesptrans
			elseif not IsAlive(player) then
				highlight.FillColor = Color3.fromRGB(100, 100, 100)
				highlight.FillTransparency = applyesptrans
			else
				highlight.FillColor = Color3.fromRGB(0, 225, 0)
				highlight.FillTransparency = applyesptrans
			end
		end
	end
end
function IsAlive(player)
	for name, data in pairs(roles) do
		if player.Name == name then
			if not data.Killed and not data.Dead then
				return true
			end
			return false
		end
	end
end
function HideHighlights()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer and player.Character ~= nil and player.Character:FindFirstChild("ESP_Highlight") then
			player.Character:FindFirstChild("ESP_Highlight"):Destroy()
		end
	end
end
applyesptrans = 0.5
Tabs.esp:Toggle({
	Title = "loc:espplayers",
	Value = false,
	Callback = function(value)
		if value then
			SSeeRoles = true
			while SSeeRoles == true do
				roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
				for name, data in pairs(roles) do
					if data.Role == "Murderer" then
						Murder = name
					elseif data.Role == "Sheriff" then
						Sheriff = name
					elseif data.Role == "Hero" then
						Hero = name
					end
				end
				CreateHighlight()
				UpdateHighlights()
			end
		else
			SSeeRoles = false
			task.wait(0.2)
			HideHighlights()
		end
	end
})
Tabs.esp:Slider({
	Title = "loc:esptrans",
	Value = {
		Min = 0,
		Max = 9,
		Default = 4
	},
	Callback = function(value)
		applyesptrans = value * 0.1
	end
})
local ESPHolder = Instance.new("Folder", CoreGui)
ESPHolder.Name = "ESP Holder"
local function createNameEsp(player)
	local billboard = Instance.new("BillboardGui", ESPHolder)
	billboard.Name = player.Name
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.fromOffset(200, 50)
	billboard.ExtentsOffset = Vector3.new(0, 3, 0)
	billboard.Enabled = false
	local label = Instance.new("TextLabel", billboard)
	label.TextSize = 15
	label.Text = player.Name
	label.Font = Enum.Font.Legacy
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	if getgenv().AllEsp then
		billboard.Enabled = true
	end
	repeat
		wait()
		pcall(function()
			billboard.Adornee = player.Character.Head
			if player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
				label.TextColor3 = Color3.new(1, 0, 0)
				if not billboard.Enabled and getgenv().MurderEsp then
					billboard.Enabled = true
				end
			elseif player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
				label.TextColor3 = Color3.new(0, 0, 1)
				if not billboard.Enabled and getgenv().SheriffEsp then
					billboard.Enabled = true
				end
			else
				label.TextColor3 = Color3.new(0, 1, 0)
			end
		end)
	until not player.Parent
end
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		coroutine.wrap(createNameEsp)(player)
	end
end
Players.PlayerAdded:Connect(createNameEsp)
Players.PlayerRemoving:Connect(function(player)
	ESPHolder[player.Name]:Destroy()
end)
Tabs.esp:Toggle({
	Title = "loc:playersnameesp",
	Value = false,
	Callback = function(value)
		getgenv().AllEsp = value
		for _, child in pairs(ESPHolder:GetChildren()) do
			if child:IsA("BillboardGui") and Players[tostring(child.Name)] then
				if getgenv().AllEsp then
					child.Enabled = true
				else
					child.Enabled = false
				end
			end
		end
	end
})
gunEspEnabled = false
local CollectionService = game:GetService("CollectionService")
function createGunEsp(part)
	if part and not part:FindFirstChild("Esp_gun") then
		local billboard = Instance.new("BillboardGui", part)
		billboard.Name = "Esp_gun"
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		local label = Instance.new("TextLabel", billboard)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Dropped Gun"
		label.TextColor3 = Color3.fromRGB(255, 0, 0)
		label.TextStrokeTransparency = 0
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		label.TextScaled = true
	end
end
local function removeAllGunEsp()
	for _, part in pairs(CollectionService:GetTagged("GunDrop")) do
		local esp = part:FindFirstChild("Esp_gun")
		if esp then
			esp:Destroy()
		end
	end
end
local function createAllGunEsp()
	for _, part in pairs(CollectionService:GetTagged("GunDrop")) do
		createGunEsp(part)
	end
end
Tabs.esp:Toggle({
	Title = "loc:espdropgun",
	Value = false,
	Callback = function(value)
		gunEspEnabled = value
		if value then
			CollectionService:GetInstanceAddedSignal("GunDrop"):Connect(function(part)
				if gunEspEnabled then
					createGunEsp(part)
				end
			end)
			CollectionService:GetInstanceRemovedSignal("GunDrop"):Connect(function(part)
				if gunEspEnabled then
					local esp = part:FindFirstChild("Esp_gun")
					if esp then
						esp:Destroy()
					end
				end
			end)
			createAllGunEsp()
		else
			removeAllGunEsp()
		end
	end
})
Tabs.esp:Section({
	Title = "New Esp"
})
local highlightSettings = {
	HighlightMurderer = false,
	HighlightInnocent = false,
	HighlightSheriff = false,
	ShowDead = false
}
local murdererName = nil
local sheriffName = nil
local heroName = nil
local playerData = {}
local function getOrCreateHighlight(player)
	if player == LocalPlayer then
		return nil
	end
	if not player.Character then
		return nil
	end
	local highlight = player.Character:FindFirstChild("Highlight")
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Adornee = player.Character
		highlight.Parent = player.Character
	end
	return highlight
end
local function isPlayerAlive(player)
	local data = playerData[player.Name]
	if data and not data.Killed and not data.Dead then
		return true
	end
	return false
end
local function updatePlayerData()
	local success, result = pcall(function()
		return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
	end)
	if success and type(result) == "table" then
		playerData = result
		heroName = nil
		sheriffName = nil
		murdererName = nil
		for name, data in pairs(playerData) do
			if data.Role == "Murderer" then
				murdererName = name
			elseif data.Role == "Sheriff" then
				sheriffName = name
			elseif data.Role == "Hero" then
				heroName = name
			end
		end
	end
end
local function getPlayerByName(name)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name == name then
			return player
		end
	end
	return nil
end
local function updateAllHighlights()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local highlight = getOrCreateHighlight(player)
			if highlight then
				local enabled = false
				local color = Color3.new(1, 1, 1)
				local alive = isPlayerAlive(player)
				if highlightSettings.ShowDead and not alive then
					color = Color3.fromRGB(128, 128, 128)
					enabled = true
				else
					local murdererPlayer = getPlayerByName(murdererName)
					local sheriffPlayer = getPlayerByName(sheriffName)
					local heroPlayer = getPlayerByName(heroName)
					if highlightSettings.HighlightMurderer and murdererPlayer == player and alive then
						color = Color3.fromRGB(255, 0, 0)
						enabled = true
					elseif highlightSettings.HighlightSheriff and sheriffPlayer == player and alive then
						color = Color3.fromRGB(0, 0, 255)
						enabled = true
					elseif highlightSettings.HighlightSheriff and heroPlayer == player and alive and (not sheriffPlayer or not isPlayerAlive(sheriffPlayer)) then
						color = Color3.fromRGB(255, 255, 0)
						enabled = true
					elseif highlightSettings.HighlightInnocent and alive and player.Name ~= murdererName and player.Name ~= sheriffName and player.Name ~= heroName then
						color = Color3.fromRGB(0, 255, 0)
						enabled = true
					end
				end
				highlight.Enabled = enabled
				highlight.FillColor = color
				highlight.OutlineColor = color
			end
		end
	end
end
RunService.Heartbeat:Connect(function()
	updatePlayerData()
	updateAllHighlights()
end)
Tabs.esp:Toggle({
	Title = "loc:innoesp",
	Value = false,
	Callback = function(value)
		highlightSettings.HighlightInnocent = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:sheresp",
	Value = false,
	Callback = function(value)
		highlightSettings.HighlightSheriff = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:murdesp",
	Value = false,
	Callback = function(value)
		highlightSettings.HighlightMurderer = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:showdead",
	Value = false,
	Callback = function(value)
		highlightSettings.ShowDead = value
	end
})
Tabs.esp:Section({
	Title = "Esp Boxes"
})
local Camera = Workspace.CurrentCamera
local boxEspSettings = {
	Murderer = false,
	Sheriff = false,
	Innocent = false,
	ShowDead = false
}
local boxEspCache = {}
local boxEspPlayerData = {}
local boxEspMurdererName = nil
local boxEspSheriffName = nil
local boxEspHeroName = nil
local function isBoxEspPlayerAlive(player)
	local data = boxEspPlayerData[player.Name]
	if data and not data.Killed and not data.Dead then
		return true
	end
	return false
end
local function getPlayerRole(player)
	local data = boxEspPlayerData[player.Name]
	if not data then
		return "Innocent"
	end
	if data.Role then
		return data.Role
	end
	return "Innocent"
end
local function updateBoxEspPlayerData()
	local success, result = pcall(function()
		if ReplicatedStorage:FindFirstChild("GetPlayerData", true) then
			return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
		end
	end)
	if success and type(result) == "table" then
		boxEspPlayerData = result
		boxEspHeroName = nil
		boxEspSheriffName = nil
		boxEspMurdererName = nil
		for name, data in pairs(boxEspPlayerData) do
			if data.Role == "Murderer" then
				boxEspMurdererName = name
			elseif data.Role == "Sheriff" then
				boxEspSheriffName = name
			elseif data.Role == "Hero" then
				boxEspHeroName = name
			end
		end
	end
end
local function getOrCreateBoxEsp(player)
	if not boxEspCache[player] then
		boxEspCache[player] = {
			box = Drawing.new("Square")
		}
		local data = boxEspCache[player]
		data.box.Thickness = 2
		data.box.Filled = false
		data.box.Transparency = 1
		data.box.Visible = false
	end
	return boxEspCache[player]
end
local function removeBoxEsp(player)
	local data = boxEspCache[player]
	if data then
		if data.box then
			pcall(function()
				data.box:Remove()
			end)
		end
		boxEspCache[player] = nil
	end
end
local function updateAllBoxEsp()
	updateBoxEspPlayerData()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			local alive = isBoxEspPlayerAlive(player)
			local role = getPlayerRole(player)
			local espData = getOrCreateBoxEsp(player)
			if rootPart and humanoid and humanoid.Health > 0 then
				local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
				if onScreen then
					local color = Color3.fromRGB(255, 255, 255)
					local visible = false
					if role == "Murderer" and boxEspSettings.Murderer and alive then
						color = Color3.fromRGB(255, 0, 0)
						visible = true
					elseif role == "Sheriff" and boxEspSettings.Sheriff and alive then
						color = Color3.fromRGB(0, 0, 255)
						visible = true
					elseif boxEspSettings.Innocent then
						if alive and player.Name ~= boxEspMurdererName and player.Name ~= boxEspSheriffName and player.Name ~= boxEspHeroName then
							color = Color3.fromRGB(0, 255, 0)
							visible = true
						elseif boxEspSettings.ShowDead and not alive then
							color = Color3.fromRGB(128, 128, 128)
							visible = true
						end
					end
					local head = char:FindFirstChild("Head")
					if head then
						local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
						local height = math.abs(headPos.Y - Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y)
						local width = height * 0.5
						espData.box.Size = Vector2.new(width, height)
						espData.box.Position = Vector2.new(pos.X - width / 2, headPos.Y)
						espData.box.Color = color
						espData.box.Visible = visible
					else
						espData.box.Visible = false
					end
				else
					espData.box.Visible = false
				end
			else
				removeBoxEsp(player)
			end
		end
	end
end
Players.PlayerRemoving:Connect(removeBoxEsp)
RunService.RenderStepped:Connect(updateAllBoxEsp)
Tabs.esp:Toggle({
	Title = "loc:boxesmurd",
	Value = false,
	Callback = function(value)
		boxEspSettings.Murderer = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:boxessher",
	Value = false,
	Callback = function(value)
		boxEspSettings.Sheriff = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:boxesinno",
	Value = false,
	Callback = function(value)
		boxEspSettings.Innocent = value
	end
})
Tabs.esp:Toggle({
	Title = "loc:boxesdead",
	Value = false,
	Callback = function(value)
		boxEspSettings.ShowDead = value
	end
})
Tabs.visual:Section({
	Title = "Visual"
})
local xrayEnabled = false
local xrayTransparency = 0.9
function updateXray()
	local function setPartTransparency(parent, transparency)
		for _, child in pairs(parent:GetChildren()) do
			if child:IsA("BasePart") and not child.Parent:FindFirstChild("Humanoid") and not child.Parent.Parent:FindFirstChild("Humanoid") then
				child.LocalTransparencyModifier = transparency
			end
			setPartTransparency(child, transparency)
		end
	end
	if xrayEnabled then
		setPartTransparency(Workspace, xrayTransparency)
	else
		setPartTransparency(Workspace, 0)
	end
end
Tabs.visual:Toggle({
	Title = "loc:xray",
	Value = false,
	Callback = function(value)
		xrayEnabled = value
		updateXray()
	end
})
Tabs.visual:Slider({
	Title = "loc:xraytrans",
	Value = {
		Min = 0,
		Max = 10,
		Default = 9
	},
	Callback = function(value)
		xrayTransparency = value * 0.1
		if xrayEnabled then
			updateXray()
		end
	end
})
Tabs.visual:Toggle({
	Title = "loc:improvefps",
	Value = false,
	Callback = function(value)
		improvefpsloop = value
		while improvefpsloop do
			for _, descendant in pairs(Workspace:GetDescendants()) do
				if descendant.Name == "Pet" then
					descendant:Destroy()
				elseif descendant.Name == "KnifeDisplay" then
					descendant:Destroy()
				elseif descendant.Name == "GunDisplay" then
					descendant:Destroy()
				end
			end
			wait(10)
		end
	end
})
Tabs.visual:Button({
	Title = "loc:boombox",
	Callback = function()
		_G.boomboxb = game:GetObjects("rbxassetid://740618400")[1]
		_G.boomboxb.Parent = game:GetService("Players").LocalPlayer.Backpack
		loadstring(_G.boomboxb.Client.Source)()
		loadstring(_G.boomboxb.Server.Source)()
	end
})
_G.HeadSize = 20
_G.HitboxColor = Color3.fromRGB(0, 0, 255)
local hitboxConnection = nil
local function setHitbox(part, enabled)
	if not part then
		return
	end
	pcall(function()
		if enabled then
			part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
			part.Transparency = 0.7
			part.Color = _G.HitboxColor
			part.Material = Enum.Material.Neon
			part.CanCollide = false
		else
			part.Size = Vector3.new(2, 2, 1)
			part.Transparency = 0
			part.Material = Enum.Material.Plastic
			part.CanCollide = true
		end
	end)
end
function updateAllHitboxes(enabled)
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer then
			local char = player.Character
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			if rootPart then
				setHitbox(rootPart, enabled)
			end
		end
	end
end
Tabs.visual:Toggle({
	Title = "loc:hitboxexpander",
	Value = false,
	Callback = function(value)
		if value then
			updateAllHitboxes(true)
			hitboxConnection = game:GetService("RunService").RenderStepped:Connect(function()
				updateAllHitboxes(true)
			end)
		else
			if hitboxConnection then
				hitboxConnection:Disconnect()
				hitboxConnection = nil
			end
			updateAllHitboxes(false)
		end
	end
})
Tabs.visual:Slider({
	Title = "loc:hitboxsize",
	Value = {
		Min = 5,
		Max = 100,
		Default = _G.HeadSize
	},
	Callback = function(value)
		_G.HeadSize = value
		if hitboxConnection then
			updateAllHitboxes(true)
		end
	end
})
Tabs.visual:Colorpicker({
	Title = "loc:hitboxcolor",
	Default = _G.HitboxColor,
	Transparency = 0,
	Locked = false,
	Callback = function(value)
		_G.HitboxColor = value
		if hitboxConnection then
			updateAllHitboxes(true)
		end
	end
})
local Lighting = game:GetService("Lighting")
local skyboxes = {
	Default = {
		Bk = "",
		Dn = "",
		Ft = "",
		Lf = "",
		Rt = "",
		Up = ""
	},
	["Default MM2 Summer"] = {
		Bk = "http://www.roblox.com/asset/?version=1&id=135483466",
		Dn = "http://www.roblox.com/asset/?version=1&id=135483484",
		Ft = "http://www.roblox.com/asset/?version=1&id=135483461",
		Lf = "http://www.roblox.com/asset/?version=1&id=135483495",
		Rt = "http://www.roblox.com/asset/?version=1&id=135483499",
		Up = "http://www.roblox.com/asset/?version=1&id=135483475"
	},
	Sunset = {
		Bk = "rbxassetid://600830446",
		Dn = "rbxassetid://600831635",
		Ft = "rbxassetid://600832720",
		Lf = "rbxassetid://600886090",
		Rt = "rbxassetid://600833862",
		Up = "rbxassetid://600835177"
	},
	Arctic = {
		Bk = "rbxassetid://225469390",
		Dn = "rbxassetid://225469395",
		Ft = "rbxassetid://225469403",
		Lf = "rbxassetid://225469450",
		Rt = "rbxassetid://225469471",
		Up = "rbxassetid://225469481"
	},
	Space = {
		Bk = "rbxassetid://166509999",
		Dn = "rbxassetid://166510057",
		Ft = "rbxassetid://166510116",
		Lf = "rbxassetid://166510092",
		Rt = "rbxassetid://166510131",
		Up = "rbxassetid://166510114"
	},
	["Pink Skies"] = {
		Bk = "rbxassetid://151165214",
		Dn = "rbxassetid://151165197",
		Ft = "rbxassetid://151165224",
		Lf = "rbxassetid://151165191",
		Rt = "rbxassetid://151165206",
		Up = "rbxassetid://151165227"
	},
	["Blue Night"] = {
		Bk = "rbxassetid://12064107",
		Dn = "rbxassetid://12064152",
		Ft = "rbxassetid://12064121",
		Lf = "rbxassetid://12063984",
		Rt = "rbxassetid://12064115",
		Up = "rbxassetid://12064131"
	},
	["Red Night"] = {
		Bk = "rbxassetid://401664839",
		Dn = "rbxassetid://401664862",
		Ft = "rbxassetid://401664960",
		Lf = "rbxassetid://401664881",
		Rt = "rbxassetid://401664901",
		Up = "rbxassetid://401664936"
	},
	["Purple Sunset"] = {
		Bk = "rbxassetid://264908339",
		Dn = "rbxassetid://264907909",
		Ft = "rbxassetid://264909420",
		Lf = "rbxassetid://264909758",
		Rt = "rbxassetid://264908886",
		Up = "rbxassetid://264907379"
	},
	["Blossom Daylight"] = {
		Bk = "rbxassetid://271042516",
		Dn = "rbxassetid://271077243",
		Ft = "rbxassetid://271042556",
		Lf = "rbxassetid://271042310",
		Rt = "rbxassetid://271042467",
		Up = "rbxassetid://271077958"
	},
	["Blue Nebula"] = {
		Bk = "rbxassetid://135207744",
		Dn = "rbxassetid://135207662",
		Ft = "rbxassetid://135207770",
		Lf = "rbxassetid://135207615",
		Rt = "rbxassetid://135207695",
		Up = "rbxassetid://135207794"
	},
	["Blue Planet"] = {
		Bk = "rbxassetid://218955819",
		Dn = "rbxassetid://218953419",
		Ft = "rbxassetid://218954524",
		Lf = "rbxassetid://218958493",
		Rt = "rbxassetid://218957134",
		Up = "rbxassetid://218950090"
	},
	["Deep Space"] = {
		Bk = "rbxassetid://159248188",
		Dn = "rbxassetid://159248183",
		Ft = "rbxassetid://159248187",
		Lf = "rbxassetid://159248173",
		Rt = "rbxassetid://159248192",
		Up = "rbxassetid://159248176"
	}
}
function setSkybox(name)
	if Lighting:FindFirstChildOfClass("Sky") then
		Lighting:FindFirstChildOfClass("Sky"):Destroy()
	end
	if name == "Default" then
		return
	end
	local sky = Instance.new("Sky")
	sky.Parent = Lighting
	for side, id in pairs(skyboxes[name]) do
		sky["Skybox" .. side] = id
	end
end
Tabs.visual:Dropdown({
	Title = "loc:skyboxselector",
	Values = {
		"Default",
		"Default MM2 Summer",
		"Sunset",
		"Arctic",
		"Space",
		"Pink Skies",
		"Blue Night",
		"Red Night",
		"Purple Sunset",
		"Blossom Daylight",
		"Blue Nebula",
		"Blue Planet",
		"Deep Space"
	},
	Value = "Default",
	Callback = function(value)
		setSkybox(value)
	end
})
Tabs.emotes:Section({
	Title = "Emotes"
})
Tabs.emotes:Button({
	Title = "loc:ninja",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("ninja")
	end
})
Tabs.emotes:Button({
	Title = "loc:sit",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("sit")
	end
})
Tabs.emotes:Button({
	Title = "loc:headless",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("headless")
	end
})
Tabs.emotes:Button({
	Title = "loc:dab",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dab")
	end
})
Tabs.emotes:Button({
	Title = "loc:zen",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zen")
	end
})
Tabs.emotes:Button({
	Title = "loc:floss",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("floss")
	end
})
Tabs.emotes:Button({
	Title = "loc:zombie",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zombie")
	end
})
Tabs.emotes:Button({
	Title = "loc:wave",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("wave")
	end
})
Tabs.emotes:Button({
	Title = "loc:cheer",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("cheer")
	end
})
Tabs.emotes:Button({
	Title = "loc:laugh",
	Callback = function()
		ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("laugh")
	end
})
Tabs.other:Section({
	Title = "Breaker"
})
Tabs.other:Button({
	Title = "loc:breakgun",
	Callback = function()
		local sheriffFound = false
		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			if player ~= game.Players.LocalPlayer and player.Character ~= nil then
				if player.Backpack:FindFirstChild("Gun") then
					sendnotification("Wait for the sheriff to pull the gun out of his inventory")
					sheriffFound = true
				elseif player.Character:FindFirstChild("Gun") then
					local args = {
						1,
						0,
						"AH2"
					}
					local success, err = pcall(function()
						player.Character.Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
					end)
					if not success then
						warn("Ошибка при вызове ShootGun: " .. err)
					end
					sheriffFound = true
					sendnotification("Gun broken")
				end
			end
		end
		if not sheriffFound then
			sendnotification("There's no sheriff to be found, or you're the sheriff")
		end
	end
})
local autoBreakMonitoring = false
local autoBreakConnection = nil
local gunBroken = false
local function autoBreakGun()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= game.Players.LocalPlayer and player.Character ~= nil then
			if player.Backpack:FindFirstChild("Gun") then
				return nil
			end
			if player.Character:FindFirstChild("Gun") then
				local args = {
					1,
					0,
					"AH2"
				}
				local success, err = pcall(function()
					player.Character.Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
				end)
				if not success then
					warn("Ошибка при вызове ShootGun: " .. err)
				end
				if not gunBroken then
					gunBroken = true
				end
			end
		end
	end
end
local function startAutoBreak()
	if not autoBreakMonitoring then
		autoBreakConnection = RunService.Stepped:Connect(autoBreakGun)
		autoBreakMonitoring = true
		print("Monitoring started")
	end
end
local function stopAutoBreak()
	if autoBreakMonitoring then
		autoBreakConnection:Disconnect()
		autoBreakMonitoring = false
		gunBroken = false
		print("Monitoring stopped")
	end
end
Tabs.other:Toggle({
	Title = "loc:autobreakgun",
	Value = false,
	Callback = function(value)
		if value then
			startAutoBreak()
		else
			stopAutoBreak()
		end
	end
})
Tabs.other:Section({
	Title = "Protection"
})
Tabs.other:Toggle({
	Title = "loc:antitrap",
	Value = false,
	Callback = function(value)
		antitraploop = value
		while antitraploop do
			local function antitraploopfix()
				if LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed == 0.009999999776482582 then
					LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
				end
				wait()
			end
			wait()
			pcall(antitraploopfix)
		end
	end
})
local function setPlayerCollision(playerChar, canCollide)
	if not playerChar then
		return
	end
	for _, part in pairs(playerChar:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = canCollide
		end
	end
end
local antiFlingEnabled = false
Tabs.other:Toggle({
	Title = "loc:antifling",
	Value = false,
	Callback = function(value)
		antiFlingEnabled = value
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= Players.LocalPlayer and player.Character then
				setPlayerCollision(player.Character, not antiFlingEnabled)
			end
		end
	end
})
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		RunService.Stepped:Connect(function()
			if antiFlingEnabled and player.Character then
				setPlayerCollision(player.Character, false)
			end
		end)
	end
end
Players.PlayerAdded:Connect(function(player)
	RunService.Stepped:Connect(function()
		if antiFlingEnabled and player.Character then
			setPlayerCollision(player.Character, false)
		end
	end)
end)
Tabs.other:Toggle({
	Title = "loc:antiafk",
	Value = true,
	Callback = function(value)
		if value then
			_G.AntiAfkEnabled = true
			local VirtualUser = game:GetService("VirtualUser")
			game:GetService("Players").LocalPlayer.Idled:Connect(function()
				if _G.AntiAfkEnabled then
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end
			end)
		else
			_G.AntiAfkEnabled = false
		end
	end
})
Tabs.other:Section({
	Title = "Notify"
})
local gunDropped = false
local gunNotifyMonitoring = false
local gunNotifyConnection = nil
function checkGunDrop()
	local found = false
	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("GunDrop") then
			found = true
			break
		end
	end
	if found and not gunDropped then
		sendnotification("Gun has Dropped")
		gunDropped = true
	elseif gunDropped then
		sendnotification("Gun has been picked up")
		gunDropped = false
	end
end
local function startGunNotify()
	if not gunNotifyMonitoring then
		gunNotifyConnection = RunService.Stepped:Connect(checkGunDrop)
		gunNotifyMonitoring = true
		print("Monitoring started")
	end
end
local function stopGunNotify()
	if gunNotifyMonitoring then
		gunNotifyConnection:Disconnect()
		gunNotifyMonitoring = false
		print("Monitoring stopped")
	end
end
Tabs.other:Toggle({
	Title = "loc:gundropnotify",
	Value = false,
	Callback = function(value)
		if value then
			startGunNotify()
		else
			stopGunNotify()
		end
	end
})
local function findMurderer()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Backpack:FindFirstChild("Knife") then
			return player
		end
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Knife") then
			return player
		end
	end
	if playerData then
		for name, data in playerData do
			if data.Role == "Murderer" and game.Players:FindFirstChild(name) then
				return game.Players:FindFirstChild(name)
			end
		end
	end
	return nil
end
local function findSheriff()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Backpack:FindFirstChild("Gun") then
			return player
		end
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Gun") then
			return player
		end
	end
	if playerData then
		for name, data in playerData do
			if data.Role == "Sheriff" and game.Players:FindFirstChild(name) then
				return game.Players:FindFirstChild(name)
			end
		end
	end
	return nil
end
Tabs.other:Button({
	Title = "loc:exposeroles",
	Callback = function()
		for _, channel in ipairs(game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()) do
			if channel.Name ~= "RBXSystem" then
				local murderer = findMurderer()
				local sheriff = findSheriff()
				local murdererName = "Not yet"
				local sheriffName = "Not yet"
				if murderer then
					murdererName = murderer.Name
				end
				if sheriff then
					sheriffName = sheriff.Name
				end
				channel:SendAsync(string.format("Murderer : %s and Sheriff : %s", murdererName, sheriffName))
			end
		end
	end
})
Tabs.other:Section({
	Title = "Server"
})
Tabs.other:Button({
	Title = "loc:devconsole",
	Callback = function()
		game.StarterGui:SetCore("DevConsoleVisible", true)
		wait()
	end
})
Tabs.other:Button({
	Title = "loc:rejoin",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
		wait()
	end
})
Tabs.other:Button({
	Title = "loc:serverhop",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Roma77799/Secrethub/refs/heads/main/OtherSCRIPTS/ServerHop", true))()
		wait()
	end
})
Tabs.autofarm:Section({
	Title = "Autofarm"
})
function showStatusLabel(text, color)
	local player = game.Players.LocalPlayer
	local oldGui = player:WaitForChild("PlayerGui"):FindFirstChild("CustomLabelGui")
	if oldGui then
		oldGui:Destroy()
	end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomLabelGui"
	screenGui.Parent = player:WaitForChild("PlayerGui")
	local label = Instance.new("TextLabel")
	label.Name = "StatusLabel"
	label.Parent = screenGui
	label.Size = UDim2.new(0, 300, 0, 50)
	label.Position = UDim2.new(0.5, -150, 1, -120)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.BackgroundTransparency = 1
	label.TextWrapped = false
	label.TextSize = 32
	label.Font = Enum.Font.SourceSansBold
	local stroke = Instance.new("UIStroke")
	stroke.Parent = label
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(0, 0, 0)
	label.Text = text
	if color == "red" then
		label.TextColor3 = Color3.fromRGB(255, 0, 0)
	elseif color == "green" then
		label.TextColor3 = Color3.fromRGB(0, 255, 0)
	elseif color == "yellow" then
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
	else
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	coroutine.wrap(function()
		wait(4.7)
		screenGui:Destroy()
	end)()
end
local isFarming = false
local farmPlatform = nil
local function findClosestCoin()
	local closestDist = math.huge
	local closestCoin = nil
	for _, model in ipairs(game.Workspace:GetChildren()) do
		if model:IsA("Model") and model:FindFirstChild("CoinContainer") then
			for _, coin in ipairs(model.CoinContainer:GetChildren()) do
				if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") and coin.Name == "Coin_Server" then
					local dist = (LocalPlayer.Character.HumanoidRootPart.Position - coin.Position).magnitude
					if dist < closestDist then
						closestDist = dist
						closestCoin = coin
					end
				end
			end
		end
	end
	return closestCoin
end
local function getRoundTime()
	local timerLabel = Workspace:FindFirstChild("RoundTimerPart") and Workspace.RoundTimerPart:FindFirstChild("SurfaceGui") and Workspace.RoundTimerPart.SurfaceGui:FindFirstChild("Timer")
	if not timerLabel or not timerLabel:IsA("TextLabel") then
		return nil
	end
	local text = timerLabel.Text
	local minutes, seconds = string.match(text, "(%d+)m (%d+)s")
	if minutes and seconds then
		return tonumber(minutes) * 60 + tonumber(seconds)
	end
	local onlySeconds = string.match(text, "(%d+)s")
	if onlySeconds then
		return tonumber(onlySeconds)
	end
	return nil
end
local function findCoinContainer()
	for _, model in ipairs(game.Workspace:GetChildren()) do
		if model:IsA("Model") and model:FindFirstChild("CoinContainer") then
			return model.CoinContainer
		end
	end
	return nil
end
local function findAutofarmMurderer()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and (player.Character:FindFirstChild("Knife") or player.Backpack and player.Backpack:FindFirstChild("Knife")) then
			return player
		end
	end
	return nil
end
function IsBagFull()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then
		return false
	end
	local fullIndicator = playerGui:FindFirstChild("MainGUI", true) and playerGui.MainGUI:FindFirstChild("Game", true) and playerGui.MainGUI.Game:FindFirstChild("CoinBags", true) and playerGui.MainGUI.Game.CoinBags:FindFirstChild("Container", true) and playerGui.MainGUI.Game.CoinBags.Container:FindFirstChild("BeachBall", true) and playerGui.MainGUI.Game.CoinBags.Container.BeachBall:FindFirstChild("Full")
	return fullIndicator and fullIndicator.Visible
end
function isBarnMapActive()
	return game.Workspace:FindFirstChild("Barn") ~= nil
end
function collectCoins()
	if isFarming then
		return
	end
	isFarming = true
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		isFarming = false
		return
	end
	humanoid.Sit = false
	task.wait(0.1)
	farmPlatform = Instance.new("Part")
	farmPlatform.Size = Vector3.new(5, 1, 5)
	farmPlatform.Position = humanoid.RootPart.Position + Vector3.new(0, -2, 0)
	farmPlatform.Anchored = true
	farmPlatform.CanCollide = false
	farmPlatform.Transparency = 1
	farmPlatform.Parent = Workspace
	humanoid.PlatformStand = true
	if isBarnMapActive() then
		warn("Фарма на карте Barn не будет.")
		isFarming = false
		showStatusLabel("Autofarm status: Map Barn ERROR", "red")
		wait(2)
		humanoid.Health = 0
		return
	end
	while isFarming do
		local char = LocalPlayer.Character
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not rootPart then
			warn("Персонаж или HumanoidRootPart не найдены ТО ЕСТЬ ОН УМЕР")
			isFarming = false
			break
		end
		showStatusLabel("Autofarm status: Farming in progress", "green")
		local timeRemaining = getRoundTime()
		if timeRemaining and timeRemaining <= 1 then
			warn("Время истекло. Остановка автофарма.")
			isFarming = false
			permit = false
			humanoid.Health = 0
			break
		end
		if IsBagFull() then
			warn("Полный мешок монет.")
			isFarming = false
			if killall and proverka then
				if char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")) then
					warn("Я убийца и мешок полон. Начинаю автоубийство.")
					showStatusLabel("Autofarm status: Killing all players", "green")
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-133.8113250732422, 150, -5.352551460266113)
					for i = 1, 20 do
						pcall(function()
							EquipTool()
							wait()
							local knife = char:FindFirstChild("Knife")
							for _, player in ipairs(game.Players:GetPlayers()) do
								if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
									local targetRoot = player.Character.HumanoidRootPart
									Stab()
									firetouchinterest(targetRoot, knife.Handle, 1)
									firetouchinterest(targetRoot, knife.Handle, 0)
								end
							end
						end)
						wait()
					end
				end
			end
			if resetmurderer and proverka then
				if not (char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))) then
					permit = true
					warn("Разрешение выставлено на положительно (проверка мешка монет)")
				end
			end
			if char and char:FindFirstChildOfClass("Humanoid") then
				humanoid.Health = 0
				break
			end
		else
			local murderer = findAutofarmMurderer()
			if not murderer then
				warn("Убийца умер, остановка автофарма до следующей игры")
				isFarming = false
				local currentHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if currentHumanoid then
					currentHumanoid.Health = 0
					break
				end
			else
				local coin = findClosestCoin()
				if coin then
					local targetPos = coin.Position + Vector3.new(0, -1, 0)
					local startPos = rootPart.Position
					local duration = (targetPos - startPos).Magnitude / moveSpeed
					local startTime = tick()
					while tick() - startTime < duration and coin do
						if coin.Parent then
							local alpha = math.min((tick() - startTime) / duration, 1)
							rootPart.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
							task.wait()
						else
							break
						end
					end
					if coin and coin.Parent then
						rootPart.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
						wait(0.15)
						coin:Destroy()
					end
				else
					warn("Нет доступных монет для сбора")
					showStatusLabel("Autofarm status: No coins on the map yet", "yellow")
					wait(3)
				end
			end
		end
	end
	humanoid.PlatformStand = false
	if farmPlatform then
		farmPlatform:Destroy()
	end
end
function onCharacterAdded(char)
	local humanoid = char:WaitForChild("Humanoid")
	if resetmurderer and proverka then
		local murderer = findAutofarmMurderer()
		if murderer and permit then
			warn("Пытаемся, флингуем убийцу...")
			permit = false
			warn("Разрешение снято")
			while findAutofarmMurderer() and proverka and resetmurderer do
				showStatusLabel("Autofarm status: Ending round...", "green")
				wait(2)
				flingPlayerLogic(murderer)
			end
			warn("Убийца исчез или выключен автофарм. Остановка.")
		else
			permit = false
			warn("Убийца исчез или выключен автофарм. Остановка. (логика if murderer and permit then)")
			warn("Разрешение убрано")
		end
	end
	humanoid.Died:Connect(function()
		warn("Персонаж умер, CoinContainer удален.")
		isFarming = false
		if farmPlatform then
			farmPlatform:Destroy()
			farmPlatform = nil
		end
		local coinContainer = findCoinContainer()
		if coinContainer then
			coinContainer:Destroy()
		end
		if resetmurderer and proverka and (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Knife") and not LocalPlayer.Backpack:FindFirstChild("Knife")) then
			permit = true
			warn("Разрешение установлено на положительно (смерть, функция ondied)")
		end
	end)
	repeat
		if not proverka then
			warn("Автофарм выключен, прекращение ожидания CoinContainer.")
			return
		end
		warn("CoinContainer не найден, ожидаем...")
		showStatusLabel("Autofarm status: Expect a new game", "yellow")
		task.wait(3)
	until findCoinContainer()
	for _, descendant in pairs(Workspace:GetDescendants()) do
		if descendant.Name == "Spawn" then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
		elseif descendant.Name == "PlayerSpawn" then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
		end
	end
	collectCoins()
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end
wasOffMessageDisplayed = true
Tabs.autofarm:Toggle({
	Title = "loc:autofarm",
	Desc = "loc:descautofarm",
	Value = false,
	Callback = function(value)
		proverka = value
		if proverka then
			warn("Автофарм включен")
			wasOffMessageDisplayed = false
			if LocalPlayer.Character then
				local coinContainer = findCoinContainer()
				if coinContainer then
					coinContainer:Destroy()
					warn("CoinContainer был удален так как это прошлая игра")
				end
				repeat
					if not proverka then
						warn("Автофарм выключен, прекращение ожидания CoinContainer.")
						return
					end
					warn("CoinContainer не найден, ожидаем...")
					showStatusLabel("Autofarm status: Expect a new game", "yellow")
					task.wait(3)
				until findCoinContainer()
				for _, descendant in pairs(Workspace:GetDescendants()) do
					if descendant.Name == "Spawn" then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
					elseif descendant.Name == "PlayerSpawn" then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
					end
				end
				collectCoins()
			end
		else
			if not wasOffMessageDisplayed then
				warn("Автофарм выключен")
				wasOffMessageDisplayed = true
				showStatusLabel("Autofarm status: OFF", "red")
			end
			isFarming = false
			local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = false
			end
			if farmPlatform then
				farmPlatform:Destroy()
				farmPlatform = nil
			end
		end
	end
})
Tabs.autofarm:Toggle({
	Title = "loc:endround",
	Desc = "loc:descendround",
	Value = false,
	Callback = function(value)
		resetmurderer = value
		if not resetmurderer then
			permit = false
			warn("Разрешение снято (done farm)")
		end
	end
})
Tabs.autofarm:Toggle({
	Title = "loc:endroundkill",
	Desc = "loc:descendroundkill",
	Value = false,
	Callback = function(value)
		killall = value
	end
})
Tabs.autofarm:Slider({
	Title = "loc:farmspeed",
	Desc = "loc:descfarmspeed",
	Value = {
		Min = 24,
		Max = 26,
		Default = 25
	},
	Callback = function(value)
		moveSpeed = value
	end
})
Tabs.autofarm:Paragraph({
	Title = "loc:autofarm_info"
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/Roma77799/Secrethub/refs/heads/main/OtherSCRIPTS/GAMESTATUS"))()
Tabs.status:Section({
	Title = "Thunder Hub Status"
})
Tabs.status:Paragraph({
	Title = "Thunder Hub Murder Mystery 2",
	Desc = SSH_mm2
})
Tabs.status:Paragraph({
	Title = "Thunder Hub TimeBomb Duels",
	Desc = SSH_timebomb
})
Tabs.report:Section({
	Title = "Report Bugs"
})
reportButtonPresses = 0
local reportdrop = Tabs.report:Dropdown({
	Title = "loc:reportcategory",
	Values = {
		"Walkspeed",
		"Jumppower",
		"Fly",
		"Noclip",
		"FOV",
		"Respawn",
		"Teleport To",
		"Grab Gun",
		"Auto Dodge Knifes",
		"Godmode",
		"Create Fake Knife",
		"Sprint",
		"Auto Kill All",
		"Kill Sheriff",
		"View Murderer/Sheriff",
		"Knife Aura",
		"Fast Throw Knife",
		"Shoot Murderer",
		"Silent Aim Sheriff",
		"Aimbot Sheriff",
		"Fling Player",
		"Fling Sheriff/Murderer",
		"Lay on Back",
		"Sit Down",
		"ESP Players",
		"Players Name ESP",
		"ESP Dropped Gun",
		"Xray",
		"Improve FPS",
		"BoomBox",
		"Emotes mm2",
		"Break Gun",
		"Break Gun Auto",
		"Anti Trap",
		"Anti Fling",
		"Anti AFK",
		"Gun Drop Notify",
		"Expose Roles to Chat",
		"Autofarm",
		nil
	},
	Multi = false
})
local reportInput = Tabs.report:Input({
	Title = "loc:placeholderreport",
	Value = "",
	Placeholder = "...",
	Type = "Textarea"
})
reportsid = 29143
Tabs.report:Button({
	Title = "loc:sendreport",
	Callback = function()
		if reportdrop.Value == nil then
			sendnotification("Fill in the dropdown field nigga")
			return
		end
		reportButtonPresses = reportButtonPresses + 1
		if reportButtonPresses > 10 then
			game.Players.LocalPlayer:Kick("Thunder HUB - You have been kicked for spamming reports.")
			return
		end
		local username = LocalPlayer.Name
		local displayName = LocalPlayer.DisplayName
		local placeId = game.PlaceId
		local executor = getExecutorName() or "Unknown"
		local category = reportdrop.Value or "Unknown"
		local message = reportInput.Value or "No description provided"
		local accountAge = tostring(LocalPlayer.AccountAge)
		local placeIdStr = tostring(placeId)
		local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"
		local data = {
			chat_id = chatId,
			text = "*New Report Received!*\n" .. "*Player Information*\n" .. "```\n" .. "Username: " .. username .. "\n" .. "Display Name: " .. displayName .. "\n" .. "Account Age: " .. accountAge .. "\n" .. "Executor: " .. executor .. "\n" .. "Place ID: " .. placeIdStr .. "\n" .. "```\n" .. "*Category:* " .. category .. "\n" .. "*Message:* " .. message,
			parse_mode = "Markdown"
		}
		if reportsid then
			data.message_thread_id = reportsid
		end
		local encodedData = game:GetService("HttpService"):JSONEncode(data)
		local requestFunc = http_request or syn and syn.request
		if requestFunc then
			requestFunc({
				Url = url,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = encodedData
			})
			susSound:Play()
			sendnotification("Report successfully sent to Telegram!")
		else
			sendnotification("Failed to send report: HTTP requests not supported.")
		end
	end
})
Tabs.report:Paragraph({
	Title = "loc:report_how"
})
Tabs.changelog:Section({
	Title = "About Script"
})
Tabs.changelog:Paragraph({
	Title = "loc:status_script"
})
Tabs.changelog:Paragraph({
	Title = "loc:product_type"
})
Tabs.changelog:Paragraph({
	Title = "loc:script_version"
})
Tabs.changelog:Paragraph({
	Title = "loc:launched_from"
})
Tabs.changelog:Paragraph({
	Title = "loc:executor"
})
Tabs.changelog:Paragraph({
	Title = "loc:age"
})
Tabs.changelog:Section({
	Title = "Credits"
})
Tabs.changelog:Button({
	Title = "loc:youtube",
	Callback = function()
		setclipboard("https://youtube.com/@snapsan?si=ZF3AY7iivGUnTpOc")
		susSound:Play()
		sendnotification("Youtube Channel Link Copy To Clipboard")
	end
})
Tabs.changelog:Paragraph({
	Title = "loc:script_tester"
})
Tabs.another:Section({
	Title = "Second link to the script, mirror"
})
Tabs.another:Code({
	Title = "ThunderX Hub",
	Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader'))()"
})
Tabs.settings:Section({
	Title = "Settings"
})
Tabs.settings:Keybind({
	Title = "loc:openhub",
	Value = "G",
	Callback = function(value)
		MainWindow:SetToggleKey(Enum.KeyCode[value])
	end
})
LangList = {
	en = "English",
	ru = "Русский"
}
Tabs.settings:Dropdown({
	Title = "loc:language",
	Values = {
		LangList.en,
		LangList.ru
	},
	Callback = function(value)
		for code, name in pairs(LangList) do
			if name == value then
				WindUI:SetLanguage(code)
			end
		end
	end
})
Tabs.settings:Button({
	Title = "loc:forgot",
	Callback = function()
		if type(readfile) == "function" and type(writefile) == "function" and type(delfile) == "function" and isfile("configlanguage.json") then
			pcall(function()
				delfile("configlanguage.json")
			end)
		else
			sendnotification("unsupported feature or reseted")
		end
		print("Language config reset.")
	end
})
themeValues = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
	table.insert(themeValues, themeName)
end
themeDropdown = Tabs.settings:Dropdown({
	Title = "loc:selecttheme",
	Multi = false,
	AllowNone = false,
	Value = nil,
	Values = themeValues,
	Callback = function(value)
		WindUI:SetTheme(value)
	end
})
themeDropdown:Select(WindUI:GetCurrentTheme())
Tabs.settings:Section({
	Title = "Set Background"
})
backgrounds = {
	"rbxassetid://140079841906330",
	"rbxassetid://100725763584702",
	"rbxassetid://78521600730119",
	"rbxassetid://138070842",
	"rbxassetid://111385647298205",
	"rbxassetid://127427174065900",
	"rbxassetid://16049721756",
	"rbxassetid://15729794400",
	"rbxassetid://18685588755",
	"Clear"
}
transparency = 0.6
Tabs.settings:Dropdown({
	Title = "loc:selectbackground",
	Multi = false,
	AllowNone = false,
	Value = nil,
	Values = backgrounds,
	Callback = function(value)
		MainWindow:SetBackgroundImage(value)
		MainWindow:SetBackgroundImageTransparency(transparency)
	end
})
Tabs.settings:Slider({
	Title = "loc:backgroundtrans",
	Value = {
		Min = 0,
		Max = 10,
		Default = 6
	},
	Callback = function(value)
		transparency = value * 0.1
		MainWindow:SetBackgroundImageTransparency(transparency)
	end
})
Tabs.settings:Section({
	Title = "Configs"
})
Tabs.settings:Button({
	Title = "loc:config",
	Locked = true
})
function AddPlayerToLists(player)
	local name = player.Name
	local function contains(tbl, val)
		for _, v in pairs(tbl) do
			if v == val then
				return true
			end
		end
		return false
	end
	if not contains(teleportPlayerList, name) then
		table.insert(teleportPlayerList, name)
	end
	if not contains(killPlayerList, name) then
		table.insert(killPlayerList, name)
	end
	if not contains(flingPlayerList, name) then
		table.insert(flingPlayerList, name)
	end
	teleportPlayerDropdown:Refresh(teleportPlayerList)
	killPlayerDropdown:Refresh(killPlayerList)
	flingPlayerDropdown:Refresh(flingPlayerList)
end
function RemovePlayerFromLists(player)
	local name = player.Name
	local function removeValue(tbl, val)
		for i, v in ipairs(tbl) do
			if v == val then
				table.remove(tbl, i)
				break
			end
		end
	end
	removeValue(teleportPlayerList, name)
	removeValue(killPlayerList, name)
	removeValue(flingPlayerList, name)
	teleportPlayerDropdown:Refresh(teleportPlayerList)
	killPlayerDropdown:Refresh(killPlayerList)
	flingPlayerDropdown:Refresh(flingPlayerList)
end
game.Players.PlayerAdded:Connect(function(player)
	task.defer(function()
		AddPlayerToLists(player)
	end)
end)
game.Players.PlayerRemoving:Connect(function(player)
	RemovePlayerFromLists(player)
end)
print("Thunder Hub MM2 Loaded✅")
susSound:Play()
game.StarterGui:SetCore("SendNotification", {
	Title = "ThunderX HUB",
	Icon = "rbxassetid://78521600730119",
	Text = "Murder Mystery 2 Version " .. versionn,
	Duration = 4
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/Roma77799/Secrethub/refs/heads/main/Secret/changelogmm2"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Roma77799/Secrethub/refs/heads/main/Secret/voting"))()
