class("Level").extends()

function Level:init()
	self.objects = {}
	self.objectsByPosition = {}
end

function Level:objectAt(x, y)
	-- Return item at (x, y), if any.
end

function Level:addObject(item, position)
	local object = GameObject.new(item, position)
	table.insert(self.objects, object)
	
	self:addObjectByPosition(object, position)
	
	object:add()
end

function Level:addObjectByPosition(object, position)
	-- Initialize position tables if nil
	
	if self.objectsByPosition[position.x] == nil then
		self.objectsByPosition[position.x] = {}
	end
	
	if self.objectsByPosition[position.x][position.y] == nil then
		self.objectsByPosition[position.x][position.y] = {}
	end
	
	-- Add object to position table
	
	self.objectsByPosition[position.x][position.y] = object
end

function Level:removeObject(object)
	-- todo
end

function Level:getObjects()
	return self.objects
end