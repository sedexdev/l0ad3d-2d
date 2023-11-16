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
        grunt: table - Grunt object whose state will be updated
        player: table - Player object to use for the relative positioning of the Grunt
    Returns:
        nil
]]
function GruntAttackingState:init(grunt, player, gruntSpriteBatch)
    self.gruntSpriteBatch = gruntSpriteBatch
    self.grunt = grunt
    self.player = player
end

--[[
    GruntAttackingState update function. Checks to see if the <self.player>
    object has moved away from the <self.grunt> by 100px and changes the 
    grunts state to walking if so

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GruntAttackingState:update(dt)
    -- call the Animation instance's update function 
    self.grunt.animations['attacking-'..self.grunt.direction]:update(dt)

    -- change state if we get further away from the player (change to use hitboxes later)
    if math.abs(self.player.x - self.grunt.x) > 100 or math.abs(self.player.y - self.grunt.y) > 100 then
        self.grunt.stateMachine:change('walking')
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
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
