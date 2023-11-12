gfx = playdate.graphics

class('Cat').extends(Enemy)

function Cat:init(sound_name)
    Cat.super.init(self)
    -- Sound
    self.sound_loop = SOUND['ENEMY_ALARM_CAT']
    self.sound_slap = SOUND['SLAP_CAT']

    -- Graphics
    self.static_image = gfx.image.new('images/animation_alarm4')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm4') , true) -- Ring

end