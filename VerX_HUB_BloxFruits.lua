repeat wait() until game.Players.LocalPlayer

if not (game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635) then
    return
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "VerX HUB | Blox Fruits",
    Icon = 0,
    LoadingTitle = "VerX HUB",
    LoadingSubtitle = "Blox Fruits Edition",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = { Enabled = true, FolderName = "VerXHub", FileName = "BloxFruits" },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local VU           = game:GetService("VirtualUser")
local LP           = Players.LocalPlayer

if game.PlaceId == 2753915549 then World1 = true
elseif game.PlaceId == 4442272183 then World2 = true
elseif game.PlaceId == 7449423635 then World3 = true end

local function round(n) return math.floor(tonumber(n) + 0.5) end
local ESPNum = math.random(1,1000000)

if getrawmetatable and setreadonly and newcclosure then
    local grm = getrawmetatable(game)
    setreadonly(grm, false)
    local old = grm.__namecall
    grm.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local blocked = {
            "TeleportDetect","CHECKER_1","CHECKER","GUI_CHECK",
            "OneMoreTime","checkingSPEED","BANREMOTE",
            "PERMAIDBAN","KICKREMOTE","BR_KICKPC","BR_KICKMOBILE"
        }
        for _, v in ipairs(blocked) do
            if tostring(args[1]) == v then return end
        end
        return old(self, ...)
    end)
    setreadonly(grm, true)
end

local _tbl
_tbl = function(t)
    return setmetatable(t or {},{
        __index = function() return _tbl() end,
        __call  = function() return _tbl() end
    })
end
local _req = require
local require = function(...)
    local ok, r = pcall(_req, ...)
    return ok and r or _tbl()
end

pcall(function()
    getgenv().CF_Attack = require(RS.CombatFramework.RigLib).wrapAttackAnimationAsync
    getgenv().CF_Particle = require(LP.PlayerScripts.CombatFramework.Particle).play
end)

spawn(function()
    while wait() do
        pcall(function()
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("LocalScript") then
                    if v.Name == "General" or v.Name == "Shiftlock" or v.Name == "FallDamage"
                    or v.Name == "4444"   or v.Name == "CamBob"    or v.Name == "JumpCD"
                    or v.Name == "Looking" or v.Name == "Run" then
                        v:Destroy()
                    end
                end
            end
            for _, v in pairs(LP.PlayerScripts:GetDescendants()) do
                if v:IsA("LocalScript") then
                    if v.Name == "RobloxMotor6DBugFix" or v.Name == "Clans"
                    or v.Name == "Codes" or v.Name == "CustomForceField"
                    or v.Name == "MenuBloodSp" or v.Name == "PlayerList" then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if _G.setfflag then
                setfflag("AbuseReportScreenshot","False")
                setfflag("AbuseReportScreenshotPercentage","0")
            end
        end)
    end
end)
_G.setfflag = true

local Mon,NameMon,NameQuest,LevelQuest,CFrameQuest,CFrameMon,MyLevel

