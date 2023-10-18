MapCorridor = Class{__includes = MapArea}

function MapCorridor:init(x, y, width, height, direction, bend, junction, doorIDs)
    MapArea.init(self, x, y, width, height)
    self.direction = direction
    self.bend = bend
    self.bendWall = {}
    self.junction = junction
    self.doorIDs = doorIDs
    self.wallTiles = {}
end

function MapCorridor:render()
    love.graphics.setColor(1, 1, 1, 1)
    MapArea.drawFloorTiles(self)
    self:drawWallTiles()
    self:drawDoors()
end

function MapCorridor:drawWallTiles()
    local tileScale = 16 * 5
    if self.direction == 'horizontal' then
        if self.bend then
            self:drawBendWallTilesHorizontal(tileScale)
        else
            -- call parent class functions to draw the wall
            MapArea.drawHorizontalWall(self, -tileScale, tileScale, 0)
            MapArea.drawHorizontalWall(self, self.height * (32 * 5), tileScale, 0)
        end
    else
        if self.bend then
            self:drawBendWallTilesVertical(tileScale)
        else
            MapArea.drawVerticalWall(self, -tileScale, tileScale)
            MapArea.drawVerticalWall(self, self.width * (64 * 5), tileScale)
        end
    end
end

-- draws a shorter wall on the side that has the bend
-- then draws a normal wall on the opposite side
function MapCorridor:drawBendWallTilesHorizontal(tileScale)
    local wallTileCount = self.width * (64 * 5) / tileScale
    local yOffset = self.height * (32 * 5)
    local helper = function (start, limit, y)
        for i = start, limit - 1 do
            love.graphics.draw(GTextures['wall-topper'], GQuads['wall-topper'][1], self.x + (i * tileScale), y, 0, 5, 5)
        end
    end
    -- check which corner has the bend
    if self.bend == 'LT' then
        helper(5, wallTileCount, self.y - tileScale)
        -- create a wall normally on the bottom side
        MapArea.drawHorizontalWall(self, yOffset, tileScale, 0)
    elseif self.bend == 'RT' then
        helper(1, wallTileCount - 5, self.y - tileScale)
        MapArea.drawHorizontalWall(self, yOffset, tileScale, 0)
    elseif self.bend == 'LB' then
        helper(5, wallTileCount, self.y + yOffset)
        -- create a wall normally on the top side
        MapArea.drawHorizontalWall(self, -tileScale, tileScale, 0)
    else
        helper(1, wallTileCount - 5, self.y + yOffset)
        MapArea.drawHorizontalWall(self, -tileScale, tileScale, 0)
    end
end

-- draws a shorter wall on the side that has the bend
-- then draws a normal wall on the opposite side
function MapCorridor:drawBendWallTilesVertical(tileScale)
    local wallTileCount = self.height * (32 * 5) / tileScale
    local xOffset = self.width * (64 * 5)
    local helper = function (start, limit, x)
        for i = start, limit - 1 do
            love.graphics.draw(GTextures['wall-topper'], GQuads['wall-topper'][1], x, self.y + (i * tileScale), 0, 5, 5)
        end
    end
    if self.bend == 'LT' then
        helper(5, wallTileCount, self.x - tileScale)
        MapArea.drawVerticalWall(self, xOffset, tileScale)
    elseif self.bend == 'RT' then
        helper(5, wallTileCount, self.x + xOffset)
        MapArea.drawVerticalWall(self, -tileScale, tileScale)
    elseif self.bend == 'LB' then
        helper(1, wallTileCount - 5, self.x - tileScale)
        MapArea.drawVerticalWall(self, xOffset, tileScale)
    else
        helper(1, wallTileCount - 5, self.x + xOffset)
        MapArea.drawVerticalWall(self, -tileScale, tileScale)
    end
end

function MapCorridor:drawDoors()
    if self.direction == 'horizontal' then
        self:drawVerticalDoors()
    else
        self:drawHorizontalDoors()
    end
end

function MapCorridor:drawHorizontalDoors()
    local helper = function (doorID, x, y)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][doorID], x, y, 0, 5, 5)
    end
    local xOffset = self.x + (32 * 5)
    local yOffset = self.y + self.height * (32 * 5) - WALL_OFFSET
    if self.doorIDs.top then
        -- draw the left under doors
        helper(DOOR_IDS['under'], self.x, self.y)
        helper(DOOR_IDS['under'], xOffset, self.y)
        -- draw left coloured doors
        helper(DOOR_IDS[self.doorIDs.top], self.x, self.y)
        helper(DOOR_IDS[self.doorIDs.top], xOffset, self.y)
    end
    if self.doorIDs.bottom then
        -- draw the right under doors
        helper(DOOR_IDS['under'], self.x, yOffset)
        helper(DOOR_IDS['under'], xOffset, yOffset)
        -- draw right coloured doors
        helper(DOOR_IDS[self.doorIDs.bottom], self.x, yOffset)
        helper(DOOR_IDS[self.doorIDs.bottom], xOffset, yOffset)
    end
end

function MapCorridor:drawVerticalDoors()
    local helper = function (doorID, x, y)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][doorID], x, y, 0, 5, 5)
    end
    local xOffset = self.x + self.width * (64 * 5) - WALL_OFFSET
    local yOffset = self.y + (32 * 5)
    if self.doorIDs.left then
        -- draw the left under doors
        helper(DOOR_IDS['under'], self.x, self.y)
        helper(DOOR_IDS['under'], self.x, yOffset)
        -- draw left coloured doors
        helper(DOOR_IDS[self.doorIDs.left], self.x, self.y)
        helper(DOOR_IDS[self.doorIDs.left], self.x, yOffset)
    end
    if self.doorIDs.right then
        -- draw the right under doors
        helper(DOOR_IDS['under'], xOffset, self.y)
        helper(DOOR_IDS['under'], xOffset, yOffset)
        -- draw right coloured doors
        helper(DOOR_IDS[self.doorIDs.right], xOffset, self.y)
        helper(DOOR_IDS[self.doorIDs.right], xOffset, yOffset)
    end
end

function MapCorridor:generateWallTiles()
    -- check for bends
    if self.bend then
        for x = 1, (self.width * 4) - 5 do
            table.insert(self.bendWall, GQuads['wall-topper'][1])
        end
    end
    if self.direction == 'horizontal' then
        self.wallTiles['horizontal'] = {}
        for x = 1, (self.width * 4) do
            table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
        end
    else
        self.wallTiles['vertical'] = {}
        for x = 1, (self.height * 2) do
             table.insert(self.wallTiles['vertical'], GQuads['wall-topper'][1])
        end
    end
end
