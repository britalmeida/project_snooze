import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "music"
import "enemies/enemies"
import "arm"
import "snore"

gfx = playdate.graphics

-- Global static defines
ARM_LENGTH_DEFAULT = 50
ARM_LENGTH_MAX = 130
ARM_LENGTH_MIN = 20
ARM_EXTEND_SPEED = 20

HAND_TOUCH_RADIUS = 10

ENEMY_SPAWN_GAP_SECONDS = 2

AWAKENESS_DECAY = -0.001

ARM_L_X, ARM_L_Y = 180, 111
ARM_R_X, ARM_R_Y = 222, 114

ARM_L_SIGN = -1
ARM_R_SIGN = 1

HEAD_X, HEAD_Y = 213, 82
HEAD_RADIUS = 10

DITHERED_BUBBLES = false
DRAW_DEBUG = 0

MUSIC_CHANGE_RATE = 8 -- Every this many seconds, the music ramps up.

function init_gameplay()
    -- Done only once on start of the game, to load and setup const resources.
    CONTEXT.player_head = Head()
    CONTEXT.player_arm_left = Arm(false)
    CONTEXT.player_arm_right = Arm(true)
    CONTEXT.player_arms = {CONTEXT.player_arm_left, CONTEXT.player_arm_right}
    CONTEXT.player_hand_l = sprite_hand_l
    CONTEXT.player_hand_r = sprite_hand_r
end


function reset_gameplay()
    -- Done on every (re)start of the play.

    stop_gameplay_sounds()

    for _, enemy in ipairs(ENEMIES) do
        enemy:remove()
    end
    ENEMIES = {}
    BUBBLE_POPS = {}

    playdate.resetElapsedTime()
    if CONTEXT.gameover_anim_timer then
        CONTEXT.gameover_anim_timer:reset()
    end

    -- Setup Character.
    CONTEXT.active_arm = CONTEXT.player_arm_left
    CONTEXT.is_left_arm_active = true
    CONTEXT.player_arm_left:reset()
    CONTEXT.player_arm_right:reset()
    CONTEXT.player_head:reset()

    -- Fresh Score.
    CONTEXT.score = 0
    CONTEXT.awakeness_rate_of_change = AWAKENESS_DECAY
    CONTEXT.awakeness = 0

    -- Start Progression.
    playdate.timer.new(1000, spawn_next_enemy)
    rampUpTheMusic(1, MUSIC_CHANGE_RATE)
end


function stop_gameplay_sounds()
    -- Stop snoozed clocks from waking up during game over.
    for _, t in ipairs(playdate.timer.allTimers()) do
        t:remove()
    end

    if CURRENT_BG_MUSIC then
        CURRENT_BG_MUSIC:stop()
    end
    for _, enemy in ipairs(ENEMIES) do
        if enemy.sound_loop then 
            if enemy.sound_loop:isPlaying() then
                enemy.sound_loop:stop()
            end
        end
    end
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
    if CONTEXT.active_arm.slapping == false and playdate.buttonJustPressed(playdate.kButtonB) then
        CONTEXT.active_arm.slapping = true
        SOUND['SLAP_ALARM']:play()
        local arm = CONTEXT.active_arm
        playdate.timer.new(100, function()
            arm.slapping = false
        end)
    end

    CONTEXT.active_arm:crank()

    if CONTEXT.active_arm.grow_rate == 0 and playdate.buttonJustPressed(playdate.kButtonUp) then
        CONTEXT.active_arm:punch(20, 80)
    end
    if CONTEXT.active_arm.grow_rate == 0 and playdate.buttonJustPressed(playdate.kButtonDown) then
        CONTEXT.active_arm:punch(-10, 100)
    end
end

function tick_arms()
    for index, arm in ipairs(CONTEXT.player_arms) do
        arm:tick()
    end
end

function tick_enemies()
    -- Update enemies (jitter around, increase radius, ...).
    for key, enemy in ipairs(ENEMIES) do
        if enemy:isVisible() then
            enemy:tick(CONTEXT)
        end
    end
end


function update_gameplay_score()
    CONTEXT.awakeness = math.max(0, CONTEXT.awakeness + CONTEXT.awakeness_rate_of_change)

    -- Game Over!
    if CONTEXT.awakeness >= 1 then
        enter_menu_gameover()
    end
end
