Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.dx = def.dx
    self.dy = def.dy
    self.width = def.width
    self.height = def.height
    self.stateMachine = def.stateMachine
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end