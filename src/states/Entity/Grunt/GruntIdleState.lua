--[[
    GruntIdleState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Grunt object when
        in an idle state. Idle means the Grunt Entity object is 
        moving the around the area in random directions for set 
        time intervals
]]

GruntIdleState = Class{__includes = BaseState}

--[[
    GruntIdleState constructor

    Params:
        area:             table       - MapArea object the Grunt was spawned in
        grunt:            table       - Grunt object whose state will be updated
        player:           table       - Player object to use for the relative positioning of the Grunt
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
        collisionSystem:  table       - CollisionSystem object
        enemySystem:      table       - EnemySystem object
    Returns:
        nil
]]
function GruntIdleState:init(area, grunt, player, gruntSpriteBatch, collisionSystem, enemySystem)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.area = area
    self.grunt = grunt
    self.player = player
    self.gruntSpriteBatch = gruntSpriteBatch
    self.collisionSystem = collisionSystem
    self.enemySystem = enemySystem
    self.interval = 0
    self.duration = math.random(15, 20)
end

--[[
    GruntIdleState update function. Moves the Grunt around the 
    area in a random pattern that updates at a random interval
    of time

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GruntIdleState:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    -- call the Animation instance's update function 
    self.grunt.animations['walking-'..self.grunt.direction]:update(dt)
    -- check for wall collisions
    local wallCollision = self.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
    end
    -- if grunt in proximity with Player change to rushing state
    if self.enemySystem:checkProximity(self.grunt) then
        self.grunt.stateMachine:change('rushing')
    end
    -- update grunt (x, y) based on current direction
    if self.grunt.direction == 'north' then
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
    elseif self.grunt.direction == 'east' then
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
    elseif self.grunt.direction == 'south' then
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
    elseif self.grunt.direction == 'west' then
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
    elseif self.grunt.direction == 'north-east' then
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
    elseif self.grunt.direction == 'south-east' then
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
    elseif self.grunt.direction == 'south-west' then
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
    elseif self.grunt.direction == 'north-west' then
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
    end
    -- update direction after defined time interval
    self.interval = self.interval + dt
    if self.interval > self.duration then
        self.grunt.direction = DIRECTIONS[math.random(1, 8)]
        self.duration = math.random(8, 10)
        self.interval = 0
    end
end

--[[
    GruntIdleState render function. Uses the current frame 
    of the associated Animation instance as defined in 
    GAnimationDefintions.grunt.animations

    Params:
        none
    Returns:
        nil
]]
function GruntIdleState:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    local currentFrame = self.grunt.animations['walking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
