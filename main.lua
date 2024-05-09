

local world = require("entities/world")
require("entities/background")
require("entities/player")
require("entities/coin")

local paused = false

local system_key_map = {
    escape = function() 
        love.event.quit() 
    end,
    space = function() 
        paused = not paused 
    end,
}

-- ## LOAD ##
function love.load()
    player.LOAD()
end

-- ## DRAW ##
function love.draw()
    -- ALWAYS pay attention to order of drawing, background needs to be draw first
    background.DRAW()
    coin.DRAW()
    player.DRAW()
end

-- ## KEY PRESSES LISTENER ##
function love.keypressed(pressed_key)
    if system_key_map[pressed_key] then 
        system_key_map[pressed_key]()
    end

    player.INPUT(pressed_key, true)
end

function love.keyreleased(released_key)
    player.INPUT(released_key, false)
end

function love.update(dt)
    player.UPDATE(dt)
    world:update(dt)
end
