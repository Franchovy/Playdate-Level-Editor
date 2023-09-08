import "playdate"
import "constants"

function getLevelFiles()
	return playdate.file.listFiles(directoryExport)
end
