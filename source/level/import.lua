import "playdate"
import "constants"

function getLevelFiles()
	if playdate.file.exists(pathLevels) and playdate.file.isdir(pathLevels) then
		return playdate.file.listFiles(pathLevels)
	end
	
	return {}
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