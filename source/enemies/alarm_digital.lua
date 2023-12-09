import "enemy"

local anim_walk_imgs = gfx.imagetable.new('images/animation_alarm2-move')
local anim_walk_framerate = 15

class('AlarmDigital').extends(Enemy)

function AlarmDigital:init()
    AlarmDigital.super.init(self)

    self.name = 'alarm_digital'
    self.sound_loop = SOUND['ENEMY_ALARM_DIGITAL']
    self.sound_slap = SOUND['SLAP_ALARM']

    self.bubble_growth_speed = 0
    self.current_bubble_radius = 20

    self.jitter_intensity = 0

    -- Graphics
    self.anim_ringing = gfx.animation.loop.new(anim_walk_framerate * frame_ms, anim_walk_imgs, true)
    self.anim_current = self.anim_ringing

    self.mirror = 1
    if self.x > 200 and self.y > 100 then
        self.mirror = -1
    elseif self.x < 200 and self.y < 100 then 
        self.mirror = -1
    end
end

function AlarmDigital:set_spawn_location()
    -- Spawn it in one of the 4 corners. 
    -- Otherwise the animation doesn't fit well with the movement.
    local index_x = math.random(1, 2)
    local index_y = math.random(1, 2)
    local x = {-20, 420}
    local y = {-20, 220}
    self:moveTo(x[index_x], y[index_y])
end

function AlarmDigital:tick()
    AlarmDigital.super.tick(self, CONTEXT)
    self:moveTowardsTarget(self.movement_target_x, self.movement_target_y, self.movement_speed)
end
