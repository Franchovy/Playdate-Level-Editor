import "playdate"
import "utils/file"
import "sprites/sprites"

function main()

	-- Init scene
	
	menuScene.init()
end

function playdate.update()
	sprite.update()
	
	if editorScene.isInitialized then
		editorScene.update()
		
		if editorScene.shouldQuit then
			editorScene.deinit()
			menuScene.init()
		end
	end
	
	if menuScene.isInitialized then
		menuScene.update()
		
		-- Set Scene
		
		if menuScene.shouldTransition then
			local gameId = menuScene.game
			local fileName = menuScene.selectedFileName
			
			menuScene.deinit()
			editorScene.init(gameId)
			
			if fileName ~= nil then
				editorScene.loadFromFile(fileName)
			end
		end
	end
end

main()