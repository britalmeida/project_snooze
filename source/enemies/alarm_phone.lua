import "alarm_analog"

local still_img = gfx.image.new('images/animation_alarm3')
local anim_ring_imgs = gfx.imagetable.new('images/animation_alarm3-ring')
local anim_ring_framerate = 1

class('AlarmPhone').extends(AlarmAnalog)

function AlarmPhone:init()
    AlarmPhone.super.init(self)
    -- Sound
    self.name = 'alarm_phone'
    self.sound_loop = SOUND['ENEMY_ALARM_PHONE']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Graphics
    self.static_image = still_img
    self.anim_default = gfx.animation.loop.new(anim_ring_framerate * frame_ms, anim_ring_imgs, true)
    self:setImage(self.static_image)
end
