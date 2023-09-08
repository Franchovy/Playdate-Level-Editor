import "playdate"

class("Menu").extends(sprite)

menu = sprite.new()

function Menu.new()
	return Menu()
end

function Menu:init()
	Menu.super.init(self)
	
	self:draw()
end

function Menu:draw()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setColor(playdate.graphics.kColorBlack)
	graphics.fillRect(0, 0, 400, 240)
	
	graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	graphics.drawText("*PlayDate* _Level Editor_", 40, 40)
	graphics.popContext()
	
	self:setImage(image)
end
