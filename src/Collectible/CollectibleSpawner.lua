local CollectibleSpawner = classes.class()

function CollectibleSpawner:init(params)
  
  -- List of collectible types that this spawner can create
  self.collectibleTypes = params.collectibleTypes
  
  -- Rate at which collectibles are spawned
  self.spawnRate = params.spawnRate
  
  -- Timer to keep track of time since the last spawn
  self.timer = 0
end

function CollectibleSpawner:update(dt)
  
  self.timer = self.timer + dt
  
  --check if the timer has exceedde the spawn rate, and if it has, spawn a collectible
  if self.timer >= self.spawnRate then
    self:spawn()
    self.timer = 0
  end
end

function CollectibleSpawner:spawn()
  
  --randomly choose which collectible type to spawn
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

  --add collectible to the level scene
  instantiateObjectInScene(collectible)
end

return CollectibleSpawner