gfx = playdate.graphics

class('Cat').extends(Enemy)

function Cat:init()
    Cat.super.init(self)
    -- Sound
    self.sound_loop = SOUND['ENEMY_ALARM_CAT']
    self.sound_slap = SOUND['SLAP_CAT']

    self.jitter_intensity = 0
    self.collision_radius = 25
    self.current_bubble_radius = 30
    self.bubble_growth_speed = -0.1
    self.respawn_timer_seconds = 1 -- For the cat, this is used for the grace period of touching the cat again.

    -- Graphics
    self.static_image = gfx.image.new('images/animation_enemy_cat')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(66.66, gfx.imagetable.new('images/animation_enemy_cat-walk') , true) -- Ring

    -- Cat
    self.touches_register = true
    self.min_bubble_radius = 30 -- Since the cat's bubble radius is always decreasing, we want to clamp it to a minimum. This is also important for visuals, otherwise we can't see the cat so well.
end

function Cat:on_hit_by_player()
    if self.touches_register == false then
        return
    end
    self.sound_slap:play()

    local growth_speed_bkp = self.bubble_growth_speed
    self.bubble_growth_speed = 5
    playdate.timer.new(100, function()
        self.bubble_growth_speed = growth_speed_bkp
    end)

    -- Allow a grace period for touching the cat, so it's notice being slapped every frame.
    self.touches_register = false
    playdate.timer.new(self.respawn_timer_seconds*1000, function()
        self.touches_register = true
    end)

    -- Make the cat jitter to tell the player they did something bad.
    self.jitter_intensity = 1
    playdate.timer.new(400, function()
        self.jitter_intensity = 0
    end)
end

function Cat:update_logic()
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:on_hit()
        CONTEXT.awakeness = 1
    end

    self.current_bubble_radius += self.bubble_growth_speed
    self.current_bubble_radius = math.max(self.min_bubble_radius, self.current_bubble_radius)

    Cat.super.update_logic(self, CONTEXT)
end
