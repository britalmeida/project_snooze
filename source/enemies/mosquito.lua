import "enemy"

local anim_fly_imgs = gfx.imagetable.new('images/animation_mosquito-fly')
local anim_fly_framerate = 1

local img_dead_mosquito = gfx.image.new("images/animations_mosquito-dead")

class('Mosquito').extends(Enemy)

function Mosquito:init()
    Mosquito.super.init(self)
    self.name = 'mosquito'
    self.collision_radius = 15
    self.jitter_intensity = 1

    self.current_bubble_radius = 15
    self.bubble_growth_speed = 0
    self.movement_speed = 0.6
    self.initial_score = 20

    -- Sound
    self.sound_loop = SOUND['ENEMY_MOSQUITO']
    self.sound_slap = SOUND['SLAP_MOSQUITO']

    -- Graphics
    self.anim_fly = gfx.animation.loop.new(anim_fly_framerate * frame_ms, anim_fly_imgs, true)
    self.anim_current = self.anim_fly
    self.death_image = img_dead_mosquito
end

function Mosquito:set_spawn_location()
    -- Spawn it somewhere slightly off-screen, left or right.
    local index = math.random(1, 2)
    local x = {-20, 420}
    local y = math.random(240)
    self:moveTo(x[index], y)
end

function Mosquito:tick(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.collision_radius) then
        self:hit_the_player()
        return
    end
    Mosquito.super.tick(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end
