Event = classes.class()

function Event:init(params)

  self.sender = params.sender
  self.type = params.type
end

return Event