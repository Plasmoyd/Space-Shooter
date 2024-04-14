local ComponentFactory = classes.class()

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