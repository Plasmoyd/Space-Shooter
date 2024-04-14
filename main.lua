--EXAMPLES
----------------------
--for debugging in zero brane
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

-- Load all dependencies from the 'src/Dependencies.lua' script
require 'src/Dependencies'

--Global variables
local stars = nil
local gameLoopStateMachine = nil

-- Global events
onSpacebarPressed = nil --global event
gameOverEvent = nil
gameCompleteEvent = nil

function love.load()
  
    -- Initialize assets and model data
    AssetsManager.init()
    Model.init()
    
    --Instantiating an event manager
    eventManager = EventManager.new()
    
    -- Initializing game events
    onSpacebarPressed = Event.new({type = ON_SPACEBAR_PRESSED})
    gameOverEvent = Event.new({type = ON_GAME_OVER})
    gameCompleteEvent = Event.new({type = ON_GAME_COMPLETE})
    
    -- Setup the starfield background
    stars = StarsCls.new(Model.starsParams)
    
    --Initializing the game state machine, starting with main menu state
    gameLoopStateMachine = StateMachine.new()
    gameLoopStateMachine:changeState(MainMenuState.new({stateMachine = gameLoopStateMachine}))
    
end

function love.update(dt)
  
  stars:update(dt)
  gameLoopStateMachine:update(dt)
end


function love.draw()
  
    stars:draw()
    --levelManager:draw()
    gameLoopStateMachine:draw()
end

function love.keypressed(key)
    print(key)
    if key == LEFT_KEY then
        Model.movement.left = true
    elseif key == RIGHT_KEY then
        Model.movement.right = true
    end
    
    if key == UP_KEY then
        Model.movement.up = true
    elseif key == DOWN_KEY then
        Model.movement.down = true
    end
    
    if key == ESCAPE_KEY then
        love.event.quit()
    end
    
    if key == SPACEBAR_KEY then
        EventManager:notify(onSpacebarPressed)
    end
    

end

function love.keyreleased(key)
    if key == LEFT_KEY then
        Model.movement.left = false
    elseif key == RIGHT_KEY then
        Model.movement.right = false
    end
    
    if key == UP_KEY then
        Model.movement.up = false
    elseif key == DOWN_KEY then
        Model.movement.down = false
    end
end

--
--



