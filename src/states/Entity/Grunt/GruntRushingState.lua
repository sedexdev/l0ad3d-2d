--[[
    GruntRushingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Grunt object when
        in a rushing state
]]

GruntRushingState = Class{__includes = BaseState}

--[[
    GruntRushingState constructor

    Params:
        area:             table       - MapArea object the Grunt was spawned in
        grunt:            table       - Grunt object whose state will be updated
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
        systemManager:    table       - SystemManager object
    Returns:
        nil
]]
function GruntRushingState:init(area, grunt, gruntSpriteBatch, systemManager)
    self.area = area
    self.grunt = grunt
    self.gruntSpriteBatch = gruntSpriteBatch
    self.systemManager = systemManager
end

--[[
    GruntRushingState update function. Compares the location of the
    <self.grunt> object to the location of the Player object and 
    forces the grunt to track the Players movement

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GruntRushingState:update(dt)
    -- call the Animation instance's update function 
    self.grunt.animations['walking-'..self.grunt.direction]:update(dt)
    -- change state if we are close to the player (change to use hitboxes later)
    if math.abs(self.systemManager.player.x - self.grunt.x) <= GRUNT_ATTACK_PROXIMITY and
       math.abs(self.systemManager.player.y - self.grunt.y) <= GRUNT_ATTACK_PROXIMITY then
        self.grunt.stateMachine:change('attacking')
    end
    -- check for wall collisions
    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
    else
        -- determine the direction the player is relative to the grunt
        if (self.systemManager.player.x < self.grunt.x) and (self.systemManager.player.y < self.grunt.y) then
            -- self.grunt is SOUTH-EAST of player
            self.grunt.direction = 'north-west'
            self.grunt.x = self.grunt.x - self.grunt.dx * dt
            self.grunt.y = self.grunt.y - self.grunt.dy * dt
        end
        if (self.systemManager.player.x < self.grunt.x) and (self.systemManager.player.y > self.grunt.y) then
            -- self.grunt is NORTH-EAST of player
            self.grunt.direction = 'south-west'
            self.grunt.x = self.grunt.x - self.grunt.dx * dt
            self.grunt.y = self.grunt.y + self.grunt.dy * dt
        end
        if (self.systemManager.player.x > self.grunt.x) and (self.systemManager.player.y < self.grunt.y) then
            -- self.grunt is SOUTH-WEST of player
            self.grunt.direction = 'north-east'
            self.grunt.x = self.grunt.x + self.grunt.dx * dt
            self.grunt.y = self.grunt.y - self.grunt.dy * dt
        end
        if (self.systemManager.player.x > self.grunt.x) and (self.systemManager.player.y > self.grunt.y) then
            -- self.grunt is NORTH-WEST of player
            self.grunt.direction = 'south-east'
            self.grunt.x = self.grunt.x + self.grunt.dx * dt
            self.grunt.y = self.grunt.y + self.grunt.dy * dt
        end
        -- abs the value to find if the player is on the same vertical or horizontal axis
        if (self.systemManager.player.x < self.grunt.x) and (math.abs(self.grunt.y - self.systemManager.player.y) <= ENTITY_AXIS_PROXIMITY) then
            -- self.grunt is EAST of player
            self.grunt.direction = 'west'
            self.grunt.x = self.grunt.x - self.grunt.dx * dt
        end
        if (self.systemManager.player.x > self.grunt.x) and (math.abs(self.grunt.y - self.systemManager.player.y) <= ENTITY_AXIS_PROXIMITY) then
            -- self.grunt is WEST of player
            self.grunt.direction = 'east'
            self.grunt.x = self.grunt.x + self.grunt.dx * dt
        end
        if (math.abs(self.grunt.x - self.systemManager.player.x) <= ENTITY_AXIS_PROXIMITY) and (self.systemManager.player.y < self.grunt.y) then
            -- self.grunt is SOUTH of player
            self.grunt.direction = 'north'
            self.grunt.y = self.grunt.y - self.grunt.dy * dt
        end
        if (math.abs(self.grunt.x - self.systemManager.player.x) <= ENTITY_AXIS_PROXIMITY) and (self.systemManager.player.y > self.grunt.y) then
            -- self.grunt is NORTH of player
            self.grunt.direction = 'south'
            self.grunt.y = self.grunt.y + self.grunt.dy * dt
        end
    end
    -- change to idle state if Player not in proximity
    if not self.systemManager.enemySystem:checkProximity(self.grunt) then
        self.grunt.stateMachine:change('idle')
    end
end

--[[
    GruntRushingState render function. Uses the current frame of the
    associated Animation instance as defined in GAnimationDefintions.grunt.animations

    Params:
        none
    Returns:
        nil
]]
function GruntRushingState:render()
    local currentFrame = self.grunt.animations['walking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 0, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
