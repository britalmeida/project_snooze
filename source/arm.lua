gfx = playdate.graphics
geo = playdate.geometry

class('Arm').extends(Sprite)

function Arm:init(is_left)
    Arm.super.init(self)

    self.is_left = is_left

    local image_hand = gfx.image.new("images/hand")
    local image_punch = gfx.image.new("images/hand_fist")
    if is_left then
        image_hand = image_hand:scaledImage(-1,1)
        image_punch = image_punch:scaledImage(-1,1)
    end

    self.image_hand = image_hand
    self.image_punch = image_punch
    self.hand = gfx.sprite.new()
    self.hand:setImage(self.image_hand)
    self.hand:setZIndex(-1)
    self.hand:add()

    self:reset()
end

function Arm:reset()

    local x, y = ARM_R_X, ARM_R_Y
    self.sign = 1
    if self.is_left then
        x, y = ARM_L_X, ARM_L_Y
        self.sign = -1
    end

    self.hand:moveTo(x+ARM_LENGTH_DEFAULT, y)
    self.angle_degrees = 0
    self.angle_max = 120
    self.angle_min = -120
    if self.is_left then
        self.hand:moveTo(x-ARM_LENGTH_DEFAULT, y)
        self.angle_degrees = 180
        self.angle_max = 310
        self.angle_min = 60
    end

    if self.is_left then
        self.line_segment = geo.lineSegment.new(ARM_L_X, ARM_L_Y, ARM_L_X-ARM_LENGTH_DEFAULT, ARM_L_Y)
    else
        self.line_segment = geo.lineSegment.new(ARM_R_X, ARM_R_Y, ARM_R_X+ARM_LENGTH_DEFAULT, ARM_R_Y)
    end

    self.current_length = ARM_LENGTH_DEFAULT
    self.grow_rate = 0.0
    self.punch_speed = 10
    self.slapping = false
    self:crank(0)
end

function Arm:tick()
    self.current_length += self.grow_rate
    self:clampLength()

    -- Compute transforms
    local x = self.line_segment.x + self.current_length * math.cos(math.rad(self.angle_degrees))
    local y = self.line_segment.y + self.current_length * math.sin(math.rad(self.angle_degrees))

    self.line_segment.x2 = x
    self.line_segment.y2 = y
    self.hand:moveTo(self.line_segment.x2, self.line_segment.y2)
    local offset = 0
    if self.sign == -1 then
        offset = 180
    end
    self.hand:setRotation(self.angle_degrees + offset)
end

function Arm:crank()
    self.angle_degrees += playdate.getCrankChange()
    if self.angle_degrees > self.angle_max then
        self.angle_degrees = self.angle_max
    elseif self.angle_degrees < self.angle_min then
        self.angle_degrees = self.angle_min
    end
end

function Arm:punch(speed, duration)
    self.grow_rate = speed
    self.slapping = true
    self.hand:setImage(self.image_punch)
    playdate.timer.new(duration, function()
        self.grow_rate = -speed
        playdate.timer.new(duration, function()
            self.current_length = ARM_LENGTH_DEFAULT
            self.grow_rate = 0
            self.slapping = false
            self.hand:setImage(self.image_hand)
        end)
    end)
end

function Arm:clampLength()
    -- We ideally shouldn't rely on this, but instead tweak the punch speed timings.
    if self.current_length > ARM_LENGTH_MAX then
        self.current_length = ARM_LENGTH_MAX
    elseif self.current_length < ARM_LENGTH_MIN then
        self.current_length = ARM_LENGTH_MIN
    end
end
