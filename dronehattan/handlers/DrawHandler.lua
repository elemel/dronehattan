local sparrow = require("sparrow")

local M = {}

function M.new(engine)
  local database = assert(engine:getProperty("database"))

  local cameraQuery = sparrow.newQuery(database, {
    inclusions = {"angle", "camera", "position", "scale", "viewport"},
    arguments = {"angle", "position", "scale", "viewport"},
  })

  local rectangleQuery = sparrow.newQuery(database, {
    inclusions = {"angle", "color", "position", "size"},
    arguments = {"angle", "color", "position", "size"},
  })

  return function()
    cameraQuery:forEach(function(angle, position, scale, viewport)
      love.graphics.push("all")
      love.graphics.setScissor(viewport.position.x, viewport.position.y, viewport.size.x, viewport.size.y)

      local viewportCenterX = viewport.position.x + 0.5 * viewport.size.x
      local viewportCenterY = viewport.position.y + 0.5 * viewport.size.y

      love.graphics.translate(viewportCenterX, viewportCenterY)

      local cameraViewportScale = scale * viewport.size.y
      love.graphics.scale(cameraViewportScale)
      love.graphics.rotate(-angle)
      love.graphics.translate(-position.x, -position.y)

      rectangleQuery:forEach(function(angle, color, position, size)
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
