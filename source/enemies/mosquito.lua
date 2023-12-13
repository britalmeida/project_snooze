import "enemy"

local anim_fly_imgs = gfx.imagetable.new('images/animation_mosquito-fly')
local anim_fly_framerate = 1

local img_dead_mosquito = gfx.image.new("images/animations_mosquito-dead")

class('Mosquito').extends(Enemy)

function Mosquito:init()
    Mosquito.super.init(self)
    self.name = 'mosquito'

    -- Threat
    self.collision_radius = 15
    self.jitter_intensity = 0.5
    self.current_bubble_radius = 20
    self.bubble_growth_speed = 0

    -- Movement
    self.movement_speed = 1.5
    self.current_score = 10
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y
    self.move_clockwise = (math.random(0, 1) - 0.5) * 2
    self.spiral_strength = 6
    self.towards_head_strength = 2

    -- Sound
    self.sound_loop = SOUND['ENEMY_MOSQUITO']
    self.sound_slap = SOUND['SLAP_MOSQUITO']

    -- Graphics
    self.anim_fly = gfx.animation.loop.new(anim_fly_framerate * frame_ms, anim_fly_imgs, true)
    self.anim_current = self.anim_fly
    self.img_death = img_dead_mosquito
    self.img_death:setInverted(true)
end

function Mosquito:behaviour_loop()
    -- Sometimes, change direction!
    self.move_clockwise = (math.random(0, 1) - 0.5) * 2
    -- Slow down direction towards the head, down to a minimum.
    self.towards_head_strength -= 0.5
    if self.towards_head_strength < 1 then
        self.towards_head_strength = 1
    end

    playdate.timer.new(1000, function()
        self:behaviour_loop()
    end)
end

function Mosquito:set_spawn_location()
    -- Spawn it somewhere slightly off-screen, left or right.
    local index = math.random(1, 2)
    local x = {-20, 420}
    local y = math.random(240)
    self:moveTo(x[index], y)
end

function Mosquito:tick(CONTEXT)
    Mosquito.super.tick(self, CONTEXT)

    if not self.is_alive then
        return
    end

    local distance = self:distanceTo(HEAD_X, HEAD_Y) - self.towards_head_strength
    local angle = self:angleTo(HEAD_X, HEAD_Y) + self.spiral_strength * self.move_clockwise

    self.movement_target_x = HEAD_X + (distance * math.cos(angle))
    self.movement_target_y = HEAD_Y + (distance * math.sin(angle))
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
    
    self.mirror = gfx.kImageUnflipped
    if self.x > 200 then
        self.mirror = gfx.kImageFlippedX
    end
end
