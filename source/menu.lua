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

        if CONTEXT.menu_screen == "start" then

            UI_TEXTURES.game_start:draw(0, 0)

            gfx.pushContext()
                gfx.setColor(gfx.kColorWhite)
                gfx.fillCircleAtPoint(90, 110 + 25*CONTEXT.menu_focus_option, 5)
            gfx.popContext()
        end
        if CONTEXT.menu_screen == "howto" then
            UI_TEXTURES.how_to_play:draw(0, 0)
        end
        if CONTEXT.menu_screen == "credits" then
            UI_TEXTURES.credits:draw(0, 0)
        end
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
        if playdate.buttonJustReleased( playdate.kButtonA ) then
            if CONTEXT.menu_focus_option == 0 then
                CONTEXT.in_menu = false
                reset_gameplay()
            end
            if CONTEXT.menu_focus_option == 1 then
                CONTEXT.menu_screen = "howto"
            end
            if CONTEXT.menu_focus_option == 2 then
                CONTEXT.menu_screen = "credits"
            end
        end
        if playdate.buttonJustReleased( playdate.kButtonDown ) then
            CONTEXT.menu_focus_option += 1
            CONTEXT.menu_focus_option = math.min(CONTEXT.menu_focus_option, 2)
        end
        if playdate.buttonJustReleased( playdate.kButtonUp ) then
            CONTEXT.menu_focus_option -= 1
            CONTEXT.menu_focus_option = math.max(CONTEXT.menu_focus_option, 0)
        end
    end
    if CONTEXT.menu_screen == "howto" then
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            CONTEXT.menu_screen = "start"
        end
    end
    if CONTEXT.menu_screen == "credits" then
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            CONTEXT.menu_screen = "start"
        end
    end
end


function init_menus()

    CONTEXT.in_menu = true
    CONTEXT.menu_screen = "start"
    CONTEXT.menu_focus_option = 0

    UI_TEXTURES.game_over = gfxi.new("images/screen_game_over")
    UI_TEXTURES.game_start = gfxi.new("images/screen_start")
    UI_TEXTURES.how_to_play = gfxi.new("images/screen_how_to_play")
    UI_TEXTURES.credits = gfxi.new("images/screen_credits")

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(100, draw_ui) -- UI goes on top of everything.
end
