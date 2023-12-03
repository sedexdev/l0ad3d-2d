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
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
        systemManager:    table       - SystemManager object
    Returns:
        nil
]]
function GruntIdleState:init(area, grunt, gruntSpriteBatch, systemManager)
    self.area             = area
    self.grunt            = grunt
    self.gruntSpriteBatch = gruntSpriteBatch
    self.systemManager    = systemManager
    -- random direction change interval
    self.interval         = 0
    self.duration         = math.random(15, 20)
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
    -- call the Animation instance's update function 
    self.grunt.animations['walking-'..self.grunt.direction]:update(dt)
    -- check for wall collisions
    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
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
    -- if grunt in proximity with Player change to rushing state
    if self.systemManager.enemySystem:checkProximity(self.grunt) then
        self.grunt.stateMachine:change('rushing')
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
    local currentFrame = self.grunt.animations['walking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 0, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
