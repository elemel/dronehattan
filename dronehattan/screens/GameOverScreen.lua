local MenuScreen = require("dronehattan.screens.MenuScreen")

local M = {}

function M.new(application)
  return MenuScreen.new(application, {
    title = "Game over",
    options = {
      {
        title = "Restart",
        handler = function()
          application:popScreen()
          application:popScreen()

          local GameScreen = require("dronehattan.screens.GameScreen")
          application:pushScreen(GameScreen.new(application))
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
