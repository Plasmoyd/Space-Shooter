local ComponentFactory = classes.class()

function ComponentFactory.createComponent(componentType, params)

  local component = nil
  
  if componentType == HEALTH_COMPONENT then
    component = HealthComponent.new(params)
  end
  
  return component
end

return ComponentFactory