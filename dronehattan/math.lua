local M = {}

function M.rotate(x, y, angle)
  local cosAngle = math.cos(angle)
  local sinAngle = math.sin(angle)

  return cosAngle * x - sinAngle * y, sinAngle * x + cosAngle * y
end

function M.length(x, y)
  return math.sqrt(x * x + y * y)
end

function M.normalize(x, y)
  local length = M.length(x, y)
  return x / length, y / length, length
end

return M
