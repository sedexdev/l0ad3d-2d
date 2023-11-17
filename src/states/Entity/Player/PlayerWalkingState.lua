--[[
    PlayerWalkingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations for the Player object when
        in a walking state
]]

PlayerWalkingState = Class{__includes = BaseState}

--[[
    PlayerWalkingState constructor

    Params:
        player: table - Player object whose state is being updated
        map:    table - Map object
    Returns:
        nil
]]
function PlayerWalkingState:init(player, map)
    self.player = player
    self.map = map
end

--[[
    PlayerWalkingState update function. Checks for keyboard input
    from the end user to determine how to update the walking animations
    of the <self.player> object. Also keeps track of the Map area/corridor
    the Player is currently in for the purposes of collision detection

    Key bindings:
        up, w:    player movement up
        right, d: player movement right
        down, s:  player movement down
        left, a:  player movement left
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayerWalkingState:update(dt)
    -- call the Animation instance's update function 
    self.player.animations['walking-'..self.player.direction]:update(dt)

    -- keep track of the players current area when moving
    if love.keyboard.anyDown(MOVEMENT_KEYS) then
        self.player:setCurrentArea(self.map.areas)
    end

    -- check for keyboard input by from the end user
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self:setDirection('north', dt)
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self:setDirection('east', dt)
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self:setDirection('south', dt)
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self:setDirection('west', dt)
    end
    if love.keyboard.multiplePressed('up', 'right') or love.keyboard.multiplePressed('w', 'd') then
        self:setDirection('north-east', dt)
    end
    if love.keyboard.multiplePressed('down', 'right') or love.keyboard.multiplePressed('s', 'd') then
        self:setDirection('south-east', dt)
    end
    if love.keyboard.multiplePressed('up', 'left') or love.keyboard.multiplePressed('w', 'a') then
        self:setDirection('north-west', dt)
    end
    if love.keyboard.multiplePressed('down', 'left') or love.keyboard.multiplePressed('s', 'a') then
        self:setDirection('south-west', dt)
    end
    -- change state to idle if the Player is not moving
    if not love.keyboard.anyDown(MOVEMENT_KEYS) then
        self.player.stateMachine:change('idle')
    end
end

--[[
    PlayerWalkingState render function. Uses the current frame 
    of the associated Animation instance as defined in 
    GAnimationDefintions.character<1|2>.animations

    Params:
        none
    Returns:
        nil
]]
function PlayerWalkingState:render()
    love.graphics.setColor(1, 1, 1, 1)
    if self.player.id == 1 then
        local currentFrame = self.player.animations['walking-'..self.player.direction]:getCurrentFrame()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.player.texture,
            GQuads['character1'][currentFrame],
            self.player.x, self.player.y
        )
    else
        local currentFrame = self.player.animations['walking-'..self.player.direction]:getCurrentFrame()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.player.texture,
            GQuads['character2'][currentFrame],
            self.player.x, self.player.y
        )
    end
end

--[[
    Sets the direction attribute on the <self.player> object and 
    updates the Players velocity in the correct direction

    Params:
        direction: string - current direction the Player is facing
        dt:        number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayerWalkingState:setDirection(direction, dt)
    if direction == 'north' then
        self.player.y = self.player.y - self.player.dy * dt
    end
    if direction == 'east' then
        self.player.x = self.player.x + self.player.dx * dt
    end
    if direction == 'south' then
        self.player.y = self.player.y + self.player.dy * dt
    end
    if direction == 'west' then
        self.player.x = self.player.x - self.player.dx * dt
    end
    self.player.lastDirection = self.player.direction
    self.player.direction = direction
end
