import "enemy" -- Needed to access HEAD_X/Y in the constructor.

gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Enemy)

function Alarm:init(sound_name)
    Alarm.super.init(self, sound_name)

    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3
    self.sound = SOUND[string.upper(sound_name)]
    self.collision_radius = 15
    self.jitter_intensity = 1

    img = gfx.image.new('images/animation_alarm1')
    self:setImage(img)
    self:addSprite()
    self:setVisible(false)
end

function Alarm:reset()
    Alarm.super.reset(self)
    self.current_bubble_radius = 0.0
end

function Alarm:snooze()
    self.sound:stop()
    SOUND.SLAP_ALARM:play()
    CONTEXT.enemies_snoozed += 1
    self:reset()
end

function Alarm:update_logic(CONTEXT)
    if self:isVisible() == false then
        return
    end
    hand = CONTEXT.player_hand_r
    if CONTEXT.is_left_arm_active then
        hand = CONTEXT.player_hand_l
    end
    if self:circleCollision(hand.x, hand.y, HAND_TOUCH_RADIUS + self.collision_radius) then
        self:snooze()
        return
    end

    if self:circleCollision(HEAD_X, HEAD_Y, HEAD_RADIUS + self.current_bubble_radius) then
        print("Alarm hit!")
        self:snooze()
        CONTEXT.awakeness = 1
    end

    self:jitter()
    self.current_bubble_radius += self.bubble_growth_speed

    Alarm.super.update_logic(self, CONTEXT)
end
