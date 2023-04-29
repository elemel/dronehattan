local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    arguments = {"input"},
    inclusions = {"input", "player"},
  })

  return function(dt)
    query:forEach(function(input)
      input.up = love.keyboard.isDown("w")
      input.left = love.keyboard.isDown("a")
      input.down = love.keyboard.isDown("s")
      input.right = love.keyboard.isDown("d")
    end)
  end
end

return M
