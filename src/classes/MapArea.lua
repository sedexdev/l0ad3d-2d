MapArea = Class{}

function MapArea:init(x, y, width, height, doorDef, numLamps, numGrills)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    -- door location (top, bottom, left, right), locked, x, y
    self.doorDef = doorDef
    self.numLamps = numLamps
    self.numGrills = numGrills
    self.floorTiles = {}
    self.wallTiles = {}
end

function MapArea:render()
    love.graphics.setColor(1, 1, 1, 1)
    self:drawFloorTiles()
    self:drawWallTiles()
end

function MapArea:drawFloorTiles()
    for y, tiles in pairs(self.floorTiles) do
        for x, tile in pairs(tiles) do
            love.graphics.draw(GTextures['floor-tiles'],
            tile,
            (x - 1) * (64 * 5) + 1, (y - 1) * (32 * 5) + 1,
            0,
            5, 5)
        end
    end
end

function MapArea:drawWallTiles()
    local tileScale = 16 * 5
    local drawHorizontalWall = function (y)
        for x, tile in pairs(self.wallTiles['horizontal']) do
            love.graphics.draw(GTextures['wall-topper'],
                tile,
                (x - 1) * (tileScale) - (tileScale), y,
                0,
                5, 5
            )
        end
    end
    local drawVerticalWall = function (x)
        for y, tile in pairs(self.wallTiles['vertical']) do
            love.graphics.draw(GTextures['wall-topper'],
                tile,
                x, (y - 1) * (tileScale),
                0,
                5, 5
            )
        end
    end
    drawHorizontalWall(-tileScale)
    drawHorizontalWall(self.height * (32 * 5))
    drawVerticalWall(-tileScale)
    drawVerticalWall(self.width * (64 * 5))
end

function MapArea:generateFloorTiles()
    for y = 1, self.height do
        table.insert(self.floorTiles, {})
        for _ = 1, self.width do
            table.insert(self.floorTiles[y], GQuads['floor-tiles'][math.random(6)])
        end
    end
end

function MapArea:generateWallTiles()
    self.wallTiles['horizontal'] = {}
    self.wallTiles['vertical'] = {}
    -- +2 to add the corner squares
    for x = 1, (self.width * 4) + 2 do
         table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
    end
    for x = 1, (self.height * 2) do
         table.insert(self.wallTiles['vertical'], GQuads['wall-topper'][1])
    end
end