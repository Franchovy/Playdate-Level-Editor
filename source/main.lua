import "playdate"
import "sprites/sprites"
import "level/level"

local gameObjects = {};
local game;

local files;

function main()
	-- Create main menu sprite
	
	menu.drawSelf()
	menuOptions.drawSelf()
	menu:add()
	menuOptions:add()
	menu:setCenter(0, 0)
	menu:moveTo(0, 0)
	menuOptions:setCenter(0, 0)
	menuOptions:moveTo(0, 0)
	
	-- Get files
	
	files = getLevelFiles()
	
	print("Files: ")
	for _, fileName in pairs(files) do
		print(fileName)
	end
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(fileName, gameObjects) end)
	
end

function playdate.update()
	sprite.update()
	
	if game ~= nil then
		-- TODO: Move to GameScene
		
		-- Adding GameObjects
		
		if playdate.buttonJustPressed(playdate.kButtonA) then
			local gameObject = GameObject.new()
			table.insert(gameObjects, gameObject)
			
			gameObject:add()
			gameObject:moveTo(game.cursor:getPosition())
		end
	end
	
	if game == nil and playdate.buttonIsPressed(playdate.kButtonA) then
		-- TODO: Move to MenuScene
		
		local selectedFile = files[1]
		if selectedFile ~= nil then
			print("Loading file: ".. selectedFile)
		else
			print("No file selected.")
		end
		
		local gameObjects = importLevel(selectedFile)
		
		menu:remove()
		
		game = Game.new()
		game:add()
	end
end

main()