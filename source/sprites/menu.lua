import "playdate"

menu = sprite.new()

function menu.drawSelf()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setColor(playdate.graphics.kColorBlack)
	graphics.fillRect(0, 0, 400, 240)
	
	graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	graphics.drawText("normal *bold* _italic_", 400/2, 240/2)
	graphics.popContext()
	
	menu:setImage(image)
end