--[[
  This script will hold all the necessary constant values for the game
]]

--input key strings
LEFT_KEY = "left"
RIGHT_KEY = "right"
UP_KEY = "up"
DOWN_KEY = "down"
ESCAPE_KEY = "escape"
SPACEBAR_KEY = "space"

--event constants
ON_SPACEBAR_PRESSED = "spacebarPressed"
ON_BULLET_DESTROYED = "bulletDestroyed"
ON_ENEMY_DESTROYED = "enemyDestroyed"
ON_ENEMY_BULLET_DESTROYED = "enemyBulletDestroyed"
ON_HEALTH_ZERO = "healthZero"
ON_SPAWNER_COMPLETE = "spawnerComplete"
ON_LEVEL_COMPLETE = "levelComplete"
ON_GAME_OVER = "gameOver"
ON_GAME_COMPLETE = "gameComplete"
ON_ANY_ENEMY_DESTROYED = "anyEnemyDestroyed"
ON_COIN_COLLECTED = "coinCollected"

--bullet direction constants

PLAYER_BULLET_DIRECTION = -1
ENEMY_BULLET_DIRECTION = 1

-- collision constants

ENEMY_COLLISION_TYPE = "enemyCollisionType"
SHIP_COLLISION_TYPE = "shipCollisionType"
BULLET_COLLISION_TYPE = "bulletCollisionType"
COLLECTIBLE_COLLISION_TYPE = "collectibleCollisionType"

--component class names

HEALTH_COMPONENT = "healthComponent"
BASE_MOVEMENT_COMPONENT = "baseMovementComponent"
SINUSOIDAL_MOVEMENT_COMPONENT = "sinusoidalMovementComponent"

--enemy types

BASE_ENEMY = "baseEnemy"
FUNKY_ENEMY = "funkyEnemy"

--collectible types

HEALTH_PACK = "healthPack"
COIN = "coin"