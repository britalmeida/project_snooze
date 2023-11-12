import "alarm_analog"

class('AlarmDigital').extends(AlarmAnalog)

function AlarmDigital:init()
    AlarmDigital.super.init(self)

    self.sound_loop = SOUND['ENEMY_ALARM_DIGITAL']
    self.sound_slap = SOUND['SLAP_ALARM']

    self.jitter_intensity = 0

    -- Load image visuals and animations
    self.static_image = gfx.image.new('images/animation_alarm2')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(500, gfx.imagetable.new('images/animation_alarm2-move') , true) -- Ring
end

function AlarmDigital:update_logic()
    AlarmDigital.super.update_logic(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end