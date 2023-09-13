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

-- dependencies are managed in a designated file
require 'src/utils/dependencies'

-- display the FPS at the top of the screen
local function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(GFonts['blood-small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

-- initialisation functions
function InitialiseWindow()
    love.window.setTitle('L0ad3d-2D')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = false
    })
    love.graphics.setBackgroundColor(10/255, 10/255, 10/255, 255/255)
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

function InitialiseFonts()
    GFonts = {
        ['blood-small'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 32),
        ['blood-menu'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 64),
        ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 160),
        ['blood-count'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 192),
    }
end

function InitialiseTextures()
    GTextures = {

    }
end

function InitialiseAudio()
    GAudio = {
        
    }
end

function InitialiseQuads()
    GQuads = {
        
    }
end

function InitialiseStateMachine()
    GStateMachine = StateMachine{
        ['menu'] = function() return MenuState() end,
        ['countdown'] = function() return CountdownState() end
    }
    GStateMachine:change('menu')
end

-- LOVE2D functions
function love.load()
    InitialiseWindow()
    InitialiseFonts()
    InitialiseTextures()
    InitialiseAudio()
    InitialiseQuads()
    InitialiseStateMachine()

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape'then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    GStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    GStateMachine:render()
    displayFPS()
end
