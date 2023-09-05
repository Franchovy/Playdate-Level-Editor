import "playdate"
import "sprites/sprites"

function main()
	menu.drawSelf()
	menu:add()
	menu:moveTo(200, 120)
end

main()

function playdate.update()
	sprite.update()
	
	if playdate.buttonIsPressed(playdate.kButtonA) then
		menu:remove()
		game:add()
	end
	
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		print(menu:getBounds())
	end
end
