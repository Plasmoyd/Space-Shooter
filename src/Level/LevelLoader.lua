local LevelLoader = classes.class()

function LevelLoader.loadLevel(index)
  
  local levelConfig = Model.levels[index]
  
  if not levelConfig then
    return nil
  end
  
  return Level.new({name = levelConfig.name, duration = levelConfig.duration, enemies = levelConfig.enemies})
end

return LevelLoader