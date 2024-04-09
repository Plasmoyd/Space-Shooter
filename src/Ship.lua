local Ship = classes.class()

function Ship:init(params)
    print("Ship init!")
    self.id = PLAYER_ID
    self.speed = params.speed
    self.asset = params.asset
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.width = self.asset:getWidth()
    self.height = self.asset:getHeight()
    
    self.rateOfFire = params.rateOfFire
    self.fireTimer = params.rateOfFire
    
    self.collisionChannel = SHIP_COLLISION_TYPE
    
    self.bulletPool = Pool.new({ poolSize = params.bulletPoolSize})
    self:populateBulletPool()
    
    EventManager:subscribe(onSpacebarPressed, self)
end

function Ship:update(dt)

    self:handleMovement(dt)
    self:handleTimer(dt)
    
end

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

function Ship:draw()
    local newX = self.x - (self.width/2)
    local newY = self.y - (self.height/2)
    love.graphics.draw(self.asset, newX,newY )
end

function Ship:onNotify(event, args)
  
    args = args or {}
    
    if not event then
      return
    end
    
    if event.type == ON_SPACEBAR_PRESSED then
        self:shoot()
    elseif event.type == ON_BULLET_DESTROYED then
        self.bulletPool:returnObject(args)
    end
      
end

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

function Ship:populateBulletPool()
    for i = 1, self.bulletPool:getPoolSize() do
      Model.bulletParams.direction = PLAYER_BULLET_DIRECTION
      local bullet = Bullet.new(Model.bulletParams)
      self.bulletPool:addObject(bullet)
      EventManager:subscribe(bullet.bulletDestroyedEvent, self)
    end
end

function Ship:handleCollision(args)
  print("Ship Collision!")
end

return Ship