img = love.graphics.newImage("tileset.png")

SQUARES = {up = love.graphics.newQuad(8*32, 0, 32, 32, img:getDimensions()),
           down = love.graphics.newQuad(6*32, 0, 32, 32, img:getDimensions()),
           left = love.graphics.newQuad(5*32, 0, 32, 32, img:getDimensions()),
           right =love.graphics.newQuad(7*32, 0, 32, 32, img:getDimensions()),
           wall = love.graphics.newQuad(4*32, 0, 32, 32, img:getDimensions()),
           empty = love.graphics.newQuad(0, 0, 32, 32, img:getDimensions()),
           bottomladder = love.graphics.newQuad(3*32, 0, 32, 32, img:getDimensions()),
           middleladder = love.graphics.newQuad(1*32, 0, 32, 32, img:getDimensions()),
           topladder = love.graphics.newQuad(2*32, 0, 32, 32, img:getDimensions())}


function drawmaze(maze)
    love.graphics.setBackgroundColor(255, 255, 255)
    for i=1,GRID_WIDTH do
        for j=1,GRID_HEIGHT do
            love.graphics.draw(img, SQUARES[maze[i][j].baseimage], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/32)
            for _,d in ipairs(DIRECTIONS) do
                if maze[i][j][d] then
                    love.graphics.draw(img, SQUARES[d], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/32)
                end
            end
        end
    end
end