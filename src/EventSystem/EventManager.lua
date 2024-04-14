-- EventManager class with singleton pattern to ensure only one instance manages all event subscriptions.
EventManager = classes.class()

--Singleton Pattern instance
local instance = nil

function EventManager:init()

    -- Prevent the creation of multiple instances.
    if instance then
        print("instance is not nil, can't have more than one")
        return
    end
    
    -- Create the event manager object with a table to hold subscribers.
    local eventManager = {
    
      subscribers = {}
    
    }
  
    -- Assign the newly created event manager to the static instance variable.
    instance = eventManager
    return instance
end

-- Subscribe a subscriber to a specific event.
function EventManager:subscribe(event, subscriber)

    if not instance then
      
        instance = self:init()
    end
    
    if not instance.subscribers[event] then
        
        instance.subscribers[event] = {}
    end
    
    table.insert(instance.subscribers[event], subscriber)
end

-- Unsubscribe a subscriber from a specific event.
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

-- Unsubscribe a subscriber from all events.
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

-- Notify all subscribers of an event.
function EventManager:notify(event, args)
  
    local subscribers = instance.subscribers[event] or {}
    
    for _, subscriber in pairs(subscribers) do
      
      if subscriber.onNotify then
          subscriber:onNotify(event, args)
      end
    end
end

return EventManager