local function CheckQuest()
    MyLevel = LP.Data.Level.Value
    if World1 then
        if MyLevel <= 9 then Mon="Bandit" LevelQuest=1 NameQuest="BanditQuest1" NameMon="Bandit" CFrameQuest=CFrame.new(1059,15,1550) CFrameMon=CFrame.new(1045,27,1560)
        elseif MyLevel <= 14 then Mon="Monkey" LevelQuest=1 NameQuest="JungleQuest" NameMon="Monkey" CFrameQuest=CFrame.new(-1598,35,153) CFrameMon=CFrame.new(-1448,67,11)
        elseif MyLevel <= 29 then Mon="Gorilla" LevelQuest=2 NameQuest="JungleQuest" NameMon="Gorilla" CFrameQuest=CFrame.new(-1598,35,153) CFrameMon=CFrame.new(-1129,40,-525)
        elseif MyLevel <= 39 then Mon="Pirate" LevelQuest=1 NameQuest="BuggyQuest1" NameMon="Pirate" CFrameQuest=CFrame.new(-1141,4,3831) CFrameMon=CFrame.new(-1103,13,3896)
        elseif MyLevel <= 59 then Mon="Brute" LevelQuest=2 NameQuest="BuggyQuest1" NameMon="Brute" CFrameQuest=CFrame.new(-1141,4,3831) CFrameMon=CFrame.new(-1140,14,4322)
        elseif MyLevel <= 74 then Mon="Desert Bandit" LevelQuest=1 NameQuest="DesertQuest" NameMon="Desert Bandit" CFrameQuest=CFrame.new(894,5,4392) CFrameMon=CFrame.new(924,6,4481)
        elseif MyLevel <= 89 then Mon="Desert Officer" LevelQuest=2 NameQuest="DesertQuest" NameMon="Desert Officer" CFrameQuest=CFrame.new(894,5,4392) CFrameMon=CFrame.new(1608,8,4371)
        elseif MyLevel <= 99 then Mon="Snow Bandit" LevelQuest=1 NameQuest="SnowQuest" NameMon="Snow Bandit" CFrameQuest=CFrame.new(1389,88,-1298) CFrameMon=CFrame.new(1354,87,-1393)
        elseif MyLevel <= 119 then Mon="Snowman" LevelQuest=2 NameQuest="SnowQuest" NameMon="Snowman" CFrameQuest=CFrame.new(1389,88,-1298) CFrameMon=CFrame.new(1201,144,-1550)
        elseif MyLevel <= 149 then Mon="Chief Petty Officer" LevelQuest=1 NameQuest="MarineQuest2" NameMon="Chief Petty Officer" CFrameQuest=CFrame.new(-5039,27,4324) CFrameMon=CFrame.new(-4881,22,4273)
        elseif MyLevel <= 174 then Mon="Sky Bandit" LevelQuest=1 NameQuest="SkyQuest" NameMon="Sky Bandit" CFrameQuest=CFrame.new(-4839,716,-2619) CFrameMon=CFrame.new(-4953,295,-2899)
        elseif MyLevel <= 189 then Mon="Dark Master" LevelQuest=2 NameQuest="SkyQuest" NameMon="Dark Master" CFrameQuest=CFrame.new(-4839,716,-2619) CFrameMon=CFrame.new(-5259,391,-2229)
        elseif MyLevel <= 209 then Mon="Prisoner" LevelQuest=1 NameQuest="PrisonerQuest" NameMon="Prisoner" CFrameQuest=CFrame.new(5308,1,475) CFrameMon=CFrame.new(5098,0,474)
        elseif MyLevel <= 249 then Mon="Dangerous Prisoner" LevelQuest=2 NameQuest="PrisonerQuest" NameMon="Dangerous Prisoner" CFrameQuest=CFrame.new(5308,1,475) CFrameMon=CFrame.new(5654,15,866)
        elseif MyLevel <= 274 then Mon="Toga Warrior" LevelQuest=1 NameQuest="ColosseumQuest" NameMon="Toga Warrior" CFrameQuest=CFrame.new(-1580,6,-2986) CFrameMon=CFrame.new(-1820,51,-2740)
        elseif MyLevel <= 299 then Mon="Gladiator" LevelQuest=2 NameQuest="ColosseumQuest" NameMon="Gladiator" CFrameQuest=CFrame.new(-1580,6,-2986) CFrameMon=CFrame.new(-1292,56,-3339)
        elseif MyLevel <= 324 then Mon="Military Soldier" LevelQuest=1 NameQuest="MagmaQuest" NameMon="Military Soldier" CFrameQuest=CFrame.new(-5313,10,8515) CFrameMon=CFrame.new(-5411,11,8454)
        elseif MyLevel <= 374 then Mon="Military Spy" LevelQuest=2 NameQuest="MagmaQuest" NameMon="Military Spy" CFrameQuest=CFrame.new(-5313,10,8515) CFrameMon=CFrame.new(-5802,86,8828)
        elseif MyLevel <= 399 then Mon="Fishman Warrior" LevelQuest=1 NameQuest="FishmanQuest" NameMon="Fishman Warrior" CFrameQuest=CFrame.new(61122,18,1569) CFrameMon=CFrame.new(60878,18,1543)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163,11,1819)) end) end
        elseif MyLevel <= 449 then Mon="Fishman Commando" LevelQuest=2 NameQuest="FishmanQuest" NameMon="Fishman Commando" CFrameQuest=CFrame.new(61122,18,1569) CFrameMon=CFrame.new(61922,18,1493)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163,11,1819)) end) end
        elseif MyLevel <= 474 then Mon="God's Guard" LevelQuest=1 NameQuest="SkyExp1Quest" NameMon="God's Guard" CFrameQuest=CFrame.new(-4721,843,-1949) CFrameMon=CFrame.new(-4710,845,-1927)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607,872,-1667)) end) end
        elseif MyLevel <= 524 then Mon="Shanda" LevelQuest=2 NameQuest="SkyExp1Quest" NameMon="Shanda" CFrameQuest=CFrame.new(-7859,5544,-381) CFrameMon=CFrame.new(-7678,5566,-497)
        elseif MyLevel <= 549 then Mon="Royal Squad" LevelQuest=1 NameQuest="SkyExp2Quest" NameMon="Royal Squad" CFrameQuest=CFrame.new(-7906,5634,-1411) CFrameMon=CFrame.new(-7624,5658,-1467)
        elseif MyLevel <= 624 then Mon="Royal Soldier" LevelQuest=2 NameQuest="SkyExp2Quest" NameMon="Royal Soldier" CFrameQuest=CFrame.new(-7906,5634,-1411) CFrameMon=CFrame.new(-7836,5645,-1790)
        elseif MyLevel <= 649 then Mon="Galley Pirate" LevelQuest=1 NameQuest="FountainQuest" NameMon="Galley Pirate" CFrameQuest=CFrame.new(5259,37,4050) CFrameMon=CFrame.new(5551,78,3930)
        else Mon="Galley Captain" LevelQuest=2 NameQuest="FountainQuest" NameMon="Galley Captain" CFrameQuest=CFrame.new(5259,37,4050) CFrameMon=CFrame.new(5441,42,4950) end
    elseif World2 then
        if MyLevel <= 724 then Mon="Raider" LevelQuest=1 NameQuest="Area1Quest" NameMon="Raider" CFrameQuest=CFrame.new(-429,71,1836) CFrameMon=CFrame.new(-728,52,2345)
        elseif MyLevel <= 774 then Mon="Mercenary" LevelQuest=2 NameQuest="Area1Quest" NameMon="Mercenary" CFrameQuest=CFrame.new(-429,71,1836) CFrameMon=CFrame.new(-1004,80,1424)
        elseif MyLevel <= 799 then Mon="Swan Pirate" LevelQuest=1 NameQuest="Area2Quest" NameMon="Swan Pirate" CFrameQuest=CFrame.new(638,71,918) CFrameMon=CFrame.new(1068,137,1322)
        elseif MyLevel <= 874 then Mon="Factory Staff" LevelQuest=2 NameQuest="Area2Quest" NameMon="Factory Staff" CFrameQuest=CFrame.new(632,73,918) CFrameMon=CFrame.new(73,81,-27)
        elseif MyLevel <= 899 then Mon="Marine Lieutenant" LevelQuest=1 NameQuest="MarineQuest3" NameMon="Marine Lieutenant" CFrameQuest=CFrame.new(-2440,71,-3216) CFrameMon=CFrame.new(-2821,75,-3070)
        elseif MyLevel <= 949 then Mon="Marine Captain" LevelQuest=2 NameQuest="MarineQuest3" NameMon="Marine Captain" CFrameQuest=CFrame.new(-2440,71,-3216) CFrameMon=CFrame.new(-1861,80,-3254)
        elseif MyLevel <= 974 then Mon="Zombie" LevelQuest=1 NameQuest="ZombieQuest" NameMon="Zombie" CFrameQuest=CFrame.new(-5497,47,-795) CFrameMon=CFrame.new(-5657,78,-928)
        elseif MyLevel <= 999 then Mon="Vampire" LevelQuest=2 NameQuest="ZombieQuest" NameMon="Vampire" CFrameQuest=CFrame.new(-5497,47,-795) CFrameMon=CFrame.new(-6037,32,-1340)
        elseif MyLevel <= 1049 then Mon="Snow Trooper" LevelQuest=1 NameQuest="SnowMountainQuest" NameMon="Snow Trooper" CFrameQuest=CFrame.new(609,400,-5372) CFrameMon=CFrame.new(549,427,-5563)
        elseif MyLevel <= 1099 then Mon="Winter Warrior" LevelQuest=2 NameQuest="SnowMountainQuest" NameMon="Winter Warrior" CFrameQuest=CFrame.new(609,400,-5372) CFrameMon=CFrame.new(1142,475,-5199)
        elseif MyLevel <= 1124 then Mon="Lab Subordinate" LevelQuest=1 NameQuest="IceSideQuest" NameMon="Lab Subordinate" CFrameQuest=CFrame.new(-6064,15,-4902) CFrameMon=CFrame.new(-5707,15,-4513)
        elseif MyLevel <= 1174 then Mon="Horned Warrior" LevelQuest=2 NameQuest="IceSideQuest" NameMon="Horned Warrior" CFrameQuest=CFrame.new(-6064,15,-4902) CFrameMon=CFrame.new(-6341,15,-5723)
        elseif MyLevel <= 1199 then Mon="Magma Ninja" LevelQuest=1 NameQuest="FireSideQuest" NameMon="Magma Ninja" CFrameQuest=CFrame.new(-5428,15,-5299) CFrameMon=CFrame.new(-5449,76,-5808)
        elseif MyLevel <= 1249 then Mon="Lava Pirate" LevelQuest=2 NameQuest="FireSideQuest" NameMon="Lava Pirate" CFrameQuest=CFrame.new(-5428,15,-5299) CFrameMon=CFrame.new(-5213,49,-4701)
        elseif MyLevel <= 1274 then Mon="Ship Deckhand" LevelQuest=1 NameQuest="ShipQuest1" NameMon="Ship Deckhand" CFrameQuest=CFrame.new(1037,125,32911) CFrameMon=CFrame.new(1212,150,33059)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923,126,32852)) end) end
        elseif MyLevel <= 1299 then Mon="Ship Engineer" LevelQuest=2 NameQuest="ShipQuest1" NameMon="Ship Engineer" CFrameQuest=CFrame.new(1037,125,32911) CFrameMon=CFrame.new(919,43,32779)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923,126,32852)) end) end
        elseif MyLevel <= 1324 then Mon="Ship Steward" LevelQuest=1 NameQuest="ShipQuest2" NameMon="Ship Steward" CFrameQuest=CFrame.new(968,125,33244) CFrameMon=CFrame.new(919,129,33436)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923,126,32852)) end) end
        elseif MyLevel <= 1349 then Mon="Ship Officer" LevelQuest=2 NameQuest="ShipQuest2" NameMon="Ship Officer" CFrameQuest=CFrame.new(968,125,33244) CFrameMon=CFrame.new(1036,181,33315)
            if _G.AutoFarm then pcall(function() RS.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923,126,32852)) end) end
        elseif MyLevel <= 1374 then Mon="Arctic Warrior" LevelQuest=1 NameQuest="FrostQuest" NameMon="Arctic Warrior" CFrameQuest=CFrame.new(5667,26,-6486) CFrameMon=CFrame.new(5966,62,-6179)
        elseif MyLevel <= 1424 then Mon="Snow Lurker" LevelQuest=2 NameQuest="FrostQuest" NameMon="Snow Lurker" CFrameQuest=CFrame.new(5667,26,-6486) CFrameMon=CFrame.new(5407,69,-6880)
        elseif MyLevel <= 1449 then Mon="Sea Soldier" LevelQuest=1 NameQuest="ForgottenQuest" NameMon="Sea Soldier" CFrameQuest=CFrame.new(-3054,235,-10142) CFrameMon=CFrame.new(-3028,64,-9775)
        else Mon="Water Fighter" LevelQuest=2 NameQuest="ForgottenQuest" NameMon="Water Fighter" CFrameQuest=CFrame.new(-3054,235,-10142) CFrameMon=CFrame.new(-3352,285,-10534) end
    elseif World3 then
        if MyLevel <= 1524 then Mon="Pirate Millionaire" LevelQuest=1 NameQuest="PiratePortQuest" NameMon="Pirate Millionaire" CFrameQuest=CFrame.new(-290,42,5581) CFrameMon=CFrame.new(-245,47,5584)
        elseif MyLevel <= 1574 then Mon="Pistol Billionaire" LevelQuest=2 NameQuest="PiratePortQuest" NameMon="Pistol Billionaire" CFrameQuest=CFrame.new(-290,42,5581) CFrameMon=CFrame.new(-187,86,6013)
        elseif MyLevel <= 1599 then Mon="Dragon Crew Warrior" LevelQuest=1 NameQuest="AmazonQuest" NameMon="Dragon Crew Warrior" CFrameQuest=CFrame.new(5832,51,-1101) CFrameMon=CFrame.new(6141,51,-1340)
        elseif MyLevel <= 1624 then Mon="Dragon Crew Archer" LevelQuest=2 NameQuest="AmazonQuest" NameMon="Dragon Crew Archer" CFrameQuest=CFrame.new(5833,51,-1103) CFrameMon=CFrame.new(6616,441,446)
        elseif MyLevel <= 1649 then Mon="Female Islander" LevelQuest=1 NameQuest="AmazonQuest2" NameMon="Female Islander" CFrameQuest=CFrame.new(5446,601,749) CFrameMon=CFrame.new(4685,735,815)
        elseif MyLevel <= 1699 then Mon="Giant Islander" LevelQuest=2 NameQuest="AmazonQuest2" NameMon="Giant Islander" CFrameQuest=CFrame.new(5446,601,749) CFrameMon=CFrame.new(4729,590,-36)
        elseif MyLevel <= 1724 then Mon="Marine Commodore" LevelQuest=1 NameQuest="MarineTreeIsland" NameMon="Marine Commodore" CFrameQuest=CFrame.new(2180,27,-6741) CFrameMon=CFrame.new(2286,73,-7159)
        elseif MyLevel <= 1774 then Mon="Marine Rear Admiral" LevelQuest=2 NameQuest="MarineTreeIsland" NameMon="Marine Rear Admiral" CFrameQuest=CFrame.new(2179,28,-6740) CFrameMon=CFrame.new(3656,160,-7001)
        elseif MyLevel <= 1799 then Mon="Fishman Raider" LevelQuest=1 NameQuest="DeepForestIsland3" NameMon="Fishman Raider" CFrameQuest=CFrame.new(-10581,330,-8761) CFrameMon=CFrame.new(-10407,331,-8368)
        elseif MyLevel <= 1824 then Mon="Fishman Captain" LevelQuest=2 NameQuest="DeepForestIsland3" NameMon="Fishman Captain" CFrameQuest=CFrame.new(-10581,330,-8761) CFrameMon=CFrame.new(-10994,352,-9002)
        elseif MyLevel <= 1849 then Mon="Forest Pirate" LevelQuest=1 NameQuest="DeepForestIsland" NameMon="Forest Pirate" CFrameQuest=CFrame.new(-13234,331,-7625) CFrameMon=CFrame.new(-13274,332,-7769)
        elseif MyLevel <= 1899 then Mon="Mythological Pirate" LevelQuest=2 NameQuest="DeepForestIsland" NameMon="Mythological Pirate" CFrameQuest=CFrame.new(-13234,331,-7625) CFrameMon=CFrame.new(-13680,501,-6991)
        elseif MyLevel <= 1924 then Mon="Jungle Pirate" LevelQuest=1 NameQuest="DeepForestIsland2" NameMon="Jungle Pirate" CFrameQuest=CFrame.new(-12680,389,-9902) CFrameMon=CFrame.new(-12256,331,-10485)
        elseif MyLevel <= 1974 then Mon="Musketeer Pirate" LevelQuest=2 NameQuest="DeepForestIsland2" NameMon="Musketeer Pirate" CFrameQuest=CFrame.new(-12680,389,-9902) CFrameMon=CFrame.new(-13457,391,-9859)
        elseif MyLevel <= 1999 then Mon="Reborn Skeleton" LevelQuest=1 NameQuest="HauntedQuest1" NameMon="Reborn Skeleton" CFrameQuest=CFrame.new(-9479,141,5566) CFrameMon=CFrame.new(-8763,165,6159)
        elseif MyLevel <= 2024 then Mon="Living Zombie" LevelQuest=2 NameQuest="HauntedQuest1" NameMon="Living Zombie" CFrameQuest=CFrame.new(-9479,141,5566) CFrameMon=CFrame.new(-10144,138,5838)
        elseif MyLevel <= 2049 then Mon="Demonic Soul" LevelQuest=1 NameQuest="HauntedQuest2" NameMon="Demonic Soul" CFrameQuest=CFrame.new(-9516,172,6078) CFrameMon=CFrame.new(-9505,172,6158)
        elseif MyLevel <= 2074 then Mon="Posessed Mummy" LevelQuest=2 NameQuest="HauntedQuest2" NameMon="Posessed Mummy" CFrameQuest=CFrame.new(-9516,172,6078) CFrameMon=CFrame.new(-9582,6,6205)
        elseif MyLevel <= 2099 then Mon="Peanut Scout" LevelQuest=1 NameQuest="NutsIslandQuest" NameMon="Peanut Scout" CFrameQuest=CFrame.new(-2104,38,-10194) CFrameMon=CFrame.new(-2143,47,-10029)
        elseif MyLevel <= 2124 then Mon="Peanut President" LevelQuest=2 NameQuest="NutsIslandQuest" NameMon="Peanut President" CFrameQuest=CFrame.new(-2104,38,-10194) CFrameMon=CFrame.new(-1859,38,-10422)
        elseif MyLevel <= 2149 then Mon="Ice Cream Chef" LevelQuest=1 NameQuest="IceCreamIslandQuest" NameMon="Ice Cream Chef" CFrameQuest=CFrame.new(-820,65,-10965) CFrameMon=CFrame.new(-872,65,-10919)
        elseif MyLevel <= 2199 then Mon="Ice Cream Commander" LevelQuest=2 NameQuest="IceCreamIslandQuest" NameMon="Ice Cream Commander" CFrameQuest=CFrame.new(-820,65,-10965) CFrameMon=CFrame.new(-558,112,-11290)
        elseif MyLevel <= 2224 then Mon="Cookie Crafter" LevelQuest=1 NameQuest="CakeQuest1" NameMon="Cookie Crafter" CFrameQuest=CFrame.new(-2021,37,-12028) CFrameMon=CFrame.new(-2374,37,-12125)
        elseif MyLevel <= 2249 then Mon="Cake Guard" LevelQuest=2 NameQuest="CakeQuest1" NameMon="Cake Guard" CFrameQuest=CFrame.new(-2021,37,-12028) CFrameMon=CFrame.new(-1598,43,-12244)
        elseif MyLevel <= 2274 then Mon="Baking Staff" LevelQuest=1 NameQuest="CakeQuest2" NameMon="Baking Staff" CFrameQuest=CFrame.new(-1927,37,-12842) CFrameMon=CFrame.new(-1887,77,-12998)
        elseif MyLevel <= 2299 then Mon="Head Baker" LevelQuest=2 NameQuest="CakeQuest2" NameMon="Head Baker" CFrameQuest=CFrame.new(-1927,37,-12842) CFrameMon=CFrame.new(-2216,82,-12869)
        elseif MyLevel <= 2324 then Mon="Cocoa Warrior" LevelQuest=1 NameQuest="ChocQuest1" NameMon="Cocoa Warrior" CFrameQuest=CFrame.new(233,29,-12201) CFrameMon=CFrame.new(-21,80,-12352)
        elseif MyLevel <= 2349 then Mon="Chocolate Bar Battler" LevelQuest=2 NameQuest="ChocQuest1" NameMon="Chocolate Bar Battler" CFrameQuest=CFrame.new(233,29,-12201) CFrameMon=CFrame.new(582,77,-12463)
        elseif MyLevel <= 2374 then Mon="Sweet Thief" LevelQuest=1 NameQuest="ChocQuest2" NameMon="Sweet Thief" CFrameQuest=CFrame.new(150,30,-12774) CFrameMon=CFrame.new(165,76,-12600)
        elseif MyLevel <= 2399 then Mon="Candy Rebel" LevelQuest=2 NameQuest="ChocQuest2" NameMon="Candy Rebel" CFrameQuest=CFrame.new(150,30,-12774) CFrameMon=CFrame.new(134,77,-12876)
        elseif MyLevel <= 2424 then Mon="Candy Pirate" LevelQuest=1 NameQuest="CandyQuest1" NameMon="Candy Pirate" CFrameQuest=CFrame.new(-1150,20,-14446) CFrameMon=CFrame.new(-1310,26,-14562)
        elseif MyLevel <= 2449 then Mon="Snow Demon" LevelQuest=2 NameQuest="CandyQuest1" NameMon="Snow Demon" CFrameQuest=CFrame.new(-1150,20,-14446) CFrameMon=CFrame.new(-880,71,-14538)
        elseif MyLevel <= 2474 then Mon="Isle Outlaw" LevelQuest=1 NameQuest="TikiQuest1" NameMon="Isle Outlaw" CFrameQuest=CFrame.new(-16547,61,-173) CFrameMon=CFrame.new(-16442,116,-264)
        elseif MyLevel <= 2499 then Mon="Island Boy" LevelQuest=2 NameQuest="TikiQuest1" NameMon="Island Boy" CFrameQuest=CFrame.new(-16547,61,-173) CFrameMon=CFrame.new(-16901,84,-192)
        elseif MyLevel <= 2524 then Mon="Sun-kissed Warrior" LevelQuest=1 NameQuest="TikiQuest2" NameMon="kissed" CFrameQuest=CFrame.new(-16539,55,1051) CFrameMon=CFrame.new(-16349,92,1123)
        else Mon="Isle Champion" LevelQuest=2 NameQuest="TikiQuest2" NameMon="Isle Champion" CFrameQuest=CFrame.new(-16539,55,1051) CFrameMon=CFrame.new(-16347,92,1122) end
    end
