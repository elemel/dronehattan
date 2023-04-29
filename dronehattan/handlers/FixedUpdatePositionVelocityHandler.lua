local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"position", "velocity"},
    inclusions = {"position", "velocity"},
  })

  return function(dt)
    query:forEach(function(position, velocity)
      position.x = position.x + velocity.x * dt
      position.y = position.y + velocity.y * dt
    end)
  end
end

return M
