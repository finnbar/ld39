local plight = love.graphics.newImage("assets/pointlight.png") -- 19 x 19
local tlight = love.graphics.newImage("assets/torchlight.png")

function pointlight(x,y,size)
    love.graphics.draw(plight,x,y,0,size,size)
end

function torchlight(x,y,sizex,sizey,rotation)
    love.graphics.draw(tlight,x,y,math.rad(rotation),sizex,sizey)
end
