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
        grunt:            table       - Grunt object whose state will be updated
        player:           table       - Player object
        gruntSpriteBatch: SpriteBatch - list of Grunt quads for rendering
    Returns:
        nil
]]
function GruntAttackingState:init(grunt, player, gruntSpriteBatch)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.gruntSpriteBatch = gruntSpriteBatch
    self.grunt = grunt
    self.player = player
end

--[[
    GruntAttackingState update function. Checks to see if the <self.player>
    object has moved away from the <self.grunt> by 100px and changes the 
    grunts state to rushing if so

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GruntAttackingState:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    -- call the Animation instance's update function 
    self.grunt.animations['attacking-'..self.grunt.direction]:update(dt)

    -- change state if we get further away from the player (change to use hitboxes later)
    if math.abs(self.player.x - self.grunt.x) > 150 or math.abs(self.player.y - self.grunt.y) > 150 then
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    local currentFrame = self.grunt.animations['attacking-'..self.grunt.direction]:getCurrentFrame()
    -- add the Grunt current quad to the SpriteBatch
    self.gruntSpriteBatch:clear()
    self.gruntSpriteBatch:add(GQuads['grunt'][currentFrame], self.grunt.x, self.grunt.y, 3, 3)
    -- render the Grunt quads
    self.gruntSpriteBatch:draw()
end
