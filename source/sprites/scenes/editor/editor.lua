import "playdate"
import "cursor"
import "grid"
import "currentGame"
import "extensions/table"
import "utils/spritecycler/spritecycler"

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
	
	self.cursorBorderMarginX = 2
	
	self.cursor = Cursor.new()
	self.cursor:setCenter(0, 0)
	self.cursor:add()
	self.cursor:moveTo(grid.makeGridPosition(3, 3))
	
	self.hintSprite = sprite.new()
	self.hintSprite:setIgnoresDrawOffset(true)
	self.hintSprite:setCenter(0, 0)
	self.hintSprite:moveTo(25, 25)
	self.hintSprite:add()
end

function Editor:deinit()
	for _, object in pairs(self.objects) do
		object:remove()
	end
	
	self.objects = nil
	
	self.cursor:remove()
	self.cursor = nil
	
	self.hintSprite:remove()
	self.hintSprite = nil
	
	self.items = nil
	self.item = nil
end

function Editor:update()
	
	-- Movement
	
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		self.cursor:moveByGrid(-1, 0)
		
		self:updateOffsetForCursor()
	end
	
	if playdate.buttonJustPressed(playdate.kButtonRight) then
		self.cursor:moveByGrid(1, 0)
		
		self:updateOffsetForCursor()
	end
	
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		self.cursor:moveByGrid(0, -1)
	end
	
	if playdate.buttonJustPressed(playdate.kButtonDown) then
		self.cursor:moveByGrid(0, 1)
	end
	
	-- Add items
	
	if playdate.buttonIsPressed(playdate.kButtonB) or playdate.buttonIsPressed(playdate.kButtonA) then
	
		local collisionData = {self.cursor:checkCollisions(self.cursor:getPosition())}
		local isColliding = (collisionData[4] > 0)
		
		if playdate.buttonIsPressed(playdate.kButtonB) and isColliding then
			local collisionObjects = collisionData[3]
			local object = collisionObjects[1].other
			
			table.removevalue(self.objects, object)
			object:remove()
		elseif playdate.buttonIsPressed(playdate.kButtonA) and not isColliding then
			local object = GameObject.new(self.item, self.cursor:getPositionGrid())
			table.insert(self.objects, object)
			self.spriteCycler:addObject(object)
			
			object:add()
			object:moveTo(self.cursor:getPosition())
		elseif playdate.buttonJustPressed(playdate.kButtonB) and not isColliding then
			-- Notify scene of change
			self.shouldChangeItemId = true
		end
	end
end

-- X Offset Movement

function Editor:moveByCrank(changeTicks)
	self.cursor:moveByGrid(-changeTicks, 0)
	
	self:updateOffsetForCursor()
end

function Editor:updateOffsetForCursor()
	local cursorX, cursorY = self.cursor:getPosition()
	local offsetX, offsetY = graphics.getDrawOffset()
	local marginX, marginY = grid.makeGridPosition(self.cursorBorderMarginX, 0)
	
	if cursorX - (-offsetX) < marginX then
		local drawOffsetX = cursorX - marginX
		graphics.setDrawOffset(-drawOffsetX, 0)
	elseif ((-offsetX) + 400) - cursorX < marginX then
		local drawOffsetX = 400 - cursorX - marginX
		graphics.setDrawOffset(drawOffsetX, 0)
	end
	
	-- TODO: Add Y-axis handling
end

function Editor:goTo(offsetX)
	graphics.setDrawOffset(-offsetX, 0)
end

function Editor:getOffsetX()
	local x, _ = graphics.getDrawOffset()
	return -x
end

-- Objects Interface

function Editor:loadObjects(objects)
	local itemsById = {}
	for _, item in pairs(self.items) do
		itemsById[item.id] = item
	end
	
	for _, objectConfig in pairs(objects) do
		local object = GameObject.fromConfig(objectConfig, itemsById[objectConfig.id])
		table.insert(self.objects, object)
		
		object:add()
	end
end

function Editor:getObjectsExport()
	--local objects = table.deepcopy(self.objects) -- Warning: Need to copy only position data/config, not entire object 
	-- TODO: Add platform efficiency
	-- iterate over all objects
	-- if platform: 
	-- get platform under, if any
	-- get platform right, if any
	-- if both of the above, get platform under, right, if any
	-- if any of the above, recurse (under -> under, right -> right, X under x Y right )
	
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
	local hintTextImage = graphics.imageWithText(id, 150, 25)
	self.hintSprite:setSize(hintTextImage:getSize())
	self.hintSprite:setImage(hintTextImage)
	
	for _, v in pairs(self.items) do
		if v.id == id then
			self.item = v
			return
		end
	end
end
