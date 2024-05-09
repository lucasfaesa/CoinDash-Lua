
local begin_contact_callback = function (fixture_a, fixture_b, contact)
    local name_a = fixture_a:getUserData()
    local name_b = fixture_b:getUserData()
    print('beginning contact', name_a.tag, name_b.tag, contact)
end

local end_contact_callback = function (fixture_a, fixture_b, contact)
    local name_a = fixture_a:getUserData()
    local name_b = fixture_b:getUserData()
    print('ending contact', name_a.tag, name_b.tag, contact)
end

local world = love.physics.newWorld(0,0)

world:setCallbacks(begin_contact_callback, end_contact_callback)

return world