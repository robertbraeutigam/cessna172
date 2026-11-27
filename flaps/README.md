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

- **Lever**: an arm swinging on a 6 mm steel rod 85 mm behind the face,
  like the real one (its cam and switches turn on a pivot behind the
  panel). The paddle, a flat white handle like the 172's, is level at 0°
  and leans down as the lever goes down, 26° at 40°; as it swings it
  comes closer to the face. The rod is fixed in two walls on the foot,
  and the lever's hub turns and slides on it. A spring on the rod between
  the hub and the right wall pushes the lever to the left, so the stem
  rests on the slot's edges: the steps of the printed slot are the stops,
  and the spring pressing the stem on the edge and on the hub gives the
  lever its friction. The lever (hub, arm, stem and a gear sector) is one
  print; the paddle is pushed onto the stem in front of the face and
  screwed across.
- **Lever sensing**: the gear sector under the hub turns a pinion on a
  16 mm rotary potentiometer in the left wall, 5:1, so the lever's 26°
  turn the pot 131° (about 450 steps from 0 to 40°). The pinion is wider
  than the sector by the lever's sideways travel, so they stay in mesh
  when the lever moves to the right. The wiper goes to the Nano's A0, and
  MobiFlight turns the reading into the flap handle's position through a
  table (`lever_table`, below).
- **Indicator**: the pointer is on a carrier that slides in a channel
  left of the lever slot, kept in by a strip screwed over it. Behind the
  strip a yoke plate is screwed onto the carrier's post. A pin (an M3
  screw) on the arm of a 9 g servo runs in the yoke's horizontal slot: a
  scotch yoke. As the arm turns, the pointer moves straight up and down
  by `arm_r` × sin(angle), with no gears. 132 degrees of the servo cover
  the 42 mm from 0 to 40°. The servo, its shaft pointing at the plate,
  sits on a rib off the left wall.

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
| `flaps.scad` | body (front plate and flange, foot, the carrier's channel, the rod's walls (the left one holds the pot), the servo's rib, the Nano's rails), face, lever, paddle, pinion, strip, carrier, yoke, servo arm |

The build checks that the carrier's channel and the walls fit the body,
the pot turns less than its range and its shaft reaches across the
pinion, the lever's spring has a preload at the left and does not go
solid at the right, the lever's arm clears the pinion at 40°, the paddle
clears the face at 0° and at 40°, the servo, its arm and the yoke clear
the lever and the pot, the Nano and its plug clear the walls, the pot,
the servo's arm and the yoke, the foot's bolts clear the walls, and that
the face fits the printer. It echoes the lever's and the servo's tables
(`lever_table`, `indicator_table`).

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | rotary potentiometer, 16 mm, 10 kΩ linear (B10K), M7 bushing, 6 mm D shaft 20 mm long (`pot_*`) | the lever's position |
| 1 | steel rod, 6 mm, 35 mm long | the lever's pivot |
| 1 | compression spring over the 6 mm rod, 9 mm OD, 20 mm long (`lev_spring`) | holds the lever to the left |
| 1 | SG90 9 g servo, with its screws | the indicator |
| 1 | 470 uF / 10 V electrolytic capacitor | across the servo's supply |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the panel |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | M3 x 10 socket head screw | the pin on the servo's arm |
| 1 | M3 x 16 screw + nut | the paddle onto the stem, across |
| 1 | M3 x 10 countersunk self tapping screw | the yoke onto the carrier |
| 2 | M3 x 10 self tapping screw | the strip |
| 4 | M3 x 12 pan head screw + nut | face and plate onto the cockpit sheet |
| 1 | cable tie | the USB cable onto its block |
| - | hookup wire, stranded | |
| 2 | M5 x 10 button head screw + washer + T-nut | foot into the throttle bar (counted in the frame) |

