-- Manages the currently active game
currentGame = {}

local currentGameId = nil

function currentGame.setGameId(gameId)
	currentGameId = gameId
end

function currentGame.getGameId()
	return currentGameId
end