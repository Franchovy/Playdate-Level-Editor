import "playdate"
import "grid"
import "game/game"

game = sprite.new()
local cursor;

function game.addSelf() 
	cursor = Cursor.new()
	
	cursor:add()
	cursor:moveTo(makeGridPosition(3, 3))
end

function game.update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		cursor:moveGrid(-1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonRight) then
		cursor:moveGrid(1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		cursor:moveGrid(0, -1)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonDown) then
		cursor:moveGrid(0, 1)
	end
end
