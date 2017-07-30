
SPEED = 15
characterimage = love.graphics.newImage("tempcharacter.png")

function getCharacterXY(i,j)
    local x = (i-0.5) * SQUARE_SIZE
    local y = (j-0.5) * SQUARE_SIZE
    return x,y
end

function getGridCoord(x)
    return math.ceil(x / SQUARE_SIZE)
end

function charleft(character)
    return character.x - character.width/2
end

function charright(character)
    return character.x + character.width/2
end

function charup(character)
    return character.y - character.height/2
end

function chardown(character)
    return character.y + character.height/2
end

function getIJ(x,y)
    local i = getGridCoord(x)
    local j = getGridCoord(y)
    return i,j
end

function drawcharacter(character)
    love.graphics.draw(characterimage, charleft(character) , charup(character), 0, character.height / characterimage:getHeight())
end

function updatecharacter(character, dt)
    if character.direction == "left" then
        local old_left = getGridCoord(charleft(character))
        local new_left = getGridCoord(charleft(character) - SPEED * dt)
        local top = getGridCoord(charup(character))
        local bottom = getGridCoord(chardown(character))
        if new_left ~= old_left - 1 or not (maze[old_left][top].left or maze[old_left][bottom].left) then
            character.x = character.x - SPEED * dt
        end
    elseif character.direction == "right" then
        local old_right = getGridCoord(charright(character))
        local new_right = getGridCoord(charright(character) + SPEED * dt)
        local top = getGridCoord(charup(character))
        local bottom = getGridCoord(chardown(character))
        if new_right ~= old_right + 1 or not (maze[old_right][top].right or maze[old_right][bottom].right) then
            character.x = character.x + SPEED * dt
        end
    end
end

function makecharacter(character)
    local i, j = GRID_WIDTH/2, GRID_HEIGHT
    local x,y = getCharacterXY(i,j)
    return {x = x, y = y, width = 10, height = 15}
end