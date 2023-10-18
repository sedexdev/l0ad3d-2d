GruntWalkingState = Class{__includes = BaseState}

function GruntWalkingState:init(grunt, player)
    self.grunt = grunt
    self.player = player
end

function GruntWalkingState:update(dt)
    self.grunt.animations['walking-'..self.grunt.direction]:update(dt)

    -- change state if we are close to the player (change to use hitboxes later)
    if math.abs(self.player.x - self.grunt.x) <= 100 and math.abs(self.player.y - self.grunt.y) <= 100 then
        self.grunt.stateMachine:change('attacking')
    end

    -- determine the direction the player is relative to the grunt
    -- make grunt walk towards the player
    if (self.player.x < self.grunt.x) and (self.player.y < self.grunt.y) then
        -- grunt is SOUTH-EAST of player
        self.grunt.direction = 'north-west'
        self.grunt.x = self.grunt.x - self.grunt.speed * dt
        self.grunt.y = self.grunt.y - self.grunt.speed * dt
    end
    if (self.player.x < self.grunt.x) and (self.player.y > self.grunt.y) then
        -- grunt is NORTH-EAST of player
        self.grunt.direction = 'south-west'
        self.grunt.x = self.grunt.x - self.grunt.speed * dt
        self.grunt.y = self.grunt.y + self.grunt.speed * dt
    end
    if (self.player.x > self.grunt.x) and (self.player.y < self.grunt.y) then
        -- grunt is SOUTH-WEST of player
        self.grunt.direction = 'north-east'
        self.grunt.x = self.grunt.x + self.grunt.speed * dt
        self.grunt.y = self.grunt.y - self.grunt.speed * dt
    end
    if (self.player.x > self.grunt.x) and (self.player.y > self.grunt.y) then
        -- grunt is NORTH-WEST of player
        self.grunt.direction = 'south-east'
        self.grunt.x = self.grunt.x + self.grunt.speed * dt
        self.grunt.y = self.grunt.y + self.grunt.speed * dt
    end
    -- abs the value to find of the player is on the same vertical or horizontal axis
    if (self.player.x < self.grunt.x) and (math.abs(self.grunt.y - self.player.y) <= 10) then
        -- grunt is EAST of player
        self.grunt.direction = 'west'
        self.grunt.x = self.grunt.x - self.grunt.speed * dt
    end
    if (self.player.x > self.grunt.x) and (math.abs(self.grunt.y - self.player.y) <= 10) then
        -- grunt is WEST of player
        self.grunt.direction = 'east'
        self.grunt.x = self.grunt.x + self.grunt.speed * dt
    end
    if (math.abs(self.grunt.x - self.player.x) <= 10) and (self.player.y < self.grunt.y) then
        -- grunt is SOUTH of player
        self.grunt.direction = 'north'
        self.grunt.y = self.grunt.y - self.grunt.speed * dt
    end
    if (math.abs(self.grunt.x - self.player.x) <= 10) and (self.player.y > self.grunt.y) then
        -- grunt is NORTH of player
        self.grunt.direction = 'south'
        self.grunt.y = self.grunt.y + self.grunt.speed * dt
    end
end

function GruntWalkingState:render()
    local currentFrame = self.grunt.animations['walking-'..self.grunt.direction]:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.grunt.texture,
        GQuads['grunt'][currentFrame],
        self.grunt.x, self.grunt.y,
        0,
        3, 3
    )
end