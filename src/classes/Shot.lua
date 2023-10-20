--[[
    Shot: class

    Description:
        Creates shot graphics to be rendered over a set interval
        when the end user fires the Player weapon using the space
        key
]]

Shot = Class{}

--[[
    Shot constructor. Defines a timer, interval, and boolea
    used to determin if the shot should still be rendered

    Params:
        player: table - Player object who fired the shot
    Returns:
        nil
]]
function Shot:init(player)
    self.player = player
    self.shotGraphic = player.fireShot
    self.shotTimer = 0
    self.shotInterval = 0.1
    self.renderShot = true
end

--[[
    Shot update function. Increments the <self.timer> attribute by
    <dt> on every frame update of the engine and checks if <self.timer>
    has passed <self.interval>. If it has we set <self.renderShot> to
    false and reset <self.timer>

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Shot:update(dt)
    self.shotTimer = self.shotTimer + dt
    if self.shotTimer > self.shotInterval then
        self.shotTimer = self.shotTimer % self.shotInterval
        self.renderShot = false
    end
end

--[[
    Shot render function. Calls a helper function to determine the
    coordintes and direction of the shot so it lines up correctly
    with the Players weapon when fired. Depending on the Player ID
    a different colour is used for the shot

    Params:
        none
    Returns:
        nil
]]
function Shot:render()
    local x, y = self:setCoordinates(self.player.x, self.player.y)
    if self.player.id == 1 then
        love.graphics.setColor(1, 1, 1, 200/255)
    else
        love.graphics.setColor(30/255, 196/255, 195/255, 200/255)
    end
    -- use the ANGLES constant to render at the correct angle 
    love.graphics.draw(self.shotGraphic, x, y, ANGLES[self.player.direction])
end

--[[
    Set's the (x, y) coordinate of the shot graphic so it
    renders correctly by appearing to enimate from the Players
    weapon. This function handles shot rendering at multiples
    of 90 degrees. Angles with multiples of 45 degrees are
    handled in the helper function below

    Params:
        x: <self.player> current x coordinate
        y: <self.player> current y coordinate
    Returns:
        number: value representing the x offset required based on 
                the <self.player.direction> and <self.player.currentWeapon>
        number: value representing the y offset required based on 
                the <self.player.direction> and <self.player.currentWeapon>
]]
function Shot:setCoordinates(x, y)
    -- get offsets for adjusting the shot graphic
    local rightOffset = 20
    local leftOffset = 110
    if self.player.direction == 'north' then
        return
            self.player.currentWeapon == 'right'
                and x + rightOffset
                or x - leftOffset,
            y + (CHARACTER_HEIGHT / 2)
    elseif self.player.direction == 'south' then
        return
            self.player.currentWeapon == 'right'
                and (x + CHARACTER_WIDTH) - rightOffset
                or (x + CHARACTER_WIDTH) + leftOffset,
            y + (CHARACTER_HEIGHT / 2)
    elseif self.player.direction == 'east' then
        return
            x + (CHARACTER_WIDTH / 2),
            self.player.currentWeapon == 'right'
                and y + rightOffset
                or y - leftOffset
    elseif self.player.direction == 'west' then
        return
            x + (CHARACTER_WIDTH / 2),
            self.player.currentWeapon == 'right'
                and (y + CHARACTER_HEIGHT) - rightOffset
                or (y + CHARACTER_HEIGHT) + leftOffset
    else
        -- set coordinates for shots with an angle that is based on a 45 degree offset
        return self:set45DegreeCoordinates(x, y)
    end
end

--[[
    Set's the (x, y) coordinate of the shot graphic so it
    renders correctly by appearing to enimate from the Players
    weapon. This function handles shot rendering at multiples
    of 45 degrees

    Params:
        x: <self.player> current x coordinate
        y: <self.player> current y coordinate
    Returns:
        number: value representing the x offset required based on 
                the <self.player.direction> and <self.player.currentWeapon>
        number: value representing the y offset required based on 
                the <self.player.direction> and <self.player.currentWeapon>
]]
function Shot:set45DegreeCoordinates(x, y)
    -- get offsets for adjusting the shot graphic
    local leftOffset = 30
    local rightOffset = 60
    local yOffset = 100
    -- small pixel offset required for better alignment
    local nudge = 20
    if self.player.direction == 'north-east' then
        return
            self.player.currentWeapon == 'right'
                and x + rightOffset
                or x - leftOffset,
            self.player.currentWeapon == 'right'
                and y + (CHARACTER_HEIGHT / 2) - yOffset
                or y
    end
    if self.player.direction == 'south-west' then
        return
            self.player.currentWeapon == 'right'
                and (x + CHARACTER_WIDTH) - rightOffset
                or (x + CHARACTER_WIDTH) + leftOffset,
            self.player.currentWeapon == 'right'
                and y + (CHARACTER_HEIGHT / 2) + yOffset
                or y + CHARACTER_HEIGHT
    end
    if self.player.direction == 'north-west' then
        return
            self.player.currentWeapon == 'right'
                and (x + rightOffset) + nudge
                or (x - leftOffset) + nudge,
            self.player.currentWeapon == 'right'
                and (y + (CHARACTER_HEIGHT / 2) + yOffset) + nudge
                or (y + CHARACTER_HEIGHT) + nudge
    end
    if self.player.direction == 'south-east' then
        return
            self.player.currentWeapon == 'right'
                and ((x + CHARACTER_WIDTH) - rightOffset) - nudge
                or ((x + CHARACTER_WIDTH) + leftOffset) - nudge,
            self.player.currentWeapon == 'right'
                and (y + (CHARACTER_HEIGHT / 2) - yOffset) - nudge
                or y - nudge
    end
end