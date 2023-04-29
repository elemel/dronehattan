local Class = require("dronehattan.Class")
local DrawHandler = require("dronehattan.handlers.DrawHandler")
local ffi = require("ffi")
local FixedUpdateDragHandler = require("dronehattan.handlers.FixedUpdateDragHandler")
local FixedUpdateFrictionHandler = require("dronehattan.handlers.FixedUpdateFrictionHandler")
local FixedUpdateDroneThrustHandler = require("dronehattan.handlers.FixedUpdateDroneThrustHandler")
local FixedUpdateDroneTurnHandler = require("dronehattan.handlers.FixedUpdateDroneTurnHandler")
local FixedUpdateMaxSpeedHandler = require("dronehattan.handlers.FixedUpdateMaxSpeedHandler")
local FixedUpdatePlayerInputHandler = require("dronehattan.handlers.FixedUpdatePlayerInputHandler")
local FixedUpdatePositionVelocityHandler = require("dronehattan.handlers.FixedUpdatePositionVelocityHandler")
local FixedUpdatePreviousPositionHandler = require("dronehattan.handlers.FixedUpdatePreviousPositionHandler")
local heart = require("heart")
local PauseScreen = require("dronehattan.screens.PauseScreen")
local ResizeHandler = require("dronehattan.handlers.ResizeHandler")
local sparrow = require("sparrow")
local UpdateClockHandler = require("dronehattan.handlers.UpdateClockHandler")
local UpdateInterpolatedPositionHandler = require("dronehattan.handlers.UpdateInterpolatedPositionHandler")

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

  typedef struct input {
    bool up;
    bool left;
    bool down;
    bool right;
  } input;
]])

local M = Class.new()

function M:init(application)
  self.application = assert(application)

  local database = sparrow.newDatabase()

  sparrow.newColumn(database, "angle", "float")
  sparrow.newColumn(database, "camera", "tag")
  sparrow.newColumn(database, "car", "tag")
  sparrow.newColumn(database, "color", "color4")
  sparrow.newColumn(database, "drag", "float")
  sparrow.newColumn(database, "drone", "tag")
  sparrow.newColumn(database, "friction", "float")
  sparrow.newColumn(database, "input", "input")
  sparrow.newColumn(database, "interpolatedPosition", "vec2")
  sparrow.newColumn(database, "maxAcceleration", "float")
  sparrow.newColumn(database, "maxSpeed", "float")
  sparrow.newColumn(database, "maxTurnSpeed", "float")
  sparrow.newColumn(database, "player", "tag")
  sparrow.newColumn(database, "position", "vec2")
  sparrow.newColumn(database, "previousPosition", "vec2")
  sparrow.newColumn(database, "radius", "float")
  sparrow.newColumn(database, "scale", "float")
  sparrow.newColumn(database, "size", "vec2")
  sparrow.newColumn(database, "velocity", "vec2")
  sparrow.newColumn(database, "viewport", "viewport")

  self.engine = heart.newEngine()
  self.engine:setProperty("application", self.application)
  self.engine:setProperty("database", database)

  self.engine:setProperty("clock", {
    fixedDt = 1 / 60,
    accumulatedDt = 0,
    maxAccumulatedDt = 0.1,
  })

  self.engine:addEvent("draw")
  self.engine:addEvent("fixedupdate")
  self.engine:addEvent("keypressed")
  self.engine:addEvent("keyreleased")
  self.engine:addEvent("resize")
  self.engine:addEvent("update")

  self.engine:addEventHandler("draw", DrawHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdatePreviousPositionHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdatePlayerInputHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdateDroneTurnHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdateDroneThrustHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdateDragHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdateFrictionHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdateMaxSpeedHandler.new(self.engine))
  self.engine:addEventHandler("fixedupdate", FixedUpdatePositionVelocityHandler.new(self.engine))
  self.engine:addEventHandler("resize", ResizeHandler.new(self.engine))
  self.engine:addEventHandler("update", UpdateClockHandler.new(self.engine))
  self.engine:addEventHandler("update", UpdateInterpolatedPositionHandler.new(self.engine))

  sparrow.newRow(database, {
    angle = 0,
    color = {0, 0.5, 1, 1},
    drone = {},
    drag = 0.1,
    friction = 0.1,
    input = {},
    interpolatedPosition = {},
    maxAcceleration = 5,
    maxTurnSpeed = 5,
    maxSpeed = 10,
    player = {},
    position = {},
    previousPosition = {},
    size = {0.5, 0.5},
    velocity = {0, 0},
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
