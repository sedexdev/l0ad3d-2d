--[[
    Creates quads of a specific width/height from a given 
    sprite sheet and returns a table

    Params:
        atlas: Image - sprite sheet to make quads from 
        tileWidth: number - width of the quads
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
