requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

function love.load()
    math.randomseed(os.time())
    maze = makemaze()
end

function love.draw()
    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.setColor(255,255,255)
    local x, y = love.mouse.getPosition()
    love.graphics.circle("fill",x,y,50)
    love.graphics.setBlendMode("darken", "premultiplied")
    love.graphics.setColor(255, 255, 255, 100)
    drawmaze(maze)
    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.setColor(250, 0, 0)
    love.graphics.circle("line",x,y,50)
end