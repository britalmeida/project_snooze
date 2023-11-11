import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "alarm"
import "sound"

gfx = playdate.graphics

-- Global static defines
ARM_LENGTH_DEFAULT = 80
ARM_LENGTH_MAX = 180
ARM_LENGTH_MIN = 20
ARM_EXTEND_SPEED = 10

HAND_TOUCH_RADIUS = 5

ARM_L_X, ARM_L_Y = 180, 110
ARM_R_X, ARM_R_Y = 220, 110

ARM_L_SIGN = -1
ARM_R_SIGN = 1

-- Global logic context, storing the game data.
CONTEXT = {}

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

function initialize()

    -- Add custom entries to system menu

    local menu = playdate.getSystemMenu()

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test screen", false, function(value)
        if value then
            CONTEXT.image_bg = CONTEXT.image_bg_test2
        else
            CONTEXT.image_bg = CONTEXT.image_bg_test1
        end
    end)

    -- Initialize global constants and permanent entities like the player.

    -- Which arm is active, left (true) or right (false).
    is_left_arm_active = false

    local image_hand_left = gfx.image.new("images/hand_left")
    local image_hand_right = gfx.image.new("images/hand_right")

    -- Permanent sprites
    -- Left hand.
    sprite_hand_l = gfx.sprite.new()
    sprite_hand_l:setImage(image_hand_left)
    sprite_hand_l:setCenter(1.0, 0.5)
    sprite_hand_l:moveTo(ARM_L_X-ARM_LENGTH_DEFAULT, ARM_L_Y)
    sprite_hand_l:add()
    print(sprite_hand_l:isOpaque())

    -- Right hand.
    sprite_hand_r = gfx.sprite.new()
    sprite_hand_r:setImage(image_hand_right)
    sprite_hand_r:setCenter(0.0, 0.5)
    sprite_hand_r:moveTo(ARM_R_X+ARM_LENGTH_DEFAULT, ARM_R_Y)
    sprite_hand_r:add()

    -- Left arm. - TODO: Probably needs to be a sprite, otherwise drawing is out of sync.
    player_arm_l = playdate.geometry.lineSegment.new(0, 0, ARM_LENGTH_DEFAULT, 0)
    player_arm_l_angle = 180

    -- Right arm.
    player_arm_r = playdate.geometry.lineSegment.new(0, 0, ARM_LENGTH_DEFAULT, 0)
    player_arm_r_angle = 0

    active_arm = player_arm_r
    inactive_arm = player_arm_l

    active_hand = sprite_hand_l

    sprite_alarm = Alarm()
    sprite_alarm:reset()

    CONTEXT.is_active = false
    CONTEXT.sprite_alarm = sprite_alarm
    CONTEXT.player_arm_l_current = player_arm_l
    CONTEXT.player_arm_r_current = player_arm_r
    CONTEXT.active_hand = sprite_hand_r

    -- Have 2 images so they can be swapped for test purposes.
    CONTEXT.image_bg_test1 = gfx.image.new("images/bg")
    CONTEXT.image_bg_test2 = gfx.image.new("images/test_screen")
    CONTEXT.image_bg = CONTEXT.image_bg_test1

    gfx.sprite.setBackgroundDrawingCallback(gfx_draw_lines)
end

initialize()

function playdate.update()
    -- Called before every frame is drawn.

    -- If crank is docked, pause the game.
    if playdate.isCrankDocked() then
        CONTEXT.is_active = false
        gfx.sprite.update()
        return
    end

    CONTEXT.is_active = true

    -- If A or B button is pressed, define active arm.
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        is_left_arm_active = false
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
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
        active_arm.x2 += ARM_EXTEND_SPEED
    elseif playdate.buttonIsPressed( playdate.kButtonDown ) then
        active_arm.x2 -= ARM_EXTEND_SPEED
    elseif active_arm.x2 ~= ARM_LENGTH_DEFAULT then
        if active_arm.x2 > ARM_LENGTH_DEFAULT then
            active_arm.x2 -= ARM_EXTEND_SPEED
        else
            active_arm.x2 += ARM_EXTEND_SPEED
        end
    end
    if inactive_arm.x2 ~= ARM_LENGTH_DEFAULT then
        if inactive_arm.x2 > ARM_LENGTH_DEFAULT then
            inactive_arm.x2 -= ARM_EXTEND_SPEED
        else
            inactive_arm.x2 += ARM_EXTEND_SPEED
        end
    end

    -- Clamp arms length.
    if player_arm_l.x2 > ARM_LENGTH_MAX then
        player_arm_l.x2 = ARM_LENGTH_MAX
    elseif player_arm_l.x2 < ARM_LENGTH_MIN then
        player_arm_l.x2 = ARM_LENGTH_MIN
    end
    if player_arm_r.x2 < ARM_LENGTH_MIN then
        player_arm_r.x2 = ARM_LENGTH_MIN
    elseif player_arm_r.x2 > ARM_LENGTH_MAX then
        player_arm_r.x2 = ARM_LENGTH_MAX
    end

    -- Read angle from the crank.
    if is_left_arm_active then
        player_arm_l_angle -= playdate.getCrankChange()
    else
        player_arm_r_angle += playdate.getCrankChange()
    end

    -- Compute transforms for both arms
    player_arm_l_tx = playdate.geometry.affineTransform.new()
    player_arm_l_tx:rotate(player_arm_l_angle * ARM_L_SIGN)
    player_arm_l_tx:translate(ARM_L_X, ARM_L_Y)
    player_arm_l_current = player_arm_l_tx:transformedLineSegment(player_arm_l)
    CONTEXT.player_arm_l_current = player_arm_l_current

    player_arm_r_tx = playdate.geometry.affineTransform.new()
    player_arm_r_tx:rotate(player_arm_r_angle * ARM_R_SIGN)
    player_arm_r_tx:translate(ARM_R_X, ARM_R_Y)
    player_arm_r_current = player_arm_r_tx:transformedLineSegment(player_arm_r)
    CONTEXT.player_arm_r_current = player_arm_r_current

    sprite_hand_l:moveTo(player_arm_l_current.x2, player_arm_l_current.y2)
    sprite_hand_r:moveTo(player_arm_r_current.x2, player_arm_r_current.y2)

    sprite_hand_l:setRotation(player_arm_l_angle * ARM_L_SIGN - 180)
    sprite_hand_r:setRotation(player_arm_r_angle * ARM_R_SIGN)

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
