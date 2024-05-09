local world = require("entities/world")

coin = {
    tag = "coin",
    -- dynamic just to receive collisions from the player
    body = love.physics.newBody(world, 200,200, 'dynamic'),
    shape = love.physics.newCircleShape(0, 0, 10),
    sprite = love.graphics.newImage('assets/sprites/coin/coin-frame-1.png'),
    scale = { x = 0.35, y = 0.35},
    image_size = {width = 100, height = 100}
}

coin.sprite:setFilter('nearest', 'nearest')
coin.body:setMass(32)

local sprite_offset = {x = (coin.image_size.width * coin.scale.x / 2), y = (coin.image_size.height * coin.scale.y / 2)}

-- Since the radius represents the distance from the center to the edge, we need to ensure that the radius reflects half of the width (or height) of the sprite, not the full width (or height).
local coin_radius = coin.image_size.width * coin.scale.x / 2
coin.shape = love.physics.newCircleShape(0, 0, coin_radius)
coin.fixture = love.physics.newFixture(coin.body, coin.shape)
coin.fixture:setUserData(coin)

function coin.draw()

    -- Center of the circle: We get the center position of the circle using coin.body:getWorldCenter().
    local coin_pos_x, coin_pos_y = coin.body:getWorldCenter()

    --Love2D draw function draws the sprite based on its top-left corner by default, not its center, thats why I needed to position it accordingly, or maybe my change in scale? who knows
    love.graphics.draw(coin.sprite, coin_pos_x - sprite_offset.x, coin_pos_y - sprite_offset.y, 0, coin.scale.x, coin.scale.y)
    love.graphics.circle('line', coin_pos_x, coin_pos_y, coin_radius)
end

function coin.DRAW()
    coin.draw()
end