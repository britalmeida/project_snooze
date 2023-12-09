local still_img = gfx.image.new('images/animation_enemy_cat')
local anim_walk_imgs = gfx.imagetable.new('images/animation_enemy_cat-walk')
local anim_walk_framerate = 2
local anim_meow_imgs = gfx.imagetable.new('images/animation_enemy_cat-meow')
local anim_meow_framerate = 6.5

class('Cat').extends(Enemy)

function Cat:init()
    Cat.super.init(self)

    -- Threat
    self.collision_radius = 5
    self.current_bubble_radius = 40
    self.bubble_growth_speed = 0.1

    -- Score
    self.score_decay = 0

    -- Movement
    self.jitter_intensity = 0

    -- Sound
    self.name = 'cat'
    self.sound_loop = SOUND['ENEMY_CAT']
    self.sound_slap = SOUND['SLAP_CAT']
    self.sound_meow = SOUND['ENEMY_CAT_MEOW']

    -- Graphics
    self.static_image = still_img
    self.anim_walk = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self.anim_meow = nil
    self.anim_default = anim_walk
    self:setSize(still_img:getSize())

    -- Cat
    self.touch_bubble_growth_speed = -0.8
end

function Cat:set_spawn_location()
    repeat
        -- Pick an arm
        arm = CONTEXT.player_arms[math.random(1, 2)]
        -- Pick an angle.
        local angle = math.random(arm.angle_min, arm.angle_max)
        local radius = ARM_LENGTH_DEFAULT

        local x = arm.line_segment.x + radius * math.cos(math.rad(angle))
        local y = arm.line_segment.y + radius * math.sin(math.rad(angle))

        self:moveTo(x, y)
    until (self:is_near_player_face(50+self.current_bubble_radius) == false) and (self.x > 230) or (self.x < 170)
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

Cat.draw = function(self, x, y, width, height)
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        self.anim_walk:draw(0, 0)
        if self.anim_meow then
            self.anim_meow:draw(0, 0)
        end
    else
        still_img:draw(0,0)
    end
end

function Cat:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:hit_the_player()
    end

    if self:is_touched_by_any_hand(CONTEXT) then
        if not self.sound_meow:isPlaying() then
            self.sound_loop:stop()
            self.sound_meow:play()
            self.anim_meow = gfx.animation.loop.new(anim_meow_framerate * frame_ms, anim_meow_imgs, true)
        end

        self.current_bubble_radius += self.touch_bubble_growth_speed
        if self.current_bubble_radius < 0 then
            CONTEXT.score += self.current_score
            self:on_hit()
        end
    else
        self.current_bubble_radius += self.bubble_growth_speed
    end

    Cat.super.update_logic(self, CONTEXT)
end
