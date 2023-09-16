import "playdate"
import "constants"

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
	if gameObjects == nil then
		return
	end
	
	local exportData = {}
	for _, gameObject in pairs(gameObjects) do
		local itemPositionX, itemPositionY = getGridPosition(gameObject:getPosition())
		local itemData = {}
		itemData["x"] = itemPositionX
		itemData["y"] = itemPositionY
		table.insert(exportData, itemData)
	end
	
	local path = directoryPathNameLevels.."/"..game.."/"..fileName
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
	
	json.encodeToFile(path, exportData)
	
	print("Exported to file.")
end
