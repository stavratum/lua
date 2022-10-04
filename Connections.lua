local connections = {}

function connections:Open(kv)
    self.Threads[ kv or (#Threads + 1) ] = {}
    
    local Thread = {}
    
    function Thread:Insert(Signal, OnFire)
        self[#self + 1] = Signal:Connect(OnFire)
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
    
    function Thread:Clear()
        for index, connection in pairs(self) do
            if connection.Connected then
                connection:Disconnect()
            end
            
            table.clear(self)
        end
    end
    
    return setmetatable(self.Threads[ kv or (#Threads + 1) ], { __index = Thread })
end

function connections:Destroy()
    for index, thread in next, self.Threads do
        for index, connection in pairs(thread) do 
            if connection.Connected then
                connection:Disconnect()
            end
        end
        
        table.clear(thread)
        self.Threads[index] = nil
    end
end

function connections:Close(kv)
    local thread = self.Threads[kv]
    
    for index, connection in pairs(thread) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    
    table.clear(thread)
    self.Threads[kv] = nil
end

function connections:Clear()
    for index, thread in next, self.Threads do
        for index, connection in pairs(thread) do
            if connection.Connected then
                connecion:Disconnect()
            end
        end
        
        table.clear(thread)
    end
end

return setmetatable({ Threads = {} }, { __index = connections })
