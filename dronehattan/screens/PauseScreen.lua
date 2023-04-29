local MenuScreen = require("dronehattan.screens.MenuScreen")

local M = {}

function M.new(application)
  return MenuScreen.new(application, {
    title = "Paused",
    options = {
      {
        title = "Resume",
        handler = function()
          application:popScreen()

          local screen = application:peekScreen()

          if screen then
            local width, height = love.graphics.getDimensions()
            screen:handleEvent("resize", width, height)
          end
        end,
      },

      {
        title = "Toggle fullscreen",
        handler = function()
          love.window.setFullscreen(not love.window.getFullscreen())
        end,
      },

      {
        title = "Quit",
        handler = function()
          application:popScreen()
          application:popScreen()
        end,
      },
    },
  })
end

return M
