local Class = require("dronehattan.Class")
local ffi = require("ffi")
local heart = require("heart")
local PauseScreen = require("dronehattan.screens.PauseScreen")
local sparrow = require("sparrow")

ffi.cdef([[
  typedef struct color4 {
    float r;
    float g;
    float b;
    float a;
  } color4;

  typedef struct tag {} tag;

  typedef struct vec2 {
    float x;
    float y;
  } vec2;
]])

local M = Class.new()

function M:init(application)
  self.application = assert(application)

  local database = sparrow.newDatabase()

  sparrow.newColumn(database, "color", "color4")
  sparrow.newColumn(database, "position", "vec2")

  self.engine = heart.newEngine()
  self.engine:setProperty("application", self.application)
  self.engine:setProperty("database", database)

  self.engine:addEvent("draw")
  self.engine:addEvent("keypressed")
  self.engine:addEvent("keyreleased")
  self.engine:addEvent("resize")
  self.engine:addEvent("update")
end

function M:handleEvent(event, ...)
  if event == "keypressed" and select(1, ...) == "escape" then
    self.application:pushScreen(PauseScreen.new(self.application))
  else
    return self.engine:handleEvent(event, ...)
  end
end

return M
