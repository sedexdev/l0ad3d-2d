MenuState = Class{__includes = BaseState}

function MenuState:init()
    self.selected = 1
end

function MenuState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.selected = self.selected == 1 and 2 or 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.selected == 1 then
            GStateMachine:change('countdown')
        else
            -- show highscores
        end
    end
end

function MenuState:render()
    love.graphics.setFont(GFonts['blood-title'])
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('L0ad3d-2D', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')

    love.graphics.setFont(GFonts['blood-menu'])

    if self.selected == 1 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf('LOAD UP', 0, WINDOW_HEIGHT / 3 + 200, WINDOW_WIDTH, 'center')

    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)

    if self.selected == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf('HIGH SCORE', 0, WINDOW_HEIGHT / 3 + 300, WINDOW_WIDTH, 'center')

    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
end