

function add_menu_entries()

    -- Add custom entries to system menu

    local menu = playdate.getSystemMenu()

    local menuItem, error = menu:addMenuItem("restart", function()
        reset_gameplay()
    end)

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test screen", false, function(value)
        if value then
            CONTEXT.image_bg = CONTEXT.image_bg_test2
        else
            CONTEXT.image_bg = CONTEXT.image_bg_test1
        end
    end)

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test dither", false, function(value)
        CONTEXT.test_dither = value
    end)

end
