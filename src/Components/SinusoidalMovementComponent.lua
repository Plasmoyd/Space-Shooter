local SinusoidalMovementComponent = classes.class(BaseMovementComponent)

function SinusoidalMovementComponent:init(params)
  
  self.speed = params.speed or 200
  self.amplitude = params.amplitude or 100
  self.frequency = params.frequency or 1
  self.phase = params.phase or 0
  self.xCenter = params.xCenter or Model.stage.stageWidth / 2
end

function SinusoidalMovementComponent:handleMovement(xPosition, yPosition, dt)
  
  local y = yPosition
  local x = xPosition
  
  y = (y + self.speed * dt)
  
  self.phase = self.phase + self.frequency * dt
  
  x = self.xCenter + self.amplitude * math.sin(self.phase)
  
  return {xPosition = x, yPosition = y}
end

return SinusoidalMovementComponent