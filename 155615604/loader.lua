local content = ([[
    chat:prefix ";"
    chat:register_message false 

    ;; starterGui notification
    startergui:notify true
    startergui:title "Loaded"
    startergui:text "Prefix - %s"
    startergui:duration 3.5
]])

if not isfile("155615604.ecfg") then 
    writefile("155615604.ecfg", content)
end

--

if not game:IsLoaded() then game.Loaded:Wait() end

local ecfg = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/ecfg/main/ecfg.lua")()
local cmds = loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/155615604/commands.lua")()

local config = ecfg:decode(readfile("155615604.ecfg"))

local string = string
local coro = coroutine
local table = table

local event = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local __namecall; __namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == event then
        local message, receiver = ...
        
        local args = message:split(" ")
        local prefix = config["chat:prefix"]

        local cmd = string.sub(args[1], 1 + #prefix, -1)
        table.remove(args, 1)

        if string.sub(message, 1, #prefix) == prefix then
            coro.resume(coro.create(cmds[cmd] or function() end), unpack(args))
            if config["chat:register_message"] ~= true then
                return
            end
        end
    end
    
    return __namecall(self, ...)
end)

--

getgenv().config = config
getgenv().ecfg = ecfg
getgenv().cmds = cmds

loadstring(game:HttpGet"https://raw.githubusercontent.com/stavratum/lua/main/155615604/connect.lua")()

--

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = config["startergui:title"],
    Text = string.format(config["startergui:text"], config["chat:prefix"]),
    Duration = config["startergui:duration"]
})
