--[[
  This script will contain some utility functions necessary for the game
]]

--this function clamps the value between a minimum and a maximum value
function clamp(value, min, max)
  
    return math.max(min, math.min(max, value))
  
end

--this function returns a normalized vector of a vector that is passes in as a parameter
function normalizeVector(vector)
      
    --calculating the magnitude (length) of the vector
    local magnitude = 0
    
    for _, v in pairs(vector) do
        
        magnitude = magnitude + v^2
        
    end
  
    magnitude = math.sqrt(magnitude)
    
    --once magnitude is calculated, vector can be normalized
    
    local normalizedVector = {}
    
    for k, v in pairs(vector) do
        
        if magnitude ~= 0 then
          normalizedVector[k] = v / magnitude
        else
          normalizedVector[k] = 0
        end
        
    end
    
    return normalizedVector
end
