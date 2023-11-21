--[[
    GameOverState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays the 'Game Over' message to the player and their
        score. If a highscore is obtained the player is directd to
        enter their highscore by changing to the EnterHighScoreState, 
        otherwise an option is displayed to go back to the MenuState 
]]

GameOverState = Class{__includes = BaseState}

--[[
    GameOverState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'gameover' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function GameOverState:enter(params)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function GameOverState:init()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function GameOverState:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end

function GameOverState:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
end
