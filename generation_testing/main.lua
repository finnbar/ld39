requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

function love.load()
    math.randomseed(os.time())
    maze = makemaze()
end

function love.draw()
    drawmaze(maze)
end