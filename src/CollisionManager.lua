CollisionManager = classes.class()

function CollisionManager:init(params)

  self.collisionHandlers = params
end

function CollisionManager:checkCollisions(objects)

  for i = 1, #objects - 1 do
    for j = i + 1, #objects do
      local obj1 = objects[i]
      local obj2 = objects[j]
      
      if not obj1 or not obj2 then
        return
      end
      
      if self:shouldCheckCollision(obj1, obj2) then
        if self:checkAABBCollision(obj1, obj2) then
          if obj1.handleCollision then
            obj1:handleCollision({collidedWith = obj2})
          end
          
          if obj2.handleCollision then
            obj2:handleCollision({collidedWith = obj1})
          end
        end
      end
    end
  end
end

function CollisionManager:shouldCheckCollision(obj1, obj2)

  if not self.collisionHandlers then
    return false
  end
  
  --print("obj1 collision type :" ..obj1.collisionChannel)
  --print("obj2 collision type :" ..obj2.collisionChannel)
  
  local collisionHandler1 = self.collisionHandlers[obj1.collisionChannel]
  local collisionHandler2 = self.collisionHandlers[obj2.collisionChannel]
  
  for _,collisionChannel in pairs(collisionHandler1) do
    if collisionChannel == obj2.collisionChannel then
      return true
    end
  end
  
  for _,collisionChannel in pairs(collisionHandler2) do
    if collisionChannel == obj1.collisionChannel then
      return true
    end
  end
  
  return false
end

function CollisionManager:checkAABBCollision(obj1, obj2)

  return obj1.x < obj2.x + obj2.width and
           obj1.x + obj1.width > obj2.x and
           obj1.y < obj2.y + obj2.height and
           obj1.y + obj1.height > obj2.y
  end

return CollisionManager