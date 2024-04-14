--LevelManager is a class responsible for managing game levels
local LevelManager = classes.class()

function LevelManager:init(params)
  
  
  self.currentLevel = nil
  self.numberOfLevels = #params
  
  --starting the first level
  self.currentIndex = 0
  self:changeLevel()
  
  --instantiating a ship and adding it to current level.
  --ship is instantiated here because we want it's data to persist between levels
  self.ship = ShipCls.new(Model.shipParams)
  self:addObjectToCurrentLevel(self.ship)
  
  --Score manager for keeping score of this playthrough
  self.scoreManager = ScoreManager.new()
  
  self.collisionManager = CollisionManager.new(Model.collisionHandlers)
  
  --subscribing to level complete event
  EventManager:subscribe(Level.levelCompleteEvent, self)
end

-- Updates the current level and the collision manager each frame.
function LevelManager:update(dt)
  
  if self.currentLevel then
    self.currentLevel:update(dt)
    self.collisionManager:checkCollisions(self.currentLevel.scene)
  end
end

--Draws the current level and the score
function LevelManager:draw()
  
  if self.currentLevel and self.currentLevel.draw then
    self.currentLevel:draw()
  end
  
  self.scoreManager:draw()
end

-- Handles the transition to the next level or completes the game if all levels are finished.
function LevelManager:changeLevel()
  
  if self.currentLevel then
    -- Remove the ship from the current level and exit the level.
    self:removeObjectFromCurrentLevel(self.ship)
    self.currentLevel:exit()
  end
  
  -- Move to the next level index.
  self.currentIndex = self.currentIndex + 1
  
  -- Check if there are more levels to load.
  if self.currentIndex <= self.numberOfLevels then
    self.currentLevel = LevelLoader.loadLevel(self.currentIndex)
  else
    -- Notify that the game is complete if there are no more levels.
    EventManager:notify(gameCompleteEvent)
    return
  end
  
  if self.currentLevel then
    -- Enter the new level and add the ship to it.
    self.currentLevel:enter()
    self:addObjectToCurrentLevel(self.ship)
  end
end

-- Adds an object to the current level.
function LevelManager:addObjectToCurrentLevel(object)
  self.currentLevel:addObject(object)
end

-- Removes an object from the current level.
function LevelManager:removeObjectFromCurrentLevel(object)
  self.currentLevel:removeObject(object)
end

-- Handles notifications for level completion.
function LevelManager:onNotify(event, args)
  
  args = args or {}
  
  if not event then
    return
  end
  
  print("Event received in LevelManager:", event.type)
  
  if event.type == ON_LEVEL_COMPLETE then
    print("Level complete event detected, changing level.")
    self:changeLevel()
  else
    print("Received different event type: ", event.type)
  end
end

-- Cleans up the LevelManager
function LevelManager:destroy()
  EventManager:unsubscribeAll(self)
  self.ship:destroy()
  self.ship = nil
  self.scoreManager:destroy()
  self.scoreManager = nil
  self = nil
end

return LevelManager