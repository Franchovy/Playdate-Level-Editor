import "playdate"
import "cursor"
import "grid"
import "currentGame"
import "extensions/table"
import "sprites/level"
import "utils/items"

class("Editor").extends(sprite)

function Editor.new(config)
	return Editor(config)
end

function Editor:init(config) 
	Editor.super.init(self)
	
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
	
	self.level = Level()
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
	
	-- Add or Remove Object
	
	if playdate.buttonIsPressed(playdate.kButtonB) or playdate.buttonIsPressed(playdate.kButtonA) then
	
		local x, y = self.cursor:getPositionGrid()
		local position = { x = x, y = y }
		
		local objectExisting = self.level:objectAt({x = x, y = y})
		if objectExisting == nil then
			
			if playdate.buttonJustPressed(playdate.kButtonB) then
				-- Cycle through possible items, skipping ones that reached their max count.
				repeat
					self:nextItem()
				until self.item.count == nil or self.level:getItemCount(self.item.id) < self.item.count
			elseif playdate.buttonIsPressed(playdate.kButtonA) then
				local canPlaceItem = true
				
				-- Ensure the item to be placed does not overlap with any other items
				if self.level:hasObjectAt({x = x, y = y}, self.item.size) then
					canPlaceItem = false
				end
				
				-- Ensure item does not exceed the item count
				if self.item.count ~= nil and self.level:getItemCount(self.item.id) >= self.item.count then
					canPlaceItem = false
				end
				
				if canPlaceItem then
					self.level:addObject(self.item, position)
				end
			end
		elseif playdate.buttonIsPressed(playdate.kButtonB) then
			self.level:removeObject(objectExisting, position, objectExisting.size)
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
	for _, objectConfig in pairs(objects) do
		local config = SItems.getItemById(objectConfig.id)
		local position = objectConfig.position
		
		self.level:addObject(config, position)
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
	self.level:buildCollisionObjects()

	return self.level:getObjects()
end

-- Items Interface


-- WIP: 
-- Migrate references to "items" from here into "items" singleton
-- Only keep hold of items id. Loop through using index and size of items array.
-- Pass item id into config for gameobject. GameObject fetches config on its own. use .new2() for dev.

function Editor:nextItem()
	local items = SItems.getItems()
	for i, v in ipairs(items) do
		if v.id == self.item.id then
			local targetIndex = (i % #items) + 1
			self.item = items[targetIndex]
			self:renderCurrentItem()
			return
		end
	end
end

function Editor:getCurrentItemId()
	return self.item.id
end

function Editor:setCurrentItemById(id)
	self.item = SItems.getItemById(id)
	
	self:renderCurrentItem()
end

function Editor:renderCurrentItem()
	local id = self.item.id
	local hintTextImage = graphics.imageWithText(id, 150, 25)
	self.hintSprite:setSize(hintTextImage:getSize())
	self.hintSprite:setImage(hintTextImage)
end