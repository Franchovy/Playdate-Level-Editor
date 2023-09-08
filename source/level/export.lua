import "constants"

function exportLevel(name, gameObjects) 
	if gameObjects == nil then
		return
	end
	
	local exportData = {}
	for _, gameObject in pairs(gameObjects) do
		local itemPosition = getGridPosition(gameObject:getPosition())
		table.insert(exportData, itemPosition)
	end
	
	local pathExport = directoryExport.. "/".. name
	print("Exporting to file: ".. pathExport.. "...")
	
	if not playdate.file.isdir(directoryExport) then
		playdate.file.mkdir(directoryExport)
	end
	
	if playdate.file.exists(pathExport) then
		print("File already exists! Overwriting...")
	end
	
	json.encodeToFile(pathExport, exportData)
	
	print("Exported to file: ".. pathExport)
end
