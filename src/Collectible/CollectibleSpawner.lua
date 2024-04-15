local CollectibleSpawner = classes.class()

function CollectibleSpawner:init(params)
  
  self.collectibleTypes = params.collectibleTypes
  self.spawnRate = params.spawnRate
  self.timer = 0
end

function CollectibleSpawner:update(dt)
  
  self.timer = self.timer + dt
  
  if self.timer >= self.spawnRate then
    self:spawn()
    self.timer = 0
  end
end

function CollectibleSpawner:spawn()
  
  local collectibleType = self.collectibleTypes[math.random(#self.collectibleTypes)]
  local collectible = Collectible.new({
    x = math.random(0, Model.stage.stageWidth),
    y = 0,
    value = math.random(50),
    asset = collectibleType.asset,
    type = collectibleType.type,
    speed = Model.collectibleParams.speed,
    collisionChannel = Model.collectibleParams.collisionChannel
  })

  instantiateObjectInScene(collectible)
end

return CollectibleSpawner