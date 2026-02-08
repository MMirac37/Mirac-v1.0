-- [[ MİRAC MENU V1.0- DELTA]] --

-- 1. INFO BOLUMUNU BURADAN DUZENLE
local INFO_METNI = [[
DEVLOPER: MİRAC
VERSİON: V1.0
SITUATION: AKTIF

ACIKLAMALAR:
- Fly: Kameranın baktığı yöne uçar.
- Aim Bot: En yakındaki rakibe kilitlenir.
- Karakter: Hız ve TP ayarları buradadır.
- Kamera: Free Cam özelliği buradadır.

miracberk56@gmail.com 

]]

-- 2. GEREKLI SERVISLER
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- 3. TEMIZLIK (Eski panel varsa siler)
if player.PlayerGui:FindFirstChild("GeminiUltimate_Final") then 
    player.PlayerGui.GeminiUltimate_Final:Destroy() 
end

local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "GeminiUltimate_Final"
screenGui.ResetOnSpawn = false

-- 4. DURUM DEGISKENLERI
local states = {fly = false, aim = false, esp = false, freecam = false, speed = false}
local bv, bg

-- 5. ANA CERCEVE
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 480, 0, 320)
main.Position = UDim2.new(0.5, -240, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- 6. UST BAR (Baslık ve Kontroller)
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Text = "  MİRAC MENU V1.0 | DELTA "
title.Size = UDim2.new(0.6, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- [X] KAPATMA
local close = Instance.new("TextButton", topBar)
close.Text = "X"
close.Size = UDim2.new(0, 40, 0, 30)
close.Position = UDim2.new(1, -45, 0.5, -15)
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- [-] KUCULTME
local isMinimized = false
local minBtn = Instance.new("TextButton", topBar)
minBtn.Text = "-"
minBtn.Size = UDim2.new(0, 40, 0, 30)
minBtn.Position = UDim2.new(1, -90, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn)

-- 7. YAN MENU VE ICERIK ALANI
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 130, 1, -50)
sideBar.Position = UDim2.new(0, 5, 0, 45)
sideBar.BackgroundTransparency = 1

local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -145, 1, -55)
content.Position = UDim2.new(0, 140, 0, 45)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 0
local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 8)

-- KUCULTME FONKSIYONU
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    sideBar.Visible = not isMinimized
    content.Visible = not isMinimized
    main:TweenSize(isMinimized and UDim2.new(0, 480, 0, 40) or UDim2.new(0, 480, 0, 320), "Out", "Quart", 0.3, true)
end)

-- ICERIK TEMIZLEME
local function clearContent()
    for _, v in pairs(content:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end
    end
end

-- 8. UI YARDIMCILARI (Toggle & Button)
local function addToggle(name, statusKey, callback)
    local f = Instance.new("Frame", content)
    f.Size = UDim2.new(1, -10, 0, 40)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", f)
    
    local l = Instance.new("TextLabel", f)
    l.Text = "  "..name
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.35, 0, 0.7, 0)
    b.Position = UDim2.new(0.6, 0, 0.15, 0)
    b.Text = states[statusKey] and "ON" or "OFF"
    b.BackgroundColor3 = states[statusKey] and Color3.new(0, 0.6, 0) or Color3.new(0.2, 0.2, 0.2)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        states[statusKey] = not states[statusKey]
        b.Text = states[statusKey] and "ON" or "OFF"
        b.BackgroundColor3 = states[statusKey] and Color3.new(0, 0.6, 0) or Color3.new(0.2, 0.2, 0.2)
        callback(states[statusKey])
    end)
end

-- 9. SEKMELERI OLUSTUR
local function createTab(name, pos, func)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        clearContent()
        func()
    end)
end

-- 10. SEKME ICERIKLERI
createTab("Hileler", 0, function()
    addToggle("Fly (Uçma)", "fly", function(val)
        local char = player.Character
        if val and char and char:FindFirstChild("HumanoidRootPart") then
            bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bg = Instance.new("BodyGyro", char.HumanoidRootPart)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end)
    addToggle("Aim Bot", "aim", function() end)
    addToggle("ESP (Wallhack)", "esp", function(val)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = p.Character:FindFirstChild("GeminiESP")
                if val then
                    if not h then Instance.new("Highlight", p.Character).Name = "GeminiESP" end
                elseif h then h:Destroy() end
            end
        end
    end)
end)

createTab("Karakter", 40, function()
    addToggle("Süper Hız", "speed", function(val)
        if player.Character:FindFirstChild("Humanoid") then 
            player.Character.Humanoid.WalkSpeed = val and 100 or 16 
        end
    end)
    
    local tpBtn = Instance.new("TextButton", content)
    tpBtn.Size = UDim2.new(1, -10, 0, 40)
    tpBtn.Text = "Mouse TP (Işınlan)"
    tpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", tpBtn)
    tpBtn.MouseButton1Click:Connect(function() player.Character:MoveTo(mouse.Hit.Position) end)
end)

createTab("Info", 80, function()
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, -10, 1, 0)
    l.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Text = INFO_METNI
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", l)
end)

createTab("Kamera", 120, function()
    addToggle("Free Cam", "freecam", function(val)
        camera.CameraType = val and Enum.CameraType.Scriptable or Enum.CameraType.Custom
    end)
end)

-- 11. DONGUSEL MANTIK (Fly & Aim)
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if states.fly and bv and char and char:FindFirstChild("HumanoidRootPart") then
        bv.Velocity = camera.CFrame.LookVector * 100
        bg.CFrame = camera.CFrame
    end
    if states.aim then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - char.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d target = p.Character.Head end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
end)

print("Gemini Ultimate V2.5 Yuklendi! Keyifli testler.")
