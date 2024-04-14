local HealthComponent = classes.class(Component)

function HealthComponent:init(params)
  self.maxHealth = params.maxHealth
  self.currentHealth = self.maxHealth
  
  -- Event triggered when health reaches zero
  self.onHealthZero = Event.new({sender = self, type = ON_HEALTH_ZERO})
end

-- Method to apply damage to the component
function HealthComponent:takeDamage(damage)
  
  -- Reduce current health by the damage amount, ensuring it doesn't drop below zero
  self.currentHealth = math.max(self.currentHealth - damage, 0)
  
  if self.currentHealth == 0 then
    -- Notify listeners via the EventManager if health reaches zero
    EventManager:notify(self.onHealthZero)
  end
end

-- Method to heal the component
function HealthComponent:heal(amount)
  
  -- Increase current health by the specified amount without exceeding the maximum health
  self.currentHealth = math.min (self.currentHealth + amount, self.maxHealth)
end

return HealthComponent