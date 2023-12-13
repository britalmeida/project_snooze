gfx = playdate.graphics
gfxi = playdate.graphics.image

-- Image Passes
TEXTURES = {}

-- Procedural Effects
local fx = {
    sunray = {
        top_y = 32,
        bot_y = 240,
        top_x1 = 199,
        top_x2 = 203,
        bot_x1 = 370,
        bot_x2 = 380,
        max_grow = 70
    }
}

BUBBLE_POPS = {}


-- Development

function draw_test_dither_patterns()

    local dither_types = {
        gfxi.kDitherTypeNone,
        gfxi.kDitherTypeDiagonalLine,
        gfxi.kDitherTypeVerticalLine,
        gfxi.kDitherTypeHorizontalLine,
        gfxi.kDitherTypeScreen,
        gfxi.kDitherTypeBayer2x2,
        gfxi.kDitherTypeBayer4x4,
        gfxi.kDitherTypeBayer8x8,
        gfxi.kDitherTypeFloydSteinberg,
        gfxi.kDitherTypeBurkes,
        gfxi.kDitherTypeAtkinson
    }
    local size = 20
    local x = 2
    local y = 2

    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)

        -- kDitherTypeBayer8x8 gradient
        local dither_type = gfxi.kDitherTypeBayer8x8
        local pattern_img = gfxi.new(size, size, gfx.kColorBlack)
        for i = 0, 10, 1 do
            pattern_img:clear(gfx.kColorBlack)
            gfx.pushContext(pattern_img)
                gfx.setDitherPattern(i/10, dither_type)
                gfx.fillRect(0, 0, size, size)
            gfx.popContext()
            pattern_img:draw(x, y)
            y += size+2
        end

        -- different types
        local alpha = 0.0
        for a = 0, 10, 1 do
            y = 2
            x += size
            for i = 0, 10, 1 do
                pattern_img:clear(gfx.kColorBlack)
                gfx.pushContext(pattern_img)
                    gfx.setDitherPattern(alpha, dither_types[i+1])
                    gfx.fillRect(0, 0, size, size)
                gfx.popContext()
                pattern_img:draw(x, y)
                y += size+2
            end
            alpha += 0.1
        end
     gfx.popContext()

end


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

function calculate_light_areas()
    -- Calculate the light regions onto an offscreen texture.

    TEXTURES.light_areas:clear(gfx.kColorClear)
    gfx.pushContext(TEXTURES.light_areas)

        -- Value from 0 to 1 triggered on game over for animating visuals.
        local gameover_anim_t = CONTEXT.gameover_anim_timer and CONTEXT.gameover_anim_timer.value or 0

        -- Draw light bubbles for the visible enemies.
        gfx.setColor(gfx.kColorWhite)
        for _, enemy in ipairs(ENEMIES) do
            if enemy:isVisible() then
                local radius = enemy.current_bubble_radius * (1 + gameover_anim_t * 15)
                gfx.fillCircleAtPoint(enemy.x, enemy.y, radius)
            end
        end

        -- Draw sunray as a healthbar.
        local intensity = math.min(0.95, 1.0-CONTEXT.awakeness)
        local sun_growth = fx.sunray.max_grow * CONTEXT.awakeness

        gfx.setDitherPattern(intensity, gfxi.kDitherTypeBayer8x8)
        --ray
        gfx.fillPolygon(fx.sunray.top_x1,            fx.sunray.top_y, -- top left
                        fx.sunray.top_x2,            fx.sunray.top_y, -- top right
                        fx.sunray.bot_x2,            fx.sunray.bot_y, -- bottom right
                        fx.sunray.bot_x1-sun_growth, fx.sunray.bot_y) -- bottom left
        -- window
        gfx.fillPolygon(fx.sunray.top_x1, 26, fx.sunray.top_x2, 26, 201, 0, 200, 0)

    gfx.popContext()
end


