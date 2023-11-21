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

end

function GameOverState:init()

end

function GameOverState:update(dt)

end

function GameOverState:render()

end
