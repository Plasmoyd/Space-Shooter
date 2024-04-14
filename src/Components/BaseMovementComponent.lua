local BaseMovementComponent = classes.class(Component)

function BaseMovementComponent:init(params)
  self.speed = params.speed or 200
end

-- Handles the vertical movement of an entity
function BaseMovementComponent:handleMovement(xPosition, yPosition, dt)
  
  local x = xPosition
  local y = yPosition
  
  -- Update the y position based on the speed and delta time
  y = (y + self.speed * dt)
  
  -- Return the updated position as a table
  return {xPosition = x, yPosition = y}
  
end

return BaseMovementComponent