local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"position", "previousPosition"},
    inclusions = {"position", "previousPosition"},
  })

  return function(dt)
    query:forEach(function(position, previousPosition)
      previousPosition.x = position.x
      previousPosition.y = position.y
    end)
  end
end

return M
