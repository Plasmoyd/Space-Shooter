--Level class
local Level = classes.class()

--Event to notify when any level is complete
Level.levelCompleteEvent = Event.new({type = ON_LEVEL_COMPLETE})

function Level:init(params)
  
  --load level attributes
  self.name = params.name
  
  --not used in current implementation, but can be easily supported
  self.duration = params.duration
  
  --scene container where all game objects for this level will be stored
  self.scene = nil
  
  --spawn rate for collectibles in this level
  self.collectibleSpawnRate = params.collectibleSpawnRate or 10
  
  -- Counter to track how many spawners have completed their spawning
  self.spawnersComplete = 0
  
  --initialize spawners based on the enemies configuration passed in params
  self.spawners = {}
  for i = 1, #params.enemies do
    
    local spawner = EnemySpawner.new({type = params.enemies[i].type, count = params.enemies[i].count, spawnRate = params.enemies[i].spawnRate})
    table.insert(self.spawners, spawner)
    EventManager:subscribe(spawner.spawnerCompleteEvent, self)
  end
  
  self.collectibleSpawner = CollectibleSpawner.new({collectibleTypes = Model.collectibleTypes, spawnRate = self.collectibleSpawnRate})
  
end

-- Called when the level is entered, sets up the scene
function Level:enter()
  
  self.scene = {}
  
end

--updte function for the level
function Level:update(dt)
  
  for i = 1, #self.spawners do
    if self.spawners[i] and self.spawners[i].update then
      self.spawners[i]:update(dt)
    end
  end
  
  if self.collectibleSpawner and self.collectibleSpawner.update then
    
    self.collectibleSpawner:update(dt)
  end
  
  for i = 1, #self.scene do
    if self.scene[i] and self.scene[i].update then
      self.scene[i]:update(dt)
    end
  end
  
end

--draw function for the level
function Level:draw()
  
  for i = 1, #self.scene do
    if self.scene[i].draw then
      self.scene[i]:draw()
    end
  end
  
  love.graphics.setFont(AssetsManager.fonts.spaceFont)
  
  love.graphics.print(self.name, (Model.stage.stageWidth / 2) - 40, 10)
end

-- Called when the level is exited, cleans up the scene.
function Level:exit()
  
  for i = 1, #self.scene do
    self.scene[i] = nil
  end
end

-- Adds an object to the scene
function Level:addObject(object)
  
  if self.scene then
    table.insert(self.scene, object)
  end
end

--removes an object from the scene
function Level:removeObject(object)
  
  if not self.scene then
    return
  end
    
  for i = 1, #self.scene do
    if self.scene[i] == object then
      table.remove(self.scene, i)
      return
    end
  end
end

--handle notifications from EventManager
function Level:onNotify(event, args)
  
  args = args or {}
  
  if not event then 
    return
  end
  
  if event.type == ON_SPAWNER_COMPLETE then
    
    self.spawnersComplete = self.spawnersComplete + 1
    
    if self.spawnersComplete == #self.spawners then
      
      EventManager:notify(Level.levelCompleteEvent)
    end
  end
end

return Level