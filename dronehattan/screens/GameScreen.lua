local Class = require("dronehattan.Class")
local DrawHandler = require("dronehattan.handlers.DrawHandler")
local ffi = require("ffi")
local heart = require("heart")
local PauseScreen = require("dronehattan.screens.PauseScreen")
local ResizeHandler = require("dronehattan.handlers.ResizeHandler")
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

  typedef struct ivec2 {
    int32_t x;
    int32_t y;
  } ivec2;

  typedef struct viewport {
    ivec2 position;
    ivec2 size;
  } viewport;
]])

local M = Class.new()

function M:init(application)
  self.application = assert(application)

  local database = sparrow.newDatabase()

  sparrow.newColumn(database, "angle", "float")
  sparrow.newColumn(database, "camera", "tag")
  sparrow.newColumn(database, "car", "tag")
  sparrow.newColumn(database, "color", "color4")
  sparrow.newColumn(database, "drone", "tag")
  sparrow.newColumn(database, "position", "vec2")
  sparrow.newColumn(database, "radius", "float")
  sparrow.newColumn(database, "scale", "float")
  sparrow.newColumn(database, "size", "vec2")
  sparrow.newColumn(database, "velocity", "vec2")
  sparrow.newColumn(database, "viewport", "viewport")

  self.engine = heart.newEngine()
  self.engine:setProperty("application", self.application)
  self.engine:setProperty("database", database)

  self.engine:addEvent("draw")
  self.engine:addEvent("keypressed")
  self.engine:addEvent("keyreleased")
  self.engine:addEvent("resize")
  self.engine:addEvent("update")

  self.engine:addEventHandler("draw", DrawHandler.new(self.engine))
  self.engine:addEventHandler("resize", ResizeHandler.new(self.engine))

  sparrow.newRow(database, {
    angle = 0.25 * math.pi,
    color = {0, 0.5, 1, 1},
    drone = {},
    position = {},
    size = {0.5, 0.5},
    velocity = {},
  })

  sparrow.newRow(database, {
    car = {},
    position = {},
    angle = 0,
    size = {1.8, 4.4},
  })

  sparrow.newRow(database, {
    angle = 0,
    camera = {},
    position = {},
    scale = 0.1,

    viewport = {
      size = {800, 600},
    },
  })
end

function M:handleEvent(event, ...)
  if event == "keypressed" and select(1, ...) == "escape" then
    self.application:pushScreen(PauseScreen.new(self.application))
  else
    return self.engine:handleEvent(event, ...)
  end
end

return M
