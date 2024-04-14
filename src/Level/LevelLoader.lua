--Factory class responsible for loading the level from the model and creating an instance of the level
local LevelLoader = classes.class()

function LevelLoader.loadLevel(index)
  
  local levelConfig = Model.levels[index]
  
  if not levelConfig then
    return nil
  end
  
  return Level.new({name = levelConfig.name, duration = levelConfig.duration, enemies = levelConfig.enemies})
end

return LevelLoader