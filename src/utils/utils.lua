--[[
    Creates quads of a specific width/height from a given 
    sprite sheet and returns a table of quads

    Params:
        atlas:      Image  - sprite sheet to make quads from 
        tileWidth:  number - width of the quads
        tileHeight: number - height of the quads
    Returns:
        table: quads - a table of generated quads 
]]
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth, sheetHeight = atlas:getDimensions()
    local cols = sheetWidth / tileWidth
    local rows = math.floor(sheetHeight / tileHeight)
    local quads = {}
    local counter = 1
    for y = 1, rows do
        for x = 1, cols do
            quads[counter] = love.graphics.newQuad(
                (x - 1) * tileWidth,
                (y - 1) * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            counter = counter + 1
        end
    end
    return quads
end

--[[
    Makes a copy of a game Entity definition so the original
    definitions are not updated as the game progresses

    Disclaimer: non-original code sourced from 
    
        - http://lua-users.org/wiki/CopyTable

    Params:
        orig: table - table to copy data from
    Returns:
        table: copy of the given table
]]
function Copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Copy(orig_key)] = Copy(orig_value)
        end
        setmetatable(copy, Copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
