--[[
    BossIdleState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Boss object when
        in an idle state. Idle means the Boss Entity object is 
        moving the around the area in random directions for set 
        time intervals
]]

BossIdleState = Class{__includes = BaseState}

--[[
    BossIdleState constructor

    Params:
        area:          table - MapArea object the Boss is spawned in
        boss:          table - Boss object whose state will be updated
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function BossIdleState:init(area, boss, systemManager)
    self.area          = area
    self.boss          = boss
    self.systemManager = systemManager
    self.interval      = 0
    self.duration      = math.random(4, 6)
end

--[[
    BossIdleState update function. Moves the Boss around the 
    area in a random pattern that updates at a random interval
    of time

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function BossIdleState:update(dt)
    -- call the Animation instance's update function 
    self.boss.animations['walking-'..self.boss.direction]:update(dt)
    -- check for wall collisions
    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(self.area, self.boss)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handleEnemyWallCollision(self.boss, wallCollision.edge)
    end
    -- update boss (x, y) based on current direction
    if self.boss.direction == 'north' then
        self.boss.y = self.boss.y - self.boss.dy * dt
    elseif self.boss.direction == 'east' then
        self.boss.x = self.boss.x + self.boss.dx * dt
    elseif self.boss.direction == 'south' then
        self.boss.y = self.boss.y + self.boss.dy * dt
    elseif self.boss.direction == 'west' then
        self.boss.x = self.boss.x - self.boss.dx * dt
    elseif self.boss.direction == 'north-east' then
        self.boss.y = self.boss.y - self.boss.dy * dt
        self.boss.x = self.boss.x + self.boss.dx * dt
    elseif self.boss.direction == 'south-east' then
        self.boss.y = self.boss.y + self.boss.dy * dt
        self.boss.x = self.boss.x + self.boss.dx * dt
    elseif self.boss.direction == 'south-west' then
        self.boss.y = self.boss.y + self.boss.dy * dt
        self.boss.x = self.boss.x - self.boss.dx * dt
    elseif self.boss.direction == 'north-west' then
        self.boss.y = self.boss.y - self.boss.dy * dt
        self.boss.x = self.boss.x - self.boss.dx * dt
    end
    -- update direction after defined time interval
    self.interval = self.interval + dt
    if self.interval > self.duration then
        self.boss.direction = DIRECTIONS[math.random(1, 8)]
        self.duration = math.random(15, 20)
        self.interval = 0
    end
    -- TODO: start rushing when Player enters Boss area
    if self.systemManager.enemySystem:checkProximity(self.boss) then
        self.boss.stateMachine:change('rushing')
    end
end

--[[
    BossIdleState render function. Uses the current frame of the
    associated Animation instance as defined in GAnimationDefintions.boss.animations

    Params:
        none
    Returns:
        nil
]]
function BossIdleState:render()
    local currentFrame = self.boss.animations['walking-'..self.boss.direction]:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.boss.texture,
        GQuads['boss'][currentFrame],
        self.boss.x, self.boss.y,
        0,
        3, 3
    )
end
