local Enemy = classes.class()

function Enemy:init(params)
  
  params.x = params.x or Model.stage.stageWidth / 2
  params.y = params.y or 0
  
  self.asset = params.asset
  self.speed = params.speed
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  self.x = params.x
  self.y = params.y
end

function Enemy:update(dt)
  
  self:handleMovement(dt)
end

function Enemy:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  love.graphics.draw(self.asset, newX, newY)
end

function Enemy:handleMovement(dt)
  
  self.y = (self.y + self.speed * dt) % Model.stage.stageHeight
end

return Enemy