local Model = {
    movement = {
        up = false,
        down = false,
        left = false,
        right = false,
        space = false
    }
}

Model.shipParams = {
    assetName = "ship",
    speed = 500,
    rateOfFire = 0.15,
    bulletPoolSize = 20
}

Model.starsParams = {
    radius = 1,
    speed = 100,
    numStars = 200
}

Model.bulletParams = {
    assetName = "bullet",
    speed = 1000,
    x = 0,
    y = 0,
    damage = 1
}

Model.enemyParams = {
    assetName = "enemy",
    speed = 200,
    rateOfFire = 0.5,
    bulletPoolSize = 5
}

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }
    
    --this part of the model tells the CollisionManager which types of objects can collide with each other
    Model.collisionHandlers = {
  
      [ENEMY_COLLISION_TYPE] = {
          
        BULLET_COLLISION_TYPE,
        SHIP_COLLISION_TYPE
      },
      
      [SHIP_COLLISION_TYPE] = {
        BULLET_COLLISION_TYPE,  
        ENEMY_COLLISION_TYPE
      },
      
      [BULLET_COLLISION_TYPE] = {
        SHIP_COLLISION_TYPE,
        ENEMY_COLLISION_TYPE
      }
    
    }
    
    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    Model.enemyParams.asset = AssetsManager.sprites[Model.enemyParams.assetName]
    
    --init collision channels
    
    Model.shipParams.collisionChannel = SHIP_COLLISION_TYPE
    Model.bulletParams.collisionChannel = BULLET_COLLISION_TYPE
    Model.enemyParams.collisionChannel = ENEMY_COLLISION_TYPE
    
    
    --define enemies here
    
    Model.enemyType = {
      
      [BASE_ENEMY] = {
        
        components = {
        
          { class = HEALTH_COMPONENT, params = { maxHealth = 3}}
        }
      }
      
    }
    
    --Ship's components
    Model.shipComponents = {
        
      components = {
        
          { class = HEALTH_COMPONENT, params = { maxHealth = 3}}
      }
    }
    
    Model.shipParams.components = Model.shipComponents.components
    

end


return Model