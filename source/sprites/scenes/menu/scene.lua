import "menu"
import "menuOptions"
import "level/level"

menuScene = {}
menuScene.isInitialized = false

menuScene.shouldTransition = false
menuScene.selectedFileName = nil

local menu
local menuOptions
local files

function menuScene.init()
	menu = Menu.new()
	menuOptions = MenuOptions.new()
	
	menu:add()
	menuOptions:add()
	
	menu:setCenter(0, 0)
	menuOptions:setCenter(0, 0)
	
	menu:moveTo(0, 0)
	menuOptions:moveTo(0, 0)
	
	menuScene.isInitialized = true
	
	-- Get files
	
	files = getLevelFiles()
	
	print("Files: ")
	for _, fileName in pairs(files) do
		print(fileName)
	end
end

function menuScene.deinit()
	menu:remove()
	menuOptions:remove()
	
	menu = nil
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