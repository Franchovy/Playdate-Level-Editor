import "playdate"
import "grid"

class("GameObject").extends(sprite)

function GameObject.new(game, itemConfig)
	return GameObject(game, itemConfig)
end

function GameObject:init(game, itemConfig)
	self.game = game
	GameObject.super.init(self)
	
	local gridSize = grid.getSize()
	
	-- Set properties
	
	self.id = itemConfig.id
	self.config = itemConfig.config
	self.size = itemConfig.size
	
	self:moveTo(grid.makeGridPosition(itemConfig.position.x, itemConfig.position.y))
	
	-- Set Image
	
	local assetImage = self:getImageAsset(itemConfig.assetName)
	if assetImage ~= nil then
		self:setImage(assetImage)
	else
		-- Default image
		local image = graphics.image.new(gridSize, gridSize)
		
		graphics.pushContext(image)
		graphics.fillRect(2, 2, gridSize-4, gridSize-4)
		graphics.popContext()
		
		self:setImage(image)
	end
	)
end

function GameObject:setImageToAsset(assetPath)
	-- TODO: Set file in data folder to asset
	local filePath = self.game.."/".."assets".."/"..assetPath
	
	if not playdate.file.exists(filePath) then
		return nil
	end
	
	
end