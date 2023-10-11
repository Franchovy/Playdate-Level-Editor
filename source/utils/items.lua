
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
	Items.loadItemsConfig(SItems, ...)
end

function SItems.getItems(...) 
	Items.getItems(SItems, ...)
end

function SItems.getItemById(...) 
	Items.getItemById(SItems, ...)
end