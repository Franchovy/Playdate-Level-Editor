import "inc"

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