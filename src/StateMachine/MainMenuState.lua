local MainMenuState = classes.class(State)

function MainMenuState:init(params)
  
  self.title = "Space Shooter"
  
  self.stateMachine = params.stateMachine
end

function MainMenuState:enter()
  
  EventManager:subscribe(onSpacebarPressed, self)
end

function MainMenuState:draw()
  
  love.graphics.setFont(AssetsManager.fonts.titleSpaceFont)
  love.graphics.print(self.title, Model.stage.stageWidth / 8, Model.stage.stageHeight / 2)
  
  love.graphics.setFont(AssetsManager.fonts.spaceFont)
  love.graphics.print("Press Spacebar To Play", Model.stage.stageWidth / 8, Model.stage.stageHeight / 2 + 200)
end

function MainMenuState:exit()
  
  EventManager:unsubscribe(onSpacebarPressed, self)
  self = nil
end

function MainMenuState:onNotify(event, args)
  
  args = args or {}
  
  if not event then 
    return
  end
  
  if event.type == ON_SPACEBAR_PRESSED then
    
    self.stateMachine:changeState(PlayState.new({stateMachine = self.stateMachine})) --change to play state
  end
end

return MainMenuState