import "currentGame"
import "editor"
import "gameObject"
import "utils/config"
import "utils/file/file"
import "utils/items"

editorScene = {}
editorScene.isInitialized = false
editorScene.shouldQuit = false

local hintSprite = nil

local itemIds = {}
local levelConfig = {};
local editor;

function editorScene.init(gameId)
	currentGame.setGameId(gameId)
	
	local gameConfig, itemsConfig = loadGameConfig(gameId)
	items.loadItemsConfig(itemsConfig)
	
	-- Create Editor
	
	editor = Editor.new(gameConfig)
	editor:add()
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(fileName, editor:getObjectsExport()) end)
	playdate.getSystemMenu():addMenuItem("Main Menu", function() editorScene.shouldQuit = true end)
	
	-- Items
	
	editor:addItems(itemsConfig)
	editor:setCurrentItemId("platform")
	
	-- Set Initialized
	
	editorScene.isInitialized = true
end

function editorScene.deinit()
	editor:deinit()
	editor:remove()
	
	editor = nil
	
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
	local crankChange = playdate.getCrankTicks(12)
	
	-- Set Draw Offset to crank change (in degrees)
	if crankChange ~= 0 then
		editor:moveByCrank(crankChange)
	end
end