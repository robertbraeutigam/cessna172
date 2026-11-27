# Pedestal

[Cessna 172 home cockpit](../README.md) / `pedestal/`

The top of the 172's pedestal under the throttle: the elevator trim wheel
and the trim indicator, on a panel of their own.

[![Pedestal](https://robertbraeutigam.github.io/cessna172/pedestal/pedestal_montage.png)](https://robertbraeutigam.github.io/cessna172/pedestal/pedestal_montage.png)

Like in the 172 (and the X-Plane 172N), the rim of the trim wheel stands
12 mm out of a tall slot in the face, NOSE DOWN at its top and NOSE UP at
its bottom: rolling it up trims nose down. Left of it the trim indicator,
a white pointer, moves up and down in a narrow slot past the TAKE OFF
mark.

- **Wheel**: 120 mm, printed, with grooves across its rim, glued onto a
  6 mm rod. The rod turns in two cheeks on the back of the front plate,
  one on each side of the wheel, which also frame the wheel's slot. Their
  bearings are slots open to the back: the wheel goes in from behind
  with its rod, and a printed keeper screwed onto each cheek's back closes
  the slot, its tongue on the rod.
- **Reading the wheel**: a printed cap on the rod's right end holds a
  diametric magnet over an AS5600 magnetic angle sensor, screwed onto the
  right cheek's block. No gears, no detents and no end stops: the wheel
  turns smoothly, any number of times. The sensor's analog output gives
  the wheel's angle within a turn; MobiFlight writes it into a dataref
  and a small FlyWithLua script, [`trim.lua`](trim.lua), adds every
  change to X-Plane's elevator trim (see [In X-Plane](#in-x-plane)). So
  the wheel trims from wherever the trim is, and the
  [yoke's](../yoke/README.md) electric trim rocker trims too.
- **Indicator**: a printed rack slides up and down in a channel on the
  back of the front plate, the pointer on its front through the slot. A
  9 g servo on a bracket behind it turns a 24 tooth pinion in the rack:
  160 degrees of the servo move the pointer 33.5 mm from full nose down
  (top) to full nose up (bottom). MobiFlight drives it from X-Plane's
  elevator trim.

The pedestal mounts in the [cockpit frame](../frame/README.md) like the
throttle box: its body goes through a cut-out in the apron sheet under the
throttle and stands on the apron's lower bar. The body's front plate has
a 10 mm flange on the top and the sides, screwed onto the sheet with M3
screws (nuts behind the sheet), and two M5 bolts through its floor go into
T-nuts in the lower bar's top slot. The separate face, with the lettering
standing out of it for a paint pen, goes in front of the flange on the
same screws. The back of the body is open (it is under the desk), and
everything goes in from there.

| File | Parts |
|------|-------|
| `pedestal.scad` | body (front plate and flange, cheeks, the rack's channel, the Nano's rails), face, wheel, magnet cap, keeper (print 2), rack, servo bracket, pinion |
| `trim.lua` | FlyWithLua script: the wheel's angle into the elevator trim |

The build checks that the wheel clears the floor, the top and the
slot, the AS5600's wires the right wall, the pinion and the servo the left
wall, the bracket's posts the pinion, the rack and the servo, the Nano the
floor bolts, the servo and the wheel, and that the face fits the printer.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | AS5600 magnetic angle sensor board (analog output) with its diametric magnet 6 x 2.5 mm | the wheel's angle |
| 1 | SG90 9 g servo, with its screws | the indicator |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the pedestal |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | 470 uF / 10 V electrolytic capacitor | across the servo's supply |
| 1 | 6 mm steel rod, 30.5 mm (`rod_len`; the throttle's rod) | the wheel's axle |
| 4 | M3 x 10 self tapping screw | keepers onto the cheeks |
| 2 | M3 x 6 self tapping screw | AS5600 board onto the right cheek |
| 4 | M3 x 12 self tapping screw | servo bracket onto its posts |
| 7 | M3 x 12 pan head screw + nut | face and flange onto the cockpit sheet |
| 1 | cable tie | the USB cable onto its block |
| - | hookup wire, stranded; CA glue | |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the lower bar (counted in the frame) |

The AS5600 board's and the servo's sizes (`as_*`, `sv_*`, the same as the
[NAV indicator's](../instruments/README.md)) are MEASURE values: the
boards differ between sellers, and so do their holes; check them before
printing.

## Print

Print the body on its face (the front plate on the bed: the walls, the
cheeks, the channel and the posts all stand on it), the face front side
up, the wheel on its web, the rack on its side, the bracket on its front,
the pinion, the cap and two keepers flat. The face is dark grey; paint the
lettering and the pointer's front white.

## Wiring

The Nano lies in its rails (the shared ones of
[`lib/nano.inc.scad`](../lib/nano.inc.scad)) on the floor under the servo,
component side up, its USB jack towards the open back. It slides in from
the back until it stops at the rails' front end; the cable is tied onto the block
behind the plug (`tie_block` of [`lib/usb.inc.scad`](../lib/usb.inc.scad)),
so pulling it does not lever the jack.

| Nano pin | To |
|----------|----|
| 5V | AS5600 VCC, servo red |
| GND | AS5600 GND and DIR, servo brown |
| A0 | AS5600 OUT |
| D9 | servo signal (orange) |

The AS5600's DIR to GND sets the direction of its count; if the wheel
trims the wrong way, set `SIGN = -1` in `trim.lua`. Solder the 470 uF
capacitor across the servo's red and brown wires near the servo.

**USB**: one port on the powered USB hub. The Nano and the AS5600 take
about 30 mA; the servo 0.15-0.3 A while it moves, up to 0.7 A stalled
(see [Connections](../README.md#connections) for servos on a Nano).

## Assembly

1. Glue the wheel onto the rod (`rod_len`, 30.5 mm), its web on the
   left, 6.5 mm from the rod's left end (through the left cheek); glue
   the magnet into the cap and push the cap onto the rod's right end, up
   to its bottom.
2. Screw the body into the frame first (the bracket covers the left floor
   bolt): body through the apron sheet's cut-out, the face on the flange,
   the M3 screws through both and the sheet, then the M5 bolts through
   the floor into the lower bar.
3. Wheel in from the back, the rod into the cheeks' slots; screw the
   keepers on. The AS5600 board onto the right cheek's block, chip
   towards the magnet.
4. The rack into its channel from the back, its pointer through the slot.
   Screw the servo onto the bracket's back (its boss through it), set it
   to its middle (MobiFlight's servo test, or 90 degrees), press the
   pinion onto its spline with the rack at its middle (the pointer half
   way) and screw it on with the servo's horn screw; screw the bracket
   onto its posts.
5. The Nano into its rails, the wires to it, the USB cable plugged in and
   tied onto its block.

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector and give it a
name (*Pedestal*). Add:

- an *Analog input* on A0 (the wheel) that sets the dataref
  `cessna172/trim/wheel` to the raw value (`$`, 0-1023); a small
  sensitivity, so it follows slow turns;
- a *Servo* on D9 (the indicator) fed from
  `sim/cockpit2/controls/elevator_trim` (-1 nose down .. 1 nose up),
  mapped so -1 puts the pointer at the top of its slot and 1 at the
  bottom: 160 degrees of travel round the servo's middle (`sv_sweep`).
  If it moves backwards, swap the two ends. The TAKE OFF mark is at a
  trim of 0.12 (`to_trim`, from the X-Plane 172N's indicator); move it
  in the scad if X-Plane's takeoff trim differs.

Check the dataref names against the Connector's dialog and X-Plane's
dataref list, as they change between versions.

## In X-Plane

The wheel's sensor gives its angle within one turn, but trim needs to
follow the wheel over several turns and still let the yoke's trim rocker
trim. [`trim.lua`](trim.lua) does that: it needs the FlyWithLua (NG)
plugin; copy it to `X-Plane/Resources/plugins/FlyWithLua/Scripts/`. It
creates the dataref `cessna172/trim/wheel` (start X-Plane, or reload the
scripts, before connecting MobiFlight) and every frame adds the change of
the wheel's angle since the last frame to the elevator trim, across the
1023 to 0 step when the wheel goes past it. `TURNS` sets how many wheel
turns go from full nose down to full nose up (4); a jump of more than
`JUMP` counts in one frame (MobiFlight connecting) is skipped, changes
under `NOISE` counts are ignored.
