import "game"
import "gameObject"
import "level/level" -- TODO: change to import "utils/import"

gameScene = {}
gameScene.isInitialized = false

local gameObjects = {};
local game;

function gameScene.init()
	game = Game.new()
	game:add()
	
	gameScene.isInitialized = true
end

function gameScene.deinit()
	gameScene.isInitialized = false
end

function gameScene.loadFromFile(fileName)
	local fileData = importLevel(fileName)
	local objectsLoaded = {}
	
	for _, object in pairs(fileData) do
		local gameObject = GameObject.new()
		table.insert(objectsLoaded, gameObject)
		
		gameObject:add()
		gameObject:moveTo(makeGridPosition(object.x, object.y))
	end
	
	gameObjects = objectsLoaded
end

function gameScene.update()
	-- Adding GameObjects
	
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local gameObject = GameObject.new()
		table.insert(gameObjects, gameObject)
		
		gameObject:add()
		gameObject:moveTo(game.cursor:getPosition())
	end
end