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
    y = 0
}

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }
    
    
    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    
    --define enemies here

end


return Model