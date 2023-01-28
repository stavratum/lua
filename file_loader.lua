local function read(path)
    if not isfile(path) then
        return ""
    end
  
    return readfile(path)
end

--

local function ecfg(path)
    local fc = read(path)
    
    local lines = fc:split("\n")
    local res = { }
  
    local tps = { [-1] = nil, [0] = false, [1] = true }
     
    for _, content in ipairs(lines) do
        local i,v = table.unpack(content:split(" "))
    
        local asn = tonumber(v)
        if asn ~= nil then res[i] = tps[asn] else
            res[i] = v
        end
    end
    
    return res
end

local function json(path)
    local fc = read(path)
    local httpService = game:GetService("HttpService")
  
    local success, result = pcall(httpService.JSONDecode, httpService, fc)
    return success and result or { }
end

return {
    txt = read,
    ecfg = ecfg,
    json = json
}
