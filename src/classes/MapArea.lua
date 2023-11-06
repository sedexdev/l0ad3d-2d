--[[
    MapArea: class

    Description:
        Creates and renders out an area of the game Map. A MapArea
        can either be an area or a corridor. An area in this project 
        is defined as a room the Player will have Entity interactions 
        in and collect powerups from. A corridor is an area the Player
        can travel through to get to other areas

]]

MapArea = Class{}

--[[
    MapArea constructor. The project defines 2 types of area depending on the
    values defined in src/utils/definitions.lua:GMapAreaDefinitions. An area
    can be an area (tile grid doors and other adjacent areas), or a corridor 
    (tile grid join between 2 areas with an orientation and bends)

    Params:
        id: number - area ID relating to the GMapAreaDefinitions area index
        x: number - x coordinate of this area
        y: number - y coordinate of this area
        width: number - width of this area in tiles
        height: number - height of this area in tiles
        type: string - area | corridor
        orientation: string - orientation of this area (corridors)
        bends: table - location of any bends in this area (corridors)
        joins: table -  area index and location to base corridor (x, y) off of (corridors)
        doors: table - doors in this area
        adjacentAreas: table - adjacent areas connected to this area
    Returns:
        nil
]]
function MapArea:init(id, x, y, width, height, type, orientation, bends, joins, doors, adjacentAreas)
    self.id = id
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.type = type
    self.orientation = orientation
    self.bends = bends
    self.joins = joins
    self.doors = doors
    self.adjacentAreas = adjacentAreas
    self.floorTiles = {}
    self.wallTiles = {}
    self.bendWall = {}
end

--[[
    MapArea render function. Renders out the floor and wall tiles for
    areas and corridors. Accounts for bends in corridors

    Params:
        none
    Returns:
        nil
]]
function MapArea:render()
    love.graphics.setColor(1, 1, 1, 1)
    self:drawFloorTiles()
    -- if this area has doors
    if self.type == 'area' then
        self:drawWallTiles()
    end
    if self.type == 'corridor' then
        -- draw the walls
        self:drawCorridorWalls()
    end
end

--[[
    Renders the floor tiles for this area using the <self.floorTiles>
    table that is populated by the MapArea:generateFloorTiles() function.
    Offsets for vertical and horizonatal rendering are defnied as follows:

        x = x + (x - n) * (64 * 5) => 64 * 5 is the floor tile width scaled x5 
        y = y + (y - n) * (32 * 5) => 32 * 5 is the floor tile height scaled x5 

    Params:
        none
    Returns:
        nil
]]
function MapArea:drawFloorTiles()
    for y, tiles in pairs(self.floorTiles) do
        for x, tile in pairs(tiles) do
            love.graphics.draw(GTextures['floor-tiles'],
            tile,
            self.x + ((x - 1) * FLOOR_TILE_WIDTH), self.y + ((y - 1) * FLOOR_TILE_HEIGHT),
            0,
            5, 5)
        end
    end
end

--[[
    Calls all helper functions for rendering out the wall tiles
    that line the boundary of this area. The horizontal and 
    vertical helper functions are called twice to get an equal
    length wall section for either side of the area, offset
    appropriately for the side being rendered

    Params:
        none
    Returns:
        nil
]]
function MapArea:drawWallTiles()
    self:drawHorizontalWall(WALL_OFFSET, -WALL_OFFSET)
    self:drawHorizontalWall(WALL_OFFSET, self.height * FLOOR_TILE_HEIGHT)
    self:drawVerticalWall(-WALL_OFFSET)
    self:drawVerticalWall(self.width * FLOOR_TILE_WIDTH)
end

--[[
    Calls all helper functions for rendering out the wall tiles
    that line the boundary of this corridor. The horizontal and 
    vertical helper functions are called twice to get an equal
    length wall section for either side of the area, offset
    appropriately for the side being rendered
]]
function MapArea:drawCorridorWalls()
    if self.orientation == 'horizontal' then
        -- draw any bends in this corridor 
        if self.bends then
            self:drawBendWallTilesHorizontal()
        else
            self:drawHorizontalWall(WALL_OFFSET, -WALL_OFFSET)
            self:drawHorizontalWall(WALL_OFFSET, self.height * FLOOR_TILE_HEIGHT)
        end
    else
        -- draw any bends in this corridor 
        if self.bends then
            self:drawBendWallTilesVertical()
        else
            self:drawVerticalWall(-WALL_OFFSET)
            self:drawVerticalWall(self.width * FLOOR_TILE_WIDTH)
        end
    end
end

