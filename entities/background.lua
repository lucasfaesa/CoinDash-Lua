
background = {
    sprite = love.graphics.newImage("assets/sprites/background/grass.png")    
}

background.sprite:setWrap("repeat", "repeat")

local image_size = {width = background.sprite:getWidth(), height = background.sprite:getHeight()}
local screen_size = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}
local background_quad = love.graphics.newQuad(0, 0, screen_size.width, screen_size.height, image_size.width, image_size.height);

function background.draw()
    love.graphics.draw(background.sprite, background_quad, 0, 0)
end

function background.DRAW()
    background.draw()
end