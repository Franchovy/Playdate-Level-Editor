items = {}
local itemsConfig = itemsConfig
local itemIds = {}
local itemsById = {}

function items.loadItemsConfig(itemConfigs)
	
	-- Load Item IDs
	
	for _, item in pairs(itemsConfig) do
		table.insert(itemIds, item.id)
	end
	
end

function items.getItems()
	return itemsConfig
end