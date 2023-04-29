local mathMod = require("dronehattan.math")
local sparrow = require("sparrow")

local length = assert(mathMod.length)

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"friction", "velocity"},
    inclusions = {"friction", "velocity"},
  })

  return function(dt)
    query:forEach(function(friction, velocity)
      local speed = length(velocity.x, velocity.y)
      local maxDeltaSpeed = friction * dt

      if speed <= maxDeltaSpeed then
        velocity.x = 0
        velocity.y = 0
      else
        velocity.x = velocity.x * (speed - maxDeltaSpeed) / speed 
        velocity.y = velocity.y * (speed - maxDeltaSpeed) / speed 
      end
    end)
  end
end

return M
