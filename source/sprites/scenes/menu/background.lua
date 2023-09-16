import "playdate"

function drawBackground()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setColor(playdate.graphics.kColorBlack)
	graphics.fillRect(0, 0, 400, 240)
	
	graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	graphics.drawText("*PlayDate* _Level Editor_", 40, 40)
	graphics.popContext()
	
	image:draw(0, 0)
end
