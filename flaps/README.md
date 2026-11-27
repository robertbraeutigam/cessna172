# Flaps panel

[Cessna 172 home cockpit](../README.md) / `flaps/`

The wing flap lever and the flap position indicator, right of the
throttle like in the 172N.

[![Flaps panel](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)

It looks like the X-Plane 172N's: WING FLAPS down the left side, the
scale UP, 10°, 20°, 30° (FULL), the indicator's white pointer in a
narrow slot beside the scale, and the white lever in a slot right of it.
"AVOID SLIPS WITH FLAPS EXTENDED" is under the slots. The lever sets the
flap handle; the pointer shows where the flaps really are, so after you
move the lever it follows as the flaps run.

- **Lever**: the printed handle's stem goes through the lever slot into
  a block that slides in a channel on the back of the front plate. A
  4 mm steel ball on a spring in the block's side snaps into a notch in
  the channel's wall at UP, 10, 20 and 30 (the detents). A magnet in the
  block's back passes four A3144 hall sensors, one at each detent, on a
  printed strip screwed over the channel's back. The strip also keeps the
  block in. Each sensor is a button to MobiFlight that sets the flap
  handle to its position exactly, with nothing to calibrate (the
  [ignition](../ignition/README.md) reads its key the same way).
- **Indicator**: the pointer is on a carrier that slides in a channel of
  its own beside the lever's, kept in by the same strip. A fin on its
  back, through a slot in the strip, has a slot along its length. A pin
  (an M3 screw) on the arm of a 9 g servo runs in that slot: a scotch
  yoke. As the arm turns, the pointer moves straight up and down by
  `arm_r` × sin(angle), with no gears. 146 degrees of the servo cover the
  44 mm from UP to 30.

There is no box: everything is behind the sheet. The front plate has a
9 mm flange on the left, the right and the bottom, screwed onto the
sheet with M3 screws (nuts behind the sheet). There is no flange at the
top, where the frame's waist bars are behind the sheet. The separate
face, with the lettering standing out of it for a paint pen, goes in
front of the plate on the same screws. Everything else hangs on the
plate's back and goes through the cut-out in the lower right sheet. A
foot along the plate's bottom stands on the frame's throttle bar, two M5
bolts through it into T-nuts in the bar's top slot, so pulling the lever
does not load the sheet alone.

| File | Parts |
|------|-------|
| `flaps.scad` | body (front plate and flange, foot, the lever's and the carrier's channels, the servo's rib, the Nano's rails), face, handle, block, sensor strip, carrier, servo arm |

The build checks that the channels fit the body's height, the servo and
its arm clear the carrier's channel, the fin and the front plate, the
servo stays within the cut-out, the arm is long enough for the travel,
the Nano clears the strip, the arm, the fin and the foot's bolts, the
detent's pocket fits the block and the spring the ball, the hall
sensors are close enough to the magnet and far enough apart, and that
the face fits the printer. It echoes the servo's interpolation table
(`indicator_table`).

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 4 | A3144 hall sensor | the lever's positions |
| 1 | disc magnet 5 x 2 mm (or two 5 x 1 stacked) | in the lever's block |
| 1 | 4 mm steel ball | the detent |
| 1 | compression spring, 3.5 mm OD, 8 mm long (`det_spring`) | the detent |
| 1 | SG90 9 g servo, with its screws | the indicator |
| 1 | 470 uF / 10 V electrolytic capacitor | across the servo's supply |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the panel |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | M3 x 10 socket head screw | the pin on the servo's arm |
| 1 | M3 x 20 countersunk screw | the handle onto the block |
| 2 | M3 x 10 self tapping screw | the sensor strip |
| 4 | M3 x 12 pan head screw + nut | face and plate onto the cockpit sheet |
| 1 | cable tie | the USB cable onto its block |
| - | hookup wire, stranded | |
| 2 | M5 x 10 button head screw + washer + T-nut | foot into the throttle bar (counted in the frame) |

The servo's sizes (`sv_*`, the same as the
[NAV indicator's](../instruments/README.md)), the sensor's and the
magnet's (`sensor`, `magnet`, [`lib/stepper.inc.scad`](../lib/stepper.inc.scad)),
the ball and the spring are MEASURE values; check them before printing.

## Print

The body on its face (the front plate on the bed: the foot, the channels,
the rib and the Nano's rails stand on it), the face front side up, the
handle on its back, the block on its end, the carrier on its front, the
sensor strip and the arm flat. The face is dark grey; paint the
lettering, the pointer's front and the handle white.

## Wiring

The Nano lies in its rails (the shared ones of
[`lib/nano.inc.scad`](../lib/nano.inc.scad)) on the foot behind the
lever, component side up, its USB jack to the back. It slides in from
the back until it stops at the rails' front end. The cable is tied onto
the block behind the plug (`tie_block` of
[`lib/usb.inc.scad`](../lib/usb.inc.scad)), so pulling it does not lever
the jack.

| Nano pin | To |
|----------|----|
| D2 | hall sensor at UP, output |
| D3 | hall sensor at 10°, output |
| D4 | hall sensor at 20°, output |
| D5 | hall sensor at 30°, output |
| D9 | servo signal (orange) |
| 5V | the four sensors' VCC, servo red |
| GND | the four sensors' GND, servo brown |

The A3144 pulls its output to GND near a magnet's south pole, so it
reads like a switch to GND on the Nano's internal pull-up (active low).
Glue the magnet in with its south pole towards the strip (check with one
sensor before gluing). Solder the 470 uF capacitor across the servo's
red and brown wires near the servo.

**USB**: one port on the powered USB hub. The Nano and the sensors take
about 40 mA, the servo 0.15-0.3 A while it moves, up to 0.7 A stalled
(see [Connections](../README.md#connections) for servos on a Nano).

## Assembly

1. Solder the sensors' wires, press the sensors into the strip's pockets
   (flat face to the front, legs out through the slots, bent back), glue
   the magnet into the block's back.
2. Put the panel into the frame: the foot onto the throttle bar through
   the cut-out, the face on the plate, the M3 screws through both and the
   sheet, then the M5 bolts through the foot into the bar.
3. From behind: the ball and the spring into the block's side pocket,
   the block into its channel (press the ball in), the carrier into its
   channel, its pointer through the slot. Screw the strip on, the fin
   through its slot.
4. The handle from the front: its stem through the lever slot into the
   block, the countersunk M3 screw through it into the block.
5. The servo into its rib's window from the left, screwed onto the rib
   with its own screws. Turn it to its middle (MobiFlight's servo test,
   or 90 degrees) with the carrier half way, press the arm onto its
   spline pointing straight back, and screw the pin through the arm into
   the fin's slot, its head on the servo's side. Keep the arm's horn
   screw short (`sv_screw`), it passes the fin.
6. The Nano into its rails, the wires to it, the USB cable plugged in
   and tied onto its block.

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector and give it a
name (*Flaps*). Add:

- four *Buttons* on D2..D5 (the lever), each setting the dataref
  `sim/cockpit2/controls/flap_ratio` on press: 0 (UP), 0.333 (10°),
  0.667 (20°), 1 (30°);
- a *Servo* on D9 (the indicator) fed from the flaps' actual position,
  `sim/cockpit2/controls/flap_handle_deploy_ratio` (0 up .. 1 full),
  through an interpolation table, because a scotch yoke moves the
  pointer by the sine of the angle. The build echoes it
  (`indicator_table`, flap ratio to servo degrees, 90 = arm straight
  back):

  | Flaps | Servo |
  |-------|-------|
  | 0 | 163 |
  | 0.25 | 118.6 |
  | 0.5 | 90 |
  | 0.75 | 61.4 |
  | 1 | 17 |

  If the pointer moves backwards, mirror the servo values (180 minus
  each).

Check the dataref names against the Connector's dialog and X-Plane's
dataref list, as they change between versions.
