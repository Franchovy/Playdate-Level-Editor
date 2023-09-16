import "editor"
import "gameObject"
import "utils/config"
import "utils/file"

editorScene = {}
editorScene.isInitialized = false
editorScene.shouldQuit = false

local items = {};
local currentItem = nil;
local levelConfig = {};
local gameObjects = {};
local editor;

function editorScene.init(game)
	editorScene.game = game
	
	local gameConfig, itemsConfig = loadGameConfig(game)
	items = itemsConfig
	
	editor = Editor.new(gameConfig)
	editor:add()
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(game, fileName, gameObjects) end)
	playdate.getSystemMenu():addMenuItem("Main Menu", function() editorScene.shouldQuit = true end)
	
	--
	
	editorScene.isInitialized = true
	
	if items == nil or #items == 0 then
		print("Error: no definitions in items config!")
		return
	end
	
	currentItem = items[1]
end

function editorScene.deinit()
	editor:deinit()
	editor:remove()
	
	for _, object in pairs(gameObjects) do
		object:remove()
	end
	
	editor = nil
	gameObjects = {}
	
	local menuItems = playdate.getSystemMenu():getMenuItems()
	
	for _, item in pairs(menuItems) do
		playdate.getSystemMenu():removeMenuItem(item)
	end
	
	editorScene.shouldQuit = false
	
	editorScene.isInitialized = false
end

function editorScene.loadFromFile(fileName)
	local fileData = importLevel(editorScene.game, fileName)
	local objectsLoaded = {}
	
	levelConfig = { levelSize = fileData.levelSize, gridSize = fileData }
	
	for _, object in pairs(fileData.objects) do
		local gameObject = GameObject.new(object)
		table.insert(objectsLoaded, gameObject)
		
		gameObject:add()
	end
	
	gameObjects = objectsLoaded
end

function editorScene.update()
	-- Adding GameObjects
	
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local gameObject = GameObject.new(currentItem)
		table.insert(gameObjects, gameObject)
		
		gameObject:add()
		gameObject:moveTo(game.cursor:getPosition())
	end
end