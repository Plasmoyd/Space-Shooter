--particle effect that is being played for a certain duration, before being destroyed
local Particle = classes.class()

function Particle:init(params)
  
  self.asset = params.asset
  self.duration = params.duration
  self.x = params.x
  self.y = params.y
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  
  self.timer = 0
end

function Particle:update(dt)
  
  self.timer = self.timer + dt
  
  if self.timer >= self.duration then
    
    self:destroy()
  end
end

function Particle:draw()
  
  local newX = self.x - (self.width/2)
  local newY = self.y - (self.height/2)
  love.graphics.draw(self.asset, newX, newY)
end

function Particle:destroy()
  
  removeObjectFromScene(self)
  self = nil
end

return Particle

