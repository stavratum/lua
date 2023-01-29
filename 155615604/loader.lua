if not isfile("155615604.ecfg") then 
    writefile("155615604.ecfg", 'commands:prefix ";"\ncharacter:respawn true')
end

--

if not game:IsLoaded() then game.Loaded:Wait() end

local ecfg = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/ecfg/main/ecfg.lua")()
local cmds = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/155615604/commands.lua")()

local config = ecfg.decode(readfile("155615604.ecfg"))

--

local event = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local __namecall; __namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == event then
        local message, receiver = ...
        
        local args = message:split(" ")
        local prefix = config["commands:prefix"]

        local cmd = args[1]:sub(1 + #prefix, -1)
        table.remove(args, 1)

        if message:sub(1, #prefix) == prefix then
            return cmds[cmd](table.unpack(args))
        end
    end
    
    return __namecall(self, ...)
end)

--

getgenv().config = config
getgenv().ecfg = ecfg
getgenv().cmds = cmds

--

loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/155615604/connect.lua")()
