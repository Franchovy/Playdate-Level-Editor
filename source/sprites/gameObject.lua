import "playdate"
import "grid"

class("GameObject").extends(sprite)

function GameObject.new()
	return GameObject()
end

function GameObject:init()
	GameObject.super.init(self)
	
	local image = graphics.image.new(gridSize, gridSize)
	
	graphics.pushContext(image)
	graphics.fillRect(2, 2, gridSize-4, gridSize-4)
	graphics.popContext()
	
	self:setImage(image)
end