The pot's sizes (`pot_*`: body, bushing, nut, shaft length and flat,
anti-rotation tab) are guesses: measure the pot before printing the body
and the pinion; the shaft must be long enough to reach across the pinion
(the build checks it). So are the spring's (`lev_spring`); a stiffer one
makes the lever heavier. The servo's sizes (`sv_*`) are the same as the
[NAV indicator's](../instruments/README.md).

## Print

The body on its face (the front plate on the bed: the foot, the channel,
the walls, the servo's rib and the Nano's rails stand on it), the face
front side up, the lever on its left side, the paddle on its underside,
the pinion on its end, the carrier on its left side, the yoke, the strip
and the servo arm flat. The face is dark grey; paint the lettering and
the pointer's front white, print the paddle white and the lever black (it
shows through the slot).

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
| A0 | pot wiper (middle lug) |
| D9 | servo signal (orange) |
| 5V | pot end lug, servo red |
| GND | pot other end lug, servo brown |

The `lever_table` assumes the reading rises as the lever goes down; if
it falls, swap the pot's two end wires or use 1023 minus each value.
Solder the 470 uF capacitor across the servo's red and brown wires near
the servo.

**USB**: one port on the powered USB hub. The Nano and the pot take
about 25 mA, the servo 0.15-0.3 A while it moves, up to 0.7 A stalled
(see [Connections](../README.md#connections) for servos on a Nano).

## Assembly

1. Solder the pot's wires, put it into the left wall from the left (its
   tab in the wall's slot), the nut on its bushing on the right, and press
   the pinion onto its shaft. Turn the pot to its middle.
2. Put the panel into the frame: the foot onto the throttle bar through
   the cut-out, the face on the plate, the M3 screws through both and the
   sheet, then the M5 bolts through the foot into the bar.
3. From behind: the lever's stem through the lever slot, half way down
   (the sector over the pinion, meshed), the rod from the left through the
   left wall, the lever's hub and the spring into the right wall's blind
   hole; a drop of glue at the left wall keeps it.
4. The paddle onto the stem in front of the face, the M3 screw across
   through both.
5. The carrier into its channel, its pointer through the slot, the strip
   screwed on over it, the yoke screwed onto the carrier's post through
   the strip's slot (countersunk screw).
6. The servo into its rib's window from behind, screwed onto the rib with
   its own screws. Turn it to its middle (MobiFlight's servo test, or 90
   degrees) with the carrier half way, press the arm onto its spline
   pointing right, and screw the pin through the arm into the yoke's slot,
   its head behind the arm.
7. The Nano into its rails, the wires to it, the USB cable plugged in
   and tied onto its block.

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector and give it a
name (*Flaps*). Add:

- an *Analog Input* on A0 (the lever) that sets the dataref
  `sim/cockpit2/controls/flap_ratio` (0 up .. 1 = 40°) on change. The
  scale is not linear (0 to 10° is longer), so the reading goes through
  the build's `lever_table`, raw reading to flap ratio (the pot's middle
  at the lever's middle, 300° of travel):

  | Lever at | Pot | Flap ratio |
  |----------|-----|------------|
  | 0° | 287 | 0 |
  | 10° | 478 | 0.25 |
  | 20° | 569 | 0.5 |
  | 30° | 655 | 0.75 |
  | 40° | 736 | 1 |

  As the value's expression (`@` is the reading):

  ```
  Max(0, Min(1, if(@ < 478, (@ - 287) / 191 * 0.25, if(@ < 569, 0.25 + (@ - 478) / 91 * 0.25, if(@ < 655, 0.5 + (@ - 569) / 86 * 0.25, 0.75 + (@ - 655) / 81 * 0.25)))))
  ```

  Check the readings with the lever on each step and at the ends (the
  Connector shows the raw value) and put the measured ones in; the
  steps then always give exactly 10° and 20°.
- a *Servo* on D9 (the indicator) fed from the flaps' actual position,
  `sim/cockpit2/controls/flap_handle_deploy_ratio` (0 up .. 1 full),
  through an interpolation table: the scale is not linear, and a scotch
  yoke moves the pointer by the sine of the angle. The build echoes it
  (`indicator_table`, flap ratio to servo degrees, 90 = arm pointing
  right):

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
