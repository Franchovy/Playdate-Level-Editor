import "playdate"
import "grid"

class('Cursor').extends(sprite);

function Cursor.new(x, y)
	return Cursor(x, y)
end

function Cursor:init(x, y)
	Cursor.super.init(self)
	
	local gridSize = grid.getSize()
	local image = graphics.image.new(gridSize, gridSize)
	
	graphics.pushContext(image)
	graphics.drawRect(0, 0, gridSize, gridSize)
	graphics.setColor(graphics.kColorClear)
	graphics.drawRoundRect(0, 0, gridSize, gridSize, gridSize / 3)
	graphics.popContext()
	
	self:setImage(image)
end

function Cursor:moveByGrid(x, y)
	local positionX, positionY = grid.getGridPosition(self:getPosition())
	positionX += x
	positionY += y
	self:moveTo(grid.makeGridPosition(positionX, positionY))
end

function Cursor:getPositionGrid()
	return grid.getGridPosition(self:getPosition())
end