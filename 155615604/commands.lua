local players = game:GetService"Players"
local teams = game:GetService"Teams"
local replicatedStorage = game:GetService"ReplicatedStorage"

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
    ["team"] = function(team)
        if not team then return end
        local refs = {
            ["guards"] = "Guards",
            ["inmates"] = "Inmates",
            ["neutral"] = "Neutral",
            ["criminals"] = "criminals"
        }
        
        local color = teams[ refs[team:lower()] ].TeamColor
        remotes.teamEvent:FireServer(color)
        remotes.loadchar:InvokeServer()
    end
}

return cmds
