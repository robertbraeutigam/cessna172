-- Elevator trim wheel for X-Plane: turns the wheel's angle into trim.
--
-- The pedestal's trim wheel turns a magnet over an AS5600 angle sensor,
-- whose analog output gives the wheel's angle within one turn (0-1023
-- over a turn, no end stops). The MobiFlight analog input on A0 writes
-- that value to the dataref cessna172/trim/wheel; this script adds every
-- change of it to X-Plane's elevator trim, across the 1023 -> 0 wrap, so
-- the wheel can turn any number of times and the yoke's trim rocker (or
-- the mouse) can trim as well.
--
-- Needs the FlyWithLua plugin: copy this file to
-- X-Plane/Resources/plugins/FlyWithLua/Scripts/. Start X-Plane (or reload
-- the scripts) before connecting MobiFlight, the dataref only exists once
-- the script has run.

define_shared_DataRef("cessna172/trim/wheel", "Float")
dataref("c172_trim_wheel", "cessna172/trim/wheel", "writable")
dataref("c172_trim", "sim/cockpit2/controls/elevator_trim", "writable")

local COUNTS = 1024      -- the sensor's counts per turn
local TURNS = 4          -- wheel turns from full nose down to full nose up (to taste)
local SIGN = 1           -- -1 if the wheel trims the wrong way
local NOISE = 2          -- smaller changes are the sensor's noise
local JUMP = 300         -- larger changes in one frame are not a hand turning it (MobiFlight connecting): skipped

local last = nil

function c172_trim_wheel_update()
   local v = c172_trim_wheel
   if last == nil then
      last = v
      return
   end
   local d = v - last
   if d > COUNTS / 2 then
      d = d - COUNTS
   elseif d < -COUNTS / 2 then
      d = d + COUNTS
   end
   if math.abs(d) > JUMP then
      last = v
   elseif math.abs(d) >= NOISE then
      local t = c172_trim + SIGN * d * 2 / (COUNTS * TURNS)
      c172_trim = math.max(-1, math.min(1, t))
      last = v
   end
end

do_every_frame("c172_trim_wheel_update()")
