import "gameplay" -- Needed to access HEAD_X/Y in the constructor.
import "enemy"

gfx = playdate.graphics

class('Mosquito').extends(Enemy)

function Mosquito:init()
    Mosquito.super.init(self)
    self.collision_radius = 15
    self.jitter_intensity = 1

    self.current_bubble_radius = 15
    self.bubble_growth_speed = 0

    -- Sound
    self.sound_loop = SOUND['ENEMY_MOSQUITO']
    self.sound_slap = SOUND['SLAP_MOSQUITO']

    -- Graphics
    self.static_image = gfx.image.new('images/animation_mosquito-fly-table-1')
    self:setImage(self.static_image)
    self.anim_default = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_mosquito-fly') , true) -- Ring
end

function Mosquito:on_hit_by_player()
    Mosquito.super.on_hit_by_player(self)
    CONTEXT.enemies_snoozed += 1
    self:on_hit()
end

function Mosquito:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.collision_radius) then
        self:on_hit()
        CONTEXT.awakeness = 1
        return
    end
    Mosquito.super.update_logic(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end
