local HttpService = game:GetService"HttpService"

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

--

return {
    getSong = getSong,
    filter = filter,
    parse = parse
}
