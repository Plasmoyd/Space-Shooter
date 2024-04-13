local LevelManager = classes.class()

local ship = nil
local collisionManager = nil

function LevelManager:init(params)
  
  
  self.currentLevel = nil
  self.numberOfLevels = #params
  
  self.currentIndex = 0
  self:changeLevel()
  
  ship = ShipCls.new(Model.shipParams)
  self:addObjectToCurrentLevel(ship)
  
  collisionManager = CollisionManager.new(Model.collisionHandlers)
end

function LevelManager:update(dt)
  
  if self.currentLevel then
    self.currentLevel:update(dt)
    collisionManager:checkCollisions(self.currentLevel.scene)
  end
end

function LevelManager:draw()
  
  if self.currentLevel then
    self.currentLevel:draw()
  end
end

function LevelManager:changeLevel()
  
  if self.currentLevel then
    self:removeObjectFromCurrentLevel(ship)
    self.currentLevel:exit()
  end
  
  self.currentIndex = self.currentIndex + 1
  
  if self.currentIndex <= self.numberOfLevels then
    self.currentLevel = LevelLoader.loadLevel(self.currentIndex)
  else
    print("Congratulations, you beat the game!")
    return
  end
  
  if self.currentLevel then
    self.currentLevel:enter()
    self:addObjectToCurrentLevel(ship)
  end
end

function LevelManager:addObjectToCurrentLevel(object)
  self.currentLevel:addObject(object)
end

function LevelManager:removeObjectFromCurrentLevel(object)
  self.currentLevel:removeObject(object)
end

return LevelManager