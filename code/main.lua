-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.

local gfx <const> = playdate.graphics

-- A function to set up our game environment.

function myGameSetUp()

    -- Set up the player sprite.
    -- The :setCenter() call specifies that the sprite will be anchored at its center.
    -- The :moveTo() call moves our sprite to the center of the display.

    -- Which arm is active, left (true) or right (false).
    is_left = false

    -- Left arm data.
    player_arm_l = playdate.geometry.lineSegment.new(0, 0, -100, 0)
    player_arm_l_angle = 0

    -- Right arm data.
    player_arm_r = playdate.geometry.lineSegment.new(0, 0, 100, 0)
    player_arm_r_angle = 0

    -- Active and inactive arms.
    player_arm = player_arm_r
    player_arm_rest = player_arm_l

    -- Alarm clock data.
    alarm_clock = playdate.geometry.arc.new(0, 0, 50, 20, 340)
    is_alarm_clock_on = false

end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

    -- Poll the d-pad and move our player accordingly.
    -- (There are multiple ways to read the d-pad; this is the simplest.)
    -- Note that it is possible for more than one of these directions
    -- to be pressed at once, if the user is pressing diagonally.

    -- Default drawing context.
    gfx.setLineWidth(2)
    gfx.clear(gfx.kColorWhite)

    -- If crank is docked, player is happily sleeping.
    if playdate.isCrankDocked() then
        return
    end

    -- If no alarm clock, gives a chance to trigger it.
    -- Else gitter it around.
    if not is_alarm_clock_on then
        if math.random(0, 256) > 250 then
            is_alarm_clock_on = true

            alarm_clock.x = math.random(50, 350)
            alarm_clock.y = math.random(50, 190)
        end
    else
        alarm_clock.x += math.random(-1, 1)
        alarm_clock.y += math.random(-1, 1)
    end

    -- If A or B button is pressed, define active arm.
    if playdate.buttonIsPressed( playdate.kButtonA ) then
        is_left = false
    end
    if playdate.buttonIsPressed( playdate.kButtonB ) then
        is_left = true
    end

    -- Assign active and resting arms.
    if is_left then
        player_arm = player_arm_l
        player_arm_rest = player_arm_r
    else
        player_arm = player_arm_r
        player_arm_rest = player_arm_l
    end

    -- Handle active arm length.
    -- If button is pressed, actively lengthen/shorten it.
    -- Else, automatically move back towards rest/default length (also for inactive arm).
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        player_arm.x2 += 2
    elseif playdate.buttonIsPressed( playdate.kButtonLeft ) then
        player_arm.x2 += -2
    elseif math.abs(player_arm.x2) ~= 100 then
        if player_arm.x2 > 100 then
            player_arm.x2 -= 2
        elseif player_arm.x2 > 0 then
            player_arm.x2 += 2
        elseif player_arm.x2 < -100 then
            player_arm.x2 += 2
        elseif player_arm.x2 < 0 then
            player_arm.x2 -= 2
        end
    end
    if math.abs(player_arm_rest.x2) ~= 100 then
        if player_arm.x2 > 100 then
            player_arm.x2 -= 2
        elseif player_arm.x2 > 0 then
            player_arm.x2 += 2
        elseif player_arm.x2 < -100 then
            player_arm.x2 += 2
        elseif player_arm.x2 < 0 then
            player_arm.x2 -= 2
        end
    end

    -- Clamp arms length.
    if player_arm_l.x2 > -20 then
        player_arm_l.x2 = -20
    elseif player_arm_l.x2 < -180 then
        player_arm_l.x2 = -180
    end
    if player_arm_r.x2 < 20 then
        player_arm_r.x2 = 20
    elseif player_arm_r.x2 > 180 then
        player_arm_r.x2 = 180
    end

    -- Read angle from the crank.
    -- TODO: this makes arm jump to angle when switching active arm.
    if is_left then
        player_arm_l_angle = -playdate.getCrankPosition()
    else
        player_arm_r_angle = playdate.getCrankPosition()
    end

    -- Compute transforms for both arms
    player_arm_l_tx = playdate.geometry.affineTransform.new()
    player_arm_l_tx:rotate(player_arm_l_angle)
    player_arm_l_tx:translate(150, 100)
    player_arm_l_current = player_arm_l_tx:transformedLineSegment(player_arm_l)

    player_arm_r_tx = playdate.geometry.affineTransform.new()
    player_arm_r_tx:rotate(player_arm_r_angle)
    player_arm_r_tx:translate(250, 100)
    player_arm_r_current = player_arm_r_tx:transformedLineSegment(player_arm_r)

    -- Draw the arms.
    gfx.pushContext()
    gfx.setLineCapStyle(playdate.graphics.kLineCapStyleRound)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(10)
    gfx.drawLine(player_arm_l_current)
    gfx.drawLine(player_arm_r_current)
    gfx.popContext()

    -- If no active alarm clock, we are done.
    if not is_alarm_clock_on then
        return
    end

    -- Detect contact between alarm clock and hands (also for inactive one currently).
    is_contact_l = math.abs(player_arm_l_current.x2 - alarm_clock.x) < 5 and math.abs(player_arm_l_current.y2 - alarm_clock.y) < 5
    is_contact_r = math.abs(player_arm_r_current.x2 - alarm_clock.x) < 5 and math.abs(player_arm_r_current.y2 - alarm_clock.y) < 5
    is_contact = is_contact_l or is_contact_r

    -- Draw alarm clock, bigger if there is contact with hands.
    gfx.pushContext()
    gfx.setColor(gfx.kColorBlack)
    alarm_clock_radius = 10
    if is_contact then
        gfx.setLineWidth(6)
        alarm_clock_radius = 15
    end
    alarm_clock.radius = alarm_clock_radius
    gfx.drawArc(alarm_clock)
    gfx.popContext()

    -- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)

    -- gfx.sprite.update()
    playdate.timer.updateTimers()

end
