--[[
    Project name: L0ad3d-2D
    Description: This is a conecptual version of the classic 1995
                 PS1 game 'Loaded'. It features a small demo environment
                 to emulate the original in a 2D plane using Lua and
                 the LOVE2D game engine for development

    Author: Andrew Macmillan
    Version: 1.0
]]

-- debugger
-- require('lldebugger').start()

-- dependencies are managed in dependencies.lua
require 'src/utils/dependencies'

--[[
    Initialises the game window, setting the title, mode, background
    colour, default filter, and mouse configuration

    Params:
        none
    Returns:
        nil
]]
function InitialiseWindow()
    love.window.setTitle('L0ad3d-2D')
    love.window.setMode(0, 0, {
        fullscreen = true,
        vsync      = true,
        resizable  = false
    })
    love.graphics.setBackgroundColor(10/255, 10/255, 10/255, 255/255)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.mouse.setVisible(false)
end

--[[
    LOVE2D load function. Sets up the initial game environment
    when the game loads

    Params:
        none
    Returns:
        nil
]]
function love.load()
    -- seed RNG
    math.randomseed(os.time())
    InitialiseWindow()
    GStateMachine:change('menu', {
        highScores = LoadHighScores()
    })
    Audio_PlayTheme()
    love.keyboard.keysPressed = {}
end

--[[
    Captures keyboard input from the user and updates a boolean
    to state if the key has been pressed

    Params:
        key: string - key being pressed
    Returns:
        nil
]]
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--[[
    Returns a boolean stating whether a specific key was pressed

    Params:
        key: string - key to check for
    Returns:
        boolean: true if key was pressed
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Returns a boolean stating if 2 keys are pressed at the same time

    Params:
        key: string - key to check for
    Returns:
        boolean: true if both keys are pressed
]]
function love.keyboard.multiplePressed(key1, key2)
    return love.keyboard.isDown(key1) and love.keyboard.isDown(key2)
end

--[[
    Returns a boolean stating if any key in the table <t> is down

    Params:
        t: table - key to check for
    Returns:
        boolean: true if a key is down
]]
function love.keyboard.anyDown(t)
    for _, key in pairs(t) do
        if love.keyboard.isDown(key) then
            return true
        end
    end
    return false
end

--[[
    LOVE2D update function. Updates the games state machine and
    resets the <love.keyboard.keysPressed> table

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function love.update(dt)
    GStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

--[[
    LOVE2D render function. Renders the game state

    Params:
        none
    Returns:
        nil
]]
function love.draw()
    GStateMachine:render()
end
