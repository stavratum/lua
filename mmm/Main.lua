local uwuware,connected = loadstring(game:HttpGet'https://raw.githubusercontent.com/OPENCUP/random-texts/main/ui.lua')(), {} do
    local Window = uwuware:CreateWindow'AFC | MMM AP'
    local Main = Window:AddFolder'Main'
    Main:AddToggle{text = 'Toggle autoplayer',flag = 'yes',state = true}
    Main:AddBind{text = 'Hide GUI',key = Enum.KeyCode.Quote,
        callback = function()uwuware:Close()end
    }
    Main:AddButton{text = 'Unload script',
        callback = function()
            uwuware.base:Destroy()
            for _,Function in pairs(connected) do
                Function:Disconnect()
            end
            script:Destroy()
        end
    }
    local Credits = Window:AddFolder'Credits'
    Credits:AddButton{text = 'Copy discord invite',
        callback = function()
            if setclipboard then 
                print"Discord invite is in your clipboard"
                setclipboard"https://discord.gg/nV2YdWtDpD"
            else
                print"Exploit doesn't support 'setclipboard'"
                print"\n\n== DISCORD INVITE ==\nhttps://discord.gg/nV2YdWtDpD\n===================="
            end
        end
    }
    Credits:AddLabel{text = "Updated: 8/8/2022"}
    Credits:AddLabel{text = "stavratum#6591: Autoplayer"}
    Credits:AddLabel{text = "cup#7282: UI setup"}
    uwuware:Init()  
end

local game = game

local client = game:GetService'Players'.LocalPlayer

local manager = game:GetService'VirtualInputManager'
local runservice = game:GetService'RunService'

local notes = {}

local _0
_0 = hookmetamethod(game,"__newindex",
    function(...)
        local self, index, value = ...
        if table.find({'name', 'Name'}, index) and value == '' then return end 
        return _0(...)
    end
)

for _,v in pairs(client.PlayerGui.ScreenGui:GetChildren()) do
    if v:FindFirstChildOfClass'TextLabel' then
        print(v)
        v.ChildAdded:connect(
            function(_)
                if not _:FindFirstChild'OpponentStats' then return end
                
                local side
                for i,v in pairs(game:GetService'ReplicatedStorage':GetDescendants())do
                    if v:IsA'ObjectValue' and v.Value == client then
                        side = ({'Left';'Right'})[v.PlayerType.Value]
                        break
                    end
                end
                
                local Main = _:WaitForChild(tostring(side), 120)
                
                if not Main then return end
                
                local Notes = Main.Notes
                local LongNotes = Main.LongNotes
                
                local Downscroll = getrenv()._G.PlayerData.Options.DownScroll
                
                local Keys = getrenv()._G.PlayerData.Options.ExtraKeySettings
                Keys['4'] = {
                    LeftKey = 'Left';
                    RightKey = 'Right';
                    UpKey = 'Up';
                    DownKey = 'Down';
                }
                
               connected[#connected + 1] = Notes.ChildAdded:Connect(
                    function(Holder)
                        Holder.ChildAdded:Connect(
                            function(note)
                                if Downscroll then
                                    repeat runservice.RenderStepped:Wait() until note.AbsolutePosition.Y >= Main['    '][Holder.name].AbsolutePosition.Y
                                else 
                                    repeat runservice.RenderStepped:Wait() until Main['    '][Holder.name].AbsolutePosition.Y >= note.AbsolutePosition.Y
                                end
                                
                                if uwuware.flags.yes then
                                    manager:SendKeyEvent(true, Keys[tostring(#Notes:GetChildren())][Holder.name .. 'Key'] ,false,nil)
                                    
                                    if #LongNotes[Holder.name]:GetChildren() == 0 then
                                        manager:SendKeyEvent(false, Keys[tostring(#Notes:GetChildren())][Holder.name .. 'Key'] ,false,nil)
                                    end
                                end
                            end
                        )
                    end
                )
                
                connected[#connected + 1] = LongNotes.ChildAdded:Connect(
                    function(Holder)
                        Holder.ChildAdded:Connect(
                            function(Sustain)
                                local Prev = Sustain.AbsolutePosition.Y
                                repeat
                                    wait()
                                    if Prev == Sustain.AbsolutePosition.Y then break end
                                    Prev = Sustain.AbsolutePosition.Y
                                until not Sustain.Visible
                                Sustain:Destroy()
                                if uwuware.flags.yes then
                                    manager:SendKeyEvent(false, Keys[tostring(#Notes:GetChildren())][Holder.name .. 'Key'] ,false,nil)
                                end
                            end
                        )
                    end
                )
            end
        )
        
    end
end
