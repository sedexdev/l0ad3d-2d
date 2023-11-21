--[[
    EnterHighScoreState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Gives the user the ability to enter their name after
        having obtained a highscore. The highscore will subsequently
        be displayed in the highscores table rendered out by the
        HighScoreState class
]]

EnterHighScoreState = Class{__includes = BaseState}

--[[
    EnterHighScoreState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'enter-highscores' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function EnterHighScoreState:enter(params)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')    
end

function EnterHighScoreState:init()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')    
end

function EnterHighScoreState:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')    
end

function EnterHighScoreState:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end
