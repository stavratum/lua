if not game:IsLoaded() then game.Loaded:Wait() end

local getnamecallmethod= getnamecallmethod;
local getcallingscript = getcallingscript;
local hookmetamethod   = hookmetamethod;
local checkcaller      = checkcaller;
local hookfunction     = hookfunction;
local coroutine        = coroutine;
local genv             = getgenv();
local type             = type;
local game             = game;
local task             = task;

if not getgenv().IsAnimeFan then
    local creating_methods = { ["getService"] = true, ["GetService"] = true };
    local yielding_methods = { ["waitForChild"] = true, ["WaitForChild"] = true }
    local indexing_methods = {
        ["FindService"] = true,
        ["findService"] = true,
        
        ["FindService"] = true,
        ["findService"] = true,
        
        ["FindFirstChild"] = true,
        ["findFirstChild"] = true,
        
        ["FindFirstChildOfClass"] = true,
        ["findFirstChildOfClass"] = true,
        
        ["FindFirstChildWhichIsA"] = true,
        ["findFirstChildWhichIsA"] = true
    };
    
    local service = "VirtualInputManager";
    local created = false;
    
    local __namecall, __index, __newindex;
    
    __namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...};
        
        if (self == game) and (args[1] == service) and not checkcaller() then
            local method = getnamecallmethod();
                
            if indexing_methods[ method ] and not created then
                return nil;
            end
            
            if yielding_methods[ method ] and not created then 
                local thread = coroutine.running();
                local signal;
                
                if type(args[2]) == "number" then 
                    task.delay(args[2], function()
                        if coroutine.status(thread) == "suspended" then
                            signal:Disconnect();
                            coroutine.resume(thread);
                        end;
                        
                        return
                    end )
                end
                
                signal = self.ChildAdded:Connect( function(Object)
                    if (Object.Name == args[1]) and (created) then
                        signal:Disconnect();
                        if coroutine.status(thread) == "suspended" then
                            coroutine.resume(thread, Object)
                        end;
                    end;
                end );
                
                return coroutine.yield();
            end;
            
            if creating_methods[ method ] then
                created = true;
            end;
        end;
        
        return __namecall(self, ...)
    end );
    
    __newindex = hookmetamethod(game, "__newindex", function(...)
        local index = ({...})[2];
        
        if getcallingscript().Name == "Client" and index == "Health" then
            return;
        end;
        
        return __newindex(...);
    end );
    
    __index = hookmetamethod(game, "__index", function(table, index)
        
        if (table == game and index == service) then
            created = true;
        end
        
        return __index(table, index);
    end );
    
    --
    -- hooking functions
    --
    
    for method, v in pairs(indexing_methods) do
        indexing_methods[method] = hookfunction(game[method], function(self, ...)
            local args = {...};
            
            if self == game and (args[1] == service) and not checkcaller() and not created then
                return;
            end
            
            return indexing_methods[method](self, ...);
        end );
    end;
    
    for method, v in pairs(creating_methods) do
        creating_methods[method] = hookfunction(game[method], function(self, ...)
            if self == game and (... == service) and not checkcaller() then
                created = true;
            end;
            
            return creating_methods[method](self, ...);
        end );
    end;
    
    for method, v in pairs(yielding_methods) do
        yielding_methods[method] = hookfunction(game[method], function(self, ...)
            local args = {...};
            
            if (self == game) and (args[1] == service) and (not created) then
                local thread = coroutine.running();
                local signal;
                
                if args[2] then
                    task.delay(args[2], function()
                        if coroutine.status(thread) == "suspended" then
                            if signal.Connected then 
                                signal:Disconnect();
                            end;
                            
                            coroutine.resume(thread);
                        end;
                        
                        return;
                    end );
                    
                    coroutine.yield(thread);
                end;
                
                signal = self.ChildAdded:Connect( function(Object)
                    if (Object.Name == args[1]) and (created) then
                        signal:Disconnect();
                        if coroutine.status(thread) == "suspended" then
                            coroutine.resume(thread, Object)
                        end;
                    end;
                end );
            end;
            
            return yielding_methods[method](self, ...)
        end )
    end;
    
    --
    
    genv.IsAnimeFan = true;
end
