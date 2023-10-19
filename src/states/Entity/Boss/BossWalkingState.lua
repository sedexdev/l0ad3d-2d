BossWalkingState = Class{__includes = BaseState}

function BossWalkingState:init(boss, player)
    self.boss = boss
    self.player = player
end

function BossWalkingState:update(dt)
    self.boss.animations['walking-'..self.boss.direction]:update(dt)

    -- determine the direction the player is relative to the boss
    -- make boss walk towards the player
    if (self.player.x < self.boss.x) and (self.player.y < self.boss.y) then
        -- boss is SOUTH-EAST of player
        self.boss.direction = 'north-west'
        self.boss.x = self.boss.x - self.boss.speed * dt
        self.boss.y = self.boss.y - self.boss.speed * dt
    end
    if (self.player.x < self.boss.x) and (self.player.y > self.boss.y) then
        -- boss is NORTH-EAST of player
        self.boss.direction = 'south-west'
        self.boss.x = self.boss.x - self.boss.speed * dt
        self.boss.y = self.boss.y + self.boss.speed * dt
    end
    if (self.player.x > self.boss.x) and (self.player.y < self.boss.y) then
        -- boss is SOUTH-WEST of player
        self.boss.direction = 'north-east'
        self.boss.x = self.boss.x + self.boss.speed * dt
        self.boss.y = self.boss.y - self.boss.speed * dt
    end
    if (self.player.x > self.boss.x) and (self.player.y > self.boss.y) then
        -- boss is NORTH-WEST of player
        self.boss.direction = 'south-east'
        self.boss.x = self.boss.x + self.boss.speed * dt
        self.boss.y = self.boss.y + self.boss.speed * dt
    end
    -- abs the value to find of the player is on the same vertical or horizontal axis
    if (self.player.x < self.boss.x) and (math.abs(self.boss.y - self.player.y) <= 10) then
        -- boss is EAST of player
        self.boss.direction = 'west'
        self.boss.x = self.boss.x - self.boss.speed * dt
    end
    if (self.player.x > self.boss.x) and (math.abs(self.boss.y - self.player.y) <= 10) then
        -- boss is WEST of player
        self.boss.direction = 'east'
        self.boss.x = self.boss.x + self.boss.speed * dt
    end
    if (math.abs(self.boss.x - self.player.x) <= 10) and (self.player.y < self.boss.y) then
        -- boss is SOUTH of player
        self.boss.direction = 'north'
        self.boss.y = self.boss.y - self.boss.speed * dt
    end
    if (math.abs(self.boss.x - self.player.x) <= 10) and (self.player.y > self.boss.y) then
        -- boss is NORTH of player
        self.boss.direction = 'south'
        self.boss.y = self.boss.y + self.boss.speed * dt
    end
end

function BossWalkingState:render()
    local currentFrame = self.boss.animations['walking-'..self.boss.direction]:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.boss.texture,
        GQuads['boss'][currentFrame],
        self.boss.x, self.boss.y,
        0,
        3, 3
    )
end