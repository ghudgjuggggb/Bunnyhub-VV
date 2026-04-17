local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")
local VirtualUser      = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid    = Character:WaitForChild("Humanoid")
local RootPart    = Character:WaitForChild("HumanoidRootPart")
local Camera      = workspace.CurrentCamera

local State = {
    GhostESP       = false,
    EvidenceESP    = false,
    ItemESP        = false,
    FingerprintESP = false,
    Fullbright     = false,
    NoClip         = false,
    Fly            = false,
    InfStamina     = false,
    HuntWarning    = false,
    AutoGhostType  = false,
    AntiAFK        = false,
    RemoveFog      = false,
    RemovePostFX   = false,
    AntiSex        = false,
    AutoPlay       = false,
}

local EvidenceFound = {
    ["EMF Level 5"]     = false,
    ["Handprints"]      = false,
    ["Spirit Box"]      = false,
    ["Ghost Orb"]       = false,
    ["Freezing Temps"]  = false,
    ["Ghost Writing"]   = false,
    ["Laser Projector"] = false,
    ["Wither"]          = false,
}

local GHOST_DATA = {
    { name = "Aswang",     evidence = {"Wither","EMF Level 5","Ghost Writing"},          ability = "Speed up per kill. Salt slows them." },
    { name = "Banshee",    evidence = {"Ghost Orb","Handprints","Freezing Temps"},       ability = "Breaks multiple windows. Unique wail at hunt start." },
    { name = "Demon",      evidence = {"EMF Level 5","Handprints","Freezing Temps"},     ability = "Hunts more frequently. Crosses float upon burning." },
    { name = "Dullahan",   evidence = {"Wither","Laser Projector","Freezing Temps"},     ability = "Headless in photos. Speed up while in line-of-sight." },
    { name = "Dybbuk",     evidence = {"Wither","Handprints","Freezing Temps"},          ability = "Stunned by first music-box play. Can throw corpses." },
    { name = "Entity",     evidence = {"Spirit Box","Handprints","Laser Projector"},     ability = "Teleports between rooms. Teleports objects (smoke)." },
    { name = "Ghoul",      evidence = {"Spirit Box","Freezing Temps","Ghost Orb"},       ability = "Hunts on excessive chat. Can't disable electronics." },
    { name = "Keres",      evidence = {"Wither","Handprints","Spirit Box"},              ability = "Speed down per kill. Targets lowest-energy player." },
    { name = "Leviathan",  evidence = {"Ghost Orb","Ghost Writing","Handprints"},        ability = "Turns off lights passively. Throws multiple objects." },
    { name = "Nightmare",  evidence = {"EMF Level 5","Spirit Box","Ghost Orb"},          ability = "Auditory hallucinations. Afraid of lit rooms." },
    { name = "Oni",        evidence = {"Spirit Box","Freezing Temps","Laser Projector"}, ability = "Extremely fast hunts. More ghost events." },
    { name = "Phantom",    evidence = {"EMF Level 5","Handprints","Ghost Orb"},          ability = "Slower blink. Faster while invisible during hunt." },
    { name = "Revenant",   evidence = {"Ghost Writing","EMF Level 5","Freezing Temps"},  ability = "Low hunt cooldown. Stops hunting after a kill." },
    { name = "Siren",      evidence = {"Wither","Spirit Box","EMF Level 5"},             ability = "Female voice. Slows players in line-of-sight." },
    { name = "Shadow",     evidence = {"EMF Level 5","Ghost Writing","Laser Projector"}, ability = "Lower temp changes. Slower in lit rooms." },
    { name = "Skinwalker", evidence = {"Freezing Temps","Ghost Writing","Spirit Box"},   ability = "Fakes Ghost Orb. Mimics other ghosts abilities." },
    { name = "Specter",    evidence = {"EMF Level 5","Freezing Temps","Laser Projector"},ability = "Throws items frequently. Stays in ghost room." },
    { name = "Spirit",     evidence = {"Handprints","Ghost Writing","Spirit Box"},       ability = "Alters candles to blue." },
    { name = "The Wisp",   evidence = {"Wither","Laser Projector","Ghost Orb"},          ability = "Walks through fire. Hunts only in favourite room." },
    { name = "Umbra",      evidence = {"Ghost Orb","Laser Projector","Handprints"},      ability = "No footstep sounds. Slower in lit rooms." },
    { name = "Vex",        evidence = {"Wither","Ghost Orb","Freezing Temps"},           ability = "Invisible to LIDAR. Walks through walls." },
    { name = "Wendigo",    evidence = {"Ghost Orb","Ghost Writing","Laser Projector"},   ability = "Less hunts near flames. Speed up as avg energy drops." },
    { name = "Wraith",     evidence = {"EMF Level 5","Spirit Box","Laser Projector"},    ability = "Drains energy fast (~0.3%/s). Doesn't disturb salt." },
}

local function deduceGhosts()
    local selected = {}
    for ev, found in pairs(EvidenceFound) do
        if found then table.insert(selected, ev) end
    end
    if #selected == 0 then return 0, {} end
    local possible = {}
    for _, ghost in ipairs(GHOST_DATA) do
        local match = true
        for _, ev in ipairs(selected) do
            local has = false
            for _, gev in ipairs(ghost.evidence) do
                if gev == ev then has = true; break end
            end
            if not has then match = false; break end
        end
        if match then table.insert(possible, ghost) end
    end
    return #selected, possible
end

local ESPObjects    = {}
local OriginalLight = {}
local FlyBodyVel    = nil
local FlyBodyGyro   = nil

local Window = Rayfield:CreateWindow({
    Name            = "Astra Hub",
    LoadingTitle    = "Astra Hub",
    LoadingSubtitle = "Demonology Edition v1.0.0",
    ConfigurationSaving = { Enabled = true, FolderName = "AstraHub", FileName = "Demonology" },
    Discord   = { Enabled = false },
    KeySystem = false,
})

-- ============================================================
--  HELPERS
-- ============================================================
local function findGhost()
    for _, name in ipairs({"Ghost","GhostModel","Spirit","Entity"}) do
        local obj = workspace:FindFirstChild(name, true)
        if obj then return obj end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj:GetAttribute("GhostType") or obj:GetAttribute("Type") or obj:GetAttribute("ghost") then
                return obj
            end
        end
    end
    return nil
end

local function getGhostType()
    local ghost = findGhost()
    if not ghost then return "Not Found" end
    return ghost:GetAttribute("GhostType") or ghost:GetAttribute("Type")
        or ghost:GetAttribute("ghost") or ghost.Name or "Unknown"
end

local function isPlayerPart(obj)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and obj:IsDescendantOf(p.Character) then return true end
    end
    return false
end

