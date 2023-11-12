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
    init_visuals()
    init_gameplay()
    init_sound()

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

    handle_input()

    manage_enemies()

    main_draw()

    playdate.timer.updateTimers()
end
