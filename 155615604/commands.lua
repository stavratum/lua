local players = game:GetService"Players"
local replicatedStorage = game:GetService"ReplicatedStorage"
local client = players.LocalPlayer

local Vector3 = Vector3.new
local CFrame = CFrame.new
local Ray = Ray.new

local string = string
local table = table

local p_items = workspace.Prison_ITEMS.giver

local unequipEvent = replicatedStorage.UnequipEvent
local shootEvent = replicatedStorage.ShootEvent
local loadchar = workspace.Remote.loadchar
local teamEvent = workspace.Remote.TeamEvent
local itemHandler = workspace.Remote.ItemHandler



local resume = coroutine.resume
local create = coroutine.create

local function spawn(f, ...)
    resume(create(f), ...)
end

local function fromPlayers(player)
    player = string.lower(player)
    
    for i, v in ipairs(players:GetChildren()) do
        local part = string.sub(v.name, 1, #player)
        if string.lower(part) == player then
            return v, i
        end
    end
    
    print(string.format("commands.lua, 33: %s", player))
end

local function indexOf(array, value)
    for i = 1, #array do
        if value == array[i] then
            return i
        end
    end

    return -1
end

--

local cmds; cmds = {
    ["reload"] = function()
        local character = client.Character
        local cframe = character.HumanoidRootPart.CFrame
        
        loadchar:InvokeServer(client)
        while character == client.Character do
            client:GetPropertyChangedSignal"Character":Wait()
        end
        
        client.Character.HumanoidRootPart.CFrame = cframe
    end,
    ["team"] = function(team)
        local colors = {"Bright blue", "Bright orange", "Medium stone gray", "Really red"}
        local color = indexOf({"guards", "inmates", "neutral", "criminals"}, string.lower(team))
        
        if color ~= -1 then
            teamEvent:FireServer(colors[color])
            spawn(cmds["reload"])
        end
    end,
    ["guns"] = function()
        local invoke = itemHandler.InvokeServer
        for _,v in ipairs({"Remington 870", "M9", "AK-47"}) do
            spawn(invoke, itemHandler, p_items[v].ITEMPICKUP);
        end
    end,
    ["gun"] = function(gun)
        local index = indexOf({"rem", "remington", "m9", "ak", "ak-47",}, string.lower(gun))
        local ref = {"Remington 870", "Remington 870", "M9", "AK-47", "AK-47"}
        
        if index ~= -1 then
            itemHandler:InvokeServer(p_items[ ref[index] ].ITEMPICKUP)
        end
    end,
    ["kill"] = function(playerName)
        local player, i = fromPlayers(playerName)
        if player == nil or i == 1 then return end
        
        local character = player.Character
        if not character or character:FindFirstChild"ForceField" then return end
        
        local name = "Remington 870"
        itemHandler:InvokeServer(p_items[name].ITEMPICKUP)
        local gun = client.Backpack:WaitForChild(name)
        
        local ray = Ray(Vector3(), Vector3())
        local cframe = CFrame()
        
        local data = {}
        for i = 1, 8 do
            data[i] = {
                ["RayObject"] = ray,
                ["Distance"] = 0,
                ["Cframe"] = cframe,
                ["Hit"] = character.Head
            }
        end
        
        gun.Parent = client.Character
        shootEvent:FireServer(data, gun)
        
        wait(0.05)
        unequipEvent:FireServer(gun)
        wait(0.01)
        gun:Destroy()
    end
}

return cmds
