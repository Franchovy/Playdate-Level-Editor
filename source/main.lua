import "playdate"
import "sprites/sprites"
import "level/level"

local gameObjects = {};
local game;

function main()
	-- Create main menu sprite
	
	menu.drawSelf()
	menu:add()
	menu:moveTo(200, 120)
	
	-- Playdate Menu options
	
	local fileName = "level.json"
	playdate.getSystemMenu():addMenuItem("Export", function() exportLevel(fileName, gameObjects) end)
	
	-- Get files
	
	local files = getLevelFiles()
	print("Files: ")
	for _, fileName in pairs(files) do
		print(fileName)
	end
end

function playdate.update()
	sprite.update()
	
	if game ~= nil then
		-- Adding GameObjects
		
		if playdate.buttonJustPressed(playdate.kButtonA) then
			local gameObject = GameObject.new()
			table.insert(gameObjects, gameObject)
			
			gameObject:add()
			gameObject:moveTo(game.cursor:getPosition())
		end
		
	end
	
	if game == nil and playdate.buttonIsPressed(playdate.kButtonA) then
		menu:remove()
		
		game = Game.new()
		game:add()
	end
end

main()