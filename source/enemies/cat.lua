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
    self.bubble_growth_speed = 0.1
    self.respawn_timer_seconds = 1 -- For the cat, this is used for the grace period of touching the cat again.

    -- Graphics
    self.static_image = gfx.image.new('images/animation_enemy_cat')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(66.66, gfx.imagetable.new('images/animation_enemy_cat-walk') , true) -- Ring

    -- Cat
    self.touch_bubble_growth_speed = -0.8
end


function Cat:start()
    self:setVisible(true)
    -- Pick an angle.
    local angle = math.random() * 360

    -- Pick arms based on which side we're on.
    if angle <= 90 or angle >= 270 then
        arm = CONTEXT.player_arm_right.line_segment
    else
        arm = CONTEXT.player_arm_left.line_segment
    end

    local radius = ARM_LENGTH_DEFAULT + 20

    local x = arm.x + radius * math.cos(math.rad(angle))
    local y = arm.y + radius * math.sin(math.rad(angle))

    self:moveTo(x, y)

    if self.sound_loop then 
        self.sound_loop:play(0)
    end
end

function Cat:on_hit_by_player()
    self.sound_slap:play()
    -- Make the cat jitter to tell the player they did something bad.
    self.jitter_intensity = 1
    playdate.timer.new(400, function()
        self.jitter_intensity = 0
    end)
end

function Cat:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:on_hit()
        CONTEXT.awakeness = 1
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
