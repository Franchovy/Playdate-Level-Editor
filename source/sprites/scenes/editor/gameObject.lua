import "playdate"
import "grid"

class("GameObject").extends(sprite)

function GameObject.new(config)
	return GameObject(config)
end

function GameObject:init(config)
	GameObject.super.init(self)
	
	local gridSize = grid.getSize()
	local image = graphics.image.new(gridSize, gridSize)
	
	graphics.pushContext(image)
	graphics.fillRect(2, 2, gridSize-4, gridSize-4)
	graphics.popContext()
	
	self:setImage(image)
	
	-- Set properties
	
	self.id = config.id
	self.config = config.config
	self.assetName = config.assetName
	self.size = config.size
	
	self:moveTo(grid.makeGridPosition(config.position.x, config.position.y))
end