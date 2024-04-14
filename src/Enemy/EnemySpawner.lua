--this class is responsible for spawning a certain type of enemy into the level, based on level configurations
local EnemySpawner = classes.class()

function EnemySpawner:init(params)
  
  -- Type of enemy this spawner will create
  self.enemyType = params.type
  -- time intervl between spawns
  self.spawnRate = params.spawnRate
  self.maxEnemies = params.count
  
  -- counter for the number of enemies killed
  self.enemiesKilled = 0
  -- Timer to track the spawn timing
  self.timer = 0
  -- Flag to control spawning logic
  self.shouldSpawn = true
  
  -- Create a pool to manage enemy instances efficiently
  self.pool = Pool.new({poolSize = (self.maxEnemies / 2)})
  self:populatePool()
  
  -- Event triggered when all enemies from this spawner are defeated
  self.spawnerCompleteEvent = Event.new({sender = self, type = ON_SPAWNER_COMPLETE})
end

function EnemySpawner:update(dt)
  
  -- Increment the timer
  self.timer = self.timer + dt
  
  -- Check if it's time to spawn a new enemy
  if self.shouldSpawn and self.timer >= self.spawnRate then
    
    -- Retrieve an enemy from the pool
    local enemy = self.pool:getObject()
    -- Add the enemy to the scene
    instantiateObjectInScene(enemy)
    -- Reset the timer after spawning an enemy
    self.timer = 0
  end
end

-- Populates the enemy pool
function EnemySpawner:populatePool()
  
  for i = 1, self.pool:getPoolSize() do
    -- Create an enemy using the factory
    local enemy = EnemyFactory.createEnemy(self.enemyType)
    -- Add the enemy to the pool
    self.pool:addObject(enemy)
    -- Subscribe to the enemy's destruction event
    EventManager:subscribe(enemy.enemyDestroyedEvent, self)
  end
end

-- Handler for notifications
function EnemySpawner:onNotify(event, args)
  
  args = args or {}
  
  if not event then
    return
  end
  
  if event.type == ON_ENEMY_DESTROYED then
    
    self.pool:returnObject(args)
    args:resetValues()
    self.enemiesKilled = self.enemiesKilled + 1
    
    if self.enemiesKilled == self.maxEnemies then
      
      self.shouldSpawn = false
      EventManager:notify(self.spawnerCompleteEvent, self)
    end
  end
  
end

return EnemySpawner