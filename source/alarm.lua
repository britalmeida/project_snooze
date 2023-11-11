gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init()
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0

    self:setImage(gfx.image.new('images/alarm'))
    self:addSprite()
end

function Alarm:jitter()
    self:moveTo(self.x + math.random(-1, 1), self.y+math.random(-1, 1))
end

function Alarm:update()
    if not self:isVisible() then
        return
    end

    self:jitter()
    self.current_bubble_radius += 0.1
end

function Alarm:reset()
    self.current_bubble_radius = 0.0
    self:setScale(1)
    self:setVisible(false)
end

function Alarm:isTouched(active_hand)
    -- Detect contact between alarm clock and the active hand.
    return math.abs(active_hand.x - self.x) < touch_radius and math.abs(active_hand.y - self.y) < touch_radius
end