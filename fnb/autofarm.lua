_G.Song = "RUN"
_G.Mod = "Bob's Onslaught"
_G.Difficulty = "Hard"

_G.Modifiers = { "FadeIn", }

loadstring(game:HttpGet'https://raw.githubusercontent.com/stavratum/lua/main/fnb/main.lua')()

local virtualUser = game:GetService'VirtualUser'
local runService = game:GetService'RunService'
local client = game:GetService'Players'.LocalPlayer
local awc = { }

local stage do 
    local stages = workspace.Stages:GetChildren()
    stage = stages[math.random(#stages)]
end

--

local function delay(w, f, ...)
    wait(w);
    (f or function() end)(...);
end

local function enterStage()
    local stem = stage.MicrophoneA.Stem
    
    client.Character.HumanoidRootPart.CFrame = CFrame.new(stem.Position.X, stem.Position.Y, stem.Position.Z)
    delay(1, fireproximityprompt, stem.Enter, 0)
end

local function pickSong()
    local engine = client.PlayerGui:WaitForChild'FNFEngine'
    
    for i,v in ipairs(_G.Modifiers) do 
        engine.Events.Modifiers:FireServer(v)
    end
    
    stage.Events.PlayerSongVote:FireServer(_G.Song, _G.Difficulty, _G.Mod);
end

local function update()
    delay(1, enterStage)
    wait(10)
    client.PlayerGui:WaitForChild'SingleplayerUI'.ButtonPressed:FireServer()
    delay(2, pickSong)
end

--

client.Idled:connect(function()
    virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
client.CameraMode = 'LockFirstPerson'
local ccts = client.PlayerGui.ChildRemoved:Connect(function(object)
    if object.name == "FNFEngine" then
        update() 
    end
end)

update()

function _G:Clear()
    ccts:Disconnect()
    
    client.CameraMode = "Classic"
    _G.Clear = nil
end
