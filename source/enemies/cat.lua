gfx = playdate.graphics

class('Cat').extends(Enemy)

function Cat:init()
    Cat.super.init(self)
    -- Sound
    self.name = 'cat'
    self.sound_loop = SOUND['ENEMY_CAT']
    self.sound_slap = SOUND['SLAP_CAT']
    self.collision_radius = 5

    -- Graphics
    self.static_image = gfx.image.new('images/animation_enemy_cat')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(66.66, gfx.imagetable.new('images/animation_enemy_cat-walk') , true) -- Ring

    -- Cat
    self.touch_bubble_growth_speed = -0.8
end

function Cat:start()
    self:setVisible(true)

    self.jitter_intensity = 0
    self.current_bubble_radius = 40
    self.bubble_growth_speed = 0.1
    self.respawn_timer_seconds = 1 -- For the cat, this is used for the grace period of touching the cat again.

    repeat
        -- Pick an arm
        arm = CONTEXT.player_arms[math.random(1, 2)]

        -- Pick an angle.
        local angle = math.random(arm.angle_min, arm.angle_max)
        local radius = ARM_LENGTH_DEFAULT

        local x = arm.line_segment.x + radius * math.cos(math.rad(angle))
        local y = arm.line_segment.y + radius * math.sin(math.rad(angle))

        self:moveTo(x, y)
    until (self:is_near_player_face(self.current_bubble_radius) == false) and (self.x > 230) or (self.x < 170)

    if self.sound_loop then 
        self.sound_loop:play(0)
    end

end

function Cat:on_hit_by_player()
    if self.jitter_intensity == 1 then
        return
    end
    self.sound_slap:play()
    -- Make the cat jitter to tell the player they did something bad.
    self.jitter_intensity = 1
    local bubble_growth_speed_bkp = self.bubble_growth_speed
    self.bubble_growth_speed = 5
    local touch_growth_speed_bkp = self.touch_bubble_growth_speed
    self.touch_bubble_growth_speed = 0
    playdate.timer.new(400, function()
        self.jitter_intensity = 0
        self.touch_bubble_growth_speed = touch_growth_speed_bkp
        self.bubble_growth_speed = bubble_growth_speed_bkp
    end)
end

function Cat:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:on_hit()
        CONTEXT.awakeness += 0.2
    end

    if self:is_touched_by_any_hand(CONTEXT) then
        self.current_bubble_radius += self.touch_bubble_growth_speed
        if self.current_bubble_radius < 0 then
            self:on_hit()
        end
    else
        self.current_bubble_radius += self.bubble_growth_speed
    end

    Cat.super.update_logic(self, CONTEXT)
end
