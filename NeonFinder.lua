-- STEAL AN EGG | NEON FINDER V2
-- Локальный поиск + интерфейс базы находок

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

pcall(function()
    local old = CoreGui:FindFirstChild("NeonFinder")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NeonFinder"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local cyan = Color3.fromRGB(0, 220, 255)
local dark = Color3.fromRGB(7, 12, 23)
local panel = Color3.fromRGB(15, 25, 42)

local main = make("Frame", {
    Size = UDim2.new(0, 320, 0, 410),
    Position = UDim2.new(0.5, -160, 0.5, -205),
    BackgroundColor3 = dark,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 14)}, main)
make("UIStroke", {Color = cyan, Thickness = 2}, main)

local title = make("TextLabel", {
    Size = UDim2.new(1, -105, 0, 45),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "✦ NEON FINDER",
    TextColor3 = cyan,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

local mini = make("TextButton", {
    Size = UDim2.new(0, 35, 0, 32),
    Position = UDim2.new(1, -82, 0, 6),
    Text = "−",
    TextSize = 24,
    TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(0, 110, 160)
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, mini)

local close = make("TextButton", {
    Size = UDim2.new(0, 35, 0, 32),
    Position = UDim2.new(1, -42, 0, 6),
    Text = "×",
    TextSize = 23,
    TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(150, 35, 55)
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, close)

local restore = make("TextButton", {
    Size = UDim2.new(0, 65, 0, 40),
    Position = UDim2.new(0, 12, 0.5, -20),
    Text = "✦ NF",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = cyan,
    BackgroundColor3 = dark,
    Visible = false
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, restore)
make("UIStroke", {Color = cyan, Thickness = 2}, restore)

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
    main.Visible = true
    restore.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local status = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 28),
    Position = UDim2.new(0, 10, 0, 45),
    BackgroundTransparency = 1,
    Text = "Готов к поиску",
    TextColor3 = Color3.fromRGB(190, 210, 225),
    TextSize = 13,
    Font = Enum.Font.Gotham
}, main)

local tab1 = make("TextButton", {
    Size = UDim2.new(0.5, -14, 0, 35),
    Position = UDim2.new(0, 10, 0, 76),
    Text = "🐾 ЖИВОТНЫЕ",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = Color3.fromRGB(0, 115, 165)
}, main)

local tab2 = make("TextButton", {
    Size = UDim2.new(0.5, -14, 0, 35),
    Position = UDim2.new(0.5, 4, 0, 76),
    Text = "🌐 СЕРВЕРЫ",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = panel
}, main)

local scan = make("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 118),
    Text = "⌕  НАЧАТЬ ПОИСК",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = Color3.fromRGB(0, 130, 190)
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, scan)

local list = make("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -170),
    Position = UDim2.new(0, 10, 0, 165),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0)
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, list)

local layout = make("UIListLayout", {
    Padding = UDim.new(0, 7)
}, list)

local known = {
    "Royal Skywhale", "Royal Sky Whale",
    "Archangel", "World Burner", "Aetherion",
    "Nightflame", "Kitsune", "Unicorn"
}

local function clear()
    for _, v in ipairs(list:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end

local function message(txt)
    clear()
    make("TextLabel", {
        Size = UDim2.new(1, -12, 0, 100),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = cyan,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextWrapped = true
    }, list)
end

local function addPet(name, image)
    local card = make("Frame", {
        Size = UDim2.new(1, -8, 0, 66),
        BackgroundColor3 = Color3.fromRGB(25, 40, 60)
    }, list)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, card)

    make("ImageLabel", {
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(0, 6, 0, 7),
        BackgroundColor3 = dark,
        Image = image or ""
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 65, 0, 0),
        BackgroundTransparency = 1,
        Text = "✦ " .. name .. "\nНайдено в текущем сервере",
        TextColor3 = cyan,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)
end

local currentTab = "pets"

tab1.MouseButton1Click:Connect(function()
    currentTab = "pets"
    tab1.BackgroundColor3 = Color3.fromRGB(0, 115, 165)
    tab2.BackgroundColor3 = panel
    scan.Visible = true
    message("Нажми «НАЧАТЬ ПОИСК», чтобы проверить текущий сервер.")
    status.Text = "Поиск животных"
end)

tab2.MouseButton1Click:Connect(function()
    currentTab = "servers"
    tab2.BackgroundColor3 = Color3.fromRGB(0, 115, 165)
    tab1.BackgroundColor3 = panel
    scan.Visible = false
    message("БАЗА ДРУГИХ СЕРВЕРОВ\n\nПока нет подключённой базы находок.\n\nСписок серверов Roblox не раскрывает животных внутри них.\n\nЗдесь будут появляться реальные сообщения игроков с названием животного и ID сервера.")
    status.Text = "Ожидание данных о находках"
end)

local busy = false

scan.MouseButton1Click:Connect(function()
    if busy or currentTab ~= "pets" then return end
    busy = true
    clear()
    status.Text = "Сканирование текущего сервера..."
    local found = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, name in ipairs(known) do
                if string.find(string.lower(obj.Name), string.lower(name), 1, true) then
                    if not found[obj] then
                        found[obj] = true
                        local image
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

    if count == 0 then
        message("Совпадений нет.\nЭто не доказывает, что редких животных нет: их названия могут отличаться или модели могут быть скрыты.")
    end

    status.Text = "Найдено совпадений: " .. count
    busy = false
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end)

message("Готов к поиску!\nНажми кнопку «НАЧАТЬ ПОИСК».")