--[[
    Renders out a horizontal length of wall on the area
    appropriate area bondary as defined by the parameters

    Params:
        xOffset: number - pixels to offset the x coordinate by 
                          (used for corners and corridors)
        yOffset: number - pixels to offset the y coordinate by
    Returns:
        nil
]]
function MapArea:drawHorizontalWall(xOffset, yOffset)
    for x, tile in pairs(self.wallTiles['horizontal']) do
        love.graphics.draw(GTextures['wall-topper'],
            tile,
            -- -xOffset to pull back wall into area corners. Set to 0 for corridors
            self.x + ((x - 1) * (WALL_OFFSET)) - xOffset, self.y + yOffset,
            0,
            5, 5
        )
    end
end

--[[
    Renders out a vertical length of wall on the area
    appropriate area boundary as defined by the parameters

    Params:
        xOffset: number - pixels to offset the x coordinate by
    Returns:
        nil
]]
function MapArea:drawVerticalWall(xOffset)
    for y, tile in pairs(self.wallTiles['vertical']) do
        love.graphics.draw(GTextures['wall-topper'],
            tile,
            self.x + xOffset, self.y + ((y - 1) * (WALL_OFFSET)),
            0,
            5, 5
        )
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
function MapArea:drawBendWallTilesHorizontal()
    local wallTileCount = self.width * FLOOR_TILE_WIDTH / WALL_OFFSET
    local yOffset = self.height * FLOOR_TILE_HEIGHT

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

    for i = 1, #self.bends do
        -- check which corner has the bend (LT = left-top, RB = right-bottom etc)
        if self.bends[i] == 'LT' then
            helper(5, wallTileCount, self.y - WALL_OFFSET)
            -- create a wall normally on the bottom side
            self:drawHorizontalWall(0, yOffset)
        elseif self.bends[i] == 'RT' then
            helper(1, wallTileCount - 5, self.y - WALL_OFFSET)
            -- create a wall normally on the bottom side
            self:drawHorizontalWall(0, yOffset)
        elseif self.bends[i] == 'LB' then
            helper(5, wallTileCount, self.y + yOffset)
            -- create a wall normally on the top side
            self:drawHorizontalWall(0, -WALL_OFFSET)
        else
            helper(1, wallTileCount - 5, self.y + yOffset)
            -- create a wall normally on the top side
            self:drawHorizontalWall(0, -WALL_OFFSET)
        end
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
function MapArea:drawBendWallTilesVertical()
    local wallTileCount = self.height * FLOOR_TILE_HEIGHT / WALL_OFFSET
    local xOffset = self.width * FLOOR_TILE_WIDTH

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

    for i = 1, #self.bends do
        -- check which corner has the bend (LT = left-top, RB = right-bottom etc)
        if self.bends[i] == 'LT' then
            helper(5, wallTileCount, self.x - WALL_OFFSET)
            -- create a wall normally on the right side
            self:drawVerticalWall(xOffset)
        elseif self.bends[i] == 'RT' then
            helper(5, wallTileCount, self.x + xOffset)
            -- create a wall normally on the right side
            self:drawVerticalWall(-WALL_OFFSET)
        elseif self.bends[i] == 'LB' then
            helper(1, wallTileCount - 5, self.x - WALL_OFFSET)
            -- create a wall normally on the left side
            self:drawVerticalWall(xOffset)
        else
            helper(1, wallTileCount - 5, self.x + xOffset)
            -- create a wall normally on the left side
            self:drawVerticalWall(-WALL_OFFSET)
        end
    end
end

--[[
    Updates the <self.floorTiles> table with floor tile quads.
    The number of tiles inserted is equal to the width * height
    of the area

    Params:
        none
    Returns:
        nil
]]
function MapArea:generateFloorTiles()
    for y = 1, self.height do
        table.insert(self.floorTiles, {})
        for _ = 1, self.width do
            table.insert(self.floorTiles[y], GQuads['floor-tiles'][math.random(6)])
        end
    end
end

--[[
    Updates the <self.wallTiles> table with wall tile quads. 2
    additional tables are inserted into <self.wallTiles> for
    horizontal and vertical walls. The number of tiles inserted 
    into the respective sub-tables is equal to the width or height
    of the area. Horizontal walls have +2 extra tiles to account
    for the corners of the area

    Params:
        none
    Returns:
        nil
]]
function MapArea:generateWallTiles()
    if self.bend then
        -- -5 to make the wall shorter on the bend side
        for x = 1, (self.width * 4) - 5 do
            table.insert(self.bendWall, GQuads['wall-topper'][1])
        end
    end
    self.wallTiles['horizontal'] = {}
    if self.type == 'corridor' then
        for x = 1, (self.width * 4) do
            table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
        end
    else
        -- +2 to add the corner squares for an area
        for x = 1, (self.width * 4) + 2 do
            table.insert(self.wallTiles['horizontal'], GQuads['wall-topper'][1])
        end
    end
    self.wallTiles['vertical'] = {}
    for x = 1, (self.height * 2) do
        table.insert(self.wallTiles['vertical'], GQuads['wall-topper'][1])
    end
end
