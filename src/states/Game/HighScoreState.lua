--[[
    HighScoreState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays the highscore table to the player
]]

HighScoreState = Class{__includes = BaseState}

--[[
    HighScoreState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'highscores' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function HighScoreState:enter(params)
    self.highScores = params.highScores
end

--[[
    HighScoreState update function

    Key bindings;
        escape: goes back to the MenuState
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
end

--[[
    HighScoreState render function. Draws out the highscores table
    based on the <params.highScores> state passed into the enter function 

    Params:
        none
    Returns;
        nil
]]
function HighScoreState:render()
    love.graphics.setFont(GFonts['funkrocker-medium'])
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('HIGH SCORES', 0, 80, WINDOW_WIDTH, 'center')
    -- print scores
    love.graphics.setFont(GFonts['funkrocker-small'])
    love.graphics.setColor(1, 1, 1, 1)
    for i = 1, 10 do
        love.graphics.printf(tostring(i) .. '. ', -420, 215 + (i * 65), WINDOW_WIDTH, 'center')
        love.graphics.printf(self.highScores[i].name, -280, 215 + (i * 65), WINDOW_WIDTH, 'center')
        love.graphics.printf(self.highScores[i].score, 180, 215 + (i * 65), WINDOW_WIDTH, 'center')
        love.graphics.printf('LVL: ' .. self.highScores[i].level, 400, 215 + (i * 65), WINDOW_WIDTH, 'center')
    end
    -- print escape message
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.setFont(GFonts['funkrocker-smaller'])
    love.graphics.printf('Press escape to go back', 0, WINDOW_HEIGHT - 100, WINDOW_WIDTH, 'center')
end
