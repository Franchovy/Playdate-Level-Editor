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
			local game = menuScene.game
			local fileName = menuScene.selectedFileName
			
			menuScene.deinit()
			editorScene.init(game)
			
			if fileName ~= nil then
				editorScene.loadFromFile(fileName)
			end
		end
	end
end

main()