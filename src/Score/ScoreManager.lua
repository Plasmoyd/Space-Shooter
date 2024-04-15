--Score Manager that will be responsible for keeping the score of the current game
local ScoreManager = classes.class()

function ScoreManager:init(params)
  
  self.score = 0
  
  --Subscribing to any enemy destroyed event 
  EventManager:subscribe(Enemy.onAnyEnemyDestroyed, self)
  EventManager:subscribe(Collectible.coinCollectedEvent, self)
end

--Draws the current score on the screen 
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
  elseif event.type == ON_COIN_COLLECTED then
    self.score = self.score + args
  end
end

function ScoreManager:destroy()
  EventManager:unsubscribeAll(self)
  self = nil
end

return ScoreManager