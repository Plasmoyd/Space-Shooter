
--[[

  This file will keep track of all the dependencies in the game

]]

classes = require 'lib/classes'
Model = require 'src/Model'
AssetsManager = require 'AssetsManager'
ShipCls = require 'src/Ship'
StarsCls = require 'src/stars'
require 'src/Util'
require 'src/Constants'
EventManager = require 'src/EventSystem/EventManager'
Event = require 'src/EventSystem/Event'
Bullet = require 'src/Bullet'
Pool = require 'src/Pool/Pool'
PoolObject = require 'src/Pool/PoolObject'
Enemy = require 'src/Enemy/Enemy'
CollisionManager = require 'src/CollisionManager'
ComponentFactory = require 'src/Components/ComponentFactory'
HealthComponent = require 'src/Components/HealthComponent'
EnemyFactory = require 'src/Enemy/EnemyFactory'
