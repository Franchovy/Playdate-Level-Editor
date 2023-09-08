import "playdate"
import "constants"

function getLevelFiles()
	return playdate.file.listFiles(pathLevels)
end

function importLevel(fileName)
	if fileName == nil then
		return
	end
	
	local path = pathLevels.."/"..fileName
	local levelData = json.decodeFile(path)
	
	print("Imported file: ".. path)
	print("Level data: ")
	printTable(levelData)
	
	return levelData
end