-- ============================================================
--  ESP CORE
-- ============================================================
local function addESP(obj, fillColor, outlineColor, labelText)
    if not obj or not obj.Parent then return end
    if ESPObjects[obj] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = fillColor or Color3.fromRGB(255,0,0)
    hl.OutlineColor = outlineColor or Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.45; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = obj; hl.Parent = obj
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0,220,0,28); bb.StudsOffset = Vector3.new(0,2.5,0)
    bb.AlwaysOnTop = true; bb.Adornee = obj; bb.Parent = obj
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0); lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true; lbl.Text = labelText or obj.Name; lbl.Parent = bb
    ESPObjects[obj] = { highlight = hl, billboard = bb }
    obj.AncestryChanged:Connect(function()
        if not obj.Parent then
            if ESPObjects[obj] then
                pcall(function() hl:Destroy() end)
                pcall(function() bb:Destroy() end)
                ESPObjects[obj] = nil
            end
        end
    end)
end

local function removeESP(obj)
    local data = ESPObjects[obj]
    if not data then return end
    pcall(function() data.highlight:Destroy() end)
    pcall(function() data.billboard:Destroy() end)
    ESPObjects[obj] = nil
end

local function clearESPByCategory(tag)
    for obj, data in pairs(ESPObjects) do
        local bb = data.billboard
        if bb then
            local lbl = bb:FindFirstChildWhichIsA("TextLabel")
            if lbl and lbl.Text:find(tag) then removeESP(obj) end
        end
    end
end

local function clearAllESP()
    for obj in pairs(ESPObjects) do removeESP(obj) end
end

local function scanGhostESP()
    local ghost = findGhost()
    if ghost then addESP(ghost, Color3.fromRGB(180,0,255), Color3.fromRGB(255,150,255), "👻 GHOST | " .. getGhostType()) end
end

local EVIDENCE_EXACT = {
    "GhostOrb","Ghost_Orb","Orb","Handprint","HandPrint","Fingerprint","Footprint","Footstep",
    "EMFReading","EMF5","EMFLevel5","SpiritBox","Spirit_Box","FreezingTemp","FreezingTemperature",
    "GhostWriting","Ghost_Writing","LaserProjector","Laser_Projector","LaserDot",
    "WitherMark","Wither_Mark","WitherTrace",
}

local function isEvidenceExact(name)
    local lower = name:lower()
    for _, kw in ipairs(EVIDENCE_EXACT) do
        if lower == kw:lower() then return true, kw end
    end
    return false, nil
end

local function isEvidenceParent(name)
    local lower = name:lower()
    for _, kw in ipairs({"ghostorb","handprint","fingerprint","footprint","footstep","emflevel5","emf5",
        "spiritbox","freezingtemp","ghostwriting","laserprojecter","laserprojector","withermark","withertrace"}) do
        if lower:find(kw) then return true, kw end
    end
    return false, nil
end

local function scanEvidenceESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isPlayerPart(obj) then continue end
        if obj:IsA("Model") then
            local ok, kw = isEvidenceParent(obj.Name)
            if ok and not ESPObjects[obj] then
                addESP(obj, Color3.fromRGB(255,200,0), Color3.fromRGB(255,240,0), "🔍 " .. (kw or obj.Name))
            end
        elseif obj:IsA("BasePart") then
            if obj.Parent and obj.Parent:IsA("Model") and ESPObjects[obj.Parent] then continue end
            local ok, kw = isEvidenceExact(obj.Name)
            if ok and not ESPObjects[obj] then
                addESP(obj, Color3.fromRGB(255,200,0), Color3.fromRGB(255,240,0), "🔍 " .. (kw or obj.Name))
            end
        end
    end
end

local ITEM_KEYWORDS = {
    "Thermometer","EMFReader","Camera","SpiritBox","UVLight","Flashlight","Crucifix","VideoCamera",
    "MusicBox","Candle","SaltShaker","TripMine","Parabolic","Journal","CrossNecklace",
    "LaserProjector","LIDAR","Blacklight","FlowerPot","SpiritBook",
}

local function isItem(name)
    for _, kw in ipairs(ITEM_KEYWORDS) do
        if name:lower():find(kw:lower()) then return true, kw end
    end
    return false, nil
end

local function scanItemESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isPlayerPart(obj) then continue end
        if (obj:IsA("Model") or obj:IsA("Tool") or obj:IsA("BasePart")) and obj.Parent then
            local ok, kw = isItem(obj.Name)
            if ok then addESP(obj, Color3.fromRGB(0,200,100), Color3.fromRGB(0,255,150), "📦 " .. (kw or "Item")) end
        end
    end
end

local function scanFingerprintESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isPlayerPart(obj) then continue end
        if obj:IsA("BasePart") and obj.Parent then
            for _, kw in ipairs({"Fingerprint","Handprint","Footprint","Footstep","UVTrace"}) do
                if obj.Name:lower():find(kw:lower()) then
                    addESP(obj, Color3.fromRGB(0,150,255), Color3.fromRGB(100,200,255), "🖐 " .. kw)
                    break
                end
            end
        end
    end
end

local function startESPLoop(stateKey, scanFn, interval)
    task.spawn(function()
        while State[stateKey] do
            task.wait(interval or 1.5)
            if State[stateKey] then pcall(scanFn) end
        end
    end)
end

-- ============================================================
--  HUNT DETECTION
-- ============================================================
local function detectHunt()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BoolValue") then
            local n = obj.Name:lower()
            if (n:find("hunt") or n:find("chasing") or n:find("attacking")) and obj.Value then return true end
        end
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local n = obj.Name:lower()
            if (n:find("hunt") or n:find("phase") or n:find("chasing")) and obj.Value > 0 then return true end
        end
        if obj:IsA("StringValue") then
            local n = obj.Name:lower(); local v = obj.Value:lower()
            if (n:find("state") or n:find("phase") or n:find("ghoststate")) then
                if v:find("hunt") or v:find("chase") or v:find("attack") then return true end
            end
        end
        if obj:IsA("Model") then
            for k, v in pairs(obj:GetAttributes()) do
                local kl = k:lower()
                if (kl:find("hunt") or kl:find("chasing") or kl:find("attacking")) and v then return true end
            end
        end
    end
    local ghost = findGhost()
    if ghost then
        for k, v in pairs(ghost:GetAttributes()) do
            local kl = k:lower()
            if (kl:find("hunt") or kl:find("active") or kl:find("phase")) and v then
                if type(v) == "boolean" and v then return true end
                if type(v) == "number" and v > 0 then return true end
                if type(v) == "string" and (v:lower():find("hunt") or v:lower():find("active")) then return true end
            end
        end
        for _, child in ipairs(ghost:GetDescendants()) do
            if child:IsA("BoolValue") and child.Name:lower():find("hunt") and child.Value then return true end
        end
    end
    return false
