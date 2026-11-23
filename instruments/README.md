# Instruments

[Cessna 172 home cockpit](../README.md) / `instruments/`

[![RPM indicator](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)

[![Airspeed indicator](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)

The analogue ("steam") instruments. They all follow one standard
(`instrument.inc.scad`): a 3 1/8" case behind a round hole in the panel,
a colour printed face, and a needle turned by a 28BYJ-48 geared stepper.
So far: the RPM indicator (tachometer) and the airspeed indicator (ASI). The instruments go into
the holes of the stage 2 left sheet (see
[Cockpit frame](../frame/README.md)): the stage 1 sheet is lower and its
top bar is in the way.

| File | Parts |
|------|-------|
| `instrument.inc.scad` | the standard: case, dial, needle, gears, back plate, board carrier in two layouts (`arm`, `deep`); the face's colour layers and print page |
| `rpm.scad` | the RPM indicator (`arm` layout): its face and the parts above; the face print |
| `asi.scad` | the airspeed indicator (`deep` layout): its face and the parts above; the face print |

## How it works

- **Case**: like a real instrument, the case goes into the panel's 81 mm
  hole from behind, with its front flush with the panel's front. Four
  black M3 screws go through the sheet into its ears on the diagonals, so
  they show like the screws on the real panel. Behind the sheet it is
  84 mm round, so the instruments fit on the 172N's 89 mm (3.5") centres.
  The RPM indicator is the tightest: 86 mm from the instrument above it.
- **Front to back**: the lip (72 mm window), a 1 mm clear sheet (the
  glass), the needle, the face, the dial. The dial is a shallow cup:
  its rim holds the glass against the lip and the paper face is glued in
  it. Three posts on the back plate press the dial forward, and the back
  plate is screwed into the case from behind, so nothing is glued but the
  face.
- **Drive**: the needle is pressed onto a 3 mm steel axle, which turns in
  the dial and in the back plate. The axle carries the needle gear, and a
  motor gear of the same size (1:1) beside it turns it. The 28BYJ-48 sits
  on the back plate's back. A 1:1 drive keeps the motor's resolution
  (about 0.18 degrees a step), and the needle turns the other way from
  the motor.
- **Two layouts** (`layout`, set by each instrument's file): the case
  with the gears is 15 mm deep behind the sheet in both; what differs is
  where the motor and the boards go.
  - `arm` (the RPM indicator): it sits beside the yoke column, and the
    Saitek yoke's housing is only 22 mm behind the sheet there, so the
    motor can not sit behind the needle. Big gears (43 teeth, module
    1.5) put the motor gear, the motor and the boards on an arm to the
    right, past the housing's side. The frame checks that they clear the
    housing, the step upright and the other instruments (`rpm_arm`,
    `rpm_deep` in `frame/frame.inc.scad`).
  - `deep` (the ASI): in the six-pack an arm would run into the next
    instrument, but there is room behind it. Small gears (26 teeth,
    module 1) keep the motor gear inside the case (in a pocket in its
    wall); the motor's body lies over the needle's axis on the back
    plate's back, and the board carrier stands on four posts behind the
    motor, its boards facing forward: the ULN2003 board beside the
    motor's wire cover, the Nano behind the motor. Nothing is outside the
    case's outline, so the instruments can sit on the 89 / 88 mm
    centres, but it is 47 mm deep behind the sheet (`asi_depth` in the
    frame, which checks it against the yoke housing). The motor's shaft
    end sits in a pocket in the dial's back.
- **Home**: a 6 x 3 mm disc magnet in the motor gear's back face passes
  0.5 mm over an A3144 hall sensor in a pocket in the back plate. The
  gears are 1:1, so there is one home per needle turn. At start
  MobiFlight turns the needle until the sensor pulls low and calls that
  0. The needle is pressed on pointing at 0 after it has homed, so the
  magnet's place does not matter.
- **Electronics**: the ULN2003 driver board and an Arduino Nano running
  MobiFlight are on a printed carrier, screwed onto the back plate (beside
  the motor in `arm`, on posts behind it in `deep`), so it can be wired on
  the bench. The Nano slides into rails with its USB jack down. In the
  six-pack the next instrument is right under it: use a mini USB cable
  with an angled plug (bent back). It is a board of its own, like every
  component's (see [Connections](../hub/README.md#connections)). The stepper takes about
  0.25 A from USB while it moves, nothing at rest (see
  [MobiFlight](#mobiflight)).
- **Print orientation**: the case, the dial and the back plate are printed
  back side down, the gears and the needle front side down, the carrier
  flat (in `deep` its board side up, with the posts). The motor gear's
  pocket in the case is open towards the sheet, so there is no bridge
  over it. All of it is black but the needle: print
  that white, or paint it.

The motor, board, sensor and magnet values are the compass's MEASURE
values. The `assert`s check that the face covers the window, that the
posts, columns and sensor clear the gears, that the screws from the front
and the back do not meet in the columns, that the magnet fits the gear,
and, in `arm`, that the case is shallow enough and the motor far enough
right for the yoke housing; in `deep`, that the motor, the carrier's
posts, its screws and the boards clear each other, the gears and the
dial's posts, and that the carrier stays between the neighbours and off
the case screws.

## The faces

`make` writes `target/rpm_face.pdf` and `target/asi_face.pdf` (also on the
project page: [RPM](https://robertbraeutigam.github.io/cessna172/instruments/rpm_face.pdf),
[ASI](https://robertbraeutigam.github.io/cessna172/instruments/asi_face.pdf)),
each two faces and a cut template for the glass on an A4 page (landscape), in
colour, 1:1, with OpenSCAD's scale bar along the edges. It is made the
same way as the [compass card](../compass/README.md#the-card), but in
colour: every shape of the face is drawn with `ink(colour)`, and the
`Make print face black,#1f9e3a,white,#e02020` marker tells the Makefile to
render it once per colour and lay the layers over each other in that
order with `qpdf` (black dial, green arc, white markings, red line; the
ASI has a yellow arc too).

- Print it on a colour printer, or at a print shop, at 100 % ("actual
  size", no "fit to page"), and check the scale bar with a ruler. Matte
  photo paper looks best (`paper_t` is 0.2 mm).
- Cut out a face on its black edge and punch the white hole in the middle
  (3.2 mm) for the axle. Glue it into the dial (spray adhesive or a glue
  stick, so it stays flat).
- Lay the clear sheet over the glass template and cut it on the line's
  inside.

The RPM face: 0 to 35 hundred RPM over 240 degrees (0 at 8 o'clock, 35 at
4 o'clock), a tick every 100 RPM and a number every 500. The 172N's green
arc is stepped: 2100 to 2450 RPM at sea level, to 2575 at 5000 ft and to
2700 at 10000 ft, each step narrower; the red line is at 2700 (`green`,
`red_line` in `rpm.scad`). RPM and HUNDREDS are over the hub, and a dummy
hour meter with HOURS is under it.

The ASI face: KNOTS on the outside, 40 to 200 kts, a tick every 5 and a
number every 20; MPH on the inside, 40 to 230 mph, a number every 20.
Like the real one the scale is not linear, wider at the low end:
`asi_cal` in `asi.scad` gives the needle's angle for each 20 kts (0 kts
at 12 o'clock, 40 at 26 degrees, 200 at 326), and the MPH ring uses the
same curve. The 172N's markings (KIAS): the white flap arc 41 to 85, on
the inside of the others, green 47 to 128, yellow 128 to 160 and the red
line at 160 (`white_arc`, `green_arc`, `yellow_arc`, `red_line`).
AIRSPEED and KNOTS are over and under the hub.

## Hardware

Per instrument:

| Qty | Part | Use |
|-----|------|-----|
| 1 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | needle |
| 1 | Arduino Nano (ATmega328P, 5 V), USB cable | MobiFlight board of the instrument |
| 1 | A3144 hall sensor (unipolar, not latching) | home |
| 1 | disc magnet 6 x 3 mm | home |
| 1 | steel dowel pin 3 x 12 mm | needle axle |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the face, printed on photo paper | face |
| 4 | M3 x 8 button head, black | case through the sheet |
| 6 (`arm`), 4 (`deep`) | M3 x 8 countersunk self tapping screw | back plate into the case |
| 2 | M3 x 8 countersunk screw + nut | motor ears (heads in the back plate's front, nuts behind the ears) |
| 4 | M3 x 6 self tapping screw | ULN2003 board |
| 3 (`arm`) | M3 x 6 self tapping screw | carrier onto the back plate, through the carrier |
| 4 (`deep`) | M3 x 8 countersunk self tapping screw | carrier's posts, from the back plate's front |
| 1 (`deep`) | mini USB cable with an angled plug | the Nano, room under it is short in the six-pack |

## Assembly

1. Magnet into the motor gear's pocket. Hold the sensor over it first to
   check which face pulls the output low (normally the flat, printed one).
   Sensor flat face forward into its pocket on the back plate, legs bent
   back through the slot.
2. Motor onto the back plate's back (wires to the right), two countersunk
   screws from the front, nuts behind the ears. Motor gear onto its shaft.
3. ULN2003 board onto the carrier's standoffs, the Nano into its rails
   (USB down, a dab of hot glue at the bottom end), the carrier onto the
   back plate (`arm`: screws through the carrier; `deep`: over the motor,
   screws from the back plate's front into its posts). Wire it (see
   [Wiring](#wiring)).
4. Needle gear onto the axle (glue it), the axle into the back plate's
   bearing hole.
5. Glass into the case from behind, against the lip, then the dial with
   the face glued in. Put the back plate on, turning the needle gear so
   the gears mesh, and screw it into the case.
6. Flash and set up MobiFlight (see [MobiFlight](#mobiflight)), let the
   stepper home, and press the needle onto the axle at 0.
7. Drill the four 3.3 mm screw holes round the instrument's hole in the
   sheet, using the case as the template. Case into the hole from behind,
   the four black screws from the front.

## Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| ULN2003 IN1, IN2, IN3, IN4 | D2, D3, D4, D5 | *Stepper* |
| hall sensor OUT (VCC to 5 V, GND to GND) | D6 | the stepper's home (zero) input |
| ULN2003 + and - | 5 V, GND | |

The same as the compass. The motor plugs into the ULN2003 board. The
sensor's output is open collector and pulls low over the magnet; the
Nano's internal pull-up is enough on its short wire. The USB cable goes
down to the powered USB hub next to the [hub](../hub/README.md#connections).

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector. Add a
*Stepper* on D2..D5 with D6 as its home (auto zero) input, and an output
that follows the instrument's dataref (below). Check the names against
the Connector's dialog, as they change between versions.

- **Coils off at rest**: tick *Disable stepper when at target position*
  in the stepper's settings. The firmware then switches the coils off as
  soon as the needle is where it should be, and on again for the next
  move; the 28BYJ-48's gearbox holds the needle without power. The motor
  draws current only while it steps (about 2.5 ms a step at the
  firmware's 400 steps a second), so a needle that twitches all the time
  in flight still takes only some 10-20 mA on average, and the motor and
  the ULN2003 board stay cool (see
  [Powered USB hub](../hub/README.md#powered-usb-hub)).
- **Twitching**: the Connector moves the needle on every whole step of
  change (0.18 degrees of the needle: about 0.12 kt on the ASI), there is
  no deadband. If a needle looks too nervous, round the value in the
  output's transform before it becomes steps (e.g. to 0.5 kt); a value
  right on a rounding boundary can still flip.

### RPM indicator

The dataref is `sim/cockpit2/engine/indicators/engine_speed_rpm` (index 0).

- **Scale**: 3500 RPM is 240 degrees, so with about 2038 steps a turn (the
  28BYJ-48's gearbox is 63.68:1, not 64:1) the output is
  `$*0.3882` steps (2038 / 360 x 240 / 3500). Set the steps per
  revolution to 2038.
- **Direction**: as the RPM grows, the needle turns clockwise and the
  motor counterclockwise (seen from the front). If the needle turns the
  wrong way, give it the pins the other way round (D5..D2).
- **Pin order**: if the motor only hums or shakes, swap the middle pins
  (IN2 and IN3) in the stepper's settings.
- **Fine tuning**: if the needle is a little off 0 after homing, add an
  offset in the transform rather than pressing the needle on again.

### Airspeed indicator

The dataref is `sim/cockpit2/gauges/indicators/airspeed_kts_pilot`. Set
the steps per revolution to 2038 as above. The scale is not linear, so
the output uses the Connector's *Interpolation* (on the output's
*Modify* tab) with the points of `asi_cal`: steps = degrees x 2038 / 360.

| kts | 0 | 40 | 60 | 80 | 100 | 120 | 140 | 160 | 180 | 200 |
|-----|---|----|----|----|-----|-----|-----|-----|-----|-----|
| degrees | 0 | 26 | 68 | 110 | 150 | 190 | 228 | 263 | 296 | 326 |
| steps | 0 | 147 | 385 | 623 | 849 | 1076 | 1291 | 1489 | 1676 | 1846 |

Above 200 kts it stays at 1846 (the needle must not run round past 0).
Direction, pin order and fine tuning as for the RPM indicator. If
`asi_cal` changes, change this table too.