end

local function EquipWeapon(name)
    pcall(function()
        local tool = LP.Backpack:FindFirstChild(name)
        if tool then
            wait(0.1)
            LP.Character.Humanoid:EquipTool(tool)
        end
    end)
end

local ActiveTween
local function TPPos(pos)
    pcall(function()
        local root = LP.Character.HumanoidRootPart
        local dist = (pos.Position - root.Position).Magnitude
        if dist <= 200 then
            root.CFrame = pos
            return
        end
        local speed = dist < 500 and 600 or dist < 1500 and 400 or 320
        if ActiveTween then ActiveTween:Cancel() end
        ActiveTween = TweenService:Create(root, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = pos})
        ActiveTween:Play()
        ActiveTween.Completed:Wait()
    end)
end

local function StopTP()
    pcall(function()
        if ActiveTween then ActiveTween:Cancel() end
    end)
end

local function MakeBillboard(parent, text, color)
    local bb  = Instance.new("BillboardGui", parent)
    bb.AlwaysOnTop = true
    bb.Size        = UDim2.new(0,200,0,50)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size                   = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextScaled             = true
    lbl.TextStrokeTransparency = 0.4
    lbl.Text      = text
    lbl.TextColor3 = color or Color3.fromRGB(7,236,240)
    return bb, lbl
