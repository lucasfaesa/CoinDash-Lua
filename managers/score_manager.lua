score_manager = {}

score_manager.currentScore = 0;

local kenney_bold_font = love.graphics.newFont('assets/fonts/Kenney Bold.ttf', 24)

function score_manager.reset()
    score_manager.currentScore = 0;
end

function score_manager.AddPoints(qty)
    score_manager.currentScore = score_manager.currentScore + qty
end

function score_manager.load()
    love.graphics.setFont(kenney_bold_font)
end

function score_manager.draw()
    love.graphics.print("score: " .. score_manager.currentScore ,305,10)
end

function score_manager.LOAD()
    score_manager.load()
end

function score_manager.DRAW()
    score_manager.draw()
end