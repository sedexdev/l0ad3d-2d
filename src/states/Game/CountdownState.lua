CountdownState = Class{__includes = BaseState}

function CountdownState:enter(params)
    self.highScores = params.highScores
    self.player = params.player
    Timer.after(3, function()
        GStateMachine:change('playing', {
            highScores = self.highScores,
            player = self.player
        })
    end)
end

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end

    self.timer = self.timer + dt

    if self.timer >= 1 then
        self.count = self.count - 1
        self.timer = 0
    end

    Timer.update(dt)
end

function CountdownState:render()
    love.graphics.setFont(GFonts['funkrocker-count'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(tostring(self.count), 2, (WINDOW_HEIGHT / 3) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(tostring(self.count), 2, (WINDOW_HEIGHT / 3) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(tostring(self.count), 0, WINDOW_HEIGHT / 3, WINDOW_WIDTH, 'center')
end