end

local function AutoFarmLoop()
    while _G.AutoFarm do
        pcall(function()
            CheckQuest()
            local char   = LP.Character
            local root   = char and char:FindFirstChild("HumanoidRootPart")
            local hum    = char and char:FindFirstChildWhichIsA("Humanoid")
            if not root or not hum or hum.Health <= 0 then wait(1) return end

            local questVisible = LP.PlayerGui:FindFirstChild("Main") and
                                 LP.PlayerGui.Main:FindFirstChild("Quest") and
                                 LP.PlayerGui.Main.Quest.Visible

            if not questVisible then
                StopTP()
                TPPos(CFrameQuest)
                wait(0.5)
                if _G.AutoFarm then
                    pcall(function() RS.Remotes.CommF_:InvokeServer("SetSpawnPoint") end)
                    pcall(function() RS.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest) end)
                end
            else
                local enemy = workspace.Enemies:FindFirstChild(Mon)
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                    if _G.SelectedWeapon then EquipWeapon(_G.SelectedWeapon) end
                    local eRoot = enemy.HumanoidRootPart
                    eRoot.Size        = Vector3.new(60,60,60)
                    eRoot.CanCollide  = false
                    eRoot.CFrame      = root.CFrame * CFrame.new(0,0,-5)
                    enemy.Humanoid.PlatformStand = true
                    VU:CaptureController()
                    VU:Button1Down(Vector2.new(1280,672))
                    wait(0.1)
                    VU:Button1Up(Vector2.new(1280,672))
                else
                    TPPos(CFrameMon)
                end
            end

            if _G.AutoHaki then
                pcall(function()
                    if not char:FindFirstChild("HasBuso") then
                        RS.Remotes.CommF_:InvokeServer("Buso")
                    end
                end)
            end
        end)
        wait(0.2)
    end
