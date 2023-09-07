--[[
    Project name: L0ad3d-2D
    Description: This is a conecptual version of the classic 1995
                 PS1 game 'Loaded'. It features a small demo environment
                 to emulate the original in a 2D plane using Lua and
                 the LOVE2D game engine for development. All textures
                 were created by me using GIMP.

    Author: Andrew Macmillan
    Version: 1.0

    Non-original sources:
        HoMicIDE EFfeCt.ttf - https://www.fontsaddict.com/font/homicide-effect.html
]]

-- Dependencies are managed in a designated file
require 'src/utils/dependencies'

function love.load()
    
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
    
end

function love.draw()
    Push:apply('start')
    
    Push:apply('end')
end
