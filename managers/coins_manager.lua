local Coin = require ('entities/coin')
--require('managers.game_manager')
require('managers/score_manager')


coins_manager = {}

coins_manager.game_manager_ref = nil
coins_manager.total_coins = 0
coins_manager.picked_up_coins = 0
coins_manager.current_active_coins = {}
coins_manager.minimum_coins = 6
coins_manager.coin_to_be_deactivated = {}

local screen_size = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}

local data_coin = Coin:new(0,0)
local max_bounds_to_spawn_coins = {width = screen_size.width - (data_coin.image_size.width * data_coin.scale.x), height = screen_size.height - (data_coin.image_size.height * data_coin.scale.y)}
math.randomseed(os.time())

local has_coins_to_deactivate = false


function coins_manager.instantiate_coins(current_level)

    coins_manager.total_coins = coins_manager.minimum_coins + current_level
    
    --#coins_manager.current_active_coins é igual a coins_manager.current_active_coins.Count() em c#
    for i = #coins_manager.current_active_coins, coins_manager.total_coins - 1 do
        local new_coin = Coin:new(-1000,-1000)
        table.insert(coins_manager.current_active_coins, new_coin)
    end 

    for i, coin in ipairs(coins_manager.current_active_coins) do
        coin:activate_coin(math.random(1,max_bounds_to_spawn_coins.width), math.random(1,max_bounds_to_spawn_coins.height))
    end

end

function coins_manager.coin_picked(coin)

    table.insert(coins_manager.coin_to_be_deactivated, coin)
    has_coins_to_deactivate = true
end

function coins_manager.check_coins_pickup()
    print('picked: ' .. coins_manager.picked_up_coins  .. 'total ' .. coins_manager.total_coins)
    if(coins_manager.picked_up_coins == coins_manager.total_coins) then
        coins_manager.reset()
        coins_manager.game_manager_ref.delay_to_next_level()
    end
end

function coins_manager.reset()
    coins_manager.total_coins = 0
    coins_manager.picked_up_coins = 0
    coins_manager.current_active_coins = {}
end

function coins_manager.check_if_need_to_deactivate_coins()

    if has_coins_to_deactivate then
        for i, coin in ipairs(coins_manager.coin_to_be_deactivated) do
            coin:deactivate_coin()

            coins_manager.picked_up_coins = coins_manager.picked_up_coins + 1
            score_manager.AddPoints(1)
        end
        coins_manager.check_coins_pickup()

        coins_manager.coin_to_be_deactivated = {}
        has_coins_to_deactivate = false
    end


end

function coins_manager.draw()
    for i, coin in ipairs(coins_manager.current_active_coins) do
        if(coin.is_active) then
            --print(i)
            coin:DRAW()
        end
    end

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

    -- #working, but above may be better
    --for i = 1, coins_manager.total_coins do
    --    coins_manager.current_active_coins[i]:DRAW()
    --end
    
end

function coins_manager.DRAW()
    coins_manager.draw()
end

function coins_manager.UPDATE()
    coins_manager.check_if_need_to_deactivate_coins()
end