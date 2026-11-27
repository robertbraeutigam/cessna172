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
  6 mm rod. Two cheeks on the back of the front plate, one on each side
  of the wheel, frame the wheel's slot: the rod turns in the left one, a
  printed coupler glued onto the rod's right end in the right one.
- **Reading the wheel**: the coupler's other end takes the D shaft of an
  EC11 rotary encoder (the common one with 20 detents a turn), whose
  bushing is clamped with its nut in a plate right of the cheek. Every
  click sends X-Plane's pitch trim up or down command, so the wheel trims
  from wherever the trim is and the [yoke's](../yoke/README.md) electric
  trim rocker trims too, all set up in MobiFlight. On the 120 mm wheel a
  click is about 19 mm of rim, so the detents are barely felt.
- **Resistance**: the bearings and the encoder's plate have slots open to
  the back: the wheel, the rod, the coupler and the encoder go in from
  behind as one, and a printed keeper screwed onto each cheek's back
  closes the slot. Each keeper's tongue has a pocket for a small felt (or
  rubber) pad that presses on the rod or the coupler, so the wheel does
  not spin freely, like the real one. A thicker pad makes it stiffer.
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
| `pedestal.scad` | body (front plate and flange, cheeks, the encoder's plate, the rack's channel, the Nano's rails), face, wheel, coupler, left and right keeper, rack, servo bracket, pinion |

The build checks that the wheel clears the floor, the top and the
slot, the encoder's wires the right wall and its nut the coupler, the pinion and the servo the left
wall, the bracket's posts the pinion, the rack and the servo, the Nano the
floor bolts, the servo and the wheel, and that the face fits the printer.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | EC11 rotary encoder with detents, 20 mm D shaft, with its nut (a bare one, not on a board) | the wheel |
| 2 | felt or rubber pad, 4 x 4 x 1.5 mm (`pad`) | the wheel's resistance |
| 1 | SG90 9 g servo, with its screws | the indicator |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the pedestal |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | 470 uF / 10 V electrolytic capacitor | across the servo's supply |
| 1 | 6 mm steel rod, 24.5 mm (`rod_len`; the throttle's rod) | the wheel's axle |
| 4 | M3 x 10 self tapping screw | keepers onto the cheeks |
| 4 | M3 x 12 self tapping screw | servo bracket onto its posts |
| 7 | M3 x 12 pan head screw + nut | face and flange onto the cockpit sheet |
| 1 | cable tie | the USB cable onto its block |
| - | hookup wire, stranded; CA glue | |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the lower bar (counted in the frame) |

The encoder's sizes (`enc_*`, the
[heading indicator's](../instruments/README.md)) and the servo's
(`sv_*`, the NAV indicator's) are MEASURE values; check them before
printing. The encoder's shaft length (`enc_shaft`) sets the coupler and
the plate: a 15 or 25 mm shaft needs it changed. An encoder on a small
board (KY-040) fits too if the board clears the right wall: the build
checks the bare body's pins (`enc_body`, `enc_wires`).

## Print

Print the body on its face (the front plate on the bed: the walls, the
cheeks, the channel and the posts all stand on it), the face front side
up, the wheel on its web, the rack on its side, the bracket on its front,
the pinion and the keepers flat, the coupler on its collar. The face is dark grey; paint the
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
| D2 | encoder A |
| D3 | encoder B |
| GND | encoder C (the middle pin), servo brown |
| 5V | servo red |
| D9 | servo signal (orange) |

The encoder's push switch pins (if it has them) stay free. Solder the
470 uF capacitor across the servo's red and brown wires near the servo.

**USB**: one port on the powered USB hub. The Nano takes about 20 mA; the servo 0.15-0.3 A while it moves, up to 0.7 A stalled
(see [Connections](../README.md#connections) for servos on a Nano).

## Assembly

1. Glue the wheel onto the rod (`rod_len`, 24.5 mm), its web on the
   left, 6.5 mm from the rod's left end (through the left cheek), and
   the coupler onto the rod's right end, against the hub. Solder the
   wires to the encoder, push its shaft into the coupler and put its nut
   on the bushing, loose. Put a pad into each keeper's pocket (a dab of
   glue).
2. Screw the body into the frame first (the bracket covers the left floor
   bolt): body through the apron sheet's cut-out, the face on the flange,
   the M3 screws through both and the sheet, then the M5 bolts through
   the floor into the lower bar.
3. Wheel, rod, coupler and encoder in from the back as one: the rod into
   the left cheek's slot, the coupler into the right one's, the
   encoder's bushing into its plate's slot (the nut in front of the
   plate). Tighten the nut, the encoder's pins pointing back, and screw
   the keepers on.
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

- an *Encoder* on D2/D3 (the wheel) that sends the X-Plane command
  `sim/flight_controls/pitch_trim_down` on one direction and
  `sim/flight_controls/pitch_trim_up` on the other: rolling the wheel up
  is nose down. Choose the encoder type that gives one step a click
  (most EC11s: one detent per cycle); if it trims backwards, swap the
  commands;
- a *Servo* on D9 (the indicator) fed from
  `sim/cockpit2/controls/elevator_trim` (-1 nose down .. 1 nose up),
  mapped so -1 puts the pointer at the top of its slot and 1 at the
  bottom: 160 degrees of travel round the servo's middle (`sv_sweep`).
  If it moves backwards, swap the two ends. The TAKE OFF mark is at a
  trim of 0.12 (`to_trim`, from the X-Plane 172N's indicator); move it
  in the scad if X-Plane's takeoff trim differs.

How far one click trims is X-Plane's step for the command. Check the
command and dataref names against the Connector's dialog and X-Plane's
dataref list, as they change between versions.
