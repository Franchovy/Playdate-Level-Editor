import "background"
import "menuOptions"
import "utils/file/file"

menuScene = {}
menuScene.isInitialized = false

menuScene.shouldTransition = false
menuScene.selectedFileName = nil

local game = "wheelrunner"

local background
local menuOptions
local files

function menuScene.init()
	menuOptions = MenuOptions.new()
	
	menuOptions:add()
	menuOptions:setCenter(0, 0)
	menuOptions:moveTo(0, 0)
	
	menuScene.isInitialized = true
	
	background = graphics.sprite.setBackgroundDrawingCallback(function()
		drawBackground()
	end)
	
	-- Get files based on game
	
	files = getLevelFiles(game)
	
	if files == nil then
		print("No Files found for game.")
	else 
		print("Files: ")
		for _, fileName in pairs(files) do
			print(fileName)
		end
	end
end

function menuScene.deinit()
	background:remove()
	menuOptions:remove()
	
	background = nil
	menuOptions = nil

	menuScene.shouldTransition = false
	menuScene.selectedFileName = nil

	menuScene.isInitialized = false
end

function menuScene.update()
	
	local buttonPressedA = playdate.buttonIsPressed(playdate.kButtonA)
	local buttonPressedB = playdate.buttonIsPressed(playdate.kButtonB)
	
	if buttonPressedA or buttonPressedB then
		menuScene.shouldTransition = true
		menuScene.game = game
	end
	
	if buttonPressedA then
		-- Load most recent filename
		
		local selectedFile = files[1]
		if selectedFile ~= nil then
			print("Loading file: ".. selectedFile)
			
			menuScene.selectedFileName = selectedFile
		else
			print("No file found.")
		end
	end
end