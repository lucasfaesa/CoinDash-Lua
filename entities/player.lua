
local helpers = require("helpers")
local world = require("entities/world")
local cron = require ('third_party.cron')

player = {}


local key_map = {
    w = function(down) player.move_input.up = down and -1 or 0 end,
    s = function(down) player.move_input.down = down and 1 or 0 end,
    a = function(down) player.move_input.left = down and -1 or 0 end,
    d = function(down) player.move_input.right = down and 1 or 0 end
}

local change_sprites_delay = nil
local previous_player_pos = {x = 240, y = 360}
local player_loaded = false
local movement_magnitude = 0
local can_animate_sprites = false

function player.load()
    player.tag = "player"
    player.position = { x = 240, y = 360}
    player.speed = 180
    player.move_input = {up = 0, down = 0, left = 0, right = 0}
    player.image_size = {width = 22, height = 22}
    player.velocity = {x = 0, y = 0}
    
    player.idle_sprites = {}
    player.walking_sprites = {}
    player.current_sprite = {}
    player.set_sprites_sheet()
    

    player.scale = { x = 2.2, y = 2.2}
    player.sprite_offset = {x = (player.image_size.width * player.scale.x / 2), y = (player.image_size.height * player.scale.y / 2)}

    -- physics?? bring it on
    player.body = love.physics.newBody(world, player.position.x, player.position.y, 'kinematic')
    player.shape = love.physics.newRectangleShape(player.image_size.width * player.scale.x, player.image_size.height * player.scale.y)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData(player)
end



function player.set_sprites_sheet()

    --idle sprites
    local idle_sprites = {}
    local numFrames = 4 
    local basePath = "assets/sprites/player/idle/player-idle-"

    for i = 1, numFrames do
        idle_sprites[i] = love.graphics.newImage(basePath .. i .. ".png")
        idle_sprites[i]:setFilter("nearest", "nearest")
    end

    player.current_sprite = idle_sprites[1]
    player.idle_sprites = idle_sprites

    -- walking sprites
    local walking_sprites = {}
    local numFrames = 6 
    local basePath = "assets/sprites/player/run/player-run-"

    for i = 1, numFrames do
        walking_sprites[i] = love.graphics.newImage(basePath .. i .. ".png")
        walking_sprites[i]:setFilter("nearest", "nearest")
    end
    player.walking_sprites = walking_sprites

    change_sprites_delay =  cron.every(0.1, player.animate_player_sprite)
    can_animate_sprites = true
end

local current_sprite_index = 0
function player.animate_player_sprite()
    if(movement_magnitude == 0) then

        current_sprite_index = current_sprite_index + 1
        if current_sprite_index > #player.idle_sprites then
            current_sprite_index = 1
        end

        player.current_sprite = player.idle_sprites[current_sprite_index]
    else
        current_sprite_index = current_sprite_index + 1
        if current_sprite_index > #player.walking_sprites then
            current_sprite_index = 1
        end
        player.current_sprite = player.walking_sprites[current_sprite_index]
    end
end


--player.body:getX(), could use this, instead of 'player.position.x', but i make myself hostage of the position of the body, not that is a bad thing, because the body moves with the player movement, but felt strange, but its good to know that exists
function player.draw()
    if not player_loaded then
        return
    end
    player.update_player_sprite_direction()
    
    love.graphics.draw(player.current_sprite, player.position.x - player.sprite_offset.x, player.position.y - player.sprite_offset.y, 0, player.scale.x, player.scale.y)
    love.graphics.polygon('line', player.body:getWorldPoints(player.shape:getPoints()))
end

function player.update_player_sprite_direction()
    if player.move_input.left < 0 then
        player.scale.x = math.abs(player.scale.x) * -1
        --updating the offset with the new scale
        player.sprite_offset.x = (player.image_size.width * player.scale.x / 2)
    end
    if player.move_input.right > 0 then
        player.scale.x = math.abs(player.scale.x)
        player.sprite_offset.x = (player.image_size.width * player.scale.x / 2)
    end
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
    movement_magnitude = math.sqrt(movement_vector.x * movement_vector.x + movement_vector.y * movement_vector.y)
    if movement_magnitude > 0 then
        movement_vector.x = movement_vector.x / movement_magnitude
        movement_vector.y = movement_vector.y / movement_magnitude
    end

  -- Apply normalized movement to player position and clamp it

    local new_x_pos = player.position.x + movement_vector.x * player.speed * dt    
    local new_y_pos = player.position.y + movement_vector.y * player.speed * dt

    player.position.x = helpers.clamp(new_x_pos, player.image_size.width, love.graphics.getWidth() - player.image_size.width)
    player.position.y = helpers.clamp(new_y_pos, player.image_size.height, love.graphics.getHeight() - player.image_size.height)

end


function player.update_collider()

    if(previous_player_pos.x ~= player.position.x or previous_player_pos.y ~= player.position.y) then
        player.body:setPosition(player.position.x, player.position.y)
        --player.fixture = love.physics.newFixture(player.body, player.shape)
        --player.fixture:setUserData(player)
    end
    
    previous_player_pos = {x = player.position.x, y = player.position.y}
end

function player.INPUT(key, is_key_pressed)
    if not player_loaded then
        return
    end

    if key_map[key] then 
        key_map[key](is_key_pressed)
    end
end

function player.LOAD()
    player.load()
    player_loaded = true
end

function player.UPDATE(dt)
    if not player_loaded then
        return
    end

    player.move(dt)
    player.update_collider()

    if can_animate_sprites then
        change_sprites_delay:update(dt)
    end

end

function player.DRAW()
    player.draw()
end