end

local function antiSexEscape()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local best, bestDist = nil, math.huge
    for _, name in ipairs({"Closet","Wardrobe","Cabinet","Locker","HidingSpot","Cupboard"}) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                local d = (obj.Position - root.Position).Magnitude
                if d < bestDist then bestDist = d; best = obj end
            end
        end
    end
    if best then
        root.CFrame = best.CFrame + Vector3.new(0,3,0)
        Rayfield:Notify({ Title="🍆 Anti Sex ACTIVATED", Content="Escaped to hiding spot!", Duration=5, Image=4483362458 })
        return
    end
    for _, name in ipairs({"SpawnLocation","Spawn","Entrance","Exit","LobbySpawn","Lobby"}) do
        local obj = workspace:FindFirstChild(name, true)
        if obj and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({ Title="🍆 Anti Sex ACTIVATED", Content="Fled to entrance.", Duration=5, Image=4483362458 })
            return
        end
    end
    local ghost = findGhost()
    if ghost then
        local gp = ghost:IsA("BasePart") and ghost or ghost:FindFirstChildWhichIsA("BasePart",true)
        if gp then
            local away = (root.Position - gp.Position).Unit
            root.CFrame = CFrame.new(root.Position + away * 60 + Vector3.new(0,5,0))
            Rayfield:Notify({ Title="🍆 Anti Sex ACTIVATED", Content="Yeeted far from ghost!", Duration=5, Image=4483362458 })
        end
    end
end

-- ============================================================
--  AUTO PLAY — Deep Evidence Engine
--
--  Core idea: instead of only checking object NAMES, we also
--  deep-read VALUES (attributes, NumberValues, StringValues,
--  BoolValues) inside every relevant tool + the ghost object.
--  We also check the player's Character and Backpack so held
--  tools are included.
-- ============================================================

-- Collect all instances of a tool type from:
--   workspace, every player's Character, every player's Backpack
local function collectTools(keywords)
    local results = {}
    local seen = {}
    local function tryAdd(obj)
        if seen[obj] then return end
        seen[obj] = true
        local nl = obj.Name:lower()
        for _, kw in ipairs(keywords) do
            if nl:find(kw:lower()) then
                table.insert(results, obj)
                return
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do tryAdd(obj) end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _, obj in ipairs(p.Character:GetChildren()) do tryAdd(obj) end
            for _, obj in ipairs(p.Character:GetDescendants()) do tryAdd(obj) end
        end
        local bp = p:FindFirstChild("Backpack")
        if bp then
            for _, obj in ipairs(bp:GetChildren()) do tryAdd(obj) end
        end
    end
    return results
end

-- Deep-read: scan obj + ALL its descendants for numeric values
-- Returns the first matching number, or nil
local function deepNum(obj, patterns)
    local function checkOne(o)
        if o:IsA("NumberValue") or o:IsA("IntValue") or o:IsA("FloatValue") then
            local nl = o.Name:lower()
            for _, p in ipairs(patterns) do
                if nl:find(p) then return o.Value end
            end
        end
        local ok, attrs = pcall(function() return o:GetAttributes() end)
        if ok then
            for k, v in pairs(attrs) do
                if type(v) == "number" then
                    local kl = k:lower()
                    for _, p in ipairs(patterns) do
                        if kl:find(p) then return v end
                    end
                end
            end
        end
        return nil
    end
    local v = checkOne(obj)
    if v ~= nil then return v end
    local ok, desc = pcall(function() return obj:GetDescendants() end)
    if ok then
        for _, child in ipairs(desc) do
            local cv = checkOne(child)
            if cv ~= nil then return cv end
        end
    end
    return nil
end

-- Deep-read: scan obj + ALL its descendants for a truthy bool/string/number
local function deepBool(obj, patterns)
    local function checkOne(o)
        if o:IsA("BoolValue") then
            local nl = o.Name:lower()
            for _, p in ipairs(patterns) do
                if nl:find(p) and o.Value then return true end
            end
        end
        if o:IsA("StringValue") then
            local nl = o.Name:lower()
            for _, p in ipairs(patterns) do
                if nl:find(p) and o.Value ~= "" and o.Value:lower() ~= "none" and o.Value:lower() ~= "false" then
                    return true
                end
            end
        end
        if o:IsA("NumberValue") or o:IsA("IntValue") then
            local nl = o.Name:lower()
            for _, p in ipairs(patterns) do
                if nl:find(p) and o.Value > 0 then return true end
            end
        end
        local ok, attrs = pcall(function() return o:GetAttributes() end)
        if ok then
            for k, v in pairs(attrs) do
                local kl = k:lower()
                for _, p in ipairs(patterns) do
                    if kl:find(p) then
                        if type(v) == "boolean" and v then return true end
                        if type(v) == "number" and v > 0 then return true end
                        if type(v) == "string" and v ~= "" and v:lower() ~= "none" and v:lower() ~= "false" then return true end
                    end
                end
            end
        end
        return false
    end
    if checkOne(obj) then return true end
    local ok, desc = pcall(function() return obj:GetDescendants() end)
    if ok then
        for _, child in ipairs(desc) do
            if checkOne(child) then return true end
        end
    end
    return false
end

-- ── 🧊 Freezing Temps ──────────────────────────────────────────
local function ap_checkFreezing(allObjs)
    local TEMP_PAT = {"temp","temperature","celsius","fahrenheit","degrees"}
    local COLD = 3

    -- 1. Thermometer tool — read the displayed temperature value
    for _, tool in ipairs(collectTools({"thermometer","thermo"})) do
        local val = deepNum(tool, TEMP_PAT)
        if val ~= nil and val <= COLD and val >= -200 then return true end
    end

    -- 2. Ghost object temperature attribute
    local ghost = findGhost()
    if ghost then
        local val = deepNum(ghost, TEMP_PAT)
        if val ~= nil and val <= COLD and val >= -200 then return true end
    end

    -- 3. Any NumberValue/attribute in workspace with temp ≤ cold
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            local nl = obj.Name:lower()
            for _, p in ipairs(TEMP_PAT) do
                if nl:find(p) and obj.Value <= COLD and obj.Value >= -200 then return true end
            end
        end
        local ok, attrs = pcall(function() return obj:GetAttributes() end)
        if ok then
            for k, v in pairs(attrs) do
                if type(v) == "number" and v <= COLD and v >= -200 then
                    local kl = k:lower()
                    for _, p in ipairs(TEMP_PAT) do
                        if kl:find(p) then return true end
                    end
                end
            end
        end
    end
    return false
end

