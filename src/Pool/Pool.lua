Pool = classes.class()

function Pool:init(poolSize)
  
  self.poolSize = poolSize
  
  self.pool = {}
  
end

function Pool:getObject()
  
  for _,poolObject in pairs(pool) do
    
    if not poolObject:isActive() then
      
      poolObject:setActive(true)
      return poolObject:getObject()
    end
  end
  
  return nil
end

function Pool:returnObject(object)
  for _, poolObject in pairs(pool) do
    
    if poolObject:getObject() == object then
      poolObject:setActive(false)
    end
  end
end

function Pool:addObject(object)
  if #pool >= poolSize then
    return false
  end
  
  poolObject = PoolObject:new(object)
  table.insert(self.pool, poolObject)
  return true
end

return Pool
