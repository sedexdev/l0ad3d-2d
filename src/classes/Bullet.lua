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
    self.x = x
    self.y = y
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
    elseif self.direction == 'south' then
    elseif self.direction == 'west' then
    elseif self.direction == 'north-east' then
    elseif self.direction == 'south-east' then
    elseif self.direction == 'south-west' then
    elseif self.direction == 'north-west' then
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
    
end
