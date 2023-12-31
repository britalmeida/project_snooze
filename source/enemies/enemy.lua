gfx = playdate.graphics
local Sprite = gfx.sprite

class('Enemy').extends(Sprite)

function Enemy:init()
    Enemy.super.init(self)
    self.name = "enemy"

    -- Threat
    self.collision_radius = 15
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3
    
    -- Score
    self.score_decay = 0.05
    self.current_score = 10

    -- Movement
    self.jitter_intensity = 1
    self.movement_speed = 0.3
    self.movement_target_x = HEAD_X
    self.movement_target_y = HEAD_Y

    -- Life cycle
    self.is_alive = true
    self.respawn_timer_seconds = 8

    -- Sound
    self.sound_loop = nil
    self.sound_slap = nil

    -- Spawn location
    self:set_spawn_location()

    -- Graphics
    self.anim_current = nil
    self.anim_death = nil
    self.img_death = nil        -- Optional. If provided, drawn for 1 second before despawning.
    self.img_table_death = nil  -- Optional. If provided, drawn for 1 second before despawning.
    self:addSprite()
    self:setVisible(true)

    -- Flip the sprite. Different enemy types may need to be flipped in different cases.
    self.mirror = gfx.kImageUnflipped
    if self.x > 200 then
        self.mirror = gfx.kImageFlippedX
    end
end

function Enemy:start()
    -- Function to re-initialize an enemy.
    -- Important to keep this separate from init(), so subclasses can define things in their own init, 
    -- such as self.sound_loop, which can be accessed here.
    self:init()
    self:setVisible(true)

    if self.sound_loop then 
        self.sound_loop:play(0)
    end

    -- Behaviour
    self:behaviour_loop()
end

function Enemy:behaviour_loop()
    -- Subclasses can put stuff here to change behaviour properties with timers.
end

function Enemy:jitter()
    self:moveTo(self.x + math.random(-1, 1) * self.jitter_intensity, self.y + math.random(-1, 1) * self.jitter_intensity)
end

function Enemy:moveTowardsTarget(x, y, speed)
    local directionX = x - self.x
    local directionY = y - self.y

    -- Calculate the distance between self and target
    local distance = math.sqrt(directionX^2 + directionY^2)

    -- Normalize the direction vector
    directionX = directionX / distance
    directionY = directionY / distance

    -- Update the Enemy's position based on the direction and speed
    self.x = self.x + directionX * speed
    self.y = self.y + directionY * speed

    self:moveTo(self.x + directionX * speed, self.y + directionY * speed)
end

local function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

function Enemy:distanceTo(x, y)
    return math.sqrt((self.x - x)^2 + (self.y - y)^2)
end

function Enemy:squareDistanceTo(x, y)
    return (self.x - x)^2 + (self.y - y)^2
end

function Enemy:angleTo(x, y)
    return math.atan2(self.y - y, self.x - x)
end

function Enemy:circleCollision(x, y, radius)
    return self:squareDistanceTo(x, y) < radius^2
end

function Enemy:is_out_of_reach()
    for _, arm in ipairs(CONTEXT.player_arms) do
        if self:circleCollision(arm.line_segment.x, arm.line_segment.y, ARM_LENGTH_MAX) == false then
            return true
        end
    end
    return false
end

-- <>
function Enemy:is_on_character_hitzone()
    -- Pass quick gross AABB test before more precise tests.
    if self:is_on_character_AABB() then
        -- Pass more precise collision volumes around the chest, neck and head.
        if (self:circleCollision(206,  78, 15 + self.current_bubble_radius) or
            self:circleCollision(206,  98,  8 + self.current_bubble_radius) or
            self:circleCollision(201, 116, 12 + self.current_bubble_radius) or
            self:circleCollision(197, 134, 10 + self.current_bubble_radius)
        ) then
            return true
        end
    end

    return false
end

function Enemy:is_on_character_AABB()
    local character_AABB_x1 = 186
    local character_AABB_x2 = 220
    local character_AABB_y1 =  62
    local character_AABB_y2 = 143
    if (self.x + self.current_bubble_radius > character_AABB_x1 and
        self.x - self.current_bubble_radius < character_AABB_x2 and
        self.y + self.current_bubble_radius > character_AABB_y1 and
        self.y - self.current_bubble_radius < character_AABB_y2) then
        return true
    end

    return false
end

