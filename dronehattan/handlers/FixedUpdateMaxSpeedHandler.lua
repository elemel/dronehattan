local mathMod = require("dronehattan.math")
local sparrow = require("sparrow")

local length = assert(mathMod.length)

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"maxSpeed", "velocity"},
    inclusions = {"maxSpeed", "velocity"},
  })

  return function(dt)
    query:forEach(function(maxSpeed, velocity)
      local speed = length(velocity.x, velocity.y)

      if speed > maxSpeed then
        velocity.x = velocity.x * maxSpeed / speed
        velocity.y = velocity.y * maxSpeed / speed
      end
    end)
  end
end

return M
