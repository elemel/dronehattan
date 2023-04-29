local MenuScreen = require("dronehattan.screens.MenuScreen")

local M = {}

function M.new(application)
  return MenuScreen.new(application, {
    title = "You win",
    options = {
      {
        title = "Continue",
        handler = function()
          application:popScreen()
          application:popScreen()
        end,
      },
    },
  })
end

return M
