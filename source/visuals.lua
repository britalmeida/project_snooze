gfx = playdate.graphics
gfxi = playdate.graphics.image

-- Image Passes
TEXTURES = {}


-- Development only

function draw_test_dither_patterns()

    local size = 20
    local x = 10
    local y = 10

    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)

        -- kDitherTypeBayer8x8 gradient
        local dither_type = gfxi.kDitherTypeBayer8x8
        local star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.0, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.1, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.2, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.3, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.4, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.5, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
            gfx.pushContext(star_img)
            gfx.setDitherPattern(0.6, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.7, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.8, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(0.9, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(1.0, dither_type)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        -- different types
        x = 40
        y = 10
        local alpha = 0.3
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeNone)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeDiagonalLine)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeVerticalLine)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeHorizontalLine)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeScreen)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeBayer2x2)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeBayer4x4)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeBayer8x8)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeFloydSteinberg)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img:draw(x, y)
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeBurkes)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

        y += size
        star_img = gfxi.new(size, size, gfx.kColorBlack)
        gfx.pushContext(star_img)
            gfx.setDitherPattern(alpha, gfxi.kDitherTypeAtkinson)
            gfx.fillRect(0, 0, size, size)
        gfx.popContext()
        star_img:draw(x, y)

    gfx.popContext()
end

function draw_debug_circle(x, y, radius)
    if DRAW_DEBUG == 0 then
        return
    end
    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(2)
        gfx.drawCircleAtPoint(x, y, radius)
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

function draw_dream_world()
    -- programmer art for stars
    local dither_type = gfxi.kDitherTypeBayer8x8
    local alpha = CONTEXT.awakeness * -1

    TEXTURES.star:drawFaded(50, 50, alpha, dither_type)
    TEXTURES.star:drawFaded(75, 55, alpha, dither_type)
    TEXTURES.star:drawFaded(45, 155, alpha, dither_type)
    TEXTURES.star:drawFaded(330, 165, alpha, dither_type)
    TEXTURES.star:drawFaded(355, 160, alpha, dither_type)

end


function draw_light_areas()
    gfx.pushContext()
        gfx.setImageDrawMode(gfx.kDrawModeXOR)
        TEXTURES.light_areas:draw(0, 0)
    gfx.popContext()
end

function calculate_light_areas()
    TEXTURES.light_areas:clear(gfx.kColorClear)
    gfx.pushContext(TEXTURES.light_areas)

        -- Draw light bubbles for the visible enemies.
        gfx.setColor(gfx.kColorWhite)
        for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
            if enemy:isVisible() then
                gfx.pushContext()
                    if DITHERED_BUBBLES then
                        local dither_type = gfxi.kDitherTypeBayer8x8
                        local distance_to_head = math.sqrt((HEAD_X - enemy.x)^2 + (HEAD_Y - enemy.y)^2) - enemy.current_bubble_radius
                        -- Circle becomes denser as it approaches the head, but maxes out at 0.8 opacity.
                        local threat_level = math.max(0, distance_to_head / 100)
                        local dither_level = threat_level
                        gfx.setDitherPattern(dither_level, dither_type)
                    end
                    gfx.fillCircleAtPoint(enemy.x, enemy.y, enemy.current_bubble_radius)
                gfx.popContext()
            end
        end

        -- Draw sunray.
        --gfx.setDitherPattern(0.05, gfxi.kDitherTypeBayer8x8)
        --gfx.fillPolygon(200, 32, 205, 32, 380, 240, 350, 240)

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

    if CONTEXT.awakeness >= 0.9 then
        TEXTURES.head_awake:draw(178, 48)
    else
        TEXTURES.head_asleep:draw(178, 48)
    end
end


function draw_game_background( x, y, width, height )

    -- Draw full screen background.
    gfx.pushContext()
        --gfx.setStencilImage(TEXTURES.light_areas)
        TEXTURES.bg:draw(0, 0)
    gfx.popContext()

end

function draw_hud()
    gfx.pushContext()
        -- Top left corner: Score!
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(10, 10, 50, 20)
        gfx.setColor(gfx.kColorBlack)
        local formattedNumber = string.format("%04d", math.floor(math.min(9999, CONTEXT.score)))
        formattedNumber = formattedNumber:sub(1, 2) .. ":" .. formattedNumber:sub(3)

        gfx.drawText(formattedNumber, 12, 12)

        -- Crappy health bar
        if false then
            gfx.setColor(gfx.kColorWhite)
            width = (1 - CONTEXT.awakeness) * 50
            gfx.fillRect(340, 10, width, 20)
        end
    gfx.popContext()
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

    CONTEXT.test_dither = false

    -- Load other image layers.
    TEXTURES.bg = gfxi.new("images/bg")
    TEXTURES.body = gfxi.new("images/body")
    TEXTURES.armpit = gfxi.new("images/shoulder_stump")
    TEXTURES.head_asleep = gfxi.new("images/animation_hero-asleep")
    TEXTURES.head_awake = gfxi.new("images/animation_hero-awake")

    -- Make a (programmer) star.
    local size = 8
    local pattern = { 0x11, 0x08, 0x18, 0x5d, 0xba, 0x18, 0x10, 0x88 }
    TEXTURES.star = gfxi.new(size, size, gfx.kColorBlack)
    gfx.pushContext(TEXTURES.star)
        gfx.setPattern(pattern)
        gfx.fillRect(0, 0, size, size)
    gfx.popContext()
    TEXTURES.star:setMaskImage(TEXTURES.star)

    -- Screen sized texture where the light bubbles and sun render to.
    TEXTURES.light_areas = gfxi.new(400, 240, gfx.kColorClear)

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(-40, draw_game_background)
    setDrawPass(-30, draw_dream_world)
    setDrawPass(-20, draw_character)
    setDrawPass(-10, draw_arms)
    setDrawPass(  0, draw_light_areas) -- light bubbles are 0, so its easy to remember.
    setDrawPass(10, draw_hud)
    setDrawPass(20, draw_debug_overlay)
end
