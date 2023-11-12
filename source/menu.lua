
UI_TEXTURES = {}

function add_menu_entries()

    -- Add custom entries to system menu

    local menu = playdate.getSystemMenu()

    local menuItem, error = menu:addMenuItem("restart", function()
        reset_gameplay()
    end)

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test screen", false, function(value)
        CONTEXT.test_screen = value
    end)

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test dither", false, function(value)
        CONTEXT.test_dither = value
    end)

end


function draw_ui()
    if CONTEXT.awakeness >= 1.0 then
        UI_TEXTURES.game_over:draw(0, 0)
    end
end


function init_menus()

    UI_TEXTURES.game_over = gfxi.new("images/screen_game_over")

    -- Set the multiple things in their Z order of what overlaps what.
    setDrawPass(100, draw_ui) -- UI goes on top of everything.
end
