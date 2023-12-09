import "enemy"

local anim_walk_imgs = gfx.imagetable.new('images/animation_mosquito-fly')
local anim_walk_framerate = 1

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
    self.static_image = anim_walk_imgs:getImage(1)
    self.anim_default = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self.death_image = gfx.image.new("images/animations_mosquito-dead")
    self:setImage(self.static_image)
end

function Mosquito:start()
    Mosquito.super.start(self)
    -- Spawn it somewhere slightly off-screen, left or right.
    local index = math.random(1, 2)
    local x = {-20, 420}
    local y = math.random(240)
    self:moveTo(x[index], y)
end

function Mosquito:on_hit_by_player()
    Mosquito.super.on_hit_by_player(self)
    CONTEXT.enemies_snoozed += 1
    self:on_hit()
end

function Mosquito:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.collision_radius) then
        self:hit_the_player()
        return
    end
    Mosquito.super.update_logic(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end
