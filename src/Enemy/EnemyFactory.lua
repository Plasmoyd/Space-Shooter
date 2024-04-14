--Enemy factory responsible for instantiating an enemy based on a provided type
local EnemyFactory = classes.class()

function EnemyFactory:init(params)
  
end

-- Static method to create an enemy based on a specified type
function EnemyFactory.createEnemy(enemyType)
 
  -- Check if the specified enemy type exists in the Model's enemy type definitions
  if not Model.enemyType[enemyType] then
    print("You are trying to create an enemy type that doesn't exist!")
    return
  end
  
  -- Retrieve the component configuration for the specified enemy type from the model
  local components = {}
  local componentsInfo = Model.enemyType[enemyType].components
  
  -- Iterate through each component configuration, create the component, and add it to the components table
  for i = 1, #componentsInfo do
    
    local componentType = componentsInfo[i].class
    local componentParams = componentsInfo[i].params
  
    -- Use the ComponentFactory to create components based on the specified type and parameters
    local component = ComponentFactory.createComponent(componentType, componentParams)
    if component then
      components[componentType] = component
    end
  end
  
  -- Assign the assembled components to the enemy parameters
  Model.enemyParams.components = components
  
  -- Create a new enemy using the configured parameters which now include the specific components
  local enemy = Enemy.new(Model.enemyParams)
  
  -- Return the newly created enemy instance
  return enemy;
end

return EnemyFactory