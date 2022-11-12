Library = Material.Load({
    Title = GUI_Name,
    Style = 1,
    SizeX = 450,
    SizeY = 350,
    Theme = "Light",
    ColorOverrides = { MainFrame = Color3.fromRGB(235, 235, 235) }
})

-- ui: preparations

PickItem = workspace.PickItem

Weapons = {'Bat', 'Katana', 'FireAxe', 'Machete', 'Crowbar', 'Pipe'}
Items =  {'Cookie', 'StrangeFruit', 'IceTea', 'FurtaSoda', 'BlueCone', 'Collar', 'blueStim', 'UnstableStim', 'SynthVisor', 'ProtoMask'}

-- ui: main

import("ui/client.lua")
import("ui/players.lua")
import("ui/weapons.lua")
import("ui/other.lua")
