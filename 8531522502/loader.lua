local function require(v)
    local link = ("https://raw.githubusercontent.com/stavratum/lua/main/8531522502/%s"):format(v)
    return loadstring( game:HttpGet(link) )
end

local function main()
    require("setgenv.lua")()
    require("ui.lua")()
  
    return tick()
end

print(
    ("%s :: Loaded in %.2f seconds"):format(
        script.Name,
        -( tick() - main() )
    )
)
