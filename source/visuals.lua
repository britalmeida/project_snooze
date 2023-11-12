gfx = playdate.graphics

function draw_game_background( x, y, width, height )
    gfx.clear(gfx.kColorWhite)

    CONTEXT.image_bg:draw(0, 0)

    if not CONTEXT.is_active then
        return
    end

    gfx.pushContext()

    -- programmer art for stars
    local size = 20
    local star_img1 = gfx.image.new(size, size, gfx.kColorBlack)
    gfx.pushContext(star_img1)
        gfx.setColor(gfx.kColorWhite)
        gfx.setDitherPattern(CONTEXT.awakeness, gfx.image.kDitherTypeDiagonalLine)
        gfx.fillRect(0, 0, size, size)
    gfx.popContext()
    star_img1:draw(50, 50)
    star_img1:draw(75, 55)

    -- Draw the arms.
    gfx.pushContext()
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)
    gfx.setColor(gfx.kColorWhite)
    gfx.setLineWidth(5)
    gfx.drawLine(CONTEXT.player_arm_l_current)
    gfx.drawLine(CONTEXT.player_arm_r_current)
    gfx.popContext()

    -- Draw the sprite bubble circle.
    if ENEMIES.ALARM1:isVisible() then
        gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(1)
        gfx.drawCircleAtPoint(ENEMIES.ALARM1.x, ENEMIES.ALARM1.y, ENEMIES.ALARM1.current_bubble_radius)
        gfx.popContext()
    end

    gfx.popContext()
end


function init_visuals()

    -- Have 2 images so they can be swapped for test purposes.
    CONTEXT.image_bg_test1 = gfx.image.new("images/bg")
    CONTEXT.image_bg_test2 = gfx.image.new("images/test_screen")
    CONTEXT.image_bg = CONTEXT.image_bg_test1

    gfx.sprite.setBackgroundDrawingCallback(draw_game_background)

end

