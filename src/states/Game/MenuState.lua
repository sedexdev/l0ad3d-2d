--[[
    MenuState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Defines and renders the options menu at the beginning of 
        the game. The menu is the first state the game enters
        into once running
]]

MenuState = Class{__includes = BaseState}

--[[
    MenuState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'menu' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function MenuState:enter(params)
    self.highScores = params.highScores
end

--[[
    MenuState constructor. The <self.bulletOffsets> table defines
    the sequentially rendered bullet holes that are fired on the 
    menu screen. The 4 Timer.after callbacks play the GAudio['gunshot']
    sound at equal intervals to the bullet holes being rendered.
    Time.after is then called again to unpause user input once the 
    shots and audio have been rendered/played

    Params:
        none
    Returns:
        nil
]]
function MenuState:init()
    self.selected = 1
    self.bulletOffsets = {
        [1] = {x = 1, y = 55, rendered = false},
        [2] = {x = 3, y = -50, rendered = false},
        [3] = {x = 4, y = 45, rendered = false},
        [4] = {x = 6, y = -20, rendered = false},
    }
    self.pauseInput = true
    for i = 1, 4 do
        Timer.after(i * 0.3, function ()
            -- set rendered to true so the graphic can be drawn to the screen
            self.bulletOffsets[i].rendered = true
            GAudio['gunshot']:stop()
            GAudio['gunshot']:play()
        end)
    end
    Timer.after(1.2, function ()
        self.pauseInput = false
    end)
end

--[[
    MenuState update function. Allows the player to choose options
    and updates the game state based on the choice made. Also updates 
    the Timer so the gunshot effects play relative to deltatime  

    Key bindings:
        up: moves the menu selector up
        down: moves the menu selector down
        enter: selects the currently highlighted option
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function MenuState:update(dt)
    if not self.pauseInput then
        if love.keyboard.wasPressed('up') then
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected <= 1 and 3 or self.selected - 1
        end
        if love.keyboard.wasPressed('down') then
            GAudio['select']:stop()
            GAudio['select']:play()
            self.selected = self.selected >= 3 and 1 or self.selected + 1
        end
    
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            GAudio['select']:stop()
            GAudio['gunshot']:play()
            if self.selected == 1 then
                GStateMachine:change('select', {
                    highScores = self.highScores
                })
            elseif self.selected == 2 then
                GStateMachine:change('highscores', {
                    highScores = self.highScores
                })
            else
                love.event.quit()
            end
        end
    end

    Timer.update(dt)
end

--[[
    MenuState render function. Draws out the menu options using a
    helper function defined below, as well as rendering out the
    bullet hole graphics based on the values of <self.bulletOffsets[i].rendered>

    Params:
        none
    Returns;
        nil
]]
function MenuState:render()
    -- draw background
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['grey-background'],
        0, 0,
        0,
        WINDOW_WIDTH / GTextures['grey-background']:getWidth(),
        WINDOW_WIDTH / GTextures['grey-background']:getHeight()
    )

    -- draw bullet holes
     for i = 1, 4 do
        if self.bulletOffsets[i].rendered then
            love.graphics.draw(GTextures['bullet-hole'],
                (WINDOW_WIDTH / 8) * self.bulletOffsets[i].x, (WINDOW_HEIGHT / 4) + self.bulletOffsets[i].y,
                0,
                0.25, 0.25
            )
        end
    end

    -- draw title
    love.graphics.setFont(GFonts['blood-title'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf('L0ad3d-2D', 2, (WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf('L0ad3d-2D', 2, (WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('L0ad3d-2D', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')

    -- draw menu
    love.graphics.setFont(GFonts['funkrocker-menu'])

    self:renderOption('LOAD UP', 1, 200)
    self:renderOption('HIGH SCORE', 2, 300)
    self:renderOption('QUIT', 3, 400)

    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
end

--[[
    Renders the menu options using a provided y offset

    Params:
        name: string - name of the menu option
        id: number - id used to verify what has been selected
        yOffset: number - y offset used to render the menu options in a stack
    Returns;
        nil
]]
function MenuState:renderOption(name, id, yOffset)
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf(name, 2, (WINDOW_HEIGHT / 3 + yOffset) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(name, 2, (WINDOW_HEIGHT / 3 + yOffset) + 2, WINDOW_WIDTH, 'center')
    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == id then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf(name, 0, WINDOW_HEIGHT / 3 + yOffset, WINDOW_WIDTH, 'center')
end