end

spawn(function()
    while true do
        pcall(function()
            if _G.AutoFarm then
                pcall(function() sethiddenproperty(LP,"SimulationRadius",math.huge) end)
            end
            if _G.InfiniteEnergy then
                local e = LP.Character:FindFirstChild("Energy")
                if e then e.Value = e.Value + 0 end
            end
            if _G.AutoStats then
                local pts = LP.Data.Points.Value
                if pts >= 1 then
                    local stats = {"Melee","Defense","Sword","Gun","Fruit"}
                    for _, s in ipairs(stats) do
                        if _G["Stat_"..s] then
                            pcall(function() RS.Remotes.CommF_:InvokeServer("AddPoint", s == "Fruit" and "Demon Fruit" or s, 1) end)
                        end
                    end
                end
            end
        end)
        wait(0.5)
    end
end)

spawn(function()
    while wait(0.1) do
        pcall(function()
            UpdatePlayerChams()
            UpdateChestChams()
            UpdateIslandESP()
            UpdateIslandMirageESP()
            UpdateAfdESP()
            UpdateLSDESP()
            UpdateAuraESP()
        end)
    end
end)

function UpdatePlayerChams()
    for _, v in pairs(Players:GetPlayers()) do
        pcall(function()
            if v.Character and v.Character:FindFirstChild("Head") then
                local head = v.Character.Head
                local key  = "VXesp"..ESPNum
                if ESPPlayer then
                    if not head:FindFirstChild(key) then
                        local bb, lbl = MakeBillboard(head, v.Name, v.Team == LP.Team and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,60,60))
                        bb.Name = key
                    else
                        local lbl = head[key]:FindFirstChildWhichIsA("TextLabel")
                        if lbl then
                            local dist = round((LP.Character.Head.Position - head.Position).Magnitude/3)
                            local hp   = round(v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth * 100)
                            lbl.Text = v.Name.." | "..dist.."m  HP:"..hp.."%"
                        end
                    end
                else
                    local b = head:FindFirstChild(key)
                    if b then b:Destroy() end
                end
            end
        end)
    end
end

function UpdateChestChams()
    local colors = {Chest1=Color3.fromRGB(160,160,160),Chest2=Color3.fromRGB(220,190,20),Chest3=Color3.fromRGB(60,220,255)}
    for _, v in pairs(workspace:GetChildren()) do
        pcall(function()
            if v.Name:find("Chest") and colors[v.Name] then
                local key = "VXesp"..ESPNum
                if ChestESP then
                    if not v:FindFirstChild(key) then
                        local bb, lbl = MakeBillboard(v, v.Name, colors[v.Name])
                        bb.Name = key
                    else
                        local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                        if lbl then
                            lbl.Text = v.Name.."  "..round((LP.Character.Head.Position-v.Position).Magnitude/3).."m"
                        end
                    end
                else
                    local b = v:FindFirstChild(key)
                    if b then b:Destroy() end
                end
            end
        end)
    end
end

function UpdateIslandESP()
    pcall(function()
        for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name ~= "Sea" then
                local key = "VXIsland"
                if IslandESP then
                    if not v:FindFirstChild(key) then
                        local bb, lbl = MakeBillboard(v, v.Name, Color3.fromRGB(7,236,240))
                        bb.Name = key
                    else
                        local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                        if lbl then lbl.Text = v.Name.."  "..round((LP.Character.Head.Position-v.Position).Magnitude/3).."m" end
                    end
                else
                    local b = v:FindFirstChild(key)
                    if b then b:Destroy() end
                end
            end
        end
    end)
