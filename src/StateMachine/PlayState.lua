local PlayState = classes.class(State)

local levelManager = nil

function PlayState:init(params)
  
  self.stateMachine = params.stateMachine
  
  self.gameOver = false
  self.gameComplete = false
  
  self.gameOverTimer = 0
  self.transitionTime = 5
end

function PlayState:enter()
  
  EventManager:subscribe(gameOverEvent, self)
  EventManager:subscribe(gameCompleteEvent, self)
  levelManager = LevelManager.new(Model.levels)
end

function PlayState:update(dt)
  if levelManager and levelManager.update then
    levelManager:update(dt)
  end
  
  if self.gameOver or self.gameComplete then
    
    self.gameOverTimer = self.gameOverTimer + dt
    
    if self.gameOverTimer >= self.transitionTime then
      self.stateMachine:changeState(MainMenuState.new({stateMachine = self.stateMachine}))
    end
  end
end

function PlayState:draw(dt)
  if levelManager and levelManager.draw then
    levelManager:draw()
  end
  
  if self.gameOver then
    love.graphics.setFont(AssetsManager.fonts.titleSpaceFont)
    love.graphics.print("GAME OVER!", Model.stage.stageWidth / 4, Model.stage.stageHeight / 2)
  elseif self.gameComplete then
    love.graphics.setFont(AssetsManager.fonts.titleSpaceFont)
    love.graphics.print("YOU WON", Model.stage.stageWidth / 3, Model.stage.stageHeight / 2)
  end
end

function PlayState:exit()
  self.gameOverTimer = 0
  self.gameOver = false
  self.gameComplete = false
  levelManager:destroy()
  EventManager:unsubscribeAll(self)
  self = nil
end

function instantiateObjectInScene(object)
  
    if levelManager then
      levelManager:addObjectToCurrentLevel(object)
    end
end

function removeObjectFromScene(object)
  
    if levelManager then
      levelManager:removeObjectFromCurrentLevel(object)
    end
end

function PlayState:onNotify(event,args)
  
  if not event then
    return
  end
  
  args = args or {}
  
  if event.type == ON_GAME_OVER then
    self.gameOver = true
  elseif event.type == ON_GAME_COMPLETE then
    self.gameComplete = true
  end
end

return PlayState