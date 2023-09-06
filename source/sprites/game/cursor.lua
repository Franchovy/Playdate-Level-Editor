import "playdate"

class('Cursor').extends(sprite);

cursor = nil;

function Cursor.new(x, y)
	return Cursor(x, y)
end

function Cursor:init(x, y)
	Cursor.super.init(self)
	
	local image = graphics.image.new(gridSize, gridSize)
	
	graphics.pushContext(image)
	graphics.drawRect(0, 0, gridSize, gridSize)
	graphics.setColor(graphics.kColorClear)
	graphics.drawRoundRect(0, 0, gridSize, gridSize, gridSize / 3)
	graphics.popContext()
	
	self:setImage(image)
end

function Cursor:moveGrid(x, y)
	local positionX, positionY = getGridPosition(self:getPosition())
	positionX += x
	positionY += y
	self:moveTo(makeGridPosition(positionX, positionY))
end