end

function UpdateIslandMirageESP()
    pcall(function()
        for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == "Mirage Island" then
                local key = "VXMirage"
                if MirageIslandESP then
                    if not v:FindFirstChild(key) then
                        local bb, lbl = MakeBillboard(v, "✨ Mirage Island", Color3.fromRGB(80,245,245))
                        bb.Name = key
                    else
                        local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                        if lbl then lbl.Text = "✨ Mirage Island  "..round((LP.Character.Head.Position-v.Position).Magnitude/3).."m" end
                    end
                else
                    local b = v:FindFirstChild(key)
                    if b then b:Destroy() end
                end
            end
        end
    end)
end

local function NPCEsp(npcName, flag, label, color)
    pcall(function()
        for _, v in pairs(workspace.NPCs:GetChildren()) do
            if v.Name == npcName then
                local key = "VX_"..npcName:gsub("%s","")
                if _G[flag] then
                    if not v:FindFirstChild(key) then
                        local root = v:FindFirstChild("HumanoidRootPart") or v
                        local bb, lbl = MakeBillboard(root, label, color)
                        bb.Name = key
                    else
                        local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                        if lbl then lbl.Text = label.."  "..round((LP.Character.Head.Position-v.PrimaryPart.Position).Magnitude/3).."m" end
                    end
                else
                    local b = v:FindFirstChild(key)
                    if b then b:Destroy() end
                end
            end
        end
    end)
end

function UpdateAfdESP()   NPCEsp("Advanced Fruit Dealer","AfdESP","🍈 Fruit Dealer",Color3.fromRGB(255,200,0)) end
function UpdateLSDESP()   NPCEsp("Legendary Sword Dealer","LADESP","⚔️ Sword Dealer",Color3.fromRGB(200,200,255)) end
function UpdateAuraESP()  NPCEsp("Master of Enhancement","AuraESP","🔮 Enhancement",Color3.fromRGB(100,100,255)) end

local function MobESPLoop()
    while wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                local root = v:FindFirstChild("HumanoidRootPart")
                if root then
                    local key = "VXMobESP"
                    if MobESP then
                        if not v:FindFirstChild(key) then
                            local bb, lbl = MakeBillboard(v, v.Name, Color3.fromRGB(255,80,80))
                            bb.Name = key
                            bb.StudsOffset = Vector3.new(0,2.5,0)
                        else
                            local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                            if lbl then
                                lbl.Text = v.Name.."  "..math.floor((LP.Character.HumanoidRootPart.Position-root.Position).Magnitude).."m"
                            end
                        end
                    else
                        local b = v:FindFirstChild(key)
                        if b then b:Destroy() end
                    end
                end
            end
        end)
    end
end
spawn(MobESPLoop)

local function SeaESPLoop()
    while wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace.SeaBeasts:GetChildren()) do
                local root = v:FindFirstChild("HumanoidRootPart")
                if root then
                    local key = "VXSeaESP"
                    if SeaESP then
                        if not v:FindFirstChild(key) then
                            local bb, lbl = MakeBillboard(v, v.Name, Color3.fromRGB(0,180,255))
                            bb.Name = key
                        else
                            local lbl = v[key]:FindFirstChildWhichIsA("TextLabel")
                            if lbl then lbl.Text = v.Name.."  "..math.floor((LP.Character.HumanoidRootPart.Position-root.Position).Magnitude).."m" end
                        end
                    else
                        local b = v:FindFirstChild(key)
                        if b then b:Destroy() end
                    end
                end
            end
        end)
    end
end
spawn(SeaESPLoop)

local function DevilFruitESPLoop()
    while wait(0.5) do
        pcall(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:find("Fruit") then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        local key = "VXFruitESP"
                        if DevilFruitESP then
                            if not handle:FindFirstChild(key) then
                                local bb, lbl = MakeBillboard(handle, "🍑 "..v.Name, Color3.fromRGB(255,255,100))
                                bb.Name = key
                            else
                                local lbl = handle[key]:FindFirstChildWhichIsA("TextLabel")
                                if lbl then lbl.Text = "🍑 "..v.Name.."  "..round((LP.Character.Head.Position-handle.Position).Magnitude/3).."m" end
                            end
                        else
                            local b = handle:FindFirstChild(key)
                            if b then b:Destroy() end
                        end
                    end
                end
            end
        end)
    end
end
spawn(DevilFruitESPLoop)

local function Hop()
    local PlaceID  = game.PlaceId
    local AllIDs   = {}
    local cursor   = ""
    while true do
        pcall(function()
            local url = 'https://games.roblox.com/v1/games/'..PlaceID..'/servers/Public?sortOrder=Asc&limit=100'
            if cursor ~= "" then url = url.."&cursor="..cursor end
            local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
            cursor = data.nextPageCursor or ""
            for _, v in ipairs(data.data) do
                local id = tostring(v.id)
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    local found = false
                    for _, ex in ipairs(AllIDs) do if ex == id then found = true break end end
                    if not found then
                        table.insert(AllIDs, id)
                        pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, id, LP) end)
                        wait(4)
                    end
                end
            end
        end)
        wait(1)
    end
end

local function BuyFightingStyle(style)
    pcall(function() RS.Remotes.CommF_:InvokeServer("Buy"..style) end)
end

local SettingsTab = Window:CreateTab("⚙️ Settings", nil)
local MainTab     = Window:CreateTab("⚔️ Auto Farm", nil)
local StatsTab    = Window:CreateTab("📊 Auto Stats", nil)
local TeleTab     = Window:CreateTab("🌀 Teleport", nil)
local ESPTab      = Window:CreateTab("👁 ESP", nil)
local MiscTab     = Window:CreateTab("🔧 Misc", nil)
local ShopTab     = Window:CreateTab("🛒 Shop", nil)

SettingsTab:CreateToggle({ Name="Auto Haki (Buso)", CurrentValue=false, Flag="AutoHaki",
    Callback=function(v) _G.AutoHaki = v end })

SettingsTab:CreateToggle({ Name="Infinite Energy", CurrentValue=false, Flag="InfiniteEnergy",
    Callback=function(v)
        _G.InfiniteEnergy = v
        if v then
            spawn(function()
                while _G.InfiniteEnergy do
                    pcall(function()
                        local e = LP.Character:FindFirstChild("Energy")
                        if e then e.Value = 99999 end
                    end)
                    wait(0.05)
                end
            end)
        end
    end })

