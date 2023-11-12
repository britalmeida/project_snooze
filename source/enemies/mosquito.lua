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

    img = gfx.image.new('images/animation_alarm1')
    self:setImage(img)

    -- Mosquito specific variables
    self.movement_speed = 0.0
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y
end

function Mosquito:update_logic(CONTEXT)
    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.collision_radius) then
        self:on_hit()
        CONTEXT.awakeness = 1
    end
    Mosquito.super.update_logic(self, CONTEXT)
end
