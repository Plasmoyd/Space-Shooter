--Implementation of State Machine pattern
local StateMachine = classes.class()

function StateMachine:init(params)
  
  self.currentState = nil
end

--Function to change the current state of the state machine
function StateMachine:changeState(state)
  
  --Check to see if the current state exists, and calls it's exit function if so
  if self.currentState then
    self.currentState:exit()
  end
  
  --changing the current state
  self.currentState = state
  
  
  --if the new current state exists, call it's enter function
  if self.currentState then
    self.currentState:enter()
  end
  
end

--calling the update method of the current state
function StateMachine:update(dt)
  
  if self.currentState and self.currentState.update then
    self.currentState:update(dt)
  end
end

--calling the draw method of the current state
function StateMachine:draw()
  if self.currentState and self.currentState.draw then
    self.currentState:draw()
  end
end

return StateMachine