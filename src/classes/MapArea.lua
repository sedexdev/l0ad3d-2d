--[[
    MapArea: class

    Description:
        Creates and renders out an area of the game Map. An area
        in this project is defined as a room the Player will have
        Entity interactions in and collect powerups from.
]]

MapArea = Class{}

--[[
    MapArea constructor

    Params:
        id: number - area ID relating to the GMapAreaDefinitions area index
        x: number - x coordinate of this area
        y: number - y coordinate of this area
        width: number - width of this area in tiles
        height: number - height of this area in tiles
        corridors: table - corridors coming off this area
        adjacentArea: table - adjacent areas connected to this area
    Returns:
        nil
]]
function MapArea:init(id, x, y, width, height, corridors, adjacentArea)
    self.id = id
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.corridors = corridors
    self.adjacentArea = adjacentArea
    self.floorTiles = {}
    self.wallTiles = {}
    self.collidingWall = nil
end

--[[
    MapArea render function. Renders out the floor and wall tiles
    as well as any doors that connect this area to an adjacent area

    Params:
        none
    Returns:
        nil
]]
function MapArea:render()
    love.graphics.setColor(1, 1, 1, 1)
    self:drawFloorTiles()
    self:drawWallTiles()
    if self.adjacentArea then
        self:drawAdjacentDoor()
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
            self.x + ((x - 1) * (64 * 5)), self.y + ((y - 1) * (32 * 5)),
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
    self:drawHorizontalWall(WALL_OFFSET, self.height * (32 * 5))
    self:drawVerticalWall(-WALL_OFFSET)
    self:drawVerticalWall(self.width * (64 * 5))
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
    Renders doors for adjacent areas that are not connected by
    corridors. A door is comprised to 4 sections: left and right,
    or top and bottom, under door sprites, with overlaying
    coloured door sprites. This will have the effect of revealing
    the under door when the coloured door tweens open. Doors have
    an ID, a location, and an orientation
    
    Params:
        none
    Returns:
        nil
]]
function MapArea:drawAdjacentDoor()
    -- pixel dimensions
    local areaWidth = self.width * (64 * 5)
    local areaHeight = self.height * (32 * 5)
    -- offsets for right and bottom walls as width/height needed for calculation
    local rightXOffset = self.x + areaWidth
    local bottomYOffset = self.y + areaHeight
    -- offsets for doors, so they are rendered adjacently in the centre
    local verticalTopDoorOffset = (areaHeight / 2) - (32 * 5)
    local verticalBottomDoorOffset = areaHeight / 2
    local horizontalLeftDoorOffset = (areaWidth / 2) - (32 * 5)
    local horizontalRightDoorOffset = areaWidth / 2

    --[[
        Helper function for rendering the doors

        Params:
            doorID: door colour used to find sprite sheet index using the DOOR_IDS constant
            x: x coordinate to render the door at
            y: y coordinate to render the door at
            orientation: horizontal or vertical
        Returns:
            nil
    ]]
    local helper = function (doorID, x, y, orientation)
        love.graphics.draw(GTextures[orientation..'-doors'], GQuads[orientation..'-doors'][DOOR_IDS[doorID]], x, y, 0, 5, 5)
    end

    -- adjacentArea[1] = GMapAreaDefinitions index for the adjacent area
    -- adjacentArea[2] = location of the door (L, R, T, B)
    -- adjacentArea[3] = door ID colour
    if self.adjacentArea[2] == 'L' then
        -- draw the under doors first
        helper('under', self.x - WALL_OFFSET, self.y + verticalBottomDoorOffset, 'vertical')
        helper('under', self.x - WALL_OFFSET, self.y + verticalTopDoorOffset, 'vertical')
        -- draw door centre left
        helper(self.adjacentArea[3], self.x - WALL_OFFSET, self.y + verticalBottomDoorOffset, 'vertical')
        helper(self.adjacentArea[3], self.x - WALL_OFFSET, self.y + verticalTopDoorOffset, 'vertical')
    elseif self.adjacentArea[2] == 'R' then
        -- draw the under doors first
        helper('under', rightXOffset, self.y + verticalBottomDoorOffset, 'vertical')
        helper('under', rightXOffset, self.y + verticalTopDoorOffset, 'vertical')
        -- draw door centre right
        helper(self.adjacentArea[3], rightXOffset, self.y + verticalBottomDoorOffset, 'vertical')
        helper(self.adjacentArea[3], rightXOffset, self.y + verticalTopDoorOffset, 'vertical')
    elseif self.adjacentArea[2] == 'T' then
        -- draw the under doors first
        helper('under', self.x + horizontalLeftDoorOffset, self.y - WALL_OFFSET, 'horizontal')
        helper('under', self.x + horizontalRightDoorOffset, self.y - WALL_OFFSET, 'horizontal')
        -- draw door centre top
        helper(self.adjacentArea[3], self.x + horizontalLeftDoorOffset, self.y - WALL_OFFSET, 'horizontal')
        helper(self.adjacentArea[3], self.x + horizontalRightDoorOffset, self.y - WALL_OFFSET, 'horizontal')
    else
        -- draw the under doors first
        helper('under', self.x + horizontalLeftDoorOffset, bottomYOffset, 'horizontal')
        helper('under', self.x + horizontalRightDoorOffset, bottomYOffset, 'horizontal')
        -- draw door centre bottom
        helper(self.adjacentArea[3], self.x + horizontalLeftDoorOffset, bottomYOffset, 'horizontal')
        helper(self.adjacentArea[3], self.x + horizontalRightDoorOffset, bottomYOffset, 'horizontal')
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
