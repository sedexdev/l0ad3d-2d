--[[
    BossWalkingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Boss object when
        in a walking state. The Boss only has a single state for
        movement and does not go idle or change state for attackin
]]

BossWalkingState = Class{__includes = BaseState}

--[[
    BossWalkingState constructor

    Params:
        boss: table - Boss object whose state will be updated
        player: table - Player object to use for the relative positioning of the Boss
    Returns:
        nil
]]
function BossWalkingState:init(boss, player)
    self.boss = boss
    self.player = player
end

--[[
    BossWalkingState update function. Compares the location of the 
    <self.boss> object to the location of the <self.player> object
    and forces the boss to track the Players movement

    TODO:
        make the boss circle the player, not run directly up to them

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function BossWalkingState:update(dt)
    -- call the Animation instance's update function 
    self.boss.animations['walking-'..self.boss.direction]:update(dt)

    -- determine the direction the player is relative to the boss
    -- make boss walk towards the player
    if (self.player.x < self.boss.x) and (self.player.y < self.boss.y) then
        -- boss is SOUTH-EAST of player
        self.boss.direction = 'north-west'
        self.boss.x = self.boss.x - self.boss.dx * dt
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (self.player.x < self.boss.x) and (self.player.y > self.boss.y) then
        -- boss is NORTH-EAST of player
        self.boss.direction = 'south-west'
        self.boss.x = self.boss.x - self.boss.dx * dt
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
    if (self.player.x > self.boss.x) and (self.player.y < self.boss.y) then
        -- boss is SOUTH-WEST of player
        self.boss.direction = 'north-east'
        self.boss.x = self.boss.x + self.boss.dx * dt
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (self.player.x > self.boss.x) and (self.player.y > self.boss.y) then
        -- boss is NORTH-WEST of player
        self.boss.direction = 'south-east'
        self.boss.x = self.boss.x + self.boss.dx * dt
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
    -- abs the value to find if the player is on the same vertical or horizontal axis
    if (self.player.x < self.boss.x) and (math.abs(self.boss.y - self.player.y) <= 10) then
        -- boss is EAST of player
        self.boss.direction = 'west'
        self.boss.x = self.boss.x - self.boss.dx * dt
    end
    if (self.player.x > self.boss.x) and (math.abs(self.boss.y - self.player.y) <= 10) then
        -- boss is WEST of player
        self.boss.direction = 'east'
        self.boss.x = self.boss.x + self.boss.dx * dt
    end
    if (math.abs(self.boss.x - self.player.x) <= 10) and (self.player.y < self.boss.y) then
        -- boss is SOUTH of player
        self.boss.direction = 'north'
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (math.abs(self.boss.x - self.player.x) <= 10) and (self.player.y > self.boss.y) then
        -- boss is NORTH of player
        self.boss.direction = 'south'
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
end

--[[
    BossWalkingState render function. Uses the current frame of the
    associated Animation instance as defined in GAnimationDefintions.boss.animations.

    Params:
        none
    Returns:
        nil
]]
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
