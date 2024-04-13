local Level = classes.class()

function Level:init(params)
  
  self.name = params.name
  self.duration = params.duration
  
  self.scene = nil
end

function Level:enter()
  
  self.scene = {}
  
  local enemy = EnemyFactory.createEnemy(BASE_ENEMY)
  self:addObject(enemy)
end

function Level:update(dt)
  
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
end

function Level:exit()
  
  for i = 1, #self.scene do
    self.scene[i] = nil
  end
  
  self.scene = nil
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

return Level