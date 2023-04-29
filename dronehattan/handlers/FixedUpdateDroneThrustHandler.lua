local mathMod = require("dronehattan.math")
local sparrow = require("sparrow")

local rotate = assert(mathMod.rotate)

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"angle", "input", "maxAcceleration", "velocity"},
    inclusions = {"angle", "drone", "input", "maxAcceleration", "velocity"},
  })

  return function(dt)
    query:forEach(function(angle, input, maxAcceleration, velocity)
      local thrust = input.up and 1 or 0
      local forwardX, forwardY = rotate(0, -1, angle)
      local acceleration = thrust * maxAcceleration

      local accelerationX = acceleration * forwardX
      local accelerationY = acceleration * forwardY

      velocity.x = velocity.x + accelerationX * dt
      velocity.y = velocity.y + accelerationY * dt
    end)
  end
end

return M
