import "playdate"
import "sprites/sprites"

function main()
	menu.drawSelf()
	menu:add()
	menu:moveTo(200, 120)
end

main()

local gameMode = false

function playdate.update()
	sprite.update()
	
	if not gameMode and playdate.buttonIsPressed(playdate.kButtonA) then
		menu:remove()
		game:add()
		game.addSelf()
	end
	
	if gameMode then
		game.update()
	end
end
