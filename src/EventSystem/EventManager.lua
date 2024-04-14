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

function EventManager:unsubscribe(event, subscriber)
  
  if not instance then
      
    instance = self:init()
  end
  
  if not instance.subscribers[event] then
    return
  end
  
  local subscribers = instance.subscribers[event]
  
  for i = 1, #subscribers do
    
    if subscriber == subscribers[i] then
      table.remove(subscribers, i)
      break
    end
  end
end

function EventManager:unsubscribeAll(subscriber)
  if not instance then
    instance = self:init()
  end
    
  for event, subscribers in pairs(instance.subscribers) do
    for i = #subscribers, 1, -1 do
      if subscribers[i] == subscriber then
        table.remove(subscribers, i)
      end
    end
  end
end

function EventManager:notify(event, args)
  
    local subscribers = instance.subscribers[event] or {}
    
    for _, subscriber in pairs(subscribers) do
      
      if subscriber.onNotify then
          subscriber:onNotify(event, args)
      end
    end
end

return EventManager
