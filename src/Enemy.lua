local Enemy = classes.class()

local nextId = ENEMY_STARTING_ID

function Enemy:init(params)
  
  self.id = nextId
  nextId = nextId + 1
  
  params.x = params.x or Model.stage.stageWidth / 2
  params.y = params.y or 0
  
  self.asset = params.asset
  self.speed = params.speed
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  self.x = params.x
  self.y = params.y
  
  self.rateOfFire = params.rateOfFire
  self.fireTimer = 0
  
  self.bulletPool = Pool.new({poolSize = params.bulletPoolSize})
  self:populateBulletPool()
  EventManager:subscribe(ON_BULLET_DESTROYED..tostring(self.id), self)
  
end

function Enemy:update(dt)
  
  self:handleMovement(dt)
  self:handleShooting(dt)
end

function Enemy:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  love.graphics.draw(self.asset, newX, newY)
end

function Enemy:handleMovement(dt)
  
  self.y = (self.y + self.speed * dt) % Model.stage.stageHeight
end

function Enemy:handleShooting(dt)
  
  self.fireTimer = self.fireTimer + dt
  
  if self.rateOfFire > self.fireTimer then
    return
  end
  
  local bullet = self.bulletPool:getObject()
  
  if not bullet then
    return
  end
  
  local xOffset = self.width / 2
  local yOffset = (self.height / 2)
  local x = self.x + xOffset
  local y = self.y + yOffset
  bullet:updatePosition(x, y)
  
  instantiateObjectInScene(bullet)
  
  self.fireTimer = 0
  
end

function Enemy:populateBulletPool()
    
  for i = 1, self.bulletPool:getPoolSize() do
    Model.bulletParams.direction = ENEMY_BULLET_DIRECTION
    Model.bulletParams.parentId = self.id
    local bullet = Bullet.new(Model.bulletParams)
    self.bulletPool:addObject(bullet)
  end
end

function Enemy:onNotify(event, args)
  
  args = args or {}
  
  if event == ON_BULLET_DESTROYED..tostring(self.id) then
    self.bulletPool:returnObject(args)
  end
end

return Enemy