import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

import "sound"
import "enemies/enemies"
import "gameplay"
import "menu"
import "visuals"
import "progression"

gfx = playdate.graphics

-- Global logic context, storing the game data.
-- NOTE: All of its variables are defined in #initialize() and in the init functions of other files.
CONTEXT = {
    is_active = false, -- Paused

    -- Game State
    awakeness = 0,
    enemies_snoozed = 0,
}

function initialize()
    -- Start all systems needed by the game to start ticking

    -- Make it different, every time!
    math.randomseed(playdate.getSecondsSinceEpoch())

    -- Add custom entries to system menu
    add_menu_entries()

    -- Init all the things!
    -- init_sound()
    init_visuals()
    init_gameplay()
    init_menus()

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

    if CONTEXT.awakeness >= 1 then
        if playdate.buttonIsPressed( playdate.kButtonA ) then
            reset_gameplay()
        end

    else
        updateProgression()

        handle_input()

        manage_enemies()
        calculate_light_areas()

        -- Game Over!
        if CONTEXT.awakeness >= 1 then
            PROGRESSION.MUSIC:stop()
            SOUND.DEATH:play()
            for _, t in ipairs(playdate.timer.allTimers()) do
                t:remove()
            end
            for _, e in ipairs(ENEMIES_MANAGER.enemies) do
                e.sound_loop:stop()
            end
        end
    end

    gfx.sprite.redrawBackground()
    gfx.sprite.update()

    playdate.timer.updateTimers()
end
