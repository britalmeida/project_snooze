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

ENEMY_SPAWN_GAP_SECONDS = 5

AWAKENESS_DECAY = -0.001

ARM_L_X, ARM_L_Y = 180, 111
ARM_R_X, ARM_R_Y = 222, 114

ARM_L_SIGN = -1
ARM_R_SIGN = 1

HEAD_X, HEAD_Y = 213, 82
HEAD_RADIUS = 10

DITHERED_BUBBLES = false
DRAW_DEBUG = 0

function init_gameplay()
    -- Done only once on start of the game, to load and setup const resources.
    CONTEXT.player_arm_left = Arm(false)
    CONTEXT.player_arm_right = Arm(true)
    CONTEXT.player_arms = {CONTEXT.player_arm_left, CONTEXT.player_arm_right}
    CONTEXT.player_hand_l = sprite_hand_l
    CONTEXT.player_hand_r = sprite_hand_r
    CONTEXT.score = 0
    CONTEXT.awakeness_rate_of_change = AWAKENESS_DECAY
end


function reset_gameplay()
    -- Done on every (re)start of the play.

    PROGRESSION.MUSIC:stop()

    for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        enemy.sound_loop:stop()
        enemy:remove()
    end
    ENEMIES_MANAGER.enemies = {}
    ENEMIES_MANAGER.last_spawned_enemy_time = 0

    playdate.resetElapsedTime()

    -- Setup Character.
    CONTEXT.active_arm = CONTEXT.player_arm_left
    CONTEXT.is_left_arm_active = true
    CONTEXT.player_arm_left:reset()
    CONTEXT.player_arm_right:reset()
    CONTEXT.score = 0
    CONTEXT.awakeness_rate_of_change = AWAKENESS_DECAY

    -- Fresh Score.
    CONTEXT.awakeness = 0
    CONTEXT.enemies_snoozed = 0

    -- Start Progression.
    -- initProgressionLevel(PROGRESSION_PLAN.LVL1)
    playdate.timer.new(1000, spawn_next_enemy)
    rampUpTheMusic(1, 8)
end


function transition_to_gameover_sounds()
    -- Stop snoozed clocks from waking up during game over.
    for _, t in ipairs(playdate.timer.allTimers()) do
        t:remove()
    end

    -- Change sounds.
    SOUND.DEATH:play()
    -- Dim or stop?
    PROGRESSION.MUSIC:stop()
    for _, enemy in ipairs(ENEMIES_MANAGER.enemies) do
        if enemy.sound_loop:isPlaying() then
            enemy.sound_loop:stop()
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

function spawn_next_enemy()
    local next_enemy_idx = #ENEMIES_MANAGER.enemies + 1
    local next_enemy = ENEMY_SEQUENCE[next_enemy_idx]
    if next_enemy == nil then
        print("All enemies spawned. Game won't get any harder.")
        return
    end
    next_enemy = next_enemy()
    print("Spawned enemy " .. next_enemy_idx .. " " .. next_enemy.name)
    next_enemy:start()
    table.insert(ENEMIES_MANAGER.enemies, next_enemy)
    playdate.timer.new(ENEMY_SPAWN_GAP_SECONDS*1000, function()
        spawn_next_enemy()
    end)
end

function manage_enemies()
    -- ENEMIES_MANAGER:spawnRandomEnemy()
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


function update_gameplay_score()
    CONTEXT.awakeness = math.max(0, CONTEXT.awakeness + CONTEXT.awakeness_rate_of_change)

    -- Game Over!
    if CONTEXT.awakeness >= 1 then
        enter_menu_gameover()
    end
end
