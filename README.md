# Cessna 172 home cockpit

A home cockpit of the Cessna 172 for the X-Plane flight simulator. The parts
are designed in [OpenSCAD](https://openscad.org/) and 3D printed, and the
controls are read by [MobiFlight](https://www.mobiflight.com/) on an
Arduino Mega.

Each cockpit component has its own directory:

| Directory | Component |
|-----------|-----------|
| [`throttle/`](throttle) | throttle quadrant: throttle, mixture and carb heat |
| [`switchpanel/`](switchpanel) | the 172N lower left switch panel: master, lights, avionics; the primer below it |
| [`ignition/`](ignition) | the ignition key switch, the left end of the switch panel |
| [`frame/`](frame) | the aluminium frame and panel sheet that everything mounts on |
| [`hub/`](hub) | the box with the MobiFlight Mega and the Cat5 ports |
| [`yoke/`](yoke) | the hollow control wheel: PTT, trim rocker, a mux inside |
| [`radio/`](radio) | the radio stack: two KX155 NAV/COMs and the KT 76C transponder, on their own Mega |

The pictures below are rendered from the current `master` by the
[Build](.github/workflows/build.yml) workflow and published, together with
all printable STLs, on the
[project page](https://robertbraeutigam.github.io/cessna172/).

## Building

The OpenSCAD binary comes from the `OPENSCAD` environment variable; the
designs use an OpenSCAD development snapshot (the AppImage pinned in the
[Build](.github/workflows/build.yml) workflow, from
[files.openscad.org/snapshots](https://files.openscad.org/snapshots/)) for
its much faster Manifold backend. Run `make` in a component directory:

```sh
cd switchpanel
make                       # render every .scad that changed (STLs + views)
make models                # only the STLs
make views                 # only the PNG views
make target/switches       # render a single file
make clean                 # remove target/
```

Output goes to `target/`. Views need a display (use
`OPENSCAD="xvfb-run -a openscad"` on a headless machine) and are trimmed and
combined into a montage if ImageMagick is installed.

A scad file can hold several printable parts. Marker comments on the line
that instantiates a part tell the Makefile what to render:

```openscad
box_lid(); // Make module lid                        -> target/<file>_lid.stl
//#big_pots(); // Ignore module                      -> never rendered
//exploded_view(); // Make view main 62,0,32         -> target/<file>_main.png
```

A leading `//` only hides a line from the OpenSCAD preview; the build still
renders it. `{{gitrev}}` in the source is replaced with the short git hash,
so the version is embossed into the parts.

Values and modules shared by several files of a component go into a
`*.inc.scad` file that the others `include`. It is not rendered itself, and
changing it renders the whole component again.

The printer is an Anycubic Kobra 3 V2 (255 x 255 mm bed). Large parts must
fit on it, and the files check it. Values that depend on bought parts
are marked MEASURE in the source; `assert()`s check that the derived
geometry still fits, so a wrong measurement fails the build instead of
printing a bad part.

# Cockpit frame

[`frame/`](frame): the frame on the desk that carries all components, and
the panel sheet over it.

[![Cockpit frame](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)

The frame is all 2020 extrusion (one profile, M5 T-nuts everywhere) in two
parts, each built on its own and then bolted together:

- **Front part**, vertical, in front of the desk edge: a rectangle (top
  bar, bottom bar, an upright at each end) with an upright on each side of
  the yoke bay. The bottom bar lies just under the desk top, its top at
  desk height and its back against the desk edge (felt pads), so pushing
  the frame away hits a stop. One
  3 mm aluminium composite (ACM) sheet is screwed onto its front slots.
- **Desk part**, flat on the desk behind it: a ladder of a front rail, a
  rear rail and five crossbars. The front rail is cut at the yoke bay. The
  front part is bolted to the front rail with corner brackets, and a 45
  degree brace from each upright down to a crossbar stops it from rocking.
  The braces are 200 mm stock bars cut square, held by a bought 45 degree
  connector for 2020 at each end, in the obtuse angle (at the top the
  upright has 39 mm above the brace for it; a 250 mm brace would leave
  only 3 mm).

The panel is as low as the parts on it allow: the right stack sets it.
The throttle box face reaches 80 mm above the desk (it stands on the
20 mm rail, 50 mm box and a 10 mm flange; its cut-out ends at 71 mm), then
20 mm of sheet to the radio panel's cut-out, the radio panel's 84 mm front
(from about 88 to 172 mm), 20 mm of sheet and the top bar. The yoke notch is 135 mm high,
for a future 130 mm force feedback yoke (`ffb_h`; the Saitek yoke is about
100 mm), and on the left the ignition above the primer needs 185 mm
(the switch panel beside it 136 mm). The
build computes the height from these and rounds the uprights up to a
stock length (200 mm), so the panel top is 220 mm above the desk; it
checks that it stays under `sheet_h_max` (260 mm, the monitor).

Seen from the pilot, left to right:

- **Switch panel** (ignition + switches), low on the left.
- **Yoke bay**: the Saitek yoke stands on the desk, its front at the
  frame front (22 mm out from the desk edge) so it sits on the bottom bar, its housing in a notch in the sheet. Its
  own clamps go around the bottom bar and the desk (the desk is thicker
  than the bar).
  A future force feedback yoke bolts to a crossbar in the bay instead.
- **Saitek radio panel**, with the **throttle box** under it.

The frame overhangs the desk edge by 22 mm (`frame_overhang`: a 2020 and
a 2 mm felt pad), so the sheet is 22 mm in front of the desk edge; the
front rail lies 18 mm on the desk.

**Desk clamps**: the front rail runs at least 50 mm past the sheet at each
end (`ear_len`, rounded so the rail halves are 450 and 400 mm). There a
bought screw clamp with rubber jaws clamps each
rail end onto the desk (the `clamp` view): the fixed jaw on the rail, the
spine in front of it beside the sheet, the screw jaw on the desk
underside, both jaws where the rail lies on the desk (`clamp_y`, 31 mm
from the frame front). The rail is 20 mm and the desk 28 mm, so a clamp
with a 50 mm opening and at least 33 mm reach fits; the build checks
`clamp_open`, `clamp_reach` and the jaw size. No printed part is in the
load path (printed parts creep under constant load), and two clamps about
1 m apart give well over 2 kN of grip, against 50-100 N of pulling on the
controls.

Below the desk top:

- **Apron**, under the throttle: a small rectangle hanging from the bottom
  bar, two 2020 hangers (corner brackets; the right one under the end
  upright) and a lower bar between their ends, covered by a small ACM
  sheet flush under the main sheet. It carries the **pedestal** with the
  trim wheel and the trim indicator (75 x 150 mm front), centered under
  the throttle, which stands on the lower bar like the throttle box on the
  front rail, and to its right the DIY **flaps panel** (lever pot and
  indicator servo, on hub port 5; not designed yet, so its 50 x 63 mm front
  plate and 64 mm depth are placeholders), as high as the desk allows: its
  body goes through a cut-out in the apron sheet and its plate is screwed
  onto the sheet. The cut-out (`flaps_body`, 3 mm smaller than the plate
  all round) follows the panel once it is designed.
- **Parking brake**, under the bottom bar in the yoke bay, directly below
  the yoke: a thin body (22 mm) under the desk top, two M5 into the bar's
  bottom slot, and the T-handle just in front of the bar. Released, it is
  almost flush and lies sideways; set, it is pulled out 50 mm and turned
  to point down. It has no face. Its body goes between the yoke's own desk
  clamps (`yoke_clamp_gap`).

Apart from the bottom bar and the thin parking brake, `knee_w` (460 mm)
around the yoke stays open for the legs. The pedestal and the parking
brake are future components; their sizes (`pedestal_size`, `park_size`)
reserve the space (the pedestal sets the apron height; its depth and the
parking brake are guesses), and the pedestal's hole is cut when it
exists. Their bodies must stay
below the desk underside.

The rule for every component: it brings its own front face, a hole is cut
into the sheet for it and its face is screwed onto the sheet. Heavy or
pulled components also stand on the frame: the throttle box sits on the
front rail and the crossbar under its middle (its front overhangs the
front part), its face flange is screwed onto the sheet like the switch
panel's and two M5 bolts through its floor go into the front rail.
The pedestal does the same on the apron's lower bar. The [hub](#hub)
stands on the desk part behind the throttle box, across the yoke bay's
right crossbar and the throttle's crossbar: the two ears on its left wall
are bolted into the first one's top slot, the ears on its front and back
walls into the second one's (M5, T-nuts). Its front ports face the pilot
(port 3 is behind the throttle box, `hub_cable_room` (50 mm) leaves room
for the plug), its right ports face right and its USB jack left, behind
the yoke; the crossbars are as long as the hub needs.
The extrusion carries the
loads, the sheet only covers the front, so cut-outs do not weaken it.
Keep at least 25 mm of sheet to the edge and 20 mm between cut-outs, and
drill the corners of a cut-out before sawing it. Holes for future
components are cut when they arrive.

All values are in `frame.inc.scad`; the layout (cut-outs, screw holes) is
computed from the component sizes, and the build prints the cut list
(`echo`). Lengths are rounded to stock lengths: the width to 100 mm
(`round_w`), the other bars to 50 mm (`round_d`). Only the apron's lower
bar (between the leg room and the pedestal, `round_cut`) is cut to an odd
length. With the current guesses the frame is 1000 x 410 mm and 220 mm
high above the desk, the sheet 1000 x 240 mm (it also covers the bottom
bar), the apron sheet
250 x 220 mm. With the ears the frame takes 1143 mm of the desk width.

| Part | 2020 bars |
|------|-----------|
| front part | top bar 1000, bottom bar 1000, 4 uprights 200, 2 apron hangers 200, lower bar 210 |
| desk part | front rail left 450, front rail right 400, rear rail 1000, 5 crossbars 350, 4 braces 200 (cut square) |

| File | Parts |
|------|-------|
| `frame.inc.scad` | extrusion and sheet standard, component sizes, layout, checks |
| `frame.scad` | views, cut list |

**MEASURE:** the desk (`desk`, and `desk_skirt` if it has a frame or
drawer under the top at the front edge), the leg room the pilot needs
(`knee_w`), the desk clamps (`clamp_open`, `clamp_reach`, `clamp_w`,
`clamp_pad_d`), the free width between the yoke's own desk clamps
(`yoke_clamp_gap`), the Saitek yoke housing (`yoke_housing`,
guessed 283 mm wide like the radio panel and about 100 mm high; spec
sheet: 310 mm wide with the wheel), the force feedback yoke's height
(`ffb_h`), the radio panel body that goes through the sheet (`radio_body`,
from Logitech's "Construction dimensions for Flight Panels" drawing) and
the panel height the monitor allows (`sheet_h_max`).

The ignition and the switch row each have their own hole, 1 mm larger
than their back all round, with 20 mm of sheet between them; the
ignition's is 49 mm higher (`switch_ign_rise`). Drill the M3 mount holes
through the panels' own holes, with the panels in place. The primer has
its own, smaller hole under the ignition key, 20 mm of sheet below the
ignition's, 1 mm larger than its square back, and its four flange
holes are drilled the same way. The same goes for the throttle box: its cut-out
is 1 mm larger than the box at the sides and the top, with 40 mm of
sheet left under it (it starts at the rail top), and its
flange holes are drilled with the box in place.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 21 | 2020 extrusion, 6 mm slot | front part: top bar, bottom bar, 4 uprights, 2 apron hangers, lower bar; desk part: front rail left and right, rear rail, 5 crossbars, 4 braces (cut square) |
| 8 | 45 degree connector for 2020 | brace ends |
| - | corner brackets, M5 screws, M5 T-nuts | frame joints, and the front part onto the front rail |
| 2 | 3 mm ACM sheet | panel, cut to frame_w x (sheet_h + 20); the apron sheet |
| 47 | M5 button head screw + T-nut (+ washer at the throttle box floor) | sheets, throttle box, pedestal, parking brake and hub |
| 2 | screw clamp with rubber jaws, 50 mm opening | rail ends onto the desk |
| 3 | felt pad | on the bottom bar's back, against the desk edge |

## Connections

- The **hub** (see [Hub](#hub)) holds the Arduino Mega with the MobiFlight
  firmware and 6 RJ45 ports. A powered USB hub next to it takes the USB
  cables (Mega, Saitek yoke, Saitek radio panel, later the
  FFB yoke), so one USB cable runs to the PC.
- Every MobiFlight component connects to its own hub port with one
  straight Cat5 patch cable, soldered straight to the component (see
  [Cables](#cables)): everything inside a component is soldered, the plug
  at the hub is the only separation point.
- There are two kinds of port (see [Port pinout](#port-pinout)): a **mux
  port** for a component with many switches (one CD74HC4067 mux), and a
  **direct port**, whose signal wires each go to their own Mega pin
  (four lines and the servo power on ports 4 and 5, six lines on port 6),
  for servos, encoders, pots and a few switches. Only 5 V and GND are the
  same on both, so one cable carries everything a component like the
  pedestal or the flaps needs.
- The **radio stack** (see [Radio stack](#radio-stack)) does not use the
  hub: its encoders, displays and buttons need more pins than the ports
  have, so it has a second Mega of its own, on its own USB cable to the
  powered USB hub.

### MobiFlight

[MobiFlight](https://www.mobiflight.com/) is free and open source (MIT,
[GitHub](https://github.com/MobiFlight/MobiFlight-Connector)). The
MobiFlight Connector runs on the PC (**Windows only**) and talks to X-Plane
11/12 directly through its datarefs and commands (X-Plane's UDP interface,
no plugin). It also flashes the MobiFlight firmware onto the Mega over USB.

In the Connector, the Mega gets one device per thing on a port: a
*Multiplexer* per mux (its SIG pin as the data pin; S0-S3 are set once, on
the first mux, and shared by all), and a *Servo*, an *Encoder*, an *Analog
input* or a *Button* on a Mega pin. Each input (a mux channel is a button)
then sets a dataref or sends a command on press and on release, each output
(servo) follows a dataref. The configuration is a file: keep it with the
cockpit.

MobiFlight sends an X-Plane command only once; it cannot hold one while a
button is pressed (still open:
[MobiFlight-Connector#2405](https://github.com/MobiFlight/MobiFlight-Connector/issues/2405)).
Where a command has to be held, like the ignition START, a small
FlyWithLua (NG) plugin
script in X-Plane does it (see [In X-Plane](#in-x-plane)).

MobiFlight reads encoders only on their own pins, not through a mux, and
drives servos straight from Mega pins, without a second board: that is
what the direct ports are for.

### Port pinout

At the hub it is the RJ45 pin, at the component the wire color (the cable
is soldered there). Pins 4 and 5 (the blue pair) are 5 V and GND on every
port; at the hub they are joined on the shield (see
[Hub wiring](#wiring)) for all 6 ports.

**Mux ports (1-3):**

| Pin | T568B color | Signal | At the hub |
|-----|-------------|--------|------------|
| 1 | white-orange | S0 | mux bus, Mega pin D38 |
| 2 | orange | S1 | mux bus, Mega pin D40 |
| 3 | white-green | S2 | mux bus, Mega pin D42 |
| 4 | blue | 5 V | all ports, Mega 5 V |
| 5 | white-blue | GND | all ports, Mega GND |
| 6 | green | S3 | mux bus, Mega pin D48 |
| 7 | white-brown | SIG | the port's own Mega pin (the mux output) |
| 8 | brown | AUX | the port's own analog Mega pin (A11-A13): one analog input |

S0-S3 are shared by every mux (MobiFlight takes them once per board); at
the hub pins 1, 2, 3 and 6 of ports 1-3 are joined on the shield (the
mux bus). Every SIG line gets a 4.7 kOhm pull-up resistor to
5 V there (one of the 8 in the shield's resistor network). MobiFlight turns on the Mega's internal pull-up, but that is
weak (20-50 kOhm): on a long cable the line rises slowly after an open
switch (the cable's capacitance) and picks up the S0-S3 edges next to it,
so the mux could read a ghost input. MobiFlight's docs recommend an extra
one for long wires. It does not matter at which end of the cable it sits,
so it is on the hub's shield and the components have no resistors.

AUX goes straight to its analog pin, with no resistor on the shield: it is
meant for a pot. A button on it would need a 4.7 kOhm pull-up and a servo
a 330 Ohm in series (and power, which a mux port does not have) added on
the shield first.

**Direct ports (4-6):**

| Pin | T568B color | Signal | At the hub |
|-----|-------------|--------|------------|
| 1 | white-orange | servo 5 V (ports 4, 5), or line E (port 6) | the servo rail (the double header's other 5 V pin), or its own Mega pin |
| 2 | orange | servo GND (ports 4, 5), or line F (port 6) | the servo rail (the double header's other GND pin), or its own Mega pin |
| 3 | white-green | line A | its own Mega pin |
| 4 | blue | 5 V | all ports, Mega 5 V |
| 5 | white-blue | GND | all ports, Mega GND |
| 6 | green | line B | its own Mega pin |
| 7 | white-brown | line C | its own Mega pin (on ports 4 and 5 a servo signal through 330 Ohm) |
| 8 | brown | line D | its own Mega pin |

Each line is whatever the component needs: a pot wiper (analog Mega
pin), an encoder contact, a switch (any digital pin) or a servo signal.
The rules:

- **A servo** takes its power on the orange pair (pin 1 5 V, pin 2 GND) and
  its signal on pin 7. At the hub they go to the double header's second
  5 V and GND pins, wired on their own (see [Hub wiring](#wiring)), not to
  the blue pair. These are the same nets as the first pins on the Mega
  board, but the servo's current peaks then flow in their own wires and do
  not move the GND and 5 V of the blue pair that the pots and the logic on
  the same cable use. On ports 4 and 5 pins 1 and 2 are always the servo
  power (bridged on the shield); only on port 6 they are two more lines (E
  and F).
- **Pots** go between 5 V and GND of the blue pair, the wiper on a line.
- **Switches and encoders** go to GND (pin 5) like on a mux, active low,
  with a 4.7 kOhm pull-up to 5 V on the hub's shield on each
  line (the same reason as the mux SIG pull-up). Pots get none: it would
  pull the wiper reading.

**A wrong port does not damage the Mega**: every Mega output that goes
into a cable has a 330 Ohm resistor in series at the hub (S0-S3 and each
servo signal, on the shield), so a component in the wrong kind of port can
not short a Mega output against a switch to GND or a pot at its end stop;
mostly it only mixes up the inputs in the sim until the cable is in its own
port again (they are numbered). It is not impossible to short the supply,
though: pins 1 and 2 of ports 4 and 5 are the servo 5 V and GND, without a
resistor. A component that uses pins 1 and 2 as lines (only possible on
port 6), plugged into port 4 or 5, can join them to its other wires, e.g.
a pot wiper on pin 1 at its GND end stop shorts 5 V to GND through the
wiper. The direct ports are on the hub's right wall, the mux ports on its
front, so they are hard to mix up.

### Cables

At the hub every cable has its RJ45 plug; at the component it is soldered
straight to the mux or to the parts, without a connector. Cut a patch
cable to length, or in half for two components:

- **Stranded** patch cable, not solid installation cable: solid wire breaks
  next to a solder joint after a few bends.
- **Pure copper** ("CU"), not CCA (copper clad aluminium, common in cheap
  cables): CCA hardly takes solder and breaks easily.
- **Check the colors** against the [Port pinout](#port-pinout) before
  soldering, with a multimeter or a cable tester: most patch cables are
  T568B, a few are T568A (orange and green pairs swapped).
- **Strain relief**: tie the jacket down on the component right before the
  wires fan out (the switch panel's mux carrier has a block for a cable
  tie next to the mux), so pulling the cable never pulls a solder joint. Tin the strands
  first and put heat shrink over every joint; cut unused wires short and
  insulate them.
- Measure the run to the hub and leave some slack: the length is fixed
  once it is soldered.

### Ports

**Mux ports**:

| Port | Component | SIG | AUX |
|------|-----------|-----|-----|
| 1 | [yoke](#yoke): PTT left and right, trim rocker | D22 | A11 (free) |
| 2 | free | D24 | A12 |
| 3 | switch panel | D28 | A13, primer |

**Direct ports** (pin 4 5 V and pin 5 GND on all of them):

| Port | Component | Pin 3 (A) | Pin 6 (B) | Pin 7 (C) | Pin 8 (D) | Pins 1, 2 |
|------|-----------|-----------|-----------|-----------|-----------|-----------|
| 4 | pedestal: trim wheel, trim indicator, parking brake | D26, encoder A | D32, encoder B | D44, trim servo | D36, parking brake | servo power |
| 5 | flaps: lever and indicator | A10, lever pot | D34 (free) | D46, flaps servo | D30 (free) | servo power |
| 6 | [throttle quadrant](#throttle-quadrant) | A2, throttle | A5, mixture | A6, carb heat | A7 (free) | A0, A1 (free) |

The pins are where the shield wires them (see [Hub wiring](#wiring)):
MobiFlight takes any pin for a button, encoder or servo, pots need analog
ones. The shield only reaches the analog headers and the double header
(D22-D53, of which it wires the even ones), not the digital header
(D0-D21), whose pins 8-13 are off the 2.54 mm grid. A component that needs more than a port
gives gets a second port of the kind it needs.

The direct ports leave room: a Mega has 16 analog and 54 digital pins, and
MobiFlight takes at most 6 multiplexers on one (`MaxInputMultiplexer` in its
board file); this hub has 3 mux ports, 2 of them used. More components than the 6 ports get
a second hub with its own Mega, on its own USB cable to the powered USB
hub; the Connector shows it as a second board. Two Megas can not drive the
same S0-S3 bus.

- **Pedestal**: one cable for everything on it. The trim wheel encoder
  (EC11 type, 20 detents) on lines A and B, its common on GND; set the
  encoder type in the Connector to match the encoder (steps per detent) and
  test that a fast spin does not lose steps. The trim indicator servo (9 g)
  on pin 7 and the orange pair.
- **Parking brake**: one switch, on line D of the pedestal port: two wires
  from the pedestal along the bottom bar to the brake under the yoke. A
  *Button* on D36 in the Connector.
- **Flaps** (DIY, on the apron next to the pedestal): the lever pot on
  line A, the indicator servo (9 g) on pin 7 and the orange pair. Two lines
  are left (e.g. a switch at the flap detents, if the lever gets one).
- **Throttle quadrant**: its three pots on lines A-C, between the blue
  pair (see [Cable to hub port 6](#cable-to-hub-port-6)); an *Analog input* per
  pot in the Connector. Line D and pins 1 and 2 are free (e.g. a pot for a
  fourth control; see the wrong port warning in
  [Port pinout](#port-pinout) before using pins 1 and 2).
- **Likely later**: panel light dimmers (pots, on free lines), steam gauges
  (servos on a direct port, or steppers with a driver board),
  outputs (annunciator lights, avionics displays): MobiFlight drives them
  through 74HC595 shift registers or MAX7219 drivers with three lines each
  (data, clock, latch), which fit a direct port once their lines get a
  330 Ohm in series on the shield like the other Mega outputs.

**Logic only** on the blue pair: the muxes, pots, encoders and hall
sensors draw some tens of mA in all (the ignition's five hall sensors
the most). The servos take their current on their own orange
pair from the Mega 5 V for now (see [Power](#power-later)); put a 470 uF capacitor across the supply
at each servo. A 9 g servo draws about 0.15-0.3 A when it moves and up to
0.7 A stalled, about 0.2 V drop on 2 m of the 24 AWG pair. Two of them on
the Mega's USB 5 V is the limit: if the Mega resets when both move at
once, feed the servos from a 5 V supply. GND has to stay in the cable
with the signals, and the logic 5 V has to come from the Mega, so a
component is never powered while its inputs are not (or the other way
round).

### Why not a serial bus

A serial bus (I2C, UART, RS485, CAN) would need 2 signal wires instead of
the mux's 5 lines, but it does not save a cable: every component gets one
Cat5 cable either way, with 8 wires, and the S0-S3 lines are shared, so
each extra mux costs only one Mega pin. The options:

- **74HC165 input shift registers**: MobiFlight reads them (*Input Shift
  Register*, 8 inputs per chip, chained). Three lines (data, clock, latch)
  instead of the mux's five, but they also have to go to every component,
  and 8 pull-up resistors per chip: no gain over the mux.
- **I2C port expanders** (MCP23017, PCF8574): not in the standard
  MobiFlight firmware for inputs (it uses I2C only for LCD displays), and
  I2C is made for a circuit board, not for 2 m cables.
- **UART, RS485, CAN**: these need a microcontroller in every component
  and our own firmware at both ends; MobiFlight does not speak them. The
  MobiFlight way to do that is a small board per component that runs
  MobiFlight itself (e.g. an Arduino Pro Micro, on its own USB cable to the
  powered USB hub): fine for one or two
  components, but each is one more board to flash and one more USB device.

### Power (later)

USB only for now. With lighting, gauges or the FFB yoke comes one 24 V PSU
with fused branches, a DC-DC converter to a 5 V bus, a separate cut-off
switch on the FFB motor power and one star ground at the PSU. That is not
in the hub. The servos then keep their orange pair in the Cat5, but the
shield's servo rail is fed from the 5 V bus (a 2 wire lead into the hub,
its GND joined to the Mega GND there) instead of the Mega's second 5 V
pin. Bigger loads (backlighting, more servos in one component) get their
current from the 5 V bus with a 2 pin plug per component (e.g. JST-VH or
a 5.08 mm screw terminal), not from the Cat5. Leave room for that plug in
components with loads.

# Hub

[`hub/`](hub): the box with the MobiFlight Mega and the Cat5 ports.

[![Hub](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)

`hub.scad` prints the box (`hub_box.stl`, floor down) and the lid
(`hub_lid.stl`, top down). The box is 172 x 135 x 53 mm with the lid
(6 ports on two walls, `port_front` and `port_side`); the build checks that
it fits the printer bed.

- **Ports**: 6 RJ45 breakout boards, their jacks behind cut-outs in the
  walls, the numbers beside the jacks. The mux ports 1-3 are along the
  front wall, numbered from the left; the direct ports 4-6 along the right
  wall, numbered from the front (see [Port pinout](#port-pinout)), so the
  two kinds can not be mixed up. The boards are screwed onto bosses on the
  floor with M3 self tapping screws from above. Their angled 8 pin headers
  point into the box, each with a strip for the jumper plugs behind it.
- **Mega**: behind the front ports, left of the right ports' jumpers, on
  6 standoffs, its USB jack through the left wall (flush with the outside,
  so any USB-B plug fits), with a cut-out in front of the power jack.
- **Shield**: a 90 x 70 mm perfboard plugged onto the Mega's analog
  headers and its double header, and screwed down at its 4 corner holes
  onto posts on the floor in front of and behind the Mega (M3 self
  tapping), so pulling a jumper off does not lift it. Every RJ45 pin is
  plugged onto it, it carries every resistor of the hub, and it is wired
  on the bench (see [Wiring](#wiring)). It only uses the
  analog headers and the double header: they are on one 2.54 mm grid,
  the digital header is not (pins 8-13 are 1.5 mm off).
- The build checks that every Mega pin the shield takes lands on a hole
  of its grid, that nothing is soldered above the Mega's ICSP header in
  the middle (measured, `mega_icsp`), that the shield's wiring is sound
  (no hole on two lines, every line in one piece from its port pins
  through its resistor to its Mega pin, bridges only between neighbouring
  used holes and on top only where that side is free), that the posts stand beside the Mega and behind the front
  ports' jumpers, and the room for a plugged jumper (20 mm: a 14 mm
  Dupont housing and the bent wire) behind the RJ45 pins and above the
  shield.
- The lid has a locating lip and is screwed onto four corner posts. Four
  ears on the floor (5.3 mm holes, M5 + T-nut) bolt the box onto the
  frame's desk part behind the throttle box (see [Cockpit
  frame](#cockpit-frame)): two on the left wall into the yoke bay's right
  crossbar, one on the front and one on the back wall into the throttle's
  crossbar. Their spacing (`ear_slot_dx`) is the frame's, and
  `frame.inc.scad` checks it.

Nothing in the box is soldered: each port is one 8 wire ribbon of
female-female jumpers from its RJ45 pins to its header on the shield, in
the same order (some of them to loose pins beside what they go to), and no
wire goes to the Mega. The shield comes off the
Mega (4 screws), so the Mega can be reused. The MobiFlight firmware is
flashed from the Connector through the Mega's USB jack in the left wall,
with the lid on.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | Arduino Mega 2560 | MobiFlight board |
| 6 | RJ45 breakout board, 34 x 28 mm, angled 9 pin header (1-8 and SH) | the ports |
| 24 | M3 x 6 self tapping screw | RJ45 boards, 4 each |
| 6 | M3 x 6 self tapping screw | Mega |
| 4 | M3 x 8 self tapping screw | shield, through its 3 mm corner holes |
| 4 | M3 x 10 self tapping screw | lid |
| 1 | perfboard, 90 x 70 mm, 2.54 mm grid (31 x 26 holes), double sided, plated through holes | shield |
| 1 | male pin header, 2 x 18, straight | shield onto the Mega's double header |
| 2 | male pin header, 1 x 8, straight | shield onto the Mega's analog headers |
| 8 | male pin header, 1 x 8, straight | the headers of ports 1-3 and 6, the strip of pins with a pull-up, three cut into the other loose pins |
| 6 | 330 Ohm resistor | in series with S0-S3 and the 2 servo signals |
| 1 | resistor network, 4.7 kOhm x 8, bussed, SIP 9 (marked A09-472, e.g. Bourns 4609X-101-472LF) | pull-ups: 3 mux SIG lines, 5 direct-port switch/encoder lines |
| - | a bit of tinned copper wire | bridges between neighbouring pins |
| 48 | female-female jumper wire, 15 cm, as 8 wire ribbons | RJ45 pins to the shield, 8 per port |

Per port used: a stranded copper Cat5 patch cable, soldered at the
component end (see [Cables](#cables)).

The RJ45 boards (`rj_*`) are measured: 34 x 28 x 1.4 mm, 4 corner holes
28 x 11 mm apart (the front ones 4.5-5 mm from the jack edge), the jack
16 mm wide and 15 mm high in the middle, flush with the board edge, and
one row of 9 angled pins (1-8 and SH; the header 7 mm from the edge on
the pin 1 side, 4 mm from the other) 2 mm before the back edge, reaching
4 mm past it. Which side pin 1 is on does not change the printed box. If
one of their holes is smaller than about 3.1 mm, drill it out, keeping
clear of the traces around it.

The perfboard (`sh`) is measured too: 90 x 70 mm, 31 x 26 holes, 4 corner
holes of 3 mm, 3 mm from both edges. The Mega values, its header
positions included (`mega_analog`, `mega_double`), are from the Arduino
drawing.

### Wiring

**The shield** is built on the bench as in the drawing (`shield` view of
`hub.scad`, which also draws it in the box from the same lists,
`sh_*`): the component side, the wiring of its back drawn through it,
the front edge (ports 1-3) at the bottom. The board has to be double
sided with plated through holes (the usual green 9 x 7 cm prototype
boards are): a hole joins its pads on both sides.

[![Shield](https://robertbraeutigam.github.io/cessna172/hub/hub_shield.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_shield.png)

Every line that goes to the double header has a row of its own: its 330
Ohm resistor's lead, or its pin of the pull-up network, is in the hole
beside the Mega pin, and a solder bridge on top joins that hole to the
pin. The Mega pins' pads on the back are under their header's plastic, so
they can only be soldered on top, and nothing else is joined to them. An
analog line goes from its port pin on the back to the hole behind the
analog pin, a bridge on top onto it. The rows of the double header's
inner (even) column are the lines; its outer column has no free hole
beside it and only gives the servo power (its 5 V and GND pins, at the
ends). Apart from these, a solder bridge joins two neighbouring pins
that belong together; the pins are placed so that this is every
connection, and the shield has no wires.

- **Mega side**: the 2 x 18 header under the double header and the two
  1 x 8 headers under the analog headers, pushed in from below (their
  plastic under the board, resting on the Mega's sockets) and soldered on
  top. Solder all their pins, used or not: together they hold the shield.
  Keep each of their joints on its own pad, apart from the bridges (yellow
  in the drawing).
- **Port headers**: 1 x 8 headers in RJ45 pin order for ports 1-3 and 6
  (pin 1 dark red in the drawing; plug each ribbon on the same way round
  as on its RJ45 board). The other pins are loose (blue in the drawing,
  marked port.pin), each pulled out of its port's header (pliers on the
  pin, the plastic held) and set beside what it goes to, bridged to it
  (each a line of its own, or 5 V, GND or servo power, which are joined
  anyway):
  the 8 pins with a pull-up (SIG of the mux ports, A, B, D of port 4, B,
  D of port 5) as one more 1 x 8 strip next to the pull-up network, each
  beside its network pin; the servo signals beside their 330 Ohm; port
  5's pot two holes behind A10; the servo power of ports 4 and 5 beside
  the double header's outer 5 V and GND; the 5 V pins (pin 4) of all six
  ports in a row of neighbours onto the Mega's 5 V, the GND pins (pin 5)
  the same onto its GND. Ports 4 and 5 have no header left: mark their
  jumpers. The mux ports P1-P3 stand side by side over the analog header,
  pin 8 (AUX) at the front: their pins 1-6 are neighbours, bridged into
  the mux bus (S0-S3, 5 V and GND), and each AUX pin is two holes behind
  its analog pin; port 3's S0-S3 pins are next to their 330 Ohm
  resistors, bridged to them. Port 6 lies along the analog header the
  same way.
- **Resistors**: each 330 Ohm resistor stands in its row, the body on the
  marked hole, the lead bent down into the hole beside the Mega pin;
  S0-S3 stand a hole further left, next to port 3's pins, the lead over
  the free hole between (the bodies of neighbouring rows touch, which
  does no harm). The pull-ups
  are one bussed network (a row of 8 resistors with one common pin),
  standing across the 8 pull-up rows two holes before the Mega pins, each
  pin bridged to the hole beside its Mega pin, its common pin 1 (the dot)
  in the 5 V row above them: each pull-up line has its own resistor to
  the one 5 V pin.
- **Back**: the bridges between neighbouring pins (a blob, or a short
  piece of tinned wire); there are no wires. Keep the joints flat: the shield sits 2.5 mm above the Mega's
  digital header and its 2 x 3 ICSP header in the middle. Nothing is
  soldered above the ICSP header (the red frame in the drawing: the build
  checks it); run the wires around it or flat over it.

Every line on the shield:

| Line | From (port.pin) | Through | To the Mega |
|------|-----------------|---------|-------------|
| S0, S1, S2, S3 | P1.1-P2.1-P3.1, .2, .3, .6 (bridged) | 330 Ohm | D38, D40, D42, D48 |
| SIG | P1.7, P2.7, P3.7 | 4.7 kOhm to 5 V | D22, D24, D28 |
| AUX | P1.8, P2.8, P3.8 | - | A11, A12, A13 |
| port 4 | A P4.3, B P4.6, D P4.8 | 4.7 kOhm to 5 V | D26, D32, D36 |
| port 4 servo | C P4.7 | 330 Ohm | D44 |
| port 5 | A P5.3 (pot) | - | A10 |
| port 5 | B P5.6, D P5.8 | 4.7 kOhm to 5 V | D34, D30 |
| port 5 servo | C P5.7 | 330 Ohm | D46 |
| port 6 | E P6.1, F P6.2, A P6.3, B P6.6, C P6.7, D P6.8 | - | A0, A1, A2, A5, A6, A7 |
| 5 V | P6.4, P1.4-P2.4-P3.4, P4.4-P5.4, the network's pin 1 | - | 5V (the double header's inner pin) |
| GND | P6.5, P1.5-P2.5-P3.5, P4.5-P5.5 | - | GND (inner pin) |
| servo power | P4.1-P5.1 and P4.2-P5.2 | - | the other 5V and GND (outer pins) |

D50 and D52 are free rows, and A3, A4, A8, A9, A14 and A15 are free analog pins
(each has a free hole behind it).

Check every line with a multimeter before the shield goes on: each port
pin to its Mega pin (through its resistor), and no line to its neighbour,
5 V or GND. The servo power has its own wires to the Mega's second 5 V
and GND pins (the same nets on the Mega board), so the servos' current
peaks do not move the 5 V and GND wires the pots read against.

**Ribbons**: peel 8 wires off a ribbon of jumper wires per port and keep
them together, so the colors are in the same order at both ends; peel
the wires of the loose pins off the ribbon to their pins (ports 4 and 5:
all of them). Tie each
Cat5 cable to the box so a pull on it does not reach the jumpers; once
everything works, a dab of hot glue across the plugs keeps them in (it
peels off).

Add a Servo device on D44 and D46 in the Connector.

### Assembly

1. Push a few loose header strips into the Mega's double header and
   analog headers and lay the perfboard on them: it must drop onto all
   the pins at once. Then build the shield on the bench (see
   [Wiring](#wiring)), the Mega side headers soldered while plugged into
   the Mega so they stay straight, and check it with a multimeter.
2. Screw the RJ45 boards onto their bosses (M3 x 6) and the Mega onto its
   standoffs.
3. Plug the shield onto the Mega and screw it onto its posts (M3 x 8).
4. Plug each port's ribbon from its RJ45 board onto its header on the
   shield.
5. Screw the lid on.

# Throttle quadrant

[`throttle/`](throttle): throttle, mixture and carb heat in one box.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

Each control is a 6 mm rod that comes out of the front of the box and moves
the slider of a linear potentiometer inside: long pots (130 mm) for the
throttle and mixture, a short one (75 mm) for the carb heat. The pots sit on
stands and are held down by printed pins. A printed clamp on each rod has a
slot that takes the pot's slider ear, so pulling the knob moves the slider.
MobiFlight on the [hub](#hub) reads them: one Cat5 cable to direct port 6,
soldered straight to the pots, with no board in the box.

The box mounts in the [cockpit frame](#cockpit-frame) and has no lid: it
goes through a cut-out in the panel sheet and stands on the frame's front rail. Its
front wall is the face, with a 10 mm flange on the top and the two sides
(none at the bottom, where the box sits on the rail) that is screwed onto
the sheet with M3 screws, nuts behind the sheet. Two M5 bolts through the
floor, at the front between the rod supports, go into T-nuts in the
front rail's top slot, so pulling a knob does not load the sheet alone.

| File | Parts |
|------|-------|
| `throttle_box.scad` | the box with its face flange (printed in one piece), pot holder, cable cradle top |
| `carb_heat_knob.scad` | carb heat knob and button |
| `clamp.scad` | rod clamps for the pot sliders |
| `pin.scad` | pot hold-down pins |

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | linear potentiometer, 130 mm | throttle, mixture |
| 1 | linear potentiometer, 75 mm | carb heat |
| 3 | 6 mm rod, with nuts | one per control |
| 1 | Cat5 patch cable, stranded, pure copper (see [Cables](#cables)) | to hub port 6 |
| - | M3 screws | pot hold-downs, cable cradle, one in each rod clamp (M3 x 10) |
| 2 | throttle and mixture knob, printed from other sources (not in this repo; the views only show them) | on the throttle and mixture rods |
| 5 | M3 x 10 pan head screw + nut | face flange onto the cockpit sheet |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the front rail (counted in the frame) |

## Cable to hub port 6

The Cat5 cable to [hub port 6](#ports) comes in through the hole at the
left of the back wall and is clamped in the cable cradle (its printed top
screwed onto the block on the floor, `cable_d` is the jacket, measure it),
so pulling the cable does not pull the solder joints. Behind the box it
runs through the gap to the hub's right wall. Colors are T568B (see
[Port pinout](#port-pinout)):

| Wire | Signal | To |
|------|--------|----|
| blue | 5 V | carb heat pot, end tab |
| white-blue | GND | carb heat pot, other end tab |
| white-green | line A (A2) | throttle pot wiper |
| green | line B (A5) | mixture pot wiper |
| white-brown | line C (A6) | carb heat pot wiper |
| white-orange, orange, brown | - | cut short, insulate |

Two short wires take 5 V and GND on from the carb heat pot to the same end
tabs of the throttle and the mixture pot, the same end of every pot to
5 V, so all three read the same way. If a control reads backwards, swap
its pot's two end tabs (or invert it in the Connector).

# Switch panel

[`switchpanel/`](switchpanel): the lower left switch panel of the 172N.
Similar in function to the Saitek Switch Panel, but it should look as close
to the real panel as possible. Every switch position is a raw input for
MobiFlight, active low, like a switch to GND.

It is two panels, printed separately and mounted side by side: the
[ignition](#ignition) on the left, a component of its own
([`ignition/`](ignition)), and the switch row, which also carries the
input multiplexer for both. Their basics are in `panel.inc.scad`, which is
in both directories (keep the copies identical): both are 3 mm thick,
with the same rim, flange, mount holes and lettering. The back of each
panel is 80 mm high (`panel_h`), closed by an 8 mm rim, and goes through a
hole in the cockpit sheet ([frame](#cockpit-frame)); a 10 mm face flange
(`flange_w`) all round sits on the sheet and is screwed to it with M3
screws, nuts behind the sheet; the face is 3 mm in front of the sheet.

The ignition sits 49 mm higher than the switch row (the frame's
`switch_ign_rise`), to make room for the [primer](#primer) under its
key, like in the X-Plane 172N: a third, small panel of its own
(`primer.scad`) with its own hole in the sheet. So the two panels are
separate, each with its own hole and its flange all round, their faces
2 mm apart (20 mm of sheet between the holes). `panel.inc.scad`
takes the height of the back as a parameter for it.

## Primer

[![Primer](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)

`primer.scad`: the push-pull primer with its twist lock, read by a linear
pot. It is a separate 47 x 47 mm panel under the ignition, centered
under its key like in the X-Plane 172N, left of the switch row and as low
as it, in its own cut-out in the sheet, so the ignition panel stays as it is. The knob pulls out 45 mm (`stroke`,
about the 1¾" of a panel plunger primer) and pushes back in; fully in, it
turns a quarter turn clockwise to lock, and only then. Turned back
(counterclockwise), a spring pops it 5 mm out (`pop`), like the real one.

### How it works

The same idea as the [throttle quadrant](#throttle-quadrant): a 6 mm rod
moves the slider of a linear pot, through a clamp-like carrier with a slot
over the pot's slider ear. The pot is the 75 mm one used for the carb heat.

- **Knob and twist lock:** the knob's 10 mm stem slides in a square tube on
  the back of the panel, the front bearing. A lug on the end of the stem
  runs in a keyway along the tube, so the knob cannot turn while it is out
  and always comes back lined up. At the back of the tube the keyway opens
  into a quarter turn pocket: fully in, the lug turns into it and the end of
  the keyway holds it (locked). Pulled out, the lug stops on the back of
  the panel plate.
- **Rod:** an M3 set screw in the knob's head holds the rod. The rod runs
  back through the bracket, whose front wall (screwed onto the end of the
  tube) and rear wall are two more bearings.
- **Pot:** in the bracket the pot sits on two stands, held down by two
  printed straps, with its slider ear pointing at the rod. The carrier on
  the rod is held between two rod collars (the throttle's plain clamp). The
  rod turns in it for the twist lock; the carrier itself slides between the
  bracket's two ribs, so it cannot turn.
- **Pop out:** a compression spring on the rod, between the rear collar and
  the rear wall. The collar only reaches it in the last 5 mm before the knob
  is in, so the locked lug holds it compressed, and unlocking pops the knob
  out that far; the rest of the stroke is free.

The bracket is beside the rod towards the pilot's right, about 49 x 26 mm
across (it reaches about 38 mm to the side of the rod, its walls 11 mm to
the other side over the tube), and with the knob in, the rod ends about 193 mm behind the panel,
under the ignition and clear of the frame's upright and brace. The
bracket is wider than the cut-out, so it goes on from behind the sheet.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | linear potentiometer, 75 mm (like the carb heat one) | primer position |
| 1 | 6 mm rod, 208 mm (`rod_len`) | knob to the pot carrier |
| 1 | compression spring, about 9 mm OD, 6.8 mm ID, 15 mm long (`pop_spring_*`) | pops the knob out when unlocked |
| 2 | `throttle/clamp.scad` plain clamp (`clamp_plain.stl`), with an M3 screw + nut | rod collars on both sides of the carrier |
| 4 | M3 x 12 socket head screw | bracket onto the tube |
| 4 | M3 x 10 screw | pot straps onto the stands |
| 1 | M3 x 6 set screw | knob onto the rod |
| 4 | M3 x 10 pan head screw + nut | face flange onto the sheet |
| - | 3 wires | pot to the switch panel's mux board |

Printed: `primer_panel.stl` (front side down), `primer_face.stl` (front
side up), `primer_knob.stl` (on the end of its stem), `primer_bracket.stl`
(on its spine), `primer_strap.stl` (2x), `primer_carrier.stl`.

The pot's travel (`pot_travel`) is measured: 60 mm, so the 45 mm stroke
uses the middle three quarters of it (the build fails if the stroke comes
within 4 mm of the travel). **MEASURE:** the pot's slider ear (`pot_ear`)
and the spring you pick (`pop_spring_od`, `_id`, `_len`, `_solid`): it
has to fit over the rod and on the collar, and it must not go solid
before the knob is in; the bracket gets longer for a longer spring. A
stiffer spring pops harder, the pot slider's friction works against it.

### Assembly

1. Paint the label, put the face on the panel, push the panel through its
   cut-out and screw the flange onto the sheet.
2. From behind: put the knob's stem into the tube, the lug in the keyway.
3. Screw the bracket onto the end of the tube (hex key through the holes
   in its rear wall).
4. Solder three wires to the pot, put it onto its stands and screw the
   straps on.
5. Push the rod in from the back: through the rear wall, the spring, a collar, the
   carrier (its slot over the pot's ear), the other collar, the front wall
   and into the knob, and tighten the set screw.
6. With the knob out, slide the carrier to where the ear is 22.5 mm
   (`stroke / 2`) in front of the pot's middle, and tighten the collars
   against it so the rod still turns.

### Wiring and X-Plane

The pot connects to the switch panel's mux board: its ends to 5 V and GND
there, the wiper to the brown AUX wire of the Cat5 cable, which goes to
the Mega's A13 at the hub (port 3, see [Ports](#ports)). It is an analog
input, not a mux input. Which end goes to 5 V decides the direction; swap
them, or invert the range in the MobiFlight Connector.

In the MobiFlight Connector it is an analog input on A13 that writes the
primer's dataref. **VERIFY** which dataref the X-Plane 172 uses for the
primer with DataRefTool while working the primer in the virtual cockpit.

## Switches

[![Switch panel](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)

`switches.scad`: the switch row, laid out like the panel of the X-Plane
172N (which differs from a real one, e.g. in the split AVIONICS). The
red split MASTER (ALT, BAT) on the left, toggle switches in the middle
(PITOT HEAT, then the LIGHTS group: BCN, LAND, TAXI, NAV, STRB) and the
black split AVIONICS (BUS 1, BUS 2) on the right; the panel ends there.
Up is ON, like in the airplane: every toggle has OFF under it, the rockers
ON beside their top half, towards the toggles. The rockers have their name
above and the two switch names below them, and sit higher than the
toggles, about half way up to the breakers (`rk_raise`). Above the toggles
is a row of circuit breakers, as in the X-Plane panel; they are for show
only.

The switch list (`groups` in the source) drives the layout. The
panel is 216.6 x 100 mm (the back 196.6 x 80 mm). Like the ignition, its
front is a separate 1 mm face with the labels standing 0.8 mm out of it,
for a white paint pen; the face is printed front side up
(`switches_face.stl`), the panel front side down, so neither needs
supports, and together they are 3 mm thick. The toggle nuts, the rocker
lips and the mount screws clamp the face on. The switches and labels need about 61 mm of the back's height, the
rest is split between above and below them. The rim on the back stiffens
it.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 6 | toggle switch, M12 neck, 18 mm lever | PITOT HEAT, BCN, LAND, TAXI, NAV, STRB |
| 6 | M3 x 10 pan head screw + nut | panel onto the cockpit sheet (`mount_count`) |
| 1 | CD74HC4067 16 channel mux breakout board | all inputs, see [Multiplexer](#multiplexer) |
| 4 | M3 x 8 self tapping screw | mux onto its standoffs on the carrier, carrier (`switches_carrier.stl`) onto the panel |
| 6 | printed dummy breaker (`switches_breakers.stl`) + glue | circuit breakers, see [Circuit breakers](#circuit-breakers) |
| 1 | Cat5 patch cable, stranded copper (see [Cables](#cables)) | to hub port 3, soldered to the mux |
| 1 | cable tie, up to 3.6 mm wide | the cable onto its block (`tie`) |
| 1 | 7 pin Dupont or JST connector (optional) | ignition cable, so the panels can be separated, see [Wiring](#wiring-1) |
| - | wire, heat shrink | see [Wiring](#wiring-1) |

### Double rocker switches

[Double Rocker Switch 6-Pin 250V 16A/AC Red Rocker Illuminated On/Off](https://www.amazon.de/-/en/Double-Rocker-Switch-6-Pin-Illuminated/dp/B0DLTMGKSS),
in red for MASTER and black for AVIONICS. Two independent rockers side by
side in one housing, tall and narrow like the real split switches.

They snap into a cutout from the front: ramps on their top and bottom end
catch behind the face and the panel, which is thinned there by a pocket
in the back, to 0.5 mm behind the 1 mm face.
Dimensions from the listing (`rk_*`):

- panel cutout 22 x 28.5 mm (width x height)
- front lip 24.3 x 31.3 mm, 2 mm thick
- body 21.7 x 25.3 mm, no mounting holes
- 31.5 mm from the front to the end of the pins

**MEASURE when they arrive:** the gap between the lip and the ramps, i.e.
the panel thickness they snap onto (`rk_grip`, now 1.5 mm). Also check the
pin positions.

The lamps are neon (250 V) and will not light on 5 V; leave the lamp pin
unconnected. Each rocker has 3 pins: find the two that close when the
rocker is ON with a multimeter.

### Toggle switches

Standard M12 toggle switches, about the size of the real ones. From the
listing: body 30 x 15.5 x 15 mm, 12 mm neck (M12 thread), 18 mm lever.
Either a 2 pin ON-OFF or a 6 pin ON-ON (DPDT) switch works. Do not take an
ON-OFF-ON one (e.g. "-203"): the real switch has no center position.

The toggles go in from the back, and a nut and washer on the front clamp
them. The body sits in a 1 mm deep square pocket in the back of the panel,
so it cannot turn.

**MEASURE when they arrive** (`tg_*`, `toggle = "M12"`):

- The 30 mm is assumed to be from the top of the body to the end of the
  lugs, and 15.5 x 15 mm the body.
- The thread length (now 9.5 mm; the panel is 2 mm thick there, the washer
  and nut need about 4 mm of it).
- The nut across flats (now 14 mm). The switches are 19 mm apart, so a nut
  up to about 15 mm fits; the build checks this.
- The lever and the lug positions.

The mini MTS-202 (M6, 10 mm lever) works too: set `toggle = "MTS-202"`.
amazon.de listings:
[ETOPARS, 10 pieces](https://www.amazon.de/ETOPARS-Kippschalter-Armaturenbrett-Wippschalter-L%C3%B6tanschluss/dp/B08Z7R4RB9),
[Taiss, 10 pieces](https://www.amazon.de/MTS-202-Terminals-Positionen-Kippschalter-wasserdichte/dp/B07JNV6SCJ).

### Circuit breakers

The real 172N has a row of push-to-reset circuit breakers above the
switches, each with its name on the panel above it and its rating (A) on
the button. Here they are non-functional dummies: a hex nut with a button
on top and the rating engraved into the button, all printed as one part
(`switches_breakers.stl`, nut side down). They are glued into hex holes in
the 1 mm face, onto the panel behind it, which locate them and keep them
straight; nothing goes through the panel. Print them in black and paint the
nut silver and the rating white, or print the nut and the button in
different colors.

They are the ones of the X-Plane 172N's row over the toggles: FLAP 10,
INST 5, AVN BUS 1 15, AVN BUS 2 15, TURN COORD 5, INST LTS 5 (its ALT
FLD and WARN breakers right of AVIONICS are left out, the panel ends at
the AVIONICS switch). The list (`breakers` in the source, name lines and
rating) is placed over the toggles, one above each, from the left; the build checks that the row
still fits the panel height, and the top middle mount screw moves between
two breakers. Real breakers
(e.g. Klixon push-to-reset) would need a bigger hole and room behind the
panel, so making them functional later means a hole through the panel
as well.

### Multiplexer

All switches and the ignition go to one CD74HC4067 breakout board on the
back of the switch panel. MobiFlight reads it as a Multiplexer device: 16
inputs through one Mega pin. So everything is soldered on the panels, and
only one Cat5 cable runs to the hub (port 3).

The board sits on two standoffs on a small printed carrier plate
(`switches_carrier.stl`, printed plate down), together with the block for
the cable tie. The carrier is a part of its own, so the mux, the Cat5 cable
and the ignition can be wired up before the switch panel is printed; it is
then screwed with two M3 x 8 self tapping screws onto two bosses on the
panel back, in the strip behind the breaker labels, on the left (pilot side)
half, where the ignition cable comes in. Mount the mux with the chip
outwards, so the solder joints face you; `assert`s check that the carrier
clears the switches and fits inside the rim.

**MEASURE** (`mux_*`): the board size (41 x 18 mm) is measured; the
mounting holes (`mux_holes`, guessed on the center line 17.5 mm from the
middle) and the order of the control pins (`mux_ctl_names`) are still
guesses. It is screwed on with M3: its holes must be at least about 3.1 mm
(`mux_hole_min`), drill them out if they are smaller. If it has no
mounting holes, glue it onto the standoffs. The carrier is printed from
the same values, so check the hole positions on the board before printing
it.

#### Inputs

| Mux | Input | Mux | Input |
|-----|-------|-----|-------|
| C0 | MASTER ALT | C8 | AVIONICS BUS 1 |
| C1 | MASTER BAT | C9 | AVIONICS BUS 2 |
| C2 | PITOT HEAT | C10 | free |
| C3 | BCN | C11 | ignition OFF |
| C4 | LAND | C12 | ignition R |
| C5 | TAXI | C13 | ignition L |
| C6 | NAV | C14 | ignition BOTH |
| C7 | STRB | C15 | ignition START |

The switches are in label order (the `groups` order), and the ignition
positions are the last five (`ignition_c0`), where they were when the
ignition was wired; C10 is free. In the MobiFlight Connector every
channel is a button: a toggle or rocker sets its dataref to 1 on press and
to 0 on release, an ignition position sets the key position on press, and
START holds the starter while it is pressed through a FlyWithLua script
(see [In X-Plane](#in-x-plane)). The OFF hall sensor is needed: a position is only set on press,
so without it the key would stay on R in the sim when it is turned to OFF.

#### Cable to the hub

The mux goes to hub port 3 (see [Port pinout](#port-pinout)) with a Cat5
cable soldered straight into its control row (see [Cables](#cables)):

| Mux pin | Wire (T568B) | Mega (at the hub) |
|---------|--------------|-------------------|
| S0, S1, S2, S3 | white-orange, orange, white-green, green | pins 38, 40, 42, 48 (shared by all muxes) |
| VCC | blue | 5 V |
| GND | white-blue | GND |
| SIG | white-brown | D28, the mux's data pin in the MobiFlight Connector |
| EN | - | not to the hub: bridge it to GND on the board (enable is active low) |

The brown wire (AUX) is the [primer](#primer) pot's wiper; the pot's
other two wires go to VCC and GND on the board. The cable
comes in over the top rim and is tied down with a cable tie on the block
right of the mux on the carrier (`tie_block`: the tie goes through the slot
at the plate and around the cable in the groove on top), so the wires fan out from
there to the pins without any pull on them. The cable is 6 mm
(`cable_d`, measured); **MEASURE** the tie (`tie`, 3.6 x 1.3 mm).

The switches and the hall sensors have no pull-up resistors of their own:
the 4.7 kOhm SIG pull-up on the hub's shield pulls whichever
input is selected up (see [Port pinout](#port-pinout)). Test it on
the bench with one switch on the mux before soldering all of them.

### Wiring

Every input is wired like a switch to GND (active low, as MobiFlight expects):

- **Toggle, 2 pin:** one lug to GND, the other to its mux input. Mount it so
  it is ON with the lever up.
- **Toggle, 6 pin:** use one pole. Its middle lug (common) goes to GND, the
  bottom lug to the mux input: lever up (ON) connects the common to the
  bottom lug. Check with a multimeter.
- **Rocker:** the two pins of each rocker that close when it is ON; one to
  GND, the other to the mux input.
- **Ignition:** the A3144 outputs go to C11..C15. The sensors also need 5 V
  and GND: take them from the mux VCC and GND.
- **Primer:** the pot's ends to the mux VCC and GND, its wiper to the Cat5
  cable's brown AUX wire (not to the mux).

So on the switch panel: one GND wire daisy chained over all 10 switches to
the mux GND, and one signal wire from each switch to its C pin, soldered
straight into the board. The ignition cable (5 signals, 5 V, GND) is
soldered to the mux too; to be able to separate the two panels later, put
a 7 pin Dupont or JST connector into it. GND and VCC get several wires (switch chain, EN bridge,
ignition, primer, Cat5 cable): join the extra wires into one before the pin, with
solder and heat shrink.

### Assembly

1. Screw the mux onto the carrier's standoffs, solder the Cat5 cable to
   the mux control row and tie it onto its block. The ignition cable (or
   its connector) and the EN bridge can be soldered on now as well; the carrier
   does not need the panel yet.
2. Solder the wires to the switches; the rockers are hard to get out
   again once snapped in.
3. Lay the face on the front, put the toggles in from the back and
   tighten their nuts.
4. Snap the rockers in from the front.
5. Screw the carrier onto its bosses on the panel back and solder the
   switch wires to the mux.
6. Glue the dummy breakers into their pockets.
7. Mount the panel.

### Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock (ALT pushes BAT on, BAT pushes ALT off); X-Plane does not need
  it.

# Ignition

[![Ignition switch](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)

[`ignition/`](ignition): the left one of the two
[switch panel](#switch-panel) halves. `ignition.scad`: the OFF - R - L -
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
| 1 | spring, 5 mm OD, about 3.8 mm ID, 15 mm | START return (`start_spring_*`, measure the ID: the shoe spigot goes inside) |
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

The positions (30° apart) should be verified against the real switch.

## In X-Plane

X-Plane's key is spring loaded: writing START (4) to
`sim/cockpit2/engine/actuators/ignition_key` jumps back to BOTH in the next
frame, and MobiFlight cannot hold the starter command. So START goes
through `ignition/ignition.lua`, a FlyWithLua script: it creates the
dataref `cessna172/ignition/start` and holds `sim/starters/engage_starter_1`
while it is 1. Copy it to `X-Plane/Resources/plugins/FlyWithLua/Scripts/`.

In the MobiFlight Connector (inputs C11..C15 of the mux):

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

# Yoke

[`yoke/`](yoke): the Cessna control wheel, hollow, with a PTT button on
each horn, an electric trim rocker on the left one, a mux inside and the
cable out through the control tube.

[![Yoke](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)

The shape is the Cessna wheel's (proportions from photos, not measured): a
trapezoid hub in the middle that the control tube goes into, a bar under
it with a flat top and a bottom that sags in one curve from end to end,
and an arm ("horn") at each end, flared at its root, 34 mm wide and
leaning 25 degrees inwards (`arm_tilt`). Each arm goes on into a head at
about its width, square on its end (so its top slopes down towards the
middle) and standing out towards the pilot: a flat top pad, a 45 degree
pad between it and the pilot face for the thumb, and a thumb rest on the
head's inner side: a shelf square to the side, tilted 30 degrees so its
top faces the pilot, its top curving smoothly out of the side into the
shelf, its underside angled back into the side, so the thumb lies on it. It is 378 mm wide,
212 mm high (with the heads) and
40 mm deep, 54 mm at the heads,
with flat front and back faces and 8 mm rounded edges. The yoke ends at
the control tube: the base the tube goes into (the future force feedback
yoke, or any bearing that takes the tube) is not part of it.

`yoke.scad` holds everything. The outline is a list of points at the top
(`bar_*`, `hub_top`, `arm_end`, `arm_outer`, `arm_inner`), rounded with
`fillet` and `round`; `assert`s check that the pieces fit the bed and that the
buttons, the mux and the cable fit inside.

### How it is built

The wheel is a 2.5 mm shell, hollow from one head to the other:

- **Pieces:** it is cut in its middle plane into a front half (towards the
  panel) and a back half (towards the pilot), and each half across the bar
  into a center piece and two horn pieces. The front half is cut further
  out (`xs_fwd`, 115 mm from the middle) than the back half (`xs_aft`,
  70 mm), so the pieces overlap like bricks: the front center piece (230 x
  157 mm) reaches over both joints of the back half and holds the back
  horn pieces, the front horn pieces sit on the back horn pieces. All six
  print outer face down, without supports (the rounded edges are printed
  in 4 steps, `edge_steps`); a back horn piece is 119 x 172 mm.
- **Screws:** 22 M3 x 12 socket head screws from the front, the side the
  pilot does not see, through bosses in the front pieces into bosses in
  the back pieces (self tapping). The bosses in the bar are above and below
  its middle, so the wires pass between them; in the arms they are on the
  outer side. A lip around the rim of the back pieces goes into the front
  pieces and lines them up.
- **Heads:** separate prints, top face down (the 45 degree pad prints
  without supports), 36 mm wide and 44 mm high (`head`, `head_chamfer`). They stand out 14 mm
  towards the pilot (`head_bulge`), which the flat shells could not. A spigot under each goes into the arm's
  open end, one M3 x 10 through the front of the arm holds it.
- **Thumb rests:** separate prints, back face down (no supports), only on
  the head's flat inner side, nothing below it. Profile: a concave 9 mm
  round from the side into a shelf at 90 degrees, 16 mm out of the side,
  a rounded tip and the underside straight back into the side (`thumb`,
  `thumb_round`); it runs 26 mm along a line tilted 30 degrees, pilot end
  lower (`thumb_angle`, `thumb_pos`). Two M3 x 8 socket head screws in
  counterbores in the underside go into pads inside the head wall (glue as
  well if you like).
- **Control tube:** a 25 x 2 mm aluminium round tube (about the real 1",
  `tube_od`), 110 mm above the bar's bottom (`z_shaft`). Its end stands on
  the hub's front; a printed collar holds it, bolted onto the hub's front
  with 4 M4 (nuts inside, on a thickened wall) and through the tube with
  two M4 cross bolts at right angles (nut traps in the collar). The hub
  front has a 21 mm hole inside the tube for the cable.

### Inside

- **Buttons:** a 12 mm momentary push button with a red cap on the top
  pad of each head; on the left head's 45 degree pad, under the thumb, a
  momentary (ON)-OFF-(ON) mini rocker for the electric trim, as on the
  real wheel (the right pad is blank, room for one more button). Their nuts are inside the heads; the wires run down the inner
  side of the arms and along the bar into the hub.
- **Mux:** a CD74HC4067 board (as on the switch panel) on two standoffs on
  the back center piece's inside, under the tube's hole, the control row
  up. Inputs, all to GND (active low): C0 left PTT, C1 trim nose down, C2
  trim nose up, C3 right PTT. C4..C15 and the AUX wire (a pot, e.g. a map
  light dimmer) are free.
- **Cable:** the Cat5 cable comes out of the tube, is tied onto the block
  between the hole and the mux with a cable tie (strain relief) and
  soldered to the mux control row, like the switch panel's (see [Cable to
  the hub](#cable-to-the-hub)). It runs through the tube to hub port 1. In
  a base that turns and slides the tube, leave the cable slack behind the
  tube's end for the full travel.

| File | Parts |
|------|-------|
| `yoke.scad` | `center_fwd`, `center_aft`, `horn_fwd_left/right`, `horn_aft_left/right` (shells), `head_left/right`, `thumb_left/right`, `collar` |

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | aluminium round tube, 25 x 2 mm | control tube, the length the base needs |
| 2 | 12 mm momentary push button | PTT, left and right |
| 1 | momentary (ON)-OFF-(ON) mini rocker, 13 x 19 mm cut-out | electric trim |
| 1 | CD74HC4067 breakout board, 2 M3 x 6 self tapping screws | input mux |
| 1 | stranded copper Cat5 patch cable, cable tie | to hub port 1 |
| 22 | M3 x 12 socket head screw | shell pieces |
| 2 | M3 x 10 screw | heads |
| 4 | M3 x 8 socket head screw | thumb rests |
| 4 | M4 x 20 socket head screw, nut, washer | collar onto the hub |
| 2 | M4 x 40 screw, nut | cross bolts through collar and tube |

**MEASURE:** the tube (`tube_od`, `tube_wall`), the buttons (`ptt_*`:
hole, body length, nut size; the head's 2.5 mm top must be within their
panel range), the rocker (`trim_*`: cut-out and body depth) and the mux
board's holes (`mux_*`, as on the switch panel).

### Assembly

1. Put the buttons and the rocker into the heads (nuts inside) and solder
   a long wire to each contact; GND is one wire chained over the left
   head's contacts and one from the right head.
2. Screw the mux onto its standoffs.
3. Push the Cat5 cable through the tube. Bolt the collar onto the front
   center piece (nuts inside), push the tube into the collar up to the
   hub, drill it through the cross bolt holes and bolt it.
4. Lay the back pieces face down side by side. Push the head wires down
   the arms and along the bar, solder them to C0..C3 and GND, and the
   cable to the mux control row (bridge EN to GND); tie the cable onto its
   block.
5. Put the front pieces on, the lips into them, and screw them on from the
   front: the center piece first, then the horn pieces.
6. Screw the thumb rests onto the heads. Put the
   heads on (spigots into the arms, wires pulled through) and screw them
   on.
7. In the MobiFlight Connector, the mux on port 1 (SIG D22) is a
   Multiplexer device; C0 and C3 are buttons for the PTT, C1 and C2 for the
   trim.

# Radio stack

[`radio/`](radio): two KX155 NAV/COM radios (COM1/NAV1 on top, COM2/NAV2
under it) and the KT 76C transponder at the bottom, stacked in one
cut-out of the panel sheet like the real stack, read and driven by a
second Arduino Mega of their own. All units are 224 mm wide (`unit_w`,
the KX155's width), each has its real height: the stack is 2 x 50.8 +
41.9 = 143.5 mm high.

[![KX155](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)

[![KT 76C](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)

| File | Parts |
|------|-------|
| `radio.inc.scad` | the stack's standard: unit width, KX155 height, face, end flanges and mount holes, the 7 segment digit sizes, lettering; the parts both units use (tactile switch, MAX7219 board, bosses, knob shapes) |
| `kx155.scad` | the KX155: body (printed in one piece), front face, outer and inner frequency knob, volume knob, flip-flop button |
| `kt76c.scad` | the KT 76C: body (printed in one piece), front face, display mask, the 11 button caps (one print), function selector knob |

## KX155

The face copies the KX155: the four frequency windows along the top (COM
USE and STBY, NAV USE and STBY, labeled above), and along the bottom, for
COM and then for NAV, the volume knob, the flip-flop button (USE <->
STBY) and the dual concentric frequency knob: the big outer knob sets the
MHz, the small inner one the kHz. Turning a volume knob fully left
switches that radio off (a pot with a switch).

- **European frequencies**: COM shows 6 digits with three decimals, so
  the 8.33 kHz channels fit (118.005); NAV shows 5 (108.00).
- **Digits**: red 0.28" 7 segment LEDs (3 digit modules, two per
  frequency; NAV leaves the first digit off, behind the face) behind a
  red acrylic filter in each window. Each frequency has its own MAX7219
  driver. These digits are 7.5 mm apart, wider than the real ones, so
  the unit is 224 mm wide instead of the real 159 mm (6.25"). The height
  (50.8 mm, 2.00") and the layout are the real ones.
- **Mounting**: the body goes through the sheet's radio cut-out; the face
  has a 9 mm flange at its left and right ends only, with two M3 screws in
  each (nuts behind the sheet). There is none at the top and bottom, so
  the units stack without a gap and the cut-out is as high as the stack.
- **Inside**: the digits are soldered on two perfboards (COM, NAV),
  screwed onto bosses on the back of the face plate, pressing the digits
  against the filters. The encoders and pots are nutted through the face
  (the nuts sit under the knob skirts). Each flip button presses a 6 x 6
  mm tactile switch on a small perfboard on two bosses behind it. The four
  MAX7219s are the cheap 8x8 matrix kit boards with the matrix left off,
  slid into rails on the floor from the open back and wired to the digit
  boards with jumpers from their matrix sockets. The cable leaves through
  the open back, tied onto the tie block.
- **Knobs**: printed, ribbed like the real ones, pressed on: the outer and
  volume knobs onto round shafts (crush ribs in the bore), the inner knob
  onto the D shaft. Print them on their front.

The encoder, pot, tactile switch, digit and driver board sizes are
MEASURE values in `kx155.scad` (the encoder bushing is a guess). The
`assert`s check that the knobs, buttons and parts behind the face do not
collide and that the knobs hold enough of their shafts.

The frame (`frame/`) still has the Saitek radio panel's cut-out; it
changes to the stack next.

### Hardware

Per KX155:

| Qty | Part | Use |
|-----|------|-----|
| 2 | dual concentric encoder with push switch, 6 mm outer / 3.5 mm D inner shaft (Alps EC11EBB24C03 type) | COM and NAV frequency |
| 2 | 10 kOhm linear pot with switch, 6 mm shaft | COM and NAV volume, on/off |
| 2 | tactile switch, 6 x 6 mm, 5 mm high | flip-flop buttons |
| 8 | 7 segment module, 0.28", 3 digits, common cathode, red (e.g. Lumex LDT-N2804RI) | the four frequencies |
| 4 | MAX7219 8x8 dot matrix kit board (without the matrix) | digit drivers |
| 4 | red transparent acrylic, 2 mm, cut to the window plus 1.5 mm all round | display filters |
| - | perfboard | 2 digit boards, 2 flip switch boards |
| 4 | M3 x 10 pan head screw + nut | face flanges onto the sheet |
| 8 | M3 x 8 self tapping screw | boards onto the bosses |

For the stack: 1 Arduino Mega (the radio stack's MobiFlight board) and a
USB cable to the powered USB hub.

### Wiring

Every unit has its own cable to the stack's Mega (its box and the cable
type are still open, they come with the frame's stack cut-out). Per
unit, all inputs go to GND when active, like everywhere in the cockpit:

| Signal | Wires | MobiFlight device |
|--------|-------|-------------------|
| 5 V, GND | 2 | |
| MAX7219 DIN, CLK, CS | 3 | *LED Module*, 4 modules in the chain |
| COM encoder outer A, B; inner A, B | 4 | 2 *Encoders* |
| NAV encoder outer A, B; inner A, B | 4 | 2 *Encoders* |
| COM and NAV encoder push | 2 | 2 *Buttons* |
| COM and NAV flip button | 2 | 2 *Buttons* |
| COM and NAV pot switch | 2 | 2 *Buttons* |
| COM and NAV pot wiper | 2 | 2 *Analog inputs* (analog Mega pins) |

That is 21 wires, 19 Mega pins per unit. With the KT 76C's 25 (see its
Wiring section) the stack takes 63 of the Mega's 68 free
pins (54 digital and 16 analog, without 0 and 1, the USB serial). The four
MAX7219s are chained DOUT to DIN, in the order COM USE, COM STBY, NAV USE,
NAV STBY. On each digit board, wire digit 0 of a MAX7219 to the leftmost
digit of its frequency. The pots go between 5 V and GND, the wiper to the
Mega.

The MAX7219s take their current from the Mega's USB 5 V: keep the
brightness low in the Connector (the real displays are not bright
either). If the Mega resets, feed the digits from a separate 5 V supply,
its GND joined to the Mega's.

### In X-Plane

The Connector configs for COM1/NAV1 (the second unit: `com2`, `nav2`).
Check the names in DataRefTool, and that the aircraft's radios use 8.33
kHz spacing:

| Control | Dataref / command |
|---------|-------------------|
| COM USE, STBY (6 digits, point after the 3rd) | `sim/cockpit2/radios/actuators/com1_frequency_hz_833`, `com1_standby_frequency_hz_833` (kHz) |
| NAV USE, STBY (5 digits, point after the 3rd, on the last 5 of the 6) | `sim/cockpit2/radios/actuators/nav1_frequency_hz`, `nav1_standby_frequency_hz` (10 kHz) |
| COM outer knob | `sim/radios/stby_com1_coarse_up` / `_down` |
| COM inner knob | `sim/radios/stby_com1_fine_up_833` / `_down_833` |
| NAV outer knob | `sim/radios/stby_nav1_coarse_up` / `_down` |
| NAV inner knob | `sim/radios/stby_nav1_fine_up` / `_down` |
| COM, NAV flip | `sim/radios/com1_standy_flip`, `sim/radios/nav1_standy_flip` |
| COM, NAV volume | `sim/cockpit2/radios/actuators/audio_volume_com1`, `audio_volume_nav1` |
| COM, NAV on/off (pot switch) | `sim/cockpit2/radios/actuators/com1_power`, `nav1_power` |

Set the encoder type in the Connector so one detent is one step, and the
displays blank while the radio's power is off.

## KT 76C

The face copies the KT 76C: the IDT button at the top left, the display
window, along the bottom the code buttons 0..7, CLR and VFR, and at the
right the function selector knob: OFF, SBY, TST, ON, ALT.

- **Display**: like the real one, the flight level on the left, marked
  FL (pressure altitude in hundreds of feet: FL 045 is 4500 ft at 1013
  hPa), the squawk code on the right and the annunciators between them:
  R (reply) over FL at the left end, ALT, ON, GND and SBY in the middle.
  X-Plane has the pressure altitude as a dataref
  (`sim/flightmodel2/position/pressure_altitude`, feet, read only), so
  MobiFlight can show it (see In X-Plane below).
- **Digits**: the KX155's red 0.28" 7 segment modules: the flight level
  is one 3 digit module, the code two (the second module's last two
  digits are behind the face), 7 digits on one MAX7219.
- **Annunciators**: the words are cut through a printed black display
  mask behind the red filter, as stencil letters (thin bridges hold the
  middles of A, O, D, B and R). Each word has its own cell in the mask
  with a 3 mm red LED behind it, on its own Mega pin. The mask also has
  the openings the digit modules sit in, and it is clamped between the
  filter and the front board.
- **Buttons**: printed caps (cream or white, the engraved labels filled
  with black paint) through the face, held behind the plate by their
  flange, a post on their back presses a 6 x 6 mm tactile switch.
- **Function selector**: a 1 pole 12 way rotary switch with its stop
  washer set to 5 positions (30 degrees apart), nutted onto the face,
  every position on its own Mega pin, so the sim always follows the
  knob. The printed knob has a pointer line engraved for white paint.
- **Inside**: one front perfboard, cut L shaped (its lower strip runs
  under the rotary switch to CLR and VFR), carries the digit modules, the
  LEDs and all 11 tactile switches; it is screwed onto three bosses on
  the plate back. The MAX7219 is the matrix kit board without the matrix
  in rails on the floor, like the KX155's. The cable leaves through the
  open back, tied onto the tie block.
- **Size**: 224 x 41.9 mm (the real height, 1.65"), 57 mm deep; mounted
  like the KX155s with two M3 screws in each end flange.

The rotary switch (`rot_*`) and LED sizes are MEASURE values (the rotary
switch is a guess until it is bought). The `assert`s check that the
buttons, the display, the board screws, the rotary switch and the knob
labels do not collide.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | rotary switch, 1 pole 12 way, 6 mm shaft, with stop washer (Lorlin CK type) | function selector |
| 11 | tactile switch, 6 x 6 mm, 5 mm high | IDT, 0..7, CLR, VFR |
| 3 | 7 segment module, 0.28", 3 digits, common cathode, red (e.g. Lumex LDT-N2804RI) | flight level, code |
| 1 | MAX7219 8x8 dot matrix kit board (without the matrix) | digit driver |
| 6 | red LED, 3 mm, and a 1 kOhm resistor each | annunciators |
| 1 | red transparent acrylic, 2 mm, 137 x 17 mm | display filter |
| 1 | perfboard, 10 x 22 cm, cut to the front board | everything on the face |
| 4 | M3 x 10 pan head screw + nut | face flanges onto the sheet |
| 3 | M3 x 8 self tapping screw | front board onto the bosses |

Print the display mask in black (light must not shine through it), front
side down, so the stencil bridges are in the first layers.

### Assembly

Filter into its frame on the plate back, button caps in from the back,
display mask onto the filter. Solder the digit modules, LEDs and tactile
switches onto the front board, the LEDs sitting on the board, and screw
it onto the bosses: the digits go into the mask's openings and the LEDs
into its cells. Face onto the plate, rotary switch through both from the
back, nut on the front. Driver board into its rails, wiring, cable tied
onto the tie block. Turn the switch fully left (OFF) and press the knob
on pointing at OFF. Into the sheet under the KX155s.

### Wiring

| Signal | Wires | MobiFlight device |
|--------|-------|-------------------|
| 5 V, GND | 2 | |
| MAX7219 DIN, CLK, CS | 3 | *LED Module*, 1 module (7 of its 8 digits) |
| IDT, 0..7, CLR, VFR | 11 | 11 *Buttons* |
| OFF, SBY, TST, ON, ALT | 5 | 5 *Buttons* (the rotary switch's common to GND) |
| R, FL, ALT, ON, GND, SBY annunciators | 6 | 6 *Outputs* (LED anode through its resistor, cathode to GND) |

That is 27 wires, 25 Mega pins. On the MAX7219, digits 0..2 are the
flight level (left to right) and 3..6 the code; leave the two hidden
digits of the last module unwired.

### In X-Plane

| Control | Dataref / command |
|---------|-------------------|
| Code (4 digits, leading zeros) | `sim/cockpit2/radios/actuators/transponder_code` |
| Flight level (3 digits, leading zeros) | `sim/flightmodel2/position/pressure_altitude`, transform `Round($/100,0)`; only while the mode is ALT, blank below 0 |
| Mode, for the annunciators | `sim/cockpit2/radios/actuators/transponder_mode`: 0 OFF, 1 SBY (SBY lit), 2 ON (ON), 3 ALT (ALT and FL), 4 TST (everything lit, 888 / 8888) |
| GND annunciator | ON or ALT and `sim/flightmodel/failures/onground_any` = 1 |
| R annunciator | `sim/cockpit/radios/transponder_light` (reply, and on for the ident) |
| 0..7 | `sim/transponder/transponder_digit_0` .. `_7` (enter the code from the left, like the KT 76C) |
| CLR | `sim/transponder/transponder_CLR` |
| IDT | `sim/transponder/transponder_ident` |
| VFR | set `sim/cockpit2/radios/actuators/transponder_code` to 7000 (1200 in the US) |
| OFF, SBY, TST, ON, ALT | `sim/transponder/transponder_off`, `_standby`, `_test`, `_on`, `_alt` |

The display and annunciators are blank while the mode is OFF (use
preconditions on the mode). Check the names in DataRefTool; the real KT
76C shows dashes or nothing when the encoder's altitude is invalid,
X-Plane's pressure altitude is always valid.
