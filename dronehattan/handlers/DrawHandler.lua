local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local cameraQuery = sparrow.newQuery(database, {
    inclusions = {"angle", "camera", "position", "scale", "viewport"},
    arguments = {"angle", "position", "scale", "viewport"},
  })

  local droneQuery = sparrow.newQuery(database, {
    inclusions = {"angle", "color", "drone", "position", "size"},
    arguments = {"angle", "color", "position", "size"},
  })

  local triangleVertices = {}

  for i = 1, 3 do
    local angle = 0.5 * math.pi + (i - 1) * 2 * math.pi / 3


  end

  return function()
    cameraQuery:forEach(function(angle, position, scale, viewport)
      love.graphics.push("all")
      love.graphics.setScissor(viewport.position.x, viewport.position.y, viewport.size.x, viewport.size.y)

      local viewportCenterX = viewport.position.x + 0.5 * viewport.size.x
      local viewportCenterY = viewport.position.y + 0.5 * viewport.size.y

      love.graphics.translate(viewportCenterX, viewportCenterY)

      local cameraViewportScale = scale * viewport.size.y
      love.graphics.scale(cameraViewportScale)

      droneQuery:forEach(function(angle, color, position, size)
        love.graphics.push("all")
        love.graphics.translate(position.x, position.y)
        love.graphics.rotate(angle)
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rectangle("fill", -0.5 * size.x, -0.5 * size.y, size.x, size.y)
        love.graphics.pop()
      end)

      love.graphics.pop()
    end)
  end
end

return M