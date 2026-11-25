# Instruments

[Cessna 172 home cockpit](../README.md) / `instruments/`

[![RPM indicator](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)

[![Airspeed indicator](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)

[![Vertical speed indicator](https://robertbraeutigam.github.io/cessna172/instruments/vsi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/vsi_montage.png)

[![Attitude indicator](https://robertbraeutigam.github.io/cessna172/instruments/ai_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/ai_montage.png)

[![Altimeter](https://robertbraeutigam.github.io/cessna172/instruments/alt_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/alt_montage.png)

[![Heading indicator](https://robertbraeutigam.github.io/cessna172/instruments/hi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/hi_montage.png)

[![Turn coordinator](https://robertbraeutigam.github.io/cessna172/instruments/tc_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/tc_montage.png)

The analogue ("steam") instruments. They all follow one standard
(`instrument.inc.scad`): a 3 1/8" case behind a round hole in the panel,
a colour printed face, and a needle turned by a 28BYJ-48 geared stepper.
So far: the RPM indicator (tachometer), the airspeed indicator (ASI),
the vertical speed indicator (VSI), the attitude indicator (AI), the altimeter (ALT), the
heading indicator (HI) and the turn coordinator (TC); the last four have
the standard's case front but mechanisms of their own (see
[Attitude indicator](#attitude-indicator), [Altimeter](#altimeter),
[Heading indicator](#heading-indicator) and
[Turn coordinator](#turn-coordinator)). The instruments go into
the holes of the stage 2 left sheet (see
[Cockpit frame](../frame/README.md)): the stage 1 sheet is lower and its
top bar is in the way.

| File | Parts |
|------|-------|
| `instrument.inc.scad` | the standard: case, dial, needle, gears, back plate, board carrier; the face's colour layers and print page; the helpers the instruments with their own mechanisms share (motor placement and clearances, ring gear, sensor pocket); every carrier's place between its neighbours (`carrier_slots`) |
| `twin_drive.inc.scad` | the two motor drive of the heading indicator and the turn coordinator: the axle's gears, a disc turned through an internal ring gear by a second motor, the dial with the disc's sensor, the back plate with both motors, the board carrier |
| `rpm.scad` | the RPM indicator: its face and the parts above; the face print |
| `asi.scad` | the airspeed indicator: its face and the parts above; the face print |
| `vsi.scad` | the vertical speed indicator: its face and the parts above; the face print |
| `ai.scad` | the attitude indicator: the standard's case front, a roll frame with the horizon bowl and the pitch motor on it, a slip ring, the roll motor; the roll dial's print |
| `alt.scad` | the altimeter: the standard's case front, three needles on concentric shafts with a motor each, the Kollsman window's disc, knob and pot; the face and Kollsman ring print |
| `hi.scad` | the heading indicator: the standard's case front, a card on the axle and a bug disc behind it with a motor each, two knobs on rotary encoders; the card, bug ring and fixed ring print |
| `tc.scad` | the turn coordinator: the standard's case front, the airplane on the axle, a face plate with the inclinometer's tube, the ball on a disc behind it, a motor each; the face and ball ring print |

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
- **Motor and boards behind the case**: small gears (26 teeth, module 1)
  keep the motor gear inside the case (in a pocket in its wall); the
  motor's body lies over the needle's axis on the back plate's back, and
  the board carrier stands on four posts behind the motor, its boards
  facing forward: the ULN2003 board beside the motor's wire cover, the
  Nano behind the motor. Nothing is outside the case's outline, so the
  instruments can sit on the 89 / 88 mm centres, but it is 47 mm deep
  behind the sheet (`inst_depth` in the frame, which checks it against
  the force feedback yoke's housing, set back for it: `ffb_back`). The
  motor's shaft end sits in a pocket in the dial's back.
- **Home**: a 5 x 2 mm magnet (two 5 x 1 mm discs stacked) in the motor gear's back face passes
  0.5 mm over an A3144 hall sensor in a pocket in the back plate (its
  legs' slot is narrower than its body, so it stays centred under the
  magnet; it switches reliably up to about a 3 mm gap). The
  gears are 1:1, so there is one home per needle turn. At start
  MobiFlight turns the needle until the sensor pulls low and calls that
  0. The needle is pressed on pointing at 0 after it has homed, so the
  magnet's place does not matter.
- **Electronics**: the ULN2003 driver board and an Arduino Nano running
  MobiFlight are on a printed carrier, screwed onto the back plate (on
  posts behind the motor), so it can be wired on
  the bench. The Nano slides into its rails (the shared ones of
  [`lib/nano.inc.scad`](../lib/nano.inc.scad)) with its USB jack down. In the
  six-pack the next instrument is right under it: use a mini USB cable
  with an angled plug (bent back). It is a board of its own, like every
  component's (see [Connections](../README.md#connections)). The stepper takes about
  0.25 A from USB while it moves, nothing at rest (see
  [MobiFlight](#mobiflight)).
- **Print orientation**: the case, the dial and the back plate are printed
  back side down, the gears and the needle front side down, the carrier
  flat (its board side up, with the posts). The motor gear's
  pocket in the case is open towards the sheet, so there is no bridge
  over it. All of it is black but the needle: print
  that white, or paint it.

The motor, board, sensor and magnet values (MEASURE) are the shared ones
of [`lib/stepper.inc.scad`](../lib/stepper.inc.scad), the compass's too. The `assert`s check that the face covers the window, that the
posts, columns and sensor clear the gears, that the screws from the front
and the back do not meet in the columns, that the magnet fits the gear,
and that the motor, the carrier's
posts, its screws and the boards clear each other, the gears and the
dial's posts, and that the carrier stays between the neighbours and off
the case screws. Behind the cases, neighbours' carriers share the width
between their axes: `carrier_slots` in `instrument.inc.scad` gives each
instrument's carrier its place, each instrument checks that its carrier
stays in it, and the include checks the places against each other.

## The faces

`make` writes `target/rpm_face.pdf`, `target/asi_face.pdf` and
`target/vsi_face.pdf` (also on the
project page: [RPM](https://robertbraeutigam.github.io/cessna172/instruments/rpm_face.pdf),
[ASI](https://robertbraeutigam.github.io/cessna172/instruments/asi_face.pdf),
[VSI](https://robertbraeutigam.github.io/cessna172/instruments/vsi_face.pdf)),
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
  inside. Keep the protective film on (trace the line onto it) until
  assembly. Sharp scissors are enough: the lip covers 2.7 mm of the glass
  all round (77.4 mm glass, 72 mm window), so the edge may be rough or a
  little wavy, but it must be under 77.4 mm everywhere (the bore is
  77.7 mm, never press it in) and over about 74 mm, so the dial's rim
  still holds it. Cut a square first (score it with a knife on a steel
  ruler and snap it), then the circle in short cuts, turning the sheet,
  and take the burr off with fine sandpaper. Acrylic cracks under
  scissors: use a circle cutter on it.

The RPM face: 0 to 35 hundred RPM over 240 degrees (0 at 8 o'clock, 35 at
4 o'clock), a tick every 100 RPM and a number every 500. The 172N's green
arc is stepped: 2100 to 2450 RPM at sea level, to 2575 at 5000 ft and to
2700 at 10000 ft, each step narrower; the red line is at 2700 (`green`,
`red_line` in `rpm.scad`). RPM and HUNDREDS are over the hub, and a dummy
hour meter with HOURS is under it.

The ASI face: KNOTS on the outside, 40 to 170 kts, a tick every 5 and a
number every 20 (to 160); MPH on the inside, 40 to 190 mph, a number
every 20. The scale is the X-Plane 172N's, measured on its dial: nearly
linear, a little wider at the low end. `asi_cal` in `asi.scad` gives the
needle's angle for each 20 kts (0 kts at 12 o'clock, 40 at 38 degrees,
100 at the bottom, 140 at 9 o'clock, 160 at 310, 170 at 329), and the
MPH ring uses the same curve. The 172N's markings (KIAS): the white flap
arc 41 to 85, on the inside of the others, green 47 to 128, yellow 128 to
160 and the red line at 160 (`white_arc`, `green_arc`, `yellow_arc`, `red_line`).
AIRSPEED and KNOTS are over and under the hub.

The VSI face, like the 172N's: 0 at 9 o'clock, UP clockwise over the
top and DOWN counterclockwise under it, to 2000 ft/min each way, so the
two 20s stand either side of 3 o'clock. The scale is wider up to 1000
(a tick every 100) and narrower above it (a tick every 250), with the
numbers 0, 5, 10, 15, 20 (hundreds of ft/min); `vsi_cal` in `vsi.scad`
gives the needle's angle from 0 (500 at 50 degrees, 1000 at 96, 1500 at
136, 2000 at 170). UP and DOWN with their arrows are inside the scale on
the left, VERTICAL SPEED and 100 FEET PER MINUTE right of the hub. It is
white on black only (`Make print face black,white`). It sits in the
six-pack's bottom right hole, under the altimeter, in front of the force
feedback yoke's housing: it is the standard, 47 mm deep.

## Hardware

Per instrument:

| Qty | Part | Use |
|-----|------|-----|
| 1 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | needle |
| 1 | Arduino Nano (ATmega328P, 5 V), USB cable | MobiFlight board of the instrument |
| 1 | A3144 hall sensor (unipolar, not latching) | home |
| 2 | disc magnet 5 x 1 mm | home (two stacked) |
| 1 | steel dowel pin 3 x 12 mm | needle axle |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the face, printed on photo paper | face |
| 4 | M3 x 8 button head, black | case through the sheet |
| 4 | M3 x 8 countersunk self tapping screw | back plate into the case |
| 2 | M3 x 8 countersunk screw + nut | motor ears (heads in the back plate's front, nuts behind the ears) |
| 4 | M3 x 6 self tapping screw | ULN2003 board |
| 4 | M3 x 8 countersunk self tapping screw | carrier's posts, from the back plate's front |
| 1 | mini USB cable with an angled plug | the Nano, room under it is short in the six-pack |

## Assembly

1. Magnet into the motor gear's pocket. Hold the sensor over it first to
   check which face pulls the output low (normally the flat, printed one).
   Sensor flat face forward into its pocket on the back plate, legs bent
   back through the slot.
2. Motor onto the back plate's back (wires to the right), two countersunk
   screws from the front, nuts behind the ears. Motor gear onto its shaft.
3. ULN2003 board onto the carrier's standoffs, the Nano into its rails
   (USB down, a dab of hot glue at the bottom end), the carrier onto the
   back plate (over the motor, screws from the back plate's front into
   its posts). Wire it (see
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
down to the powered USB hub on the desk.

**USB**: one port on the powered USB hub per instrument (the six-pack,
the NAV indicators and the RPM are 9). A stepper draws about 0.25 A while
its coils are on, so an instrument with one stepper takes about 0.3 A
with its Nano, one with two about 0.55 A: the port must give at least
500 mA (see [Powered USB hub](../README.md#powered-usb-hub)). With the
coils off at rest (see [MobiFlight](#mobiflight)) that is only while the
needle moves, and at start, when every needle homes at once for a few
seconds. X27.168 gauge steppers would cut even that (about 20 mA, no
driver board), but they have an end stop inside: only for needles that
do not turn round, like the ASI, VSI and RPM.

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
  [USB](#wiring)).
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

| kts | 0 | 40 | 60 | 80 | 100 | 120 | 140 | 160 | 170 |
|-----|---|---|---|---|---|---|---|---|---|
| degrees | 0 | 38 | 92 | 140 | 186 | 229 | 270 | 310 | 329 |
| steps | 0 | 215 | 521 | 793 | 1053 | 1296 | 1528 | 1755 | 1863 |

Above 170 kts it stays at 1863 (the needle must not run round past 0).
Direction, pin order and fine tuning as for the RPM indicator. If
`asi_cal` changes, change this table too.

### Vertical speed indicator

The dataref is `sim/cockpit2/gauges/indicators/vvi_fpm_pilot`. Set the
steps per revolution to 2038. The needle's home is 0 ft/min (9 o'clock):
climbs are positive steps (clockwise), descents negative. The scale is
not linear, so the output uses the *Interpolation* with the points of
`vsi_cal`, both ways (steps = degrees x 2038 / 360):

| ft/min | -2000 | -1500 | -1000 | -500 | 0 | 500 | 1000 | 1500 | 2000 |
|--------|---|---|---|---|---|---|---|---|---|
| degrees | -170 | -136 | -96 | -50 | 0 | 50 | 96 | 136 | 170 |
| steps | -962 | -770 | -543 | -283 | 0 | 283 | 543 | 770 | 962 |

Beyond 2000 either way it stays at the end (the needle must not run
round past the 20s into the other side). After homing press the needle
on pointing at 0. If the Connector does not move the stepper to negative
positions, add 962 to every step value and press the needle on at
DOWN 20 instead. Direction, pin order and fine tuning as for the RPM
indicator. If `vsi_cal` changes, change this table too.

## Attitude indicator

The six-pack's top middle instrument, modelled on the 172's RC Allen
attitude indicator (and X-Plane's 172N). Its
case front is the standard's (the 81 mm hole, the lip, the glass), with
a square front bezel (86 mm, 4 mm thick) in front of the sheet: the
case's four screws go through its corners and the sheet. Behind it is a mechanism of its own with
two 28BYJ-48 steppers and a slip ring, and it is 116 mm deep behind the
sheet (`ai_depth`). It is in the top row, over the force feedback yoke's
housing, so the depth does not matter there (the frame checks it).

### How it works

- **What you see**: a thin roll dial ring (turquoise sky over brown
  ground, the bank marks 0, 10, 20, 30, a dot at 45, 60 and 90, the
  horizon line across it); the ring ends where the long
  bank marks end, so its window is 59 mm across. Behind it the horizon
  bowl, a part of a sphere, sky blue over brown: the horizon, in the sky
  a ladder (lines every 2 degrees to 8, then 10, 15, 20, 25, with 1 0 and
  2 0 split by their lines), in the ground lines every 5 degrees, wider
  downwards, with 10 and 20 at their ends, and two slanted rails
  converging on the middle. Fixed, between the glass and the dial: the
  bank index, a yellow triangle hanging from the top of the sleeve's ring
  and pointing down, with a slit down its middle where the dial's zero
  line shows; and the airplane: yellow wing bars, a Y and a dot on a stem
  from a light brown pedestal, which stands on a black mask over the
  window's bottom. In front of the glass the bezel has a ledge over the
  window's bottom, as high as the mask; a dummy knob sits on it, its stem
  glued into the ledge (the real one sets the airplane's height). The
  dial turns with the horizon and the index reads its marks.
- **Roll**: the dial is the front of the roll frame: two arms go back from
  it to a back disc with the roll gear. The frame turns in a printed
  sleeve in the case: the dial and the back disc run in it (a big plain
  bearing at each end), the dial's rim against the sleeve's front ring.
  The sleeve's ring holds the glass against the lip, three legs on its
  back press it forward from the back plate. The roll gear is 1:1 with
  the roll motor's gear (the standard's gears), so the roll turns round
  freely. The roll motor is on the back plate's back, its body beside its
  shaft (the slip ring is on the axis); a magnet in its gear's flange
  passes a hall sensor in the back plate for homing.
- **Pitch**: the bowl is a 33 mm sphere's front, cut 60 mm wide, with a
  side plate at each end. It turns on two steel pins in the arms, through
  its middle, one degree per degree of pitch, like the real instrument's
  sphere (10 degrees of pitch move the horizon about 6 mm). The pitch
  motor rides on the roll frame, inside the bowl, on a bracket screwed
  onto the back disc; its 8 tooth pinion turns a 24 tooth gear sector on
  the bowl's left hub (3:1). The bowl turns 30 degrees each way. A magnet
  in its right side plate passes a hall sensor in the right arm at 33
  degrees nose down, just past the travel, for homing.
- **Slip ring**: the pitch motor and its sensor need 7 wires (4 coils,
  5 V, GND, the sensor's output) across the turning roll axis. They go
  through an MSM-12-08A capsule slip ring (8 wires, the spare one doubles
  the 5 V): its flange is screwed onto the back plate's front, its front
  end reaches into the roll gear's bore, and its turning wires come out
  there, through the back disc to the motor and the sensor (tie them to
  the bracket). Its body goes through the back plate, and its fixed wires
  come out of its back end to the boards. So the roll turns round freely.
- **Electronics**: a board carrier on four posts of the back plate,
  behind the roll motor, with both ULN2003 boards and the Nano on its
  back (they face back, in reach for wiring). The AI is deeper than its
  neighbours, so its carrier is behind them, and the Nano's USB jack
  points left.
- **Print orientation**: the case back side down; the bezel on its back
  (the counterbores up); the sleeve on its ring; the airplane (with its
  pedestal and the mask) flat; the knob on its front;
  the roll dial on its face, the arms up; the back disc on its front, the
  roll gear up; the bowl halves on their horizon face, with supports under
  the inside of the shell (the outside stays clean): the sky half in blue,
  the ground half in brown filament; the sector, the pinion, the roll
  motor gear flat; the bracket on its plate, the feet up; the back plate
  on its front, the posts up; the carrier flat. The small pitch gears
  (module 0.8) are cut by a rolling rack in the model (undercut), so
  they mesh. Everything else black; paint the index and the
  airplane yellow, its pedestal light brown, the bowl's ribs (horizon,
  lines, numbers) white.

The `assert`s check that the bowl fills the window at both ends of its
travel and turns in the sleeve, that the pitch motor, its cover and ears
stay inside the bowl's shell and clear of the arms and the back disc,
that the bracket's feet clear the motor, that the sector covers the
travel, that the pins reach into the hubs, that the slip ring, the roll
motor, its gear, sensor and ears clear each other, and that the
carrier's posts, screws and boards fit.

### The print

`make` writes `target/ai_face.pdf` (two roll dial faces and the glass's
template, on the project page as
[face](https://robertbraeutigam.github.io/cessna172/instruments/ai_face.pdf)),
a colour print like the other faces. Print at 100 % on matte photo
paper. Cut the outside on the black line's inside and the window on the
colours' edge, and glue it onto the dial, sky up (the horizon at the
arms).

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | roll, pitch |
| 1 | Arduino Nano (ATmega328P, 5 V), mini USB cable with an angled plug | MobiFlight board of the instrument |
| 1 | capsule slip ring, 8 wires (MSM-12-08A: 12 mm, 24 mm flange with 3 holes) | the pitch motor's and sensor's wires across the roll axis |
| 2 | A3144 hall sensor | homes |
| 4 | disc magnet 5 x 1 mm | homes (two stacked each) |
| 2 | steel dowel pin 3 x 10 mm | the bowl's pivots |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the dial's face, printed on photo paper | roll dial |
| 4 | M3 x 12 button head, black | case through the bezel and the sheet |
| 4 | M3 x 8 countersunk self tapping screw | back plate into the case |
| 2 | M3 x 8 countersunk self tapping screw | back disc onto the arms |
| 2 | M3 x 8 countersunk self tapping screw | back disc onto the bracket's feet |
| 2 | M3 x 8 countersunk screw + nut | roll motor ears |
| 2 | M3 x 8 pan head screw + nut | pitch motor ears on the bracket |
| 3 | M3 x 6 pan head self tapping screw | slip ring flange onto the back plate |
| 4 | M3 x 8 countersunk self tapping screw | carrier onto its posts |
| 8 | M3 x 6 self tapping screw | ULN2003 boards |

The slip ring's hole circle (`sr_holes`, 18 mm) is a guess: measure it.

### Assembly

1. Glue the face onto the roll dial. Glue the bowl halves together at
   the horizon (the hubs' halves and the pin holes line up), paint the
   ribs. Magnet into the right side plate's pocket (check which face pulls
   the sensor low), the gear sector onto the left hub's hexagon (glue).
2. Pitch sensor into the right arm's pocket (flat face out), its legs in
   the groove to the back.
3. Pitch motor onto its bracket (ears on the plate, nuts on the motor's
   side), the pinion onto its shaft, the bracket onto the back disc (two
   screws from the back disc's back).
4. Bowl between the arms, the pins from outside through the arms into its
   hubs (press fit), the sector meshing the pinion. Back disc onto the
   arms (two screws).
5. The airplane's mask into the notch in the sleeve's ring (glue). Glass
   into the case from behind, the sleeve behind it, the roll frame into
   the sleeve (the dial against the ring). The knob's stem into the
   hole in the bezel's ledge (glue).
6. Slip ring through the back plate, its flange screwed on the front; the
   roll motor (ears countersunk from the front, nuts behind) and its
   sensor; the magnet into the roll motor gear's flange, the gear onto
   the shaft. Turning wires through the roll gear's bore and the back
   disc to the pitch motor and sensor (solder, tie them to the bracket).
   Back plate into the case, the gears meshing as it goes on.
7. Carrier onto its posts, the ULN2003 boards and the Nano onto it, wire
   it (below). Into the panel like the standard instrument, but with the
   bezel in front of the sheet: drill the four screw holes using the
   bezel as the template, case into the hole from behind, the four
   M3 x 12 screws through the bezel and the sheet into the case.

### Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| roll ULN2003 IN1..IN4 | D2, D3, D4, D5 | *Stepper* roll |
| roll hall sensor OUT | D6 | roll's home input |
| pitch ULN2003 IN1..IN4 | D7, D8, D9, D10 | *Stepper* pitch |
| pitch hall sensor OUT (through the slip ring) | D11 | pitch's home input |
| both ULN2003 + and -, sensors' VCC and GND | 5 V, GND | |

The pitch motor's 5 wires (its plug cut off) and the pitch sensor's
output and GND go through the slip ring; the sensor's VCC shares the
motor's red (5 V) wire, and the eighth wire doubles it.

**USB**: one port on the powered USB hub, about 0.55 A while both motors
move (two steppers, see [USB](#wiring) above).

### MobiFlight

Two *Steppers* (pins above, 2038 steps a turn, home inputs, coils off at
rest). The datarefs are the vacuum attitude indicator's,
`sim/cockpit2/gauges/indicators/roll_vacuum_deg_pilot` and
`pitch_vacuum_deg_pilot` (it tumbles with the vacuum, like the real one).

- **Roll**: tick *Compass mode*, so a roll past 180 degrees takes the
  short way round; steps = roll x 2038 / 360, `$*5.661` (plus an offset,
  below). If the dial turns the wrong way, give the motor its pins the
  other way round (D5..D2).
- **Pitch**: the bowl turns 3 x 2038 / 360 = 16.98 steps a degree. It
  homes at 33 degrees nose down, so the output is
  `(Max(-30,Min(30,$))+33)*16.98` (plus a small offset, below). Homing
  must turn the bowl nose down, towards its sensor: if it turns the other
  way, give the motor its pins the other way round (D10..D7) and make the
  steps negative (`-(...)`).
- **Offsets**: after homing, add the roll offset (in steps) to the roll
  transform until the dial is level, then fine tune the pitch so the
  horizon is under the airplane's wings. Check the names against the
  Connector's dialogs, as they change between versions.

## Altimeter

The six-pack's top right instrument, like the 172N's, but with two
needles (100 ft and 1000 ft): the airplane stays under 10000 ft, so the
10000 ft needle is left out. Like the dual scale altimeters, it has two
Kollsman windows, inHg at 3 o'clock and hPa at 9 o'clock (for QNH in
Europe), set by one knob at the lower left. Its case front is the
standard's (the 81 mm hole, the lip, the glass), but the lower left
screw's place is the knob's, so it has three screws. Behind it are two
28BYJ-48 steppers, one behind the other, and it is 98 mm deep behind the
sheet (`alt_depth`): like the AI it is in the top row, over the force
feedback yoke's housing (the frame checks it).

### How it works

- **Needles**: the 100 ft needle (long, in front) is pressed onto a 3 mm
  steel axle, the 1000 ft needle (short and wide) onto a 4 mm brass tube
  round the axle (0.45 mm wall: the axle turns in it). A real altimeter
  drives them through clockwork; here each has a motor of its own, so
  each one homes on its own and a lost step never shows as the wrong
  thousands. Above 10000 ft the 1000 ft needle simply goes round again.
- **100 ft**: the axle goes back through everything to motor C on the
  rear plate, its shaft on the axis; a printed coupler joins them (no
  gears: 2.04 steps a foot). A magnet in the coupler passes a sensor in
  the rear plate.
- **1000 ft**: a 14 tooth gear on the tube, in the gear layer next to
  the back plate, turned by a 28 tooth gear on motor B on the back
  plate. The needle turns twice per motor turn (0.10 steps a foot), so
  the motor's one home a turn is one place of the needle. The magnet in
  the motor gear passes a sensor in the back plate.
- **Kollsman windows**: a disc behind the dial carries a printed paper
  ring with two scales of the same setting: inHg inside (28.1 to 31.0,
  numbers every 0.1, ticks every 0.02) and hPa outside (952 to 1049,
  numbers every 5, ticks every 1; 1 inHg is 33.86 hPa). Two windows in
  the dial show them, each only over its own scale: inHg at 3 o'clock,
  hPa at 9 o'clock. A white index beside each window points at the
  setting (1013 hPa with 29.92 inHg).
  The knob turns it: the knob's pinion (14 teeth) turns an idler (23
  teeth, on a steel pin from the back plate; both in the gear layer in
  front of motor B's), whose pinion (13 teeth) turns an internal ring
  gear (90 teeth) on the disc's back, 3.2 knob turns per inHg. Clockwise
  raises the setting. The knob is on a 10 turn pot, read by MobiFlight:
  it gives the setting absolutely, so the windows and X-Plane never drift
  apart, and the pot's end stops end the scales. X-Plane gets inHg; the
  hPa window needs nothing of its own.
- **Keeper**: the disc turns on a hub on the dial's back, the keeper
  holds it there. The keeper's two legs go back to the back plate (pins
  into it) and press the dial forward against a spacer ring and the
  glass; pins on the dial's hub go into the keeper, so the windows stay
  at 3 and 9 o'clock.
- **Back**: motor B on the back plate's back (beside the axle), the pot
  down left. Four posts carry the rear plate with motor C; four more
  carry the board carrier with the two ULN2003 boards and the Nano facing
  back, its USB jack down. The carrier reaches below the case: the VSI
  under it is only 47 mm deep.
- **Print orientation**: every part has its features on one side: the
  dial, the disc, the keeper, the back and rear plates and the carrier
  are printed front down, the case back side down (the knob's train's
  pocket is open to the sheet), the idler on its big gear, the knob's
  shaft standing on its pinion's end. Black, but the needles: print them
  white, or paint them.

The `assert`s check the face (numerals, ticks and the windows clear of
each other, each scale only in its window), the gears (shafts reaching through them, the magnets in
them, the keeper's legs, the idler and the pot clear of them), the
Kollsman scale against the pot's 10 turns, the motors, posts, pot and
boards clear of each other, and the neighbours: the AI's case on the
left, the VSI's case and ears under it, the AI's bezel against the knob.

### The print

`make` writes `target/alt_face.pdf` (on the project page as
[face](https://robertbraeutigam.github.io/cessna172/instruments/alt_face.pdf)):
two faces, two Kollsman rings and the glass's template, black and white,
like the other faces. Print at 100 % on matte photo paper. Cut the face
on its edge, cut out the two windows and the hole on the white lines'
inside, and glue it onto the dial, the windows over the dial's. Cut the
ring on its edges and glue it onto the disc's front.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | the two needles |
| 1 | Arduino Nano (ATmega328P, 5 V), mini USB cable | MobiFlight board of the instrument |
| 2 | A3144 hall sensor | homes |
| 4 | disc magnet 5 x 1 mm | homes (two stacked each) |
| 1 | 10 turn pot 10k, 6.35 mm shaft, 3590S type (e.g. Bourns 3590S-2-103L or a clone) | the Kollsman knob |
| 1 | 3 mm silver steel rod, 44 + 16 mm | the axle, the idler's pin |
| 1 | brass tube 4 x 0.45 mm, 21 mm | the 1000 ft needle's shaft |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the face and the Kollsman ring, printed on photo paper | |
| 3 | M3 x 8 button head, black | case through the sheet |
| 3 | M3 x 8 countersunk self tapping screw | back plate into the case |
| 4 | M3 x 8 countersunk self tapping screw | rear plate onto the back plate's posts |
| 4 | M3 x 8 countersunk self tapping screw | carrier onto the rear plate's posts |
| 4 | M3 x 8 countersunk screw + nut | motor ears |
| 8 | M3 x 6 self tapping screw | ULN2003 boards |

The lengths come from the build's echo (`axle_len`, `pin_len`,
`tube_len`). The pot's sizes (`pot_*`) and the tube's (`tube`) are
MEASURE values: check them before printing.

### Assembly

1. Magnets into motor gear B (back face) and into the coupler (back
   face); check which face pulls the sensor low.
2. Back plate: motor B (ears countersunk from the front, nuts behind),
   sensor B into its pocket (flat face forward, legs bent back through
   the slot), the pot through its hole (nut on the front), the idler's
   pin pressed into its hole. Motor gear B onto B's shaft.
3. Rear plate: motor C and sensor C the same way, the coupler on C's
   shaft. Screw the rear plate onto the back plate's posts (from its back).
4. Glue the needle gear onto the tube 2.5 mm from its back end (that end
   goes into the back plate). The axle through the back plate into the
   coupler, the tube over it into its bearing. Idler onto its pin.
5. Face onto the dial, the Kollsman ring onto the disc. Glass into the
   case from behind, the spacer ring, the dial (the inHg window at 3
   o'clock). Turn the knob's pot to its low stop and put the disc on
   the dial's hub with 28.1 a little below the index (it must reach 28.1
   before the stop), the keeper on it (its pins on the dial's hub's).
   Put the back plate's stack on, the gears meshing, and screw it into
   the case.
6. The knob's shaft onto the pot's shaft through the case's pocket
   (glue), the carrier onto the rear plate's posts, the boards onto it,
   wire it (below). Flash and set up MobiFlight, let it home, press the
   needles on at 0.
7. Into the panel like the standard instrument: drill the three screw
   holes and the knob's 7 mm hole using the case as the template, the
   case into the hole from behind, the knob's shaft through its hole,
   the three screws, the knob onto the shaft (its flat).

### Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| motor C (100 ft) ULN2003 IN1..IN4 | D2, D3, D4, D5 | *Stepper* 100 ft |
| sensor C OUT | D6 | its home input |
| motor B (1000 ft) ULN2003 IN1..IN4 | D7, D8, D9, D10 | *Stepper* 1000 ft |
| sensor B OUT | D11 | its home input |
| pot wiper (ends to 5 V and GND) | A7 | *Analog input* Kollsman |
| both ULN2003 boards' + and -, sensors' VCC and GND | 5 V, GND | |

**USB**: one port on the powered USB hub, about 0.55 A while both motors
move (two steppers, see [USB](#wiring) above).

### MobiFlight

Two *Steppers* (pins above, 2038 steps a turn, home inputs, coils off at
rest), both following `sim/cockpit2/gauges/indicators/altitude_ft_pilot`
(it already has the Kollsman setting in it):

- **100 ft**: tick *Compass mode*, so it turns the short way round past
  0; steps = (feet mod 1000) x 2.038, `((($%1000)+1000)%1000)*2.038`.
  The needle turns with the motor (no gears).
- **1000 ft**: `$*0.1019` (the needle turns twice per motor turn: 20000 ft
  a motor turn). The needle turns the other way from the motor.
- **Direction and offsets**: if a needle turns the wrong way, give its
  motor its pins the other way round. After homing, press the needles
  on at 0; fine tune with an offset in the transform.
- **Kollsman**: an *Analog input* on A7 that sets
  `sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot` to
  `Round(28.1+($-L)*2.9/(H-L),2)`, where L and H are the input's values
  (the Connector shows them) with 28.1 and 31.0 at the inHg index. About
  3 counts per 0.01 inHg; raise the input's sensitivity if the value
  flickers.

## Heading indicator

The six-pack's bottom middle instrument, the 172N's directional gyro:
a compass card turning behind a white airplane, a fixed ring with the
index (lubber line) at the top and marks every 45 degrees, an orange
heading bug, and two knobs at the lower corners: the left one sets the
gyro, the right one the bug. Its case front is the standard's (the 81 mm
hole, the lip, the glass), but the lower screws' places are the knobs',
so it has two screws, on the top diagonals. Behind it are two 28BYJ-48
steppers side by side.

It is under the attitude indicator, in the bottom row, over the force
feedback yoke's housing only with its upper part: its board carrier is
62 mm deep behind the sheet (`hi_depth`), but nothing deeper than the
back plate reaches below 24 mm under its axis (`hi_deep_z`); below that
it is 19 mm deep (`hi_low_depth`: the case, the back plate, the knobs'
encoders). The frame checks both against the housing.

### How it works

- **Front to back**: the glass with the airplane (printed white, 0.8 mm,
  glued onto its back), the mask (the fixed ring, a printed paper ring on
  its front), the card (in the mask's opening), the bug disc behind the
  card, the dial (a plate with a rim forward to the mask: it presses the
  mask and the glass against the lip), the card's gears, the back plate.
- **Card**: printed paper (N 3 6 E ... 33, a tick every 5 degrees) on a
  56 mm printed disc, pressed onto a 3 mm steel axle, which turns in the
  dial's hub and in the back plate. The axle's gear is turned 1:1 by
  motor A's (26 teeth, module 1), like the standard's needle, and the
  magnet in motor A's gear homes it on a sensor in the back plate. The
  heading shows at the index: the card turns counter clockwise in a
  right turn.
- **Bug**: the bug disc is a disc behind the card, bigger than it: its
  edge shows between the card and the fixed ring, black with the orange
  bug (a paper ring). It turns on the dial's hub. An internal ring gear
  on its back (80 teeth, module 0.8) is turned by motor B's pinion
  (16 teeth): 5 motor turns a bug turn, so its home cannot be in the
  motor's gear. The magnet is in a boss on the bug disc's back and the
  sensor lies in a pocket in the dial's front, its legs in a groove out
  to a hole, and its wires back through the gear layer and the back
  plate: one home a bug turn. The bug follows the heading like the card
  (MobiFlight turns it by the bug's heading minus the heading).
- **Knobs**: two EC11 rotary encoders with push switches. Each sits in a
  bracket of the case at its lower corner (49 mm from the axis, outside
  the case's round wall): the bushing through the bracket, its nut in a
  pocket in front of the bracket (behind the sheet), the shaft through a
  7 mm hole in the sheet, a printed knurled knob on its D flat. The knob
  stands 1 mm off the sheet, more than the push travel.
- **Back**: the two motors lie on the back plate's back, their bodies
  slanted (A to the upper left, B to the lower right) so that their wire
  covers pass each other. Four posts carry the board carrier behind them:
  the two ULN2003 boards upright either side, the Nano between them, all
  facing back, the Nano's USB jack up. A straight mini USB plug fits
  under the attitude indicator's case; the cable bends back over the
  force feedback yoke's housing.
- **Print orientation**: the case back side down (the motor gear's pocket
  open to the sheet, the encoders' nut pockets open to the front), the
  mask, card, bug disc, dial, back plate and carrier front down, the
  gears flat, the pinion on its teeth, the knobs front down, the
  airplane flat (white). Everything else black.

The `assert`s check the faces (numbers, ticks, the airplane, the bug's
room between the card and the fixed ring), the front stack (the papers
covering the window, the bug disc under the mask and inside the dial's
rim), the gears (the pinion in the ring, the shafts reaching through
their gears, the magnet boss and the hubs clear of each other), the bug
sensor's wires clear of the gears and motors, the two motors, their ears
and covers clear of each other and of the screws, posts and sensors, the
encoders outside the case's wall and clear of the neighbours, the knobs
on their shafts, and the carrier in its place between the neighbours'
(`carrier_slots`) and under the attitude indicator. The drive, its parts
and its checks are `twin_drive.inc.scad`, shared with the turn
coordinator.

### The print

`make` writes `target/hi_face.pdf` (on the project page as
[face](https://robertbraeutigam.github.io/cessna172/instruments/hi_face.pdf)):
two fixed rings, the glass's template, two cards and two bug rings, in
black, white and orange. Print at 100 % on matte photo paper and cut on
the edges. Glue the fixed ring onto the mask's front (the index at the
top), the card onto the card's disc, the bug ring onto the bug disc's
front. The airplane is a printed part, not on the paper.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | card and bug |
| 1 | Arduino Nano (ATmega328P, 5 V), mini USB cable (straight plug) | MobiFlight board of the instrument |
| 2 | A3144 hall sensor | homes |
| 4 | disc magnet 5 x 1 mm | homes (two stacked each) |
| 2 | EC11 rotary encoder with push switch, 20 mm D shaft, M7 bushing, with its nut | the knobs |
| 1 | 3 mm steel dowel pin, 16 mm | the card's axle |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the fixed ring, card and bug ring, printed on photo paper | |
| 2 | M3 x 8 button head, black | case through the sheet |
| 3 | M3 x 8 countersunk self tapping screw | back plate into the case |
| 4 | M3 x 8 countersunk self tapping screw | carrier onto the back plate's posts |
| 4 | M3 x 8 countersunk screw + nut | motor ears |
| 8 | M3 x 6 self tapping screw | ULN2003 boards |

The encoder's sizes (`enc_*`: body, bushing, nut, shaft) and the axle's
length are MEASURE values: check them before printing.

### Assembly

1. Magnets into motor gear A (back face) and into the bug disc's boss
   (back face); check which face pulls each sensor low.
2. Back plate: motors A and B (ears countersunk from the front, nuts
   behind), sensor A into its pocket (flat face forward, legs bent back
   through the slot). Motor gear A onto A's shaft, the pinion onto B's.
3. Dial: the bug sensor into its pocket in the front (flat face
   forward), its legs out along the groove, bent back through the hole;
   wires through the back plate's hole. Fixed ring onto the mask, card
   paper onto the card, bug ring onto the bug disc.
4. The card onto the axle's front end (pressed, glue), the card's gear
   onto the axle, its back face 2.2 mm from the axle's back end
   (`gear_from_end` in the build's echo).
5. Glass into the case from behind (the airplane glued on its back, nose
   up, at the middle), the mask (the index at the top), the card with its
   axle, the bug disc, the dial over the axle (its hub into the bug
   disc's sleeve), then the back plate's stack, the axle into its
   bearing and the gears meshing, the posts into the dial's holes:
   screwed into the case (three screws).
6. Encoders into their brackets from behind, the nuts on in the pockets.
7. The carrier onto the back plate's posts (from its back; before the
   boards: the screws are under them), the boards onto it, wire it
   (below). Flash and set up MobiFlight, let it home, and set the card's
   and the bug's offsets (the card shows N, the bug at the index).
8. Into the panel: drill the two screw holes and the knobs' 7 mm holes
   using the case as the template, the case into the hole from behind,
   the two screws, the knobs onto the shafts (their flats).

### Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| motor A (card) ULN2003 IN1..IN4 | D2, D3, D4, D5 | *Stepper* card |
| sensor A OUT | D6 | its home input |
| motor B (bug) ULN2003 IN1..IN4 | D7, D8, D9, D10 | *Stepper* bug |
| bug sensor OUT | D11 | its home input |
| left encoder A, B | D12, A0 | *Encoder* gyro |
| left encoder push | A1 | *Button* gyro sync |
| right encoder A, B | A2, A3 | *Encoder* bug |
| right encoder push | A4 | *Button* bug sync |
| encoders' C and push commons, ULN2003 boards' -, sensors' GND | GND | |
| ULN2003 boards' +, sensors' VCC | 5 V | |

**USB**: one port on the powered USB hub, about 0.55 A while both motors
move (two steppers, see [USB](#wiring) above).

### MobiFlight

Two *Steppers* (pins above, coils off at rest, *Compass mode*, so they
turn the short way round):

- **Card**: 2038 steps a turn, following
  `sim/cockpit2/gauges/indicators/heading_vacuum_deg_mag_pilot` (the
  vacuum gyro's heading), steps `$*2038/360`. The card turns the other
  way from the motor; if it turns the wrong way, give the motor its pins
  the other way round.
- **Bug**: 10190 steps a turn (5 motor turns), following the bug minus
  the heading: `sim/cockpit/autopilot/heading_mag` and the heading above,
  steps `((($bug-$hdg)%360+360)%360)*10190/360` (in the Connector: the
  bug's dataref as the output's value, the heading as a config
  reference). The pinion and the ring turn the same way.
- **Offsets**: after homing, set each stepper's offset so the card shows
  N and the bug sits at the index.
- **Knobs**: the left *Encoder* runs `sim/instruments/DG_sync_down` /
  `sim/instruments/DG_sync_up`, its *Button* `sim/instruments/DG_sync_mag`
  (to the magnetic compass); the right *Encoder* runs
  `sim/autopilot/heading_down` / `sim/autopilot/heading_up`, its *Button*
  `sim/autopilot/heading_sync`. Check the command names in X-Plane's
  keyboard settings, they change between versions.

## Turn coordinator

The six-pack's bottom left instrument, the 172N's turn coordinator: a
white airplane (seen from behind) that banks with the turn rate, wings
level at the marks at 9 and 3 o'clock and a standard rate turn
(2 minutes) at the L and R marks under them, and the inclinometer's
black ball in a curved tube under the axis, between two black wires.
TURN COORDINATOR, D.C. ELEC., 2 MIN. and NO PITCH INFORMATION are
printed on the face. Its case front is the standard's, with the four
screws on the diagonals; there is no knob. Behind it are two 28BYJ-48
steppers side by side, the heading indicator's drive.

It is under the airspeed indicator, left of the heading indicator, in
the bottom row: like the heading indicator, only its upper part is over
the force feedback yoke's housing. Its board carrier is 65 mm deep
behind the sheet (`tc_depth`), but nothing deeper than the back plate
reaches below 24 mm under its axis (`tc_deep_z`); below that it is
22 mm deep (`tc_low_depth`: the case and the back plate). The frame
checks both against the housing.

### How it works

- **Front to back**: the glass, the airplane (on the axle), the face
  plate (a cup: its rim presses the glass against the lip, the face's
  paper on its front), the ball disc behind it, the dial (a plate with a
  rim forward to the face plate, a lug on the rim keying the face
  plate), the airplane's gears, the back plate.
- **Airplane**: printed white, pressed onto the front end of a 3 mm
  steel axle, which turns in the dial's hub and in the back plate. The
  axle's gear is turned 1:1 by motor A's (26 teeth, module 1), like the
  standard's needle; the magnet in motor A's gear homes it on a sensor
  in the back plate.
- **Ball**: the tube is a curved slot through the face plate, an arc
  round the axis (21 mm from it, ±32 degrees from 6 o'clock), with two
  thin bridges across its middle: the wires. Behind it the ball disc
  turns on the dial's hub; a white paper ring on its front carries the
  black ball (with a highlight), so the ball runs along the tube's curve
  as the disc turns, and the rest of the ring fills the tube white. Its
  drive is the heading indicator's bug's: an internal ring gear on its
  back (80 teeth, module 0.8) turned by motor B's pinion (16 teeth),
  5 motor turns a disc turn; the magnet in a boss on the disc's back,
  the sensor in a pocket in the dial's front (its legs along a groove,
  its wires back through the gear layer and the back plate). To home,
  the disc turns until the magnet passes the sensor, the ball out of
  sight behind the face meanwhile.
- **Back**: the two motors lie on the back plate's back, their bodies
  slanted (A to the upper left, B to the lower right) so that their wire
  covers pass each other. Four posts carry the board carrier behind them:
  the two ULN2003 boards upright either side, the Nano between them, all
  facing back, the Nano's USB jack up. The carrier is shifted 2.5 mm left
  of the axis, clear of the heading indicator's carrier (as deep, 89 mm
  to the right; their places are in `carrier_slots`). The drive is the
  heading indicator's (`twin_drive.inc.scad`).
  A straight mini USB plug fits under the airspeed indicator's case.
- **Print orientation**: the case, the face plate and the dial back side
  down, the ball disc, back plate and carrier front down, the gears
  flat, the pinion on its teeth, the airplane front down (white).
  Everything else black.

The `assert`s check the face (the airplane's wings inside the marks, L,
R and the words in the window and clear of the tube, the ball in the
tube and the ball ring filling it), the front stack (the axle ending in
the back plate, the ball disc inside the dial's rim), the gears, the
ball sensor's wires, the motors, their ears and covers, the screws,
posts and sensors (as in the heading indicator), and the carrier clear
of the heading indicator's and under the airspeed indicator.

### The print

`make` writes `target/tc_face.pdf` (on the project page as
[face](https://robertbraeutigam.github.io/cessna172/instruments/tc_face.pdf)):
two faces, the glass's template and two ball rings, black and white.
Print at 100 % on matte photo paper. Cut the face out on its edge and
the tube's slot on the black line inside its white rim (a sharp craft
knife), punch the axle's hole; cut the ball ring on its edges. Glue the
face onto the face plate's front (the slot over the plate's slot), the
ball ring onto the ball disc, its mark at the top on the notch in the
disc's edge (over the magnet), the ball at the bottom.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | 28BYJ-48 stepper, 5 V, with its ULN2003 driver board | airplane and ball |
| 1 | Arduino Nano (ATmega328P, 5 V), mini USB cable (straight plug) | MobiFlight board of the instrument |
| 2 | A3144 hall sensor | homes |
| 4 | disc magnet 5 x 1 mm | homes (two stacked each) |
| 1 | 3 mm steel dowel pin, 20 mm | the airplane's axle |
| 1 | clear sheet 1 mm (PET or acrylic), 78 x 78 mm | glass |
| 1 | the face and the ball ring, printed on photo paper | |
| 4 | M3 x 8 button head, black | case through the sheet |
| 3 | M3 x 8 countersunk self tapping screw | back plate into the case |
| 4 | M3 x 8 countersunk self tapping screw | carrier onto the back plate's posts |
| 4 | M3 x 8 countersunk screw + nut | motor ears |
| 8 | M3 x 6 self tapping screw | ULN2003 boards |

The axle's length is a MEASURE value: check it before printing.

### Assembly

1. Magnets into motor gear A (back face) and into the ball disc's boss
   (back face); check which face pulls each sensor low.
2. Back plate: motors A and B (ears countersunk from the front, nuts
   behind), sensor A into its pocket (flat face forward, legs bent back
   through the slot). Motor gear A onto A's shaft, the pinion onto B's.
3. Dial: the ball sensor into its pocket in the front (flat face
   forward), its legs out along the groove, bent back through the hole;
   wires through the back plate's hole. Face onto the face plate, the
   ball ring onto the ball disc.
4. The airplane onto the axle's front end (pressed, glue, about wings
   level), the axle from the front through the face plate.
5. Glass into the case from behind, the face plate with the axle (its
   notch at the top), the ball disc over the axle, the dial (its lug
   into the face plate's notch, its hub into the ball disc's sleeve).
   The airplane's gear onto the axle's back end, its back face 3.2 mm
   from the end (`gear_from_end` in the build's echo). Then the back
   plate's stack, the axle into its bearing and the gears meshing, the
   posts into the dial's holes: screwed into the case (three screws).
6. The carrier onto the back plate's posts (from its back; before the
   boards: the screws are under them), the boards onto it, wire it
   (below). Flash and set up MobiFlight, let it home, and set the
   steppers' offsets (the airplane wings level, the ball between the
   wires): the homes are one a turn, so neither the airplane's angle on
   the axle nor the ring's on the disc has to be exact.
7. Into the panel: drill the four screw holes using the case as the
   template, the case into the hole from behind, the four screws.

### Wiring

| Signal | Nano pin | MobiFlight device |
|--------|----------|-------------------|
| motor A (airplane) ULN2003 IN1..IN4 | D2, D3, D4, D5 | *Stepper* airplane |
| sensor A OUT | D6 | its home input |
| motor B (ball) ULN2003 IN1..IN4 | D7, D8, D9, D10 | *Stepper* ball |
| ball sensor OUT | D11 | its home input |
| ULN2003 boards' -, sensors' GND | GND | |
| ULN2003 boards' +, sensors' VCC | 5 V | |

**USB**: one port on the powered USB hub, about 0.55 A while both motors
move (two steppers, see [USB](#wiring) above).

### MobiFlight

Two *Steppers* (pins above, coils off at rest):

- **Airplane**: 2038 steps a turn, following
  `sim/cockpit2/gauges/indicators/turn_rate_roll_deg_pilot` (the
  airplane symbol's bank in degrees, right turn positive), steps
  `$*2038/360`. The airplane turns the other way from the motor; if it
  banks the wrong way, give the motor its pins the other way round. The
  L and R marks are 20 degrees under wings level (`rate_a`): check in a
  2 minute turn that the dataref's value lands on them, and move
  `rate_a` (or scale the steps) if it does not.
- **Ball**: 10190 steps a turn (5 motor turns), following
  `sim/cockpit2/gauges/indicators/slip_deg` (the ball's deflection in
  degrees), steps `Max(-32, Min(32, $))*10190/360` (limited to the tube's ends,
  ±32 degrees: `slot_a`). The ball to the right
  turns the disc counter clockwise; the pinion and the ring turn the same
  way. One degree of slip moves the ball one degree along the tube; if
  it looks too lively or too dull next to X-Plane's own panel, scale the
  steps.
- **Offsets**: after homing, set each stepper's offset so the airplane
  is wings level and the ball sits between the wires.
