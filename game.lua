game = {}

local character

function game.setup()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    maze = makemaze()
    character = makecharacter()
    return game
end

function game.draw()
    drawmaze(maze)
    drawcharacter(character)
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