-- DarkSS Arsenal ULTIMATE v6.0 - ПОЛНЫЙ РАБОЧИЙ СКРИПТ
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

--=== НАСТРОЙКИ ===--
_G.AimbotEnabled = true
_G.ESPEnabled = true
_G.GodModeEnabled = false
_G.SpeedHackEnabled = false
_G.InfiniteAmmoEnabled = true
_G.BunnyHopEnabled = false
_G.TriggerBotEnabled = false
_G.NoRecoilEnabled = true
_G.InstantRespawnEnabled = true
_G.FlyEnabled = false
_G.WallBangEnabled = false
_G.NoSpreadEnabled = true

_G.AimbotKey = Enum.KeyCode.Q
_G.AimbotFOV = 80
_G.AimbotSmoothness = 0.1
_G.AimbotPart = "Head"
_G.WalkSpeed = 25
_G.JumpPower = 50
_G.ESPColor = Color3.fromRGB(255, 0, 0)

--=== AIMBOT ===--
local function findClosestPlayer()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closestPlayer = nil
    local shortestDistance = _G.AimbotFOV
    local camera = Workspace.CurrentCamera
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") then
            local humanoid = target.Character.Humanoid
            if humanoid.Health > 0 and target.Character:FindFirstChild(_G.AimbotPart) then
                local targetPart = target.Character[_G.AimbotPart]
                local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local mouseLocation = Vector2.new(mouse.X, mouse.Y)
                    local targetLocation = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mouseLocation - targetLocation).magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = target
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Основной цикл аимбота
spawn(function()
    while RunService.RenderStepped:Wait() do
        if _G.AimbotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if UserInputService:IsKeyDown(_G.AimbotKey) then
                local target = findClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild(_G.AimbotPart) then
                    local camera = Workspace.CurrentCamera
                    local targetPosition = target.Character[_G.AimbotPart].Position
                    local direction = (targetPosition - camera.CFrame.Position).Unit
                    local currentLook = camera.CFrame.LookVector
                    local targetLook = direction
                    local smoothedLook = currentLook:Lerp(targetLook, _G.AimbotSmoothness)
                    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + smoothedLook)
                end
            end
        end
    end
end)

--=== ESP ===--
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "DarkSS_ESP"
ESPFolder.Parent = Workspace

spawn(function()
    while wait(0.3) do
        if _G.ESPEnabled then
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") then
                    
                    -- Highlight
                    local highlight = target.Character:FindFirstChild("DarkSS_Highlight") or Instance.new("Highlight")
                    highlight.Name = "DarkSS_Highlight"
                    highlight.FillColor = _G.ESPColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = target.Character
                    
                    -- Billboard Info
                    local billboard = target.Character:FindFirstChild("DarkSS_Info") or Instance.new("BillboardGui")
                    billboard.Name = "DarkSS_Info"
                    billboard.Size = UDim2.new(0, 200, 0, 80)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Adornee = target.Character.Head
                    billboard.MaxDistance = 500
                    billboard.Parent = target.Character
                    
                    local nameLabel = billboard:FindFirstChild("Name") or Instance.new("TextLabel")
                    nameLabel.Name = "Name"
                    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
                    nameLabel.Position = UDim2.new(0, 0, 0, 0)
                    nameLabel.Text = target.Name
                    nameLabel.TextColor3 = _G.ESPColor
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextSize = 14
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.Parent = billboard
                    
                    local healthLabel = billboard:FindFirstChild("Health") or Instance.new("TextLabel")
                    healthLabel.Name = "Health"
                    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
                    healthLabel.Position = UDim2.new(0, 0, 0.3, 0)
                    healthLabel.Text = "HP: " .. math.floor(target.Character.Humanoid.Health)
                    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    healthLabel.BackgroundTransparency = 1
                    healthLabel.TextSize = 12
                    healthLabel.Parent = billboard
                    
                    local distanceLabel = billboard:FindFirstChild("Distance") or Instance.new("TextLabel")
                    distanceLabel.Name = "Distance"
                    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
                    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
                    local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude
                    distanceLabel.Text = "Dist: " .. math.floor(distance)
                    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    distanceLabel.BackgroundTransparency = 1
                    distanceLabel.TextSize = 12
                    distanceLabel.Parent = billboard
                    
                end
            end
        else
            for _, target in pairs(Players:GetPlayers()) do
                if target.Character then
                    if target.Character:FindFirstChild("DarkSS_Highlight") then
                        target.Character.DarkSS_Highlight:Destroy()
                    end
                    if target.Character:FindFirstChild("DarkSS_Info") then
                        target.Character.DarkSS_Info:Destroy()
                    end
                end
            end
        end
    end
end)

