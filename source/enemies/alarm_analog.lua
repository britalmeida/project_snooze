import "enemy" -- Needed to access HEAD_X/Y in the constructor.

gfx = playdate.graphics

class('Alarm_Analog').extends(Enemy)

function Alarm_Analog:init(sound_name)
    Alarm_Analog.super.init(self, sound_name)

    self.sound = SOUND[string.upper(sound_name)]

    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3

    -- Load image visuals and animations
    img = gfx.image.new('images/animation_alarm1') -- Chill clock state
    anim_ring = gfx.animation.loop.new(33.33333333, gfx.imagetable.new('images/animation_alarm1-ring') , true) -- Ring
    self:setImage(img)
end

function Alarm_Analog:on_hit()
    -- Should be called whenever player hits enemy or enemy hits player
    SOUND.SLAP_ALARM:play()

    CONTEXT.enemies_snoozed += 1
    self.current_bubble_radius = 0.0

    Alarm_Analog.super.on_hit(self)
end

function Alarm_Analog:update_logic(CONTEXT)
    if self:isVisible() == false then
        return
    end
    hand = CONTEXT.player_hand_r
    if CONTEXT.is_left_arm_active then
        hand = CONTEXT.player_hand_l
    end
    if self:circleCollision(hand.x, hand.y, HAND_TOUCH_RADIUS + self.collision_radius) then
        self:on_hit()
        return
    end

    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        self:on_hit()
        CONTEXT.awakeness = 1
    end

    self.current_bubble_radius += self.bubble_growth_speed
    self:jitter()

    Alarm_Analog.super.update_logic(self, CONTEXT)
    -- Set the image frame to display.
    -- e.g. if chill then self:setImage(img), otherwise walk or ring.
    self:setImage(anim_ring:image())
end
