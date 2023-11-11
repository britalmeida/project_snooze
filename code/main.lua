import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local resX, resY = 400, 240

local handX, handY = resX/2, resY/2
local handRadius = 100

local image = gfx.image.new("assets/images/hand")
local sprite = gfx.sprite.new()
sprite:setImage(image)
sprite:moveTo(handX, handY)
sprite:add()

function pd.main()
end

function playdate.update()
	gfx.clear()
	local crankAngle = math.rad(pd.getCrankPosition())
	-- Redraw all sprites.
	sprite:setCenter(0.5, 0.8)
	sprite:setRotation(crankAngle*(180/math.pi))
	gfx.sprite.update()
	gfx.drawText("Amount: " .. 15, 5, 5)
end
