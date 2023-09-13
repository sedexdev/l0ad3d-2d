-- the "Class" library provides OOP style classes
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- util files
require 'src/utils/constants'

-- classes
require 'src/classes/StateMachine'

-- states
require 'src/states/BaseState'
require 'src/states/MenuState'
require 'src/states/CountdownState'