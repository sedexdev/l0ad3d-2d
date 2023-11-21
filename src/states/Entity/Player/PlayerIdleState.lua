--[[
    PlayerIdleState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Implements the animations for the Player object when
        in an idle state
]]

PlayerIdleState = Class{__includes = BaseState}

--[[
    PlayerIdleState constructor

    Params:
        player: table - Player object whose state is being updated
    Returns:
        nil
]]
function PlayerIdleState:init(player)
    self.player = player
end

--[[
    PlayerIdleState update function. Checks for keyboard input
    from the end user to determine if the player is moving, changes
    state to walking if so

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayerIdleState:update(dt)
    -- update the player animations
    self.player.animations['idle-'..self.player.lastDirection]:update(dt)

    if not love.keyboard.anyDown(MOVEMENT_KEYS) then
        self.player.direction = self.player.lastDirection
    else
        self.player.stateMachine:change('walking')
    end
end

--[[
    PlayerIdleState render function. Uses the current frame 
    of the associated Animation instance as defined in 
    GAnimationDefintions.character<1|2>.animations

    Params:
        none
    Returns:
        nil
]]
function PlayerIdleState:render()
    if self.player.powerups.invincible then
        love.graphics.setColor(1, 1, 1, 100/255)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    if self.player.id == 1 then
        local currentFrame = self.player.animations['idle-'..self.player.lastDirection]:getCurrentFrame()
        love.graphics.draw(self.player.texture,
            GQuads['character1'][currentFrame],
            self.player.x, self.player.y
        )
    else
        local currentFrame = self.player.animations['idle-'..self.player.lastDirection]:getCurrentFrame()
        love.graphics.draw(self.player.texture,
            GQuads['character2'][currentFrame],
            self.player.x, self.player.y
        )
    end
end
