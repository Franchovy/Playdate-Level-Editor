import "playdate"

dirPathGames = "games/"

function loadGameConfig(name) 
	local dirPathGame = dirPathGames..name
	-- Check game folder exists
	if not (playdate.file.exists(dirPathGame) and playdate.file.isdir(dirPathGame)) then
		return nil
	end
	
	local filePathGameConfig = dirPathGame.."/game.json"
	local filePathItemsConfig = dirPathGame.."/items.json"
	
	-- Check game files exist
	if not (playdate.file.exists(filePathGameConfig) and playdate.file.exists(filePathItemsConfig)) then
		return nil
	end
	
	local gameConfig = json.decodeFile(filePathGameConfig)
	local itemsConfig = json.decodeFile(filePathItemsConfig)
	
	return gameConfig, itemsConfig
end