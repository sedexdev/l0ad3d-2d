PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player
end

function PlayerWalkingState:update(dt)
    self.player.animations['walking-'..self.player.direction]:update(dt)

    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self:setDirection('north', dt)
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self:setDirection('east', dt)
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self:setDirection('south', dt)
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self:setDirection('west', dt)
    end
    if love.keyboard.multiplePressed('up', 'right') or love.keyboard.multiplePressed('w', 'd') then
        self:setDirection('north-east', dt)
    end
    if love.keyboard.multiplePressed('down', 'right') or love.keyboard.multiplePressed('s', 'd') then
        self:setDirection('south-east', dt)
    end
    if love.keyboard.multiplePressed('up', 'left') or love.keyboard.multiplePressed('w', 'a') then
        self:setDirection('north-west', dt)
    end
    if love.keyboard.multiplePressed('down', 'left') or love.keyboard.multiplePressed('s', 'a') then
        self:setDirection('south-west', dt)
    end
    if not love.keyboard.anyDown(MOVEMENT_KEYS) then
        self.player.stateMachine:change('idle')
    end
end

function PlayerWalkingState:render()
    if self.player.id == 1 then
        -- render character 1
        local currentFrame = self.player.animations['walking-'..self.player.direction]:getCurrentFrame()
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

function PlayerWalkingState:setDirection(direction, dt)
    if direction == 'north' then
        self.player.y = self.player.y - self.player.speed * dt
    end
    if direction == 'east' then
        self.player.x = self.player.x + self.player.speed * dt
    end
    if direction == 'south' then
        self.player.y = self.player.y + self.player.speed * dt
    end
    if direction == 'west' then
        self.player.x = self.player.x - self.player.speed * dt
    end
    self.player.lastDirection = self.player.direction
    self.player.direction = direction
end