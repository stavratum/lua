if not game:IsLoaded() then game.Loaded:Wait() end

local LP = game:GetService("Players").LocalPlayer
local Mouse = LP:GetMouse()
local X = Mouse.ViewSizeX
local Y = Mouse.ViewSizeY

local Color3 = Color3.fromRGB
local Instance = Instance.new
local Vector2 = Vector2.new
local UDim2 = UDim2.new
local UDim = UDim.new

local Objects = {}

local Colors = {
    Color3(22, 22, 22),
    Color3(18, 18, 18),
    Color3(255, 90, 255),

    WHITE = Color3(233, 233, 233)
}

local OFFSET_Y = 6
local FOLDER_SIZE = 190
local FONT = Enum.Font.Jura

local UI = Instance("ScreenGui")
UI.Name = tostring(math.random()):sub(3, -1)
local folders = Instance("Folder", UI)
folders.Name = "Folders"

xpcall(
    function() ui.Parent = game:GetService"CoreGui" end,
    function() ui.Parent = LP.PlayerGui end
)

--

local function insert(parent, instance)
    parent.Size += UDim2(0, 0, 0, instance.Size.Y.Offset + OFFSET_Y)
    instance.Parent = parent
    instance.AnchorPoint = Vector2(0.5, 0)
    instance.Position = UDim2(0.5, 0, 0, parent.Size.Y.Offset - instance.Size.Y.Offset - OFFSET_Y)

    table.insert(Objects[parent].Children, instance)
end

--

local function makeFolder(text)
    local instance = Instance("Frame")
    instance.BackgroundColor3 = Colors[1]
    instance.BorderSizePixel = 0
    instance.Size = UDim2(0, FOLDER_SIZE, 0, 24 + OFFSET_Y)
    instance.Position = UDim2(0, X / 16 + FOLDER_SIZE * 2 * #folders:GetChildren(), 0, 0)
    instance.Draggable = true
    instance.Active = true
    instance.Selectable = true

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0, 3)
    uiCorner.Parent = instance

    local textLabel = Instance("TextLabel")
    textLabel.BackgroundColor3 = Colors[1]
    textLabel.BorderSizePixel = 0
    textLabel.TextColor3 = Colors.WHITE
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = string.upper(text or "TextLabel")
    textLabel.Size = UDim2(0, 190, 0, 24)
    textLabel.Position = UDim2(0, 0, 0, 0)
    textLabel.Parent = instance

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0, 3)
    uiCorner.Parent = instance
    
    local object = {}
    object.Instance = instance
    object.Class = "Folder"
    object.Children = {}
    
    Objects[instance] = object

    return object
end

local function makeSection(...)
    local instance = Instance("TextButton")
    instance.BackgroundColor3 = Colors[2]
    instance.BorderSizePixel = 0
    instance.TextColor3 = Colors.WHITE
    instance.TextScaled = true
    instance.Font = FONT
    instance.Text = ...
    instance.Size = UDim2(0, FOLDER_SIZE - 10, 0, 21)
    instance.Position = UDim2(0, 0, 0, 0)

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0.15, 0)
    uiCorner.Parent = instance

    local frame = Instance("Frame")
    frame.BackgroundColor3 = Colors[3]
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2(0.5, 0)
    frame.Size = UDim2(0, FOLDER_SIZE - 10 - 2, 0, 1)
    frame.Position = UDim2(0.5, 0, 0, 1)
    frame.Parent = instance

    return instance
end

local function makeButton(...)
    local instance = Instance("TextButton")
    instance.BackgroundColor3 = Colors[2]
    instance.BorderSizePixel = 0
    instance.TextColor3 = Colors.WHITE
    instance.TextScaled = true
    instance.Font = FONT
    instance.Text = ...
    instance.Size = UDim2(0, FOLDER_SIZE - 14, 0, 20)
    instance.Position = UDim2(0, 0, 0, 0)

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0.15, 0)
    uiCorner.Parent = instance

    local object = {}
    object.Instance = instance
    object.Class = "Button"

    Objects[instance] = object

    return object
end

local function makeToggle(...)
    local instance = Instance("TextButton")
    instance.BackgroundColor3 = Colors[2]
    instance.BorderSizePixel = 0
    instance.TextColor3 = Colors.WHITE
    instance.TextScaled = true
    instance.Font = FONT
    instance.Text = ...
    instance.Size = UDim2(0, FOLDER_SIZE - 14, 0, 20)
    instance.Position = UDim2(0, 0, 0, 0)

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0.15, 0)
    uiCorner.Parent = instance

    local frame = Instance("Frame")
    frame.BackgroundColor3 = Colors[3]
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2(0.5, 0.5)
    frame.Size = UDim2(0, FOLDER_SIZE - 15, 0, 1)
    frame.Position = UDim2(0.5, 0, 1, -1)
    frame.Parent = instance

    local object = {}
    object.Instance = instance
    object.Class = "Toggle"
    object.Value = false

    instance.MouseButton1Click:Connect(
        function()
            local state = not frame.Visible
            
            frame.Visible = state
            object.Value = state
        end
    )

    Objects[instance] = object

    return object
end

local function makeSlider(text, parameters)
    local instance = Instance("TextButton")
    instance.BackgroundColor3 = Colors[2]
    instance.BorderSizePixel = 0
    instance.TextColor3 = Colors.WHITE
    instance.TextScaled = true
    instance.Font = FONT
    instance.Text = text
    instance.Size = UDim2(0, FOLDER_SIZE - 14, 0, 20)
    instance.Position = UDim2(0, 0, 0, 0)

    local uiCorner = Instance("UICorner")
    uiCorner.CornerRadius = UDim(0.15, 0)
    uiCorner.Parent = instance

    local frame = Instance("Frame")
    frame.BackgroundColor3 = Colors[3]
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2(0.5, 0.5)
    frame.Size = UDim2(0, FOLDER_SIZE - 15, 0, 1)
    frame.Position = UDim2(0.5, 0, 1, -1)
    frame.Parent = instance

    local object = {}
    object.Instance = instance
    object.Class = "Slider"
    object.Value = parameters.Value or 0

    instance.MouseButton1Click:Connect(
        function()
            frame.Visible = state
            instance.Text = text .. "["..object.Value.."]"
        end
    )

    Objects[instance] = object

    return instance
end

local function getFunctions(table)
    function table:Destroy()
        self.instance:Destroy()
        Objects[self.instance] = nil
    end

    function table:AddButton(text)
        local button = makeButton(text)
        insert(self.instance, button.instance)
        table.insert(self.Children, button)

        return button
    end

    function table:AddToggle(text)
        local toggle = makeToggle(text)
        insert(self.instance, toggle.instance)
        table.insert(self.Children, toggle)

        return toggle
    end
    
    return table
end

return {
    Base = UI,
    Colors = Colors,
    Objects = Objects,
    
    MakeFolder = function(text)
        local Object = makeFolder(text)
        Object.Instance.Parent = folders

        return getFunctions(Object)
    end
}
