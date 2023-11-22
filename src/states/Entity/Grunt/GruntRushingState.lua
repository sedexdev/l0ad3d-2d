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
        area:              table       - MapArea object the Grunt was spawned in
        grunt:             table       - Grunt object whose state will be updated
        playerX:           table       - Player x to use for the relative positioning of the Grunt
        playerX:           table       - Player y to use for the relative positioning of the Grunt
        gruntSpriteBatch:  SpriteBatch - list of Grunt quads for rendering
        collisionSystem:   table       - CollisionSystem object
        enemySystem:       table       - EnemySystem object
    Returns:
        nil
]]
function GruntRushingState:init(area, grunt, playerX, playerY, gruntSpriteBatch, collisionSystem, enemySystem)
    self.area = area
    self.grunt = grunt
    self.playerX = playerX
    self.playerY = playerY
    self.gruntSpriteBatch = gruntSpriteBatch
    self.collisionSystem = collisionSystem
    self.enemySystem = enemySystem
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
    if math.abs(self.playerX - self.grunt.x) <= 150 and math.abs(self.playerY - self.grunt.y) <= 150 then
        self.grunt.stateMachine:change('attacking')
    end
    -- check for wall collisions
    local wallCollision = self.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
    end
    -- change to idle state if Player not in proximity
    if not self.enemySystem:checkProximity(self.grunt) then
        self.grunt.stateMachine:change('idle')
    end
    -- determine the direction the player is relative to the grunt
    if (self.playerX < self.grunt.x) and (self.playerY < self.grunt.y) then
        -- self.grunt is SOUTH-EAST of player
        self.grunt.direction = 'north-west'
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
    end
    if (self.playerX < self.grunt.x) and (self.playerY > self.grunt.y) then
        -- self.grunt is NORTH-EAST of player
        self.grunt.direction = 'south-west'
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
    end
    if (self.playerX > self.grunt.x) and (self.playerY < self.grunt.y) then
        -- self.grunt is SOUTH-WEST of player
        self.grunt.direction = 'north-east'
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
    end
    if (self.playerX > self.grunt.x) and (self.playerY > self.grunt.y) then
        -- self.grunt is NORTH-WEST of player
        self.grunt.direction = 'south-east'
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
    end
    -- abs the value to find if the player is on the same vertical or horizontal axis
    if (self.playerX < self.grunt.x) and (math.abs(self.grunt.y - self.playerY) <= ENTITY_AXIS_PROXIMITY) then
        -- self.grunt is EAST of player
        self.grunt.direction = 'west'
        self.grunt.x = self.grunt.x - self.grunt.dx * dt
    end
    if (self.playerX > self.grunt.x) and (math.abs(self.grunt.y - self.playerY) <= ENTITY_AXIS_PROXIMITY) then
        -- self.grunt is WEST of player
        self.grunt.direction = 'east'
        self.grunt.x = self.grunt.x + self.grunt.dx * dt
    end
    if (math.abs(self.grunt.x - self.playerX) <= ENTITY_AXIS_PROXIMITY) and (self.playerY < self.grunt.y) then
        -- self.grunt is SOUTH of player
        self.grunt.direction = 'north'
        self.grunt.y = self.grunt.y - self.grunt.dy * dt
    end
    if (math.abs(self.grunt.x - self.playerX) <= ENTITY_AXIS_PROXIMITY) and (self.playerY > self.grunt.y) then
        -- self.grunt is NORTH of player
        self.grunt.direction = 'south'
        self.grunt.y = self.grunt.y + self.grunt.dy * dt
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
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
