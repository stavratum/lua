local connections = {}

function connections:Open(kv)
    self.Threads[ kv or (#Threads + 1) ] = {}
    
    local Thread = {}
    
    function Thread:Add(Object, Signal, OnFire)
        local index = #self + 1
        
        self[index] = Object[Signal]:Connect(OnFire)
        
        Object.Destroying:Connect(
            function()
                table.remove(self, index)
            end
        )
    end
    
    function Thread:Close()
        for index, connection in pairs(self) do
            if connection.Connected then
                connection:Disconnect()
            end
            
            table.clear(self)
            
            Threads[Thread] = nil
        end
    end
    
    return setmetatable(self.Threads[ kv or (#Threads + 1) ], { __index = __index })
end

function connections:Destroy()
    for index, thread in next, self.Threads do
        for index, connection in pairs(thread) do 
            connection:Disconnect()
        end
        
        table.remove(self.Threads, index)
    end
end

function connections:Close(kv)
    local thread = self.Threads[kv]
    
    for index, connection in pairs(thread) do
        connection:Disconnect()
    end
    
    table.clear(thread)
    self.Threads[kv] = nil
end

return setmetatable({ Threads = {} }, { __index = connections })
