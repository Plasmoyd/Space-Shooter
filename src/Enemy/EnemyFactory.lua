local EnemyFactory = classes.class()

function EnemyFactory:init(params)
  
end

function EnemyFactory.createEnemy(enemyType)
 
  if not Model.enemyType[enemyType] then
    print("You are trying to create an enemy type that doesn't exist!")
    return
  end
  
  local components = {}
  
  local componentsInfo = Model.enemyType[enemyType].components
  
  for i = 1, #componentsInfo do
    
    local componentType = componentsInfo[i].class
    local componentParams = componentsInfo[i].params
  
    local component = ComponentFactory.createComponent(componentType, componentParams)
    if component then
      components[componentType] = component
    end
  end
  
  Model.enemyParams.components = components
  
  local enemy = Enemy.new(Model.enemyParams)
  
  return enemy;
end

return EnemyFactory