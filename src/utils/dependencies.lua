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
require 'src/classes/StateMachine'

-- states
require 'src/states/BaseState'
require 'src/states/MenuState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
require 'src/states/HighScoreState'

-- util files
require 'src/utils/constants'
require 'src/utils/scores'