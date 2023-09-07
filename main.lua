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
    love.window.setTitle('L0ad3d-2D')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    love.graphics.setBackgroundColor(10/255, 10/255, 10/255, 255/255)
    BloodFont = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 64)
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape'then
        love.event.quit()
    end
end

function love.update(dt)
    
end

function love.draw()
    Push:apply('start')
    love.graphics.setFont(BloodFont)
    love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
    love.graphics.printf('L0ad3d-2D', 0, 80, VIRTUAL_WIDTH, 'center')
    Push:apply('end')
end
