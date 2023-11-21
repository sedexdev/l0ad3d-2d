--[[
    HUD: class

    Description:
        Initialises, updates, and renders out the Heads-up
        Display (HUD) for relaying game information to the
        end user such as ammo count, current health, powerups
        possed, and a map
]]

HUD = Class{}

function HUD:init()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    
end

function HUD:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    
end

function HUD:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    
end
