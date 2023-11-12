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
        gfx.setColor(gfx.kColorWhite)

        for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
            -- Draw the sprite bubble circle.
            if enemy:isVisible() then
                gfx.fillCircleAtPoint(enemy.x, enemy.y, enemy.current_bubble_radius)
            end
        end

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

function draw_game_background( x, y, width, height )
    if CONTEXT.test_screen then
        TEXTURES.bg_test2:draw(0, 0)
        return
    end

    -- Draw full screen background.
    gfx.pushContext()
        --gfx.setStencilImage(TEXTURES.light_areas)
        TEXTURES.bg_test1:draw(0, 0)
    gfx.popContext()


    if CONTEXT.test_dither then
        draw_test_dither_patterns()
    end

    draw_dream_world()


    TEXTURES.armpit:draw(173, 103)
    TEXTURES.armpit:draw(211, 105)

    TEXTURES.body:draw(0, 0)

    draw_arm(CONTEXT.player_arm_l_current)
    draw_arm(CONTEXT.player_arm_r_current)



    draw_light_areas()

    -- draw_debug_circle(ENEMIES.ALARM1.x, ENEMIES.ALARM1.y, ENEMIES.ALARM1.collision_radius)
    --draw_debug_circle(HEAD_X, HEAD_Y, HEAD_RADIUS)
end


function init_visuals()

    CONTEXT.test_dither = false

    -- Have 2 bg images so they can be swapped for test purposes.
    TEXTURES.bg_test1 = gfxi.new("images/bg")
    TEXTURES.bg_test2 = gfxi.new("images/test_screen")
    -- Load other layers.
    TEXTURES.body = gfxi.new("images/body")
    TEXTURES.armpit = gfxi.new("images/shoulder_stump")

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

    gfx.sprite.setBackgroundDrawingCallback(draw_game_background)

end

