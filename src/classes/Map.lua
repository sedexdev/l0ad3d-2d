Map = Class{}

function Map:init()
    self.width = 100
    self.height = 150
    self.tiles = {}
end

function Map:update(dt)
    
end

function Map:generateTiles()
    for y = 1, self.height do
        table.insert(self.tiles, {})
        for _ = 1, self.width do
            table.insert(self.tiles[y], GQuads['floor-tiles'][math.random(6)])
        end
    end
end

function Map:render()
    love.graphics.setColor(1, 1, 1, 1)
    for y, tiles in pairs(self.tiles) do
        for x, tile in pairs(tiles) do
            love.graphics.draw(GTextures['floor-tiles'],
            tile,
            (x - 1) * (64 * 5) + 1, (y - 1) * (32 * 5) + 1,
            0,
            5, 5)
        end
    end
end