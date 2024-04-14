local SinusoidalMovementComponent = classes.class(BaseMovementComponent)

function SinusoidalMovementComponent:init(params)
  
  -- Speed of vertical movement
  self.speed = params.speed or 200
  
  -- Amplitude of the sinusoidal movement, controlling the horizontal deviation
  self.amplitude = params.amplitude or 100
  
  -- Frequency of the sinusoidal movement, affecting the rapidity of wave oscillations
  self.frequency = params.frequency or 1
  
  -- Initial phase of the sinusoidal movement, allowing phase shifting of the wave pattern
  self.phase = params.phase or 0
  
  -- Center x-position around which the sinusoidal movement oscillates
  self.xCenter = params.xCenter or Model.stage.stageWidth / 2
end

function SinusoidalMovementComponent:handleMovement(xPosition, yPosition, dt)
  
  local y = yPosition
  local x = xPosition
  
  -- Update the y position based on the speed and delta time
  y = (y + self.speed * dt)
  
  -- Update the phase of the sinusoidal movement based on the frequency and delta time
  self.phase = self.phase + self.frequency * dt
  
  -- Calculate the new x position based on the sinusoidal formula
  x = self.xCenter + self.amplitude * math.sin(self.phase)
  
  -- Return the updated position as a table
  return {xPosition = x, yPosition = y}
end

return SinusoidalMovementComponent