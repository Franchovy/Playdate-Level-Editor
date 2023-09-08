import "playdate"
import "level/level"
import "sprites/sprites"


function main()

	-- Init scene
	
	menuScene.init()
end

function playdate.update()
	sprite.update()
	
	if gameScene.isInitialized then
		gameScene.update()
	end
	
	if menuScene.isInitialized then
		
		menuScene.update()
		
		-- Set Scene
		
		if menuScene.shouldTransition then
			menuScene.deinit()
			gameScene.init()
			
			local fileName = menuScene.selectedFileName
			if fileName ~= nil then
				gameScene.loadFromFile(fileName)
			end
		end
	end
end

main()