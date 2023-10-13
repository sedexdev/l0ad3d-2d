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
                atlas
            )
            counter = counter + 1
        end
    end

    return quads
end

function table.contains(T, value)
    for _, v in pairs(T) do
        if v == value then
            return true
        end
    end
    return false
end
