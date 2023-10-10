Corridor = Class{}

function Corridor:init()
    self.width = math.random(1, 3)
    self.height = math.random(5, 10)
    self.tiles = {}
    self.doors = {}
end

function Corridor:render()
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

function Corridor:generateTiles()
    for y = 1, self.height do
        table.insert(self.tiles, {})
        for _ = 1, self.width do
            table.insert(self.tiles[y], GQuads['floor-tiles'][math.random(6)])
        end
    end
end