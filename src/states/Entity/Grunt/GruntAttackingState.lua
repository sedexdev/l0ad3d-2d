GruntAttackingState = Class{__includes = BaseState}

function GruntAttackingState:init(grunt, player)
    self.grunt = grunt
    self.player = player
end

function GruntAttackingState:update(dt)
    self.grunt.animations['attacking-'..self.grunt.direction]:update(dt)

    -- change state if we get further away from the player (change to use hitboxes later)
    if math.abs(self.player.x - self.grunt.x) > 100 or math.abs(self.player.y - self.grunt.y) > 100 then
        self.grunt.stateMachine:change('walking')
    end
end

function GruntAttackingState:render()
    local currentFrame = self.grunt.animations['attacking-'..self.grunt.direction]:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.grunt.texture,
        GQuads['grunt'][currentFrame],
        self.grunt.x, self.grunt.y,
        0,
        3, 3
    )
end