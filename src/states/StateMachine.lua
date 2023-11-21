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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    -- defines the base functions of any instance of StateMachine
    self.coreState = {
        render = function () end,
        update = function (_, dt) end,
        enter = function (_, params) end,
        exit = function () end,
    }
    self.states = states or {}
    self.current = self.coreState
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    assert(self.states[stateName])
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.current:render()
end