-- ── 📡 EMF Level 5 ─────────────────────────────────────────────
local function ap_checkEMF5(allObjs)
    -- 1. EMFReader tool — read the level value
    for _, tool in ipairs(collectTools({"emfreader","emf reader","emfmeter","emf_reader","emf"})) do
        -- Look for any number >= 5 inside the tool
        local function scanEMF(o)
            if o:IsA("NumberValue") or o:IsA("IntValue") then
                local nl = o.Name:lower()
                if (nl:find("emf") or nl:find("level") or nl:find("reading") or nl:find("value") or nl:find("signal")) then
                    if o.Value >= 5 then return true end
                end
            end
            local ok, attrs = pcall(function() return o:GetAttributes() end)
            if ok then
                for k, v in pairs(attrs) do
                    local kl = k:lower()
                    if type(v) == "number" and v >= 5 then
                        if kl:find("emf") or kl:find("level") or kl:find("reading") then return true end
                    end
                    if type(v) == "boolean" and v then
                        if kl:find("emf5") or kl:find("level5") or kl:find("emflevel5") then return true end
                    end
                end
            end
            return false
        end
        if scanEMF(tool) then return true end
        local ok, desc = pcall(function() return tool:GetDescendants() end)
        if ok then
            for _, c in ipairs(desc) do
                if scanEMF(c) then return true end
            end
        end
    end

    -- 2. Ghost attributes with emf ≥ 5
    local ghost = findGhost()
    if ghost then
        for k, v in pairs(ghost:GetAttributes()) do
            local kl = k:lower()
            if kl:find("emf") then
                if (type(v) == "number" and v >= 5) or (type(v) == "boolean" and v) then return true end
            end
        end
        for _, child in ipairs(ghost:GetDescendants()) do
            if (child:IsA("NumberValue") or child:IsA("IntValue")) and child.Name:lower():find("emf") then
                if child.Value >= 5 then return true end
            end
        end
    end

    -- 3. Workspace: named EMF5 objects or numeric values ≥ 5
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl == "emflevel5" or nl == "emf5" or nl == "emf_5" then
            if obj:IsA("BasePart") or obj:IsA("Model") then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
        if (obj:IsA("NumberValue") or obj:IsA("IntValue")) and nl:find("emf") and obj.Value >= 5 then
            return true
        end
    end
    return false
end

-- ── 🖐 Handprints ──────────────────────────────────────────────
local function ap_checkHandprints(allObjs)
    -- 1. Blacklight tool — check if it detected a handprint
    for _, tool in ipairs(collectTools({"blacklight","uvlight","uv_light","ultraviolet","uv"})) do
        if deepBool(tool, {"handprint","fingerprint","uvmark","detected","found","visible","print","trace"}) then
            return true
        end
    end
    -- 2. Handprint/fingerprint objects existing in workspace
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl:find("handprint") or nl:find("fingerprint") or nl:find("uvtrace")
        or nl:find("uvmark") or nl:find("handmark") or nl:find("uvstain") then
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Decal") or obj:IsA("Texture") then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
    end
    return false
end

-- ── 📻 Spirit Box ──────────────────────────────────────────────
local function ap_checkSpiritBox(allObjs)
    local RESP = {"response","talking","active","answered","reply","voice","detected","ghost","speak"}

    -- 1. SpiritBox tool — check for a response flag
    for _, tool in ipairs(collectTools({"spiritbox","spirit_box","spirit box"})) do
        if deepBool(tool, RESP) then return true end
        -- Non-empty string responses
        local ok, desc = pcall(function() return tool:GetDescendants() end)
        if ok then
            for _, child in ipairs(desc) do
                if child:IsA("StringValue") and child.Value ~= "" and child.Value:lower() ~= "none" then
                    local nl = child.Name:lower()
                    if nl:find("response") or nl:find("voice") or nl:find("answer") or nl:find("ghost") then
                        return true
                    end
                end
            end
        end
    end

    -- 2. Workspace spirit box indicators
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl:find("spiritbox") or nl:find("spirit_box") then
            if obj:IsA("BoolValue") and obj.Value then return true end
            if obj:IsA("StringValue") and obj.Value ~= "" then return true end
            if (obj:IsA("NumberValue") or obj:IsA("IntValue")) and obj.Value > 0 then return true end
        end
    end
    return false
end

-- ── 🔮 Ghost Orb ───────────────────────────────────────────────
local function ap_checkGhostOrb(allObjs)
    -- 1. VideoCamera — check if orb is visible in feed
    for _, tool in ipairs(collectTools({"videocamera","video_camera","vidcam","videocam"})) do
        if deepBool(tool, {"orb","ghostorb","ghost_orb","orbdetected","orbvisible","orbfound","orbs"}) then
            return true
        end
    end
    -- 2. Orb particle / object in workspace
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl == "ghostorb" or nl == "ghost_orb" or nl == "orb" or nl == "ghostball" or nl == "orbparticle" then
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("ParticleEmitter")
            or obj:IsA("SpotLight") or obj:IsA("PointLight") then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
        if obj:IsA("ParticleEmitter") and (nl:find("orb") or nl:find("ghostorb")) then return true end
    end
    return false
end

-- ── 📝 Ghost Writing ───────────────────────────────────────────
local function ap_checkGhostWriting(allObjs)
    local WRITE = {"written","writing","haswriting","marked","inkmark","drew","drawn","used","active","complete"}

    -- 1. SpiritBook / FlowerPot tools
    for _, tool in ipairs(collectTools({"spiritbook","spirit_book","flowerpot","flower_pot","notebook","journal","inkbook","book"})) do
        if deepBool(tool, WRITE) then return true end
    end

    -- 2. Writing mark objects in workspace
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl:find("ghostwriting") or nl:find("ghost_writing") or nl:find("writingmark")
        or nl:find("inkmark") or nl:find("writingstain") then
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Decal") or obj:IsA("Texture") then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
    end
    return false
end

-- ── 🔦 Laser Projector ─────────────────────────────────────────
local function ap_checkLaser(allObjs)
    local DOT = {"dot","dots","placed","active","on","visible","enabled","laserdot","projecting","detected"}

    -- 1. LaserProjector tool — check if dots are active
    for _, tool in ipairs(collectTools({"laserprojector","laser_projector","laserproj","lidar"})) do
        if deepBool(tool, DOT) then return true end
    end

    -- 2. Laser dot objects in workspace
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl:find("laserdot") or nl:find("laser_dot") or nl:find("lidardot")
        or nl:find("lidar_dot") or nl:find("projectormark") or nl:find("projdot") then
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("ParticleEmitter") then return true end
        end
    end
    return false
end

