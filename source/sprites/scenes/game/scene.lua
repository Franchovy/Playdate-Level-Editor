import "game"
import "gameObject"
import "level/level" -- TODO: change to import "utils/import"

gameScene = {}
gameScene.isInitialized = false
gameScene.shouldQuit = false

local levelConfig = {};
local gameObjects = {};
local game;

function gameScene.init()
	game = Game.new()
	game:add()
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(fileName, gameObjects) end)
	playdate.getSystemMenu():addMenuItem("Main Menu", function() gameScene.shouldQuit = true end)
	
	--
	
	gameScene.isInitialized = true
end

function gameScene.deinit()
	game:deinit()
	game:remove()
	
	for _, object in pairs(gameObjects) do
		object:remove()
	end
	
	game = nil
	gameObjects = {}
	
	local menuItems = playdate.getSystemMenu():getMenuItems()
	
	for _, item in pairs(menuItems) do
		playdate.getSystemMenu():removeMenuItem(item)
	end
	
	gameScene.shouldQuit = false
	
	gameScene.isInitialized = false
end

function gameScene.loadFromFile(fileName)
	local fileData = importLevel(fileName)
	local objectsLoaded = {}
	
	levelConfig = { levelSize = fileData.levelSize, gridSize = fileData }
	
	for _, object in pairs(fileData.gameObjects) do
		local gameObject = GameObject.new(object)
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