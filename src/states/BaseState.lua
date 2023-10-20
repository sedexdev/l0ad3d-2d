--[[
    BaseState: class

    Description:
        Defines function signatures to be inherited by all 
        other state class instances
]]

BaseState = Class{}

--[[
    Simulates an interface or abstract class with functions
    definitions that have no implementation. This allows all
    state classes to call the base functions regardless of
    whether the concrete class overrides the function

    For all
        Params:
            none
        Returns:
            nil
]]
function BaseState:init() end
function BaseState:update() end
function BaseState:render() end
function BaseState:enter() end
function BaseState:exit() end
