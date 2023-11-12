gfx = playdate.graphics

class('Cat').extends(Enemy)

function Cat:init(sound_name)
    Cat.super.init(self, sound_name)

    -- Load image visuals and animations
    img = gfx.image.new('images/animation_alarm4') -- Chill clock state
    anim_ring = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm4') , true) -- Ring
    self:setImage(img)
end