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
    bulletPoolSize = 20,
    collisionChannel = SHIP_COLLISION_TYPE
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
    collisionChannel = BULLET_COLLISION_TYPE
}

Model.enemyParams = {
    assetName = "enemy",
    speed = 200,
    rateOfFire = 0.5,
    bulletPoolSize = 5,
    collisionChannel = ENEMY_COLLISION_TYPE
}

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }
    
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
    
    --define enemies here

end


return Model