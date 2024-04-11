local Bullet = classes.class()

function Bullet:init(params)
  
  --print("xPosition: " .. xPosition .. " yPosition: " .. yPosition)
  self.speed = params.speed
  self.asset = params.asset
  self.x = params.x
  self.y = params.y
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  self.direction = params.direction
  self.damage = params.damage
  
  self.parentId = params.parentId
  
  self.collisionChannel = params.collisionChannel
  
  self.bulletDestroyedEvent = Event.new({sender = self, type = ON_BULLET_DESTROYED})
end

function Bullet:update(dt)
  
  --handling movement of the bullet
  self.y = self.y + (self.direction * self.speed * dt)
  
  --destroying the bullet if it's off screen
  if not self:isOnScreen() then
    self:destroy()
  end
end

function Bullet:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  local rotation = self.direction == PLAYER_BULLET_DIRECTION and 0 or math.pi
  love.graphics.draw(self.asset, newX, newY, rotation)
end

function Bullet:isOnScreen()
  
   if self.y < 0 or self.y > Model.stage.stageHeight or self.x < 0 or self.x > Model.stage.stageWidth then
     return false
   end
   
   return true
end

function Bullet:destroy()
  removeObjectFromScene(self)
  EventManager:notify(self.bulletDestroyedEvent, self)
end

function Bullet:updatePosition(x, y)
   
   if x and y then
     self.x = x
     self.y = y
   end
end

function Bullet:handleCollision(args)
  self:destroy()
end

return Bullet
