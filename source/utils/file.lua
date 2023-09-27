import "playdate"
import "constants"
import "currentGame"

local directoryPathNameLevels = "levels"

function getLevelFiles(game)
	local filePathLevels = directoryPathNameLevels.."/"..game
	if not (playdate.file.exists(filePathLevels) and playdate.file.isdir(filePathLevels)) then
		return nil
	end
	
	return playdate.file.listFiles(filePathLevels)
end

function importLevel(game, fileName)
	if game == nil or fileName == nil then
		return
	end
	
	local path = directoryPathNameLevels.."/"..game.."/"..fileName
	local levelData = json.decodeFile(path)
	
	print("Imported file: ".. path)
	print("Level data: ")
	printTable(levelData)
	
	return levelData
end

function exportLevel(name, gameObjects) 
	
	-- Export level and items data
	
	if gameObjects == nil then
		return
	end
	
	local levelObjects = {}
	local maxX = 0
	
	for _, gameObject in pairs(gameObjects) do
		-- Insert Item Export Data
		local itemData = gameObject:getExportData()
		table.insert(levelObjects, itemData)
		
		-- Update Max X if necessary
		maxX = getMaxX(maxX, gameObject)
	end
	
	local levelData = {}
	
	print("Exporting ".. #levelObjects.. " game objects for level size ".. maxX)
	
	levelData.objects = levelObjects
	levelData.theme = 0
	levelData.levelSize = maxX + grid.getSize()
	
	
	-- Destination File Path
	
	local game = currentGame.getGameId()
	local path = directoryPathNameLevels.."/"..game.."/"..name
	print("Exporting to file: ".. path.. "...")
	
	if not playdate.file.isdir(game) then
		playdate.file.mkdir(game)
	end
	
	if not playdate.file.isdir(directoryPathNameLevels.."/"..game) then
		playdate.file.mkdir(directoryPathNameLevels.."/"..game)
	end
	
	if playdate.file.exists(path) then
		print("File already exists! Overwriting...")
	end
	
	json.encodeToFile(path, levelData)
	
	print("Exported to file.")
end

function getMaxX(previousMaxX, gameObject) 
	local x = gameObject:getPosition()
	local width = gameObject:getSize()
	
	if width + x > previousMaxX then
		return width + x
	end
	
	return previousMaxX
end