-- ── 💀 Wither ──────────────────────────────────────────────────
local function ap_checkWither(allObjs)
    -- 1. Ghost has wither attribute
    local ghost = findGhost()
    if ghost then
        if deepBool(ghost, {"wither","withering","withermark","witherdecay","decay"}) then return true end
    end
    -- 2. Wither mark objects
    for _, obj in ipairs(allObjs) do
        if isPlayerPart(obj) then continue end
        local nl = obj.Name:lower()
        if nl:find("wither") or nl:find("withertrace") or nl:find("withermark")
        or nl:find("wither_mark") or nl:find("witherdecay") then
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Decal") then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
    end
    return false
end

-- Master table
local AP_CHECKS = {
    { evidence = "Freezing Temps",  icon = "🧊", fn = ap_checkFreezing    },
    { evidence = "EMF Level 5",     icon = "📡", fn = ap_checkEMF5        },
    { evidence = "Handprints",      icon = "🖐",  fn = ap_checkHandprints  },
    { evidence = "Spirit Box",      icon = "📻", fn = ap_checkSpiritBox   },
    { evidence = "Ghost Orb",       icon = "🔮", fn = ap_checkGhostOrb    },
    { evidence = "Ghost Writing",   icon = "📝", fn = ap_checkGhostWriting},
    { evidence = "Laser Projector", icon = "🔦", fn = ap_checkLaser       },
    { evidence = "Wither",          icon = "💀", fn = ap_checkWither      },
}

local apAlreadyIdentified = false

