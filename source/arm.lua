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
    self.hand:setImage(image_hand_left)
    self.hand:setZIndex(-1)

    self.hand:setCenter(0.0, 0.5)
    self.hand:moveTo(x+ARM_LENGTH_DEFAULT, y)
    self.angle_degrees = 0
    if is_left then
        self.hand:setCenter(1.0, 0.5)
        self.hand:moveTo(x-ARM_LENGTH_DEFAULT, y)
        self.angle_degrees = 180
    end
    self.hand:add()

    if is_left then
        self.line_segment = geo.lineSegment.new(ARM_L_X, ARM_L_Y, ARM_L_X-ARM_LENGTH_DEFAULT, ARM_L_Y)
    else
        self.line_segment = geo.lineSegment.new(ARM_R_X, ARM_R_Y, ARM_R_X+ARM_LENGTH_DEFAULT, ARM_R_Y)
    end

    self.grow_rate = 0.0
    self.slapping = false
end

function Arm:crank(crank_change)
    self.angle_degrees += playdate.getCrankChange() * self.sign

    -- Compute transforms for both arms
    local x = self.line_segment.x + ARM_LENGTH_DEFAULT * math.cos(math.rad(self.angle_degrees))
    local y = self.line_segment.y + ARM_LENGTH_DEFAULT * math.sin(math.rad(self.angle_degrees))

    self.line_segment.x2 = x
    self.line_segment.y2 = y
    self.hand:moveTo(self.line_segment.x2, self.line_segment.y2)
    self.hand:setRotation(self.angle_degrees * ARM_L_SIGN - 180)

end

function Arm:clampLength()
    if self.line_segment.x2 > ARM_LENGTH_MAX then
        self.line_segment.x2 = ARM_LENGTH_MAX
    elseif self.line_segment.x2 < ARM_LENGTH_MIN then
        self.line_segment.x2 = ARM_LENGTH_MIN
    end
end
