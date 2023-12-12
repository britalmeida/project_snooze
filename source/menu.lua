gfx = playdate.graphics

MENU_SCREEN = { gameplay = 0, gameover = 1, start = 2, howto = 3, credits = 4 }
local UI_TEXTURES = {}


-- System Menu

function add_system_menu_entries()

    local menu = playdate.getSystemMenu()
    menu:removeAllMenuItems() -- ensure there's no duplicated entries.

        -- Add custom entries to system menu.

    local menuItem, error = menu:addMenuItem("restart", function()
        reset_gameplay()
    end)
    local menuItem, error = menu:addMenuItem("main menu", function()
        enter_menu_start()
    end)
end

function remove_system_menu_entries()
    playdate.getSystemMenu():removeAllMenuItems()
end


-- Menu State Transitions

function enter_menu_start()
    CONTEXT.menu_screen = MENU_SCREEN.start

    remove_system_menu_entries()
    stop_gameplay_sounds()

    CONTEXT.menu_active_screen_texture = UI_TEXTURES.game_start
    if not SOUND.BG_LOOP_MENU:isPlaying() then
        SOUND.BG_LOOP_MENU:play(0)
    end
end

function enter_menu_howto()
    CONTEXT.menu_screen = MENU_SCREEN.howto

    CONTEXT.menu_active_screen_texture = UI_TEXTURES.how_to_play
end

function enter_menu_credits()
    CONTEXT.menu_screen = MENU_SCREEN.credits

    CONTEXT.menu_active_screen_texture = UI_TEXTURES.credits
end

function enter_menu_gameover()
    CONTEXT.menu_screen = MENU_SCREEN.gameover

    CONTEXT.menu_active_screen_texture = UI_TEXTURES.game_over
    SOUND.DEATH:play()
    stop_gameplay_sounds()
    CONTEXT.gameover_anim_timer = playdate.timer.new(1500, 0, 1, playdate.easingFunctions.outCubic)
end

function enter_gameplay()
    CONTEXT.menu_screen = MENU_SCREEN.gameplay

    SOUND.BG_LOOP_MENU:stop()
    add_system_menu_entries()
    reset_gameplay()
end


-- Draw & Update

function draw_ui()
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        return
    end

    -- In menus, game is inactive.

    -- Draw baground screen image.
    CONTEXT.menu_active_screen_texture:draw(0, 0)

    -- Start menu draws a selected option indicator.
    if CONTEXT.menu_screen == MENU_SCREEN.start then
        gfx.pushContext()
            gfx.setColor(gfx.kColorWhite)
            gfx.fillCircleAtPoint(73, 110 + 27*CONTEXT.menu_focus_option, 7)
        gfx.popContext()

    -- Draw gameover screen dynamic elements.
    elseif CONTEXT.menu_screen == MENU_SCREEN.gameover then
    end
end


function handle_menu_input()
    if CONTEXT.menu_screen == MENU_SCREEN.gameover then
        if playdate.buttonIsPressed( playdate.kButtonA ) then
            SOUND.MENU_CONFIRM:play()
            enter_gameplay()
        end
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            SOUND.MENU_CONFIRM:play()
            enter_menu_start()
        end
    end
    if CONTEXT.menu_screen == MENU_SCREEN.start then
        -- Select an Option.
        if playdate.buttonJustReleased( playdate.kButtonA ) then
            SOUND.MENU_CONFIRM:play()
            if CONTEXT.menu_focus_option == 0 then
                enter_gameplay()
            end
            if CONTEXT.menu_focus_option == 1 then
                enter_menu_howto()
            end
            if CONTEXT.menu_focus_option == 2 then
                enter_menu_credits()
            end
        end
        -- Cycle Options.
        if playdate.buttonJustReleased( playdate.kButtonDown ) then
            CONTEXT.menu_focus_option += 1
            SOUND.MENU_HIGHLIGHT:play()
        end
        if playdate.buttonJustReleased( playdate.kButtonUp ) then
            CONTEXT.menu_focus_option -= 1
            SOUND.MENU_HIGHLIGHT:play()
        end
        local crankTicks = playdate.getCrankTicks(3)
        if crankTicks == 1 then
            CONTEXT.menu_focus_option += 1
        elseif crankTicks == -1 then
            CONTEXT.menu_focus_option -= 1
        end
        -- Clamp so the option cycling doesn't wrap around.
        CONTEXT.menu_focus_option = math.max(CONTEXT.menu_focus_option, 0)
        CONTEXT.menu_focus_option = math.min(CONTEXT.menu_focus_option, 2)
    end
    if CONTEXT.menu_screen == MENU_SCREEN.howto then
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            SOUND.MENU_CONFIRM:play()
            enter_menu_start()
        end
    end
    if CONTEXT.menu_screen == MENU_SCREEN.credits then
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            SOUND.MENU_CONFIRM:play()
            enter_menu_start()
        end
    end
end


function init_menus()

    UI_TEXTURES.game_over = gfxi.new("images/screen_game_over")
    UI_TEXTURES.game_start = gfxi.new("images/screen_start")
    UI_TEXTURES.how_to_play = gfxi.new("images/screen_how_to_play")
    UI_TEXTURES.credits = gfxi.new("images/screen_credits")

    CONTEXT.menu_active_screen_texture = UI_TEXTURES.game_start
    CONTEXT.menu_focus_option = 0

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(100, draw_ui) -- UI goes on top of everything.
end
