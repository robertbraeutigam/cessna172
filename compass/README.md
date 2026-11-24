# Compass

[Cessna 172 home cockpit](../README.md) / `compass/`

[![Compass](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)

The 172's magnetic ("wet") compass, sized like the Airpath C2300 in the
172N (2.57" square front, about 4" deep). The card is a drum turned by a
28BYJ-48 geared stepper. MobiFlight on an Arduino Nano of its own drives
it from X-Plane's compass heading. The compass stands over the panel on the
frame's right top bar, about where the windshield's middle is (see
[Cockpit frame](../frame/README.md)).

| File | Parts |
|------|-------|
| `compass.scad` | base (floor with the motor posts, sensor post, Nano rails and the ULN2003 plate), shell, bezel, drum, stand; the card print |

## How it works

- **Card**: the drum is an inverted cup, a top disc with a 58 mm band
  hanging from it. It sits over the motor and is pressed onto the shaft
  (double D bore, blind, so the shaft end sets its height). The motor
  stands on two posts under its ears. The card is a paper strip glued
  around the band: white 5° and 10° ticks and N 3 6 E 12 15 S 21 24 W 30
  33 on black. Like on the real compass, the numbers fall to the right (E
  is left of N): the real card stays put while the aircraft turns around
  it, so the stepper turns it counterclockwise (seen from above) as the
  heading grows.
- **Home**: a 6 x 3 mm disc magnet in a pad under the drum's top disc
  passes 1.5 mm over an A3144 hall sensor lying on a post. At start
  MobiFlight turns the card until the sensor pulls low and calls that
  position 0. The strip is glued with N in front there, so it does not
  matter where the magnet sits on the drum or which way the D bore goes on.
- **Window**: round with a flat top and bottom, so only the card shows. A
  1 mm clear sheet is glued into the bezel's front. The lubber line is a
  printed bar behind it, just in front of the card; paint its front white.
  The N-S and E-W compensator screws under the window are dummies.
- **Electronics**: the Nano lies in rails on the floor behind the motor,
  its USB jack in a notch in the back wall. The ULN2003 driver board is
  screwed behind a plate at the back, which hides the board and its LEDs
  from the window. Everything is soldered, and the USB cable is the only
  connection.
- **Own board**: the stepper needs four outputs and a home input, on a
  Nano running MobiFlight, like every component (see
  [Connections](../README.md#connections)). The stepper takes about
  0.2 A at 5 V with its coils on, which USB supplies (the Nano's 5 V pin is
  behind a 0.5 A diode). With the coils switched off at rest (see
  [MobiFlight](#mobiflight)) it only draws that while the card turns and
  stays cool; if it is left on, it gets warm while it holds the card:
  then print the base in PETG if PLA softens near the posts.
- **Parts**: the base is printed flat with everything on it, the shell top
  down (open front and bottom), the bezel back side down (the lubber bar on
  the bed), the drum top down, and the stand on its foot. All black except
  the stand. The bezel's lower screws go into posts on the base, its upper
  ones into blocks in the shell. Two screws from below hold the shell's back
  columns. The stand is screwed onto the base from inside.
- **Size**: 65 x 65 mm front, 108 mm deep (4 mm more than the C2300, for
  the Nano behind the motor), its bottom 25 mm over the top bar (`rise`).

The motor, board, sensor and magnet sizes (`motor_*`, `uln_*`, `sensor`,
`magnet`; the Nano's `nano_*` and its rails are the shared ones of
[`lib/nano.inc.scad`](../lib/nano.inc.scad), here without their lips: it
drops in from above) and the paper and window sheet thicknesses
(`paper_t`, `glass_t`) are MEASURE values. The `assert`s check that the
band clears the motor, its ears, wires and posts, the sensor post and the
side walls; that the pad clears the hub, the band and the ear screws; that
the boards clear each other, the card and the screw columns; that the
stand's screws clear the posts and the Nano; and that the card strip fits
an A4 page.

## The card

`make` writes `target/compass_card.pdf` (also on the
[project page](https://robertbraeutigam.github.io/cessna172/compass/compass_card.pdf)):
three strips on an A4 page, drawn 1:1 in black with the markings as white
paper, and OpenSCAD's scale bar along the edges. Print it at 100 % (no "fit
to page"), check the scale bar with a ruler, and cut out one strip along
its black edges. It is black and white, like the real card, so any printer
will do: matte photo paper or a print shop's sticker vinyl looks best. The
strip is 182.5 mm (the band's circumference at the paper's middle,
`paper_t`) plus a 6 mm plain black end that goes under the other end. With
thicker paper or vinyl, set `paper_t` and print again.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | card |
| 1 | Arduino Nano (ATmega328P, 5 V), USB cable | MobiFlight board of the compass |
| 1 | A3144 hall sensor (unipolar, not latching) | home |
| 1 | disc magnet 6 x 3 mm | home |
| 1 | clear sheet 1 mm (PET or acrylic), 52 x 30 mm | window |
| 1 | the card, printed on paper | card |
| 2 | M3 x 6 self tapping screw | motor ears onto the posts |
| 4 | M3 x 8 self tapping screw | ULN2003 board |
| 10 | M3 x 10 countersunk self tapping screw | bezel (4), base into the shell (2), base onto the stand (4) |
| 2 | M5 x 10 button head screw + T-nut | stand onto the frame's right top bar |

## Assembly

1. Stand onto the base, the screws from inside.
2. Magnet into the drum's pad. Hold the sensor over it first to check which
   face pulls the output low (the sensor's flat, printed face towards the
   magnet). Sensor flat face up into the pocket on its post, legs bent down
   the groove.
3. Motor onto its posts (wires to the back), Nano into its rails (USB to
   the back), ULN2003 board behind its plate (parts towards the back
   wall). Wire them (see [Wiring](#wiring)), coil the motor's cable behind
   the plate and plug it in.
4. Flash and set up MobiFlight (see [MobiFlight](#mobiflight)), and let
   the stepper home with the drum pushed on. Mark the drum's front at the
   notch in the base's front edge, pull the drum off, and glue the card on
   with N on the mark and the plain end under, its top edge flush with the
   drum's top. Press the drum back on.
5. Shell down over it from above, the USB cable through the notch in the
   back wall, two screws from below into the back columns.
6. Glue the clear sheet into the bezel's front, paint the lubber line and
   the lettering, and screw the bezel on.
7. Bolt the stand onto the right top bar (T-nuts in the top slot).

## Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| ULN2003 IN1, IN2, IN3, IN4 | D2, D3, D4, D5 | *Stepper* |
| hall sensor OUT (VCC to 5 V, GND to GND) | D6 | the stepper's home (zero) input |
| ULN2003 + and - | 5 V, GND | |

The motor plugs into the ULN2003 board. The sensor's output is open
collector and pulls low over the magnet; the Nano's internal pull-up is
enough on its short wire. The USB cable goes to the powered USB hub on
the desk.

**USB**: one port on the powered USB hub. With the Nano about 0.25 A
while the card turns (and for a few seconds at start, while it homes),
some 10-20 mA on average in flight with the coils off at rest (see
[MobiFlight](#mobiflight)): the port must give 500 mA, as every port of
the [powered USB hub](../README.md#powered-usb-hub) does.

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector, like the
audio panel's. Add a *Stepper* on D2..D5 with D6 as its home (auto zero)
input, and an output that follows
`sim/cockpit2/gauges/indicators/compass_heading_deg_mag` (X-Plane's wet
compass, with its turning errors) in compass mode, so it takes the short
way round from 359° to 0°. Check the names against the Connector's dialog,
as they change between versions.

- **Steps**: the 28BYJ-48's gearbox is 63.68:1, not 64:1, so a turn is
  about 2038 full steps, not the 2048 that is often given. Set the steps
  per revolution to that, or the card walks a little further off with
  every full turn (it homes again only at start). If it still drifts,
  count: home, turn it 10 times, see how far it is off.
- **Direction**: as the heading grows, the card turns counterclockwise
  seen from above (the numbers under the lubber line grow, E moves in from
  the left). If it turns the wrong way, use the output's transform
  (`360-$`) or give it the pins the other way round (D5..D2).
- **Pin order**: if the motor only hums or shakes, swap the middle pins
  (IN2 and IN3) in the stepper's settings.
- **Coils off at rest**: tick *Disable stepper when at target position*
  in the stepper's settings. The firmware then switches the coils off as
  soon as the card is where it should be, and on again for the next
  move; the 28BYJ-48's gearbox holds the card without power. The motor
  draws current only while it steps (about 2.5 ms a step at the
  firmware's 400 steps a second), so a card that swings all the time
  in flight still takes only some 10-20 mA on average, and the motor and
  the ULN2003 board stay cool (see
  [USB](#wiring)).
- **Fine tuning**: if N is a little off the lubber line after homing,
  add an offset in the transform (e.g. `$+2`) rather than gluing the card
  again.
