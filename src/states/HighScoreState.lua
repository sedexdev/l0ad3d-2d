HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(GFonts['blood-highscores'])
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('HIGH SCORES', 0, 100, WINDOW_WIDTH, 'center')

    love.graphics.setFont(GFonts['blood-small'])
    love.graphics.setColor(1, 1, 1, 1)
    for i = 1, 10 do
        love.graphics.printf(tostring(i) .. '. ', -250, 225 + (i * 65), WINDOW_WIDTH, 'center')
        love.graphics.printf(self.highScores[i].name, -140, 225 + (i * 65), WINDOW_WIDTH, 'center')
        love.graphics.printf(self.highScores[i].score, 250, 225 + (i * 65), WINDOW_WIDTH, 'center')
    end

    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.setFont(GFonts['blood-smaller'])
    love.graphics.printf('Press escape to go back', 0, WINDOW_HEIGHT - 80, WINDOW_WIDTH, 'center')
end