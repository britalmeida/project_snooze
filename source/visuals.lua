gfx = playdate.graphics
gfxi = playdate.graphics.image

-- Image Passes
TEXTURES = {}

-- Set a pass on Z depth

function setDrawPass(z, drawCallback)
    local bgsprite = gfx.sprite.new()
    bgsprite:setSize(playdate.display.getSize())
    bgsprite:setCenter(0, 0)
    bgsprite:moveTo(0, 0)
    bgsprite:setZIndex(z)
    bgsprite:setIgnoresDrawOffset(true)
    bgsprite:setUpdatesEnabled(false)
    bgsprite.draw = function(s, x, y, w, h)
            drawCallback(x, y, w, h)
    end
    bgsprite:add()
    return bgsprite
end

-- Draw passes

function draw_light_areas()
    gfx.pushContext()
        gfx.setImageDrawMode(gfx.kDrawModeXOR)
        TEXTURES.light_areas:draw(0, 0)
    gfx.popContext()
end

function calculate_light_areas()
    TEXTURES.light_areas:clear(gfx.kColorClear)
    gfx.pushContext(TEXTURES.light_areas)

        -- Value from 0 to 1 triggered on game over for animating visuals.
        local gameover_anim_t = CONTEXT.gameover_anim_timer and CONTEXT.gameover_anim_timer.value or 0

        -- Draw light bubbles for the visible enemies.
        gfx.setColor(gfx.kColorWhite)
        for _, enemy in ipairs(ENEMIES) do
            if enemy:isVisible() then
                local radius = enemy.current_bubble_radius * (1 + gameover_anim_t * 27)
                gfx.pushContext()
                    if DITHERED_BUBBLES then
                        local dither_type = gfxi.kDitherTypeBayer8x8
                        local distance_to_head = math.sqrt((HEAD_X - enemy.x)^2 + (HEAD_Y - enemy.y)^2) - radius
                        -- Circle becomes denser as it approaches the head, but maxes out at 0.8 opacity.
                        local threat_level = math.max(0, distance_to_head / 100)
                        local dither_level = threat_level
                        gfx.setDitherPattern(dither_level, dither_type)
                    end
                    gfx.fillCircleAtPoint(enemy.x, enemy.y, radius)
                gfx.popContext()
            end
        end

        -- Draw sunray as a healthbar.
        local intensity = math.min(0.95, 1.0-CONTEXT.awakeness)
        local sun_growth = 70 * CONTEXT.awakeness + math.random(0,2)
        gfx.setDitherPattern(intensity, gfxi.kDitherTypeBayer8x8)
        --ray
        gfx.fillPolygon(199, 32, 203, 32,
                        380, 240, 370-sun_growth, 240)
        -- window
        gfx.fillPolygon(199, 26, 203, 26,
                        201, 0, 200, 0)

    gfx.popContext()
end


function draw_arm(arm_line_segment)
    -- Draw one arm.
    local arm_vec2 = arm_line_segment:segmentVector()
    local arm_normal = arm_vec2:leftNormal() * 6
    local line_top = arm_line_segment:offsetBy(arm_normal:unpack())
    local line_bottom = arm_line_segment:offsetBy((-arm_normal):unpack())

    gfx.pushContext()
        gfx.setColor(gfx.kColorBlack)
        gfx.fillPolygon(line_top.x1, line_top.y1, line_top.x2, line_top.y2,
                        line_bottom.x2, line_bottom.y2, line_bottom.x1, line_bottom.y1)

        gfx.setLineCapStyle(gfx.kLineCapStyleRound)
        gfx.setLineWidth(2)
        gfx.setColor(gfx.kColorWhite)
        --local pattern = { 0x11, 0x08, 0x18, 0x5d, 0xba, 0x18, 0x10, 0x88 }
        --gfx.setPattern(pattern)
        gfx.drawLine(line_top)
        gfx.drawLine(line_bottom)
    gfx.popContext()
end


function draw_arms()
    draw_arm(CONTEXT.player_arm_left.line_segment)
    draw_arm(CONTEXT.player_arm_right.line_segment)
end


function draw_character()
    TEXTURES.armpit:draw(173, 103)
    TEXTURES.armpit:draw(211, 105)
    TEXTURES.body:draw(0, 0)
end


function draw_game_background( x, y, width, height )

    -- Draw full screen background.
    gfx.pushContext()
        --gfx.setStencilImage(TEXTURES.light_areas)
        TEXTURES.bg:draw(0, 0)
    gfx.popContext()

end


function get_24h_formatted_score()
    -- Style score like a 24h clock.
    -- +300 to start at 5am instead of midnight.
    -- +0.5 and floor because lua doesn't have 'round'.
    -- max out at 1440 to not go above 24h.
    local capped_score = math.min(math.floor(300+CONTEXT.score + 0.5), 1440)
    local mins = string.format("%02d", capped_score % 60)
    local hours = string.format("%02d", math.floor(capped_score / 60))
    return hours .. ":" .. mins
end

function draw_hud()
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        gfx.pushContext()
            -- Top left corner: Score!
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRoundRect(7, 6, 78, 22, 3)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.setColor(gfx.kColorWhite)
            gfx.setFont(TEXTURES.font)
            gfx.drawText(get_24h_formatted_score(), 10, 10)
        gfx.popContext()
    elseif CONTEXT.menu_screen == MENU_SCREEN.gameover then
        gfx.pushContext()
            -- Big score in the screen center.
            gfx.setColor(gfx.kColorWhite)
            gfx.setFont(TEXTURES.uifont_medium)
            gfx.drawTextAligned("GAME OVER", 200, 60, kTextAlignment.center)
            gfx.setFont(TEXTURES.uifont_large)
            gfx.drawTextAligned(get_24h_formatted_score(), 200, 100, kTextAlignment.center)
        gfx.popContext()
    end
end


function draw_debug_overlay()
    if DRAW_DEBUG == 0 then
        return
    end
    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(10, 10, 50, 20)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawText(string.format("%.3f", CONTEXT.awakeness), 12, 12)
    gfx.popContext()
end

function init_visuals()

    -- Load fonts.
    TEXTURES.font = gfx.font.new("fonts/alarmity16x16")
    TEXTURES.uifont_medium = gfx.font.new("fonts/alarmity_outline38x38")
    TEXTURES.uifont_large = gfx.font.new("fonts/alarmity_outline72x72")

    -- Load image layers.
    TEXTURES.bg = gfxi.new("images/bg")
    TEXTURES.body = gfxi.new("images/body")
    TEXTURES.armpit = gfxi.new("images/shoulder_stump")

    -- Screen sized texture where the light bubbles and sun render to.
    TEXTURES.light_areas = gfxi.new(400, 240, gfx.kColorClear)

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(-40, draw_game_background)
    setDrawPass(-20, draw_character)
    --          -20, Head:draw()
    setDrawPass(-10, draw_arms)
    setDrawPass(  0, draw_light_areas) -- light bubbles are 0, so its easy to remember.
    setDrawPass(10, draw_hud)
end
