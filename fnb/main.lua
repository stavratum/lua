-- grrr nya

local function require(s)
    return loadstring(game:HttpGet( ("https://raw.githubusercontent.com/stavratum/lua/main/%s.lua"):format(s) ))()
end

require("fnb/hooks")
local Connections = require("Connections")
local Discord = require("Discord")
local Util = require("fnb/util")
local UwUware = require("fnb/uwuware")

require = getgenv().require

local VirtualInputManager = game:GetService "VirtualInputManager"
local InputService = game:GetService "UserInputService"
local RunService = game:GetService "RunService"
local Players = game:GetService "Players"


local Client = Players.LocalPlayer
local PlayerGui = Client.PlayerGui


local set_identity = (syn and syn.set_thread_identity or setidentity or setthreadcontext)
local get_signal_function = function(Signal, Target, _)
    set_identity(2)
    for index, connection in pairs( getconnections(Signal) ) do
        if getfenv(connection.Function).script == Target then
            _ = connection.Function
        end 
    end
    set_identity(7)
    return _;
end

local MAIN = Connections:Open("MAIN")
local TEMP = Connections:Open("TEMP")


local function onChildAdded(Object)
    if (not Object) then return end
    if (#Object:GetDescendants() < 50) then return end
    
    TEMP:Clear()
    
    local convert
    local spawn = task.spawn
    local delay = task.delay
    local wait = task.wait
    
    local Begin = Enum.UserInputState.Begin
    local End = Enum.UserInputState.End
    
    local GimmickNotes
    local Chart = {}
    local IncomingNotes = {}
    
    local Song, SongData
    local Stage = Object.Stage.Value
    local Side = Object.PlayerSide.Value
    
    local TimePast = Object.Config.TimePast
    
    
    while (not Stage.Config.Song.Value) do
        TimePast.Changed:Wait()
    end

    while not require(Object.Modules.Functions).notetypeconvert do
        TimePast.Changed:Wait()
    end
    
    Song = Stage.Config.Song.Value
    SongData = Util.getSong(Song)
    convert = require(Object.Modules.Functions).notetypeconvert
    
    local PoisonNotes =
        Song:FindFirstChild"MultipleGimmickNotes" or Song:FindFirstChild"GimmickNotes" or
        Song:FindFirstChild"MineNotes" or Song.Parent:FindFirstChild"GimmickNotes"
        or Song.Parent:FindFirstChild"MineNotes" or Song.Parent:FindFirstChild"MultipleGimmickNotes"
    
    for _, connection in pairs(getconnections(Object.Events.UserInput.OnClientEvent)) do 
        connection:Disable()
    end
    
    
    for Index, Note in pairs(Util.parse( SongData )) do
        local Note_1 = Note[1]
        local Key, _, HellNote = convert(Note_1[2], Note_1[4])
        Key = type(Key) == "string" and Key or "|"
        
        local function add()
            Chart[#Chart + 1] = {
                Length = Note[1][3],
                At = Note[1][1],
                Key = Key:split"_"[1]
            }
        end
        
        local function close()
            add = function() end
        end
        
        --
    
        local mustHit
        
        if (not Key or Key:find"|") then close() end
        if type(Note[2]) ~= "table" then close() else
            mustHit = Note[2].mustHitSection
        end
        
        local Arrow = PoisonNotes and PoisonNotes:FindFirstChild(Key:split"_"[2] or Key:split"_"[1])
        Arrow = Arrow and require(Arrow.ModuleScript)
        
        if (_) then mustHit = not mustHit end
        if (mustHit and "R" or "L") ~= Side then close() end
        if HellNote and (Arrow and Arrow.Type == "OnHit" or PoisonNotes and PoisonNotes.Value == "OnHit") then close() end
        
        add()
    end
    
    for i,v in pairs(Chart) do
        IncomingNotes[v.Key] = (IncomingNotes[v.Key] or {})
        if v.At > TimePast.Value * 1000 then 
            IncomingNotes[v.Key][#IncomingNotes[v.Key] + 1] = { v.At - 1, tonumber(v.Length) and (v.Length / 1000) or 0 }
        end
    end
    
    local len = 0 
    for i,v in pairs(IncomingNotes) do len += 1 end
    
    local inputFunction = get_signal_function(InputService.InputBegan, Object.Client)
    
    for Key, chart in pairs(IncomingNotes) do
        local input = Util.getKeycode(Key, len)
        local index = 1
        
        local function Update()
            local Arrow = chart[index]
            
            if Arrow and (Arrow[1] <= TimePast.Value * 1000) then
                index += 1
                
                if (not UwUware.flags.IsAnimeFan) then return end
                
                if (UwUware.flags.FireDirectly) then 
                    set_identity(2)   
                     
                    spawn(inputFunction, { KeyCode = input, UserInputState = Begin })
                    delay(Arrow[2], inputFunction, { KeyCode = input, UserInputState = End })
                else
                    set_identity(7)
                    
                    VirtualInputManager:SendKeyEvent(true, input, false, nil)
                    delay(Arrow[2], VirtualInputManager.SendKeyEvent, VirtualInputManager, false, input, false, nil)
                end
            end
        end
        
        TEMP:Insert(RunService.RenderStepped, Update)
        TEMP:Insert(RunService.Stepped, Update)
        TEMP:Insert(RunService.Heartbeat, Update)
    end
    
end

MAIN:Insert(PlayerGui.ChildAdded, onChildAdded)
task.spawn(onChildAdded, PlayerGui:FindFirstChild"FNFEngine")


local Window = UwUware:CreateWindow "Friday Night Bloxxin'" do
    Window:AddToggle { text = "Toggle Autoplayer", flag = "IsAnimeFan", state = true }
    Window:AddToggle { text = "Fire Signals Directly", flag = "FireDirectly", state = true }
    Window:AddBind { text = "Close GUI", key = Enum.KeyCode.Quote, callback = function() UwUware:Close() end }
    Window:AddButton({
        text = "Unload Script",
        callback = function()
            set_identity(7)
            Connections:Destroy()
            UwUware.base:Destroy()
        end
    })
    Window:AddButton { text = "Copy Discord Invite", callback = function() (setclipboard or print)(Discord) end }
    
    UwUware:Init()
end

--

for i,v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "ProximityPrompt" then
        v.HoldDuration = 0
    end
end

if Client.Input.Keybinds.R4.Value == ";" then
    game:GetService("ReplicatedStorage").Events.RemoteEvent:FireServer("Input", "Semicolon", "R4")
end
