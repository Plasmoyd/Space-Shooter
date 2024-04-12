local ParticleSystem = classes.class()

function ParticleSystem.playParticle(asset, duration, xLocation, yLocation)

  local particle = Particle.new({asset = asset, duration = duration, x = xLocation, y = yLocation})
  instantiateObjectInScene(particle)
end

return ParticleSystem