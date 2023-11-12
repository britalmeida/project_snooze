gfx = playdate.graphics

UI_TEXTURES = {}

function add_menu_entries()

    -- Add custom entries to system menu

    local menu = playdate.getSystemMenu()

    local menuItem, error = menu:addMenuItem("restart", function()
        reset_gameplay()
    end)
end


function draw_ui()
    if CONTEXT.in_menu then
        -- In menus, game is inactive.
        UI_TEXTURES.game_start:draw(0, 0)

        gfx.pushContext()
            gfx.setColor(gfx.kColorWhite)
            gfx.fillCircleAtPoint(90, 110, 5)
        gfx.popContext()
    else
        -- Gameplay.
        -- Draw GameOver menu if lost.
        if CONTEXT.awakeness >= 1.0 then
            UI_TEXTURES.game_over:draw(0, 0)
        end
    end
end


function handle_menu_input()
    if CONTEXT.menu_screen == "start" then
        if playdate.buttonIsPressed( playdate.kButtonA ) then
            CONTEXT.in_menu = false
            reset_gameplay()
        end
    end
end


function init_menus()

    CONTEXT.in_menu = true
    CONTEXT.menu_screen = "start"

    UI_TEXTURES.game_over = gfxi.new("images/screen_game_over")
    UI_TEXTURES.game_start = gfxi.new("images/screen_start")
    UI_TEXTURES.how_to_play = gfxi.new("images/screen_how_to_play")
    UI_TEXTURES.credits = gfxi.new("images/screen_credits")

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(100, draw_ui) -- UI goes on top of everything.
end
