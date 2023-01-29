local players = game:GetService"Players"
local replicatedStorage = game:GetService"ReplicatedStorage"
local client = players.LocalPlayer

local remotes = {
    ["loadchar"] = workspace.Remote.loadchar,
    ["teamEvent"] = workspace.Remote.TeamEvent
}

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
        
        remotes.loadchar:InvokeServer(client)
        if character == client.Character then wait() end
        
        client.Character.HumanoidRootPart.CFrame = cframe
    end,
    ["team"] = function(team)
        local colors = {"Bright blue", "Bright orange", "Medium stone gray", "Really red"}
        local color = indexOf({"guards", "inmates", "neutral", "criminals"}, team:lower())
        
        if color ~= -1 then
            teamEvent:FireServer(colors[color])
            cmds.reload()
        end
    end
}

return cmds
