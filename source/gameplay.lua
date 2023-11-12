import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "enemies/enemies"

gfx = playdate.graphics

-- Global static defines
ARM_LENGTH_DEFAULT = 80
ARM_LENGTH_MAX = 180
ARM_LENGTH_MIN = 20
ARM_EXTEND_SPEED = 20

HAND_TOUCH_RADIUS = 5

ARM_L_X, ARM_L_Y = 180, 110
ARM_R_X, ARM_R_Y = 225, 115

ARM_L_SIGN = -1
ARM_R_SIGN = 1

HEAD_X, HEAD_Y = 213, 82
HEAD_RADIUS = 10

DRAW_DEBUG = 1

function init_gameplay()

    local image_hand_right = gfx.image.new("images/hand")
    local image_hand_left = image_hand_right:scaledImage(-1,1)

    -- Permanent sprites
    -- Left hand.
    local sprite_hand_l = gfx.sprite.new()
    sprite_hand_l:setImage(image_hand_left)
    sprite_hand_l:setCenter(1.0, 0.5)
    sprite_hand_l:moveTo(ARM_L_X-ARM_LENGTH_DEFAULT, ARM_L_Y)
    sprite_hand_l:add()

    -- Right hand.
    local sprite_hand_r = gfx.sprite.new()
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

    -- Which arm is active, left (true) or right (false).
    CONTEXT.is_left_arm_active = false
    CONTEXT.player_arm_l_current = player_arm_l
    CONTEXT.player_arm_r_current = player_arm_r
    CONTEXT.player_hand_l = sprite_hand_l
    CONTEXT.player_hand_r = sprite_hand_r

end


function reset_gameplay()
    CONTEXT.awakeness = 0
    CONTEXT.enemies_snoozed = 0

end


function handle_input()

    -- If A or B button is pressed, define active arm.
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        is_left_arm_active = false
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        is_left_arm_active = true
    end
    CONTEXT.is_left_arm_active = is_left_arm_active

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

    CONTEXT.player_hand_l:moveTo(player_arm_l_current.x2, player_arm_l_current.y2)
    CONTEXT.player_hand_r:moveTo(player_arm_r_current.x2, player_arm_r_current.y2)

    CONTEXT.player_hand_l:setRotation(player_arm_l_angle * ARM_L_SIGN - 180)
    CONTEXT.player_hand_r:setRotation(player_arm_r_angle * ARM_R_SIGN)
end


function manage_enemies()
    if playdate.getElapsedTime() < 10 then
        ENEMIES_MANAGER.proto = PROGRESSION.LVL1
    end
    -- print(TIMER.currentTime)
    if
        TIMER.currentTime >= 1000 and
        TIMER.currentTime <= 2000 and
        #ENEMIES_MANAGER.enemies < 4
        then
        -- If no alarm clock, give a chance to trigger it.
        -- ENEMIES_MANAGER:spawnEnemy(ENEMIES_MANAGER.prototypes.mosquito)
        ENEMIES_MANAGER:spawnRandomEnemy()
    end
    -- Update enemies (jitter around, increase radius, ...).
    -- ENEMIES.ALARM1:update_logic(CONTEXT)
    for key, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        if enemy:isVisible() == true then
            enemy:update_logic(CONTEXT)
        end
    end

    CONTEXT.awakeness = math.min(#ENEMIES_MANAGER.enemies / 5, 1)
    if CONTEXT.awakeness >= 1 then
        print("Time is Up!")
        reset_gameplay()
    end
end
