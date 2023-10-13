MapCorridor = Class{__includes = MapArea}

function MapCorridor:init(x, y, width, height, direction, bend, junction, doorIDs)
    MapArea.init(self, x, y, width, height)
    self.direction = direction
    self.bend = bend
    self.junction = junction
    self.doorIDs = doorIDs
    self.wallTiles = {}
    -- self.doors = {}
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
        -- call parent class functions for to draw the wall
        MapArea.drawHorizontalWall(self, -tileScale, tileScale, 0)
        MapArea.drawHorizontalWall(self, self.height * (32 * 5), tileScale, 0)
    else
        MapArea.drawVerticalWall(self, -tileScale, tileScale)
        MapArea.drawVerticalWall(self, self.width * (64 * 5), tileScale)
    end
end

function MapCorridor:drawDoors()
    if self.direction == 'horizontal' then
        self:drawVerticalDoors()
    else
        self:drawHorizontalDoors()
    end
end

function MapCorridor:drawVerticalDoors()
    if self.doorIDs.left then
        -- draw the left under doors
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS['under']], self.x, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS['under']], self.x, self.y + (32 * 5), 0, 5, 5)
        -- draw left coloured doors
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS[self.doorIDs.left]], self.x, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS[self.doorIDs.left]], self.x, self.y + (32 * 5), 0, 5, 5)
    end
    if self.doorIDs.right then
        -- draw the right under doors
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS['under']], self.x + self.width * (64 * 5) - WALL_OFFSET, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS['under']], self.x + self.width * (64 * 5) - WALL_OFFSET, self.y + (32 * 5), 0, 5, 5)
        -- draw right coloured doors
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS[self.doorIDs.right]], self.x + self.width * (64 * 5) - WALL_OFFSET, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][DOOR_IDS[self.doorIDs.right]], self.x + self.width * (64 * 5) - WALL_OFFSET, self.y + (32 * 5), 0, 5, 5)
    end
end

function MapCorridor:drawHorizontalDoors()
    if self.doorIDs.top then
        -- draw the left under doors
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS['under']], self.x, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS['under']], self.x + (32 * 5), self.y, 0, 5, 5)
        -- draw left coloured doors
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS[self.doorIDs.top]], self.x, self.y, 0, 5, 5)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS[self.doorIDs.top]], self.x + (32 * 5), self.y, 0, 5, 5)
    end
    if self.doorIDs.bottom then
        -- draw the right under doors
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS['under']], self.x, self.y + self.height * (32 * 5) - WALL_OFFSET, 0, 5, 5)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS['under']], self.x + (32 * 5), self.y + self.height * (32 * 5) - WALL_OFFSET, 0, 5, 5)
        -- draw right coloured doors
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS[self.doorIDs.bottom]], self.x, self.y + self.height * (32 * 5) - WALL_OFFSET, 0, 5, 5)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][DOOR_IDS[self.doorIDs.bottom]], self.x + (32 * 5), self.y + self.height * (32 * 5) - WALL_OFFSET, 0, 5, 5)
    end
end

function MapCorridor:generateWallTiles()
    if self.direction == 'horizontal' then
        self.wallTiles['horizontal'] = {}
        for x = 1, (self.width * 4) do
            table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
        end
        -- check for bends
    else
        self.wallTiles['vertical'] = {}
        for x = 1, (self.height * 2) do
             table.insert(self.wallTiles['vertical'], GQuads['wall-topper'][1])
        end
        -- -- check for bends
    end
end