SettingsTab:CreateToggle({ Name="No Dodge Cooldown", CurrentValue=false, Flag="NoDodgeCool",
    Callback=function(v)
        _G.NoDodgeCool = v
        if v then
            spawn(function()
                while _G.NoDodgeCool do
                    pcall(function()
                        for _, gc in next, getgc() do
                            if typeof(gc) == "function" and LP.Character:FindFirstChild("Dodge") then
                                if getfenv(gc).script == LP.Character.Dodge then
                                    for i, uv in next, getupvalues(gc) do
                                        if tostring(uv) == "0.1" then setupvalue(gc,i,0) end
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.1)
                end
            end)
        end
    end })

SettingsTab:CreateToggle({ Name="Server Hop", CurrentValue=false, Flag="ServerHop",
    Callback=function(v) if v then spawn(Hop) end end })

SettingsTab:CreateToggle({ Name="Anti AFK", CurrentValue=true, Flag="AntiAFK",
    Callback=function(v)
        if v then
            spawn(function()
                while _G.AntiAFK do
                    VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                    wait(1)
                    VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                    wait(30)
                end
            end)
        end
    end })
_G.AntiAFK = true

local WeaponList = {}
for _, v in ipairs(LP.Backpack:GetChildren()) do
    if v:IsA("Tool") then table.insert(WeaponList, v.Name) end
end
for _, v in ipairs(LP.Character:GetChildren()) do
    if v:IsA("Tool") then table.insert(WeaponList, v.Name) end
end

local WeaponDrop = SettingsTab:CreateDropdown({
    Name = "Select Weapon",
    Options = WeaponList,
    CurrentOption = {"None"},
    Flag = "WeaponSelect",
    Callback = function(v) _G.SelectedWeapon = v[1] end,
})

