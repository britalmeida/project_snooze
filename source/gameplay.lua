import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "progression"
import "enemies/enemies"
import "arm"

gfx = playdate.graphics

-- Global static defines
ARM_LENGTH_DEFAULT = 50
ARM_LENGTH_MAX = 130
ARM_LENGTH_MIN = 20
ARM_EXTEND_SPEED = 20

HAND_TOUCH_RADIUS = 10

AWAKENESS_DECAY = 0.0001

ARM_L_X, ARM_L_Y = 180, 111
ARM_R_X, ARM_R_Y = 222, 114

ARM_L_SIGN = -1
ARM_R_SIGN = 1

HEAD_X, HEAD_Y = 213, 82
HEAD_RADIUS = 10

DRAW_DEBUG = 1

function init_gameplay()
    CONTEXT.player_arm_left = Arm(false)
    CONTEXT.player_arm_right = Arm(true)
    CONTEXT.player_arms = {CONTEXT.player_arm_left, CONTEXT.player_arm_right}
    CONTEXT.active_arm = CONTEXT.player_arm_left

    CONTEXT.player_hand_l = sprite_hand_l
    CONTEXT.player_hand_r = sprite_hand_r

    CONTEXT.is_left_arm_active = true
end


function reset_gameplay()
    CONTEXT.awakeness = 0
    CONTEXT.enemies_snoozed = 0
    for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        enemy:remove()
    end
    ENEMIES_MANAGER.enemies = {}
    ENEMIES_MANAGER.last_spawned_enemy_time = 0
    playdate.resetElapsedTime()
    initProgressionLevel(PROGRESSION_PLAN.LVL1)
    rampUpTheMusic(1, 8)
end


function handle_input()
    -- Left/Right button switches the active arm.
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        CONTEXT.active_arm = CONTEXT.player_arm_left
        CONTEXT.is_left_arm_active = true
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        CONTEXT.active_arm = CONTEXT.player_arm_right
        CONTEXT.is_left_arm_active = false
    end

    -- B button is to slap alarms/mosquitoes.
    if CONTEXT.active_arm.slapping == false and playdate.buttonIsPressed(playdate.kButtonB) then
        CONTEXT.active_arm.slapping = true
        SOUND['SLAP_ALARM']:play()
        local arm = CONTEXT.active_arm
        playdate.timer.new(100, function()
            arm.slapping = false
        end)
    end

    CONTEXT.active_arm:crank(playdate.getCrankChange())

    if CONTEXT.active_arm.grow_rate == 0 and playdate.buttonIsPressed(playdate.kButtonUp) then
        CONTEXT.active_arm:punch(20)
    end
    if CONTEXT.active_arm.grow_rate == 0 and playdate.buttonIsPressed(playdate.kButtonDown) then
        CONTEXT.active_arm:punch(-10)
    end
end


function manage_enemies()
    ENEMIES_MANAGER:spawnRandomEnemy()
    -- Update enemies (jitter around, increase radius, ...).
    for key, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        if enemy:isVisible() == true then
            enemy:update_logic(CONTEXT)
        end
    end

    local sumRadius = 0
    for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        if enemy:isVisible() then
            sumRadius = sumRadius + enemy.current_bubble_radius
        end
    end
end
