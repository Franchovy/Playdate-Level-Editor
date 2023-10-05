import "playdate"
import "constants"
import "currentGame"

import "export"
import "import"
import "inc"

function getLevelFiles(game)
	local filePathLevels = directoryPathNameLevels.."/"..game
	if not (playdate.file.exists(filePathLevels) and playdate.file.isdir(filePathLevels)) then
		return nil
	end
	
	return playdate.file.listFiles(filePathLevels)
end

