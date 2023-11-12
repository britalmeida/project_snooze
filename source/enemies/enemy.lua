gfx = playdate.graphics
local Sprite = gfx.sprite

class('Enemy').extends(Sprite)

function Enemy:init(sound_name)
    Enemy.super.init(self)
    self.sound = SOUND[string.upper('enemy_' .. sound_name)]
    self.collision_radius = 15
    self.jitter_intensity = 1

    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    self.respawn_timer_seconds = 5

    img = gfx.image.new('images/animation_alarm1')
    self:setImage(img)
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
    active_arm = CONTEXT.player_arm_r_current
    if CONTEXT.is_left_arm_active then
        active_arm = CONTEXT.player_arm_l_current
    end
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
    return math.abs( self.x - x) <= radius and math.abs( self.y - y ) <= radius
end

function Enemy:start()
    if math.random(0, 100) < 50 then
        self:moveTo(math.random(50, 150), math.random(50, 190))
    else
        self:moveTo(math.random(250, 350), math.random(50, 190))
    end
    self:setVisible(true)
    self.sound:play(0)
end

function Enemy:on_hit()
    -- Should be called whenever player hits enemy or enemy hits player.
    self.sound:stop()
    self:setVisible(false)

    -- Start a timer to respawn this enemy.
    playdate.timer.new(self.respawn_timer_seconds*1000, function()
        self:start()
    end)
end

function Enemy:update_logic(CONTEXT)
    self:clampPosition(0, 0, 400, 240)
end
