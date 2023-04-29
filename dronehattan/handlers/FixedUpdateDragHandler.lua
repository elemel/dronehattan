local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"drag", "velocity"},
    inclusions = {"drag", "velocity"},
  })

  return function(dt)
    query:forEach(function(drag, velocity)
      velocity.x = velocity.x * (1 - drag * dt)
      velocity.y = velocity.y * (1 - drag * dt)
    end)
  end
end

return M
