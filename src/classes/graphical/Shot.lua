--[[
    Shot: class

    Description:
        Creates shot graphics to be rendered over a set interval
        when a game Entity ( Player | Boss | Turret ) fires their
        weapon
]]

Shot = Class{}

--[[
    Shot constructor. Defines a timer, interval, and boolean
    used to determine if the shot should still be rendered

    Params:
        entity: table - Entity object
    Returns:
        nil
]]
function Shot:init(entity)
    self.entity       = entity
    self.shotGraphic  = entity.fireShot
    self.shotTimer    = 0
    self.shotInterval = 0.1
    self.remove       = false
end

--[[
    Shot update function. Increments the <self.timer> attribute by
    <dt> on every frame update of the engine and checks if <self.timer>
    has passed <self.interval>. If it has <self.remove> is set to
    true and <self.timer> is reset

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Shot:update(dt)
    self.shotTimer = self.shotTimer + dt
    if self.shotTimer > self.shotInterval then
        self.shotTimer = self.shotTimer % self.shotInterval
        self.remove    = true
    end
end

--[[
    Shot render function. Calls a helper function to determine the
    coordintes and direction of the shot so it lines up correctly
    with the weapon when fired. For Player Entity objects the ID
    determines a different colour is used for the shot

    Params:
        none
    Returns:
        nil
]]
function Shot:render()
    if self.entity.type == 'turret' then
        local x, y = self:setTurretCoordinates()
        -- use the ANGLES constant to render at the correct angle 
        love.graphics.draw(self.shotGraphic,
            x, y,
            ANGLES[self.entity.direction]
        )
    else
        local x, y = self:setCoordinates(self.entity.x, self.entity.y)
        if self.entity.type == 'character' then
            if self.entity.id == 1 then
                love.graphics.setColor(1, 1, 1, 200/255)
            else
                love.graphics.setColor(30/255, 196/255, 195/255, 200/255)
            end
        else
            love.graphics.setColor(1, 1, 1, 200/255)
        end
        love.graphics.draw(self.shotGraphic, x, y, ANGLES[self.entity.direction])
    end
end

--[[
    Set's the (x, y) coordinate of the shot graphic so it
    renders correctly by appearing to eminate from the Entity's
    weapon. This function handles shot rendering at right angles. 
    Angles at 45, 135, 225, and 315 degrees are handled in the helper 
    function below

    Params:
        x: number - current x coordinate
        y: number - current y coordinate
    Returns:
        number: value representing the x offset required
        number: value representing the y offset required
]]
function Shot:setCoordinates(x, y)
    -- get offsets for adjusting the shot graphic
    local rightOffset = 20
    local leftOffset = 110
    if self.entity.direction == 'north' then
        return
            self.entity.currentWeapon == 'right'
                and x + rightOffset
                or x - leftOffset,
            y + (ENTITY_HEIGHT / 2)
    elseif self.entity.direction == 'south' then
        return
            self.entity.currentWeapon == 'right'
                and (x + ENTITY_WIDTH) - rightOffset
                or (x + ENTITY_WIDTH) + leftOffset,
            y + (ENTITY_HEIGHT / 2)
    elseif self.entity.direction == 'east' then
        return
            x + (ENTITY_WIDTH / 2),
            self.entity.currentWeapon == 'right'
                and y + rightOffset
                or y - leftOffset
    elseif self.entity.direction == 'west' then
        return
            x + (ENTITY_WIDTH / 2),
            self.entity.currentWeapon == 'right'
                and (y + ENTITY_HEIGHT) - rightOffset
                or (y + ENTITY_HEIGHT) + leftOffset
    else
        -- set coordinates for shots with an angle that is based on a 45 degree offset
        return self:set45DegreeCoordinates(x, y)
    end
end

--[[
    Set's the (x, y) coordinate of the shot graphic so it
    renders correctly by appearing to enimate from the Players
    weapon

    Params:
        x: number - current x coordinate
        y: number - current y coordinate
    Returns:
        number: value representing the x offset required
        number: value representing the y offset required
]]
function Shot:set45DegreeCoordinates(x, y)
    -- get offsets for adjusting the shot graphic
    local leftOffset = 30
    local rightOffset = 60
    local yOffset = 100
    -- small pixel offset required for better alignment
    local nudge = 20
    if self.entity.direction == 'north-east' then
        return
            self.entity.currentWeapon == 'right'
                and x + rightOffset
                or x - leftOffset,
            self.entity.currentWeapon == 'right'
                and y + (ENTITY_HEIGHT / 2) - yOffset
                or y
    end
    if self.entity.direction == 'south-west' then
        return
            self.entity.currentWeapon == 'right'
                and (x + ENTITY_WIDTH) - rightOffset
                or (x + ENTITY_WIDTH) + leftOffset,
            self.entity.currentWeapon == 'right'
                and y + (ENTITY_HEIGHT / 2) + yOffset
                or y + ENTITY_HEIGHT
    end
    if self.entity.direction == 'north-west' then
        return
            self.entity.currentWeapon == 'right'
                and (x + rightOffset) + nudge
                or (x - leftOffset) + nudge,
            self.entity.currentWeapon == 'right'
                and (y + (ENTITY_HEIGHT / 2) + yOffset) + nudge
                or (y + ENTITY_HEIGHT) + nudge
    end
    if self.entity.direction == 'south-east' then
        return
            self.entity.currentWeapon == 'right'
                and ((x + ENTITY_WIDTH) - rightOffset) - nudge
                or ((x + ENTITY_WIDTH) + leftOffset) - nudge,
            self.entity.currentWeapon == 'right'
                and (y + (ENTITY_HEIGHT / 2) - yOffset) - nudge
                or y - nudge
    end
end

--[[
    Sets the (x, y) coordinates for a turret shot

    Params:
        none
    Returns:
        number: shot x coordinate
        number: shot y coordinate
]]
function Shot:setTurretCoordinates()
    if self.entity.direction == 'north' then
        return self.entity.x - (TURRET_OFFSET * 2), self.entity.y - TURRET_HEIGHT + TURRET_OFFSET
    end
    if self.entity.direction == 'north-east' then
        return self.entity.x - TURRET_OFFSET, self.entity.y - (TURRET_OFFSET * 2)
    end
    if self.entity.direction == 'east' then
        return self.entity.x + TURRET_WIDTH - TURRET_OFFSET, self.entity.y - (ENEMY_SHOT_PX / 2) - TURRET_OFFSET
    end
    if self.entity.direction == 'south-east' then
        return self.entity.x + TURRET_WIDTH, self.entity.y - TURRET_OFFSET
    end
    if self.entity.direction == 'south' then
        return self.entity.x + (TURRET_OFFSET * 2.5), self.entity.y + TURRET_OFFSET
    end
    if self.entity.direction == 'south-west' then
        return self.entity.x + TURRET_OFFSET, self.entity.y + TURRET_HEIGHT
    end
    if self.entity.direction == 'west' then
        return self.entity.x - TURRET_OFFSET, self.entity.y + TURRET_HEIGHT
    end
    if self.entity.direction == 'north-west' then
        return self.entity.x - (TURRET_OFFSET * 2), self.entity.y + TURRET_OFFSET
    end
end
