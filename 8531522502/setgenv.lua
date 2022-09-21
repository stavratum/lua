local new_genv = table.clone(getgenv())
local set = function(i,v) new_genv[i] = v end

setrawmetatable(getfenv(), { __metatable = "This metatable is locked.", __index = new_genv })

set("Players", game:GetService"Players")
set("Client", Players.LocalPlayer)
set("PlayerGui", Client.PlayerGui)
set("RunService", game:GetService"RunService")

set("GUI_Name", ("Facility of Redemption :: %s"):format(script.Name))
set("Material", loadstring(game:HttpGet"https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua")() )
