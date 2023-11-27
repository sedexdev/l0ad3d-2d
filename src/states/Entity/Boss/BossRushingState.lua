--[[
    BossRushingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Boss object when
        in a rushing state
]]

BossRushingState = Class{__includes = BaseState}

--[[
    BossRushingState constructor

    Params:
        area:          table - MapArea object the Boss is spawned in
        boss:          table - Boss object whose state will be updated
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function BossRushingState:init(area, boss, systemManager)
    self.area = area
    self.boss = boss
    self.systemManager.player= player
    self.systemManager = systemManager
end

--[[
    BossRushingState update function. Compares the location of the 
    <self.boss> object to the location of the <self.systemManager.player> object
    and forces the boss to track the Players movement

    TODO: make boss circle Player

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function BossRushingState:update(dt)
    -- call the Animation instance's update function 
    self.boss.animations['walking-'..self.boss.direction]:update(dt)

    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(self.area, self.boss)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handleEnemyWallCollision(self.boss, wallCollision.edge)
    end
    -- determine the direction the player is relative to the boss
    if (self.systemManager.player.x < self.boss.x) and (self.systemManager.player.y < self.boss.y) then
        -- boss is SOUTH-EAST of player
        self.boss.direction = 'north-west'
        self.boss.x = self.boss.x - self.boss.dx * dt
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (self.systemManager.player.x < self.boss.x) and (self.systemManager.player.y > self.boss.y) then
        -- boss is NORTH-EAST of player
        self.boss.direction = 'south-west'
        self.boss.x = self.boss.x - self.boss.dx * dt
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
    if (self.systemManager.player.x > self.boss.x) and (self.systemManager.player.y < self.boss.y) then
        -- boss is SOUTH-WEST of player
        self.boss.direction = 'north-east'
        self.boss.x = self.boss.x + self.boss.dx * dt
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (self.systemManager.player.x > self.boss.x) and (self.systemManager.player.y > self.boss.y) then
        -- boss is NORTH-WEST of player
        self.boss.direction = 'south-east'
        self.boss.x = self.boss.x + self.boss.dx * dt
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
    -- abs the value to find if the player is on the same vertical or horizontal axis
    if (self.systemManager.player.x < self.boss.x) and (math.abs(self.boss.y - self.systemManager.player.y) <= ENTITY_AXIS_PROXIMITY) then
        -- boss is EAST of player
        self.boss.direction = 'west'
        self.boss.x = self.boss.x - self.boss.dx * dt
    end
    if (self.systemManager.player.x > self.boss.x) and (math.abs(self.boss.y - self.systemManager.player.y) <= ENTITY_AXIS_PROXIMITY) then
        -- boss is WEST of player
        self.boss.direction = 'east'
        self.boss.x = self.boss.x + self.boss.dx * dt
    end
    if (math.abs(self.boss.x - self.systemManager.player.x) <= ENTITY_AXIS_PROXIMITY) and (self.systemManager.player.y < self.boss.y) then
        -- boss is SOUTH of player
        self.boss.direction = 'north'
        self.boss.y = self.boss.y - self.boss.dy * dt
    end
    if (math.abs(self.boss.x - self.systemManager.player.x) <= ENTITY_AXIS_PROXIMITY) and (self.systemManager.player.y > self.boss.y) then
        -- boss is NORTH of player
        self.boss.direction = 'south'
        self.boss.y = self.boss.y + self.boss.dy * dt
    end
end

--[[
    BossRushingState render function. Uses the current frame 
    of the associated Animation instance as defined in 
    GAnimationDefintions.boss.animations

    Params:
        none
    Returns:
        nil
]]
function BossRushingState:render()
    local currentFrame = self.boss.animations['walking-'..self.boss.direction]:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.boss.texture,
        GQuads['boss'][currentFrame],
        self.boss.x, self.boss.y,
        0,
        3, 3
    )
end
