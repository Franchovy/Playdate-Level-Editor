gridSize = 24

function makeGridPosition(x, y)
	return (x * gridSize), (y * gridSize)
end

function getGridPosition(x, y)
	return (x / gridSize), (y / gridSize)
end