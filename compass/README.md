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
| `compass.scad` | base (floor with the motor posts, sensor post, Nano rails and the ULN2003 plate), shell, bezel, bezel back, drum (the card), stand; the white parts of the bezel (lettering), the bezel back (lubber line) and the drum (marks) as `*_white` STLs |

## How it works

- **Card**: the drum is an inverted cup, a top disc with a 57.5 mm band
  hanging from it. It sits over the motor and is pushed onto the shaft
  (double D bore, 0.25 mm play, `bore_play`, so it slides on by hand). The
  bore goes through the hub: the drum stops where the shaft's flats end,
  and to take it off, a pin pushed in from the top onto the shaft's end
  pushes it off without pulling on the motor. Four windows in the top
  disc, between spokes, show the motor and the sensor beside the magnet
  pad, so the gap can be checked. The motor
  stands on two posts under its ears. The band is the card: printed in
  black, its 5° and 10° ticks (1 mm wide) and N 3 6 E 12 15 S 21 24 W 30
  33 stand 0.6 mm out of it (`mark_h`), painted white. Like on the real
  compass, the numbers fall to the right (E is left of N): the real card
  stays put while the aircraft turns around it, so the stepper turns it
  counterclockwise (seen from above) as the heading grows.
- **Home**: a 5 x 2 mm magnet (two 5 x 1 mm discs stacked) in a pad under the drum's top disc
  passes 1.5 mm over an A3144 hall sensor lying on a post, centred in
  its pocket (the legs' channel is narrower than its body). At start
  MobiFlight turns the card until the sensor pulls low and calls that
  its zero. Wherever N is then, an offset in the output's transform puts
  it under the lubber line (see [MobiFlight](#mobiflight)), so it does not
  matter where the magnet sits on the drum or which way the D bore goes on.
- **Window**: round with a flat top and bottom, so only the card shows. A
  1 mm clear sheet lies in a pocket in the bezel back's front (a 2 mm
  plate with the same window, a 1 mm ledge round it behind the glass),
  and the bezel (2 mm, flat behind) holds it there, so it needs no glue
  and its edges are hidden 2 mm behind the bezel's front all round: cut it with scissors or a knife and a ruler, only not
  bigger than 52 x 30 mm. The lubber line is a printed bar across the
  bezel back's window, just in front of the card; paint its front white.
  The N-S and E-W compensator screws under the window are dummies.
- **Electronics**: the Nano lies in rails on the floor behind the motor,
  its USB jack in a notch in the back wall. The ULN2003 driver board is
  screwed behind a plate at the back, which hides the board and its LEDs
  from the window. The wires are soldered onto the Nano and end in
  female Dupont plugs on the ULN2003 board's pins and the sensor's legs,
  so it all comes apart. The plate stands far enough in front of the
  back wall for the plugs and their wires' bend (`uln_plug_room`, MEASURE),
  2 mm or more behind the card.
- **Own board**: the stepper needs four outputs and a home input, on a
  Nano running MobiFlight, like every component (see
  [Connections](../README.md#connections)). The stepper takes about
  0.2 A at 5 V with its coils on, which USB supplies (the Nano's 5 V pin is
  behind a 0.5 A diode). With the coils switched off at rest (see
  [MobiFlight](#mobiflight)) it only draws that while the card turns and
  stays cool; if it is left on, it gets warm while it holds the card:
  then print the base in PETG if PLA softens near the posts.
- **Parts**: the base is printed flat with everything on it, the shell top
  down (open front and bottom), the bezel and the bezel back back side down
  (the bezel's lettering on top, its back flat on the bed; the bezel
  back's pocket open on top, the lubber bar on the bed), the drum top down, and the stand on its foot. All black except
  the stand and the white parts (see [Two colours](#two-colours)). The bezel's lower screws go into posts on the base, its upper
  ones into blocks in the shell. Two screws from below hold the shell's back
  columns. The stand is screwed onto the base from inside.
- **Size**: 65 x 65 mm front, 109 mm deep (5 mm more than the C2300, for
  the Nano behind the motor), its bottom 25 mm over the top bar (`rise`).

The motor, board, sensor and magnet sizes (`motor_*`, `uln_*`, `sensor`,
`magnet`: the shared ones of [`lib/stepper.inc.scad`](../lib/stepper.inc.scad),
the instruments' too; the Nano's `nano_*` and its rails are the shared
ones of [`lib/nano.inc.scad`](../lib/nano.inc.scad), here without their
lips: it drops in from above) and the window sheet's thickness
(`glass_t`) are MEASURE values. The `assert`s check that the
band clears the motor, its ears, wires and posts, the sensor post, and
with its marks the side walls and the lubber line; that the pad clears
the hub, the band and the ear screws; that the boards clear each other,
the card and the screw columns; and that the stand's screws clear the
posts and the Nano.

The case was first printed around a paper card glued onto a 58 mm band.
Its sizes stay as they were (`bz_back`, the axis to the bezel back), and
the band is 0.5 mm smaller so the marks clear the side walls by 0.65 mm;
only the drum is new. The notch in the base's front edge was the paper
card's front mark and has no use now.

## Two colours

The drum's marks, the bezel's lettering and the lubber line are white,
the rest black. An STL has no colour (a slicer shows it in its first
filament's colour), so each of these parts is two STLs in the same place
on the bed: the black part (`compass_drum.stl`, `compass_bezel.stl`,
`compass_bezel_back.stl`) and its white part (`compass_drum_white.stl`,
`compass_bezel_white.stl`, `compass_bezel_back_white.stl`). The white part
fills pockets in the black one, so they do not overlap.

In the slicer (Anycubic Slicer Next, like Orca and Bambu Studio), select
both files of a part and open them together. When it asks whether to load
them as a single object with multiple parts, say yes; otherwise select
both objects and *Assemble* them. Then give the white part the white
filament in the object list (the part's filament column), and the black
part the black one. Do not move or scale the parts against each other.

- **Drum**: the marks stand 0.6 mm out of the band and go 0.6 mm into it,
  so they are 1.2 mm of white seen from the front (thinner white looks
  grey over black). Printed top down, every layer of the band has both
  colours.
- **Bezel**: the lettering stands 0.6 mm out of the front and goes 0.6 mm
  in; printed back side down it is only the top layers.
- **Bezel back**: the lubber bar, its ends 1.5 mm into the ledge above and
  under the window, through the ledge's whole thickness.

With one colour, print both files of a part in black and paint the marks,
the lettering and the lubber line white: wipe a nearly dry flat brush with
white acrylic across the raised marks, or use a white paint pen.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | card |
| 1 | Arduino Nano (ATmega328P, 5 V), USB cable | MobiFlight board of the compass |
| 1 | A3144 hall sensor (unipolar, not latching) | home |
| 2 | disc magnet 5 x 1 mm | home (two stacked) |
| 1 | clear sheet 1 mm (PET or acrylic), 52 x 30 mm, no glue | window |
| 1 | white filament, or white acrylic paint / a white paint pen with one colour | the card's marks, lubber line, lettering |
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
4. Push the drum onto the shaft until it stops, any way round, the flats
   lined up (one colour: paint its marks first, see
   [Two colours](#two-colours)). Do not force it: if it is tight, turn a
   5 mm drill bit by hand in the bore; if it turns on the shaft, a drop
   of thin CA glue on the shaft. Flash and set up MobiFlight (see
   [MobiFlight](#mobiflight)), let it home and set the N offset.
5. Shell down over it from above, the USB cable through the notch in the
   back wall, two screws from below into the back columns.
6. With one colour, paint the lubber line and the lettering. Lay the bezel back on its
   back, the clear sheet into its pocket (film off, no fingerprints), the
   bezel on it, and screw both on together.
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
- **N offset**: after homing the card is wherever the magnet put it, so
  set its direction first, then the offset. With the output's value at 0
  (the Connector's test value, or the airplane heading north), read the
  card under the lubber line, say `r` degrees (N = 0, 3 = 30, ... 33 =
  330; between ticks as well as you can). Then make the transform
  `($+360-r)%360` (for `r` = 40: `($+320)%360`; with the direction
  reversed, `(720-$-r)%360`) and check N again. The `%360` keeps the value
  in 0..359 for the compass mode. The sensor trips at the same place at
  every start, so the offset holds; it changes only if the drum is pulled
  off and pressed on again, or the magnet moves.
