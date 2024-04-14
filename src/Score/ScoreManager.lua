local ScoreManager = classes.class()

function ScoreManager:init(params)
  
  self.score = 0
  
  EventManager:subscribe(Enemy.onAnyEnemyDestroyed, self)
  
end

function ScoreManager:draw()
  
  love.graphics.setFont(AssetsManager.fonts.spaceFont)
  love.graphics.print("Score: " ..tostring(self.score), 10, 10)
end

function ScoreManager:onNotify(event, args)
  
  if not event then 
    return
  end
  
  args = args or {}
  
  if event.type == ON_ANY_ENEMY_DESTROYED then
    self.score = self.score + args.score
  end
end

function ScoreManager:destroy()
  EventManager:unsubscribeAll(self)
  self = nil
end

return ScoreManager