
local Collectible = classes.class()

Collectible.coinCollectedEvent = Event.new({type = ON_COIN_COLLECTED})

function Collectible:init(params)
  
  self.x = params.x
  self.y = params.y
  self.asset = params.asset
  
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  
  -- Type of collectible
  self.type = params.type
  -- Value of the collectible (could be score or health points)
  self.value = params.value
  -- Movement speed of the collectible.
  self.speed = params.speed
  -- Collision channel to identify what the collectible can interact with
  self.collisionChannel = params.collisionChannel
end

function Collectible:update(dt)
  self.y = (self.y + self.speed * dt)
end

function Collectible:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  
  love.graphics.draw(self.asset, newX, newY)
end

--Handles collision with other objects
function Collectible:handleCollision(args)
  --if the collectible is a coin, send an event that a coin has been collected
  if self.type == COIN then
    EventManager:notify(Collectible.coinCollectedEvent, self.value)
  end
  self:destroy()
end

-- Destroy the collectible, removing it from the scene and cleaning up resources
function Collectible:destroy()
  removeObjectFromScene(self)
  self = nil
end

return Collectible