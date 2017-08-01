requires = {"generate", "useful"}

for _,j in pairs(requires) do
    require(j)
end

hide = true
pointlight = love.graphics.newImage("pointlight.png") -- 16x16
pointlight:setFilter("nearest")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
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
            love.graphics.draw(pointlight,x,y,0,8,8)
            love.graphcs.setBlendMode("darken", "premultiplied")
            love.graphics.setColor(0,0,0)
            for _,p in pairs(listblocked(maze)) do
                local i,j = (p[1]-1)*SQUARE_SIZE, (p[2]-1)*SQUARE_SIZE
                love.graphics.rectangle("fill", i, j, SQUARE_SIZE, SQUARE_SIZE)
            end
            love.graphics.setColor(255,255,255,255)
        love.graphics.setCanvas()
        love.graphics.setBlendMode("darken", "premultiplied")
        love.graphics.draw(canvas,0,0)
    end
end

function love.keypressed(k)
    hide = not hide
end
