import "currentGame"
import "editor"
import "gameObject"
import "utils/config"
import "utils/file"

editorScene = {}
editorScene.isInitialized = false
editorScene.shouldQuit = false

local hintSprite = nil

local itemIds = {"platform", "killBlock", "coin"}
local levelConfig = {};
local editor;

function editorScene.init(gameId)
	currentGame.setGameId(gameId)
	
	local gameConfig, itemsConfig = loadGameConfig(gameId)
	
	editor = Editor.new(gameConfig)
	editor:add()
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(fileName, editor:getObjects()) end)
	playdate.getSystemMenu():addMenuItem("Main Menu", function() editorScene.shouldQuit = true end)
	
	-- Items
	
	if itemsConfig == nil or #itemsConfig == 0 then
		print("Error: no definitions in items config!")
		return
	end
	
	editor:addItems(itemsConfig)
	editor:setCurrentItemId("platform")
	
	-- Set Initialized
	
	editorScene.isInitialized = true
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
	local crankChange = playdate.getCrankTicks(180)
	
	-- Set Draw Offset to crank change (in degrees)
	if crankChange ~= 0 then
		editor:goTo(editor:getOffsetX() + crankChange)
	end
	
	-- Change item to next
	if playdate.buttonJustPressed(playdate.kButtonB) then
		
		-- Get Current Item Index
		
		local currentItemIndex = nil;
		local currentItemId = editor:getCurrentItemId()
		
		for i, v in ipairs(itemIds) do
			if currentItemId == v then
				currentItemIndex = i
			end
		end
		
		-- Increment (or loop) index
		
		if currentItemIndex < #itemIds then
			currentItemIndex += 1
		else
			currentItemIndex = 1
		end
		
		currentItemId = itemIds[currentItemIndex]
		
		print("Change Item to: ".. currentItemId)
		
		-- Set new item 
		
		editor:setCurrentItemId(currentItemId)
	end
end