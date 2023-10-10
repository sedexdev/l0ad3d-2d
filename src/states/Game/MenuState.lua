MenuState = Class{__includes = BaseState}

function MenuState:enter(params)
    self.highScores = params.highScores
end

function MenuState:init()
    self.selected = 1
    self.bulletOffsets = {
        [1] = {x = 1, y = 55, rendered = false},
        [2] = {x = 3, y = -50, rendered = false},
        [3] = {x = 4, y = 45, rendered = false},
        [4] = {x = 6, y = -20, rendered = false},
    }
    self.pauseInput = true
    for i = 1, 4 do
        Timer.after(i * 0.3, function ()
            self.bulletOffsets[i].rendered = true
            GAudio['gunshot']:stop()
            GAudio['gunshot']:play()
        end)
    end
    Timer.after(1.2, function ()
        self.pauseInput = false
    end)
end

function MenuState:update(dt)
    if not self.pauseInput then
        if love.keyboard.wasPressed('up') then
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected <= 1 and 3 or self.selected - 1
        end
        if love.keyboard.wasPressed('down') then
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected >= 3 and 1 or self.selected + 1
        end
    
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            GAudio['select']:stop()
            GAudio['gunshot']:play()
            if self.selected == 1 then
                GStateMachine:change('select', {
                    highScores = self.highScores
                })
            elseif self.selected == 2 then
                GStateMachine:change('highscores', {
                    highScores = self.highScores
                })
            else
                love.event.quit()
            end
        end
    end

    Timer.update(dt)
end

function MenuState:render()
    -- draw background
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['grey-background'],
        0, 0,
        0,
        WINDOW_WIDTH / GTextures['grey-background']:getWidth(),
        WINDOW_WIDTH / GTextures['grey-background']:getHeight()
    )

    -- draw bullet holes
     for i = 1, 4 do
        if self.bulletOffsets[i].rendered then
            love.graphics.draw(GTextures['bullet-hole'],
                (WINDOW_WIDTH / 8) * self.bulletOffsets[i].x, (WINDOW_HEIGHT / 4) + self.bulletOffsets[i].y,
                0,
                0.25, 0.25
            )
        end
    end

    -- draw title
    love.graphics.setFont(GFonts['blood-title'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf('L0ad3d-2D', 2, (WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf('L0ad3d-2D', 2, (WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('L0ad3d-2D', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')

    -- draw menu
    love.graphics.setFont(GFonts['funkrocker-menu'])

    self:renderOption('LOAD UP', 1, 200)
    self:renderOption('HIGH SCORE', 2, 300)
    self:renderOption('QUIT', 3, 400)

    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
end

function MenuState:renderOption(name, id, yOffset)
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf(name, 2, (WINDOW_HEIGHT / 3 + yOffset) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(name, 2, (WINDOW_HEIGHT / 3 + yOffset) + 2, WINDOW_WIDTH, 'center')
    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == id then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf(name, 0, WINDOW_HEIGHT / 3 + yOffset, WINDOW_WIDTH, 'center')
end