local function autoPlayTick(statusLbl, resultLbl)
    local allObjs = workspace:GetDescendants()
    local newFound = {}

    for _, check in ipairs(AP_CHECKS) do
        local ok, result = pcall(check.fn, allObjs)
        if ok and result and not EvidenceFound[check.evidence] then
            EvidenceFound[check.evidence] = true
            table.insert(newFound, check.icon .. " " .. check.evidence)
        end
    end

    local foundCount = 0
    for _, v in pairs(EvidenceFound) do if v then foundCount += 1 end end

    pcall(function() statusLbl:Set("🤖 Auto Play: " .. foundCount .. "/8 evidence found") end)

    if #newFound > 0 then
        Rayfield:Notify({ Title="🤖 New Evidence!", Content=table.concat(newFound, "\n"), Duration=5, Image=4483362458 })
    end

    local _, possible = deduceGhosts()

    if #possible == 1 then
        local g = possible[1]
        pcall(function() resultLbl:Set("✅ Ghost: " .. g.name) end)
        if not apAlreadyIdentified then
            apAlreadyIdentified = true
            Rayfield:Notify({
                Title    = "✅ GHOST IDENTIFIED: " .. g.name:upper(),
                Content  = table.concat(g.evidence, " | ") .. "\n\n" .. g.ability,
                Duration = 12,
                Image    = 4483362458,
            })
        end
    elseif #possible > 1 then
        apAlreadyIdentified = false
        local names = {}
        for _, g in ipairs(possible) do table.insert(names, g.name) end
        pcall(function() resultLbl:Set("Possible (" .. #possible .. "): " .. table.concat(names, ", ")) end)
    elseif foundCount > 0 then
        apAlreadyIdentified = false
        pcall(function() resultLbl:Set("⚠️ No match — check evidence") end)
    else
        pcall(function() resultLbl:Set("Scanning for evidence...") end)
    end
end

-- ============================================================
--  TABS
-- ============================================================

-- TAB 1 — GHOST
local GhostTab = Window:CreateTab("👻 Ghost", 4483362458)
GhostTab:CreateSection("Identification")
local ghostLabel = GhostTab:CreateLabel("Ghost Type: —")

GhostTab:CreateButton({ Name="🔍 Identify Ghost Now",
    Callback=function()
        local gType = getGhostType()
        ghostLabel:Set("Ghost Type: " .. gType)
        Rayfield:Notify({ Title="👻 Ghost Identified", Content=gType, Duration=6, Image=4483362458 })
    end })

GhostTab:CreateToggle({ Name="🔄 Auto Identify Ghost (loop)", CurrentValue=false, Flag="AutoGhostType",
    Callback=function(val)
        State.AutoGhostType = val
        if val then
            task.spawn(function()
                while State.AutoGhostType do
                    ghostLabel:Set("Ghost Type: " .. getGhostType())
                    task.wait(2)
                end
            end)
        end
    end })

GhostTab:CreateSection("Ghost Attributes")

GhostTab:CreateButton({ Name="📊 Dump All Ghost Attributes",
    Callback=function()
        local ghost = findGhost()
        if not ghost then Rayfield:Notify({ Title="Astra Hub", Content="Ghost not found! Join a match first.", Duration=3 }); return end
        local attrs = {}
        for k, v in pairs(ghost:GetAttributes()) do table.insert(attrs, k .. " = " .. tostring(v)) end
        if #attrs == 0 then
            Rayfield:Notify({ Title="Ghost Attributes", Content="No attributes found.", Duration=4 })
        else
            Rayfield:Notify({ Title="Ghost Attributes", Content=table.concat(attrs, "\n"), Duration=10 })
        end
    end })

GhostTab:CreateButton({ Name="📋 Copy Ghost Type to Clipboard",
    Callback=function()
        local gType = getGhostType()
        pcall(function() setclipboard(gType) end)
        Rayfield:Notify({ Title="Copied!", Content=gType, Duration=2 })
    end })

GhostTab:CreateSection("Evidence Reference")
GhostTab:CreateLabel("📡 EMF Level 5  |  🖐 Handprints  |  📻 Spirit Box  |  🔮 Ghost Orb")
GhostTab:CreateLabel("🧊 Freezing Temps  |  📝 Ghost Writing  |  🔦 Laser Projector  |  💀 Wither")

-- TAB 2 — EVIDENCE
local EvidTab = Window:CreateTab("📋 Evidence", 4483362458)
EvidTab:CreateSection("Mark Evidence Found")

local EVIDENCE_LIST  = {"EMF Level 5","Handprints","Spirit Box","Ghost Orb","Freezing Temps","Ghost Writing","Laser Projector","Wither"}
local EVIDENCE_ICONS = {["EMF Level 5"]="📡",["Handprints"]="🖐",["Spirit Box"]="📻",["Ghost Orb"]="🔮",
    ["Freezing Temps"]="🧊",["Ghost Writing"]="📝",["Laser Projector"]="🔦",["Wither"]="💀"}

for _, ev in ipairs(EVIDENCE_LIST) do
    EvidTab:CreateToggle({
        Name=EVIDENCE_ICONS[ev].." "..ev, CurrentValue=false, Flag="Ev_"..ev:gsub("[%s/]",""),
        Callback=function(val) EvidenceFound[ev]=val end })
end

EvidTab:CreateSection("Ghost Deduction")
local deductLabel  = EvidTab:CreateLabel("Possible: — (mark evidence above)")
local abilityLabel = EvidTab:CreateLabel("Ability: —")

EvidTab:CreateButton({ Name="🔍 Deduce Ghost Now",
    Callback=function()
        local count, possible = deduceGhosts()
        if count == 0 then Rayfield:Notify({ Title="Evidence", Content="Mark at least 1 evidence type first!", Duration=3 }); return end
        if #possible == 0 then
            deductLabel:Set("Possible: 0 — check inputs!"); abilityLabel:Set("Ability: —")
            Rayfield:Notify({ Title="❌ No Match", Content="No ghost has all selected evidence.", Duration=5 }); return
        end
        local names = {}
        for _, g in ipairs(possible) do table.insert(names, g.name) end
        deductLabel:Set("Possible (" .. #possible .. "): " .. table.concat(names, ", "))
        if #possible == 1 then
            abilityLabel:Set("Ability: " .. possible[1].ability)
            Rayfield:Notify({ Title="✅ "..possible[1].name.."!", Content=table.concat(possible[1].evidence," | ").."\n\n"..possible[1].ability, Duration=10 })
        else
            abilityLabel:Set("Add more evidence to narrow down.")
            Rayfield:Notify({ Title="👻 "..(#possible).." possible ghosts", Content=table.concat(names,"\n"), Duration=8 })
        end
    end })

EvidTab:CreateButton({ Name="🗑️ Reset Checklist",
    Callback=function()
        for ev in pairs(EvidenceFound) do EvidenceFound[ev]=false end
        deductLabel:Set("Possible: — (mark evidence above)"); abilityLabel:Set("Ability: —")
        Rayfield:Notify({ Title="Checklist Reset", Content="All evidence cleared.", Duration=2 })
    end })

-- AUTO PLAY
EvidTab:CreateSection("🤖 Auto Play")
EvidTab:CreateLabel("Reads tool VALUES directly: Thermometer temp,")
EvidTab:CreateLabel("EMFReader level, SpiritBox response, Camera orb,")
EvidTab:CreateLabel("Blacklight marks, SpiritBook writing and more.")

local apStatusLabel = EvidTab:CreateLabel("🤖 Auto Play: Off")
local apResultLabel  = EvidTab:CreateLabel("Result: —")

EvidTab:CreateToggle({ Name="🤖 Auto Play (auto evidence detection)", CurrentValue=false, Flag="AutoPlay",
    Callback=function(val)
        State.AutoPlay = val
        if val then
            for ev in pairs(EvidenceFound) do EvidenceFound[ev]=false end
            apAlreadyIdentified = false
            pcall(function() apStatusLabel:Set("🤖 Auto Play: Running...") end)
            pcall(function() apResultLabel:Set("Scanning for evidence...") end)
            Rayfield:Notify({ Title="🤖 Auto Play ON",
                Content="Scanning tool values every 2 seconds.\nEvidence detected automatically.", Duration=5, Image=4483362458 })
            task.spawn(function()
                while State.AutoPlay do
                    task.wait(2)
                    if State.AutoPlay then pcall(autoPlayTick, apStatusLabel, apResultLabel) end
                end
                pcall(function() apStatusLabel:Set("🤖 Auto Play: Off") end)
                pcall(function() apResultLabel:Set("Result: —") end)
            end)
        else
            Rayfield:Notify({ Title="🤖 Auto Play OFF", Content="Evidence scanning stopped.", Duration=3, Image=4483362458 })
        end
    end })

EvidTab:CreateButton({ Name="🔍 Scan Once (manual)",
    Callback=function()
        Rayfield:Notify({ Title="🤖 Scanning...", Content="Scanning now...", Duration=2 })
        task.spawn(function() task.wait(0.1); pcall(autoPlayTick, apStatusLabel, apResultLabel) end)
    end })

EvidTab:CreateButton({ Name="🗑️ Reset Auto Play",
    Callback=function()
        State.AutoPlay = false
        for ev in pairs(EvidenceFound) do EvidenceFound[ev]=false end
        apAlreadyIdentified = false
        pcall(function() apStatusLabel:Set("🤖 Auto Play: Off") end)
        pcall(function() apResultLabel:Set("Result: —") end)
        Rayfield:Notify({ Title="Auto Play Reset", Content="All evidence cleared.", Duration=2 })
    end })

EvidTab:CreateSection("Ghost Encyclopedia")

EvidTab:CreateButton({ Name="📖 Ghosts 1–11",
    Callback=function()
        local lines={}
        for i=1,11 do local g=GHOST_DATA[i]; table.insert(lines, g.name..": "..table.concat(g.evidence," | ")) end
        Rayfield:Notify({ Title="👻 Ghosts 1–11", Content=table.concat(lines,"\n"), Duration=15 })
    end })

EvidTab:CreateButton({ Name="📖 Ghosts 12–23",
    Callback=function()
        local lines={}
        for i=12,#GHOST_DATA do local g=GHOST_DATA[i]; table.insert(lines, g.name..": "..table.concat(g.evidence," | ")) end
        Rayfield:Notify({ Title="👻 Ghosts 12–23", Content=table.concat(lines,"\n"), Duration=15 })
    end })

EvidTab:CreateButton({ Name="🔎 Lookup Ghost Ability",
    Callback=function()
        local gType = getGhostType()
        for _, g in ipairs(GHOST_DATA) do
            if g.name:lower() == gType:lower() then
                Rayfield:Notify({ Title="📖 "..g.name, Content=table.concat(g.evidence," | ").."\n\n"..g.ability, Duration=10 }); return
            end
        end
        Rayfield:Notify({ Title="Lookup", Content="'"..gType.."' not in database.", Duration=4 })
    end })

-- TAB 3 — ESP
local ESPTab = Window:CreateTab("🔮 ESP", 4483362458)
ESPTab:CreateSection("ESP Toggles")
ESPTab:CreateToggle({ Name="👻 Ghost ESP", CurrentValue=false, Flag="GhostESP",
    Callback=function(val) State.GhostESP=val
        if val then pcall(scanGhostESP); startESPLoop("GhostESP",scanGhostESP,1)
        else clearESPByCategory("GHOST") end end })
ESPTab:CreateToggle({ Name="🔍 Evidence ESP", CurrentValue=false, Flag="EvidenceESP",
    Callback=function(val) State.EvidenceESP=val
        if val then pcall(scanEvidenceESP); startESPLoop("EvidenceESP",scanEvidenceESP,2)
        else clearESPByCategory("Evidence") end end })
ESPTab:CreateToggle({ Name="🖐 Fingerprint / UV ESP", CurrentValue=false, Flag="FingerprintESP",
    Callback=function(val) State.FingerprintESP=val
        if val then pcall(scanFingerprintESP); startESPLoop("FingerprintESP",scanFingerprintESP,2)
        else clearESPByCategory("print") end end })
ESPTab:CreateToggle({ Name="📦 Equipment / Item ESP", CurrentValue=false, Flag="ItemESP",
    Callback=function(val) State.ItemESP=val
        if val then pcall(scanItemESP); startESPLoop("ItemESP",scanItemESP,2) end end })
ESPTab:CreateButton({ Name="🗑️ Clear All ESP",
    Callback=function() clearAllESP(); Rayfield:Notify({Title="Astra Hub",Content="All ESP cleared!",Duration=2}) end })
ESPTab:CreateSection("ESP Appearance")
ESPTab:CreateSlider({ Name="Fill Transparency", Range={0,10}, Increment=1, Suffix="/10", CurrentValue=4, Flag="ESPFillTransp",
    Callback=function(val) local t=val/10; for _,d in pairs(ESPObjects) do if d.highlight then d.highlight.FillTransparency=t end end end })
ESPTab:CreateSlider({ Name="Outline Transparency", Range={0,10}, Increment=1, Suffix="/10", CurrentValue=0, Flag="ESPOutlineTransp",
    Callback=function(val) local t=val/10; for _,d in pairs(ESPObjects) do if d.highlight then d.highlight.OutlineTransparency=t end end end })

-- TAB 4 — PLAYER
local PlayerTab = Window:CreateTab("⚡ Player", 4483362458)
PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({ Name="Walk Speed", Range={8,120}, Increment=2, Suffix=" studs/s", CurrentValue=16, Flag="WalkSpeed",
    Callback=function(val) local c=LocalPlayer.Character; if c then local h=c:FindFirstChildWhichIsA("Humanoid"); if h then h.WalkSpeed=val end end end })
PlayerTab:CreateSlider({ Name="Jump Power", Range={50,300}, Increment=10, Suffix="", CurrentValue=50, Flag="JumpPower",
    Callback=function(val) local c=LocalPlayer.Character; if c then local h=c:FindFirstChildWhichIsA("Humanoid")
        if h then h.UseJumpPower=true; h.JumpPower=val end end end })
PlayerTab:CreateToggle({ Name="✈️ Fly", CurrentValue=false, Flag="FlyToggle",
    Callback=function(val) State.Fly=val
        if val then
            local c=LocalPlayer.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); if not root then return end
            FlyBodyVel=Instance.new("BodyVelocity"); FlyBodyVel.Velocity=Vector3.zero
            FlyBodyVel.MaxForce=Vector3.new(1e5,1e5,1e5); FlyBodyVel.Parent=root
            FlyBodyGyro=Instance.new("BodyGyro"); FlyBodyGyro.MaxTorque=Vector3.new(1e5,1e5,1e5)
            FlyBodyGyro.P=9e4; FlyBodyGyro.CFrame=root.CFrame; FlyBodyGyro.Parent=root
            RunService:BindToRenderStep("AstraFly",200,function()
                if not State.Fly then
                    if FlyBodyVel then pcall(function() FlyBodyVel:Destroy() end); FlyBodyVel=nil end
                    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end); FlyBodyGyro=nil end
                    RunService:UnbindFromRenderStep("AstraFly"); return
                end
                local speed=32; local dir=Vector3.zero; local UIS=UserInputService
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then speed=70 end
                FlyBodyVel.Velocity=dir.Magnitude>0 and dir.Unit*speed or Vector3.zero
                FlyBodyGyro.CFrame=Camera.CFrame
            end)
        else State.Fly=false end end })
PlayerTab:CreateToggle({ Name="🚶 NoClip", CurrentValue=false, Flag="NoClipToggle",
    Callback=function(val) State.NoClip=val
        if val then
            RunService:BindToRenderStep("AstraNoClip",300,function()
                if not State.NoClip then
                    RunService:UnbindFromRenderStep("AstraNoClip")
                    local c=LocalPlayer.Character
                    if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
                    return
                end
                local c=LocalPlayer.Character
                if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
            end)
        end end })
PlayerTab:CreateSection("Survival")
PlayerTab:CreateToggle({ Name="♾️ Infinite Stamina / Energy", CurrentValue=false, Flag="InfStamina",
    Callback=function(val) State.InfStamina=val
        if val then task.spawn(function()
            while State.InfStamina do task.wait(0.05)
                local c=LocalPlayer.Character
                local eN={"Energy","Stamina","Sanity","Mental","Fear","SP","Endurance","Breath"}
                if c then
                    local h=c:FindFirstChildWhichIsA("Humanoid")
                    if h then for _,n in ipairs(eN) do if h:GetAttribute(n)~=nil then pcall(function() h:SetAttribute(n,100) end) end end end
                    for _,v in ipairs(c:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            for _,n in ipairs(eN) do if v.Name:lower():find(n:lower()) then pcall(function() v.Value=100 end); break end end
                        end
                    end
                end
                for _,n in ipairs(eN) do if LocalPlayer:GetAttribute(n)~=nil then pcall(function() LocalPlayer:SetAttribute(n,100) end) end end
            end
        end) end end })

-- TAB 5 — VISUALS
local VisualsTab = Window:CreateTab("🌟 Visuals", 4483362458)
VisualsTab:CreateSection("Lighting")
VisualsTab:CreateToggle({ Name="☀️ Fullbright", CurrentValue=false, Flag="Fullbright",
    Callback=function(val) State.Fullbright=val
        if val then
            OriginalLight.Brightness=Lighting.Brightness; OriginalLight.FogEnd=Lighting.FogEnd
            OriginalLight.FogStart=Lighting.FogStart; OriginalLight.ClockTime=Lighting.ClockTime
            OriginalLight.Ambient=Lighting.Ambient; OriginalLight.OutdoorAmbient=Lighting.OutdoorAmbient
            Lighting.Brightness=10; Lighting.FogEnd=1e9; Lighting.FogStart=1e9; Lighting.ClockTime=14
            Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
            for _,e in ipairs(Lighting:GetChildren()) do
                if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BlackAndWhiteEffect")
                or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end
            end
        else
            if OriginalLight.Brightness then
                Lighting.Brightness=OriginalLight.Brightness; Lighting.FogEnd=OriginalLight.FogEnd
                Lighting.FogStart=OriginalLight.FogStart; Lighting.ClockTime=OriginalLight.ClockTime
                Lighting.Ambient=OriginalLight.Ambient; Lighting.OutdoorAmbient=OriginalLight.OutdoorAmbient
            end
            for _,e in ipairs(Lighting:GetChildren()) do
                if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BlackAndWhiteEffect")
                or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=true end
            end
        end end })
VisualsTab:CreateSlider({ Name="Brightness Level", Range={1,20}, Increment=1, Suffix="x", CurrentValue=2, Flag="BrightnessLevel",
    Callback=function(val) Lighting.Brightness=val end })
VisualsTab:CreateToggle({ Name="🌫️ Remove Fog", CurrentValue=false, Flag="RemoveFog",
    Callback=function(val) State.RemoveFog=val
        if val then Lighting.FogEnd=1e9; Lighting.FogStart=1e9 else Lighting.FogEnd=1000; Lighting.FogStart=0 end end })
VisualsTab:CreateToggle({ Name="🎨 Remove Post-Processing Effects", CurrentValue=false, Flag="RemovePostFX",
    Callback=function(val) State.RemovePostFX=val
        for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("PostEffect") then e.Enabled=not val end end end })
VisualsTab:CreateSection("Camera")
VisualsTab:CreateSlider({ Name="Field of View", Range={70,120}, Increment=5, Suffix="°", CurrentValue=70, Flag="FOVSlider",
    Callback=function(val) Camera.FieldOfView=val end })

-- TAB 6 — HUNT
local HuntTab = Window:CreateTab("🏃 Hunt", 4483362458)
HuntTab:CreateSection("Hunt Detection")
HuntTab:CreateToggle({ Name="🔔 Hunt Warning Notification", CurrentValue=false, Flag="HuntWarning",
    Callback=function(val) State.HuntWarning=val
        if val then task.spawn(function()
            local wasH=false
            while State.HuntWarning do task.wait(0.2)
                local isH=detectHunt()
                if isH and not wasH then
                    Rayfield:Notify({Title="⚠️ HUNT STARTED!",Content="Ghost is hunting! Hide immediately!",Duration=6,Image=4483362458})
                    wasH=true
                elseif not isH then wasH=false end
            end
        end) end end })
HuntTab:CreateSection("🍆 Anti Sex")
HuntTab:CreateLabel("Auto-teleports you to safety the moment a hunt begins.")
HuntTab:CreateToggle({ Name="🍆 Anti Sex (Auto Hunt Escape)", CurrentValue=false, Flag="AntiSex",
    Callback=function(val) State.AntiSex=val
        if val then
            Rayfield:Notify({Title="🍆 Anti Sex ENABLED",Content="You are now protected.",Duration=4,Image=4483362458})
            task.spawn(function()
                local wasH=false
                while State.AntiSex do task.wait(0.15)
                    local isH=detectHunt()
                    if isH and not wasH then wasH=true; antiSexEscape()
                    elseif not isH then wasH=false end
                end
            end)
        else Rayfield:Notify({Title="🍆 Anti Sex DISABLED",Content="You're on your own now.",Duration=3,Image=4483362458}) end end })
HuntTab:CreateButton({ Name="🍆 Escape NOW (Manual)", Callback=function() antiSexEscape() end })
HuntTab:CreateSection("Teleportation")
HuntTab:CreateButton({ Name="🚪 Teleport to Spawn / Entrance",
    Callback=function()
        local root=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
        for _,name in ipairs({"SpawnLocation","Spawn","Entrance","Exit","LobbySpawn","Lobby"}) do
            local obj=workspace:FindFirstChild(name,true)
            if obj and obj:IsA("BasePart") then root.CFrame=obj.CFrame+Vector3.new(0,5,0)
                Rayfield:Notify({Title="Teleported",Content="→ "..name,Duration=2}); return end
        end
        Rayfield:Notify({Title="Astra Hub",Content="Spawn not found. Try NoClip.",Duration=3})
    end })
HuntTab:CreateButton({ Name="🚶 Teleport to Nearest Hiding Spot",
    Callback=function()
        local root=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
        local best,bestDist=nil,math.huge
        for _,name in ipairs({"Closet","Wardrobe","Cabinet","Locker","HidingSpot","Cupboard"}) do
            for _,obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(name:lower()) then
                    local d=(obj.Position-root.Position).Magnitude
                    if d<bestDist then bestDist=d; best=obj end
                end
            end
        end
        if best then root.CFrame=best.CFrame+Vector3.new(0,3,0)
            Rayfield:Notify({Title="Teleported",Content="→ Hiding spot ("..math.floor(bestDist).." studs)",Duration=3})
        else Rayfield:Notify({Title="Astra Hub",Content="No hiding spot found.",Duration=3}) end
    end })
HuntTab:CreateButton({ Name="💨 Teleport to Ghost Room",
    Callback=function()
        local root=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
        local ghost=findGhost()
        if ghost then
            local gp=ghost:IsA("BasePart") and ghost or ghost:FindFirstChildWhichIsA("BasePart",true)
            if gp then root.CFrame=gp.CFrame+Vector3.new(0,6,4)
                Rayfield:Notify({Title="Teleported",Content="→ Ghost Room",Duration=2}); return end
        end
        Rayfield:Notify({Title="Astra Hub",Content="Ghost not located.",Duration=3})
    end })

-- TAB 7 — MISC
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)
MiscTab:CreateSection("Anti-AFK")
MiscTab:CreateToggle({ Name="🎮 Anti-AFK", CurrentValue=false, Flag="AntiAFK",
    Callback=function(val) State.AntiAFK=val
        if val then LocalPlayer.Idled:Connect(function()
            if not State.AntiAFK then return end
            VirtualUser:Button2Down(Vector2.zero,workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.zero,workspace.CurrentCamera.CFrame)
        end) end end })
MiscTab:CreateSection("Server / Character")
MiscTab:CreateButton({ Name="🔄 Rejoin Server",
    Callback=function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end })
MiscTab:CreateButton({ Name="🩹 Reset Character",
    Callback=function()
        local c=LocalPlayer.Character; if c then local h=c:FindFirstChildWhichIsA("Humanoid"); if h then h.Health=0 end end
    end })
MiscTab:CreateSection("Info")
MiscTab:CreateLabel("Astra Hub v1.0.0 | Demonology Edition")
MiscTab:CreateLabel("UI: Rayfield Library by Sirius")
MiscTab:CreateLabel("Ghost DB: 23 types | Evidence: 8 types")

-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    Character=char; Humanoid=char:WaitForChild("Humanoid"); RootPart=char:WaitForChild("HumanoidRootPart")
    local s=Rayfield:GetFlag("WalkSpeed"); if s and s~=16 then Humanoid.WalkSpeed=s end
end)

Rayfield:Notify({
    Title   = "✨ Astra Hub v1.0.0",
    Content = "Loaded! 23 ghosts · 8 evidence types\n🤖 Auto Play in Evidence tab",
    Duration = 6, Image = 4483362458,
})
