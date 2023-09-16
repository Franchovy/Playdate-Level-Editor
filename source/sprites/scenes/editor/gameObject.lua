import "playdate"
import "grid"

class("GameObject").extends(sprite)

function GameObject.new(itemConfig)
	return GameObject(itemConfig)
end

function GameObject:init(itemConfig)
	GameObject.super.init(self)
	
	local gridSize = grid.getSize()
	local image = graphics.image.new(gridSize, gridSize)
	
	graphics.pushContext(image)
	graphics.fillRect(2, 2, gridSize-4, gridSize-4)
	graphics.popContext()
	
	self:setImage(image)
	
	-- Set properties
	
	self.id = itemConfig.id
	self.config = itemConfig.config
	self.size = itemConfig.size
	
	self:moveTo(grid.makeGridPosition(itemConfig.position.x, itemConfig.position.y))
	self:setImageToAsset(itemConfig.assetName)
end

function GameObject:setImageToAsset(assetPath)
	-- TODO: Set file in data folder to asset
end