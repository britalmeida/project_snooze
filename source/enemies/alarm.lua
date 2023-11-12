gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init(alarm_name)
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0
    self.sound = SOUND[string.upper(alarm_name)]
    self.collision_radius = 15
    self.movement_speed = 0.8
    self.movement_target_x = 213
    self.movement_target_y = 82

    img = gfx.image.new('images/animation_alarm1')
    self:setImage(img)
    self:addSprite()
    self:setVisible(false)
end

function Alarm:drawDebug()
    if DRAW_DEBUG == 0 then
        return
    end
    if self == nil then
        return
    end
    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(2)
        gfx.drawCircleAtPoint(self.x, self.y, self.collision_radius)
    gfx.popContext()
end

function Alarm:jitter()
    self:moveTo(self.x + math.random(-1, 1), self.y + math.random(-1, 1))
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

function Alarm:isTouchedBySprite(sprite, radius)
    local total_radius = radius + self.collision_radius
    return math.abs( self.x - sprite.x) <= total_radius and math.abs( self.y - sprite.y ) <= total_radius
end

function Alarm:start()
    if math.random(0, 100) < 50 then
        self:moveTo(math.random(50, 150), math.random(50, 190))
    else
        self:moveTo(math.random(250, 350), math.random(50, 190))
    end
    self:setVisible(true)
    if TIMER.value % 500 == 0 then
        self.sound:play(0)
    end
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
    print(CONTEXT.enemies_snoozed)
    self:reset()
end

function Alarm:update_logic(CONTEXT)
    hand = CONTEXT.player_hand_r
    if CONTEXT.is_left_arm_active then
        hand = CONTEXT.player_hand_l
    end
    if self:isTouchedBySprite(hand, HAND_TOUCH_RADIUS) then
        self:snooze()
        return
    end

    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
    self:jitter()
    self:clampPosition(50, 50, 350, 190)

    self.current_bubble_radius += 0.1
end
