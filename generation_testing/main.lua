requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    maze = makemaze()
end

function love.draw()
    drawmaze(maze)
end
