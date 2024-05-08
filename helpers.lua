local helpers = {}

function helpers.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

return helpers
