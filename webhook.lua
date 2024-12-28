-- Main Script
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerStats = LocalPlayer:WaitForChild("_stats")
local waveNumber = LocalPlayer.PlayerGui:WaitForChild("Waves"):WaitForChild("HealthBar"):WaitForChild("WaveNumber").Text

local resourceCandies = playerStats["_resourceCandies"].Value
local resourceGemsLegacy = playerStats["_resourceGemsLegacy"].Value
local resourceHolidayStars = playerStats["_resourceHolidayStars"].Value
local gemamount = playerStats["gem_amount"].Value
local goldamount = playerStats["gold_amount"].Value
local level = LocalPlayer.Character:WaitForChild("Head"):WaitForChild("_overhead"):WaitForChild("Frame"):WaitForChild("Level_Frame"):WaitForChild("Level").Text

local damageDealt = math.floor(playerStats["damage_dealt"].Value)
local kills = playerStats["kills"].Value

local gemReward = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("LevelRewards"):WaitForChild("ScrollingFrame"):WaitForChild("GemReward"):WaitForChild("Main"):WaitForChild("Amount").Text
local xpReward = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("LevelRewards"):WaitForChild("ScrollingFrame"):WaitForChild("XPReward"):WaitForChild("Main"):WaitForChild("Amount").Text
local titleText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Title").Text
local timerText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Middle"):WaitForChild("Timer").Text
local difficultyText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Difficulty").Text

local function CreateNormalWebhookData()
    return {
        ["username"] = "GuyItems ฟาร์ม",
        ["avatar_url"] = "https://media.discordapp.net/attachments/1285600581049782303/1318629070459633775/logo123.png",
        ["embeds"] = {
            {
                ["title"] = "แจ้งเตือนทั่วไป GuyItems",
                ["description"] = "**____ข้อมูลทั่วไป____**\n<:2506_Challenger:1322279711883264051>ชื่อผู้เล่น : " .. LocalPlayer.Name
                .. "\n<:c3cb3f4fe332464092e1336c0124209b:1322278388043354215>เลเวล: " .. level
                .. "\n<:Gems:1322277058327613552>เพชร [" .. gemamount .. "/" .. _G.targetgems .. "]"
                .. "\n<:Gold:1322277056184193077>ทอง : " .. goldamount
                .. "\n<:Candies:1322277730066366475>Candies : " .. resourceCandies
                .. "\n<:yellowgolddiamondgemiconfreepng:1322277050102321192>Legacy Gems : " .. resourceGemsLegacy
                .. "\n<:Stars:1322277054137499739>Holiday Stars : " .. resourceHolidayStars,
                ["color"] = 16711680
            }
        }
    }
end

local function CreateFinishWebhookData()
    return {
        ["content"] = "<@" .. _G.discordId .. ">",
        ["username"] = "GuyItems ฟาร์ม",
        ["avatar_url"] = "https://media.discordapp.net/attachments/1285600581049782303/1318629070459633775/logo123.png",
        ["embeds"] = {
            {
                ["title"] = "**งานเสร็จแล้ว ขอบคุณที่ใช้บริการ GuyItems**",
                ["description"] = "**____ข้อมูลหลังฟาร์มเสร็จ____**\n<:2506_Challenger:1322279711883264051>ชื่อผู้เล่น : " .. LocalPlayer.Name
                .. "\n<:c3cb3f4fe332464092e1336c0124209b:1322278388043354215>เลเวล : " .. level
                .. "\n<:Gems:1322277058327613552>เพชร : [" .. gemamount .. "/" .. _G.targetgems .. "]"
                .. "\n<:Gold:1322277056184193077>ทอง: " .. goldamount,
                ["color"] = 65280
            }
        }
    }
end

local function SendWebhook(url, data)
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    local requestTable = {
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    }
    request(requestTable)
end

local GameFinished = game:GetService("Workspace")["_DATA"].GameFinished.Value
if GameFinished == true then
    local normalData = CreateNormalWebhookData()
    SendWebhook(_G.webhookUrlNormal, normalData)

    if gemamount >= _G.targetgems then
        local finishData = CreateFinishWebhookData()
        SendWebhook(_G.webhookUrlFinish, finishData)
    end
end
