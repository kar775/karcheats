local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Утилита создания объектов
local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    return obj
end

-- === UI СТИЛЬ ===
local function AddCorners(frame)
    local cornerSize = UDim2.new(0, 3, 0, 3)
    local offsets = {
        UDim2.new(0, 0, 0, 0), -- TopLeft
        UDim2.new(1, -3, 0, 0), -- TopRight
        UDim2.new(0, 0, 1, -3), -- BottomLeft
        UDim2.new(1, -3, 1, -3) -- BottomRight
    }
    for _,pos in pairs(offsets) do
        local dot = Create("Frame", {
            Size = cornerSize,
            Position = pos,
            BackgroundColor3 = Color3.fromRGB(0, 170, 255),
            BorderColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 1,
            Parent = frame
        })
    end
end

-- Кнопка 🫩
local mainButton = Create("TextButton", {
    Text = "M", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 100, 0, 100),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.new(1, 1, 1),
    Parent = CoreGui, Draggable = true, Active = true, Selectable = true
})
AddCorners(mainButton)

-- Панель читов
local cheatPanel = Create("Frame", {
    Size = UDim2.new(0, 400, 0, 600), Position = UDim2.new(0, 200, 0, 100),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20), Visible = false, Parent = CoreGui,
    Active = true, Draggable = true, BorderSizePixel = 0
})
AddCorners(cheatPanel)

-- Панель настройки GUI
local settingsPanel = Create("Frame", {
    Size = UDim2.new(0, 400, 0, 600), Position = UDim2.new(0, 200, 0, 100),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20), Visible = false, Parent = CoreGui,
    Active = true, Draggable = true, BorderSizePixel = 0
})
AddCorners(settingsPanel)

-- === UI КОНТРОЛЫ ===
local function makeCheckbox(name, pos, default, callback)
    local box = Create("TextButton", {
        Size = UDim2.new(0, 200, 0, 30), Position = pos, Text = name .. (default and " [ON]" or " [OFF]"),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.new(1, 1, 1), Parent = cheatPanel
    })
    AddCorners(box)
    local state = default
    box.MouseButton1Click:Connect(function()
        state = not state
        box.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local function makeSlider(name, pos, min, max, default, callback)
    local frame = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 50), Position = pos, BackgroundTransparency = 1, Parent = cheatPanel
    })
    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20), Text = name .. ": " .. tostring(default),
        BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Parent = frame
    })
    local slider = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60), Text = "",
        AutoButtonColor = false, Parent = frame
    })
    AddCorners(slider)

    slider.MouseButton1Down:Connect(function()
        local con
        con = RunService.RenderStepped:Connect(function()
            local scale = math.clamp((Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor((min + (max - min) * scale) + 0.5)
            label.Text = name .. ": " .. tostring(value)
            callback(value)
        end)
        UIS.InputEnded:Wait()
        con:Disconnect()
    end)
end

-- Панель функций
local function createFunctionPanel()
    local panel = Create("Frame", {
        Size = UDim2.new(0, 400, 0, 600),
        Position = UDim2.new(0, 200, 0, 100),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Visible = true, Parent = CoreGui,
        Active = true, Draggable = true
    })
    AddCorners(panel)

    makeCheckbox("Aimbot", UDim2.new(0, 20, 0, 20), true, function(on)
        _G.AimbotEnabled = on
    end)

    makeSlider("Aimbot FOV", UDim2.new(0, 20, 0, 70), 0, 360, 90, function(v)
        _G.FOV = v
    end)

    makeSlider("Aimbot Дальность", UDim2.new(0, 20, 0, 130), 0, 2000, 500, function(v)
        _G.AimbotDistance = v
    end)
end

-- Обработчик кнопки 🫩 на клавишу M
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        cheatPanel.Visible = not cheatPanel.Visible
        mainButton.Text = cheatPanel.Visible and "M" or "🫩"
    end
end)

-- Переключение панели
local function switchPanel(panel)
    cheatPanel.Visible = (panel == "cheats")
    settingsPanel.Visible = (panel == "settings")
end

-- Настройка панели
createFunctionPanel()

-- Настройка Auto Run
local function setAutoRun(state)
    if state then
        -- Автозапуск скрипта
    end
end
makeCheckbox("Автозапуск", UDim2.new(0, 20, 0, 500), false, setAutoRun)