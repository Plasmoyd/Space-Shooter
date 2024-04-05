EventManager = classes.class()

--Singleton Pattern instance
local instance = nil

function EventManager:init()

    if instance then
        print("instance is not nil, can't have more than one")
        return
    end
    
    local eventManager = {
    
      subscribers = {}
    
    }
  
    instance = eventManager
    return instance
end

function EventManager:subscribe(event, subscriber)

    if not instance then
      
        instance = self:init()
    end
    
    if not instance.subscribers[event] then
        
        instance.subscribers[event] = {}
    end
    
    table.insert(instance.subscribers[event], subscriber)
end


function EventManager:notify(event)
  
    local subscribers = instance.subscribers[event] or {}
    
    for _, subscriber in pairs(subscribers) do
      
      if subscriber.onNotify then
          subscriber:onNotify(event)
      end
    end
end

return EventManager
