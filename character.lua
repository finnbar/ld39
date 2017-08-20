
UPSPEED = 3 -- pixels climbed each time you press space bar
SPEED = 35
DOWNSPEED = 40
BUFFER = 2 -- to stop character from hitting walls

DELAY = 0.5 -- occurs when climbing off ladders so you don't fall immediately

IMAGE_WIDTH = 30
IMAGE_HEIGHT = 40

ANIMATION_RATE = 0.1

local walkingleft = {image = love.graphics.newImage("assets/characterwalkleft.png"), number = 10, cyclemode = "TIMER", time = ANIMATION_RATE}
local walkingright = {image = love.graphics.newImage("assets/characterwalkright.png"), number = 10, cyclemode = "TIMER", time = ANIMATION_RATE}
local idleleft = {image = love.graphics.newImage("assets/characteridleleft.png"), number = 1, cyclemode = "NONE"}
local idleright = {image = love.graphics.newImage("assets/characteridleright.png"), number = 1, cyclemode = "NONE"}
local ladder = {image = love.graphics.newImage("assets/characterladder.png"), number = 2, cyclemode = "SPACE"}
local quads = {}

-- Add quads to the character images to get specific frames
for _,img in ipairs({walkingright, idleleft, idleright, ladder}) do
    img.quads = {}
    for i = 0,(img.number-1) do
        table.insert(img.quads, love.graphics.newQuad(IMAGE_WIDTH*i, 0, IMAGE_WIDTH, IMAGE_HEIGHT, img.image:getDimensions()))
    end
end

-- Do the walking left guy separately to put the quads in backwards
walkingleft.quads = {}
for i = (walkingleft.number-1),0,-1 do
    table.insert(walkingleft.quads, love.graphics.newQuad(IMAGE_WIDTH*i, 0, IMAGE_WIDTH, IMAGE_HEIGHT, walkingleft.image:getDimensions()))
end


CHARACTER_HEIGHT = 15
CHARACTER_WIDTH = CHARACTER_HEIGHT * IMAGE_WIDTH/IMAGE_HEIGHT

-- These functions convert between the x,y coordinates for drawing and the i,j coordinates
-- of the points on the grid.

function getcharacterxy(i,j)
    local x = (i-0.5) * SQUARE_SIZE
    local y = (j-0.5) * SQUARE_SIZE
    return x,y
end

function getgridcoord(x)
    return math.ceil(x / SQUARE_SIZE)
end

-- The characters position is stored as the x,y coordinates of its middle.
-- These functions find the coordinates of their left, right, top and bottom
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
    local i = getgridcoord(x)
    local j = getgridcoord(y)
    if i < 1 then i = 1 end
    if i > GRID_WIDTH then i = GRID_WIDTH end
    if j < 1 then j = 1 end
    if j > GRID_HEIGHT then j = GRID_HEIGHT end
    return i,j
end

function wallbelow(character)
    local i,j = getIJ(character.x, chardown(character))
    local i2, i3 = getgridcoord(charleft(character)), getgridcoord(charright(character))
    if i2 ~= i3 and maze[i2][j-1].right then
        return true
    else
        return maze[i][j].down or maze[i2][j].down or maze[i3][j].down
    end
end

function drawcharacter(character)
    local image = character.cycler.characterstate.image
    local quad = character.cycler.characterstate.quads[character.cycler.number]
    love.graphics.draw(image, quad, charleft(character) , charup(character), 0, character.height / IMAGE_HEIGHT)
end

function changecycler(cycler, newvalue)
    cycler.characterstate = newvalue
    cycler.number = 1
end

function cyclecycler(cycler)
    cycler.number = cycler.number + 1
    if cycler.number > cycler.characterstate.number then
        cycler.number = 1
    end
    cycler.time = 0
end

function updatecycler(cycler, dt)
    cycler.time = cycler.time + dt
    if cycler.characterstate.cyclemode == "TIMER" and cycler.time > cycler.characterstate.time then
        cyclecycler(cycler)
    end
end

