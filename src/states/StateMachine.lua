--[[
    StateMachine: class

    Description:
        Defines a state machine that can be used for either
        passing state between core game elements such as the 
        menu, character selection process, and playing/game 
        over state. Also used for Entity object animation
        updates by defining a state machine on the Entity which
        returns a different state based on end user/other Entity
        interactions
]]

StateMachine = Class{}

--[[
    StateMachine constructor

    Params:
        states: table - the state classes that can be manipulated by this state machine
    Returns:
        nil
]]
function StateMachine:init(states)
    -- defines the base functions of any instance of StateMachine
    self.coreState = {
        render = function () end,
        update = function (_, dt) end,
        enter  = function (_, params) end,
        exit   = function () end,
    }
    self.states  = states or {}
    self.current = self.coreState
    self.name    = nil
end

--[[
    Exits out of the <self.current> state and passes in
    the parameters defined in <params> to the next state's
    enter function

    Params:
        stateName: string - name of the state to change to
        params:    table  - list of parameters to pass into the new state
]]
function StateMachine:change(stateName, params)
    assert(self.states[stateName])
    self.name = stateName
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(params)
end

--[[
    StateMachine update function. Calls the update function of
    the state class stored in <self.current> passing <dt> as
    an argument
    
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function StateMachine:update(dt)
    self.current:update(dt)
end

--[[
    StateMachine render function. Calls the render function of
    the state class stored in <self.current>
    
    Params:
        none
    Returns:
        nil
]]
function StateMachine:render()
    self.current:render()
end
