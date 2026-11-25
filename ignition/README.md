# Ignition

[Cessna 172 home cockpit](../README.md) / `ignition/`

[![Ignition switch](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)

The left one of the two
[switch panel](../switchpanel/README.md) halves. `ignition.scad`: the OFF - R - L -
BOTH - START key switch. The key turns
clockwise; OFF, R, L and BOTH are detents, START is spring loaded and
returns to BOTH.

## How it works

It is built around a cheap mailbox (cabinet) cam lock. These locks turn
only 90°, so the lock is made to turn freely and the assembly has its own
end stops for the whole OFF..START sweep. On the lock used here the stop is
a small tab (about 1 mm) on the plug just behind the face, which runs into
two of the four grooves in the housing: take the cam, its washer and the
cam screw off, pull the plug out with the key in (the small detent ball
falls out, it is not needed), file the tab flush with the plug and put it
back; the printed rotor on the spindle then holds the plug in. The key can
be pulled every 90°, with the key parallel or perpendicular to the body
flats (`lock_key_home`), so the flats of the cutouts in the face, panel
and housing are turned to put one of these positions at OFF. It also
comes out 90° further, at BOTH.

A printed rotor on the lock's spindle sits in a housing behind the panel,
closed by a cover:

- **Detents:** a steel ball, pushed by a spring in a radial channel of the
  housing, drops into notches in the rotor rim. START has no notch.
- **End stops:** a lug on the rotor rim moves in a pocket of the housing.
- **START return:** an M3 screw through the cover is a pin in an arc slot of
  the rotor. From OFF to BOTH it moves freely in the narrow part of the
  slot. Past BOTH it pushes a printed shoe that compresses a spring in the
  wide part, and the spring pushes the key back to BOTH. The shoe is a
  block that fills the slot, with a spigot inside the spring's end, so the
  spring is held centred and cannot slip past the shoe and catch the pin
  screw.
- **Sensing:** a magnet in the rotor lug and one digital hall sensor per
  position in the cover. The sensors (A3144, unipolar, not latching) are
  open collector and pull low over the magnet, so each one is wired like a
  switch to GND. They are glued into pockets on the inside of the cover,
  marked face towards the rotor, and their legs are bent 90° backwards
  through slots in the cover.
- **Sensor boards:** the wires are not soldered to the thin legs but to a
  small piece of prototype board on each sensor (3 x 4 holes, 2.54 mm
  pitch). It slips onto the legs about 5 mm behind the cover
  (`board_z`), where they have spread to 2.54 mm. A printed holder, an
  arc on the back of the cover, has a post under each board, and one M2
  screw through a hole drilled in the board's outer row holds it there.
  The hole is in the OUT leg's column (the A3144 legs are 5 V, GND, OUT
  seen on the marked face), which needs only one wire, so the 5 V and GND
  columns keep two free holes each: one for the wire in, one for the wire
  on to the next board.
  The holder's two ears go under the two cover screws on the switch panel
  side and are clamped by the cap. A 3 x 5 piece works too, with the legs
  in its second row (`board_rows = 5`, `board_leg_row = 1`).
