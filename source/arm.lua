gfx = playdate.graphics
geo = playdate.geometry

class('Arm').extends(Sprite)

function Arm:init(is_left)
    Arm.super.init(self)

    local x, y = ARM_R_X, ARM_R_Y
    self.sign = 1
    if is_left then
        x, y = ARM_L_X, ARM_L_Y
        self.sign = -1
    end

    local image_hand = gfx.image.new("images/hand")
    if is_left then
        image_hand = image_hand:scaledImage(-1,1)
    end

    self.hand = gfx.sprite.new()
    self.hand:setImage(image_hand)
    self.hand:setZIndex(-1)

    self.hand:setCenter(0.0, 0.5)
    self.hand:moveTo(x+ARM_LENGTH_DEFAULT, y)
    self.angle_degrees = 0
    self.angle_max = 120
    self.angle_min = -120
    if is_left then
        self.hand:setCenter(1.0, 0.5)
        self.hand:moveTo(x-ARM_LENGTH_DEFAULT, y)
        self.angle_degrees = 180
        self.angle_max = 310
        self.angle_min = 60
    end
    self.hand:add()

    if is_left then
        self.line_segment = geo.lineSegment.new(ARM_L_X, ARM_L_Y, ARM_L_X-ARM_LENGTH_DEFAULT, ARM_L_Y)
    else
        self.line_segment = geo.lineSegment.new(ARM_R_X, ARM_R_Y, ARM_R_X+ARM_LENGTH_DEFAULT, ARM_R_Y)
    end

    self.current_length = ARM_LENGTH_DEFAULT
    self.grow_rate = 0.0
    self.punch_speed = 10
    self.slapping = false
end

function Arm:crank(crank_change)
    self.angle_degrees += playdate.getCrankChange() * self.sign
    if self.angle_degrees > self.angle_max then
        self.angle_degrees = self.angle_max
    elseif self.angle_degrees < self.angle_min then
        self.angle_degrees = self.angle_min
    end

    -- Compute transforms for both arms
    local x = self.line_segment.x + self.current_length * math.cos(math.rad(self.angle_degrees))
    local y = self.line_segment.y + self.current_length * math.sin(math.rad(self.angle_degrees))

    self.current_length += self.grow_rate

    self.line_segment.x2 = x
    self.line_segment.y2 = y
    self.hand:moveTo(self.line_segment.x2, self.line_segment.y2)
    local offset = 0
    if self.sign == -1 then
        offset = 180
    end
    self.hand:setRotation(self.angle_degrees + offset)
end

function Arm:setLength(newLength)
    if newLength > ARM_LENGTH_MAX then
        newLength = ARM_LENGTH_MAX
    elseif newLength < ARM_LENGTH_MIN then
        newLength = ARM_LENGTH_MIN
    end

    local currentLength = math.sqrt((self.line_segment.x2 - self.line_segment.x)^2 + (self.line_segment.y2 - self.line_segment.y)^2)

    -- Calculate the scaling factor
    local scaleFactor = newLength / currentLength

    self.line_segment.x2 = self.line_segment.x + (self.line_segment.x2 - self.line_segment.x) * scaleFactor
    self.line_segment.y2 = self.line_segment.y + (self.line_segment.y2 - self.line_segment.y) * scaleFactor
end

function Arm:punch(speed)
    self.grow_rate = speed
    self.slapping = true
    playdate.timer.new(100, function()
        self.grow_rate = -speed
        playdate.timer.new(100, function()
            self.current_length = ARM_LENGTH_DEFAULT
            self.grow_rate = 0
            self.slapping = false
        end)
    end)
end

function Arm:clampLength()
    if self.line_segment.x2 > ARM_LENGTH_MAX then
        self.line_segment.x2 = ARM_LENGTH_MAX
    elseif self.line_segment.x2 < ARM_LENGTH_MIN then
        self.line_segment.x2 = ARM_LENGTH_MIN
    end
end
