local anim_ring_imgs = gfx.imagetable.new('images/animation_alarm3-ring')
local anim_ring_framerate = 1

class('AlarmPhone').extends(Enemy)

function AlarmPhone:init()
    -- Phones spawn close to the player's face, but their bubble grows VERY slowly.
    -- They may look more threatening than they really are! Don't be distracted!
    AlarmPhone.super.init(self)

    -- Threat
    self.current_bubble_radius = 10
    self.bubble_growth_speed = 0.2

    -- Movement
    self.jitter_intensity = 0.2

    -- Sound
    self.name = 'alarm_phone'
    self.sound_loop = SOUND['ENEMY_ALARM_PHONE']
    self.sound_slap = SOUND['SLAP_ALARM']

    -- Graphics
    self.anim_ringing = gfx.animation.loop.new(anim_ring_framerate * frame_ms, anim_ring_imgs, true)
    self.anim_current = self.anim_ringing
end

function AlarmPhone:set_spawn_location()
    local repeats = 0
    repeat
        -- Pick an angle.
        local angle = math.random(360)
        local radius = math.random(ARM_LENGTH_MIN, ARM_LENGTH_DEFAULT)
        local arms_x = {ARM_R_X, ARM_L_X}
        local arms_y = {ARM_R_Y, ARM_R_Y}
        local arm_idx = math.random(1, 2)

        local x = arms_x[arm_idx] + radius * math.cos(math.rad(angle))
        local y = arms_y[arm_idx] + radius * math.sin(math.rad(angle))

        self:moveTo(x, y)
        repeats += 1
    until (
        (self:is_near_player_face(50 + self.current_bubble_radius) == false) and 
        (self:is_out_of_reach() == false) or
        (repeats > 10)
    )
    -- print("Spawned after " .. repeats .. " repeats.")
end