requires = {"game", "title", "generate", "useful", "rendermaze", "character", "light"}

local gamestate
local maze

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    for _,j in pairs(requires) do
        require(j)
    end
    gamestate = game
    if gamestate.setup then gamestate.setup() end
end

function love.draw()
    if gamestate.draw then gamestate = gamestate.draw() end
end

function love.update(dt)
    if gamestate.update then gamestate = gamestate.update(dt) end
end

function love.mousepressed(x, y, button, istouch)
    if gamestate.mousepressed then gamestate = gamestate.mousepressed(x, y, button, istouch) end
end

function love.mousereleased(x, y, button, istouch)
    if gamestate.mousereleased then gamestate = gamestate.mousereleased(x, y, button, istouch) end
end

function love.keypressed(key, scancode, isrepeat)
    if gamestate.keypressed then gamestate = gamestate.keypressed(key, scancode, isrepeat) end
end

function love.keyreleased(key)
    if gamestate.keyreleased then gamestate = gamestate.keyreleased(key) end
end

function love.quit()
    local toQuit
    toQuit = false
    if gamestate.quit then gamestate, toQuit = gamestate.quit() end
    return toQuit
end
