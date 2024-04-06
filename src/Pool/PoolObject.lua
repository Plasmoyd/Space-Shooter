local PoolObject = classes.class()

function PoolObject:init(params)
  
  self.object = params.object
  self.active = false
end

function PoolObject:setActive(isActive)
  self.active = isActive  
end

function PoolObject:isActive()
  return self.active
end

function PoolObject:getObject()
  return self.object
end

return PoolObject

