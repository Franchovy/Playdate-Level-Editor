import "playdate"
import "constants"

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
	
	local path = pathLevels.. "/".. name
	print("Exporting to file: ".. path.. "...")
	
	if not playdate.file.isdir(pathLevels) then
		playdate.file.mkdir(pathLevels)
	end
	
	if playdate.file.exists(path) then
		print("File already exists! Overwriting...")
	end
	
	json.encodeToFile(path, exportData)
	
	print("Exported to file.")
end
