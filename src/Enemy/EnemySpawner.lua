local EnemySpawner = classes.class()

function EnemySpawner:init(params)
  
  self.enemyType = params.type
  self.spawnRate = params.spawnRate
  self.maxEnemies = params.count
  
  self.enemiesKilled = 0
  self.timer = 0
  self.shouldSpawn = true
  
  self.pool = Pool.new({poolSize = (self.maxEnemies / 2)})
  self:populatePool()
end

function EnemySpawner:update(dt)
  
  self.timer = self.timer + dt
  
  if self.
  shouldSpawn and self.timer >= self.spawnRate then
    
    local enemy = self.pool:getObject()
    instantiateObjectInScene(enemy)
    self.timer = 0
  end
end

function EnemySpawner:populatePool()
  
  for i = 1, self.pool:getPoolSize() do
    local enemy = EnemyFactory.createEnemy(self.enemyType)
    self.pool:addObject(enemy)
    EventManager.subscribe(enemy.enemyDestroyedEvent, self)
  end
end

function EnemySpawner:onNotify(event, args)
  
  args = args or {}
  
  if not event then
    return
  end
  
  if event.type == ON_ENEMY_DESTROYED then
    
    self.pool:returnObject(args)
    self.enemiesKilled = self.enemiesKilled + 1
    
    if self.enemiesKilled == self.maxEnemies then
      
      shouldSpawn = false
    end
  end
  
end

return EnemySpawner