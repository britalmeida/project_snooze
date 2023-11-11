gfx = playdate.graphics
local Sprite = gfx.sprite

class('Alarm').extends(Sprite)

function Alarm:init()
    Alarm.super.init(self)

    self.current_bubble_radius = 0.0

    clock_image = gfx.image.new('images/clock')
    clock_image:setMaskImage(gfx.image.new('images/clock_mask'))
    self:setImage(clock_image)
    self:addSprite()
end

function Alarm:jitter()
    self:moveTo(self.x + math.random(-1, 1), self.y + math.random(-1, 1))
end

function Alarm:clampPosition(min_x, min_y, max_x, max_y)
    if self.x < min_x then
        self.x = min_x
    elseif self.x > max_x then
        self.x = max_x
    end

    if self.y < min_y then
        self.y = min_y
    elseif self.y > max_y then
        self.y = max_y
    end
end

function Alarm:isTouched(CONTEXT)
    -- Detect contact between alarm clock and the active hand.
    return math.abs(CONTEXT.active_hand.x - self.x) < touch_radius and math.abs(CONTEXT.active_hand.y - self.y) < touch_radius
end

function Alarm:start()
    sprite_alarm:moveTo(math.random(50, 350), math.random(50, 190))
    sprite_alarm:setVisible(true)
    SOUND.ALARM6:play(0)
end

function Alarm:reset()
    self.current_bubble_radius = 0.0
    self:setScale(1.0)
    self:setVisible(false)
    SOUND.ALARM6:pause()
    if SOUND.ALARM6:isPlaying() then
        SOUND.SLAP_ALARM:play()
    end
end

function Alarm:update_logic(CONTEXT)
    curr_scale = self:getScale()
    if curr_scale == 1.0 and self:isTouched(CONTEXT) then
        self:setScale(1.5)
    elseif curr_scale == 1.5 then
        self:setScale(1.8)
    elseif curr_scale == 1.8 then
        self:setScale(2.0)
    elseif curr_scale == 2.0 then
        self:setScale(2.1)
    elseif curr_scale == 2.1 then
        self:reset()
        return
    end

    self:jitter()
    self:clampPosition(50, 50, 350, 190)

    self.current_bubble_radius += 0.1
end
