--[[
    GruntAttackingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations and AI for the Grunt object when
        in an attacking state
]]

GruntAttackingState = Class{__includes = BaseState}

--[[
    GruntAttackingState constructor

    Params:
        area:             table       - MapArea object the Grunt was spawned in
        grunt:            table       - Grunt object whose state will be updated
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
        systemManager:    table       - SystemManager object
    Returns:
        nil
]]
function GruntAttackingState:init(area, grunt, gruntSpriteBatch, systemManager)
    self.area = area
    self.gruntSpriteBatch = gruntSpriteBatch
    self.grunt = grunt
    self.systemManager = systemManager
end

--[[
    GruntAttackingState update function. Checks to see if the Player
        object has moved away from the grunt Entity by 150px and changes 
        the state to rushing if so
        
        Params:
        dt: number - deltatime counter for current frame rate
        Returns:
        nil
        ]]
function GruntAttackingState:update(dt)
    -- dispatch attack event after 1 second to allow PLayer to pass grunt without taking damage
    Event.dispatch('gruntAttack', self.grunt)
    -- call the Animation instance's update function 
    self.grunt.animations['attacking-'..self.grunt.direction]:update(dt)
    -- check for wall collisions
    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(self.area, self.grunt)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handleEnemyWallCollision(self.grunt, wallCollision.edge)
    end
    -- change state if we get further away from the player (change to use hitboxes later)
    if math.abs(self.systemManager.player.x - self.grunt.x) > GRUNT_ATTACK_PROXIMITY or
       math.abs(self.systemManager.player.y - self.grunt.y) > GRUNT_ATTACK_PROXIMITY then
        self.grunt.stateMachine:change('rushing')
    end
end

--[[
    GruntAttackingState render function. Uses the current frame of the
    associated Animation instance as defined in GAnimationDefintions.grunt.animations

    Params:
        none
    Returns:
        nil
]]
function GruntAttackingState:render()
    local currentFrame = self.grunt.animations['attacking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 0, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
