local client = game:GetService"Players".LocalPlayer

return {
    ["kill"] = function(target)
    
    end,
    ["criminal"] = function()
  
    end,
    ["reload"] = function()
    
    end,
    ["test"] = function(...)
        print("received command 'test' with args: " .. table.concat({...}, ", "))
    end
}
