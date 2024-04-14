local BaseMovementComponent = classes.class(Component)

function BaseMovementComponent:init(params)
  self.speed = params.speed or 200
end

function BaseMovementComponent:handleMovement(xPosition, yPosition, dt)
  
  local x = xPosition
  local y = yPosition
  
  y = (y + self.speed * dt) --% Model.stage.stageHeight
  
  return {xPosition = x, yPosition = y}
  
end

return BaseMovementComponent