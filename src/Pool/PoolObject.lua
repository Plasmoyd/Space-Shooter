PoolObject = classes.class()

function PoolObject:init(object)
  
  self.object = object
  self.isActive = false
end

function PoolObject:setActive(isActive)
  self.isActive = isActive  
end

function PoolObject:isActive()
  return self.isActive
end

function PoolObject:getObject()
  return self.object
end

return PoolObject

