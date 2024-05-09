
local helpers = require("helpers")
local world = require("entities/world")

player = {}

local key_map = {
    w = function(down) player.move_input.up = down and -1 or 0 end,
    s = function(down) player.move_input.down = down and 1 or 0 end,
    a = function(down) player.move_input.left = down and -1 or 0 end,
    d = function(down) player.move_input.right = down and 1 or 0 end
}

local previous_player_pos = {x = 240, y = 360}

function player.load()
    player.tag = "player"
    player.position = { x = 240, y = 360}
    player.speed = 100
    player.move_input = {up = 0, down = 0, left = 0, right = 0}
    player.image_size = {width = 22, height = 22}
    player.velocity = {x = 0, y = 0}
    local sprite = love.graphics.newImage("assets/sprites/player/idle/player-idle-1.png")
    sprite:setFilter("nearest", "nearest")
    player.sprite = sprite
    player.scale = { x = 2.2, y = 2.2}
    player.sprite_offset = {x = (player.image_size.width * player.scale.x / 2), y = (player.image_size.height * player.scale.y / 2)}

    -- physics?? bring it on
    player.body = love.physics.newBody(world, player.position.x, player.position.y, 'kinematic')
    player.shape = love.physics.newRectangleShape(player.image_size.width * player.scale.x, player.image_size.height * player.scale.y)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData(player)
end


--player.body:getX(), could use this, instead of 'player.position.x', but i make myself hostage of the position of the body, not that is a bad thing, because the body moves with the player movement, but felt strange, but its good to know that exists
function player.draw()
    love.graphics.draw(player.sprite, player.position.x - player.sprite_offset.x, player.position.y - player.sprite_offset.y, 0, player.scale.x, player.scale.y)
    love.graphics.polygon('line', player.body:getWorldPoints(player.shape:getPoints()))
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

    player.position.x = helpers.clamp(new_x_pos, 0, love.graphics.getWidth() - player.image_size.width)
    player.position.y = helpers.clamp(new_y_pos, 0, love.graphics.getHeight() - player.image_size.height)

end


function player.update_collider()

    if(previous_player_pos.x ~= player.position.x or previous_player_pos.y ~= player.position.y) then
        player.body = love.physics.newBody(world, player.position.x, player.position.y, 'kinematic')
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.fixture:setUserData(player)
    end
    
    previous_player_pos = {x = player.position.x, y = player.position.y}
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
    player.update_collider()
end

function player.DRAW()
    player.draw()
end