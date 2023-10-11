
class("Items").extends()

function Items:init()
	self.itemsConfig = {}
	self.itemIds = {}
	self.itemsById = {}
end

function Items:loadItemsConfig(itemsConfig)
	self.itemsConfig = itemsConfig
	
	-- Load Table: Item IDs
	
	for _, item in pairs(itemsConfig) do
		table.insert(self.itemIds, item.id)
	end
	
	-- Load Table: Items by ID
	
	for _, item in pairs(itemsConfig) do
		self.itemsById[item.id] = item
	end
end

function Items:getItems()
	return self.itemsConfig
end

function Items:getItemById(id)
	return self.itemsById[id]
end
	
-- Singleton instance

SItems = Items()

function SItems.loadItemsConfig(...) 
	return Items.loadItemsConfig(SItems, ...)
end

function SItems.getItems(...) 
	return Items.getItems(SItems, ...)
end

function SItems.getItemById(...) 
	return Items.getItemById(SItems, ...)
end