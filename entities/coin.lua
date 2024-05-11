
local world = require("entities/world")
--require('managers.coins_manager')

-- Define the Coin class
local Coin = {}

-- This line sets the __index metamethod of the Coin table to itself. This is typically done to allow instances of this class to inherit methods from the class table.
Coin.__index = Coin -- Set the metatable for inheritance

function Coin:new(pos_x, pos_y)
    --setmetatable({}, Coin): This line sets the metatable of the {} table to be Coin. This effectively makes {} an instance of the Coin class.
    local coin = setmetatable({}, Coin) -- Create a new instance
    coin.tag = "coin"
    coin.body = love.physics.newBody(world, pos_x, pos_y, 'dynamic')
    --coin.shape = love.physics.newCircleShape(0, 0, 10)
    --coin.sprite = love.graphics.newImage('assets/sprites/coin/coin-frame-1.png')
    coin.scale = { x = 0.35, y = 0.35 }
    coin.image_size = { width = 100, height = 100 }
    coin.is_active = true
    --coin.sprite_sheet = {}
    
    local sprites = {}
    local numFrames = 11 
    local basePath = "assets/sprites/coin/coin-frame-"

    for i = 1, numFrames do
        sprites[i] = love.graphics.newImage(basePath .. i .. ".png")
        sprites[i]:setFilter("nearest", "nearest")
    end
    coin.sprite_sheet = sprites
    coin.sprite = coin.sprite_sheet[1]
    

    coin.sprite_offset = { x = (coin.image_size.width * coin.scale.x / 2), y = (coin.image_size.height * coin.scale.y / 2) }

    -- Since the radius represents the distance from the center to the edge, we need to ensure that the radius reflects half of the width (or height) of the sprite, not the full width (or height).
    coin.radius = coin.image_size.width * coin.scale.x / 2
    coin.shape = love.physics.newCircleShape(0, 0, coin.radius)
    coin.fixture = love.physics.newFixture(coin.body, coin.shape)
    coin.fixture:setUserData(coin)

    return coin
end

local current_sprite_index = 1
local initialTime = love.timer.getTime()
local interval = 0.15
local elapsedTime = 0


function Coin:animate_coin_sprite()
    elapsedTime = love.timer.getTime() - initialTime
    
    if elapsedTime >= interval then
        current_sprite_index = current_sprite_index + 1

        if current_sprite_index > #self.sprite_sheet then
            current_sprite_index = 1
        end

        initialTime = love.timer.getTime()
    end
end

function Coin:draw()
    local coin_pos_x, coin_pos_y = self.body:getWorldCenter()    
    love.graphics.draw(self.sprite_sheet[current_sprite_index], coin_pos_x - self.sprite_offset.x, coin_pos_y - self.sprite_offset.y, 0, self.scale.x, self.scale.y)
    --love.graphics.circle('line', coin_pos_x, coin_pos_y, self.radius)
end

function Coin:activate_coin(x, y)
    self.body:setPosition(x, y)
    self.body:setActive(true)
    self.is_active = true
end

function Coin:deactivate_coin()
    self.body:setActive(false)
    self.is_active = false
end

function Coin:destroy_coin()
    self.fixture:destroy()
    self.body:destroy()
    self.body = nil
    self.is_active = false
end

function Coin:pickedUp()
    coins_manager.coin_picked(self)
end

-- Static method to draw a coin
function Coin:DRAW()
    self:draw()
end

return Coin


--[[
local world = require("entities/world")
require ('managers.score_manager')

coin = {
    tag = "coin",
    -- dynamic just to receive collisions from the player
    body = love.physics.newBody(world, 200,200, 'dynamic'),
    shape = love.physics.newCircleShape(0, 0, 10),
    sprite = love.graphics.newImage('assets/sprites/coin/coin-frame-1.png'),
    scale = { x = 0.35, y = 0.35},
    image_size = {width = 100, height = 100},
    is_active = true
}

coin.sprite:setFilter('nearest', 'nearest')

local sprite_offset = {x = (coin.image_size.width * coin.scale.x / 2), y = (coin.image_size.height * coin.scale.y / 2)}

-- Since the radius represents the distance from the center to the edge, we need to ensure that the radius reflects half of the width (or height) of the sprite, not the full width (or height).
local coin_radius = coin.image_size.width * coin.scale.x / 2
coin.shape = love.physics.newCircleShape(0, 0, coin_radius)
coin.fixture = love.physics.newFixture(coin.body, coin.shape)
coin.fixture:setUserData(coin)

function coin.draw()
    if(not is_active) then
        return
    end
    -- Center of the circle: We get the center position of the circle using coin.body:getWorldCenter().
    local coin_pos_x, coin_pos_y = coin.body:getWorldCenter()

    --Love2D draw function draws the sprite based on its top-left corner by default, not its center, thats why I needed to position it accordingly, or maybe my change in scale? who knows
    love.graphics.draw(coin.sprite, coin_pos_x - sprite_offset.x, coin_pos_y - sprite_offset.y, 0, coin.scale.x, coin.scale.y)
    love.graphics.circle('line', coin_pos_x, coin_pos_y, coin_radius)
end

function coin.pickedUp()
    coin.fixture:destroy()
    coin.body:destroy()
    coin.body = nil
    coin.is_active = false
    score_manager.AddPoints(1)
end

function coin.DRAW()
    coin.draw()
end
]]