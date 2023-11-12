import "gameplay" -- Needed to access HEAD_X/Y in the constructor.
import "enemy"

gfx = playdate.graphics

class('Mosquito').extends(Enemy)

function Mosquito:init()
    Mosquito.super.init(self, 'mosquito')

    self.collision_radius = 15
    self.jitter_intensity = 1

    self.current_bubble_radius = 15
    self.bubble_growth_speed = 0

    img = gfx.image.new('images/animation_mosquito-fly-table-1')
    self:setImage(img)

    -- Mosquito specific variables
    self.movement_speed = 0.3
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y

    self.anim_fly = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_mosquito-fly') , true) -- Ring
end

function Mosquito:on_hit_by_player()
    Mosquito.super.on_hit_by_player(self)
    SOUND.SLAP_MOSQUITO:play()
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

    -- Set the image frame to display.
    -- e.g. if chill then self:setImage(img), otherwise walk or ring.
    self:setImage(self.anim_fly:image())
end
