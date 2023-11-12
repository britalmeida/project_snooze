import "gameplay" -- Needed to access HEAD_X/Y in the constructor.

gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init(alarm_name)
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3
    self.sound = SOUND[string.upper(alarm_name)]
    self.collision_radius = 15
    self.movement_speed = 0.0
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y
    self.jitter_intensity = 1

    -- Load image visuals and animations
    img = gfx.image.new('images/animation_alarm1') -- Chill clock state
    anim_ring = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm1-ring') , true) -- Ring
    self:setImage(img)

    self:addSprite()
    self:setVisible(false)
end

function Alarm:jitter()
    self:moveTo(self.x + math.random(-1, 1) * self.jitter_intensity, self.y + math.random(-1, 1) * self.jitter_intensity)
end

function Alarm:moveTowardsTarget(x, y, speed)
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

function Alarm:clampPosition(min_x, min_y, max_x, max_y)
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

function Alarm:__isTouchedByActiveArm(CONTEXT)
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

function Alarm:circleCollision(x, y, radius)
    return math.abs( self.x - x) <= radius and math.abs( self.y - y ) <= radius
end

function Alarm:start()
    if math.random(0, 100) < 50 then
        self:moveTo(math.random(50, 150), math.random(50, 190))
    else
        self:moveTo(math.random(250, 350), math.random(50, 190))
    end
    self:setVisible(true)
    self.sound:play(0)
end

function Alarm:reset()
    self.current_bubble_radius = 0.0
    self:setScale(1.0)
    self:setVisible(false)
end

function Alarm:snooze()
    self.sound:stop()
    SOUND.SLAP_ALARM:play()
    CONTEXT.enemies_snoozed += 1
    self:reset()
end

function Alarm:update_logic(CONTEXT)
    if self:isVisible() == false then
        return
    end
    hand = CONTEXT.player_hand_r
    if CONTEXT.is_left_arm_active then
        hand = CONTEXT.player_hand_l
    end
    if self:circleCollision(hand.x, hand.y, HAND_TOUCH_RADIUS + self.collision_radius) then
        self:snooze()
        return
    end

    -- TODO: This should be moved into a new mosquito enemy type.
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.collision_radius) then
        print("Mosquito hit!")
        self:snooze()
        CONTEXT.awakeness = 1
    end

    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        print("Alarm hit!")
        self:snooze()
        CONTEXT.awakeness = 1
    end

    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
    self:jitter()
    self:clampPosition(50, 50, 350, 190)

    self.current_bubble_radius += self.bubble_growth_speed

    -- Set the image frame to display.
    -- e.g. if chill then self:setImage(img), otherwise walk or ring.
    self:setImage(anim_ring:image())
end
