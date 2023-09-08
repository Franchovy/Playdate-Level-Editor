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
		
		if gameScene.shouldQuit then
			gameScene.deinit()
			menuScene.init()
		end
	end
	
	if menuScene.isInitialized then
		menuScene.update()
		
		-- Set Scene
		
		if menuScene.shouldTransition then
			local fileName = menuScene.selectedFileName
			
			menuScene.deinit()
			gameScene.init()
			
			if fileName ~= nil then
				gameScene.loadFromFile(fileName)
			end
		end
	end
end

main()