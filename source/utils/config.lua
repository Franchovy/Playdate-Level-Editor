import "playdate"

function loadGameConfig(name) 
	-- Check game folder exists
	if not (playdate.file.exists(name) and playdate.file.isdir(name)) then
		return nil
	end
	
	local filePathGameConfig = name.."/game.json"
	local filePathItemsConfig = name.."/items.json"
	
	-- Check game files exist
	if not (playdate.file.exists(filePathGameConfig) and playdate.file.exists(filePathItemsConfig)) then
		return nil
	end
	
	local gameConfig = json.decodeFile(filePathGameConfig)
	local itemsConfig = json.decodeFile(filePathItemsConfig)
	
	return gameConfig, itemsConfig
end