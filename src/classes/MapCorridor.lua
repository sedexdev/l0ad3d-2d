--[[
    MapCorridor: class

    Includes: MapArea - parent class for MapCorridor objects as corridors 
                        are still areas of the Map

    Description:
        Creates and renders out a corridor for joining MapAreas of 
        the game Map. A corridor in this project is defined as a an
        area the Player can pass through to get to other MapAreas 
]]

MapCorridor = Class{__includes = MapArea}

--[[
    MapCorridor constructor

    Params:
        id: number - area ID relating to the GMapCorridorDefinitions corridor index
        x: number - x coordinate of this corridor
        y: number - y coordinate of this corridor
        width: number - width of this corridor in tiles
        height: number - height of this corridor in tiles
        bend: string - describes the location of a bend in this corridor
        junction: table - tile reference and location of a junction in this corridor
        doorIDs: table - door information for rendering the doors
    Returns:
        nil
]]
function MapCorridor:init(id, x, y, width, height, direction, bend, junction, doorIDs)
    MapArea.init(self, id, x, y, width, height)
    self.direction = direction
    self.bend = bend
    self.bendWall = {}
    self.junction = junction
    self.doorIDs = doorIDs
    self.wallTiles = {}
end

--[[
    MapCorridor render function. Renders out the floor and wall tiles
    as well as the doors at the ends of the corridor. Floor tiles are
    rendered using the MapArea:drawFloorTiles function

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:render()
    love.graphics.setColor(1, 1, 1, 1)
    MapArea.drawFloorTiles(self)
    self:drawWallTiles()
    self:drawDoors()
end

--[[
    Calls all helper functions for rendering out the wall tiles
    that line the boundary of this corridor. The horizontal and 
    vertical MapArea parent functions are called twice to get an 
    equal length wall section for either side of the corridor, 
    offset appropriately for the side being rendered. Before drawing
    2 equal pairs of horizontal and vertical walls, a check is done
    to see if this corridor has a bend in it

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawWallTiles()
    if self.direction == 'horizontal' then
        if self.bend then
            self:drawBendWallTilesHorizontal()
        else
            -- call parent class functions to draw the wall
            MapArea.drawHorizontalWall(self, 0, -WALL_OFFSET)
            MapArea.drawHorizontalWall(self, 0, self.height * (32 * 5))
        end
    else
        if self.bend then
            self:drawBendWallTilesVertical()
        else
            MapArea.drawVerticalWall(self, -WALL_OFFSET)
            MapArea.drawVerticalWall(self, self.width * (64 * 5))
        end
    end
end

--[[
    For horizontal corridors this function draws a shorter wall 
    on the side that has the bend then draws a normal wall on 
    the opposite side

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawBendWallTilesHorizontal()
    local wallTileCount = self.width * (64 * 5) / WALL_OFFSET
    local yOffset = self.height * (32 * 5)

    --[[
        Helper function for rendering out the wall tile segments
        of a shorter section of wall (defined as 5 less tiles than
        a normal wall)

        Params:
            start: number - defines the starting value of the for loop
                            to ensure wall tiles are offset by the correct
                            amount for the location of the bend
            limit: number - defines the final value of the for loop
                            to ensure wall tiles are offset by the correct
                            amount for the location of the bend
            y: number - offset value for the y coordinate
        Returns:
            nil
    ]]
    local helper = function (start, limit, y)
        for i = start, limit - 1 do
            love.graphics.draw(GTextures['wall-topper'], GQuads['wall-topper'][1], self.x + (i * WALL_OFFSET), y, 0, 5, 5)
        end
    end

    -- check which corner has the bend (LT = left-top, RB = right-bottom etc)
    if self.bend == 'LT' then
        helper(5, wallTileCount, self.y - WALL_OFFSET)
        -- create a wall normally on the bottom side
        MapArea.drawHorizontalWall(self, 0, yOffset)
    elseif self.bend == 'RT' then
        helper(1, wallTileCount - 5, self.y - WALL_OFFSET)
        -- create a wall normally on the bottom side
        MapArea.drawHorizontalWall(self, 0, yOffset)
    elseif self.bend == 'LB' then
        helper(5, wallTileCount, self.y + yOffset)
        -- create a wall normally on the top side
        MapArea.drawHorizontalWall(self, 0, -WALL_OFFSET)
    else
        helper(1, wallTileCount - 5, self.y + yOffset)
        -- create a wall normally on the top side
        MapArea.drawHorizontalWall(self, 0, -WALL_OFFSET)
    end
end

--[[
    For verical corridors this function draws a shorter wall 
    on the side that has the bend then draws a normal wall on 
    the opposite side

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawBendWallTilesVertical()
    local wallTileCount = self.height * (32 * 5) / WALL_OFFSET
    local xOffset = self.width * (64 * 5)

    --[[
        Helper function for rendering out the wall tile segments
        of a shorter section of wall (defined as 5 less tiles than
        a normal wall)

        Params:
            start: number - defines the starting value of the for loop
                            to ensure wall tiles are offset by the correct
                            amount for the location of the bend
            limit: number - defines the final value of the for loop
                            to ensure wall tiles are offset by the correct
                            amount for the location of the bend
            x: number - offset value for the x coordinate 
        Returns:
            nil
    ]]
    local helper = function (start, limit, x)
        for i = start, limit - 1 do
            love.graphics.draw(GTextures['wall-topper'], GQuads['wall-topper'][1], x, self.y + (i * WALL_OFFSET), 0, 5, 5)
        end
    end

    -- check which corner has the bend (LT = left-top, RB = right-bottom etc)
    if self.bend == 'LT' then
        helper(5, wallTileCount, self.x - WALL_OFFSET)
        -- create a wall normally on the right side
        MapArea.drawVerticalWall(self, xOffset)
    elseif self.bend == 'RT' then
        helper(5, wallTileCount, self.x + xOffset)
        -- create a wall normally on the right side
        MapArea.drawVerticalWall(self, -WALL_OFFSET)
    elseif self.bend == 'LB' then
        helper(1, wallTileCount - 5, self.x - WALL_OFFSET)
        -- create a wall normally on the left side
        MapArea.drawVerticalWall(self, xOffset)
    else
        helper(1, wallTileCount - 5, self.x + xOffset)
        -- create a wall normally on the left side
        MapArea.drawVerticalWall(self, -WALL_OFFSET)
    end
end

--[[
    Calls the required helper functions for rendering out the
    doors at the end of this corridor. If a corridor only has 
    doors at one end because there is a bend at the other then
    this is accounted for in the helper functions

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawDoors()
    if self.direction == 'horizontal' then
        -- if corridors are horizontal, the doors must be vertical
        self:drawVerticalDoors()
    else
        -- and vice-versa
        self:drawHorizontalDoors()
    end
end

--[[
    For vertical corridors this function draws doors horizontally
    at the ends that have doors defined according to the
    GMapCorridorDefinitions.doorIDs table

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawHorizontalDoors()
    --[[
        Helper function for rendering out the horizonatal door sections according
        to the door ID and the required (x, y) offset

        Params:
            doorID: string - colour used to lookup door IDs in the DOOR_IDS constant
            x: number - offset value for the x coordinate 
            y: number - offset value for the y coordinate 
        Returns:
            nil
    ]]
    local helper = function (doorID, x, y)
        love.graphics.draw(GTextures['horizontal-doors'], GQuads['horizontal-doors'][doorID], x, y, 0, 5, 5)
    end

    -- (x, y) offset values for drawing the doors
    local xOffset = self.x + (32 * 5)
    local yOffset = self.y + self.height * (32 * 5) - WALL_OFFSET

    -- check to see where the doors are defined
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

--[[
    For horizontal corridors this function draws doors vertically
    at the ends that have doors defined according to the
    GMapCorridorDefinitions.doorIDs table

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:drawVerticalDoors()
    --[[
        Helper function for rendering out the vertical door sections according
        to the door ID and the required (x, y) offset

        Params:
            doorID: string - colour used to lookup door IDs in the DOOR_IDS constant
            x: number - offset value for the x coordinate 
            y: number - offset value for the y coordinate 
        Returns:
            nil
    ]]
    local helper = function (doorID, x, y)
        love.graphics.draw(GTextures['vertical-doors'], GQuads['vertical-doors'][doorID], x, y, 0, 5, 5)
    end

    -- (x, y) offset values for drawing the doors
    local xOffset = self.x + self.width * (64 * 5) - WALL_OFFSET
    local yOffset = self.y + (32 * 5)

    -- check to see where the doors are defined
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

--[[
    Updates the <self.wallTiles> table with different length
    and orientation walls depending on the definition of this
    corridor as defined in GMapCorridorDefinitions

    Params:
        none
    Returns:
        nil
]]
function MapCorridor:generateWallTiles()
    -- check for bends
    if self.bend then
        -- -5 to make the wall shorter on the bend side
        for x = 1, (self.width * 4) - 5 do
            table.insert(self.bendWall, GQuads['wall-topper'][1])
        end
    end
    if self.direction == 'horizontal' then
        self.wallTiles['horizontal'] = {}
        -- *4 because wall tiles are 16px and floor are 64px wide
        for x = 1, (self.width * 4) do
            table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
        end
    else
        self.wallTiles['vertical'] = {}
        -- *2 because wall tiles are 16px and floor are 32px tall
        for x = 1, (self.height * 2) do
             table.insert(self.wallTiles['vertical'], GQuads['wall-topper'][1])
        end
    end
end
