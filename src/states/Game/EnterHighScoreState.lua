--[[
    EnterHighScoreState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Gives the user the ability to enter their name after
        having obtained a highscore. The highscore will subsequently
        be displayed in the highscores table rendered out by the
        HighScoreState class
]]

EnterHighScoreState = Class{__includes = BaseState}

--[[
    EnterHighScoreState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'enter-highscores' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.map        = params.map
    self.score      = params.score
    self.level      = params.level
    self.index      = params.index
end

--[[
    EnterHighScoreState constructor

    Params:
        none
    Returns:
        nil
]]
function EnterHighScoreState:init()
    self.selected   = 1
    -- starting ASCII chars for name entry
    self.chars      = {
        [1] = 65,
        [2] = 65,
        [3] = 65,
        [4] = 65,
    }
    -- char font size separators
    self.fontWidth  = GFonts['funkrocker-large']:getWidth('A')
    self.fontHeight = GFonts['funkrocker-large']:getHeight()
end

--[[
    EnterHighScoreState update function

    Key bindings:
        up:    moves the char selector up
        down:  moves the char selector down
        enter: selects the currently highlighted char
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local playerName = ''
        for i = 1, 4 do
            playerName = playerName .. string.char(self.chars[i])
        end
        -- shift high scores down to fit in new score
        for i = 10, self.index, -1 do
            -- break if we get to 1 - top score
            if i == 1 then break end
            self.highScores[i] = {
                name  = self.highScores[i - 1].name,
                level = self.highScores[i - 1].level,
                score = self.highScores[i - 1].score
            }
        end
        -- add the new highscore
        self.highScores[self.index].name  = playerName
        self.highScores[self.index].level = self.level
        self.highScores[self.index].score = self.score
        -- write the new high score to file
        WriteHighScores(self.highScores)
        -- change to highScoreState to view updated high scores table
        GStateMachine:change('highscores', {
            highScores = self.highScores
        })
    end
    -- handle user input to change name
    if love.keyboard.wasPressed('left') then
        Audio_MenuOption()
        self.selected = self.selected == 1 and 4 or self.selected - 1
    end
    if love.keyboard.wasPressed('right') then
        Audio_MenuOption()
        self.selected = self.selected == 4 and 1 or self.selected + 1
    end
    if love.keyboard.wasPressed('up') then
        Audio_MenuOption()
        self.chars[self.selected] = self.chars[self.selected] + 1
        if self.chars[self.selected] > 90 then
            self.chars[self.selected] = 65
        end
    end
    if love.keyboard.wasPressed('down') then
        Audio_MenuOption()
        self.chars[self.selected] = self.chars[self.selected] - 1
        if self.chars[self.selected] < 65 then
            self.chars[self.selected] = 90
        end
    end
end

--[[
    EnterHighScoreState render function 

    Params:
        none
    Returns;
        nil
]]
function EnterHighScoreState:render()
    -- display map in background
    self.map:render()
    -- draw dark background  
    love.graphics.setColor(10/255, 10/255, 10/255, 150/255)
    -- to keep things centered with the translation add the values to the (cameraX, cameraY) vector
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    -- display name input options
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.setFont(GFonts['funkrocker-medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 50, WINDOW_WIDTH, 'center')
    -- set font again so the letters are clearly visible
    love.graphics.setFont(GFonts['funkrocker-large'])
    -- render the 4 characters of the name
    if self.selected == 1 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[1]), (WINDOW_WIDTH / 2 - 300) - self.fontWidth / 2, (WINDOW_HEIGHT / 2) - self.fontHeight / 2)
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[2]), (WINDOW_WIDTH / 2 - 100) - self.fontWidth / 2, (WINDOW_HEIGHT / 2) - self.fontHeight / 2)
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == 3 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[3]), (WINDOW_WIDTH / 2 + 100) - self.fontWidth / 2, (WINDOW_HEIGHT / 2) - self.fontHeight / 2)
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == 4 then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[4]), (WINDOW_WIDTH / 2 + 300) - self.fontWidth / 2, (WINDOW_HEIGHT / 2) - self.fontHeight / 2)
    love.graphics.setColor(1, 0/255, 0/255, 1)
    -- display confirm message
    love.graphics.setFont(GFonts['funkrocker-smaller'])
    love.graphics.printf('Press Enter to confirm!', 0, WINDOW_HEIGHT - 200, WINDOW_WIDTH, 'center')
end
