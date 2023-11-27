-- the "Class" library provides OOP style classes
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- the "Timer" library is part of the Knife Lua module
-- colletion and gives access to timer functions
-- and tweening
--
-- https://github.com/airstruck/knife
Timer = require 'lib/timer'

-- the "Event" library is part of the Knife Lua module
-- colletion and gives access to event handlers for
-- creating and dispatching event
--
-- https://github.com/airstruck/knife
Event = require 'lib/event'

-- global resources
GFonts = {
    ['funkrocker-smaller'] = love.graphics.newFont('fonts/Funkrocker.ttf', 32),
    ['funkrocker-small'] = love.graphics.newFont('fonts/Funkrocker.ttf', 48),
    ['funkrocker-menu'] = love.graphics.newFont('fonts/Funkrocker.ttf', 64),
    ['funkrocker-highscores'] = love.graphics.newFont('fonts/Funkrocker.ttf', 108),
    ['funkrocker-count'] = love.graphics.newFont('fonts/Funkrocker.ttf', 192),
    ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 170)
}

GTextures = {
    ['grey-background'] = love.graphics.newImage('graphics/mottled-grey.png'),
    ['bullet-hole'] = love.graphics.newImage('graphics/bullet_hole.png'),
    ['floor-tiles'] = love.graphics.newImage('graphics/floor_tiles.png'),
    ['wall-topper'] = love.graphics.newImage('graphics/wall_topper.png'),
    ['vertical-doors'] = love.graphics.newImage('graphics/vertical_doors.png'),
    ['horizontal-doors'] = love.graphics.newImage('graphics/horizontal_doors.png'),
    ['gun-flash'] = love.graphics.newImage('graphics/gun_flash.png'),
    ['boss-gun-flash'] = love.graphics.newImage('graphics/boss_gun_flash.png'),
    ['explosion'] = love.graphics.newImage('graphics/explosions.png'),
    ['blood-splatter'] = love.graphics.newImage('graphics/blood_splatter.png'),
    ['character1-avatar'] = love.graphics.newImage('graphics/cap_n_hands.png'),
    ['character2-avatar'] = love.graphics.newImage('graphics/fwank.png'),
    ['character1'] = love.graphics.newImage('graphics/character1.png'),
    ['character2'] = love.graphics.newImage('graphics/character2.png'),
    ['grunt'] = love.graphics.newImage('graphics/grunt.png'),
    ['turret']= love.graphics.newImage('graphics/turret.png'),
    ['boss']= love.graphics.newImage('graphics/boss.png'),
    ['crate']= love.graphics.newImage('graphics/crate.png'),
    ['powerups']= love.graphics.newImage('graphics/powerups.png'),
    ['keys']= love.graphics.newImage('graphics/keys.png')
}

GAudio = {
    ['theme'] = love.audio.newSource('audio/theme.mp3', 'static'),
    ['gunshot'] = love.audio.newSource('audio/gunshot.wav', 'static'),
    ['select'] = love.audio.newSource('audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('audio/error.wav', 'static'),
    ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
    ['grunt-death'] = love.audio.newSource('audio/grunt_splat.wav', 'static'),
}

-- classes
require 'src/classes/graphical/Animation'
require 'src/classes/graphical/BloodSplatter'
require 'src/classes/graphical/Bullet'
require 'src/classes/graphical/Crate'
require 'src/classes/graphical/Explosion'
require 'src/classes/graphical/Key'
require 'src/classes/graphical/PowerUp'
require 'src/classes/graphical/Shot'
require 'src/classes/graphical/SpriteBatcher'
require 'src/classes/entity/Boss'
require 'src/classes/entity/Entity'
require 'src/classes/entity/Grunt'
require 'src/classes/entity/Player'
require 'src/classes/entity/Turret'
require 'src/classes/map/Door'
require 'src/classes/map/HUD'
require 'src/classes/map/Map'
require 'src/classes/map/MapArea'
require 'src/classes/systems/CollisionSystem'
require 'src/classes/systems/DoorSystem'
require 'src/classes/systems/EffectsSystem'
require 'src/classes/systems/EnemySystem'
require 'src/classes/systems/ObjectSystem'
require 'src/classes/systems/SystemManager'

-- game states
require 'src/states/BaseState'
require 'src/states/StateMachine'
require 'src/states/Game/MenuState'
require 'src/states/Game/SelectCharacterState'
require 'src/states/Game/CountdownState'
require 'src/states/Game/PlayState'
require 'src/states/Game/LevelCompleteState'
require 'src/states/Game/GameOverState'
require 'src/states/Game/HighScoreState'
require 'src/states/Game/EnterHighScoreState'

-- entity states
require 'src/states/Entity/Player/PlayerIdleState'
require 'src/states/Entity/Player/PlayerWalkingState'
require 'src/states/Entity/Grunt/GruntAttackingState'
require 'src/states/Entity/Grunt/GruntIdleState'
require 'src/states/Entity/Grunt/GruntRushingState'
require 'src/states/Entity/Boss/BossIdleState'
require 'src/states/Entity/Boss/BossRushingState'
require 'src/states/Entity/Turret/TurretIdleState'
require 'src/states/Entity/Turret/TurretAttackingState'

-- util files
require 'src/utils/utils'
require 'src/utils/constants'
require 'src/utils/definitions'
require 'src/utils/scores'

-- game state machine
GStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['select'] = function() return SelectCharacterState() end,
    ['countdown'] = function() return CountdownState() end,
    ['playing'] = function() return PlayState() end,
    ['gameover'] = function() return GameOverState() end,
    ['complete'] = function() return LevelCompleteState() end,
    ['highscores'] = function() return HighScoreState() end,
    ['enter-highscores'] = function() return EnterHighScoreState() end,
}

-- quads
GQuads = {
    ['floor-tiles'] = GenerateQuads(GTextures['floor-tiles'], 64, 32),
    ['wall-topper'] = GenerateQuads(GTextures['wall-topper'], 16, 16),
    ['vertical-doors'] = GenerateQuads(GTextures['vertical-doors'], 16, 32),
    ['horizontal-doors'] = GenerateQuads(GTextures['horizontal-doors'], 32, 16),
    ['character1'] = GenerateQuads(GTextures['character1'], 384, 384),
    ['character2'] = GenerateQuads(GTextures['character2'], 384, 384),
    ['explosion'] = GenerateQuads(GTextures['explosion'], 64, 64),
    ['blood-splatter'] = GenerateQuads(GTextures['blood-splatter'], 384, 384),
    ['grunt'] = GenerateQuads(GTextures['grunt'], 128, 128),
    ['turret'] = GenerateQuads(GTextures['turret'], 256, 256),
    ['boss'] = GenerateQuads(GTextures['boss'], 128, 128),
    ['crate'] = GenerateQuads(GTextures['crate'], 85, 85),
    ['powerups'] = GenerateQuads(GTextures['powerups'], 64, 64),
    ['keys'] = GenerateQuads(GTextures['keys'], 64, 64)
}
