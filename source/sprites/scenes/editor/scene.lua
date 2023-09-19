import "currentGame"
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

function editorScene.init(gameId)
	currentGame.setGameId(gameId)
	
	local gameConfig, itemsConfig = loadGameConfig(gameId)
	items = itemsConfig
	
	editor = Editor.new(gameConfig)
	editor:add()
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(gameId, fileName, editor:getObjects()) end)
	playdate.getSystemMenu():addMenuItem("Main Menu", function() editorScene.shouldQuit = true end)
	
	--
	
	editorScene.isInitialized = true
	
	if items == nil or #items == 0 then
		print("Error: no definitions in items config!")
		return
	end
	
	editor:addItems(items)
	editor:setItem("platform")
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
	local gameId = currentGame.getGameId()
	local fileData = importLevel(gameId, fileName)
	
	levelConfig = { levelSize = fileData.levelSize, gridSize = fileData }
	
	editor:loadObjects(fileData.objects)
end

function editorScene.update()

end