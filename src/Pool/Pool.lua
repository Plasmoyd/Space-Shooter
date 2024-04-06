local Pool = classes.class()

function Pool:init(params)
  self.poolSize = params.poolSize
  
  self.pool = {}
  
  print("poolSize: " .. self.poolSize .. " #self.pool: " .. #self.pool)
  
end

function Pool:getObject()
  
  for _,poolObject in pairs(self.pool) do
    
    local active = poolObject:isActive()
    
    if not active then
      
      poolObject:setActive(true)
      return poolObject:getObject()
    end
  end
  
  return nil
end

function Pool:returnObject(object)
  for _, poolObject in pairs(self.pool) do
    
    if poolObject:getObject() == object then
      poolObject:setActive(false)
    end
  end
end

function Pool:addObject(object)
  
  if #self.pool >= self.poolSize then
    return false
  end
  
  local poolObject = PoolObject.new({object = object})
  table.insert(self.pool, poolObject)
  return true
end

function Pool:getPoolSize()
  return self.poolSize
end

return Pool
