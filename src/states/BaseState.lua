BaseState = Class{}

-- base interface for other states to inherit from
function BaseState:init() end
function BaseState:update() end
function BaseState:render() end
function BaseState:enter() end
function BaseState:exit() end
