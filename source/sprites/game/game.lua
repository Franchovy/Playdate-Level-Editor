import "playdate"
import "cursor"
import "grid"

class("Game").extends(sprite)

function Game.new()
	return Game()
end

function Game:init() 
	Game.super.init(self)
	
	self.cursor = Cursor.new()
	self.cursor:add()
	self.cursor:moveTo(makeGridPosition(3, 3))
end

function Game:update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		self.cursor:moveGrid(-1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonRight) then
		self.cursor:moveGrid(1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		self.cursor:moveGrid(0, -1)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonDown) then
		self.cursor:moveGrid(0, 1)
	end
end