function Enemy:is_roughly_on_character(tolerance)
    if (self:circleCollision(205,  77, 29 + tolerance) or
        self:circleCollision(201, 117, 32 + tolerance) or
        self:circleCollision(197, 137, 29 + tolerance) or
        self:circleCollision(192, 170, 28 + tolerance)
    ) then
        return true
    end
end


function Enemy:is_near_another_enemy()
    for _, enemy in ipairs(ENEMIES) do
        if enemy ~= self and self:circleCollision(enemy.x, enemy.y, 25) then
            return true
        end
    end
    return false
end

function Enemy:set_spawn_location()
    -- Pick an angle.
    local angle = math.random(360)
    -- Pick a radius near max arm length
    local radius = math.random(ARM_LENGTH_MAX-30, ARM_LENGTH_MAX)

    -- Pick cartesian coordinates in a donut area centered on the character.
    local x = 200 + (radius * math.cos(math.rad(angle)))
    local y = 120 + (radius * math.sin(math.rad(angle)))

    -- Bring closer positions spawned offscreen at top and bottom due to non circular screen aspect ratio.
    self:moveTo(x, clamp(y, 20, 280))
end

function Enemy:is_near_player_face(threshold)
    return self:circleCollision(HEAD_X, HEAD_Y, threshold)
end


function Enemy:on_hit_by_player()
    if self.is_alive then
        -- Stop updating this enemy.
        self.is_alive = false

        -- SFX
        if self.sound_loop then
            self.sound_loop:stop()
        end
        if self.sound_slap then
            self.sound_slap:play()
        end

        -- Increase score.
        CONTEXT.score += self.current_score

        self.current_bubble_radius = 0
        self:play_death_animation()
    end
end


function Enemy:play_death_animation()
    local death_linger_time = 0
    if self.img_table_death then
        death_linger_time = 1000
        self.anim_death = gfx.animation.loop.new(3 * frame_ms, self.img_table_death, false)
        self.anim_current = self.anim_death
    elseif self.img_death then
        death_linger_time = 1000
        self.anim_current = nil
        self:setImage(self.img_death)
    end

    playdate.timer.new(death_linger_time, function()
        self:despawn_then_respawn()
    end)
end


function Enemy:hit_the_player()
    --print("Hit by", self.name)

    -- Stop updating this enemy.
    self.is_alive = false

    -- SFX
    if self.sound_loop then
        self.sound_loop:stop()
    end
    SOUND['ENEMY_POP']:play()
    table.insert(BUBBLE_POPS, {
        x=self.x, y=self.y,
        radius=self.current_bubble_radius,
        -- Animation for the bubble pop. Keep duration the same.
        timer_r=playdate.timer.new(300, 0, 1, playdate.easingFunctions.inCirc), -- radius expansion
        timer_w=playdate.timer.new(300, 0, 1, playdate.easingFunctions.inBack)  -- thickness reduction
    })
    self.current_bubble_radius = 0

    -- Decrease player health.
    CONTEXT.awakeness_hits += 0.15

    -- Start a timer to respawn this enemy.
    self:despawn_then_respawn()
end

function Enemy:despawn_then_respawn()
    -- Should be called whenever player hits enemy or enemy hits player.

    self:setVisible(false)

    -- Start a timer to respawn this enemy.
    playdate.timer.new(self.respawn_timer_seconds*1000, function()
        self:start()
    end)
end

function Enemy:is_touched_by_hand(hand)
    return self:circleCollision(hand.x, hand.y, HAND_TOUCH_RADIUS + self.collision_radius)
end

function Enemy:is_touched_by_any_hand(CONTEXT)
    for _, arm in ipairs(CONTEXT.player_arms) do
        if self:circleCollision(arm.hand.x, arm.hand.y, HAND_TOUCH_RADIUS + self.collision_radius) then
            return true
        end
    end
    return false
end

function Enemy:tick(CONTEXT)
    -- This is only called when self:isVisible == true !!!

    -- Set the image frame to display.
    if self.anim_current then
        self:setImage(self.anim_current:image(), self.mirror)
    end

    if not self.is_alive then
        return
    end

    for _, arm in ipairs(CONTEXT.player_arms) do
        if arm.slapping and self:is_touched_by_hand(arm.hand) then
            self:on_hit_by_player()
            return
        end
    end

    if self:is_on_character_hitzone() then
        self:hit_the_player()
        return
    end

    -- Enemies give less score over timer, but always at least 1 point.
    self.current_score = math.max(1, self.current_score - self.score_decay)
    -- Increase threat.
    self.current_bubble_radius += self.bubble_growth_speed

    self:jitter()
end
