-- thanks to MarsRon and his amazing project "owofier"
-- https://github.com/MarsRon/

-- owofier: https://github.com/MarsRon/owofire/blob/master/index.js

local faces = {'UwU', 'OwO', 'owo', 'uwu', '^w^', '>w<', 'x3', '^-^', "'w'", ':3', 'ÚwÚ'}

local function getFace()
    return faces[math.random(#faces)]
end

local function owofire(input)
    local result = ""
    
    for index, word in pairs(input:split" ") do 
        local expressions = {
            ["l"] = "w",
            ["r"] = "w",
            ["L"] = "W",
            ["R"] = "W",
            ["Na"] = "Ny", ["Ne"] = "Ny", ["Ni"] = "Ny", ["No"] = "Ny", ["Nu"] = "Ny",
            ["na"] = "ny", ["ne"] = "ny", ["ni"] = "ny", ["no"] = "ny", ["nu"] = "ny",
            ["NA"] = "NY", ["NE"] = "NY", ["NI"] = "NY", ["NO"] = "NY", ["NU"] = "NY",
            ["ove"] = "uv",
            ["OVE"] = "UV",
            ["nd\b"] = "ndo",
            ["z\b"] = "z~",
            ["!"] = "! " .. getFace(),
            ["\?"] = "? " .. getFace(),
            ["the"] = "da",
            ["this"] = "dis",
            ["with"] = "wif",
            ["youw"] = "ur",
            ["you"] = "u",
            [","] = "~",
            [":\\"] = ":3",
            [":O"] = "OwO",
            [":o"] = "owo",
            [":D"] = "UwU",
            ["XD"] = "X3",
            ["xD"] = "x3"
        }
        
        for ex, rep in pairs(expressions) do 
            word = word:gsub(ex, rep)
        end
        
        result = result .. word .. " "
    end
    
    return result:sub(1, #result - 1)
end

local __namecall; __namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self.name == "SayMessageRequest" then 
        local message, receiver = ...
        return __namecall(self, owofire(message), receiver)
    end
    
    return __namecall(self, ...)
end )
