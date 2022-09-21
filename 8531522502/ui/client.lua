local client = Library.New({ Title = "CLIENT" })

client.Label({ Text = "SPEED" })

client.TextField({
    Text = "Walkspeed",
    Type = "Default",
    Callback = function(ws)
        for index, value in pairs({ ["Run"] = 16, ["PupRun"] = 0, ["Outraged"] = 19 }) do 
            PlayerGui[index].Walkspeed.Value = tonumber(ws) or value
        end
    end
})

client.TextField({
    Text = "Runspeed",
    Type = "Default",
    Callback = function(rs)
        for index, value in pairs({ ["Run"] = 20, ["PupRun"] = 0, ["Outraged"] = 29 }) do 
            PlayerGui[index].Runspeed.Value = tonumber(rs) or value
        end
    end
})

client.Label({ Text = "KILLAURA" })

client.Toggle({
    Text = "Enabled",
    Enabled = false,
    Callback = function(Enabled) end
})

client.ColorPicker({
    Text = "Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(Color) end
})

client.Slider({
    Text = "Size",
    Min = 0,
    Max = 63,
    Def = 63,
    Callback = function(def)
        def = def * 0.1
      
        --
    end
})

client.Slider({
    Text = "Transparency",
    Min = 0,
    Max = 10,
    Def = 8,
    Callback = function(def)
        def = def * 0.1
      
        --
    end
})
