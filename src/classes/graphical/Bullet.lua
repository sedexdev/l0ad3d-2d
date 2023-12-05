--[[
    Bullet: class

    Includes: Obervable - parent class for observers

    Description:
        Creates a Bullet that travels across the (x, y) plane
        after a Shot instance has been created and 'fired'
]]

Bullet = Class{__includes = Observable}

--[[
    Bullet constructor

    Params:
        id:     number - id of this Bullet
        entity: table  - Entity object
    Returns:
        nil
]]
function Bullet:init(id, entity)
    self.id        = id
    self.entity    = entity
    self.x         = entity.x + (ENTITY_WIDTH / 2)
    self.y         = entity.y + (ENTITY_WIDTH / 2)
    self.dx        = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.dy        = entity.type == 'character' and BULLET_SPEED or ENEMY_BULLET_SPEED
    self.direction = entity.direction
    -- observers table
    self.observers = {}
end

--[[
    Bullet update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Bullet:update(dt)
    -- update Observers as the Bullet moves through the Map
    self:notify()
    -- set bullet (x, y) based on direction
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
    Subscribes an Observer to this Observable

    Params:
        observer: table - Observer object 
    Returns:
        nil
]]
function Bullet:subscribe(observer)
    table.insert(self.observers, observer)
end

--[[
    Unsubscribes an Observer to this Observable

    Params:
        observer: table - Observer object 
    Returns:
        nil
]]
function Bullet:unsubscribe(observer)
    local index
    for i = 1, #self.observers do
        if self.observers[i] == observer then
            index = i
            break
        end
    end
    if index ~= nil then
        self.observers[index] = nil
        table.remove(self.observers, index)
    end
end

--[[
    Notify function for this Observable class

    Params:
        none
    Returns:
        table: Player object data
]]
function Bullet:notify()
    for _, observer in pairs(self.observers) do
        observer:message({
            source = 'Bullet',
            id     = self.id,
            x      = self.x,
            y      = self.y,
            entity = self.entity,
            bullet = self
        })
    end
end
