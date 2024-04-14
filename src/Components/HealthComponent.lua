local HealthComponent = classes.class(Component)

function HealthComponent:init(params)
  self.maxHealth = params.maxHealth
  self.currentHealth = self.maxHealth
  
  self.onHealthZero = Event.new({sender = self, type = ON_HEALTH_ZERO})
end

function HealthComponent:takeDamage(damage)
  
  self.currentHealth = math.max(self.currentHealth - damage, 0)
  
  if self.currentHealth == 0 then
    EventManager:notify(self.onHealthZero)
  end
end

function HealthComponent:heal(amount)
  
  self.currentHealth = math.min (self.currentHealth + amount, self.maxHealth)
end

return HealthComponent