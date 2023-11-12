import "enemy"

gfx = playdate.graphics

class('AlarmAnalog').extends(Enemy)

function AlarmAnalog:init()
    AlarmAnalog.super.init(self)

    self.name = 'alarm_analog'
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    self.sound_loop = SOUND['ENEMY_ALARM_ANALOG']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Load image visuals and animations
    self.static_image = gfx.image.new('images/animation_alarm1')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm1-ring') , true) -- Ring

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
        self:on_hit()
        CONTEXT.awakeness = 1
    end

    self.current_bubble_radius += self.bubble_growth_speed

    AlarmAnalog.super.update_logic(self, CONTEXT)
end
