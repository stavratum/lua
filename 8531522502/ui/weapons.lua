local weapons = Library.New({ Title = "WEAPONS" })

weapons.Label({ Text = "WEAPONS" })

for index, weapon_name in pairs(Weapons) do 
    weapons.Button({
        Text = weapon_name,
        Callback = function()
            local Item = PickItem[weapon_name]
            local Prompt = Item:FindFirstChildOfClass"ProximityPrompt"
                    
            local Character = Client.Character.Parent ~= nil and Client.Character or Client.CharacterAdded:Wait()
            local HumanoidRootPart = Character.HumanoidRootPart
            local CFrame = HumanoidRootPart.CFrame
                    
            HumanoidRootPart.CFrame = Item.CFrame
            wait(0.2)
            fireproximityprompt(Prompt)
            HumanoidRootPart.CFrame = CFrame
        end
    })
end

weapons.Label({ Text = "ITEMS" })

for index, item_name in pairs(Items) do 
    weapons.Button({
        Text = item_name,
        Callback = function()
            local Item = PickItem[item_name]
            local Prompt = Item:FindFirstChildOfClass"ProximityPrompt"
                    
            local Character = Client.Character.Parent ~= nil and Client.Character or Client.CharacterAdded:Wait()
            local HumanoidRootPart = Character.HumanoidRootPart
            local CFrame = HumanoidRootPart.CFrame
                    
            HumanoidRootPart.CFrame = Item.CFrame
            wait(0.2)
            fireproximityprompt(Prompt)
            HumanoidRootPart.CFrame = CFrame
        end
    })
end
