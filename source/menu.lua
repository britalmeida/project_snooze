

function add_menu_entries()

    -- Add custom entries to system menu

    local menu = playdate.getSystemMenu()

    local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("test screen", false, function(value)
        if value then
            CONTEXT.image_bg = CONTEXT.image_bg_test2
        else
            CONTEXT.image_bg = CONTEXT.image_bg_test1
        end
    end)

end
