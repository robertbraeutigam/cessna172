-- Ignition START for X-Plane: holds the starter while the key is in START.
--
-- MobiFlight can only send an X-Plane command once, which cranks for a
-- single frame. So the START input in MobiFlight writes the dataref
-- cessna172/ignition/start (1 on press, 0 on release) and this script
-- holds sim/starters/engage_starter_1 while it is 1.
--
-- Needs the FlyWithLua plugin: copy this file to
-- X-Plane/Resources/plugins/FlyWithLua/Scripts/. Start X-Plane (or reload
-- the scripts) before connecting MobiFlight, the dataref only exists once
-- the script has run.

define_shared_DataRef("cessna172/ignition/start", "Float")
dataref("c172_start", "cessna172/ignition/start", "writable")

local starter = "sim/starters/engage_starter_1"
local cranking = false

function c172_ignition_start()
   if c172_start > 0.5 and not cranking then
      command_begin(starter)
      cranking = true
   elseif c172_start <= 0.5 and cranking then
      command_end(starter)
      cranking = false
   end
end

do_every_frame("c172_ignition_start()")
