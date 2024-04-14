--EXAMPLES
----------------------
--for debugging in zero brane
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

require 'src/Dependencies'


local ship = nil
local stars = nil
local gameLoopStateMachine = nil

onSpacebarPressed = nil --global event
gameOverEvent = nil
gameCompleteEvent = nil

function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()
    eventManager = EventManager.new()
    
    onSpacebarPressed = Event.new({type = ON_SPACEBAR_PRESSED})
    gameOverEvent = Event.new({type = ON_GAME_OVER})
    gameCompleteEvent = Event.new({type = ON_GAME_COMPLETE})
    
    stars = StarsCls.new(Model.starsParams)
    --levelManager = LevelManager.new(Model.levels)
    
    gameLoopStateMachine = StateMachine.new()
    
    gameLoopStateMachine:changeState(MainMenuState.new({stateMachine = gameLoopStateMachine}))
    
end

function love.update(dt)
  
  stars:update(dt)
  --levelManager:update(dt)
  gameLoopStateMachine:update(dt)
end


function love.draw()
  
    stars:draw()
    --levelManager:draw()
    gameLoopStateMachine:draw()
end

--[[
function instantiateObjectInScene(object)
  
    levelManager:addObjectToCurrentLevel(object)
end

function removeObjectFromScene(object)
    
    levelManager:removeObjectFromCurrentLevel(object)
end
]]

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



