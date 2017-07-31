game = {}

local gamera = require("gamera")

local hide = false -- for debugging, set to false so we can see the whole grid

local pointlight = love.graphics.newImage("pointlight.png") -- 19 x 19

local character

function game.setup()
    camera = gamera.new(0,0,800,600)
    camera:setScale(3.0)
    maze = makemaze()
    character = makecharacter()
    canvas = love.graphics.newCanvas()
    return game
end

function game.draw()
    camera:setPosition(character.x, character.y)
    camera:draw(function(l,t,w,h)
        love.graphics.setBlendMode("alpha", "premultiplied")
        local x,y = character.x - 8*19/2, character.y - 8*19/2
        drawmaze(maze)
        drawcharacter(character)
        if hide then
            love.graphics.setCanvas(canvas)
                love.graphics.clear()
                love.graphics.setColor(0,0,0)
                love.graphics.rectangle("fill",0,0,800,600)
                love.graphics.setBlendMode("lighten", "premultiplied")
                love.graphics.setColor(255,255,255,255)
                love.graphics.draw(pointlight,x,y,0,8,8)
                love.graphics.setBlendMode("darken", "premultiplied")
                love.graphics.setColor(255,255,255,255)
            love.graphics.setCanvas()
            love.graphics.setBlendMode("darken", "premultiplied")
            love.graphics.draw(canvas,0,0)
        end
    end)
    return game
end

function game.keypressed(key, scancode, isrepeat)
    characterkeypressed(character, key, scancode, isrepeat)
    return game
end

function game.keyreleased(key)
    if key == "left" or key == "right" then
        character.direction = "none"
    end
    return game
end

function game.update(dt)
    updatecharacter(character, dt)
    return game
end
