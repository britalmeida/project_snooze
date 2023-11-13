import "alarm_analog"

local still_img = gfx.image.new('images/animation_alarm2')
local anim_walk_imgs = gfx.imagetable.new('images/animation_alarm2-move')
local anim_walk_framerate = 15

class('AlarmDigital').extends(AlarmAnalog)

function AlarmDigital:init()
    AlarmDigital.super.init(self)

    self.name = 'alarm_digital'
    self.sound_loop = SOUND['ENEMY_ALARM_DIGITAL']
    self.sound_slap = SOUND['SLAP_ALARM']

    self.bubble_growth_speed = 0
    self.current_bubble_radius = 20

    self.jitter_intensity = 0

    -- Graphics
    self.static_image = still_img
    self.anim_default = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self:setImage(self.static_image)
end

function AlarmDigital:start()
    self.current_bubble_radius = 20 -- TODO Fix the inheritance here. This is otherwise getting incorrectly reset by AlarmAnalog:on_hit()
    AlarmDigital.super.start(self)
    -- Spawn it somewhere slightly off-screen
    local index = math.random(1, 2)
    local x = {-20, 420}
    local y = math.random(240)
    self:moveTo(x[index], y)
end

function AlarmDigital:update_logic()
    AlarmDigital.super.update_logic(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end
