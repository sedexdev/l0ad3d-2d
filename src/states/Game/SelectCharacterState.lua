SelectCharacterState = Class{__includes = BaseState}

function SelectCharacterState:enter(params)
    self.highScores = params.highScores
end

function SelectCharacterState:init()
    self.selected = 1
    self.bulletOffsets = {
        [1] = {x = 3, y = -50},
        [2] = {x = 4, y = 45},
    }
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
            player = Player(
                self.selected,
                GAnimationDefintions['character'..tostring(self.selected)],
                GCharacterDefinition
            ),
            grunt = Grunt(
                GAnimationDefintions['grunt'],
                GGruntDefinition
            ),
            boss = Grunt(
                GAnimationDefintions['boss'],
                GBossDefinition
            ),
            map = Map()
            }
        )
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

    --render bullet holes in the centre
    for i = 1, #self.bulletOffsets do
        love.graphics.draw(GTextures['bullet-hole'],
            (WINDOW_WIDTH / 8) * self.bulletOffsets[i].x, (WINDOW_HEIGHT / 4) + self.bulletOffsets[i].y,
            0,
            0.25, 0.25
        )
    end

    -- render first character
    self:renderShadow(1, 25)
    self:renderAvatar(GTextures['character1-avatar'], 1)
    if self.selected == 1 then
        self:renderHighlight(1)
    end
    self:renderName('CAP\'N GUNS', (WINDOW_WIDTH / 4))

    -- render second character
    self:renderShadow(3, 25)
    self:renderAvatar(GTextures['character2-avatar'], 3)
    if self.selected == 2 then
        self:renderHighlight(3)
    end
    self:renderName('PLANK', (WINDOW_WIDTH / 4 * 3))
end

function SelectCharacterState:renderShadow(xOffset, yOffset)
    love.graphics.setColor(20/255, 20/255, 20/255, 1)
    love.graphics.rectangle('fill',
        ((WINDOW_WIDTH / 4 * xOffset ) - (AVATAR_WIDTH / 2)) + yOffset,
        ((WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2)) + yOffset,
        AVATAR_WIDTH, AVATAR_HEIGHT
    )
end

function SelectCharacterState:renderHighlight(xOffset)
    -- render opaque rectangle on top
    love.graphics.setColor(1, 1, 1, 50/255)
    love.graphics.rectangle('fill',
        (WINDOW_WIDTH / 4 * xOffset) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
        AVATAR_WIDTH, AVATAR_HEIGHT
    )
end

function SelectCharacterState:renderAvatar(texture, xOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(texture,
        (WINDOW_WIDTH / 4 * xOffset) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2)
    )
end

function SelectCharacterState:renderName(name, x)
    local fontWidth = GFonts['funkrocker-highscores']:getWidth(name)
    love.graphics.setFont(GFonts['funkrocker-highscores'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.print(name,
        x + 2, (WINDOW_HEIGHT / 3) + 2,
        0,
        1, 1,
        fontWidth / 2, 0,
        0, 0
    )
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.print(name,
        x, (WINDOW_HEIGHT / 3),
        0,
        1, 1,
        fontWidth / 2, 0,
        0, 0
    )
end