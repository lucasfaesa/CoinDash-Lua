
local helpers = require("helpers")

player = {}

local key_map = {
    w = function(down) player.move_input.up = down and -1 or 0 end,
    s = function(down) player.move_input.down = down and 1 or 0 end,
    a = function(down) player.move_input.left = down and -1 or 0 end,
    d = function(down) player.move_input.right = down and 1 or 0 end
}

function player.load()
    player.position = { x = 240, y = 360}
    player.speed = 100
    player.move_input = {up = 0, down = 0, left = 0, right = 0}
    player.size = {width = 22, height = 22}
    player.velocity = {x = 0, y = 0}
    local sprite = love.graphics.newImage("assets/sprites/player/idle/player-idle-1.png")
    sprite:setFilter("nearest", "nearest")
    player.sprite = sprite
end

function player.draw()
    love.graphics.draw(player.sprite, player.position.x, player.position.y)
end

function player.key_press_check(key, pressed_key)
    if key_map[key] then
        key_map[key](pressed_key)
    end
end

function player.move(dt)
    local horizontal_movement = player.move_input.left + player.move_input.right
    local vertical_movement = player.move_input.up + player.move_input.down

  -- Combine into a movement vector
    local movement_vector = {x = horizontal_movement, y = vertical_movement}

  -- Normalize the movement vector (avoid division by zero)
    local magnitude = math.sqrt(movement_vector.x * movement_vector.x + movement_vector.y * movement_vector.y)
    if magnitude > 0 then
        movement_vector.x = movement_vector.x / magnitude
        movement_vector.y = movement_vector.y / magnitude
    end

  -- Apply normalized movement to player position and clamp it

    local new_x_pos = player.position.x + movement_vector.x * player.speed * dt    
    local new_y_pos = player.position.y + movement_vector.y * player.speed * dt

    player.position.x = helpers.clamp(new_x_pos, 0, love.graphics.getWidth() - player.size.width)
    player.position.y = helpers.clamp(new_y_pos, 0, love.graphics.getHeight() - player.size.height)

end

function player.INPUT(key, is_key_pressed)
    if key_map[key] then 
        key_map[key](is_key_pressed)
    end
end

function player.LOAD()
    player.load()
end

function player.UPDATE(dt)
    player.move(dt)
end

function player.DRAW()
    player.draw()
end