
local world = require("entities/world")
require("entities/background")
require("entities/player")
require('managers.score_manager')
require('managers/coins_manager')
require('managers.game_manager')
require('managers.time_manager')

main ={}

local paused = false
local in_main_title = true

local system_key_map = {
    escape = function() 
        love.event.quit() 
    end,
    space = function() 
        paused = not paused 
    end,
    ['return'] = function()
        if in_main_title then
            game_manager.start_game()
            in_main_title = false
        end
    end
}

function main.game_ended()
    in_main_title =true
end

-- ## LOAD ##
function love.load()
    --player.LOAD()
    game_manager.LOAD()
    game_manager.main_script_ref = main
    time_manager.LOAD()
    score_manager.LOAD()
    --coins_manager.instantiate_coins(1)
    --game_manager.start_game()
end

-- ## DRAW ##
function love.draw()
    -- ALWAYS pay attention to order of drawing, background needs to be draw first
    background.DRAW()
    coins_manager.DRAW()
    player.DRAW()
    score_manager.DRAW()
    time_manager.DRAW()
    game_manager.DRAW()
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
    if paused then
        return
    end

    if game_manager.can_check_collisions then
        world:update(dt)
    end

    player.UPDATE(dt)
    game_manager.UPDATE(dt)
    coins_manager.UPDATE(dt)
    time_manager.UPDATE(dt)

end
