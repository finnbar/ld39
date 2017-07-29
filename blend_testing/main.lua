requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

hide = true

function love.load()
    math.randomseed(os.time())
    maze = makemaze()
end

function love.draw()
    local x, y = love.mouse.getPosition()
    if hide then
        love.graphics.setBlendMode("alpha", "alphamultiply")
        love.graphics.setColor(255,255,255)
        love.graphics.circle("fill",x,y,50)
        love.graphics.setBlendMode("darken", "premultiplied")
    end
    love.graphics.setColor(255, 255, 255, 100)
    drawmaze(maze)
    if hide then
        love.graphics.setBlendMode("alpha", "alphamultiply")
        love.graphics.setColor(250, 0, 0)
        love.graphics.circle("line",x,y,50)
    end
end

function love.keypressed(k)
    hide = not hide
end
