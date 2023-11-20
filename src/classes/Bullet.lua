--[[
    Bullet: class

    Description:
        Creates a Bullet that travels across the (x, y) plane
        after a Shot instance has been created and 'fired'
]]

Bullet = Class{}

--[[
    Bullet constructor

    Params:
        entity:    table  - Entity object
        x:         number - x coordinate of the bullet
        y:         number - y coordinate of the bullet 
        direction: string - direction to travel in
    Returns:
        nil
]]
function Bullet:init(entity, x, y, direction)
    self.entity = entity
    self.x = self.entity.x + (ENTITY_WIDTH / 2)
    self.y = self.entity.y + (ENTITY_WIDTH / 2)
    self.dx = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.dy = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.direction = direction
end

--[[
    Bullet update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Bullet:update(dt)
    if self.direction == 'north' then
        self.y = self.y - self.dy * dt
    elseif self.direction == 'east' then
        self.x = self.x + self.dx * dt
    elseif self.direction == 'south' then
        self.y = self.y + self.dy * dt
    elseif self.direction == 'west' then
        self.x = self.x - self.dx * dt
    elseif self.direction == 'north-east' then
        self.x = self.x + self.dx * dt
        self.y = self.y - self.dy * dt
    elseif self.direction == 'south-east' then
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
    elseif self.direction == 'south-west' then
        self.x = self.x - self.dx * dt
        self.y = self.y + self.dy * dt
    elseif self.direction == 'north-west' then
        self.x = self.x - self.dx * dt
        self.y = self.y - self.dy * dt
    end
end

--[[
    Bullet render function

    Params:
        none
    Returns:
        nil
]]
function Bullet:render()
    love.graphics.setColor(1, 0/255, 0/255, 255/255)
    love.graphics.circle('fill', self.x, self.y, 5)
end
