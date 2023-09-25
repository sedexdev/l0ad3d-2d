-- split lines in file on comma
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

-- create score file if it doesn't exist
function CreateFile()
    love.filesystem.setIdentity('l0ad3d')
    local highScores = ''
    local name = 'L0AD'
    for i = 10, 1, -1 do
        highScores = highScores .. name .. ', ' .. tostring(i * 10000) .. '\n'
    end
    love.filesystem.write('l0ad3d.lst', highScores)
end

function WriteHighScores(highScores)
    love.filesystem.setIdentity('l0ad3d')
    love.filesystem.write('l0ad3d.lst', highScores)
end

-- load the highscores from file, or create the file
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
            name = data[1],
            score = data[2]
        }
        counter = counter + 1
    end
    return highScores
end