gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init()
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0

    self:setImage(gfx.image.new('images/alarm'))
    self:addSprite()
end