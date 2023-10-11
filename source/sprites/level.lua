class("Level").extends()

function Level:init()
	self.objects = {}
end

function Level:objectAt(x, y)
	-- Return item at (x, y), if any.
end

function addObject(config, position)
	local object = GameObject.new2(config, position)
	table.insert(self.objects, object)
	
	object:add()
end

function removeObject(object)
	
end
