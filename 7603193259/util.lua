local Keybinds = game:GetService"Players".LocalPlayer.Input.Keybinds
local HttpService = game:GetService"HttpService"
local KeyCode = Enum.KeyCode
local Keys = {
    [4] = { Left = "Left", Down = "Down", Up = "Up", Right = "Right" },
    [5] = { D = "L2", F = "L1", Space = "Space", J = "R1", K = "R2" },
    [6] = { S = "L3", D = "L2", F = "L1", J = "R1", K = "R2", L = "R3" },
    [7] = { S = "L3", D = "L2", F = "L1", Space = "Space", J = "R1", K = "R2", L = "R3" },
    [8] = { A = "L4", S = "L3", D = "L2", F = "L1", H = "R1", J = "R2", K = "R3", L = "R4" },
    [9] = { A = "L4", S = "L3", D = "L2", Space = "Space", F = "L1", H = "R1", J = "R2", K = "R3", L = "R4" }
}

local function parse(u23)
    local v395 = {};
    for v397, v398 in pairs(u23.notes) do
        for v399, v400 in pairs(v398.sectionNotes) do
            table.insert(v395, { v400, v398 });
        end
    end
    if u23.events and u23.chartVersion == nil then
        for v401, v402 in pairs(u23.events) do
            for v403, v404 in pairs(v402[2]) do
                table.insert(v395, { { v402[1], "-1", v404[1], v404[2], v404[3] } });
            end
        end
    end
    table.sort(v395, function(p62, p63)
        return p62[1][1] < p63[1][1];
    end)
        
    return v395
end

local function filter(iter, method)
    local returns = {}
    for i,v in pairs(iter) do 
        returns[#returns + 1] = method(v)
    end
    return returns
end

local function getSong(module)
    return HttpService:JSONDecode( require(module) ).song
end

local function generateGUID()
    return HttpService:GenerateGUID(false)
end

local function getKeycode(str, len)
    return KeyCode[ Keybinds[ Keys[len][str] ].Value ]
end

--

return {
    generateGUID = generateGUID,
    getKeycode = getKeycode,
    getSong = getSong,
    filter = filter,
    parse = parse
}
