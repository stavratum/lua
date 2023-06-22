local UwUware = loadstring(game:HttpGet "https://raw.githubusercontent.com/OPENCUP/random-texts/main/ui.lua")()
local window = UwUware:CreateWindow("Monday Morning Misery")

window:AddToggle {
    text = "Toggle Autoplayer",
    flag = "IsAnimeFan",
    state = true
}

window:AddBind {
    key = Enum.KeyCode.Quote,
    text = "Close GUI",
    callback = function()
        UwUware:Close()
    end
}

window:AddButton {
    text = "Unload Script",
    callback = function()
        clear()

        UwUware.base:Destroy()
        UwUware = nil
    end
}

window:AddButton {
    text = "Copy Discord Invite",
    callback = function()
	      local code = game:HttpGet "https://stavratum.github.io/invite"
	      local invite = "discord.gg" .. "/" .. code

        setclipboard(invite)
    end
}

if not game:IsLoaded() then game.Loaded:Wait() end

local replicatedstorage = game:GetService "ReplicatedStorage"
local manager = game:GetService "VirtualInputManager"
local runservice = game:GetService "RunService"
local players = game:GetService "Players"

local options = getrenv()._G.PlayerData.Options
local flags = UwUware.flags

local playertype = {"Left", "Right"}
local connections = { }
local codes = {
    [9] = {"Left", "Down", "Up", "Right", "Space", "Left2", "Down2", "Up2", "Right2"},
    [8] = {"Left", "Down", "Up", "Right", "Left2", "Down2", "Up2", "Right2"},
    [7] = {"Left", "Up", "Right", "Space", "Left2", "Down", "Right2"},
    [6] = {"Left", "Up", "Right", "Left2", "Down", "Right2"},
    [5] = {"Left", "Down", "Space", "Up", "Right"},
    [4] = {"Left", "Down", "Up", "Right"}
}

function main()
    local match = getMatch()
    if not match then return end
    
    repeat wait(1) until rawget(match, 'Songs')

    local side = playertype[match.PlayerType]
    local arrowGui = match.ArrowGui

    local sideFrame = arrowGui[side]
    local container = sideFrame.MainArrowContainer
    local longNotes = sideFrame.LongNotes
    local notes = sideFrame.Notes

    local maxArrows = match.MaxArrows
    local codes = codes [ maxArrows ]
    local controls = maxArrows < 5 and options
        or options.ExtraKeySettings [tostring (maxArrows)]

    container = sort(container)
    longNotes = sort(longNotes)
    notes = sort(notes)
	
    for index, holder in ipairs(notes) do
        local name = codes[index]
        local longNote = longNotes[index]
        local fakeNote = container[index]
        local keycode = controls[name .. "Key"]
        local offset = 10 * maxArrows

        table.insert(connections,
            holder.ChildAdded:Connect(function(note)
                while (fakeNote.AbsolutePosition - note.AbsolutePosition).Magnitude >= offset do
                    runservice.RenderStepped:Wait()
                end
                
                if not flags.IsAnimeFan then return end
                manager:SendKeyEvent(true, keycode, false, nil)

                if #longNote:GetChildren() == 0 then
                    manager:SendKeyEvent(false, keycode, false, nil)
                end
            end)
        )
    end
	
    for index, holder in ipairs(longNotes) do
        local name = codes[index]
        local keycode = controls[name .. "Key"]

        table.insert(connections,
            holder.ChildRemoved:Connect(function()
                if not flags.IsAnimeFan then return end
                manager:SendKeyEvent(false, keycode, false, nil)
            end)
        )
    end

    return match
end

function sort(instance)
    local children = instance:GetChildren()
    
    table.sort(children, function(a, b)
        return a.AbsolutePosition.X < b.AbsolutePosition.X
    end)
    
    return children
end

function getMatch()
    for i,v in ipairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'MatchFolder') then
            return v
        end
    end
end

--

UwUware:Init()

while true do wait(1)
    if UwUware == nil then break else
        for i,v in ipairs(connections) do
            v:Disconnect()
        end

        table.clear(connections)
    end

    local match = main()
    if not match then continue end

    match.MatchFolder.Destroying:Wait()
end
