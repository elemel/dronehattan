local M = {}

function M.new(engine)
  local clock = assert(engine:getProperty("clock"))

  return function(dt)
    clock.accumulatedDt = math.min(clock.accumulatedDt + dt, clock.maxAccumulatedDt)

    while clock.accumulatedDt >= clock.fixedDt do
      clock.accumulatedDt = clock.accumulatedDt - clock.fixedDt
      engine:handleEvent("fixedupdate", clock.fixedDt)
    end
  end
end

return M
