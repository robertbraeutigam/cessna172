# Flaps panel

[Cessna 172 home cockpit](../README.md) / `flaps/`

The wing flap lever and the flap position indicator, right of the
throttle like in the 172N.

[![Flaps panel](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)

It looks like the 172N's placard: WING FLAPS down the left side, a
letter under the other, the scale 0°, 10°, 20°, 30°, 40° (0 to 10 is
twice as long as each step after it, like the real one), the indicator's
white pointer in a narrow slot beside the scale, and the white lever in a
stepped slot right of it. "AVOID SLIPS WITH FLAPS EXTENDED" is under the
slots.

The lever works like the real one: it has no detents, it moves
continuously and stays wherever you leave it, and the flaps follow it.
The slot stops it. From 0 it goes down until it rests on a step at 10°;
moved to the right it goes on down to a second step at 20°; moved to the
right again it goes all the way down to 40° (FULL). A spring holds the
lever to the left, against the steps, and as it comes back up it springs
back left past them. The pointer shows where the flaps really are, so
after you move the lever it follows as the flaps run.

- **Lever**: the printed handle, a flat white paddle that leans down,
  has a square stem. The stem goes through the slot into a slider. The
  slider moves sideways in a pocket of a carriage, and a small spring in
  the carriage's right wall pushes it to the left. The carriage slides up
  and down in a channel on the back of the front plate. The stem rests
  on the slot's edges, so the steps of the printed slot are the stops,
  and the spring pressing the stem on the edge gives the lever its
  friction.
- **Lever sensing**: a 60 mm slide potentiometer (45 mm travel) stands
  right of the channel, snapped into a pocket on the plate's back. Its
  ear points forward into a slot in a tab on the carriage's right side,
  so the pot's slider follows the lever. The wiper goes to the Nano's A0,
  and MobiFlight turns the reading into the flap handle's position
  through a table (`lever_table`, below).
- **Indicator**: the pointer is on a carrier that slides in a channel of
  its own beside the lever's. A strip screwed over both channels' backs
  keeps the carriage and the carrier in. A fin on the carrier's back,
  through a slot in the strip, has a slot along its length. A pin (an M3
  screw) on the arm of a 9 g servo runs in that slot: a scotch yoke. As
  the arm turns, the pointer moves straight up and down by `arm_r` ×
  sin(angle), with no gears. 132 degrees of the servo cover the 42 mm
  from 0 to 40°. The servo sits behind the strip, on a rib that stands on
  the foot.

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
| `flaps.scad` | body (front plate and flange, foot, the lever's and the carrier's channels, the pot's pocket, the servo's rib, the Nano's rails), face, handle, slider, carriage, strip, carrier, servo arm |

The build checks that the channels and the pot fit the body's height,
the lever's travel is within the pot's, the carriage's tab clears the
pot's end ledges and the ear stays in it, the slider's spring has a
preload at the left and does not go solid at the right, the servo clears
the strip and the pot's walls, the arm is long enough for the travel, the
Nano clears the strip, the arm, the fin and the rib, the foot's bolts
clear the rib and the pot, the paddle clears the face, and that the face
fits the printer. It echoes the lever's and the servo's tables
(`lever_table`, `indicator_table`).

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | slide potentiometer, 60 mm long, 45 mm travel, 10 kΩ linear (B10K), with solder tabs at one end (`pot_*`) | the lever's position |
| 1 | compression spring, 4 mm OD, 16 mm long (`lev_spring`) | holds the lever to the left |
| 1 | SG90 9 g servo, with its screws | the indicator |
| 1 | 470 uF / 10 V electrolytic capacitor | across the servo's supply |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the panel |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | M3 x 10 socket head screw | the pin on the servo's arm |
| 1 | M3 x 8 pan head screw | through the slider into the handle's stem |
| 2 | M3 x 10 self tapping screw | the strip |
| 4 | M3 x 12 pan head screw + nut | face and plate onto the cockpit sheet |
| 1 | cable tie | the USB cable onto its block |
| - | hookup wire, stranded | |
| 2 | M5 x 10 button head screw + washer + T-nut | foot into the throttle bar (counted in the frame) |

The pot's sizes (`pot_*`: length, width, thickness, travel, the ear's
size and height, the end caps, the solder tabs) are guesses: measure the
pot before printing the body and the carriage. So are the spring's
(`lev_spring`); a stiffer or longer one makes the lever heavier. The
servo's sizes (`sv_*`) are the same as the
[NAV indicator's](../instruments/README.md).

## Print

The body on its face (the front plate on the bed: the foot, the
channels, the pot's pocket, the rib and the Nano's rails stand on it),
the face front side up, the handle standing on the end of its paddle
(the stem up), the carriage on its front, the slider on its back, the
carrier on its left side, the strip and the arm flat. The face is dark
grey; paint the lettering and the pointer's front white, print the
handle white and the carriage and the slider black (they show through
the slot).

## Wiring

The Nano lies in its rails (the shared ones of
[`lib/nano.inc.scad`](../lib/nano.inc.scad)) on the foot behind the
strip, at the left, component side up, its USB jack to the back. It
slides in from the back until it stops at the rails' front end. The cable
is tied onto the block behind the plug (`tie_block` of
[`lib/usb.inc.scad`](../lib/usb.inc.scad)), so pulling it does not lever
the jack.

| Nano pin | To |
|----------|----|
| A0 | pot wiper (middle tab) |
| D9 | servo signal (orange) |
| 5V | pot end tab, servo red |
| GND | pot other end tab, servo brown |

The `lever_table` assumes the pot reads 0 at its bottom end (the end
with the tabs at the bottom, GND on that end's tab); if it reads the
other way round, swap the two end wires or use 1023 minus each value.
Solder the 470 uF capacitor across the servo's red and brown wires near
the servo.

**USB**: one port on the powered USB hub. The Nano and the pot take
about 25 mA, the servo 0.15-0.3 A while it moves, up to 0.7 A stalled
(see [Connections](../README.md#connections) for servos on a Nano).

## Assembly

1. Solder the pot's wires, snap it into its pocket from behind (its ear
   forward, the tabs down), the lips over its back at its ends.
2. Put the panel into the frame: the foot onto the throttle bar through
   the cut-out, the face on the plate, the M3 screws through both and the
   sheet, then the M5 bolts through the foot into the bar.
3. From behind: the spring into its bore in the carriage's right wall,
   the slider into the pocket against it. Put the carriage into its
   channel at the middle of the travel (its tab through the notch in the
   right wall, the pot's ear into the tab's slot), the slider against the
   plate. The carrier into its channel, its pointer through the slot.
4. The handle from the front: its stem through the lever slot into the
   slider's socket. Screw the M3 pan head screw from behind through the
   slider into the stem (through the slot in the carriage's back).
5. Screw the strip on, the fin through its slot.
6. The servo into its rib's window from the right, screwed onto the rib
   with its own screws. Turn it to its middle (MobiFlight's servo test,
   or 90 degrees) with the carrier half way, press the arm onto its
   spline pointing straight forward, and screw the pin through the arm
   into the fin's slot, its head on the servo's side. Keep the arm's horn
   screw short (`sv_screw`), it passes the fin.
7. The Nano into its rails, the wires to it, the USB cable plugged in
   and tied onto its block.

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector and give it a
name (*Flaps*). Add:

- an *Analog Input* on A0 (the lever) that sets the dataref
  `sim/cockpit2/controls/flap_ratio` (0 up .. 1 = 40°) on change. The
  scale is not linear (0 to 10° is longer), so the reading goes through
  the build's `lever_table`, raw reading to flap ratio:

  | Lever at | Pot | Flap ratio |
  |----------|-----|------------|
  | 0° | 989 | 0 |
  | 10° | 607 | 0.25 |
  | 20° | 416 | 0.5 |
  | 30° | 225 | 0.75 |
  | 40° | 34 | 1 |

  As the value's expression (`@` is the reading):

  ```
  Max(0, Min(1, if(@ > 607, (989 - @) / 382 * 0.25, if(@ > 416, 0.25 + (607 - @) / 191 * 0.25, if(@ > 225, 0.5 + (416 - @) / 191 * 0.25, 0.75 + (225 - @) / 191 * 0.25)))))
  ```

  Check the readings with the lever on each step and at the ends (the
  Connector shows the raw value) and put the measured ones in; the
  steps then always give exactly 10° and 20°.
- a *Servo* on D9 (the indicator) fed from the flaps' actual position,
  `sim/cockpit2/controls/flap_handle_deploy_ratio` (0 up .. 1 full),
  through an interpolation table: the scale is not linear, and a scotch
  yoke moves the pointer by the sine of the angle. The build echoes it
  (`indicator_table`, flap ratio to servo degrees, 90 = arm straight
  forward):

  | Flaps | Servo |
  |-------|-------|
  | 0 | 155.9 |
  | 0.125 | 123.2 |
  | 0.25 | 100.5 |
  | 0.375 | 90 |
  | 0.5 | 79.5 |
  | 0.625 | 68.6 |
  | 0.75 | 56.8 |
  | 0.875 | 43.1 |
  | 1 | 24.1 |

  If the pointer moves backwards, mirror the servo values (180 minus
  each).

Check the dataref names
against the Connector's dialog and X-Plane's dataref list, as they change
between versions.
