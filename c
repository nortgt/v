local Players, RunService, ReplicatedStorage, StarterGui, UIS = game:GetService("Players"), game:GetService("RunService"), game:GetService("ReplicatedStorage"), game:GetService("StarterGui"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid, RootPart = Character:WaitForChild("Humanoid"), Character:WaitForChild("HumanoidRootPart")
local RE = ReplicatedStorage:WaitForChild("RE")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")

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
            title = "🔧 A player executed Hexagon",
            color = 7358325,
            thumbnail = { url = thumbUrl },
            fields = {
                {name = "📅 Date", value = dataHora, inline = false},
                {name = "🎮 Game", value = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name, inline = false},
                {name = "👤 Player", value = LocalPlayer.Name, inline = false},
                {name = "🆔 User ID", value = tostring(userId), inline = false},
                {name = "📝 Account Age", value = LocalPlayer.AccountAge .. " Days", inline = false},
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
        request({
            Url = "https://discord.com/api/webhooks/1436087501835210833/7cyw8RSgIqKrRX3gVmhLYDwxYBSbqE20h7ikkBOftTMxwXMfzGBMNZglXsFii4WGI9OW",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
    end)
end

ExecuteLog()
