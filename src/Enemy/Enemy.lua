local Enemy = classes.class()

-- Static event for notifying when any enemy is destroyed
Enemy.onAnyEnemyDestroyed = Event.new({type = ON_ANY_ENEMY_DESTROYED})

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
  
  self.score = params.score
  
  --Collision channel for registering collisions
  self.collisionChannel = params.collisionChannel
  
  -- Bullet management for the enemy
  self.bulletPool = Pool.new({poolSize = params.bulletPoolSize})
  self:populateBulletPool()
  
  --Implementation of component pattern, which allows us to have multiple enemy types by mixing and matching components. This way, we don't have to use inheritance
  self.components = params.components or {}
  
  --finding a reference to movement component
  for _, component in pairs(self.components) do
    if component.handleMovement then
      self.movementComponent = component
      break
    end
  end
  
  if self.components[HEALTH_COMPONENT] then
    -- subscribe to the health zero event if the enemy has a health component
    EventManager:subscribe(self.components[HEALTH_COMPONENT].onHealthZero, self)
  end
  
  -- Custom event triggered when this enemy is destroyed
  self.enemyDestroyedEvent = Event.new({sender = self, type = ON_ENEMY_DESTROYED})
  
end

function Enemy:update(dt)
  
  -- Handle movement and shooting
  self:handleMovement(dt)
  self:handleShooting(dt)
  
  -- Update all components
  for _, component in pairs(self.components) do
    if component.update then
      component:update(dt)
    end
  end
  
end

-- Draw the enemy
function Enemy:draw()
  
  local newX = self.x - (self.width / 2)
  local newY = self.y - (self.height / 2)
  love.graphics.draw(self.asset, newX, newY)
end

-- Movement handling method
function Enemy:handleMovement(dt)
  
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

--checks if enemy has passed the bottom edge of the screen
function Enemy:isOnScreen()
  
  return self.y <= Model.stage.stageHeight
end

-- Manage the shooting mechanism based on the fire rate
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

-- Populate the bullet pool with bullet objects
function Enemy:populateBulletPool()
    
  for i = 1, self.bulletPool:getPoolSize() do
    Model.bulletParams.direction = ENEMY_BULLET_DIRECTION
    Model.bulletParams.parentId = self.id
    local bullet = Bullet.new(Model.bulletParams)
    self.bulletPool:addObject(bullet)
    EventManager:subscribe(bullet.bulletDestroyedEvent, self)
  end
end

--Handling events from EventManager
function Enemy:onNotify(event, args)
  
  args = args or {}
  
  if not event then
    return
  end
  
  if event.type == ON_BULLET_DESTROYED then
    
    self.bulletPool:returnObject(args)
    
  elseif event.type == ON_HEALTH_ZERO then
    EventManager:notify(Enemy.onAnyEnemyDestroyed, self)
    self:destroy()
  end
end

--helper function for adding a component
function Enemy:addComponent(component)
  if component then
    table.insert(self.components, component)
  end
end

--Function responsible for handling collision
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

-- Destroy the enemy
function Enemy:destroy()
  removeObjectFromScene(self)
  EventManager:notify(self.enemyDestroyedEvent, self)
end

-- Reset enemy properties to initial values
function Enemy:resetValues()
  
  local healthComponent = self.components[HEALTH_COMPONENT]
  if healthComponent then 
    healthComponent:heal(healthComponent.maxHealth)
  end
  
  self.y = 0
  self.x = Model.stage.stageWidth / 2
  
end

return Enemy