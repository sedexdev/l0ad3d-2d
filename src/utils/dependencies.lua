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
    ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 170),
}

GTextures = {
    ['grey-background'] = love.graphics.newImage('graphics/mottled-grey.png'),
    ['bullet-hole'] = love.graphics.newImage('graphics/bullet_hole.png'),
    ['floor-tiles'] = love.graphics.newImage('graphics/floor_tiles.png'),
    ['character1-avatar'] = love.graphics.newImage('graphics/cap_n_hands.png'),
    ['character1'] = love.graphics.newImage('graphics/character1.png')
}

GAudio = {
    ['theme'] = love.audio.newSource('audio/theme.mp3', 'static'),
    ['gunshot'] = love.audio.newSource('audio/gunshot.wav', 'static'),
    ['select'] = love.audio.newSource('audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('audio/error.wav', 'static'),
}

-- classes
require 'src/classes/Animation'
require 'src/classes/Entity'
require 'src/classes/Map'
require 'src/classes/Player'
require 'src/classes/StateMachine'

-- game states
require 'src/states/BaseState'
require 'src/states/Game/MenuState'
require 'src/states/Game/SelectCharacterState'
require 'src/states/Game/CountdownState'
require 'src/states/Game/PlayState'
require 'src/states/Game/HighScoreState'

-- entity states
require 'src/states/Entity/Player/PlayerIdleState'
require 'src/states/Entity/Player/PlayerWalkingState'

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
    ['highscores'] = function() return HighScoreState() end
}

-- quads
GQuads = {
    ['floor-tiles'] = GenerateQuads(GTextures['floor-tiles'], 64, 32),
    ['character1'] = GenerateQuads(GTextures['character1'], 384, 384)
}