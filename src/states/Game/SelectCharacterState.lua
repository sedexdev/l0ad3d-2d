SelectCharacterState = Class{__includes = BaseState}

function SelectCharacterState:enter(params)
    self.highScores = params.highScores
end

function SelectCharacterState:init()
    self.selected = 1
end

function SelectCharacterState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('right') then
        if self.selected == 2 then
            GAudio['error']:play()
        else
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected + 1
        end
    elseif love.keyboard.wasPressed('left') then
        if self.selected == 1 then
            GAudio['error']:play()
        else
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected - 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GAudio['select']:stop()
        GAudio['gunshot']:play()
        GStateMachine:change('countdown', {
            highScores = self.highScores,
            player = Player(self.selected, GEntityDefintions['player']),
            map = Map()
        })
    end
end

function SelectCharacterState:render()
    -- draw background
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['grey-background'],
        0, 0,
        0,
        WINDOW_WIDTH / GTextures['grey-background']:getWidth(),
        WINDOW_WIDTH / GTextures['grey-background']:getHeight()
    )

    -- use rectangles as characters for now

    -- render first character
    love.graphics.setColor(0/255, 1, 0/255, 1)
    love.graphics.rectangle('fill',
        (WINDOW_WIDTH / 4) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
        AVATAR_WIDTH, AVATAR_HEIGHT
    )

    if self.selected == 1 then
        -- render opaque rectangle on top
        love.graphics.setColor(1, 1, 1, 50/255)
        love.graphics.rectangle('fill',
            (WINDOW_WIDTH / 4) - (AVATAR_WIDTH / 2),
            (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
            AVATAR_WIDTH, AVATAR_HEIGHT
        )
    end

    -- render second character
    love.graphics.setColor(0/255, 0/255, 1, 1)
    love.graphics.rectangle('fill',
        (WINDOW_WIDTH / 4 * 3) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
        AVATAR_WIDTH, AVATAR_HEIGHT
    )

    if self.selected == 2 then
        -- render opaque rectangle on top
        love.graphics.setColor(1, 1, 1, 50/255)
        love.graphics.rectangle('fill',
        (WINDOW_WIDTH / 4 * 3) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
        AVATAR_WIDTH, AVATAR_HEIGHT
    )
    end
end