-- the "Class" library provides OOP style classes
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- the Timer library is part of the Knife Lua module
-- colletion and gives access to timer functions
-- and tweening
--
-- https://github.com/airstruck/knife
Timer = require 'lib/timer'

-- global resources
GFonts = {
    ['funkrocker-smaller'] = love.graphics.newFont('fonts/funkrocker.ttf', 32),
    ['funkrocker-small'] = love.graphics.newFont('fonts/funkrocker.ttf', 48),
    ['funkrocker-menu'] = love.graphics.newFont('fonts/funkrocker.ttf', 64),
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
    ['error'] = love.audio.newSource('audio/error.wav', 'static')
}

-- classes
require 'src/classes/Animation'
require 'src/classes/Boss'
require 'src/classes/Entity'
require 'src/classes/Grunt'
require 'src/classes/HUD'
require 'src/classes/Map'
require 'src/classes/MapArea'
require 'src/classes/Player'
require 'src/classes/PowerUp'
require 'src/classes/Shot'
require 'src/classes/StateMachine'

-- game states
require 'src/states/BaseState'
require 'src/states/Game/MenuState'
require 'src/states/Game/SelectCharacterState'
require 'src/states/Game/CountdownState'
require 'src/states/Game/PlayState'
require 'src/states/Game/PauseState'
require 'src/states/Game/LevelCompleteState'
require 'src/states/Game/GameOverState'
require 'src/states/Game/HighScoreState'
require 'src/states/Game/EnterHighScoreState'

-- entity states
require 'src/states/Entity/Player/PlayerIdleState'
require 'src/states/Entity/Player/PlayerWalkingState'
require 'src/states/Entity/Grunt/GruntWalkingState'
require 'src/states/Entity/Grunt/GruntAttackingState'
require 'src/states/Entity/Boss/BossWalkingState'

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
    ['paused'] = function() return PauseState() end,
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
    ['grunt'] = GenerateQuads(GTextures['grunt'], 128, 128),
    ['boss'] = GenerateQuads(GTextures['boss'], 128, 128)
}