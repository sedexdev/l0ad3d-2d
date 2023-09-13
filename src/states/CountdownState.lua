CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= 1 then
        self.count = self.count - 1
        self.timer = 0
    end
end

function CountdownState:render()
    love.graphics.setFont(GFonts['blood-count'])
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(tostring(self.count), 0, WINDOW_HEIGHT / 3, WINDOW_WIDTH, 'center')
end