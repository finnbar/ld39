game = {}

local gamera = require("gamera")

local hide = true -- for debugging, set to false so we can see the whole grid
LIGHT_SCALE = 5

local character

function game.setup()
    camera = gamera.new(0,0,800,600)
    camera:setScale(3.0)
    maze = makemaze()
    character = makecharacter()
    return game
end

function game.draw()
    camera:setPosition(character.x, character.y)
    camera:draw(function(l,t,w,h)
        love.graphics.setBlendMode("alpha", "premultiplied")
        local x,y = character.x - LIGHT_SCALE*19/2, character.y - LIGHT_SCALE*19/2
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",0,0,800,600)
        love.graphics.setBlendMode("lighten", "premultiplied")
        love.graphics.setColor(255,255,255,255)
        if hide then
            pointlight(x,y,LIGHT_SCALE)
            --torchlight(x,y,15,5,0)
        else
            love.graphics.rectangle("fill",0,0,800,600)
        end
        love.graphics.setBlendMode("multiply", "premultiplied")
        love.graphics.setColor(255,255,255,255)
        drawmaze(maze)
        love.graphics.setBlendMode("alpha", "premultiplied")
        drawcharacter(character)

    end)
    return game
end

function game.keypressed(key, scancode, isrepeat)
    characterkeypressed(character, key, scancode, isrepeat)
    return game
end

function game.keyreleased(key)
    characterkeyreleased(character, key)
    return game
end

function game.update(dt)
    updatecharacter(character, dt)
    return game
end
