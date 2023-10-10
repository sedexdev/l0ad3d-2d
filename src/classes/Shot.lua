Shot = Class{}

function Shot:init(player)
    self.player = player
    self.shotGraphic = player.fireShot
    self.shotTimer = 0
    self.shotInterval = 0.1
    self.renderShot = true
end

function Shot:update(dt)
    self.shotTimer = self.shotTimer + dt
    if self.shotTimer > self.shotInterval then
        self.shotTimer = self.shotTimer % self.shotInterval
        self.renderShot = false
    end
end

function Shot:render()
    local x, y = self:setCoordinates(self.player.x, self.player.y)
    love.graphics.draw(self.shotGraphic,
        x, y,
        ANGLES[self.player.direction]
    )
end

function Shot:setCoordinates(x, y)
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
        return self:set45DegreeCoordinates(x, y)
    end
end

function Shot:set45DegreeCoordinates(x, y)
    local leftOffset = 30
    local rightOffset = 60
    local yOffset = 100
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