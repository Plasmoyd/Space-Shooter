--A player controlled class
local Ship = classes.class()

--ShipCls.coinCollectedEvent = Event.new({type = ON_COIN_COLLECTED})

function Ship:init(params)
    --populating ship attributes from the parameters
    self.speed = params.speed
    self.asset = params.asset
    self.explosionAsset = params.explosionAsset
    self.explosionDuration = params.explosionDuration
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight
    self.width = self.asset:getWidth()
    self.height = self.asset:getHeight()
    
    self.rateOfFire = params.rateOfFire
    self.fireTimer = params.rateOfFire
    
    -- Collision channel to determine interactions with other objects
    self.collisionChannel = params.collisionChannel
    
    self.bulletPool = Pool.new({ poolSize = params.bulletPoolSize})
    self:populateBulletPool()
    
    --uses component pattern for additional functionality
    self.components = {}
    self:populateComponents(params.components)
    
    -- subscribe to the health zero event if the ship has a health component.
    if self.components[HEALTH_COMPONENT] then
      EventManager:subscribe(self.components[HEALTH_COMPONENT].onHealthZero, self)
    end
    
    EventManager:subscribe(onSpacebarPressed, self)
end

-- Populates the components of the ship based on the configuration provided
function Ship:populateComponents(componentsInfo)
    
    for i = 1, #componentsInfo do
      
      local componentType = componentsInfo[i].class
      local componentParams = componentsInfo[i].params
    
      local component = ComponentFactory.createComponent(componentType, componentParams)
      if component then
        self.components[componentType] = component
      end
    end
end


function Ship:update(dt)

    self:handleMovement(dt)
    self:handleTimer(dt)
    
    -- Update each component
    for _, component in pairs(self.components) do
      if component.update then
        component:update(dt)
      end
    end
    
end

-- Handles the movement of the ship based on player inputs
function Ship:handleMovement(dt)
    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down

    --direction to move on x-axis
    local xDirection = 0
    --direction to move on y-axis
    local yDirection = 0

    if left then
        xDirection = xDirection + -1
    end
    if right then
        xDirection = xDirection + 1
    end

    if up then
        yDirection = yDirection + -1
    end
    if down then
        yDirection = yDirection + 1
    end

    --here I'm normalizing the movement vector in order to have a consistent movement speed regardless of the direction the ship is moving in.
    --as it was previously implemented, the ship was moving faster while moving diagonally compared to moving horizontally or vertically, because the magnitude of the vector was higher than 1
    movementVector = normalizeVector({x = xDirection, y = yDirection})

    --ship can now move only within the borders of the screen
    self.x = clamp(self.x + (movementVector.x * self.speed * dt), self.width / 2, Model.stage.stageWidth - self.width / 2)
    self.y = clamp(self.y + (movementVector.y * self.speed * dt), self.height / 2, Model.stage.stageHeight - self.height / 2)
end

-- Draw the ship on the screen.
function Ship:draw()
    local newX = self.x - (self.width/2)
    local newY = self.y - (self.height/2)
    love.graphics.draw(self.asset, newX,newY )
    
    love.graphics.setFont(AssetsManager.fonts.spaceFont)
    love.graphics.print("Health: " ..self.components[HEALTH_COMPONENT].currentHealth, Model.stage.stageWidth - 120, 10)
end

-- Responds to notifications from the EventManager
function Ship:onNotify(event, args)
  
    args = args or {}
    
    if not event then
      return
    end
    
    if event.type == ON_SPACEBAR_PRESSED then
        self:shoot()
    elseif event.type == ON_BULLET_DESTROYED then
        self.bulletPool:returnObject(args)
    elseif event.type == ON_HEALTH_ZERO then
      EventManager:notify(gameOverEvent)
      self:destroy()
    end
      
end

-- Conrols the ship's firing mechanism
function Ship:shoot()
  
    if self.rateOfFire > self.fireTimer then
      return
    end
    
    local bullet = self.bulletPool:getObject()
    
    if not bullet then
      return
    end
    
    local yOffset = (self.height / 2)
    local x = self.x
    local y = self.y - yOffset
    bullet:updatePosition(x, y)
    instantiateObjectInScene(bullet)
    
    self.fireTimer = 0
end

function Ship:handleTimer(dt)
    self.fireTimer = self.fireTimer + dt
end

-- Populates the bullet pool with pre-instantiated bullet objects
function Ship:populateBulletPool()
    for i = 1, self.bulletPool:getPoolSize() do
      Model.bulletParams.direction = PLAYER_BULLET_DIRECTION
      local bullet = Bullet.new(Model.bulletParams)
      self.bulletPool:addObject(bullet)
      EventManager:subscribe(bullet.bulletDestroyedEvent, self)
    end
end

-- Handles collision events
function Ship:handleCollision(args)
  
    local collisionObject = args.collidedWith
    
    if not collisionObject then
      return
    end
    
    local healthComponent = self.components[HEALTH_COMPONENT]
    
    if not healthComponent then
      return
    end
    
    if collisionObject.collisionChannel == COLLECTIBLE_COLLISION_TYPE then
      
      if collisionObject.type == HEALTH_PACK then
        
        healthComponent:heal(collisionObject.value)
      elseif collisionObject.type == COIN then
        
        --EventManager:notify(ShipCls.coinCollectedEvent, collisionObject.value)
      end
    
      return
    end
    
    ParticleSystem.playParticle(self.explosionAsset, self.explosionDuration, self.x, self.y)
      
    if collisionObject.collisionChannel == BULLET_COLLISION_TYPE then
      
      healthComponent:takeDamage(collisionObject.damage)
    elseif collisionObject.collisionChannel == ENEMY_COLLISION_TYPE then
        
      healthComponent:takeDamage(healthComponent.maxHealth)
    end
end

-- Destroys the ship and cleans up resources
function Ship:destroy()
  
  removeObjectFromScene(self)
  EventManager:unsubscribeAll(self)
  self = nil
end

return Ship