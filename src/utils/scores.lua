--[[
    String split function used to split a string into
    sub-strings based on a separator

    Params:
        str: string - string to split
        sep: string - seperator to split on
    Returns:
        table: list of sub-strings after splitting
]]
local function split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

--[[
    Creates and writes score file to disk if it doesn't exist

    Params:
        none
    Returns:
        nil
]]
function CreateFile()
    love.filesystem.setIdentity('l0ad3d')
    local highScores = ''
    local name = 'L0AD'
    for i = 10, 1, -1 do
        highScores = highScores .. name .. ', ' .. tostring(1) .. ', ' .. tostring(i * 10000) .. '\n'
    end
    love.filesystem.write('l0ad3d.lst', highScores)
end

--[[
    Writes highScores string file to disk

    Params:
        highScores: string - string data of high scores table
    Returns:
        nil
]]
function WriteHighScores(highScores)
    love.filesystem.setIdentity('l0ad3d')
    local scores = ''
    for i = 1, 10 do
        scores = scores .. highScores[i].name .. ', ' .. tostring(highScores[i].level) .. ', ' .. tostring(highScores[i].score .. '\n')
    end
    love.filesystem.write('l0ad3d.lst', scores)
end

--[[
    Loads the high scores from file, or creates the file
    if it doesn't exist

    Params:
        none
    Returns:
        nil
]]
function LoadHighScores()
    love.filesystem.setIdentity('l0ad3d')
    if not love.filesystem.getInfo('l0ad3d.lst') then
        CreateFile()
    end
    local highScores = {}
    local counter = 1
    for line in love.filesystem.lines('l0ad3d.lst') do
        local data = split(line, ',')
        highScores[counter] = {
            name  = data[1],
            level = data[2],
            score = data[3]
        }
        counter = counter + 1
    end
    return highScores
end

--[[
    Checks the highscores table to see if the passed in
    score can be added to the table. If so it returns the
    index to add the score at

    Params:
        highScores: table  - high scores table
        score:      number - score obtained by the player
    Returns:
        number: index to add score at, or nil
]]
function CheckHighScore(highScores, score)
    -- loop over highScores table to check for new high score
    for i = 1, #highScores do
        if score > tonumber(highScores[i].score) then
            return i
        end
    end
end