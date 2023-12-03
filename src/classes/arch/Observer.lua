--[[
    Observer: class

    Description:
        In line with the classic Observer design pattern this
        class declares a number of methods that will be 
        inherited (as lua has no interfaces) by child classes.
        The children will serve as observers to the Observable
        conrete implementation, which will call the notify()
        function on each of its subscribers
]]

Observer = Class{}

--[[
    Simulates an interface or abstract class with function
    definitions that have no implementation. This allows all
    Observer classes to call the base functions regardless of
    whether the concrete class overrides the function

    Params (for all):
        none
    Returns (for all):
        nil
]]
function Observer:init() end
function Observer:message() end
