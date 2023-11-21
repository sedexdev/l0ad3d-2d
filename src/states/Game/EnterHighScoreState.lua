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

end

function EnterHighScoreState:init()

end

function EnterHighScoreState:update(dt)

end

function EnterHighScoreState:render()

end
