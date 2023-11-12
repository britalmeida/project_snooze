import "alarm_analog"

class('AlarmPhone').extends(AlarmAnalog)

function AlarmPhone:init()
    AlarmPhone.super.init(self)
    -- Sound
    self.sound_loop = SOUND['ENEMY_ALARM_PHONE']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Graphics
    self.static_image = gfx.image.new('images/animation_alarm3')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm3-ring') , true) -- Ring
end
