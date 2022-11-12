function getgenv().import(v)
    local str = "https://raw.githubusercontent.com/%s/%s/main/%d/%s"
    local account = "stavratum"
    local repository = "lua"
    
    return loadstring(game:HttpGet(str:format(account, repository, game.PlaceId, v)))()
end

local function main()
    import("setgenv.lua")
    import("ui.lua")
    
    return tick()
end

print(
    ("%s :: Loaded in %.2f seconds"):format(
        script.Name,
        -(tick() - main())
    )
)
