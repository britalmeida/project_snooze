gfx = playdate.graphics
gfxi = playdate.graphics.image

-- Image Passes
TEXTURES = {}

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
    -- Draw the sprite bubble circle.
    if ENEMIES.ALARM1:isVisible() then
        gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleAtPoint(ENEMIES.ALARM1.x, ENEMIES.ALARM1.y, ENEMIES.ALARM1.current_bubble_radius)
        gfx.popContext()
    end
end


function draw_game_background( x, y, width, height )
    gfx.clear(gfx.kColorWhite)

    CONTEXT.image_bg:draw(0, 0)

    if not CONTEXT.is_active then
        return
    end

    ENEMIES.ALARM1:drawDebug()
 
    gfx.pushContext()

        if CONTEXT.test_dither then
            draw_test_dither_patterns()
        end

        draw_dream_world()

        -- Draw the arms.
        gfx.pushContext()
        gfx.setLineCapStyle(gfx.kLineCapStyleRound)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(5)
        gfx.drawLine(CONTEXT.player_arm_l_current)
        gfx.drawLine(CONTEXT.player_arm_r_current)
        gfx.popContext()

        draw_light_areas()

    gfx.popContext()
end


function init_visuals()

    CONTEXT.test_dither = false

    -- Have 2 bg images so they can be swapped for test purposes.
    TEXTURES.bg_test1 = gfxi.new("images/bg")
    TEXTURES.bg_test2 = gfxi.new("images/test_screen")
    CONTEXT.image_bg = TEXTURES.bg_test1

    -- Make a (programmer) star.
    local size = 8
    local pattern = { 0x11, 0x08, 0x18, 0x5d, 0xba, 0x18, 0x10, 0x88 } 
    TEXTURES.star = gfx.image.new(size, size, gfx.kColorBlack)
    gfx.pushContext(TEXTURES.star)
        gfx.setPattern(pattern)
        gfx.fillRect(0, 0, size, size)
    gfx.popContext()
    TEXTURES.star:setMaskImage(TEXTURES.star)

    gfx.sprite.setBackgroundDrawingCallback(draw_game_background)

end

