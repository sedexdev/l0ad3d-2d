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

-- classes
require 'src/classes/Map'
require 'src/classes/Player'
require 'src/classes/StateMachine'

-- states
require 'src/states/Game/BaseState'
require 'src/states/Game/MenuState'
require 'src/states/Game/SelectCharacterState'
require 'src/states/Game/CountdownState'
require 'src/states/Game/PlayState'
require 'src/states/Game/HighScoreState'

-- util files
require 'src/utils/utils'
require 'src/utils/constants'
require 'src/utils/definitions'
require 'src/utils/scores'
