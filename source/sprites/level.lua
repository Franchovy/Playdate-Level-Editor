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
	print("Adding object: ")
	
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