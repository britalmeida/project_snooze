local still_img = gfx.image.new('images/animation_enemy_cat')
local anim_walk_imgs = gfx.imagetable.new('images/animation_enemy_cat-walk')
local anim_walk_framerate = 2
local anim_meow_imgs = gfx.imagetable.new('images/animation_enemy_cat-meow')
local anim_meow_framerate = 6.5
local anim_sit_imgs = gfx.imagetable.new('images/animation_enemy_cat-sit')
local anim_sit_framerate = 3

class('Cat').extends(Enemy)

function Cat:init()
    Cat.super.init(self)

    -- Threat
    self.collision_radius = 5
    self.current_bubble_radius = 30
    self.bubble_growth_speed = 0.0

    -- Score
    self.score_decay = 0

    -- Movement
    self.jitter_intensity = 0
    self.movement_speed = 1

    -- Sound
    self.name = 'cat'
    self.sound_loop = nil --SOUND['ENEMY_CAT']
    self.sound_slap = SOUND['SLAP_CAT']
    self.sound_meow = SOUND['ENEMY_CAT_MEOW']

    -- Graphics
    self.anim_walk = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self.anim_sitting = gfx.animation.loop.new(anim_sit_framerate * frame_ms, anim_sit_imgs, true)
    self.anim_meow = nil
    self.anim_current = nil -- Don't set this, because we don't want to use the drawing logic inherited from Enemy.
    self.anim_current_cat = anim_walk
    self:setSize(still_img:getSize())
    self:setVisible(false)

    -- Cat
    self.touch_bubble_growth_speed = -0.8
    self.no_touch_bubble_growth_speed = 0.3

end

Cat.draw = function(self, x, y, width, height)
    if CONTEXT.menu_screen == MENU_SCREEN.gameplay then
        local flip = playdate.graphics.kImageUnflipped
        if self.mirror == -1 then
            flip = playdate.graphics.kImageFlippedX
        end
        self.anim_current_cat:draw(0, 0, flip)
        if self.anim_meow then
            self.anim_meow:draw(0, 0, flip)
        end
    else
        still_img:draw(0,0)
    end
end

function Cat:set_spawn_location()
    local spawns_x = {-20, 420}
    local spawns_y = {200, 200}
    local rand = math.random(1, 2)
    self:moveTo(spawns_x[rand], spawns_y[rand])

    local target_x = {150, 240}
    local target_y = {150, 150}
    self.movement_target_x = target_x[rand]
    self.movement_target_y = target_y[rand]
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
    self.touch_bubble_growth_speed = 5
    playdate.timer.new(400, function()
        self.jitter_intensity = 0
        self.touch_bubble_growth_speed = touch_growth_speed_bkp
        self.bubble_growth_speed = bubble_growth_speed_bkp
    end)
end

function Cat:tick(CONTEXT)
    if self:distanceTo(self.movement_target_x, self.movement_target_y) > 5 then
        -- While moving towards target location
        self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
        self.anim_current_cat = self.anim_walk
        self.bubble_growth_speed = 0.0
    elseif self:is_touched_by_any_hand(CONTEXT) then
        -- While being petted
        if not self.sound_meow:isPlaying() then
            -- self.sound_loop:stop()
            self.sound_meow:play()
            self.anim_meow = gfx.animation.loop.new(anim_meow_framerate * frame_ms, anim_meow_imgs, false)
        end

        self.bubble_growth_speed = self.touch_bubble_growth_speed
        if self.current_bubble_radius < 0 then
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

    Cat.super.tick(self, CONTEXT)
end
