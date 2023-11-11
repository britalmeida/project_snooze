gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init()
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0

    clock_image = gfx.image.new('images/clock')
    clock_image:setMaskImage(gfx.image.new('images/clock_mask'))
    self:setImage(clock_image)
    self:addSprite()
end

function Alarm:jitter()
    self:moveTo(self.x + math.random(-1, 1), self.y + math.random(-1, 1))
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

function Alarm:isTouched(CONTEXT)
    -- Detect contact between alarm clock and the active hand.
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

function Alarm:start()
    if math.random(0, 100) < 50 then
        sprite_alarm:moveTo(math.random(50, 150), math.random(50, 190))
    else
        sprite_alarm:moveTo(math.random(250, 350), math.random(50, 190))
    end
    sprite_alarm:setVisible(true)
    if TIMER.value % 500 == 0 then
        SOUND.ALARM1:play(0)
    end
end

function Alarm:reset()
    self.current_bubble_radius = 0.0
    self:setScale(1.0)
    self:setVisible(false)
    SOUND.ALARM1:stop()
    SOUND.SLAP_ALARM:play()
end

function Alarm:update_logic(CONTEXT)
    curr_scale = self:getScale()
    if curr_scale == 1.0 and self:isTouched(CONTEXT) then
        self:setScale(1.5)
    elseif curr_scale == 1.5 then
        self:setScale(1.8)
    elseif curr_scale == 1.8 then
        self:setScale(2.0)
    elseif curr_scale == 2.0 then
        self:setScale(2.1)
    elseif curr_scale == 2.1 then
        self:reset()
        return
    end

    self:jitter()
    self:clampPosition(50, 50, 350, 190)

    self.current_bubble_radius += 0.1
end
