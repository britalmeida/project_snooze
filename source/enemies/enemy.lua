gfx = playdate.graphics
local Sprite = gfx.sprite

class('Enemy').extends(Sprite)

function Enemy:init(sound_name)
    Enemy.super.init(self)

    -- Threat
    self.collision_radius = 15
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    -- Movement
    self.jitter_intensity = 1
    self.movement_speed = 0.3
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y

    -- Life cycle
    self.respawn_timer_seconds = 8

    -- Sound
    self.sound_loop = nil
    self.sound_slap = nil

    -- Graphics
    self.static_image = nil
    self.anim_default = nil
    self:setImage(self.static_image)
    self:addSprite()
    self:setVisible(false)
end

function Enemy:jitter()
    self:moveTo(self.x + math.random(-1, 1) * self.jitter_intensity, self.y + math.random(-1, 1) * self.jitter_intensity)
end

function Enemy:moveTowardsTarget(x, y, speed)
    local directionX = x - self.x
    local directionY = y - self.y

    -- Calculate the distance between self and target
    local distance = math.sqrt(directionX^2 + directionY^2)

    -- Normalize the direction vector
    directionX = directionX / distance
    directionY = directionY / distance

    -- Update the Enemy's position based on the direction and speed
    self.x = self.x + directionX * speed
    self.y = self.y + directionY * speed

    self:moveTo(self.x + directionX * speed, self.y + directionY * speed)
end

function Enemy:clampPosition(min_x, min_y, max_x, max_y)
    if self.x < min_x then
        self.x = min_x
    elseif self.x > max_x then
        self.x = max_x
    end

    if self.y < min_y then
        self.y = min_y
    elseif self.y > max_y then
        self.y = max_y
    end
end

function Enemy:__isTouchedByActiveArm(CONTEXT)
    -- Dead code for now, we only want touch detection on the hands, not the whole arm.

    -- Detect contact between alarm clock and the active arm.
    active_arm = CONTEXT.active_arm
    self_p = playdate.geometry.point.new(self.x, self.y)
    hand_p = playdate.geometry.point.new(active_arm.x2, active_arm.y2)
    -- If self point is more than ARM_EXTEND_SPEED pixels away, no contact.
    if self_p:squaredDistanceToPoint(hand_p) > ARM_EXTEND_SPEED * ARM_EXTEND_SPEED then
        return false
    end
    closest_p = active_arm:closestPointOnLineToPoint(self_p)
    -- If closest point on arm from self is more than HAND_TOUCH_RADIUS pixels away, no contact.
    if self_p:squaredDistanceToPoint(closest_p) > HAND_TOUCH_RADIUS * HAND_TOUCH_RADIUS then
        return false
    end
    return true
end

function Enemy:circleCollision(x, y, radius)
    return math.sqrt((self.x - x)^2 + (self.y - y)^2) < radius
end

function self:is_out_of_reach()
    for _, arm in ipairs(CONTEXT.player_arms)
    if self:circleCollision(arm.x, arm.y, ARM_LENGTH_MAX) then
        return true
    end
    return false
end

function Enemy:start()
    local repeats = 0
    repeat
        -- Pick an arm
        arm = CONTEXT.player_arms[math.random(1, 2)]

        -- Pick an angle.
        local angle = math.random(arm.angle_min, arm.angle_max)
        local radius = math.random(50, ARM_LENGTH_MAX)

        local x = radius * math.cos(math.rad(angle))
        local y = radius * math.sin(math.rad(angle))

        self:moveTo(x, y)
        repeats += 1
    until ((self:is_near_player_face(self.current_bubble_radius) or self:is_out_of_reach()) == false) or repeats > 10

    self:setVisible(true)
    if self.sound_loop then 
        self.sound_loop:play(0)
    end
end

function Enemy:is_near_player_face(threshold)
    return self:circleCollision(HEAD_X, HEAD_Y, threshold)
end

function Enemy:on_hit_by_player()
    if self.sound_slap then
        self.sound_slap:play()
    end
    self:on_hit()
end

function Enemy:on_hit()
    -- Should be called whenever player hits enemy or enemy hits player.
    if self.sound_loop then
        self.sound_loop:stop()
    end
    self:setVisible(false)

    -- Start a timer to respawn this enemy.
    playdate.timer.new(self.respawn_timer_seconds*1000, function()
        self:start()
    end)
end

function Enemy:is_touched_by_hand(hand)
    return self:circleCollision(hand.x, hand.y, HAND_TOUCH_RADIUS + self.collision_radius)
end

function Enemy:is_touched_by_any_hand(CONTEXT)
    for _, arm in ipairs(CONTEXT.player_arms) do
        if self:circleCollision(arm.hand.x, arm.hand.y, HAND_TOUCH_RADIUS + self.collision_radius) then
            return true
        end
    end
    return false
end

function Enemy:update_logic(CONTEXT)
    for _, arm in ipairs(CONTEXT.player_arms) do
        if arm.slapping and self:is_touched_by_hand(arm.hand) then
            self:on_hit_by_player()
            return
        end
    end
    self:jitter()
    self:clampPosition(0, 0, 400, 240)

    -- Set the image frame to display.
    -- e.g. if chill then self:setImage(img), otherwise walk or ring.
    if self.anim_default then 
        self:setImage(self.anim_default:image())
    end
end