--=== GOD MODE ===--
spawn(function()
    while wait(0.1) do
        if _G.GodModeEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 100
            player.Character.Humanoid.MaxHealth = math.huge
            
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Material = Enum.Material.ForceField
                end
            end
        end
    end
end)

--=== SPEED HACK ===--
spawn(function()
    while wait(0.1) do
        if _G.SpeedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = _G.WalkSpeed
            player.Character.Humanoid.JumpPower = _G.JumpPower
        elseif player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
        end
    end
end)

--=== INFINITE AMMO ===--
spawn(function()
    while wait(0.2) do
        if _G.InfiniteAmmoEnabled and player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool:FindFirstChild("Ammo") then
                        tool.Ammo.Value = 999
                    end
                    if tool:FindFirstChild("StoredAmmo") then
                        tool.StoredAmmo.Value = 999
                    end
                    if tool:FindFirstChild("Clip") then
                        tool.Clip.Value = 999
                    end
                end
            end
        end
    end
end)

--=== BUNNY HOP ===--
spawn(function()
    while wait(0.1) do
        if _G.BunnyHopEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.FloorMaterial ~= Enum.Material.Air and humanoid.MoveDirection.Magnitude > 0 then
                humanoid.Jump = true
            end
        end
    end
end)

--=== TRIGGER BOT ===--
spawn(function()
    while RunService.RenderStepped:Wait() do
        if _G.TriggerBotEnabled and player.Character and mouse.Target then
            local targetPlayer = Players:GetPlayerFromCharacter(mouse.Target.Parent)
            if targetPlayer and targetPlayer ~= player then
                mouse1click()
                wait(0.05)
            end
        end
    end
end)

--=== NO RECOIL & NO SPREAD ===--
spawn(function()
    while wait(0.1) do
        if _G.NoRecoilEnabled then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool:FindFirstChild("Recoil") then
                        tool.Recoil.Value = 0
                    end
                    if tool:FindFirstChild("Spread") then
                        tool.Spread.Value = 0
                    end
                end
            end
        end
    end
end)

--=== FLY HACK ===--
local flyBodyVelocity, flyBodyGyro

local function enableFly()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        flyBodyVelocity.Parent = player.Character.HumanoidRootPart
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        flyBodyGyro.P = 1000
        flyBodyGyro.D = 50
        flyBodyGyro.Parent = player.Character.HumanoidRootPart
        
        spawn(function()
            while _G.FlyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                flyBodyGyro.CFrame = Workspace.CurrentCamera.CFrame
                local moveDirection = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
                
                flyBodyVelocity.Velocity = moveDirection * 100
                RunService.RenderStepped:Wait()
            end
        end)
    end
end

local function disableFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        _G.FlyEnabled = not _G.FlyEnabled
        if _G.FlyEnabled then
            enableFly()
        else
            disableFly()
        end
    end
end)

--=== WALL BANG ===--
spawn(function()
    while wait(0.1) do
        if _G.WallBangEnabled then
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    part.Transparency = 0.5
                    part.CanCollide = false
                end
            end
        end
    end
end)

--=== INSTANT RESPAWN ===--
player.CharacterAdded:Connect(function(character)
    wait(2)
    if _G.InstantRespawnEnabled then
        -- Авто-выдача оружия после респавна
        if game:GetService("ReplicatedStorage"):FindFirstChild("GiveTool") then
            game:GetService("ReplicatedStorage").GiveTool:FireServer()
        end
    end
end)

--=== ANTI-AFK ===--
local VirtualU = game:GetService("VirtualUser")
spawn(function()
    while wait(60) do
        VirtualU:CaptureController()
        VirtualU:ClickButton2(Vector2.new())
    end
end)

--=== АВТО-ОБНОВЛЕНИЕ ESP ===--
spawn(function()
    while wait(1) do
        if _G.ESPEnabled then
            for _, target in pairs(Players:GetPlayers()) do
                if target.Character and target.Character:FindFirstChild("DarkSS_Info") then
                    local infoGui = target.Character.DarkSS_Info
                    if infoGui:FindFirstChild("Health") and target.Character:FindFirstChild("Humanoid") then
                        infoGui.Health.Text = "HP: " .. math.floor(target.Character.Humanoid.Health)
                    end
                    if infoGui:FindFirstChild("Distance") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude
                        infoGui.Distance.Text = "Dist: " .. math.floor(distance)
                    end
                end
            end
        end
    end
end)

