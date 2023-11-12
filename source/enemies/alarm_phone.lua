import "alarm_analog"

class('AlarmPhone').extends(Alarm_Analog)

function AlarmPhone:init(sound_name)
    Alarm_Analog.super.init(self, sound_name)

    -- Load image visuals and animations
    img = gfx.image.new('images/animation_alarm3') -- Chill clock state
    anim_ring = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm3-ring') , true) -- Ring
    self:setImage(img)
end