import "CoreLibs/animation"
import "CoreLibs/crank"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "sound"
import "enemies/enemies"
import "gameplay"
import "menu"
import "visuals"

gfx = playdate.graphics
frame_ms = 1000 / 30

-- Global logic context, storing the game data.
-- NOTE: All of its variables are defined in #initialize() and in the init functions of other files.
CONTEXT = {
    -- Game State
    awakeness = 0,
}


function initialize()
    -- Start all systems needed by the game to start ticking

    -- Make it different, every time!
    math.randomseed(playdate.getSecondsSinceEpoch())

    -- Init all the things!
    init_gameplay()
    init_visuals()
    init_menus()
end

initialize()
enter_menu_start()


function playdate.update()
    -- Called before every frame is drawn.

    if CONTEXT.menu_screen ~= MENU_SCREEN.gameplay then
        -- In Menu system.
        handle_menu_input()

        if CONTEXT.menu_screen == MENU_SCREEN.gameover then
            calculate_light_areas()
        end
    end
    -- Intentionally check again (no else), the menu might have just started gameplay
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        -- In gameplay.
        handle_input()
        tick_arms()
        tick_enemies()
        update_gameplay_score()
        calculate_light_areas()
    end

    -- Always redraw and update entities (sprites) and timers.
    gfx.clear()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
