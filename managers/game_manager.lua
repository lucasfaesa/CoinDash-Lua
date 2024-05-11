require('entities.player')
require('managers/coins_manager')
require('managers.time_manager')
local cron = require ('third_party.cron')

game_manager = {}

game_manager.main_script_ref = nil
game_manager.current_level = 1
game_manager.can_check_collisions = false
game_manager.draw_title = true

local next_level_delay = nil
local check_collisions_delay = nil
local update_timer_next_level_delay = false
local update_timer_collisions_delay = false

function game_manager.start_game()
    time_manager.game_started()
    score_manager.reset()
    coins_manager.reset()
    game_manager.current_level = 1

    game_manager.draw_title = false

    game_manager.can_check_collisions = true
    coins_manager.game_manager_ref = game_manager
    time_manager.game_manager_ref = game_manager

    coins_manager.instantiate_coins(game_manager.current_level)
    player.LOAD()
end

function game_manager.start_next_level()
    time_manager.reset_timer()
    game_manager.can_check_collisions = false
    update_timer_next_level_delay = false
    next_level_delay:reset()

    game_manager.current_level = game_manager.current_level + 1

    coins_manager.instantiate_coins(game_manager.current_level)
    game_manager.activate_collision_check_delay()
end

function game_manager.delay_to_next_level()
    next_level_delay = cron.after(0.5, game_manager.start_next_level)
    update_timer_next_level_delay = true
end

function game_manager.activate_collision_check_delay()
    check_collisions_delay = cron.after(0.5, function() 
        game_manager.can_check_collisions = true 
        check_collisions_delay:reset()
    end)
    update_timer_collisions_delay = true
end

function game_manager.update(dt)
    if update_timer_next_level_delay then
        next_level_delay:update(dt)
    end

    if update_timer_collisions_delay then
        check_collisions_delay:update(dt)
    end
end

function game_manager.end_game()
    game_manager.draw_title = true
    player.can_move = false
    game_manager.main_script_ref.game_ended()
end

local kenney_bold_font_header = love.graphics.newFont('assets/fonts/Kenney Bold.ttf', 42)
local kenney_bold_font_subtitle = love.graphics.newFont('assets/fonts/Kenney Bold.ttf', 17)

function game_manager.load()
    
end

function game_manager.draw()
    love.graphics.print("COIN DASH",kenney_bold_font_header ,80,240)
    love.graphics.print("press 'enter' to continue",kenney_bold_font_subtitle ,60,360)
end

function game_manager.DRAW()
    if game_manager.draw_title then
        game_manager.draw()
    end
end

function game_manager.LOAD()
    game_manager.load()
end

function game_manager.UPDATE(dt)
    game_manager.update(dt)
end