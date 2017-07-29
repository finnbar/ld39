GRID_WIDTH = 40
GRID_HEIGHT = 30
SQUARE_SIZE = 20
DIRECTIONS = {"up", "down", "left", "right"}
PROBABILITIES = {up = 0.15, down = 0.05, left = 0.4, right = 0.4}
NEW_AGENT_PROB = 0.07
DEATH_RATE = 0.05
KEEP_GOING = 1

img = love.graphics.newImage("tileset.png")

SQUARES = {up = love.graphics.newQuad(8*32, 0, 32, 32, img:getDimensions()),
           down = love.graphics.newQuad(6*32, 0, 32, 32, img:getDimensions()),
           left = love.graphics.newQuad(5*32, 0, 32, 32, img:getDimensions()),
           right =love.graphics.newQuad(7*32, 0, 32, 32, img:getDimensions()),
           wall = love.graphics.newQuad(4*32, 0, 32, 32, img:getDimensions()),}

function makemaze()
    local maze = {}
    for i=1,GRID_WIDTH do
        maze[i] = {}
        for j=1,GRID_HEIGHT do
            maze[i][j] = {left = true, right = true, up = true, down = true}
        end
    end
    local agents = {{pos = {i = math.floor(GRID_WIDTH / 2), j = GRID_HEIGHT}, alive = true, last = "left"},
                    {pos = {i = math.floor(GRID_WIDTH / 2), j = GRID_HEIGHT}, alive = true, last = "right"}}
    local agentcount = 2
    for count=1,200 do
        for _, agent in ipairs(agents) do
            if agent.alive then
                local i = agent.pos.i
                local j = agent.pos.j
                local probs = deepcopy(PROBABILITIES)

                -- Edges, and code to increase probability of keeping going left/right
                if i == 1 then probs.left = 0 end
                if i == GRID_WIDTH then probs.right = 0 end
                if j == GRID_HEIGHT then probs.down = 0 end
                if agent.last == "right" then probs.right = probs.right * KEEP_GOING end
                if agent.last == "left" then probs.left = probs.left * KEEP_GOING end
                probs[opposite(agent.last)] = 0

                local direction = makechoice(probs)
                agent.last = direction
                local walldestroyed = true

                if direction == "left" then
                    if wallcount(maze[i-1][j]) > 1 then
                        maze[i-1][j]["right"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i-1][j]) then
                        agent.pos.i = i - 1
                    end
                elseif direction == "right" then
                    if wallcount(maze[i+1][j]) > 1 then
                        maze[i+1][j]["left"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i+1][j]) then
                        agent.pos.i = i + 1
                    end
                elseif direction == "up" then
                    if j == 1 then
                        return maze
                    end
                    if wallcount(maze[i][j-1]) > 1 then
                        maze[i][j-1]["down"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i][j-1]) then
                        agent.pos.j = j - 1
                    end
                elseif direction == "down" then
                    if wallcount(maze[i][j+1]) > 1 then
                        maze[i][j+1]["up"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i][j+1]) then
                        agent.pos.j = j + 1
                    end
                elseif direction == "none" then
                    agent.alive = false
                end

                if walldestroyed then
                    maze[i][j][direction] = false
                end

                if agent.alive then
                    if math.random() < NEW_AGENT_PROB then
                        local newagent = deepcopy(agent)
                        newagent.last = opposite(agent.last)
                        table.insert(agents, deepcopy(agent))
                        agentcount = agentcount + 1
                    end

                    if agentcount > 1 and math.random() < DEATH_RATE then
                        agent.alive = false
                        agentcount = agentcount - 1
                    end
                end
            end
        end
        if agentcount == 0 then
            -- ???
        end
    end
    return maze
end

function newsquare(square)
    return square["up"] and square["down"] and square["left"] and square["right"]
end

function wallcount(square)
    total = 0
    for _,v in pairs({"up", "down", "left", "right"}) do
        if square[v] then total = total + 1 end
    end
    return total
end

function makechoice(probs)
    local t = probs["up"] + probs["down"] + probs["left"] + probs["right"]
    if t == 0 then
        return "none"
    end
    local r = math.random()
    local total = 0
    for i=1,4 do
        total = total + probs[DIRECTIONS[i]]
        if r <= total/t then return DIRECTIONS[i] end
    end
end

function drawmaze(maze)
    --love.graphics.setBackgroundColor(255, 255, 255)
    for i=1,GRID_WIDTH do
        for j=1,GRID_HEIGHT do
            for k,d in ipairs(DIRECTIONS) do
                if maze[i][j][d] then
                    love.graphics.draw(img, SQUARES[d], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/32)
                end
            end
            if newsquare(maze[i][j]) then
                love.graphics.draw(img, SQUARES.wall, (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, SQUARE_SIZE/32)
            end
        end
    end
end

function opposite(direction)
    if direction == "left" then return "right" end
    if direction == "right" then return "left" end
    if direction == "up" then return "down" end
    if direction == "down" then return "up" end
end
