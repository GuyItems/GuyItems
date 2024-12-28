local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer  -- ใช้ LocalPlayer

-- ดึงค่าจาก path ที่ระบุสำหรับ LocalPlayer
local playerStats = LocalPlayer:WaitForChild("_stats")
local waveNumber = LocalPlayer.PlayerGui:WaitForChild("Waves"):WaitForChild("HealthBar"):WaitForChild("WaveNumber").Text

local resourceCandies = playerStats["_resourceCandies"].Value
local resourceGemsLegacy = playerStats["_resourceGemsLegacy"].Value
local resourceHolidayStars = playerStats["_resourceHolidayStars"].Value
local gemamount = playerStats["gem_amount"].Value
local goldamount = playerStats["gold_amount"].Value
local level = LocalPlayer.Character:WaitForChild("Head"):WaitForChild("_overhead"):WaitForChild("Frame"):WaitForChild("Level_Frame"):WaitForChild("Level").Text

-- ใช้ math.floor เพื่อให้ damage_dealt ไม่มีเศษทศนิยม
local damageDealt = math.floor(playerStats["damage_dealt"].Value)
local kills = playerStats["kills"].Value

-- ดึงค่าจาก GUI ของ ResultsUI
local gemReward = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("LevelRewards"):WaitForChild("ScrollingFrame"):WaitForChild("GemReward"):WaitForChild("Main"):WaitForChild("Amount").Text
local xpReward = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("LevelRewards"):WaitForChild("ScrollingFrame"):WaitForChild("XPReward"):WaitForChild("Main"):WaitForChild("Amount").Text
local titleText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Title").Text
local timerText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Middle"):WaitForChild("Timer").Text
local difficultyText = LocalPlayer.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Holder"):WaitForChild("Difficulty").Text

-- สร้างข้อมูล Webhook สำหรับแบบปกติ (normal)
local function CreateNormalWebhookData()
    return {
        ["username"] = "GuyItems ฟาร์ม",
        ["avatar_url"] = "https://media.discordapp.net/attachments/1285600581049782303/1318629070459633775/logo123.png?ex=67630485&is=6761b305&hm=1918e27c774ca791827a17d426fde8e539ede8b7b73c04f0625fc80106047744&=&format=webp&quality=lossless",
        ["embeds"] = {
            {   ["title"] = "แจ้งเตือนทั่วไป GuyItems",
                ["description"] = "**____ข้อมูลทั่วไป____**\n<:2506_Challenger:1322279711883264051>ชื่อผู้เล่น : " .. LocalPlayer.Name
                .. "\n<:c3cb3f4fe332464092e1336c0124209b:1322278388043354215>เลเวล: " .. level
                .. "\n<:Gems:1322277058327613552>เพชร [" .. gemamount .. "/".._G.targetgems.. "]"
                .. "\n<:Gold:1322277056184193077>ทอง : " .. goldamount
                .. "\n<:Candies:1322277730066366475>Candies : " .. resourceCandies
                .. "\n<:yellowgolddiamondgemiconfreepng:1322277050102321192>Legacy Gems : " .. resourceGemsLegacy
                .. "\n<:Stars:1322277054137499739>Holiday Stars : " .. resourceHolidayStars
                    .. "\n\n\n**____ข้อมูลการเล่น____**\nผลลัพธ์: " .. titleText
                    .. "\nเวลา: " .. timerText
                    .. "\nเวฟ: " .. waveNumber
                    .. "\nได้รับเพชร: " .. gemReward
                    .. "\nได้รับ XP: " .. xpReward
                    .. "\nดาเมจ: " .. damageDealt
                    .. "\nKills: " .. kills,
                ["color"] = 16711680
            }
        }
    }
end

-- สร้างข้อมูล Webhook สำหรับแบบ Finish
local function CreateFinishWebhookData()
    return {
        ["content"] = "<@" .. _G.discordId .. ">",
        ["username"] = "GuyItems ฟาร์ม",
        ["avatar_url"] = "https://media.discordapp.net/attachments/1285600581049782303/1318629070459633775/logo123.png?ex=67630485&is=6761b305&hm=1918e27c774ca791827a17d426fde8e539ede8b7b73c04f0625fc80106047744&=&format=webp&quality=lossless",
        ["embeds"] = {
            {
                ["title"] = "**งานเสร็จแล้ว ขอบคุณที่ใช้บริการ GuyItems**",
                ["description"] = "**____ข้อมูลหลังฟาร์มเสร็จ____**\n<:2506_Challenger:1322279711883264051>ชื่อผู้เล่น : " .. LocalPlayer.Name
                    .. "\n<:c3cb3f4fe332464092e1336c0124209b:1322278388043354215>เลเวล : " .. level
                    .. "\n<:Gems:1322277058327613552>เพชร : [" .. gemamount .. "/".._G.targetgems.. "]"
                    .. "\n<:Gold:1322277056184193077>ทอง: " .. goldamount
                    .. "\n<:Candies:1322277730066366475>Candies : " .. resourceCandies
                    .. "\n<:yellowgolddiamondgemiconfreepng:1322277050102321192>Lagacy Gems : " .. resourceGemsLegacy
                    .. "\n<:Stars:1322277054137499739>Holiday Stars : " .. resourceHolidayStars,
                    ["thumbnail"] = {
                        ["url"]= "https://media.discordapp.net/attachments/1285600605242392618/1318633202180554824/467378876_610111638123749_3432950519344764419_n.png?ex=6763085e&is=6761b6de&hm=94f1e61ca89c11118939bfe8b825fe1acaa9c81004170bd9f034e0221c1bacd7&=&format=webp&quality=lossless&width=676&height=676",
                ["color"] = 65280
            }
        }
    }
}
end

-- ฟังก์ชันสำหรับส่งข้อมูล Webhook
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

-- ส่งข้อมูล Webhook
    -- ส่ง Webhook ปกติ (normal) ทันที
    while true do
    local GameFinished = game:GetService("Workspace")["_DATA"].GameFinished.Value
    if GameFinished == true then
    local normalData = CreateNormalWebhookData()
    SendWebhook(_G.webhookUrlNormal, normalData)
    wait(10)
    end
    -- ตรวจสอบว่า gemamount >= targetgems หรือไม่ ก่อนส่ง Webhook แบบ Finish
    while true do
    if gemamount >= _G.targetgems then
        local finishData = CreateFinishWebhookData()
        SendWebhook(_G.webhookUrlFinish, finishData)
        wait(10)
        end
    end
end

-- เรียกใช้งานเมื่อพร้อม
SendPlayerData()
