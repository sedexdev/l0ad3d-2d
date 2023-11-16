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
        area: table - MapArea object the Boss is spawned in
        boss: table - Boss object whose state will be updated
        player: table - Player object to use for the relative positioning of the Boss
        collisionSystem: table - collisionSystem object
    Returns:
        nil
]]
function BossWalkingState:init(area, boss, player, collisionSystem, enemySystem)
    self.area = area
    self.boss = boss
    self.player = player
    self.collisionSystem = collisionSystem
    self.enemySystem = enemySystem
end

--[[
    BossWalkingState update function. Compares the location of the 
    <self.boss> object to the location of the <self.player> object
    and forces the boss to track the Players movement

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function BossWalkingState:update(dt)
    -- call the Animation instance's update function 
    self.boss.animations['walking-'..self.boss.direction]:update(dt)

    local wallCollision = self.collisionSystem:checkWallCollision(self.area, self.boss)
    if wallCollision.detected then
        -- handle the wall collision
        self.collisionSystem:handleEnemyWallCollision(self.boss, wallCollision.edge)
    end

    for _, adjacenyID in pairs(GAreaAdjacencies[self.area.id]) do
        -- if Player enters the area the Boss is in then update Boss (dx, dy)
        if self.player.currentArea.id == self.area.id or self.player.currentArea.id == adjacenyID then
            self.enemySystem:updateBossVelocity(self.boss, self.player, dt)
        end
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
