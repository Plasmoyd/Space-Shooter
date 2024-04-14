local Level = classes.class()

Level.levelCompleteEvent = Event.new({type = ON_LEVEL_COMPLETE})

function Level:init(params)
  
  self.name = params.name
  self.duration = params.duration
  
  self.scene = nil
  
  self.spawnersComplete = 0
  self.spawners = {}
  for i = 1, #params.enemies do
    
    local spawner = EnemySpawner.new({type = params.enemies[i].type, count = params.enemies[i].count, spawnRate = params.enemies[i].spawnRate})
    table.insert(self.spawners, spawner)
    EventManager:subscribe(spawner.spawnerCompleteEvent, self)
  end
  
end

function Level:enter()
  
  self.scene = {}
  
  --local enemy = EnemyFactory.createEnemy(BASE_ENEMY)
  --self:addObject(enemy)
end

function Level:update(dt)
  
  for i = 1, #self.spawners do
    if self.spawners[i] and self.spawners[i].update then
      self.spawners[i]:update(dt)
    end
  end
  
  for i = 1, #self.scene do
    if self.scene[i] and self.scene[i].update then
      self.scene[i]:update(dt)
    end
  end
  
end

function Level:draw()
  
  for i = 1, #self.scene do
    if self.scene[i].draw then
      self.scene[i]:draw()
    end
  end
  
  love.graphics.setFont(AssetsManager.fonts.spaceFont)
  
  love.graphics.print(self.name, (Model.stage.stageWidth / 2) - 40, 10)
end

function Level:exit()
  
  for i = 1, #self.scene do
    self.scene[i] = nil
  end
  
  --self.scene = nil
end

function Level:addObject(object)
  
  if self.scene then
    table.insert(self.scene, object)
  end
end

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