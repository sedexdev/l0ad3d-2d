--[[
    Project name: L0ad3d-2D
    Description: This is a conecptual version of the classic 1995
                 PS1 game 'Loaded'. It features a small demo environment
                 to emulate the original in a 2D plane using Lua and
                 the LOVE2D game engine for development. All textures
                 were created by me using GIMP (excluding those mentioned
                below)

    Author: Andrew Macmillan
    Version: 1.0
]]

-- dependencies are managed in dependencies.lua
require 'src/utils/dependencies'

-- initialisation functions
function InitialiseWindow()
    love.window.setTitle('L0ad3d-2D')
    love.window.setMode(0, 0, {
        fullscreen = true,
        vsync = true,
        resizable = false
    })
    love.graphics.setBackgroundColor(10/255, 10/255, 10/255, 255/255)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.mouse.setVisible(false)
end

-- LOVE2D functions
function love.load()
    -- seed RNG
    math.randomseed(os.time())

    InitialiseWindow()
    GStateMachine:change('menu', {
        highScores = LoadHighScores()
    })

    GAudio['theme']:play()
    GAudio['theme']:setLooping(true)

    love.keyboard.keysPressed = {}
end

-- capture a keypress during gameplay
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- return a boolean saying whether a specific key was pressed
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- check if 2 keys are pressed at the same time
function love.keyboard.multiplePressed(key1, key2)
    return love.keyboard.isDown(key1) and love.keyboard.isDown(key2)
end

-- check if no keys are down
function love.keyboard.anyDown(t)
    for _, key in pairs(t) do
        if love.keyboard.isDown(key) then
            return true
        end
    end
    return false
end

-- update relative to delatime
function love.update(dt)
    GStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

-- render game textures and text
function love.draw()
    GStateMachine:render()
end
