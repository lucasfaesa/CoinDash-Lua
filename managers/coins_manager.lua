local Coin = require ('entities/coin')

coins_manager = {}

coins_manager.total_coins = 0
coins_manager.current_active_coins = {}
coins_manager.minimum_coins = 6

local screen_size = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}

local data_coin = Coin:new(0,0)
local max_bounds_to_spawn_coins = {width = screen_size.width - (data_coin.image_size.width * data_coin.scale.x), height = screen_size.height - (data_coin.image_size.height * data_coin.scale.y)}
math.randomseed(os.time())

function coins_manager.instantiate_coins(current_level)
    coins_manager.total_coins = coins_manager.minimum_coins + current_level

    for i = 0, coins_manager.total_coins do
        local new_coin = Coin:new(math.random(1,max_bounds_to_spawn_coins.width), math.random(1,max_bounds_to_spawn_coins.height))
        table.insert(coins_manager.current_active_coins, new_coin)
    end 
end

function coins_manager.draw()

    --[[
        ipairs is a Lua built-in function used for iterating over arrays or sequences (tables with sequential numerical indices). 
        It returns three values for each iteration: the current index, the corresponding value, and nil when the end of the array is reached.

        Here's how ipairs is typically used:

        local myArray = {10, 20, 30, 40}
        for index, value in ipairs(myArray) do
            print(index, value)
        end

        This code will output:
        1   10
        2   20
        3   30
        4   40
    ]]

    for i, coin in ipairs(coins_manager.current_active_coins) do
        coin:DRAW()
    end

    -- #working, but above may be better
    --for i = 1, coins_manager.total_coins do
    --    coins_manager.current_active_coins[i]:DRAW()
    --end
end

function coins_manager.DRAW()
    coins_manager.draw()
end