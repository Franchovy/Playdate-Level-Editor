import "playdate"
import "sprites/sprites"

function main()
	menu.drawSelf()
	menu:add()
	menu:moveTo(200, 120)
end

main()

local gameObjects = {};
local game;

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
