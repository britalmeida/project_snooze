gfx = playdate.graphics

function gfx_draw_lines( x, y, width, height )
    gfx.clear(gfx.kColorWhite)

    CONTEXT.image_bg:draw(0, 0)

    if not CONTEXT.is_active then
        return
    end

    gfx.pushContext()

    -- Draw the arms.
    gfx.pushContext()
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)
    gfx.setColor(gfx.kColorWhite)
    gfx.setLineWidth(5)
    gfx.drawLine(CONTEXT.player_arm_l_current)
    gfx.drawLine(CONTEXT.player_arm_r_current)
    gfx.popContext()

    -- Draw the sprite bubble circle.
    if CONTEXT.sprite_alarm:isVisible() then
        gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(1)
        gfx.drawCircleAtPoint(CONTEXT.sprite_alarm.x, CONTEXT.sprite_alarm.y, CONTEXT.sprite_alarm.current_bubble_radius)
        gfx.popContext()
    end

    gfx.popContext()
end


function init_visuals()

    -- Have 2 images so they can be swapped for test purposes.
    CONTEXT.image_bg_test1 = gfx.image.new("images/bg")
    CONTEXT.image_bg_test2 = gfx.image.new("images/test_screen")
    CONTEXT.image_bg = CONTEXT.image_bg_test1

    gfx.sprite.setBackgroundDrawingCallback(gfx_draw_lines)

end