SettingsTab:CreateButton({ Name="Refresh Weapon List",
    Callback=function()
        WeaponDrop:Set({"None"})
        local new = {}
        for _, v in ipairs(LP.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(new, v.Name) end end
        for _, v in ipairs(LP.Character:GetChildren()) do if v:IsA("Tool") then table.insert(new, v.Name) end end
        Rayfield:Notify({Title="VerX HUB", Content="Weapon list refreshed!", Duration=2})
    end })

MainTab:CreateToggle({ Name="Auto Farm", CurrentValue=false, Flag="AutoFarm",
    Callback=function(v)
        _G.AutoFarm = v
        if v then
            CheckQuest()
            Rayfield:Notify({Title="VerX HUB", Content="Auto Farm ON — "..tostring(Mon), Duration=3})
            spawn(AutoFarmLoop)
        else
            StopTP()
            Rayfield:Notify({Title="VerX HUB", Content="Auto Farm OFF", Duration=2})
        end
    end })

MainTab:CreateLabel("Current mob updates automatically based on your level.")

StatsTab:CreateToggle({ Name="Auto Stats", CurrentValue=false, Flag="AutoStats",
    Callback=function(v) _G.AutoStats = v end })
StatsTab:CreateToggle({ Name="Melee",   CurrentValue=false, Flag="Stat_Melee",   Callback=function(v) _G.Stat_Melee = v end })
StatsTab:CreateToggle({ Name="Defense", CurrentValue=false, Flag="Stat_Defense", Callback=function(v) _G.Stat_Defense = v end })
StatsTab:CreateToggle({ Name="Sword",   CurrentValue=false, Flag="Stat_Sword",   Callback=function(v) _G.Stat_Sword = v end })
StatsTab:CreateToggle({ Name="Gun",     CurrentValue=false, Flag="Stat_Gun",     Callback=function(v) _G.Stat_Gun = v end })
StatsTab:CreateToggle({ Name="Devil Fruit", CurrentValue=false, Flag="Stat_Fruit", Callback=function(v) _G.Stat_Fruit = v end })

local W1Teles, W2Teles, W3Teles = {}, {}, {}
if World1 then
    W1Teles = {
        {"Start Island",    CFrame.new(1071,16,1426)},
        {"Middle Town",     CFrame.new(-655,7,1436)},
        {"Jungle",          CFrame.new(-1249,11,341)},
        {"Pirate Village",  CFrame.new(-1122,4,3855)},
        {"Desert",          CFrame.new(1094,6,4192)},
        {"Frozen Village",  CFrame.new(1198,27,-1211)},
        {"Marine Ford",     CFrame.new(-4505,20,4260)},
        {"Colosseum",       CFrame.new(-1428,7,-3014)},
        {"Sky Island 1",    CFrame.new(-4970,717,-2622)},
        {"Sky Island 2",    CFrame.new(-4813,903,-1912)},
        {"Sky Island 3",    CFrame.new(-7952,5545,-320)},
        {"Sky Island 4",    CFrame.new(-7793,5607,-2016)},
        {"Prison",          CFrame.new(4854,5,740)},
        {"Magma Village",   CFrame.new(-5231,8,8467)},
        {"Underwater City", CFrame.new(61163,11,1819)},
        {"Fountain City",   CFrame.new(5132,4,4037)},
    }
elseif World2 then
    W2Teles = {
        {"Dock",            CFrame.new(82,18,2834)},
        {"Kingdom of Rose", CFrame.new(-394,118,1245)},
        {"Mansion",         CFrame.new(-390,331,673)},
        {"Green Zone",      CFrame.new(-2372,72,-3166)},
        {"Cafe",            CFrame.new(-385,73,297)},
        {"Factory",         CFrame.new(430,210,-432)},
        {"Colosseum",       CFrame.new(-1836,44,1360)},
        {"Graveyard",       CFrame.new(-5411,48,-721)},
        {"Snow Mountain",   CFrame.new(511,401,-5380)},
        {"Cold Island",     CFrame.new(-6026,14,-5071)},
        {"Hot Island",      CFrame.new(-5478,15,-5246)},
        {"Cursed Ship",     CFrame.new(902,124,33071)},
        {"Ice Castle",      CFrame.new(5400,28,-6236)},
        {"Forgotten Island",CFrame.new(-3043,238,-10191)},
        {"Usopp Island",    CFrame.new(4748,8,2849)},
    }
elseif World3 then
    W3Teles = {
        {"Port Town",       CFrame.new(-610,57,6436)},
        {"Hydra Island",    CFrame.new(5229,603,345)},
        {"Great Tree",      CFrame.new(2174,28,-6728)},
        {"Castle on Sea",   CFrame.new(-5477,313,-2808)},
        {"Floating Turtle", CFrame.new(-10919,331,-8637)},
        {"Deep Jungle",     CFrame.new(-13234,331,-7625)},
        {"Secret Temple",   CFrame.new(5217,6,1100)},
        {"Friendly Arena",  CFrame.new(5220,72,-1450)},
        {"Haunted Castle",  CFrame.new(-9479,141,5566)},
        {"Peanut Island",   CFrame.new(-2104,38,-10194)},
        {"Ice Cream Island",CFrame.new(-820,65,-10965)},
        {"Tiki Outpost",    CFrame.new(-16547,61,-173)},
    }
end

local allTeles = (#W1Teles > 0 and W1Teles) or (#W2Teles > 0 and W2Teles) or W3Teles
for _, t in ipairs(allTeles) do
    local name, cf = t[1], t[2]
    TeleTab:CreateButton({ Name="→ "..name,
        Callback=function()
            pcall(function() LP.Character.HumanoidRootPart.CFrame = cf end)
            Rayfield:Notify({Title="Teleport", Content=name.." ✓", Duration=2})
        end })
end

ESPTab:CreateToggle({ Name="Player ESP",         CurrentValue=false, Flag="ESPPlayer",       Callback=function(v) ESPPlayer = v end })
ESPTab:CreateToggle({ Name="Chest ESP",          CurrentValue=false, Flag="ChestESP",        Callback=function(v) ChestESP = v end })
ESPTab:CreateToggle({ Name="Mob ESP",            CurrentValue=false, Flag="MobESP",          Callback=function(v) MobESP = v end })
ESPTab:CreateToggle({ Name="Sea Beast ESP",      CurrentValue=false, Flag="SeaESP",          Callback=function(v) SeaESP = v end })
ESPTab:CreateToggle({ Name="Devil Fruit ESP",    CurrentValue=false, Flag="DevilFruitESP",   Callback=function(v) DevilFruitESP = v end })
ESPTab:CreateToggle({ Name="Island ESP",         CurrentValue=false, Flag="IslandESP",       Callback=function(v) IslandESP = v end })
ESPTab:CreateToggle({ Name="Mirage Island ESP",  CurrentValue=false, Flag="MirageIslandESP", Callback=function(v) MirageIslandESP = v end })
ESPTab:CreateToggle({ Name="Fruit Dealer ESP",   CurrentValue=false, Flag="AfdESP",          Callback=function(v) _G.AfdESP = v end })
ESPTab:CreateToggle({ Name="Sword Dealer ESP",   CurrentValue=false, Flag="LADESP",          Callback=function(v) _G.LADESP = v end })
ESPTab:CreateToggle({ Name="Enhancement NPC ESP",CurrentValue=false, Flag="AuraESP",         Callback=function(v) _G.AuraESP = v end })

MiscTab:CreateToggle({ Name="Fly", CurrentValue=false, Flag="Fly",
    Callback=function(v)
        Fly = v
        if v then
            spawn(function()
                local torso = LP.Character.HumanoidRootPart
                local pos   = Instance.new("BodyPosition",torso)
                local gyro  = Instance.new("BodyGyro",torso)
                pos.Name = "VXFlyPos"
                pos.maxForce = Vector3.new(math.huge,math.huge,math.huge)
                pos.position = torso.Position
                gyro.maxTorque = Vector3.new(9e9,9e9,9e9)
                gyro.CFrame = torso.CFrame
                local UIS = game:GetService("UserInputService")
                local cam = workspace.CurrentCamera
                repeat
                    wait()
                    LP.Character.Humanoid.PlatformStand = true
                    local spd = 1
                    if UIS:IsKeyDown(Enum.KeyCode.W) then pos.position = pos.position + cam.CFrame.LookVector*1.5 spd=2 end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then pos.position = pos.position - cam.CFrame.LookVector*1.5 spd=2 end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then pos.position = pos.position - cam.CFrame.RightVector*1.5 end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then pos.position = pos.position + cam.CFrame.RightVector*1.5 end
                    gyro.CFrame = cam.CFrame
                until not Fly
                pos:Destroy() gyro:Destroy()
                LP.Character.Humanoid.PlatformStand = false
            end)
        end
    end })

MiscTab:CreateToggle({ Name="Inf Jump", CurrentValue=false, Flag="InfJump",
    Callback=function(v)
        _G.InfJump = v
        if v then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump and LP.Character then
                    LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end })

MiscTab:CreateSlider({ Name="Walk Speed", Range={16,500}, Increment=1, CurrentValue=16, Flag="WalkSpeed",
    Callback=function(v)
        spawn(function()
            while _G.WalkSpeedActive do
                pcall(function() LP.Character.Humanoid.WalkSpeed = v end)
                wait(0.1)
            end
        end)
        _G.WalkSpeedActive = true
        _G.WalkSpeedVal = v
    end })

MiscTab:CreateSlider({ Name="Jump Power", Range={50,500}, Increment=5, CurrentValue=50, Flag="JumpPower",
    Callback=function(v)
        pcall(function() LP.Character.Humanoid.JumpPower = v end)
    end })

ShopTab:CreateButton({ Name="Buy Black Leg",      Callback=function() BuyFightingStyle("BlackLeg")     end })
ShopTab:CreateButton({ Name="Buy Electro",         Callback=function() BuyFightingStyle("Electro")      end })
ShopTab:CreateButton({ Name="Buy Fishman Karate",  Callback=function() BuyFightingStyle("FishmanKarate") end })
ShopTab:CreateButton({ Name="Buy Dragon Claw",     Callback=function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
        RS.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
    end)
end })
ShopTab:CreateButton({ Name="Buy Superhuman",      Callback=function() BuyFightingStyle("Superhuman")   end })
ShopTab:CreateButton({ Name="Buy Death Step",      Callback=function() BuyFightingStyle("DeathStep")    end })
ShopTab:CreateButton({ Name="Buy Sharkman Karate", Callback=function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
        RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end)
end })
ShopTab:CreateButton({ Name="Buy Electric Claw",   Callback=function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("BuyElectricClaw",true)
        RS.Remotes.CommF_:InvokeServer("BuyElectricClaw")
    end)
end })
ShopTab:CreateButton({ Name="Buy Dragon Talon",    Callback=function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("BuyDragonTalon",true)
        RS.Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end)
end })

Rayfield:Notify({
    Title   = "VerX HUB",
    Content = "Loaded! World: "..(World1 and "First" or World2 and "Second" or "Third").."  |  Lv."..LP.Data.Level.Value,
    Duration = 6,
    Image   = 4483362458,
})

Rayfield:LoadConfiguration()
