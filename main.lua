--EXAMPLES
----------------------
--for debugging in zero brane
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

require 'src/Dependencies'


local ship = nil
local stars = nil

local scene = {}

function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()
    eventManager = EventManager.new()
    stars = StarsCls.new( Model.starsParams)
    ship = ShipCls.new( Model.shipParams )
    
    instantiateObjectInScene(stars)
    instantiateObjectInScene(ship)
    
end

function love.update(dt)
   -- print("update")
    for i = 1, #scene do
      if scene[i].update then
        scene[i]:update(dt)
      end
    end
end


function love.draw()
    --love.graphics.draw(AssetsManager.sprites.fireAngles, 0,0 )
    for i = 1, #scene do
      if scene[i].draw then
        scene[i]:draw()
      end
    end
    --love.graphics.print("You Win!", 180, 350)
end

function instantiateObjectInScene(object)
    
    if scene then
      table.insert(scene, object)
    end
end

function removeObjectFromScene(object)
  
    if not scene then
      return
    end
    
    for k, v in pairs(scene) do
      
      if v == object then
        table.remove(scene, k)
        return
      end
    end
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



