import "playdate"
import "grid"
import "currentGame"

class("GameObject").extends(sprite)

function GameObject.new(itemConfig, x, y)
	return GameObject(itemConfig, x, y)
end

function GameObject:init(itemConfig, x, y)
	GameObject.super.init(self)
	
	local gridSize = grid.getSize()
	-- Set properties
	
	self.id = itemConfig.id
	self.config = itemConfig.config
	if itemConfig.size ~= nil then
		self.size = itemConfig.size
	else 
		self.size = { width = 1, height = 1 }
	end
	
	-- Set sprite properties
	
	self:setCenter(0, 0)
	self:setSize(grid.makeGridPosition(self.size.width, self.size.height))
	self:setCollideRect(0, 0, self:getSize())
	
	-- Set Position 
	
	if x ~= nil and y ~= nil then
		self:moveTo(grid.makeGridPosition(x, y))
	elseif itemConfig.position ~= nil then
		self:moveTo(grid.makeGridPosition(itemConfig.position.x, itemConfig.position.y))
	else 
		print("Error: No positioning data for sprite: ".. itemConfig.id)
		return
	end
	
	-- Set Image
	
	local assetImage = self:getImageAsset(itemConfig.assetName)
	if assetImage ~= nil then
		self:setImage(assetImage)
	else
		-- Default image
		local width, height = self:getSize()
		local image = graphics.image.new(width, height)
		
		graphics.pushContext(image)
		graphics.fillRect(2, 2, width-4, height-4)
		graphics.popContext()
		
		self:setImage(image)
	end
end

function GameObject:getImageAsset(assetPath)
	if assetPath == nil then
		return nil
	end
	
	local gameId = currentGame.getGameId()
	return graphics.image.new("assets/"..gameId.."/"..assetPath)
end