function draw_light_areas()
    -- Apply the light areas to inverse the color of the background and character already drawn.
    gfx.pushContext()
        gfx.setImageDrawMode(gfx.kDrawModeXOR)
        TEXTURES.light_areas:draw(0, 0)
    gfx.popContext()
end


function draw_light_borders()
    -- Draw dither borders around the light areas.
    gfx.pushContext()
        -- Draw dithering only around the light areas (i.e.: light bubbles should look like metaballs).
        TEXTURES.light_areas:setInverted(true)
        gfx.setStencilImage(TEXTURES.light_areas)
        gfx.setStrokeLocation(gfx.kStrokeOutside)

        -- Set dither pattern.
        gfx.setColor(gfx.kColorWhite)
        gfx.setDitherPattern(0.6, gfxi.kDitherTypeBayer8x8)

        -- Draw a circle around each enemy bubble.
        for _, enemy in ipairs(ENEMIES) do
            if enemy:isVisible() then
                -- Borders are thinner for small bubbles and get ticker up to a maximum.
                -- 'x+1' sets it so a 0 radius bubble has a 0 thick border,
                -- '*1.1' makes the thickness tend to ~5px for a 50px radius and ~6px for 150px radius.
                local radius = enemy.current_bubble_radius
                local line_width = math.log(radius+1)*1.1
                gfx.setLineWidth(line_width)
                gfx.drawCircleAtPoint(enemy.x, enemy.y, radius)
            end
        end

        -- Draw the sunray borders.
        local intensity = 1-math.log(CONTEXT.awakeness+1)
        gfx.setColor(gfx.kColorWhite)
        gfx.setDitherPattern(intensity, gfxi.kDitherTypeBayer8x8)
        local sun_growth = fx.sunray.max_grow * CONTEXT.awakeness
        local line_width = math.sqrt(sun_growth) * 0.7 + math.random(0,2)
        -- right side border.
        gfx.fillTriangle(fx.sunray.top_x2,            fx.sunray.top_y, -- top
                         fx.sunray.bot_x2,            fx.sunray.bot_y, -- bottom left
                         fx.sunray.bot_x2+line_width, fx.sunray.bot_y) -- bottom right
        -- left side border.
        gfx.fillTriangle(fx.sunray.top_x1,            fx.sunray.top_y, -- top
                         fx.sunray.bot_x1-sun_growth, fx.sunray.bot_y, -- bottom right
                         fx.sunray.bot_x1-sun_growth-line_width, fx.sunray.bot_y) -- bottom left

        -- Restore the light texture to normal.
        TEXTURES.light_areas:setInverted(false)
    gfx.popContext()
end


function draw_bubble_pops()
    gfx.pushContext()
        -- Set dither pattern.
        gfx.setColor(gfx.kColorWhite)
        gfx.setDitherPattern(0.6, gfxi.kDitherTypeBayer8x8)

        for _, bubble in ipairs(BUBBLE_POPS) do
            -- Border with becomes thinner until it disappears using easing curve from timer_w.
            -- Original thickness is constant according to radius, same as when normally drawing the bubble border.
            local original_line_width = math.log(bubble.radius+1)*1.3
            local line_width = original_line_width * (1 - bubble.timer_w.value)
            if line_width > 0.001 then
                gfx.setLineWidth(line_width)
                gfx.drawCircleAtPoint(bubble.x, bubble.y,
                                      -- Radius expands to +10px using easing curve from timer_r.
                                      bubble.radius + bubble.timer_r.value * 10)
            end
        end

    gfx.popContext()

    -- Remove completed bubble pops
    for i=#BUBBLE_POPS, 1, -1 do
        if BUBBLE_POPS[i].timer_w.timeLeft <= 0 then
            table.remove(BUBBLE_POPS, i)
        end
    end
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
    -- +360 to start at 5am instead of midnight.
    -- +0.5 and floor because lua doesn't have 'round'.
    -- max out at 1440 to not go above 24h.
    local capped_score = math.min(math.floor(360+CONTEXT.score + 0.5), 1440)
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
            if CONTEXT.score >= 1440 then
                gfx.drawTextAligned("WELL SLEPT", 200, 60, kTextAlignment.center)
            else
                gfx.drawTextAligned("GAME OVER", 200, 60, kTextAlignment.center)
            end
            gfx.setFont(TEXTURES.uifont_large)
            gfx.drawTextAligned(get_24h_formatted_score(), 200, 100, kTextAlignment.center)
        gfx.popContext()
    end
