TILE_SIZE = 32
img = love.graphics.newImage("tileset.png")

SQUARES = {up = love.graphics.newQuad(8*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           down = love.graphics.newQuad(6*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           left = love.graphics.newQuad(5*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           right =love.graphics.newQuad(7*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           wall = love.graphics.newQuad(4*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           empty = love.graphics.newQuad(0, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           bottomladder = love.graphics.newQuad(3*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           middleladder = love.graphics.newQuad(1*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions()),
           topladder = love.graphics.newQuad(2*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, img:getDimensions())}


function drawmaze(maze)
    --love.graphics.setBackgroundColor(255, 255, 255)
    for i=1,GRID_WIDTH do
        for j=1,GRID_HEIGHT do
            love.graphics.draw(img, SQUARES[maze[i][j].baseimage], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/TILE_SIZE)
            allwalls = true
            for _,d in ipairs(DIRECTIONS) do
                if maze[i][j][d] then
                    love.graphics.draw(img, SQUARES[d], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/TILE_SIZE)
                else
                    allwalls = false
                end
            end
            if allwalls then
                love.graphics.draw(img, SQUARES["wall"], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE / TILE_SIZE)
            end
        end
    end
end