- **Back cap:** a cap over the cover protects the boards, their solder
  joints and the wires. The 7 wires (5 signals, 5 V, GND) leave through a
  slot in its wall towards the switch panel, side by side in one flat row.
  Outside the wall they lie in a groove under a block on the cap, and a
  printed clamp bar under them is pulled up against the block by two M3 x 10
  screws from the back. Tight, the bar sits flat on the block and squeezes
  the wires by `wire_squeeze` (0.25 mm, `wire_d` is the measured diameter
  over the insulation), so pulling them does not pull on the solder joints.
  The cover screws go through the cap as well. The cap goes on only one way
  (the pockets for the holder's ears). The housing also fits the panel
  turned 180° (with the rotor turned to match), but then the slot faces
  away from the switch panel: print the cap with `cable_side = 1` for such
  a housing.

Printed parts: face, panel, housing, rotor, shoe, cover, holder, cap,
cable clamp.

The panel is 97 x 100 mm (the back 77 x 80 mm), with the flange all
round; it used to have none on its right end, where it met the switch
row, so print the panel and its face again. Its front is a separate
1 mm face with the position labels, tick marks and MAGNETOS standing 0.8 mm
out of it around the key, to be painted with a white acrylic paint pen.
The face is printed front side up (the STL is already flipped), the panel
front side down, so neither needs supports; together they are 3 mm thick,
like the switch panel. The mount screws clamp the face onto the panel,
and so does the lock flange (glue or double sided tape it on
as well if it bows); it has holes around the heads of the panel screws.
The lock body goes through
a cutout with flats, so it cannot turn, and the housing sits on the back,
between the rims. The cutout is turned so the key points at OFF
(`key_off_angle`) where it comes out of the lock.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | mailbox / cabinet cam lock | key and spindle (`lock_*`: 18 mm thread, 17 mm body, 25 x 4 mm nut, 8 mm square spindle, its M4 x 5 cam screw with a 12 mm head holds the rotor) |
| 1 | 6 mm steel ball + spring | detent (`detent_spring_*`, spring OD below 6 mm) |
| 1 | spring, 5 mm OD, about 3.8 mm ID, 30 mm (it must not go solid above 11 mm) | START return (`start_spring_*`, measure the ID: the shoe spigot goes inside) |
| 1 | cube magnet, 5 x 5 x 5 mm | position sensing (`magnet_*`) |
| 5 | A3144 hall sensor | one per position (OFF included: it is needed, see [In X-Plane](#in-x-plane)) |
| 1 | prototype board, 2.54 mm pitch | 5 pieces of 3 x 4 holes, one on each sensor's legs |
| 5 | M2 x 6 screw | sensor boards onto the holder |
| 4 | M3 x 30 screw | cap and cover (M3 x 10 to test without the cap) |
| 2 | M3 x 10 screw | wire clamp bar |
| 4 | M3 x 10 screw | panel to housing |
| 1 | M3 x 8 screw | START pin |
| 4 | M3 x 10 pan head screw + nut | panel onto the cockpit sheet |

## Assembly

1. Put the lock through the panel and the housing, screw the panel to the
   housing, tighten the lock nut.
2. Mount the rotor with the lock's cam screw.
3. Insert the ball and its spring, and the START spring with the shoe on
   its end (spigot in the spring, flat face out).
4. Check which magnet face triggers the sensors, then glue in the magnet and
   the sensors.
5. Screw on the cover (M3 x 10 screws to test), then put in the START pin.
6. Drill the outer row hole in the OUT leg's column of each board piece
   to 2.2 mm.
   Put the holder on the cover (ears over the two cover screw holes on the
   switch panel side), slip the boards onto the sensor legs and screw them
   onto the posts with the M2 screws.
7. Solder the legs to the boards and trim them. Solder the wires into the
   next row, each next to its leg, and bridge them to it: 5 V and GND
   chained from board to board, one signal wire each.
8. Lay the wires into the cap's slot, screw on the cap with the M3 x 30
   screws (it clamps the holder's ears), lay the wires side by side in the
   groove under the clamp block and screw the clamp bar up against it with
   the M3 x 10 screws.

OFF, R, L and BOTH are 30° apart, OFF at 10 o'clock and L straight up;
START is 60° past BOTH, straight to the right (3 o'clock), as on the real
switch, its label's letters stacked
downwards beside it.

## In X-Plane

X-Plane's key is spring loaded: writing START (4) to
`sim/cockpit2/engine/actuators/ignition_key` jumps back to BOTH in the next
frame, and MobiFlight cannot hold the starter command. So START goes
through `ignition/ignition.lua`, a FlyWithLua script: it creates the
dataref `cessna172/ignition/start` and holds `sim/starters/engage_starter_1`
while it is 1. Copy it to `X-Plane/Resources/plugins/FlyWithLua/Scripts/`.

In the MobiFlight Connector (pins A0..A4 of the switch panel's Nano, see
[Inputs](../switchpanel/README.md#inputs)):

| Input | On press | On release |
|-------|----------|------------|
| OFF, R, L, BOTH | `sim/cockpit2/engine/actuators/ignition_key[0]` = the position | nothing |
| START | `cessna172/ignition/start` = 1 | `cessna172/ignition/start` = 0 |

Releasing START springs the key back to BOTH, whose sensor sets the key
position again. **VERIFY** the key values (0 is OFF, 3 is BOTH; check
which of 1 and 2 is L) with DataRefTool while turning the key in the
virtual cockpit. Start X-Plane (or reload the Lua scripts) before
connecting MobiFlight, the START dataref only exists once the script has
run. If MobiFlight disconnects in START, the starter keeps cranking until
the key is turned in the cockpit or the scripts are reloaded.
