--[[
    Observable: class

    Description:
        In line with the classic Observer design pattern this
        class declares a number of methods that will be 
        inherited (as lua has no interfaces) by child classes.
        The children will serve as notification systems when events
        happen in the game that cause the observable object to
        change state and notify the observers
]]

Observable = Class{}

--[[
    Simulates an interface or abstract class with functions
    definitions that have no implementation. This allows all
    Observable classes to call the base functions regardless of
    whether the concrete class overrides the function

    Params (for all):
        none
    Returns (for all):
        nil
]]
function Observable:init() end
function Observable:subscribe() end
function Observable:unsubscribe() end
function Observable:notify() end
