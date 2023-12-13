local still_img = gfx.image.new('images/animation_enemy_cat')

local anim_walk_imgs = gfx.imagetable.new('images/animation_enemy_cat-walk')
local anim_walk_framerate = 2

local anim_meow_imgs = gfx.imagetable.new('images/animation_enemy_cat-meow')
local anim_meow_num_imgs = anim_meow_imgs:getLength()
local anim_meow_timings = { 8, 11, 29, 35, 40, 44, 52, 55, 60 }
local anim_meow_framelength = 61

local anim_sit_imgs = gfx.imagetable.new('images/animation_enemy_cat-sit')
local anim_sit_framerate = 3

local anim_scream_imgs = gfx.imagetable.new('images/animation_enemy_cat-scream')
local anim_scream_framerate = 2

class('Cat').extends(Enemy)

function Cat:init()
    Cat.super.init(self)

    -- Threat
    self.collision_radius = 5
    self.current_bubble_radius = 30
    self.bubble_growth_speed = 0.0

    -- Score
    self.current_score = 20
    self.score_decay = 0

    -- Movement
    self.movement_speed = 1

    -- Sound
    self.name = 'cat'
    self.sound_loop = nil --SOUND['ENEMY_CAT']
    self.sound_slap = SOUND['SLAP_CAT']
    self.sound_meow = SOUND['ENEMY_CAT_MEOW']

    -- Graphics
    self.anim_walk = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self.anim_sitting = gfx.animation.loop.new(anim_sit_framerate * frame_ms, anim_sit_imgs, true)
    self.anim_scream = gfx.animation.loop.new(anim_scream_framerate * frame_ms, anim_scream_imgs, true)
    self.anim_current = nil -- Don't set this, because we don't want to use the drawing logic inherited from Enemy.
    self.anim_current_cat = anim_walk
    self.frame_count_facial = 0
    self.anim_frame_facial = 0

    self:setSize(still_img:getSize())
    self:setVisible(false)

    -- Cat
    self.touch_bubble_growth_speed = -0.8
    self.no_touch_bubble_growth_speed = 0.3

    -- State
    self.jitter_intensity = 0
    self.got_petted_already = false
    self.is_meowing = false

end

Cat.draw = function(self, x, y, width, height)
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        self.anim_current_cat:draw(0, 0, self.mirror)

        -- Overlay facial animation.
        if self.is_meowing then
            anim_meow_imgs:drawImage(self.anim_frame_facial + 1, 0, 0, self.mirror)

            -- Update the animation frame we should be in.
            if self.frame_count_facial == anim_meow_timings[self.anim_frame_facial + 1] then
                self.anim_frame_facial = (self.anim_frame_facial + 1) % anim_meow_num_imgs
            end
            self.frame_count_facial = self.frame_count_facial + 1
            -- Don't repeat.
            if  self.frame_count_facial >= anim_meow_framelength then
                self.is_meowing = false
                self.frame_count_facial = 0
                self.anim_frame_facial = 0
            end

        end


    else -- gameover
        still_img:draw(0,0, self.mirror)
    end
end

function Cat:set_spawn_location()
    local spawns_x = {-20, 420}
    local spawns_y = {200, 200}
    local rand = math.random(1, 2)
    self:moveTo(spawns_x[rand], spawns_y[rand])

    local target_x = {140, 245}
    local target_y = {152, 155}
    self.movement_target_x = target_x[rand]
    self.movement_target_y = target_y[rand]
end

function Cat:on_hit_by_player()
    if self.jitter_intensity == 1 then
        -- Already being punched.
        return
    end

    -- Make the cat jitter to tell the player they did something bad.
    self.jitter_intensity = 1

    -- FX
    self.sound_slap:play()
    self.anim_current_cat = self.anim_scream
    self.is_meowing = false
    if self.sound_meow:isPlaying() then
        self.sound_meow:stop()
    end

    self.bubble_growth_speed = 3

    playdate.timer.new(300, function()
        self.jitter_intensity = 0
        self.bubble_growth_speed = self.no_touch_bubble_growth_speed
    end)
end


function Cat:tick(CONTEXT)
    if self.jitter_intensity == 1 then
        -- If being punched

    else
        if self:distanceTo(self.movement_target_x, self.movement_target_y) > 5 then
            -- While moving towards target location
            self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)

            self.anim_current_cat = self.anim_walk
            self.bubble_growth_speed = 0.0

        elseif self.got_petted_already == false then

            if self:is_touched_by_any_hand(CONTEXT) then
                -- While being petted
                if not self.sound_meow:isPlaying() then
                    self.sound_meow:play()
                    self.is_meowing = true
                end

                self.anim_current_cat = self.anim_sitting
                self.bubble_growth_speed = self.touch_bubble_growth_speed

                -- Success! score the cat and make it go away.
                if self.current_bubble_radius < 0 then
                    self.got_petted_already = true
                    self.movement_target_x = 200
                    self.movement_target_y = 280
                    self.movement_speed = 2
                    CONTEXT.score += self.current_score
                    playdate.timer.new(2000, function()
                        self:despawn_then_respawn()
                    end)
                end
            else
                -- Waiting to be petted
                self.anim_current_cat = self.anim_sitting
                self.bubble_growth_speed = self.no_touch_bubble_growth_speed
            end
        end
    end

    Cat.super.tick(self, CONTEXT)
end
