StateMachine = Class{}

function StateMachine:init(states)
    self.coreState = {
        render = function () end,
        update = function (_, dt) end,
        enter = function (_, params) end,
        exit = function () end,
    }
    self.states = states or {}
    self.current = self.coreState
end

function StateMachine:change(stateName, params)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(params)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end