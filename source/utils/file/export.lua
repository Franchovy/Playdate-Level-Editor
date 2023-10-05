import "inc"

function exportLevel(name, gameObjects) 
	
	-- Export level and items data
	
	if gameObjects == nil then
		return
	end
	
	local levelObjects, maxX = getLevelObjects(gameObjects)
	
	print("Exporting ".. #levelObjects.. " game objects for level size ".. maxX)
	
	local levelData = {
		objects = levelObjects,
		theme = 0,
		levelSize = maxX + grid.getSize(),
	}

	-- Destination File Path
	
	local game = currentGame.getGameId()
	
	ensureDirectoryExists(directoryPathNameLevels)
	ensureDirectoryExists(directoryPathNameLevels.."/"..game)
	
	encodeToFile(directoryPathNameLevels.."/"..game.."/"..name, levelData)
end

function ensureDirectoryExists(paths)
	if not playdate.file.isdir(v) then
		playdate.file.mkdir(v)
	end
end

function getLevelObjects(path, levelData)
	if playdate.file.exists(path) then
		print("File already exists! Overwriting...")
	end
	
	json.encodeToFile(path, levelData)
	
	print("Exported to file: ".. path)
end

function getLevelObjects(gameObjects)
	local levelObjects = {}
	local maxX = 0
	
	for _, gameObject in pairs(gameObjects) do
		-- Insert Item Export Data
		local itemData = gameObject:getExportData()
		table.insert(levelObjects, itemData)
		
		-- Update Max X if necessary
		maxX = getMaxX(maxX, gameObject)
	end
	
	return levelObjects, maxX
end

function getMaxX(previousMaxX, gameObject) 
	local x = gameObject:getPosition()
	local width = gameObject:getSize()
	
	if width + x > previousMaxX then
		return width + x
	end
	
	return previousMaxX
end