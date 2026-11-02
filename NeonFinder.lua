-- STEAL AN EGG | NEON FINDER
-- Локальный поиск существ в текущем сервере

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

pcall(function()
    local old = CoreGui:FindFirstChild("NeonFinder")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NeonFinder"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 310, 0, 390)
main.Position = UDim2.new(0.5, -155, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(8, 13, 24)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ NEON FINDER"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -42, 0, 5)
close.Text = "×"
close.TextSize = 25
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(150, 35, 55)
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 28)
status.Position = UDim2.new(0, 10, 0, 48)
status.BackgroundTransparency = 1
status.Text = "Готов к поиску"
status.TextColor3 = Color3.fromRGB(180, 200, 220)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.Parent = main

local scan = Instance.new("TextButton")
scan.Size = UDim2.new(1, -20, 0, 42)
scan.Position = UDim2.new(0, 10, 0, 80)
scan.Text = "⌕  НАЧАТЬ ПОИСК"
scan.TextColor3 = Color3.new(1,1,1)
scan.TextSize = 16
scan.Font = Enum.Font.GothamBold
scan.BackgroundColor3 = Color3.fromRGB(0, 130, 190)
scan.Parent = main
Instance.new("UICorner", scan).CornerRadius = UDim.new(0, 9)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -140)
list.Position = UDim2.new(0, 10, 0, 132)
list.BackgroundColor3 = Color3.fromRGB(14, 22, 36)
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main
Instance.new("UICorner", list).CornerRadius = UDim.new(0, 9)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = list

local known = {
    "Royal Skywhale", "Royal Sky Whale",
    "Archangel", "World Burner", "Aetherion",
    "Nightflame", "Kitsune", "Unicorn"
}

local function clearList()
    for _, v in ipairs(list:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

local function addPet(name, image)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 65)
    card.BackgroundColor3 = Color3.fromRGB(25, 38, 58)
    card.Parent = list
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local picture = Instance.new("ImageLabel")
    picture.Size = UDim2.new(0, 52, 0, 52)
    picture.Position = UDim2.new(0, 6, 0, 6)
    picture.BackgroundColor3 = Color3.fromRGB(10, 18, 30)
    picture.Image = image or ""
    picture.Parent = card
    Instance.new("UICorner", picture).CornerRadius = UDim.new(0, 7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -72, 1, 0)
    label.Position = UDim2.new(0, 66, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "✦ " .. name
    label.TextColor3 = Color3.fromRGB(0, 220, 255)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
end

local busy = false

scan.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    clearList()

    status.Text = "Сканирование текущего сервера..."
    local found = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, name in ipairs(known) do
                if string.find(string.lower(obj.Name), string.lower(name), 1, true) then
                    if not found[obj] then
                        found[obj] = true
                        local image = nil
                        for _, child in ipairs(obj:GetDescendants()) do
                            if child:IsA("Decal") or child:IsA("Texture") then
                                image = child.Texture
                                break
                            end
                        end
                        addPet(obj.Name, image)
                    end
                    break
                end
            end
        end
    end

    local count = 0
    for _ in pairs(found) do count = count + 1 end

    status.Text = "Найдено существ: " .. count
    if count == 0 then
        status.Text = "В текущем сервере совпадений нет"
    end

    task.wait(1)
    busy = false
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
