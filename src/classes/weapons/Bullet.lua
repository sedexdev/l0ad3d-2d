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
        id:      number - id of this Bullet
        entity:  table  - Entity object
    Returns:
        nil
]]
function Bullet:init(id, entity)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.id = id
    self.entity = entity
    self.x = self.entity.x + (ENTITY_WIDTH / 2)
    self.y = self.entity.y + (ENTITY_WIDTH / 2)
    self.dx = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.dy = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.direction = self.entity.direction
end

--[[
    Bullet update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Bullet:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
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
    AABB collision detection for a passed in object to detect
    if the bullet hit the object

    Params;
        object: table - object to check collision on
    Returns:
        boolean: true if collision detected
]]
function Bullet:hit(object)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    if (self.x > object.x + object.width) or (object.x > self.x + BULLET_WIDTH) then
        return false
    end
    if (self.y > object.y + object.height) or (object.y > self.y + BULLET_HEIGHT) then
        return false
    end
    return true
end
