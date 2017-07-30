GRID_WIDTH = 40
GRID_HEIGHT = 30
SQUARE_SIZE = 20
DIRECTIONS = {"up", "down", "left", "right"}

-- Base probabilites for each direction, changing them makes a significant difference to mazes generated
PROBABILITIES = {up = 0.15, down = 0.05, left = 0.4, right = 0.4}
NEW_AGENT_PROB = 0.07
DEATH_RATE = 0.05

-- KEEP_GOING will increase prob of continuing in same direction if > 1 and decrease otherwise
-- Note turning back is already forbidden so this isn't very necessary
KEEP_GOING = 1

function makemaze()
    local maze = {}
    for i=1,GRID_WIDTH do
        maze[i] = {}
        for j=1,GRID_HEIGHT do
            maze[i][j] = {left = true, right = true, up = true, down = true}
        end
    end

    -- initially two agents likely to move in opposite directions
    local agents = {{pos = {i = math.floor(GRID_WIDTH / 2), j = GRID_HEIGHT}, alive = true, last = "left"},
                    {pos = {i = math.floor(GRID_WIDTH / 2), j = GRID_HEIGHT}, alive = true, last = "right"}}
    local agentcount = 2
    local movessincesuccess = 0 -- if nothing changes in a few moves, give up
    local unfinished = true
    while unfinished do
        local success = false
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
                    if wallcount(maze[i-1][j]) > 2 then
                        maze[i-1][j]["right"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i-1][j]) then
                        agent.pos.i = i - 1
                    end
                elseif direction == "right" then
                    if wallcount(maze[i+1][j]) > 2 then
                        maze[i+1][j]["left"] = false
                    else walldestroyed = false
                    end
                    if not newsquare(maze[i+1][j]) then
                        agent.pos.i = i + 1
                    end
                elseif direction == "up" then
                    if j == 1 then
                        unfinished = false
                    else
                        if wallcount(maze[i][j-1]) > 2 then
                            maze[i][j-1]["down"] = false
                        else walldestroyed = false
                        end
                        if not newsquare(maze[i][j-1]) then
                            agent.pos.j = j - 1
                        end
                    end
                elseif direction == "down" then
                    if wallcount(maze[i][j+1]) > 2 then
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
                else
                    success = true
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
        if success then
            movessincesuccess = 0
        else
            movessincesuccess = movessincesuccess + 1
            if movessincesuccess > 10 then
                return makemaze() -- give up and try again
            end
        end
    end

    -- Say which squares have ladders etc. so you don't always need to check
    for i=1,GRID_WIDTH do
        for j=1,GRID_HEIGHT do
            maze[i][j].baseimage = "wall"
            if not newsquare(maze[i][j]) then
                if not maze[i][j]["up"] then
                    if not maze[i][j]["down"] then
                        maze[i][j].baseimage = "middleladder"
                    else
                        maze[i][j].baseimage = "topladder"
                    end
                elseif not maze[i][j]["down"] then
                    maze[i][j].baseimage = "bottomladder"
                else
                    maze[i][j].baseimage = "empty" 
                end
            end
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

function opposite(direction)
    if direction == "left" then return "right" end
    if direction == "right" then return "left" end
    if direction == "up" then return "down" end
    if direction == "down" then return "up" end
end
