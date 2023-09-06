import "playdate"
import "grid"

game = sprite.new()

local cursor

function game.addSelf() 
	
	local image = graphics.image.new(gridSize, gridSize)
	graphics.pushContext(image)
	graphics.drawRect(0, 0, gridSize, gridSize)
	graphics.setColor(graphics.kColorClear)
	graphics.drawRoundRect(0, 0, gridSize, gridSize, gridSize / 3)
	graphics.popContext()
	
	cursor = sprite.new(image)
	
	cursor:add()
	cursor:moveTo(makeGridPosition(3, 3))
end

function game.update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		game.moveCursorGrid(-1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonRight) then
		game.moveCursorGrid(1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		game.moveCursorGrid(0, -1)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonDown) then
		game.moveCursorGrid(0, 1)
	end
end

function game.moveCursorGrid(x, y)
	local positionX, positionY = getGridPosition(cursor:getPosition())
	positionX += x
	positionY += y
	cursor:moveTo(makeGridPosition(positionX, positionY))
end