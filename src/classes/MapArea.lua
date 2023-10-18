MapArea = Class{}

function MapArea:init(x, y, width, height, corridors, adjacentArea)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.corridors = corridors -- use for collision detection
    self.adjacentArea = adjacentArea -- use for collision detection and door placement
    self.floorTiles = {}
    self.wallTiles = {}
end

function MapArea:render()
    love.graphics.setColor(1, 1, 1, 1)
    self:drawFloorTiles()
    self:drawWallTiles()
    if self.adjacentArea then
        self:drawAdjacentDoor()
    end
end

function MapArea:drawFloorTiles()
    for y, tiles in pairs(self.floorTiles) do
        for x, tile in pairs(tiles) do
            love.graphics.draw(GTextures['floor-tiles'],
            tile,
            self.x + ((x - 1) * (64 * 5)), self.y + ((y - 1) * (32 * 5)),
            0,
            5, 5)
        end
    end
end

function MapArea:drawWallTiles()
    local tileScale = 16 * 5
    self:drawHorizontalWall(-tileScale, tileScale, tileScale)
    self:drawHorizontalWall(self.height * (32 * 5), tileScale, tileScale)
    self:drawVerticalWall(-tileScale, tileScale)
    self:drawVerticalWall(self.width * (64 * 5), tileScale)
end

function MapArea:drawHorizontalWall(y, tileScale, offset)
    for x, tile in pairs(self.wallTiles['horizontal']) do
        -- -tilescale to pull the tiles back by 1 to fit in corners
        love.graphics.draw(GTextures['wall-topper'],
            tile,
            self.x + ((x - 1) * (tileScale) - (offset)), self.y + y,
            0,
            5, 5
        )
    end
end

function MapArea:drawVerticalWall(x, tileScale)
    for y, tile in pairs(self.wallTiles['vertical']) do
        love.graphics.draw(GTextures['wall-topper'],
            tile,
            self.x + x, self.y + ((y - 1) * (tileScale)),
            0,
            5, 5
        )
    end
end

function MapArea:drawAdjacentDoor()
    local tileScale = 16 * 5
    local rightXOffset = self.x + self.width * (64 * 5)
    local bottomYOffset = self.y + self.height * (32 * 5)
    local verticalTopDoorOffset = (self.height * (32 * 5) / 2) - (32 * 5)
    local verticalBottomDoorOffset = self.height * (32 * 5) / 2
    local horizontalLeftDoorOffset = (self.width * (64 * 5) / 2) - (32 * 5)
    local horizontalRightDoorOffset = self.width * (64 * 5) / 2

    local helper = function (doorID, x, y, orientation)
        love.graphics.draw(GTextures[orientation..'-doors'], GQuads[orientation..'-doors'][DOOR_IDS[doorID]], x, y, 0, 5, 5)
    end

    if self.adjacentArea[2] == 'L' then
        -- draw the under doors first
        helper('under', self.x - tileScale, self.y + verticalBottomDoorOffset, 'vertical')
        helper('under', self.x - tileScale, self.y + verticalTopDoorOffset, 'vertical')
        -- draw door centre left
        helper(self.adjacentArea[3], self.x - tileScale, self.y + verticalBottomDoorOffset, 'vertical')
        helper(self.adjacentArea[3], self.x - tileScale, self.y + verticalTopDoorOffset, 'vertical')
    elseif self.adjacentArea[2] == 'R' then
        -- draw the under doors first
        helper('under', rightXOffset, self.y + verticalBottomDoorOffset, 'vertical')
        helper('under', rightXOffset, self.y + verticalTopDoorOffset, 'vertical')
        -- draw door centre right
        helper(self.adjacentArea[3], rightXOffset, self.y + verticalBottomDoorOffset, 'vertical')
        helper(self.adjacentArea[3], rightXOffset, self.y + verticalTopDoorOffset, 'vertical')
    elseif self.adjacentArea[2] == 'T' then
        -- draw the under doors first
        helper('under', self.x + horizontalLeftDoorOffset, self.y - tileScale, 'horizontal')
        helper('under', self.x + horizontalRightDoorOffset, self.y - tileScale, 'horizontal')
        -- draw door centre top
        helper(self.adjacentArea[3], self.x + horizontalLeftDoorOffset, self.y - tileScale, 'horizontal')
        helper(self.adjacentArea[3], self.x + horizontalRightDoorOffset, self.y - tileScale, 'horizontal')
    else
        -- draw the under doors first
        helper('under', self.x + horizontalLeftDoorOffset, bottomYOffset, 'horizontal')
        helper('under', self.x + horizontalRightDoorOffset, bottomYOffset, 'horizontal')
        -- draw door centre bottom
        helper(self.adjacentArea[3], self.x + horizontalLeftDoorOffset, bottomYOffset, 'horizontal')
        helper(self.adjacentArea[3], self.x + horizontalRightDoorOffset, bottomYOffset, 'horizontal')
    end
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