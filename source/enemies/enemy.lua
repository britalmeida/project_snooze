gfx = playdate.graphics
local Sprite = gfx.sprite

class('Enemy').extends(Sprite)

function Enemy:init()
    -- Function to initialize OR re-initialize an enemy.
    Enemy.super.init(self)

    -- Threat
    self.collision_radius = 15
    self.current_bubble_radius = 0.0
    self.bubble_growth_speed = 0.3
    
    -- Score
    self.initial_score = 10
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
    if self.sound_loop then 
        self.sound_loop:play(0)
    end

    -- Spawn location
    self:set_spawn_location()

    -- Graphics
    self.anim_current = nil
    self.death_image = nil      -- Optional. If provided, drawn for 1 second before despawning.
    self:addSprite()
    self:setVisible(true)
    self.mirror = 1
    if self.x > 200 then
        self.mirror = -1
    end
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

function Enemy:clampPosition(min_x, min_y, max_x, max_y)
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

function Enemy:distanceTo(x, y)
    return math.sqrt((self.x - x)^2 + (self.y - y)^2)
end

function Enemy:angleTo(x, y)
    return math.atan2(self.y - y, self.x - x)
end

function Enemy:circleCollision(x, y, radius)
    return self:distanceTo(x, y) < radius
end

function Enemy:is_out_of_reach()
    for _, arm in ipairs(CONTEXT.player_arms) do
        if self:circleCollision(arm.line_segment.x, arm.line_segment.y, ARM_LENGTH_MAX) == false then
            return true
        end
    end
    return false
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
    local radius = math.random(100, ARM_LENGTH_MAX)

    local x = 200 + (radius * math.cos(math.rad(angle)))
    local y = 120 + (radius * math.sin(math.rad(angle)))

    self:moveTo(x, y)
    self:clampPosition(20, 20, 380, 220)
end

function Enemy:is_near_player_face(threshold)
    return self:circleCollision(HEAD_X, HEAD_Y, threshold)
end

function Enemy:on_hit_by_player()
    if self.sound_slap then
        self.sound_slap:play()
    end
    CONTEXT.score += self.current_score

    self.is_alive = false
    self.current_bubble_radius = 0

    local death_linger_time = 0
    if self.death_image then
        death_linger_time = 1000
        self.death_image:setInverted(true)
        self:setImage(self.death_image)
    end

    playdate.timer.new(death_linger_time, function()
        self:despawn_then_respawn()
    end)
end

function Enemy:hit_the_player()
    CONTEXT.awakeness_rate_of_change = 0.035
    -- Start a timer to respawn this enemy.
    playdate.timer.new(200, function()
        CONTEXT.awakeness_rate_of_change = AWAKENESS_DECAY
    end)
    self:despawn_then_respawn()
end

function Enemy:despawn_then_respawn()
    -- Should be called whenever player hits enemy or enemy hits player.
    if self.sound_loop then
        self.sound_loop:stop()
    end

    self:setVisible(false)

    -- Start a timer to respawn this enemy.
    playdate.timer.new(self.respawn_timer_seconds*1000, function()
        self:init()
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
    for _, arm in ipairs(CONTEXT.player_arms) do
        if arm.slapping and self:is_touched_by_hand(arm.hand) then
            self:on_hit_by_player()
            return
        end
    end
    self.current_score = math.max(1, self.current_score - self.score_decay)
    self:jitter()
    self:clampPosition(0, 0, 400, 240)

    -- Set the image frame to display.
    -- e.g. if chill then self:setImage(img), otherwise walk or ring.
    -- Make the enemies face the player depending if they're on the left or right side of the screen.

    if self.anim_current then
        self:setImage(self.anim_current:image():scaledImage(self.mirror,1))
    end
end
