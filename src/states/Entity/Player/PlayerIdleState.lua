PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player
end

function PlayerIdleState:update(dt)
    -- update the player animations
    self.player.animations['idle-'..self.player.lastDirection]:update(dt)

    if not love.keyboard.anyDown(MOVEMENT_KEYS) then
        self.player.direction = self.player.lastDirection
    else
        self.player.stateMachine:change('walking')
    end
end

function PlayerIdleState:render()
    if self.player.id == 1 then
        -- render character 1
        local currentFrame = self.player.animations['idle-'..self.player.lastDirection]:getCurrentFrame()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.player.texture,
            GQuads['character1'][currentFrame],
            self.player.x, self.player.y
        )
    else
        -- render circle for now
        love.graphics.setColor(0/255, 0/255, 1, 1)
        love.graphics.circle("fill", self.x, self.y, 16)
    end
end