
--Main Menu state, will handle main menu logic
local MainMenuState = classes.class(State)

function MainMenuState:init(params)
  
  -- Set the title displayed in the main menu.
  self.title = "Space Shooter"
  
  -- Store reference to the state machine to allow state transitions.
  self.stateMachine = params.stateMachine
end

-- Called when the MainMenuState becomes the active state.
function MainMenuState:enter()
  
  EventManager:subscribe(onSpacebarPressed, self)
end

-- Render the main menu interface.
function MainMenuState:draw()
  
  love.graphics.setFont(AssetsManager.fonts.titleSpaceFont)
  love.graphics.print(self.title, Model.stage.stageWidth / 8, Model.stage.stageHeight / 2)
  
  love.graphics.setFont(AssetsManager.fonts.spaceFont)
  love.graphics.print("Press Spacebar To Play", Model.stage.stageWidth / 8, Model.stage.stageHeight / 2 + 200)
end

-- Called when the MainMenuState is exited.
function MainMenuState:exit()
  
  EventManager:unsubscribe(onSpacebarPressed, self)
  self = nil
end

-- Handle notifications from the EventManager.
function MainMenuState:onNotify(event, args)
  
  args = args or {}
  
  if not event then 
    return
  end
  
  if event.type == ON_SPACEBAR_PRESSED then
    
    -- Change to the PlayState when spacebar is pressed.
    self.stateMachine:changeState(PlayState.new({stateMachine = self.stateMachine})) --change to play state
  end
end

return MainMenuState