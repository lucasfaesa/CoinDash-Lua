local begin_contact_callback = function (fixture_a, fixture_b, contact)    
    local name_a = fixture_a:getUserData()
    local name_b = fixture_b:getUserData()
    --print('beginning contact', name_a.tag, name_b.tag, contact)
    --print('collision with: ' .. name_b.tag .. ' and ' .. name_a.tag)

    if(name_b.tag == "coin" and name_a.tag ~= "coin") then
        
        name_b:pickedUp()
    end
end

local pre_solve_callback = function(fixture_a, fixture_b, contact)

end
  
local post_solve_callback = function(fixture_a, fixture_b, contact)

end

local end_contact_callback = function (fixture_a, fixture_b, contact)

end



local world = love.physics.newWorld(0,0)

world:setCallbacks(begin_contact_callback, end_contact_callback, pre_solve_callback, post_solve_callback)

return world