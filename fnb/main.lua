-- stavratum.github.io

loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/fnb/hooks.lua")() -- Anticheat bypass

local connections = {
    add = function(self, signal, onFire)
        self[#self + 1] = signal:Connect(onFire);
    end,
  
    disconnect = function(self)
        for i,v in pairs(self) do
            if type(v) ~= "function" then v:Disconnect() end
        end
        table.clear(self)
    end
}

local Client = game:GetService"Players".LocalPlayer;
local PlayerGui = Client.PlayerGui;
local Input = Client:WaitForChild"Input";

local uwuware;
local Offsets = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/fnb/offsets.lua")();
local Discord = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/Discord.lua")();
local Keys = {
    [4] = { Left = "Left", Down = "Down", Up = "Up", Right = "Right" },
    [5] = { Left = "Left", Down = "Down", Space = "Space", Up = "Up", Right = "Right" },
    [6] = { S = "R3", D = "R2", F = "R1", J = "L1", K = "L2", L = "L3" },
    [7] = { S = "R3", D = "R2", F = "R1", Space = "Space", J = "L1", K = "L2", L = "L3" },
    [8] = { A = "L4", S = "L3", D = "L2", F = "L1", H = "R1", J = "R2", K = "R3", L = "R4" },
    [9] = { A = "L4", S = "L3", D = "L2", Space = "Space", F = "L1", H = "R1", J = "R2", K = "R3", L = "R4" }
};

local VirtualInputManager = game:GetService "VirtualInputManager"; -- for input sending
local InputService = game:GetService "UserInputService"; -- for input sending
local HttpService = game:GetService "HttpService"; -- for JSON decoding

local genv = getgenv();
local task = genv.task;
local type = type;

local function onChildAdded(Object)
    if (not Object) then return end;
    if (Object.Name ~= "FNFEngine") then return end;
    
    local require = require;
    local set_identity = (syn and syn.set_thread_identity or setidentity or setthreadcontext);
    local function IsOnHit(_) return (_ ~= nil and require(_).Type == "OnHit") end;
    
    local function GetInputFunction()
        local inputFunction;
        set_identity(2);
        for _, v in pairs(getconnections(InputService.InputBegan)) do
            if getfenv(v.Function).script.Name == "Client" then
                inputFunction = v.Function;
            end;
        end;
        set_identity(7);
        return inputFunction;
    end;
    
    local function Filter(iter, method)
        local returns = {};
        for i,v in pairs(iter) do 
            returns[#returns + 1] = method(v);
        end;
        return returns;
    end;
    
    local Stage = Object.Stage.Value;
    while (not Stage.Config.Song.Value) do
        Object.Config.TimePast.Changed:Wait();
    end;
    
    local Song = Stage.Config.Song.Value;
    local PoisonNotes;
    
    local ScrollSpeed = Input.ScrollSpeedChange.Value and Input.ScrollSpeed.Value or HttpService:JSONDecode( require(Song) ).song.speed;
    local Offset = Offsets[#tostring(ScrollSpeed) > 1 and string.format("%.1f", ScrollSpeed) or tostring(ScrollSpeed)] / 1000 + 0.4;
    
    local Arrows = Object.Game[Object.PlayerSide.Value].Arrows
    local IncomingNotes = Filter(Arrows.IncomingNotes:GetChildren(), function(v)
        return not string.find(v.Name, "|") and v or nil;
    end )
      
    if Song then
        PoisonNotes =
            (Song.Parent:FindFirstChild"MultiplieGimmickNotes" or Song:FindFirstChild"GimmickNotes" or
            Song.Parent:FindFirstChild"GimmickNotes" or
            Song:FindFirstChild"MineNotes" or {} ).Value == "OnHit"
    end
    
    local Keybinds = Input.Keybinds;
    local Session = {};
    
    if Keys[#IncomingNotes] == nil then 
        print(("note count: %d"):format(#IncomingNotes))
        warn("No keys were loaded, report to owner of the script!")
    end
    
    for kn, kv in pairs(Keys[#IncomingNotes]) do 
        Session[kn] = Enum.KeyCode[ Keybinds[kv].Value ];
    end
    
    local begin = Enum.UserInputState.Begin;
    local inputFunction = GetInputFunction();
    local spawn = task.spawn;
    local wait = task.wait;
    
    for _, connection in pairs(getconnections(Object.Events.UserInput.OnClientEvent)) do 
        connection:Disable()
    end
    
    for _, Holder in pairs(IncomingNotes) do
        connections:add(Holder.ChildAdded, function(Arrow)
            if Arrow.HellNote.Value and PoisonNotes or IsOnHit(Arrow:FindFirstChildOfClass"ModuleScript") or not Arrow.Visible then return end
            local Input = Session[Holder.Name]
          
            wait(Offset + uwuware.flags.ms / 1000);
            if not uwuware.flags.hello then return end
            
            if (uwuware.flags.FireDirectly) then 
                set_identity(2);
                spawn(inputFunction, {
                    KeyCode = Input,
                    UserInputState = begin
                });
              
                local Bar = Arrow.Frame.Bar;
                while Bar.Size.Y.Scale >= 0.6 do
                    task.wait();
                end
              
                spawn(inputFunction, { KeyCode = Input });
                set_identity(7);
            else
                VirtualInputManager:SendKeyEvent(true, Input, false, nil);
                local Bar = Arrow.Frame.Bar;
                while Bar.Size.Y.Scale >= 0.6 do
                    task.wait();
                end
                VirtualInputManager:SendKeyEvent(false, Input, false, nil);
            end
        end )
    end
end

uwuware = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/fnb/uwuware.lua")() do
    local Window = uwuware:CreateWindow "Friday Night Bloxxin'";
    Window:AddSlider { text = "Offset (ms)", flag = "ms", min = -50, max = 50, value = 0 };
    Window:AddToggle { text = "Toggle Autoplayer", flag = "hello", state = true };
    Window:AddToggle { text = "Fire Signals Directly", flag = "FireDirectly", state = true };
    Window:AddBind { text = "Close GUI", key = Enum.KeyCode.Quote, callback = function() uwuware:Close(); end }
    Window:AddButton({
        text = "Unload Script",
        callback = function()
            (syn and syn.set_thread_identity or setidentity or setthreadcontext)(7);
            connections:disconnect();
            uwuware.base:Destroy();
        end
    })
    Window:AddButton { text = "Copy Discord Invite", callback = function() (setclipboard or print)(Discord) end }
end

connections:add(PlayerGui.ChildAdded, onChildAdded);
task.spawn(onChildAdded, PlayerGui:FindFirstChild"FNFEngine");

uwuware:Init();

--

for i,v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "ProximityPrompt" then
        v.HoldDuration = 0;
    end
end

if Input.Keybinds.R4.Value == ";" then
    game:GetService("ReplicatedStorage").Events.RemoteEvent:FireServer("Input", "Semicolon", "R4")
end
