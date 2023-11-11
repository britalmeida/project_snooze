import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "alarm"

gfx = playdate.graphics

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
    local image_hand_right = gfx.image.new("images/hand_left")

    -- Permanent sprites
    -- Left hand.
    sprite_hand_l = gfx.sprite.new()
    sprite_hand_l:setImage(image_hand_left)
    sprite_hand_l:setCenter(1.0, 0.5)
    sprite_hand_l:moveTo(left_arm_x-default_arm_length, left_arm_y)
    sprite_hand_l:add()

    -- Right hand.
    sprite_hand_r = gfx.sprite.new()
    sprite_hand_r:setImage(image_hand_right)
    sprite_hand_r:setCenter(1.0, 0.5)
    sprite_hand_r:moveTo(right_arm_x+default_arm_length, right_arm_y)
    sprite_hand_r:add()

    -- Left arm. - TODO: Probably needs to be a sprite, otherwise drawing is out of sync.
    player_arm_l = playdate.geometry.lineSegment.new(0, 0, -default_arm_length, 0)
    player_arm_l_angle = 0

    -- Right arm.
    player_arm_r = playdate.geometry.lineSegment.new(0, 0, default_arm_length, 0)
    player_arm_r_angle = 0

    active_arm = player_arm_r
    inactive_arm = player_arm_l

    active_hand = sprite_hand_l

    -- Alarm clock - TODO: Needs ability to have more than one in existence at a time.
    sprite_alarm = Alarm()
end
initialize()

function playdate.update()
    -- Called before every frame is drawn.

    gfx.setLineWidth(2)
    -- TODO: sprite.update() should be at the end for less input lag, but it wipes non-sprite drawings.
    gfx.sprite.update()

    -- If crank is docked, pause the game.
    if playdate.isCrankDocked() then
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
        
    -- Handle active arm length.
    -- If button is pressed, actively lengthen/shorten it.
    -- Else, automatically move back towards rest/default length (also for inactive arm).
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        active_arm.x2 += arm_extend_speed
    elseif playdate.buttonIsPressed( playdate.kButtonLeft ) then
        active_arm.x2 += -arm_extend_speed
    elseif math.abs(active_arm.x2) ~= default_arm_length then
        if active_arm.x2 > 100 then
            active_arm.x2 -= arm_extend_speed
        elseif active_arm.x2 > 0 then
            active_arm.x2 += arm_extend_speed
        elseif active_arm.x2 < -default_arm_length then
            active_arm.x2 += arm_extend_speed
        elseif active_arm.x2 < 0 then
            active_arm.x2 -= arm_extend_speed
        end
    end
    if math.abs(inactive_arm.x2) ~= default_arm_length then
        if active_arm.x2 > default_arm_length then
            active_arm.x2 -= arm_extend_speed
        elseif active_arm.x2 > 0 then
            active_arm.x2 += arm_extend_speed
        elseif active_arm.x2 < -default_arm_length then
            active_arm.x2 += arm_extend_speed
        elseif active_arm.x2 < 0 then
            active_arm.x2 -= arm_extend_speed
        end
    end

    -- Clamp arms length.
    if player_arm_l.x2 > -min_arm_length then
        player_arm_l.x2 = -min_arm_length
    elseif player_arm_l.x2 < -max_arm_length then
        player_arm_l.x2 = -max_arm_length
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

    player_arm_r_tx = playdate.geometry.affineTransform.new()
    player_arm_r_tx:rotate(player_arm_r_angle * right_arm_sign)
    player_arm_r_tx:translate(right_arm_x, right_arm_y)
    player_arm_r_current = player_arm_r_tx:transformedLineSegment(player_arm_r)

    -- Draw the arms.
    gfx.pushContext()
    gfx.setLineCapStyle(playdate.graphics.kLineCapStyleRound)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(5)
    gfx.drawLine(player_arm_l_current)
    gfx.drawLine(player_arm_r_current)
    gfx.popContext()

    sprite_hand_l:moveTo(player_arm_l_current.x2, player_arm_l_current.y2)
    sprite_hand_r:moveTo(player_arm_r_current.x2, player_arm_r_current.y2)

    sprite_hand_l:setRotation(player_arm_l_angle * left_arm_sign)
    sprite_hand_r:setRotation(180+player_arm_r_angle * right_arm_sign)

    -- If no alarm clock, give a chance to trigger it.
    -- Else jitter it around.
    if not sprite_alarm:isVisible() then
        if math.random(0, 256) > 250 then
            sprite_alarm:setVisible(true)
            -- TODO IMPORTANT: Alarms can spawn in unreachable places!! Need to clamp between arm min/max radius!
            sprite_alarm:moveTo(math.random(50, 350), math.random(50, 190))
        end
    end

    sprite_alarm:update()

    if sprite_alarm:isTouched(active_hand) then
        sprite_alarm:setScale(1.5) -- NOTE: This will only matter once alarms aren't instantly turned off.
        sprite_alarm:reset()
    end

    gfx.setLineWidth(1)
    gfx.drawCircleAtPoint(sprite_alarm.x, sprite_alarm.y, sprite_alarm.current_bubble_radius)

    playdate.timer.updateTimers()
end