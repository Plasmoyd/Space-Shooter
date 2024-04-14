local StateMachine = classes.class()

function StateMachine:init(params)
  
  self.currentState = nil
end

function StateMachine:changeState(state)
  
  if self.currentState then
    self.currentState:exit()
  end
  
  self.currentState = state
  
  if self.currentState then
    self.currentState:enter()
  end
  
end

function StateMachine:update(dt)
  
  if self.currentState and self.currentState.update then
    self.currentState:update(dt)
  end
end

function StateMachine:draw()
  if self.currentState and self.currentState.draw then
    self.currentState:draw()
  end
end

return StateMachine