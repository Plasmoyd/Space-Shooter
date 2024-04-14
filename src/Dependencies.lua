
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
Component = require 'src/Components/Component'
HealthComponent = require 'src/Components/HealthComponent'
BaseMovementComponent = require 'src/Components/BaseMovementComponent'
SinusoidalMovementComponent = require 'src/Components/SinusoidalMovementComponent'
EnemyFactory = require 'src/Enemy/EnemyFactory'
LevelManager = require 'src/Level/LevelManager'
Level = require 'src/Level/Level'
LevelLoader = require 'src/Level/LevelLoader'
ParticleSystem = require 'src/Particle/ParticleSystem'
Particle = require 'src/Particle/Particle'
EnemySpawner = require 'src/Enemy/EnemySpawner'
State = require 'src/StateMachine/State'
StateMachine = require 'src/StateMachine/StateMachine'
MainMenuState = require 'src/StateMachine/MainMenuState'
PlayState = require 'src/StateMachine/PlayState'
