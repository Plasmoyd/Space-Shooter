local Ship = classes.class()

function Ship:init(params)
    print("Ship init!")
    self.speed = params.speed
    self.asset = params.asset
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.rateOfFire = params.rateOfFire
    self.fireTimer = params.rateOfFire
    
    self.bulletPool = Pool:new(params.bulletPoolSize)
    self:populateBulletPool()
    
    EventManager:subscribe(ON_SPACEBAR_PRESSED, self)
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
    self.x = clamp(self.x + (movementVector.x * self.speed * dt), self.w / 2, Model.stage.stageWidth - self.w / 2)
    self.y = clamp(self.y + (movementVector.y * self.speed * dt), self.h / 2, Model.stage.stageHeight - self.h / 2)
end

function Ship:draw()
    local newX = self.x - (self.w/2)
    local newY = self.y - (self.h/2)
    love.graphics.draw(self.asset, newX,newY )
end

function Ship:onNotify(event)
    
    if event == ON_SPACEBAR_PRESSED then
        self:shoot()
    end
end

function Ship:shoot()
  
    if self.rateOfFire > self.fireTimer then
      return
    end
    
    local yOffset = (self.h / 2)
    Model.bulletParams.x = self.x
    Model.bulletParams.y = self.y - yOffset
    local bullet = Bullet.new(Model.bulletParams)
    instantiateObjectInScene(bullet)
    
    self.fireTimer = 0
end

function Ship:handleTimer(dt)
    self.fireTimer = self.fireTimer + dt
end

function Ship:populateBulletPool()
    
    for i = 1, #self.bulletPool.poolSize do
      local bullet = Bullet.new(Model.bulletParams)
      self.bulletPool:AddObject(bullet)
    end
end

return Ship