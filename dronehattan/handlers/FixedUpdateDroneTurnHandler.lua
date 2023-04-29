local mathMod = require("dronehattan.math")
local sparrow = require("sparrow")

local rotate = assert(mathMod.rotate)

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"angle", "input", "maxTurnSpeed"},
    inclusions = {"angle", "drone", "input", "maxTurnSpeed"},
    results = {"angle"},
  })

  return function(dt)
    query:forEach(function(angle, input, maxTurnSpeed)
      local turn = (input.right and 1 or 0) - (input.left and 1 or 0)
      return angle + turn * maxTurnSpeed * dt
    end)
  end
end

return M
