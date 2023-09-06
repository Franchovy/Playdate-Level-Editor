import "playdate"
import "sprites/sprites"

function main()
	menu.drawSelf()
	menu:add()
	menu:moveTo(200, 120)
end

main()

local game;

function playdate.update()
	sprite.update()
	
	if game == nil and playdate.buttonIsPressed(playdate.kButtonA) then
		menu:remove()
		
		game = Game.new()
		game:add()
	end
end
