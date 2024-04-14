--class responsible for playing a particle effect for a certain duration at a certain location
local ParticleSystem = classes.class()

function ParticleSystem.playParticle(asset, duration, xLocation, yLocation)

  local particle = Particle.new({asset = asset, duration = duration, x = xLocation, y = yLocation})
  instantiateObjectInScene(particle)
end

return ParticleSystem