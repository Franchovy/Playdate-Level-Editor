import "playdate"

menu = sprite.new()

function menu.drawSelf()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setColor(playdate.graphics.kColorBlack)
	graphics.fillRect(0, 0, 400, 240)
	
	graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	graphics.drawText("*PlayDate* _Level Editor_", 40, 40)
	graphics.popContext()
	
	menu:setImage(image)
end

menuOptions = sprite.new()

function menuOptions.drawSelf()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	graphics.drawText("(A) - Continue", 200, 100)
	graphics.drawText("(B) - New Level", 200, 170)
	graphics.popContext()
	
	menuOptions:setImage(image)
end