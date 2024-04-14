local Enemy = classes.class()

function Enemy:init(params)
  
  params.x = params.x or Model.stage.stageWidth / 2
  params.y = params.y or 0
  
  self.asset = params.asset
  self.explosionAsset = params.explosionAsset
  self.explosionDuration = params.explosionDuration
  --self.speed = params.speed
  self.width = self.asset:getWidth()
  self.height = self.asset:getHeight()
  self.x = params.x
  self.y = params.y
  
  self.rateOfFire = params.rateOfFire
  self.fireTimer = 0
  
  self.collisionChannel = params.collisionChannel
  
  self.bulletPool = Pool.new({poolSize = params.bulletPoolSize})
  self:populateBulletPool()
  
  self.components = params.components or {}
  
  --finding a reference to movement component
  for _, component in pairs(self.components) do
    if component.handleMovement then
      self.movementComponent = component
      break
    end
  end
  
  if self.components[HEALTH_COMPONENT] then
    
    EventManager:subscribe(self.components[HEALTH_COMPONENT].onHealthZero, self)
  end
  
  self.enemyDestroyedEvent = Event.new({sender = self, type = ON_ENEMY_DESTROYED})
  
end

function Enemy:update(dt)
  
  self:handleMovement(dt)
  self:handleShooting(dt)
  
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
  
end

function Enemy:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  love.graphics.draw(self.asset, newX, newY)
end

function Enemy:handleMovement(dt)
  
  --self.y = (self.y + self.speed * dt) % Model.stage.stageHeight
  if not self.movementComponent then
    return
  end
  
  local positionVector = self.movementComponent:handleMovement(self.x, self.y, dt)
  
  self.x = positionVector.xPosition
  self.y = positionVector.yPosition
  
  if not self:isOnScreen() then
    self:destroy()
  end
  
end

function Enemy:isOnScreen()
  
  return self.y <= Model.stage.stageHeight
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
  local yOffset = (self.height)
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
    EventManager:subscribe(bullet.bulletDestroyedEvent, self)
  end
end

function Enemy:onNotify(event, args)
  
  args = args or {}
  
  if not event then
    return
  end
  
  if event.type == ON_BULLET_DESTROYED then
    
    self.bulletPool:returnObject(args)
    
  elseif event.type == ON_HEALTH_ZERO then
    self:destroy()
    
  end
end

function Enemy:addComponent(component)
  if component then
    table.insert(self.components, component)
  end
end

function Enemy:handleCollision(args)
  
  
  local collisionObject = args.collidedWith
  
  if not collisionObject then
    return
  end
  
  local healthComponent = self.components[HEALTH_COMPONENT]
  
  if healthComponent then
    
    ParticleSystem.playParticle(self.explosionAsset, self.explosionDuration, self.x, self.y)
    
    if collisionObject.collisionChannel == BULLET_COLLISION_TYPE then
    
      healthComponent:takeDamage(collisionObject.damage)
    elseif collisionObject.collisionChannel == SHIP_COLLISION_TYPE then
      
      healthComponent:takeDamage(healthComponent.maxHealth)
    end
  end
end

function Enemy:destroy()
  removeObjectFromScene(self)
  EventManager:notify(self.enemyDestroyedEvent, self)
end

function Enemy:resetValues()
  
  local healthComponent = self.components[HEALTH_COMPONENT]
  if healthComponent then 
    healthComponent:heal(healthComponent.maxHealth)
  end
  
  self.y = 0
  self.x = Model.stage.stageWidth / 2
  
end

return Enemy