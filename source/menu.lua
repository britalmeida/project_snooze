

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
