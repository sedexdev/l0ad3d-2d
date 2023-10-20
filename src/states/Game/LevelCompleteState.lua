--[[
    LevelCompleteState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays a 'Level Complete' message to the player and restarts
        play by starting the player back in the start area. The boss
        has their health increased slighly and grunt enemies damage 
        increases. Any powerups are removed and keys rendered back
        in their original location
]]

LevelCompleteState = Class{__includes = BaseState}

--[[
    LevelCompleteState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'complete' as the stateName argument. The 
    Timer.after callback function changes state after 3 seconds

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function LevelCompleteState:enter(params)
    
end

function LevelCompleteState:init()
    
end

function LevelCompleteState:update(dt)
    
end

function LevelCompleteState:render()
    
end
