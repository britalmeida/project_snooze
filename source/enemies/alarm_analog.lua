import "enemy"

local still_img = gfx.image.new('images/animation_alarm1')
local anim_ring_imgs = gfx.imagetable.new('images/animation_alarm1-ring')
local anim_ring_framerate = 1

class('AlarmAnalog').extends(Enemy)

function AlarmAnalog:init()
    AlarmAnalog.super.init(self)

    self.name = 'alarm_analog'
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    self.sound_loop = SOUND['ENEMY_ALARM_ANALOG']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Graphics
    self.static_image = still_img
    self.anim_default = gfx.animation.loop.new(anim_ring_framerate * frame_ms, anim_ring_imgs, true)
    self:setImage(self.static_image)
end

function AlarmAnalog:on_hit_by_player()
    CONTEXT.enemies_snoozed += 1
    AlarmAnalog.super.on_hit_by_player(self)
end

function AlarmAnalog:on_hit()
    -- Should be called whenever player hits enemy or enemy hits player

    self.current_bubble_radius = 0.0

    AlarmAnalog.super.on_hit(self)
end

function AlarmAnalog:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:hit_the_player()
    end

    self.current_bubble_radius += self.bubble_growth_speed

    AlarmAnalog.super.update_logic(self, CONTEXT)
end
