import "enemy"

local static_img = gfx.image.new('images/animation-alarm1')
local anim_ring_imgs = gfx.imagetable.new('images/animation_alarm1_with_arms-walk')
local anim_ring_framerate = 5

class('AlarmAnalog').extends(Enemy)

function AlarmAnalog:init()
    AlarmAnalog.super.init(self)

    self.name = 'alarm_analog'
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    self.sound_loop = SOUND['ENEMY_ALARM_ANALOG']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Graphics
    self.anim_ringing = gfx.animation.loop.new(anim_ring_framerate * frame_ms, anim_ring_imgs, true)
    self.anim_idle = static_img
    self.anim_current = self.anim_ringing
end

function AlarmAnalog:behaviour_loop()
    -- Periodically change movement properties and whatnot.
    if not self:isVisible() or not self.is_alive then
        return
    end

    -- Go back and forth between jittering and moving and being static.
    self.jitter_intensity = 1
    self.bubble_growth_speed = 0.6
    self.anim_current = self.anim_ringing
    playdate.timer.new(1000, function()
        self.jitter_intensity = 0
        self.anim_current = self.anim_idle
        self.bubble_growth_speed = -0.1
        playdate.timer.new(1000, function()
            self:behaviour_loop()
        end)
    end)

end

function AlarmAnalog:tick(CONTEXT)
    AlarmAnalog.super.tick(self, CONTEXT)
end
