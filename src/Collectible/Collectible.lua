
local Collectible = classes.class()

Collectible.coinCollectedEvent = Event.new({type = ON_COIN_COLLECTED})

function Collectible:init(params)
  
  self.x = params.x
  self.y = params.y
  self.asset = params.asset
  
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  
  self.type = params.type
  self.value = params.value
  self.speed = params.speed
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

function Collectible:handleCollision(args)
  if self.type == COIN then
    EventManager:notify(Collectible.coinCollectedEvent, self.value)
  end
  self:destroy()
end

function Collectible:destroy()
  removeObjectFromScene(self)
  self = nil
end

return Collectible