function updatecharacter(character, dt)
    character.delay = character.delay + dt
    updatecycler(character.cycler, dt)

    if character.direction == "left" then
        local old_left,top = getIJ(charleft(character), charup(character))
        local new_left,bottom = getIJ(charleft(character) - SPEED * dt - BUFFER, chardown(character))

        -- move left as long as there isn't a wall in the way
        -- first test is for vertical | | walls, second is for horizontal _ walls
        if new_left ~= old_left - 1 or not (maze[old_left][top].left or maze[old_left][bottom].left) then
            if top == bottom or old_left == new_left or not maze[new_left][top].down then
                character.x = character.x - SPEED * dt
            end
        end
    elseif character.direction == "right" then
        local old_right, top = getIJ(charright(character), charup(character))
        local new_right, bottom = getIJ(charright(character) + SPEED * dt + BUFFER, chardown(character))

        -- move right as long as there isn't a wall in the way
        -- first test is for vertical | | walls, second is for horizontal _ walls
        if new_right ~= old_right + 1 or not (maze[old_right][top].right or maze[old_right][bottom].right) then
            if top == bottom or old_right == new_right or not maze[new_right][top].down then
                character.x = character.x + SPEED * dt
            end
        end
    end

    -- Implement some kind of "gravity"
    if not character.onladder and character.delay > DELAY then
        local bottomy = chardown(character)
        local i,j = getIJ(character.x, bottomy)
        local i2, i3 = getgridcoord(charleft(character)), getgridcoord(charright(character))
        if (not wallbelow(character) or SQUARE_SIZE*j - bottomy > BUFFER) then
            character.y = character.y + DOWNSPEED * dt
        else
            _, character.y = getcharacterxy(i,j)
            character.y =  character.y + SQUARE_SIZE / 2 - character.height / 2 - BUFFER / 2
        end
    end

    -- Rescue operation!!! If falling through a wall.
    local left,middle = getIJ(charleft(character), character.y)
    local right,bottom = getIJ(charright(character), chardown(character))
    if middle ~= bottom and (maze[left][middle].down or maze[right][middle].down) then
        _, character.y = getcharacterxy(left,middle)
        character.y =  character.y + SQUARE_SIZE / 2 - character.height / 2 - BUFFER / 2
    end

end

function makecharacter(character)
    local i, j = GRID_WIDTH/2, GRID_HEIGHT
    local x,y = getcharacterxy(i,j)
    return {x = x, y = y, width = CHARACTER_WIDTH, height = CHARACTER_HEIGHT, direction = "none", onladder = false, delay = 0,
           cycler = {characterstate = idleright, number = 1, time = 0}}
end

function characterkeypressed(character, key, scancode, isrepeat)
    -- moving left and right
    if key == "left" then
        character.direction = "left"
        if character.onladder then
            character.onladder = false
            character.delay = 0
        end
        changecycler(character.cycler, walkingleft)
    elseif key == "right" then
        character.direction = "right"
        if character.onladder then
            character.onladder = false
            character.delay = 0
        end
        changecycler(character.cycler, walkingright)
    end

    -- climbing ladders
    if key == "space" then
        local i,j = getIJ(character.x, character.y)
        local squaretype = maze[i][j].baseimage
        if character.onladder then
            local _,oldup = getIJ(character.x, charup(character))
            local _,newup = getIJ(character.x, charup(character) - UPSPEED - BUFFER)
            if oldup == newup or not maze[i][oldup].up then
                character.y = character.y - UPSPEED
                cyclecycler(character.cycler)
            end
        elseif squaretype == "topladder" or squaretype == "middleladder" or squaretype == "bottomladder" then
            character.onladder = true
            character.x, _ = getcharacterxy(i,j)
            character.direction = "none"
            changecycler(character.cycler, ladder)
        end
    end
end

function characterkeyreleased(character, key)
    if key == "left" or key == "right" then
        if character.direction == "left" then
            changecycler(character.cycler, idleleft)
        elseif character.direction == "right" then
            changecycler(character.cycler, idleright)
        end
        character.direction = "none"
    end
end