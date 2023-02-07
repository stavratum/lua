local players = game:GetService"Players"
local replicatedStorage = game:GetService"ReplicatedStorage"
local client = players.LocalPlayer

local string = string
local table = table

local p_items = workspace.Prison_ITEMS.giver

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
        
        itemHandler:InvokeServer(p_items["Remington 870"].ITEMPICKUP)
        local gun = client.Character:WaitForChild"Remington 870"
        
        local vector3 = Vector3.new
        local data = {
            ["RayObject"] = Ray.new(vector3(), vector3()),
            ["Distance"] = 0,
            ["Cframe"] = CFrame.new(),
            ["Hit"] = character.Head
        }
        
        shootEvent:FireServer({data, data, data, data, data, data, data, data}, gun)
        gun:Destroy()
    end
}

return cmds
