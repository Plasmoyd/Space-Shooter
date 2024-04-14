--ComponentFactory is a factory that creates an instance of the component and returns it based on the component type and parameters
local ComponentFactory = classes.class()

-- Static method to create components based on the specified type and parameters
function ComponentFactory.createComponent(componentType, params)

  local component = nil
  
  if componentType == HEALTH_COMPONENT then
    component = HealthComponent.new(params)
  elseif componentType == BASE_MOVEMENT_COMPONENT then
    component = BaseMovementComponent.new(params)
  elseif componentType == SINUSOIDAL_MOVEMENT_COMPONENT then
    component = SinusoidalMovementComponent.new(params)
  end
  
  return component
end

return ComponentFactory