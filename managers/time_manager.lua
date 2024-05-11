time_manager = {}

time_manager.game_time = 10
time_manager.current_time = 0
time_manager.game_manager_ref = nil
time_manager.can_update_timer = false

local kenney_bold_font = love.graphics.newFont('assets/fonts/Kenney Bold.ttf', 17)

function time_manager.game_started()
    time_manager.reset_timer()
end

function time_manager.load()
    love.graphics.setFont(kenney_bold_font)
end

function time_manager.reset_timer()
    time_manager.current_time = time_manager.game_time
    time_manager.can_update_timer = true
end

function time_manager.decrease_time(dt)
    time_manager.current_time = time_manager.current_time - dt

    if(time_manager.current_time <= 0) then
        time_manager.can_update_timer = false
        time_manager.game_manager_ref.end_game()
    end
end

function time_manager.draw()
    love.graphics.print("time: " .. math.floor(math.abs(time_manager.current_time)) ,10,10)
end

function time_manager.LOAD()
    time_manager.load()
end

function time_manager.DRAW()
    time_manager.draw()
end

function time_manager.UPDATE(dt)
    if time_manager.can_update_timer then
        time_manager.decrease_time(dt)
    end
end