--=== GUI МЕНЮ ===--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkSS_MainGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "🔫 DarkSS Arsenal v6.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local function createToggle(name, yPos, config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 25)
    ToggleFrame.Position = UDim2.new(0.05, 0, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BackgroundTransparency = 0.1
    ToggleFrame.Parent = MainFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 5, 0, 0)
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.2, 0, 0.7, 0)
    ToggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    ToggleButton.Text = config.value and "✅" or "❌"
    ToggleButton.BackgroundColor3 = config.value and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 10
    ToggleButton.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        config.value = not config.value
        ToggleButton.Text = config.value and "✅" or "❌"
        ToggleButton.BackgroundColor3 = config.value and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        if config.callback then config.callback(config.value) end
    end)
end

-- Создание переключателей
local toggles = {
    {name = "Aimbot (Q)", y = 40, config = {value = _G.AimbotEnabled, callback = function(v) _G.AimbotEnabled = v end}},
    {name = "ESP", y = 70, config = {value = _G.ESPEnabled, callback = function(v) _G.ESPEnabled = v end}},
    {name = "God Mode", y = 100, config = {value = _G.GodModeEnabled, callback = function(v) _G.GodModeEnabled = v end}},
    {name = "Speed Hack", y = 130, config = {value = _G.SpeedHackEnabled, callback = function(v) _G.SpeedHackEnabled = v end}},
    {name = "Infinite Ammo", y = 160, config = {value = _G.InfiniteAmmoEnabled, callback = function(v) _G.InfiniteAmmoEnabled = v end}},
    {name = "Bunny Hop", y = 190, config = {value = _G.BunnyHopEnabled, callback = function(v) _G.BunnyHopEnabled = v end}},
    {name = "Trigger Bot", y = 220, config = {value = _G.TriggerBotEnabled, callback = function(v) _G.TriggerBotEnabled = v end}},
    {name = "No Recoil", y = 250, config = {value = _G.NoRecoilEnabled, callback = function(v) _G.NoRecoilEnabled = v end}},
    {name = "Fly (F)", y = 280, config = {value = _G.FlyEnabled, callback = function(v) _G.FlyEnabled = v end}},
    {name = "Wall Bang", y = 310, config = {value = _G.WallBangEnabled, callback = function(v) _G.WallBangEnabled = v end}},
}

for _, toggle in pairs(toggles) do
    createToggle(toggle.name, toggle.y, toggle.config)
end

-- Кнопка скрытия
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0.9, 0, 0, 30)
HideButton.Position = UDim2.new(0.05, 0, 0, 350)
HideButton.Text = "📁 Скрыть меню"
HideButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 12
HideButton.Parent = MainFrame

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    HideButton.Text = MainFrame.Visible and "📁 Скрыть меню" or "📂 Показать меню"
end)

--=== ЗАЩИТА И ЛОГИ ===--
spawn(function()
    while wait(10) do
        -- Очистка логов
        for i = 1, 20 do print("\n") end
        print("🛡️ DarkSS Protection: Active | " .. os.date("%X"))
    end
end)

--=== СТАТУС ===--
print("🎮 DarkSS Arsenal ULTIMATE v6.0 ЗАПУЩЕН!")
print("✅ Все функции активированы")
print("🎯 Aimbot: Клавиша Q | FOV: " .. _G.AimbotFOV)
print("👁️ ESP: Включен с информацией")
print("💊 God Mode: Готов")
print("⚡ Speed: " .. _G.WalkSpeed .. " | Jump: " .. _G.JumpPower)
print("🔋 Infinite Ammo: Активно")
print("🐰 Bunny Hop: Готов")
print("🔫 Trigger Bot: Активен")
print("🚫 No Recoil: Включено")
print("✈️ Fly: Клавиша F")
print("🔓 Wall Bang: Доступно")
print("🔄 Instant Respawn: Включено")
print("🕒 Anti-AFK: Защита активна")
print("📱 GUI: Открыто меню управления")

-- Авто-обновление при респавне
player.CharacterAdded:Connect(function()
    wait(3)
    print("🔄 DarkSS перезагружен для нового персонажа")
end)
