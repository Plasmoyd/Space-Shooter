--EXAMPLES
----------------------
--for debugging in zero brane
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

----EXAMPLES: INSTANTIARING A CLASS

require 'src/Dependencies'


local ship = nil

local stars = nil

--local LEFT_KEY = "left"
--local RIGHT_KEY = "right"
--local UP_KEY = "up"
--local DOWN_KEY = "down"
--local ESCAPE_KEY = "escape"


function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()
    eventManager = EventManager.new()
    stars = StarsCls.new( Model.starsParams)
    ship = ShipCls.new( Model.shipParams )
end

function love.update(dt)
   -- print("update")
    ship:update(dt)
    stars:update(dt)
end


function love.draw()
    --love.graphics.draw(AssetsManager.sprites.fireAngles, 0,0 )
    stars:draw()
    ship:draw()
    
    --love.graphics.print("You Win!", 180, 350)
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
        EventManager:notify(ON_SPACEBAR_PRESSED)
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



