import "playdate"

class("MenuOptions").extends(sprite)

function MenuOptions.new()
	return MenuOptions()
end

function MenuOptions:init()
	MenuOptions.super.init(self)
	
	self:draw()
end

function MenuOptions:draw()
	local image = graphics.image.new(400, 240)
	graphics.pushContext(image)
	graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	graphics.drawText("(A) - Continue", 200, 100)
	graphics.drawText("(B) - New Level", 200, 170)
	graphics.popContext()
	
	self:setImage(image)
end