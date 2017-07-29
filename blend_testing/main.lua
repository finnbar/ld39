requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

hide = true

function love.load()
    math.randomseed(os.time())
    maze = makemaze()
    canvas = love.graphics.newCanvas()
end

function love.draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    local x,y = love.mouse.getPosition()
    drawmaze(maze)
    if hide then
        love.graphics.setCanvas(canvas)
            love.graphics.clear()
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill",0,0,800,600)
            love.graphics.setBlendMode("lighten", "premultiplied")
            love.graphics.setColor(255,255,255,255)
            love.graphics.circle("fill",x,y,50)
        love.graphics.setCanvas()
        love.graphics.setBlendMode("darken", "premultiplied")
        love.graphics.draw(canvas,0,0)
    end
end

function love.keypressed(k)
    hide = not hide
end
