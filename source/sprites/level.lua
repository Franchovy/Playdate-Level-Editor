class("Level").extends()

function Level:init()
	self.objects = {}
	self.objectsByPosition = {}
	self.itemCountById = {}
end

function Level:_positionDataAt(position)
	if self.objectsByPosition[position.x] == nil then
		return nil
	elseif self.objectsByPosition[position.x][position.y] == nil then
		return nil
	else 
		return self.objectsByPosition[position.x][position.y]
	end
end

function Level:objectAt(position)
	print("Checking for object at: ".. position.x ..", ".. position.y)
	
	local positionData = self:_positionDataAt(position)
	
	if positionData ~= nil then
		print("Returning: object")
		return positionData.object
	end
	
	print("Returning: nil")
	return nil
end

function Level:hasObjectAt(position, size)
	for i=0, size.width-1 do
		local x = position.x + i
		for j=0, size.height-1 do
			local y = position.y + j
			if self:objectAt({x = x, y = y}) ~= nil then
				return true
			end
		end
	end
	
	return false
end

function Level:addObject(item, position)
	local object = GameObject.new(item, position)
	table.insert(self.objects, object)
	
	self:addObjectByPosition(object, position, item.size)
	self:incrementObjectCount(item.id)
	
	object:add()
end

function Level:addObjectByPosition(object, position, size)
	-- Add object to origin position
	
	local objectData = {
		object = object,
		origin = position
	}
	
	-- Add object to all possible positions
	
	for i=0, size.width - 1 do
		for j=0, size.height - 1 do
			local x = position.x + i
			local y = position.y + j
			print("".. x ..", ".. y)
			self:createMissingPositionTables({ x = x, y = y })
			
			self.objectsByPosition[x][y] = objectData
		end
	end
end

function Level:createMissingPositionTables(position)
	if self.objectsByPosition[position.x] == nil then
		self.objectsByPosition[position.x] = {}
	end
end

function Level:removeObject(object, position, size)
	table.removevalue(self.objects, object)
	
	object:remove()
	
	local positionData = self:_positionDataAt(position)
	local origin = positionData.origin
	
	self:decrementObjectCount(object.id)
	
	-- Remove object from all possible positions
	
	for i=0, size.width - 1 do
		for j=0, size.height - 1 do
			local x = origin.x + i
			local y = origin.y + j
			print("".. x ..", ".. y)
			
			self.objectsByPosition[x][y] = nil
		end
	end
end

function Level:postprocessing()
	print("Running postprocessing")
	self:buildCollisionObjects()
end

function Level:buildCollisionObjects()
	for id, objects in pairs(self:getObjectsById()) do
		-- retrieve item associated to this id and check if it should produce collision objects
		local item = SItems.getItemById(id)

		if item.editorConfig ~= nil and item.editorConfig.mergeToCollision then
			print("Creating collisions for " .. id)
			local rects = self:_createRects(objects)
			print("Built " .. #rects .. " rects")
			local itemConfigs = self:_createCollisionItems(rects, item.editorConfig.collisionId)
			self:_addCollisionsAsObjects(rects, itemConfigs)
		end
	end
end

function Level:_createRects(objects)
	-- some internal functions
	local nextObjHorizontal = function(objects, baseX, baseY, grouped)
		for _, obj in pairs(objects) do
			if obj.gridPosition.y ~= baseY then goto continue end
			if obj.gridPosition.x - baseX > 1 then return nil end
			if grouped[obj] then goto continue end
			
			do return obj end

			::continue::
		end
		return nil
	end

	-- still ...
	local nextObjVertical = function(objects, baseX, baseY, grouped)
		for _, obj in pairs(objects) do
			if obj.gridPosition.x > baseX then return nil end
			if obj.gridPosition.y - baseY > 1 then return nil
			elseif not grouped[obj] then return obj
			else return end
		end 

		return nil
	end

	-- again ...
	local createRect = function(start, finish)
		if start.gridPosition.x == finish.gridPosition.x then
			return {x=start.gridPosition.x, y=start.gridPosition.y, w=1, h=finish.gridPosition.y - start.gridPosition.y + 1}
		else
			return {x=start.gridPosition.x, y=start.gridPosition.y, w=finish.gridPosition.x-start.gridPosition.x+1, h=1}
		end
	end

	local tableFind = function(collection, obj)
		for i, value in pairs(collection) do
			if obj == value then return i end
		end

		return nil
	end

	-- function start here

	-- first we need the grid position of every object
	for _, obj in pairs(objects) do
		local x, y = obj:getGridPosition()
		obj.gridPosition = {x=x, y=y}
	end

	-- sort by increasing x and if x are equal by increasing y (top to bottom)
	table.sort(objects, function (a, b)
		-- sort by x position
		if a.gridPosition.x < b.gridPosition.x then return true
		elseif a.gridPosition.x > b.gridPosition.x then return false
		-- if equal, the one that is above comes first
		else
			if a.gridPosition.y < b.gridPosition.y then return true
			else return false end
		end
		
	end)

	local grouped = {}
	local rects = {}

	for i, obj in ipairs(objects) do
		if grouped[obj] then goto continue end

		if i == #objects then
			table.insert(rects, createRect(obj, obj))
			break
		end

		grouped[obj] = true

		local finish = obj
		while true do
			local sliceStart = tableFind(objects, finish)+1
			if sliceStart > #objects then break end

			local nextObj = nextObjHorizontal({table.unpack(objects, sliceStart)}, finish.gridPosition.x, finish.gridPosition.y, grouped)
			if not nextObj then break end
			finish = nextObj
			grouped[finish] = true
		end

		if finish ~= obj then
			table.insert(rects, createRect(obj, finish))
			goto continue
		end

		while true do
			local sliceStart = tableFind(objects, finish)+1
			if sliceStart > #objects then break end

			local nextObj = nextObjVertical({table.unpack(objects, sliceStart)}, finish.gridPosition.x, finish.gridPosition.y, grouped)
			if not nextObj then break end
			finish = nextObj
			grouped[finish] = true
		end

		table.insert(rects, createRect(obj, finish))

		::continue::
	end

	return rects
end

-- build item configs for the collisions as if they are in items.json, trickery 🎭
function Level:_createCollisionItems(rects, itemId)
	local fakeItems = {}
	for _, rect in pairs(rects) do
		table.insert(fakeItems, 
		{
			id=itemId,
			config={
				w={type="number", value=rect.w},
				h={type="number", value=rect.h},
			},
			size={
				width=rect.w,
				height=rect.h,
			}
		})
	end
	return fakeItems
end

function Level:_addCollisionsAsObjects(rects, itemConfigs)
	for i=1,#rects do
		self:addObject(itemConfigs[i], {x=rects[i].x, y=rects[i].y})
		print("Added collision box")
	end
end

function Level:getObjectsById()
	local objectsById = {}

	for _, object in pairs(self:getObjects()) do
		if objectsById[object.id] == nil then
			objectsById[object.id] = {}
		end

		table.insert(objectsById[object.id], object)
	end

	return objectsById
end

function Level:getObjects()
	return self.objects
end

function Level:getItemCount(itemId)
	return self.itemCountById[itemId]
end

function Level:incrementObjectCount(itemId)
	if self.itemCountById[itemId] == nil then
		self.itemCountById[itemId] = 1
	else
		self.itemCountById[itemId] += 1
	end
end

function Level:decrementObjectCount(itemId)
	assert(self.itemCountById[itemId] ~= nil)
	
	self.itemCountById[itemId] -= 1
end