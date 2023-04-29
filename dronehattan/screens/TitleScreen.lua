local GameScreen = require("dronehattan.screens.GameScreen")
local MenuScreen = require("dronehattan.screens.MenuScreen")

local M = {}

function M.new(application)
  return MenuScreen.new(application, {
    title = "Dronehattan",
    options = {
      {
        title = "Play",
        handler = function()
          local screen = GameScreen.new(application)
          application:pushScreen(screen)

          local width, height = love.graphics.getDimensions()
          screen:handleEvent("resize", width, height)
        end,
      },

      {
        title = "Toggle fullscreen",
        handler = function()
          love.window.setFullscreen(not love.window.getFullscreen())
        end,
      },

      {
        title = "Exit",
        handler = function()
          application:popScreen()
        end,
      },
    },
  })
end

return M
