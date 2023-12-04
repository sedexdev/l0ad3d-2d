--[[
    SelectCharacterState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays the 2 character avatars for the available playable
        characters: Cap'n'Guns and Plank. The player then selects
        the character they want to play as and the state changes
        to the CountdownState 
]]

SelectCharacterState = Class{__includes = BaseState}

--[[
    SelectCharacterState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'select' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function SelectCharacterState:enter(params)
    self.highScores = params.highScores
end

--[[
    SelectCharacterState constructor. Creates bullet
    offsets that mirror the shots fired in the MenuState

    Params:
        none
    Returns:
        nil
]]
function SelectCharacterState:init()
    self.selected = 1
    self.bulletOffsets = {
        [1] = {x = 3, y = -50},
        [2] = {x = 4, y = 45},
    }
end

--[[
    SelectCharacterState update function. Lets the player move
    between the 2 available characters and make a seclection
    on which one to play as

    Key bindings:
        escape: goes back to the MenuState
        right:  highlights the avatar to the right
        left:   highlights the avatar to the left
        enter:  selects the highlighted character
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function SelectCharacterState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('right') then
        -- play error if right avatar already selected
        if self.selected == 2 then
            Audio_MenuError()
        else
            Audio_MenuOption()
            self.selected = self.selected + 1
        end
    elseif love.keyboard.wasPressed('left') then
        -- play error if left avatar already selected
        if self.selected == 1 then
            Audio_MenuError()
        else
            Audio_MenuOption()
            self.selected = self.selected - 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Audio_PlayerShot()
        local map = Map()
        local player = Player(
            self.selected,
            GAnimationDefintions['character'..tostring(self.selected)],
            Copy(GCharacterDefinition)
        )
        local systemManager = SystemManager(map, player)
        -- Player stateMachine
        player.stateMachine = StateMachine {
            ['idle']    = function () return PlayerIdleState(player) end,
            ['walking'] = function ()
                local walkingState = PlayerWalkingState(player, map)
                walkingState:subscribe(systemManager)
                walkingState:subscribe(systemManager.doorSystem)
                walkingState:subscribe(systemManager.collisionSystem)
                walkingState:subscribe(systemManager.objectSystem)
                walkingState:subscribe(systemManager.enemySystem)
                walkingState:subscribe(systemManager.effectsSystem)
                return walkingState
            end
        }
        player.stateMachine:change('idle')
        GStateMachine:change('countdown', {
            highScores    = self.highScores,
            player        = player,
            map           = map,
            systemManager = systemManager,
            hud           = HUD(player),
            score         = 0,
            level         = 1
        })
    end
end

--[[
    SelectCharacterState render function. Draws out the background
    as well as the avatar images of each character. Multiple helper
    functions are defined below to render out the shadow, name, 
    highlighting, and avatar images

    Params:
        none
    Returns;
        nil
]]
function SelectCharacterState:render()
    -- draw background
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['grey-background'],
        0, 0,
        0,
        WINDOW_WIDTH / GTextures['grey-background']:getWidth(),
        WINDOW_WIDTH / GTextures['grey-background']:getHeight()
    )
    --render bullet holes in the centre
    for i = 1, #self.bulletOffsets do
        love.graphics.draw(GTextures['bullet-hole'],
            (WINDOW_WIDTH / 8) * self.bulletOffsets[i].x, (WINDOW_HEIGHT / 4) + self.bulletOffsets[i].y,
            0,
            0.25, 0.25
        )
    end
    -- render first character
    self:renderShadow(1, 25)
    self:renderAvatar(GTextures['character1-avatar'], 1)
    if self.selected == 1 then
        self:renderHighlight(1)
    end
    self:renderName('CAP\'N GUNS', (WINDOW_WIDTH / 4))
    -- render second character
    self:renderShadow(3, 25)
    self:renderAvatar(GTextures['character2-avatar'], 3)
    if self.selected == 2 then
        self:renderHighlight(3)
    end
    self:renderName('PLANK', (WINDOW_WIDTH / 4 * 3))
end

--[[
    Draws the shadow behind the avatar image based on offsets
    to the (x, y) of the image

    Params:
        xOffset: number - x coordinate offset to adjust the shadow by
        yOffset: number - y coordinate offset to adjust the shadow by
    Returns:
        nil
]]
function SelectCharacterState:renderShadow(xOffset, yOffset)
    love.graphics.setColor(20/255, 20/255, 20/255, 1)
    love.graphics.rectangle('fill',
        ((WINDOW_WIDTH / 4 * xOffset ) - (AVATAR_WIDTH / 2)) + yOffset,
        ((WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2)) + yOffset,
        AVATAR_WIDTH, AVATAR_HEIGHT
    )
end

--[[
    Draws the highlight over the selected avatar image based on
    the (x, y) of the image

    Params:
        xOffset: number - x coordinate offset to adjust the highlight
    Returns:
        nil
]]
function SelectCharacterState:renderHighlight(xOffset)
    -- render opaque rectangle on top
    love.graphics.setColor(1, 1, 1, 50/255)
    love.graphics.rectangle('fill',
        (WINDOW_WIDTH / 4 * xOffset) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2),
        AVATAR_WIDTH, AVATAR_HEIGHT
    )
end

--[[
    Draws the avatar image based on the image dimensions and
    an x offset

    Params:
        texture: Image  - avatar image defined in src/utils/dependencies.lua in GTextures
        xOffset: number - x coordinate offset to adjust the highlight
    Returns:
        nil
]]
function SelectCharacterState:renderAvatar(texture, xOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(texture,
        (WINDOW_WIDTH / 4 * xOffset) - (AVATAR_WIDTH / 2),
        (WINDOW_HEIGHT / 2) - (AVATAR_HEIGHT / 2)
    )
end

--[[
    Draws the avatar name over the avatar image based on the 
    window dimensions and an x offset

    Params:
        name:    string - the name of the character
        xOffset: number - x coordinate offset to adjust the highlight
    Returns:
        nil
]]
function SelectCharacterState:renderName(name, xOffset)
    local fontWidth = GFonts['funkrocker-medium']:getWidth(name)
    love.graphics.setFont(GFonts['funkrocker-medium'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.print(name,
        xOffset + 2, (WINDOW_HEIGHT / 3) + 2,
        0,
        1, 1,
        fontWidth / 2, 0,
        0, 0
    )
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.print(name,
        xOffset, (WINDOW_HEIGHT / 3),
        0,
        1, 1,
        fontWidth / 2, 0,
        0, 0
    )
end
