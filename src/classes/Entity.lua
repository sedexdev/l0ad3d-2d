--[[
    Entity: class

    Description:
        An entity is a game character that can move around the
        game map. It is defined by an (x, y) location in the 2D plane,
        has a velocity, and width and height, and a state machine for
        changing animations depending on the interactions from the 
        end user or other Entity objects
]]

Entity = Class{}

--[[
    Boss constructor

    Params:
        def: table - the definition of a subclass object as defined 
                     in src/utils/definitions.lua
    Returns:
        nil
]]
function Entity:init(def)
    self.type = def.type
    self.x = def.x
    self.y = def.y
    self.dx = def.dx
    self.dy = def.dy
    self.width = def.width
    self.height = def.height
    self.stateMachine = def.stateMachine
end

--[[
    Collision detectio algorithm to detect collisions with other
    Entity objects. The function uses Axis-Aligned Bounding Boxes
    (AABB) to detect overlaps between sprites

    Params:
        entity: table - an Entity object to compare location with
    Returns:
        boolean: true of collision detected, false if not
]]
function Entity:collides(entity)
    -- AABB collision detection algorithm
    if (self.x > entity.x + entity.width) or (entity.x > self.x + self.width) then
        return false
    end
    if (self.y > entity.y + entity.height) or (entity.height > self.y + self.height) then
        return false
    end
    return true
end

--[[
    Entity update function. Calls <self.stateMachine> update function,
    passing <dt> as an arguments. This updates the Entity according to
    its current state

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Entity:update(dt)
    self.stateMachine:update(dt)
end

--[[
    Entity update function. Calls <self.stateMachine> render function.
    This renders the Entity according to its current state

    Params:
        none
    Returns:
        nil
]]
function Entity:render()
    self.stateMachine:render()
end