end


function draw_debug_character_hitzones()
    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        -- hitzone
        local HEAD_XX = 206
        local HEAD_YY = 78
        gfx.drawCircleAtPoint(HEAD_XX, HEAD_YY, 15)
        gfx.drawCircleAtPoint(206, 98, 8)
        gfx.drawCircleAtPoint(201, 116, 12)
        gfx.drawCircleAtPoint(197, 134, 10)
        -- AABB
        local character_AABB_x1 = 186
        local character_AABB_x2 = 220
        local character_AABB_y1 = 62
        local character_AABB_y2 = 143
        gfx.drawLine(character_AABB_x1, character_AABB_y1, character_AABB_x1, character_AABB_y2)
        gfx.drawLine(character_AABB_x2, character_AABB_y1, character_AABB_x2, character_AABB_y2)
        gfx.drawLine(character_AABB_x1, character_AABB_y1, character_AABB_x2, character_AABB_y1)
        gfx.drawLine(character_AABB_x1, character_AABB_y2, character_AABB_x2, character_AABB_y2)
    gfx.popContext()
end


function draw_debug_spawn_locations()
    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        -- arm length
        gfx.drawCircleAtPoint(200, 120, ARM_LENGTH_MAX-30)
        gfx.drawCircleAtPoint(200, 120, ARM_LENGTH_MAX)

        -- Cat targets
        gfx.drawCircleAtPoint(140, 152, 2)
        gfx.drawCircleAtPoint(245, 155, 2)

        -- Roughly on character
        gfx.drawCircleAtPoint(205,  77, 29 + 10)
        gfx.drawCircleAtPoint(201, 117, 32 + 10)
        gfx.drawCircleAtPoint(197, 137, 29 + 10)
        gfx.drawCircleAtPoint(192, 170, 28 + 10)

        -- phone
        local character_AABB_x1 = 185
        local character_AABB_x2 = 220
        local character_AABB_y1 = 60
        local character_AABB_y2 = 150
        local arms_x = {ARM_R_X, ARM_L_X}
        local arms_y = {ARM_R_Y, ARM_R_Y}
        local arm_idx = math.random(1, 2)
        local x, y
        local repeats = 0
        repeat
            -- Pick a random spot in polar coordinates, within short arm's reach.
            local angle = math.random(360)
            local radius = math.random(ARM_LENGTH_MIN+20, ARM_LENGTH_DEFAULT)
    
            -- Convert to cartesian.
            x = arms_x[arm_idx] + radius * math.cos(math.rad(angle))
            y = arms_y[arm_idx] + radius * math.sin(math.rad(angle))
    
            repeats += 1
        until (
            (x + 10 > character_AABB_x1 and
            x - 10 < character_AABB_x2 and
            y + 10 > character_AABB_y1 and
            y - 10 < character_AABB_y2) == false or
            (repeats > 10)
        )
        gfx.drawCircleAtPoint(x, y, 2)

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
    setDrawPass(  1, draw_light_borders)
    setDrawPass(  2, draw_bubble_pops)
    setDrawPass(10, draw_hud)
    --setDrawPass(20, draw_debug_character_hitzones)
    --setDrawPass(20, draw_debug_spawn_locations)
    --setDrawPass(20, draw_test_dither_patterns)
end
