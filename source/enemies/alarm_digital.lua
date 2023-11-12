import "alarm_analog"

class('AlarmDigital').extends(Alarm_Analog)

function AlarmDigital:init(sound_name)
    Alarm_Analog.super.init(self, sound_name)

    -- Load image visuals and animations
    img = gfx.image.new('images/animation_alarm2') -- Chill clock state
    anim_ring = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm2-move') , true) -- Ring
    self:setImage(img)
end