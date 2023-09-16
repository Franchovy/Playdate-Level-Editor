grid = {}

local gridSize;

function grid.getSize()
	return gridSize
end

function grid.setSize(size)
	gridSize = size
end

function grid.makeGridPosition(x, y)
	return (x * gridSize), (y * gridSize)
end

function grid.getGridPosition(x, y)
	return (x / gridSize), (y / gridSize)
end
