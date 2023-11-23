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
    self.id = id
    self.x = entity.x + (ENTITY_WIDTH / 2)
    self.y = entity.y + (ENTITY_WIDTH / 2)
    self.dx = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.dy = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.direction = entity.direction
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
    AABB collision detection for a passed in Entity to detect
    if the bullet hit the object

    Params;
        entity: table - entity to check collision on
    Returns:
        boolean: true if collision detected
]]
function Bullet:hit(entity)
    if (self.x > entity.x + entity.width) or (entity.x > self.x + BULLET_WIDTH) then
        return false
    end
    if (self.y > entity.y + entity.height) or (entity.y > self.y + BULLET_HEIGHT) then
        return false
    end
    return true
end

--[[
    AABB collision detection for a passed in object to detect
    if the bullet hit the object

    Params;
        none
    Returns:
        boolean: true if collision detected
]]
function Bullet:hitBoundary(areaID)
    if self.x < GMapAreaDefinitions[areaID].x then
        return true
    end
    if self.x > (GMapAreaDefinitions[areaID].x + GMapAreaDefinitions[areaID].width * FLOOR_TILE_WIDTH) then
        return true
    end
    if self.y < GMapAreaDefinitions[areaID].y then
        return true
    end
    if self.y > (GMapAreaDefinitions[areaID].y + GMapAreaDefinitions[areaID].height * FLOOR_TILE_HEIGHT) then
        return true
    end
    return false
end
