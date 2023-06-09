local Application = require("dronehattan.Application")
local QuitScreen = require("dronehattan.screens.QuitScreen")
local TitleScreen = require("dronehattan.screens.TitleScreen")

local insert = assert(table.insert)

local application

function love.load()
  love.physics.setMeter(1)
  application = Application.new()

  application:pushScreen(QuitScreen.new(application))
  application:pushScreen(TitleScreen.new(application))
end

function love.draw(...)
  return application:handleEvent("draw", ...)
end

function love.keypressed(...)
  return application:handleEvent("keypressed", ...)
end

function love.keyreleased(...)
  return application:handleEvent("keyreleased", ...)
end

function love.resize(...)
  return application:handleEvent("resize", ...)
end

function love.update(...)
  return application:handleEvent("update", ...)
end
