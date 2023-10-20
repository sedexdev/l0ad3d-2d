--[[
    PauseState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Pauses the game by darkening the screen and displaying
        a 'Paused' message. Option are displyed for continuing
        the game or quitting to the MenuState
]]

PauseState = Class{__includes = BaseState}

--[[
    PauseState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'pause' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function PauseState:enter(params)
    
end

function PauseState:init()
    
end

function PauseState:update(dt)
    
end

function PauseState:render()
    
end
