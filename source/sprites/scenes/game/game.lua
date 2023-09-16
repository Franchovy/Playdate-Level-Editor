import "playdate"
import "cursor"
import "grid"

class("Game").extends(sprite)

function Game.new(config)
	return Game(config)
end

function Game:init(config) 
	Game.super.init(self)
	
	if config ~= nil then
		self.levelSize = config.levelSize
		grid.setSize(config.gridSize)
	else
		grid.setSize(defaultGridSize)
	end
	
	self.cursor = Cursor.new()
	self.cursor:add()
	self.cursor:moveTo(grid.makeGridPosition(3, 3))
end

function Game:deinit()
	self.cursor:remove()
	self.cursor = nil
end

function Game:update()
	
	-- Movement
	
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
