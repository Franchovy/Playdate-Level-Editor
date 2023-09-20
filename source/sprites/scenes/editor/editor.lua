import "playdate"
import "cursor"
import "grid"
import "currentGame"

class("Editor").extends(sprite)

function Editor.new(config)
	return Editor(config)
end

function Editor:init(config) 
	Editor.super.init(self)
	
	self.items = {}
	self.item = nil
	self.objects = {}
	
	if config ~= nil then
		self.levelSize = config.levelSize
		grid.setSize(config.gridSize)
	else
		grid.setSize(defaultGridSize)
	end
	
	self.cursor = Cursor.new()
	self.cursor:setCenter(0, 0)
	self.cursor:add()
	self.cursor:moveTo(grid.makeGridPosition(3, 3))
end

function Editor:deinit()
	self.cursor:remove()
	self.cursor = nil
	self.items = nil
	self.item = nil
end

function Editor:update()
	
	-- Movement
	
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		self.cursor:moveByGrid(-1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonRight) then
		self.cursor:moveByGrid(1, 0)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		self.cursor:moveByGrid(0, -1)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonDown) then
		self.cursor:moveByGrid(0, 1)
	end
	
	-- Add items
	
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local object = GameObject.new(self.item, self.cursor:getPositionGrid())
		table.insert(self.objects, object)
		
		object:add()
		object:moveTo(self.cursor:getPosition())
	end
end

-- X Offset Movement

function Editor:goTo(offsetX)
	graphics.setDrawOffset(offsetX, 0)
end

function Editor:getOffsetX()
	return graphics.getDrawOffset()
end

-- Objects Interface

function Editor:loadObjects(objects)
	for _, objectConfig in pairs(objects) do
		local object = GameObject.new(objectConfig)
		table.insert(self.objects, object)
		
		object:add()
	end
end

function Editor:getObjects()
	return self.objects
end 

-- Items Interface

function Editor:addItems(items)
	self.items = items
end

function Editor:getCurrentItemId()
	return self.item.id
end

function Editor:setCurrentItemId(id)
	for _, v in pairs(self.items) do
		if v.id == id then
			self.item = v
			return
		end
	end
end
