local Event = {}

local function clear(table)
    for i,v in pairs(table) do
        if type(v) == 'table' then
            clear(v)
        end
        table[i] = nil
    end
end

local function remove(table, index)
    if type(table[index]) == 'table' then
        clear(table[index])
    end
    
    table[index] = nil
    
    for i = index + 1, #table do 
        local v = table[i]
        
        table[i] = nil
        table[i - 1] = v
    end
end

function Event.new()
    
    local coroutine = coroutine
    local type = type
    local pairs = pairs
    local clear = clear
    local remove = remove
  
    local event = {
        __THREADS = {};
        __CONNECTED = {}
    }
    
    function event:Wait()
        self.__THREADS[#self.__THREADS + 1] = coroutine.running()
        return coroutine.yield()
    end
    
    function event:Fire(...)
        for _,Function in pairs(self.__CONNECTED) do
            Function(...)
        end
        for _,Thread in pairs(self.__THREADS) do
            coroutine.resume(Thread, ...)
        end
    end
    
    function event:Connect(Function)
        local index = #self.__CONNECTED + 1
        self.__CONNECTED[index] = Function
                        
        return {
            Disconnect = function()
                remove(self.__CONNECTED, index)
            end
        }
    end
    
    return event
end

return Event
