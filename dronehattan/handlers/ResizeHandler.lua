local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local query = sparrow.newQuery(database, {
    inclusions = {"viewport"},
    arguments = {"viewport"},
  })

  return function(w, h)
  	query:forEach(function(viewport)
  		viewport.size.x = w
  		viewport.size.y = h
  	end)
  end
end

return M
