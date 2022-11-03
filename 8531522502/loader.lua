local function import(v)
    return loadstring(game:HttpGet(("https://raw.githubusercontent.com/stavratum/lua/main/8531522502/%s"):format(v)))()
end

local function main()
    import("setgenv.lua")
    import("ui.lua")
    
    return tick()
end

print(
    ("%s :: Loaded in %.2f seconds"):format(
        script.Name,
        -( tick() - main() )
    )
)
