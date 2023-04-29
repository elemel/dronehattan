local mathMod = require("dronehattan.math")
local sparrow = require("sparrow")

local mix = assert(mathMod.mix)

local M = {}

function M.new(engine)
  local clock = assert(engine:getProperty("clock"))
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"interpolatedPosition", "position", "previousPosition"},
    inclusions = {"interpolatedPosition", "position", "previousPosition"},
  })

  return function(dt)
    local t = clock.accumulatedDt / clock.fixedDt

    query:forEach(function(interpolatedPosition, position, previousPosition)
      interpolatedPosition.x = mix(previousPosition.x, position.x, t)
      interpolatedPosition.y = mix(previousPosition.y, position.y, t)
    end)
  end
end

return M
