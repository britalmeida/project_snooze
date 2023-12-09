
gfx = playdate.graphics
gfxi = playdate.graphics.image
local head_asleep = gfxi.new("images/animation_hero-asleep")
local head_awake = gfxi.new("images/animation_hero-awake")

local head_snore_imgs = gfx.imagetable.new('images/animation_hero-snore')
local head_snore_num_imgs = head_snore_imgs:getLength()
local head_snore_timings = { 4, 9, 14, 19, 24, 39, 46, 49, 53, 60 }
local head_snore_framelength = 61

class('Head').extends(gfx.sprite)

function Head:init()
    -- Function to initialize character's head - once on load.

    Head.super.init(self)

    self:setSize(head_asleep:getSize())
    self:setCenter(0, 0)
    self:moveTo(178, 48)
    self:setZIndex(-20)
    self:setIgnoresDrawOffset(true)
    self:setUpdatesEnabled(false)

    -- Graphics
    self:addSprite()
    self:setVisible(true)

    self:reset()
end


function Head:reset()
    -- (Re)-start the read state
    self.anim_snore = gfx.animation.loop.new(6 * frame_ms, head_snore_imgs, true)
    self.frame_count = 0
    self.anim_frame = 0
end


Head.draw = function(self, x, y, width, height)
    if CONTEXT.awakeness >= 0.97 then
        -- Draw awake face.
        head_awake:draw(0, 0)
    else
        -- Draw snoring.
        head_snore_imgs:drawImage(self.anim_frame + 1, 0, 0)

        -- Update the animation frame we should be in.
        if self.frame_count == head_snore_timings[self.anim_frame + 1] then
            self.anim_frame = (self.anim_frame + 1) % head_snore_num_imgs
        end
        self.frame_count = (self.frame_count + 1) % head_snore_framelength
    end
end
