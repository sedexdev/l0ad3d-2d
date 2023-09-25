PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.highScores = params.highScores
end

function PlayState:init()
    
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
end

function PlayState:render()
    love.graphics.setFont(GFonts['blood-title'])
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('PLAYING!', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
end