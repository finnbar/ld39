game = {}

function game.setup()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    maze = makemaze()
    return game
end

function game.draw()
    drawmaze(maze)
    return game
end
