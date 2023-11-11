import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "alarm"

gfx = playdate.graphics

CONTEXT = {}

function gfx_draw_lines( x, y, width, height )
    gfx.clear(gfx.kColorWhite)
    
    CONTEXT.image_bg:draw(0, 0)

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
        gfx.setLineWidth(1)
        gfx.drawCircleAtPoint(CONTEXT.sprite_alarm.x, CONTEXT.sprite_alarm.y, CONTEXT.sprite_alarm.current_bubble_radius)
        gfx.popContext()
    end

    gfx.popContext()
end

function initialize()
    -- Initialize global constants and permanent entities like the player.

    default_arm_length = 100
    max_arm_length = 180
    min_arm_length = 20
    arm_extend_speed = 2

    touch_radius = 5

    left_arm_x, left_arm_y = 120, 120
    right_arm_x, right_arm_y = 280, 120

    left_arm_sign = -1
    right_arm_sign = 1

    -- Which arm is active, left (true) or right (false).
    is_left_arm_active = false

    local image_hand_left = gfx.image.new("images/hand_left")
    local image_hand_right = gfx.image.new("images/hand_right")

    image_bg = gfx.image.new("images/bg")

    -- Permanent sprites
    -- Left hand.
    sprite_hand_l = gfx.sprite.new()
    sprite_hand_l:setImage(image_hand_left)
    sprite_hand_l:setCenter(1.0, 0.5)
    sprite_hand_l:moveTo(left_arm_x-default_arm_length, left_arm_y)
    sprite_hand_l:add()
    print(sprite_hand_l:isOpaque())

    -- Right hand.
    sprite_hand_r = gfx.sprite.new()
    sprite_hand_r:setImage(image_hand_right)
    sprite_hand_r:setCenter(0.0, 0.5)
    sprite_hand_r:moveTo(right_arm_x+default_arm_length, right_arm_y)
    sprite_hand_r:add()

    -- Left arm. - TODO: Probably needs to be a sprite, otherwise drawing is out of sync.
    player_arm_l = playdate.geometry.lineSegment.new(0, 0, default_arm_length, 0)
    player_arm_l_angle = 180

    -- Right arm.
    player_arm_r = playdate.geometry.lineSegment.new(0, 0, default_arm_length, 0)
    player_arm_r_angle = 0

    active_arm = player_arm_r
    inactive_arm = player_arm_l

    active_hand = sprite_hand_l

    sprite_alarm = Alarm()
    sprite_alarm:reset()

    CONTEXT.sprite_alarm = sprite_alarm
    CONTEXT.player_arm_l_current = player_arm_l
    CONTEXT.player_arm_r_current = player_arm_r
    CONTEXT.active_hand = sprite_hand_r

    CONTEXT.image_bg = image_bg

    gfx.sprite.setBackgroundDrawingCallback(gfx_draw_lines)
end

initialize()

function playdate.update()
    -- Called before every frame is drawn.

    -- If crank is docked, pause the game.
    if playdate.isCrankDocked() then
        gfx.sprite.update()
        return
    end

    -- If A or B button is pressed, define active arm.
    if playdate.buttonIsPressed( playdate.kButtonA ) then
        is_left_arm_active = false
    end
    if playdate.buttonIsPressed( playdate.kButtonB ) then
        is_left_arm_active = true
    end

    -- Assign active and resting arms.
    if is_left_arm_active then
        active_arm = player_arm_l
        active_hand = sprite_hand_l
        inactive_arm = player_arm_r
    else
        active_arm = player_arm_r
        active_hand = sprite_hand_r
        inactive_arm = player_arm_l
    end
    CONTEXT.active_hand = active_hand

    -- Handle active arm length.
    -- If button is pressed, actively lengthen/shorten it.
    -- Else, automatically move back towards rest/default length (also for inactive arm).
    if playdate.buttonIsPressed( playdate.kButtonUp ) then
        active_arm.x2 += arm_extend_speed
    elseif playdate.buttonIsPressed( playdate.kButtonDown ) then
        active_arm.x2 -= arm_extend_speed
    elseif active_arm.x2 ~= default_arm_length then
        if active_arm.x2 > default_arm_length then
            active_arm.x2 -= arm_extend_speed
        else
            active_arm.x2 += arm_extend_speed
        end
    end
    if inactive_arm.x2 ~= default_arm_length then
        if inactive_arm.x2 > default_arm_length then
            inactive_arm.x2 -= arm_extend_speed
        else
            inactive_arm.x2 += arm_extend_speed
        end
    end

    -- Clamp arms length.
    if player_arm_l.x2 > max_arm_length then
        player_arm_l.x2 = max_arm_length
    elseif player_arm_l.x2 < min_arm_length then
        player_arm_l.x2 = min_arm_length
    end
    if player_arm_r.x2 < min_arm_length then
        player_arm_r.x2 = min_arm_length
    elseif player_arm_r.x2 > max_arm_length then
        player_arm_r.x2 = max_arm_length
    end

    -- Read angle from the crank.
    if is_left_arm_active then
        player_arm_l_angle -= playdate.getCrankChange()
    else
        player_arm_r_angle += playdate.getCrankChange()
    end

    -- Compute transforms for both arms
    player_arm_l_tx = playdate.geometry.affineTransform.new()
    player_arm_l_tx:rotate(player_arm_l_angle * left_arm_sign)
    player_arm_l_tx:translate(left_arm_x, left_arm_y)
    player_arm_l_current = player_arm_l_tx:transformedLineSegment(player_arm_l)
    CONTEXT.player_arm_l_current = player_arm_l_current

    player_arm_r_tx = playdate.geometry.affineTransform.new()
    player_arm_r_tx:rotate(player_arm_r_angle * right_arm_sign)
    player_arm_r_tx:translate(right_arm_x, right_arm_y)
    player_arm_r_current = player_arm_r_tx:transformedLineSegment(player_arm_r)
    CONTEXT.player_arm_r_current = player_arm_r_current

    sprite_hand_l:moveTo(player_arm_l_current.x2, player_arm_l_current.y2)
    sprite_hand_r:moveTo(player_arm_r_current.x2, player_arm_r_current.y2)

    sprite_hand_l:setRotation(player_arm_l_angle * left_arm_sign - 180)
    sprite_hand_r:setRotation(player_arm_r_angle * right_arm_sign)

    if not sprite_alarm:isVisible() then
        -- If no alarm clock, give a chance to trigger it.
        if math.random(0, 256) > 250 then
            sprite_alarm:start()
        end
    else
        -- Else update it (jitter it around, increase its radius, ...).
        sprite_alarm:update_logic(CONTEXT)
    end

    gfx.sprite.redrawBackground()
    gfx.sprite.update()

    playdate.timer.updateTimers()
end
