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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function LevelCompleteState:init()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function LevelCompleteState:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function LevelCompleteState:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end
