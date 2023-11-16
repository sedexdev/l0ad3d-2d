--[[
    GruntWalkingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Grunt object when
        in a walking state
]]

GruntWalkingState = Class{__includes = BaseState}

--[[
    GruntWalkingState constructor

    Params:
    area: table - MapArea object the Grunt was spawned in
        grunt: table - Grunt object whose state will be updated
        player: table - Player object to use for the relative positioning of the Grunt
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
        collisionSystem: table - CollisionSystem object
        enemySystem: table - EnemySystem object
    Returns:
        nil
]]
function GruntWalkingState:init(area, grunt, player, gruntSpriteBatch, collisionSystem, enemySystem)
    self.area = area
    self.grunt = grunt
    self.player = player
    self.gruntSpriteBatch = gruntSpriteBatch
    self.collisionSystem = collisionSystem
    self.enemySystem = enemySystem
end

--[[
    GruntWalkingState update function. Compares the location of the 
    <self.grunt> object to the location of the <self.player> object
    and forces the grunt to track the Players movement

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GruntWalkingState:update(dt)
    -- call the Animation instance's update function 
    self.grunt.animations['walking-'..self.grunt.direction]:update(dt)

    -- change state if we are close to the player (change to use hitboxes later)
    if math.abs(self.player.x - self.grunt.x) <= 100 and math.abs(self.player.y - self.grunt.y) <= 100 then
        self.grunt.stateMachine:change('attacking')
    end

    local wallCollision = self.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
    end

    self.enemySystem:updateGruntVelocity(self.grunt, self.player, dt)
end

--[[
    GruntWalkingState render function. Uses the current frame of the
    associated Animation instance as defined in GAnimationDefintions.grunt.animations

    Params:
        none
    Returns:
        nil
]]
function GruntWalkingState:render()
    local currentFrame = self.grunt.animations['walking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
