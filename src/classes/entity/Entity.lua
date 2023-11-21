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
        def: table - tEntity definition defined in src/utils/definitions.lua
    Returns:
        nil
]]
function Entity:init(def)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.type = def.type
    self.x = def.x
    self.y = def.y
    self.dx = def.dx
    self.dy = def.dy
    self.width = def.width
    self.height = def.height
    self.areaID = def.areaID
    self.stateMachine = def.stateMachine
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.stateMachine:render()
end
