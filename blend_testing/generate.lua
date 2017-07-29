GRID_WIDTH = 40
GRID_HEIGHT = 30
SQUARE_SIZE = 20
DIRECTIONS = {"up", "down", "left", "right"}
PROBABILITIES = {up = 0.15, down = 0.05, left = 0.4, right = 0.4}
SQUARES = {up = love.graphics.newImage("up.png"),
           down = love.graphics.newImage("down.png"),
           left = love.graphics.newImage("left.png"),
           right = love.graphics.newImage("right.png"),
           wall = love.graphics.newImage("wall.png"),}
NEW_AGENT_PROB = 0.07
DEATH_RATE = 0.05
KEEP_GOING = 1

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

                if i == 1 then probs.left = 0 end
                if i == GRID_WIDTH then probs.right = 0 end
                if j == GRID_HEIGHT then probs.down = 0 end
                if agent.last == "right" then probs.right = probs.right * KEEP_GOING end
                if agent.last == "left" then probs.left = probs.left * KEEP_GOING end
                probs[opposite(agent.last)] = 0

                local direction = makechoice(probs)
                agent.last = direction
                maze[i][j][direction] = false
                
                if direction == "left" then
                    agent.pos.i = i - 1
                    maze[i-1][j]["right"] = false
                elseif direction == "right" then
                    agent.pos.i = i + 1
                    maze[i+1][j]["left"] = false
                elseif direction == "up" then
                    if j == 1 then
                        return maze
                    end
                    agent.pos.j = j - 1
                    maze[i][j-1]["down"] = false
                elseif direction == "down" then
                    agent.pos.j = j + 1
                    maze[i][j+1]["up"] = false
                elseif direction == "none" then
                    agent.alive = false
                end

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
    return maze
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
                    love.graphics.draw(SQUARES[d], (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, 2)
                end
            end
            local square = maze[i][j]
            if square.left and square.right and square.up and square.down then
                love.graphics.draw(SQUARES.wall, (i-1)*SQUARE_SIZE, (j-1)*SQUARE_SIZE, 0, 2)
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