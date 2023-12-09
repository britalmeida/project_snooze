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

    -- Graphics
    self.static_image = nil
    self.anim_default = nil
    self.death_image = nil
    self:addSprite()
    self:setVisible(true)

    -- Spawn location
    self:set_spawn_location()
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

function Enemy:circleCollision(x, y, radius)
    return math.sqrt((self.x - x)^2 + (self.y - y)^2) < radius
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
    local repeats = 0
    repeat
        -- Pick an angle.
        local angle = math.random(360)
        local radius = math.random(70, ARM_LENGTH_MAX)

        local x = 200 + radius * math.cos(math.rad(angle))
        local y = 120 + radius * math.sin(math.rad(angle))

        self:moveTo(x, y)
        repeats += 1
    until (
        (self:is_near_player_face(30 + self.current_bubble_radius) == false) and 
        (self:is_out_of_reach() == false) or
        (repeats > 10)
    )
    print("Spawned after " .. repeats .. " repeats.")
    self:clampPosition(20, 20, 380, 120)
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
    if self.death_image then
        self.death_image:setInverted(true)
        self:setImage(self.death_image)
    end
    self:on_hit()
end

function Enemy:hit_the_player()
    CONTEXT.awakeness_rate_of_change = 0.035
    -- Start a timer to respawn this enemy.
    playdate.timer.new(200, function()
        CONTEXT.awakeness_rate_of_change = AWAKENESS_DECAY
    end)
    self:on_hit()
end

function Enemy:on_hit()
    -- Should be called whenever player hits enemy or enemy hits player.
    if self.sound_loop then
        self.sound_loop:stop()
    end

    local death_anim_timer = 0
    if self.death_image then
        death_anim_timer = 1000
    end

    playdate.timer.new(death_anim_timer, function()
        self:setVisible(false)
    end)

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

function Enemy:update_logic(CONTEXT)
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
    local mirror = 1
    if self.x > 200 then
        mirror = -1
    end
    if self.anim_default then
        self:setImage(self.anim_default:image():scaledImage(mirror,1))
    end
end
