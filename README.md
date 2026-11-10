# Cessna 172 home cockpit

A home cockpit of the Cessna 172 for the X-Plane flight simulator. The parts
are designed in [OpenSCAD](https://openscad.org/) and 3D printed, and the
controls are read by [MobiFlight](https://www.mobiflight.com/) on an
Arduino Mega (the throttle quadrant uses its own ESP32).

Each cockpit component has its own directory:

| Directory | Component |
|-----------|-----------|
| [`throttle/`](throttle) | throttle quadrant: throttle, mixture and carb heat |
| [`switchpanel/`](switchpanel) | the 172N lower left switch panel: ignition key, master, lights, avionics |
| [`frame/`](frame) | the aluminium frame and panel sheet that everything mounts on |
| [`hub/`](hub) | the box with the MobiFlight Mega and the Cat5 ports |

The pictures below are rendered from the current `master` by the
[Build](.github/workflows/build.yml) workflow and published, together with
all printable STLs, on the
[project page](https://robertbraeutigam.github.io/cessna172/).

## Building

The OpenSCAD binary comes from the `OPENSCAD` environment variable; the
designs use OpenSCAD 2021.01. Run `make` in a component directory:

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

An aluminium extrusion ladder lies on the desk. On its front edge stands a panel frame: four 2020 uprights,
a top bar and a 45 degree brace behind each upright. One 3 mm aluminium
composite (ACM) sheet is screwed onto its front slots.

Seen from the pilot, left to right:

- **Switch panel** (ignition + switches), low on the left.
- **Yoke bay**: the front rail is split here, so the Saitek yoke stays
  on the desk with its own clamps, its housing in a notch in the sheet.
  A future force feedback yoke bolts to a crossbar in the bay instead.
- **Saitek radio panel**, with the **throttle box** under it.

The frame overhangs the desk edge by 22 mm (`frame_overhang`: a 2020 and
a 2 mm felt pad), so the sheet is 22 mm in front of the desk edge and
extrusion can go down there; the front rail still lies 18 mm on the desk
and the yoke housing sits 22 mm behind the sheet.

**Desk clamps**: the 2040 front rail runs 50 mm past the sheet at each
end (`ear_len`). There a bought screw clamp with rubber jaws clamps each
rail end onto the desk (the `clamp` view): the fixed jaw on the rail, the
spine in front of it beside the sheet, the screw jaw on the desk
underside, both jaws where the rail lies on the desk (`clamp_y`, 31 mm
from the rail front). The rail is 20 mm and the desk 28 mm, so a clamp
with a 50 mm opening and at least 33 mm reach fits; the build checks
`clamp_open`, `clamp_reach` and the jaw size. No printed part is in the
load path (printed parts creep under constant load), and two clamps about
1 m apart give well over 2 kN of grip, against 50-100 N of pulling on the
controls.

Below the desk top:

- **Apron**, under the throttle: two 2020 hangers under the front rail go
  202 mm down, a 2020 lower bar joins them and a small ACM sheet covers
  them, flush under the main sheet. Each hanger hangs from the rail by a
  blind joint: an M5 button head in its tapped top end, the head in the
  rail's front bottom slot, tightened through a 5 mm access hole drilled
  down through the rail, and a corner bracket on each side. A felt pad on
  each hanger's back rests against the desk edge, so pushing the frame
  away hits a stop. The apron carries the **pedestal** with the trim wheel
  and the fuel selector, which stands on the lower bar like the throttle
  box on the rail.
- **Bay bar**: a 2020 under the yoke bay, screwed under the two front
  rail ends (it also ties them together). The **parking brake** hangs under
  it, directly below the yoke: a thin body (22 mm) under the desk top, two
  M5 into the bar's bottom slot, and the T-handle just in front of the
  bar. Released, it is almost flush and lies sideways; set, it is pulled
  out 50 mm and turned to point down. It has no face. Its body goes
  between the yoke's own desk clamps (`yoke_clamp_gap`).

Apart from the bay bar and the thin parking brake, `knee_w` (460 mm)
around the yoke stays open for the legs. The pedestal and the parking
brake are future components; their sizes (`pedestal_size`, `park_size`)
are guesses that reserve the space (the pedestal sets the apron height),
and the pedestal's hole is cut when it exists. Their bodies must stay
below the desk underside.

The rule for every component: it brings its own front face, a hole is cut
into the sheet for it and its face is screwed onto the sheet. Heavy or
pulled components also stand on the frame: the throttle box sits on the
front rail and a crossbar, its face flange is screwed onto the sheet like
the switch panel's and two M5 bolts through its floor go into the rail.
The pedestal does the same on the apron's lower bar.
The extrusion carries the
loads, the sheet only covers the front, so cut-outs do not weaken it.
Keep at least 25 mm of sheet to the edge and 20 mm between cut-outs, and
drill the corners of a cut-out before sawing it. Holes for future
components are cut when they arrive.

All values are in `frame.inc.scad`; the layout (cut-outs, screw holes) is
computed from the component sizes, and the build prints the cut list
(`echo`). With the current guesses the frame is 985 x 362 mm, the sheet
985 x 260 mm, the apron sheet 250 x 202 mm. With the ears the frame takes
1085 mm of the desk width.

| File | Parts |
|------|-------|
| `frame.inc.scad` | extrusion and sheet standard, component sizes, layout, checks |
| `frame.scad` | views, cut list |

**MEASURE:** the desk (`desk`, and `desk_skirt` if it has a frame or
drawer under the top at the front edge), the leg room the pilot needs
(`knee_w`), the desk clamps (`clamp_open`, `clamp_reach`, `clamp_w`,
`clamp_pad_d`), the free width between the yoke's own desk clamps
(`yoke_clamp_gap`), the Saitek yoke housing (`yoke_housing`,
guessed 283 mm wide like the radio panel; spec sheet: 310 x 185 mm with the
wheel), the radio panel body that goes through the sheet (`radio_body`,
from Logitech's "Construction dimensions for Flight Panels" drawing) and
the panel height the monitor allows (`sheet_h`).

The switch panel's two backs go through one hole, 1 mm larger than the
backs all round; drill its M3 mount holes through the panel's own holes,
with the panels in place. The same goes for the throttle box: its cut-out
is 1 mm larger than the box, open to the rail at the bottom, and its
flange holes are drilled with the box in place.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 3 | 2040 extrusion, 6 mm slot | front rail left and right, rear rail |
| 18 | 2020 extrusion, 6 mm slot | 5 crossbars, 4 uprights, top bar, 4 braces (45 degree ends), 2 apron hangers (top end tapped M5), lower bar, bay bar |
| - | corner brackets, M5 screws, M5 T-nuts | frame joints (2 per apron hanger at the rail) |
| 2 | 3 mm ACM sheet | panel, cut to frame_w x sheet_h; the apron sheet |
| 45 | M5 button head screw + T-nut | sheets, bay bar into the rail ends, throttle box, pedestal and parking brake |
| 2 | M5 x 12 button head screw | apron hangers' blind joints into the front rail |
| 2 | screw clamp with rubber jaws, 50 mm opening | rail ends onto the desk |
| 2 | felt pad | on the apron hangers' backs, against the desk edge |

## Connections

- The **hub** (see [Hub](#hub)) holds the Arduino Mega with the MobiFlight
  firmware and 6 RJ45 ports. A powered USB hub next to it takes the USB
  cables (Mega, throttle ESP32, Saitek yoke, Saitek radio panel, later the
  FFB yoke), so one USB cable runs to the PC.
- Every MobiFlight component connects to a hub port with a straight Cat5
  patch cable. Each component has one CD74HC4067 mux (if it has inputs),
  and the cable is soldered straight to it (see [Cables](#cables)):
  everything inside a component is soldered, the plug at the hub is the
  only separation point.

### MobiFlight

[MobiFlight](https://www.mobiflight.com/) is free and open source (MIT,
[GitHub](https://github.com/MobiFlight/MobiFlight-Connector)). The
MobiFlight Connector runs on the PC (**Windows only**) and talks to X-Plane
11/12 directly through its datarefs and commands (X-Plane's UDP interface,
no plugin). It also flashes the MobiFlight firmware onto the Mega over USB.

In the Connector, the Mega gets one device per thing on a port: a
*Multiplexer* per mux (its SIG pin as the data pin; S0-S3 are set once, on
the first mux, and shared by all), a *Servo*, an *Encoder* or an *Analog
input* on the port's other pins. Each input (a mux channel is a button) then
sets a dataref or sends a command on press and on release, each output
(servo) follows a dataref. The configuration is a file: keep it with the
cockpit.

MobiFlight reads encoders only on their own pins, not through a mux, and
drives servos straight from Mega pins, without a second board.

### Port pinout

The same on every port. At the hub it is the RJ45 pin, at the component
the wire color (the cable is soldered there):

| Pin | T568B color | Signal | At the hub |
|-----|-------------|--------|------------|
| 1 | white-orange | S0 | bus, Mega pin 22 |
| 2 | orange | S1 | bus, Mega pin 23 |
| 3 | white-green | S2 | bus, Mega pin 24 |
| 4 | blue | 5 V | bus, Mega 5 V |
| 5 | white-blue | GND | bus, Mega GND |
| 6 | green | S3 | bus, Mega pin 25 |
| 7 | white-brown | SIG | the port's own Mega pin (the mux output) |
| 8 | brown | AUX | the port's own line: a Mega analog pin, or a digital pin (servo, encoder) |

5 V and GND are one twisted pair (blue). S0-S3 are shared by every mux (MobiFlight
takes them once per board); at the hub pins 1-6 of all ports are soldered together (the
bus). SIG and AUX are wired per port with jumpers, so a component must go
into its own port (they are numbered); swapping two cables only mixes up
the inputs in the sim until they are swapped back, it does not damage
anything.

Every mux gets a pull-up resistor from SIG to 5 V. MobiFlight turns on the
Mega's internal pull-up, but that is weak (20-50 kOhm), and its docs
recommend an extra one for long wires: solder a 4.7 kOhm between the SIG and
VCC pins on each mux board, in the component.

### Cables

At the hub every cable has its RJ45 plug; at the component it is soldered
straight to the mux (and the port's other pins), without a connector. Cut a
patch cable to length, or in half for two components:

- **Stranded** patch cable, not solid installation cable: solid wire breaks
  next to a solder joint after a few bends.
- **Pure copper** ("CU"), not CCA (copper clad aluminium, common in cheap
  cables): CCA hardly takes solder and breaks easily.
- **Check the colors** against the [Port pinout](#port-pinout) before
  soldering, with a multimeter or a cable tester: most patch cables are
  T568B, a few are T568A (orange and green pairs swapped).
- **Strain relief**: tie the jacket down on the component right before the
  wires fan out (the switch panel has a block for a cable tie next to the
  mux), so pulling the cable never pulls a solder joint. Tin the strands
  first and put heat shrink over every joint; cut unused wires short and
  insulate them.
- Measure the run to the hub and leave some slack: the length is fixed
  once it is soldered.

### Ports

| Port | Component | SIG | AUX |
|------|-----------|-----|-----|
| 1 | pedestal: fuel selector (mux), trim indicator (servo) | D26 | D2 (servo) |
| 2 | throttle quadrant (open, see below) | D27 | A1 |
| 3 | switch panel | D28 | A2 (free) |
| 4 | yoke handle: PTT, trim switch, more buttons (FFB yoke, later) | D29 | A3 |
| 5 | pedestal: trim wheel encoder | D30 (encoder A) | D38 (encoder B) |
| 6 | free | D31 | A5 |

The pins are suggestions: any free pin works, select it in the MobiFlight
Connector. AUX carries one analog input (a pot, on an analog pin), one servo
signal or one encoder line (on a digital pin); a component that needs more
(an encoder, several gauge servos) gets a second port.

A Mega takes at most 6 multiplexers in MobiFlight (`MaxInputMultiplexer`
in its board file), so one hub has 6 ports. If the cockpit needs more
ports, it gets a second hub with its own Mega and its own bus, on its own
USB cable to the powered USB hub; the Connector shows it as a second
board. Two Megas can not drive the same S0-S3 bus.

- **Parking brake**: one switch, on the mux of the pedestal or of the yoke
  port, whichever cable runs closer (it hangs under the yoke).
- **Trim wheel encoder** (EC11 type, 20 detents): MobiFlight does not read
  encoders through a mux, so the pedestal has a second cable to port 5: encoder A on its SIG, B on its AUX, both straight to Mega pins,
  the common on its GND. Set the encoder type in the Connector to match the
  encoder (steps per detent) and test that a fast spin does not lose steps.
- **Throttle quadrant**: open. It is an ESP32 on USB today; on a port its
  three pots would need three analog lines (a port has AUX, and SIG if it
  goes to an analog Mega pin, but no mux), or carb heat becomes a switch.
- **Likely later**: flaps lever and indicator (mux + servo on AUX), panel
  light dimmers (pots on AUX), steam gauges (servos, or steppers with a
  driver board in the hub). Outputs (annunciator lights, avionics displays)
  do not fit this pinout: MobiFlight drives them through 74HC595 shift
  registers or MAX7219 drivers, which need three lines of their own; decide
  that before the first output component.

**Logic only** goes over the Cat5: the muxes, encoders and hall sensors
draw a few mA. One small (9 g) servo may take its 5 V from pin 4 too (about
0.2-0.3 V drop on 2 m of one 24 AWG wire at its current peaks); put a 470 uF
capacitor across its supply at the servo. GND has to stay in the cable with
the signals, and the mux 5 V has to come from the Mega, so it is never
powered while its inputs are not (or the other way round).

### Power (later)

USB only for now. With lighting, gauges or the FFB yoke comes one 24 V PSU
with fused branches, buck converters for 5 V, a separate cut-off switch on
the FFB motor power and one star ground at the PSU. Loads (servos,
backlighting) then get their current from a separate 2 wire 5 V bus with a
2 pin plug per component (e.g. JST-VH or a 5.08 mm screw terminal), not
from the Cat5; its GND is tied to the Mega GND at one point in the hub.
Leave room for that plug in components with loads; the hub has a hole for
the bus in its back wall.

# Hub

[`hub/`](hub): the box with the MobiFlight Mega and the Cat5 ports.

[![Hub](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)

`hub.scad` prints the box (`hub_box.stl`, floor down) and the lid
(`hub_lid.stl`, top down). The box is 249 x 135 x 55 mm with the lid
(one row of 6 ports, `port_cols`); the build checks that it fits the
printer bed.

From the front wall to the back:

- **Ports**: 6 RJ45 breakout boards in a row along the front wall,
  their jacks behind cut-outs in it, numbered 1-6 from the left, the
  numbers beside the jacks. The boards are screwed onto bosses on the
  floor with M2 self tapping screws from above. Their angled 8 pin headers
  point into the box. Behind them is a 30 mm strip for the jumpers, then one row of
  boards:
- **Mega** (left): on 6 standoffs, its USB jack through the left wall
  (flush with the outside, so any USB-B plug fits), with a cut-out in
  front of the power jack for later.
- **Prototype board** (next to the Mega, 20 mm away): a 50 x 70 mm board
  on four standoffs, with the bus header (below) and room for small extra
  circuits if they are needed (a servo capacitor, later the power bus
  distribution). The hole for the power bus is in the back wall behind it.
  The rest of the row, on the right, stays free (a stepper driver board,
  later).
- The build checks the room for a plugged jumper (30 mm) above every
  board.
- The lid has a locating lip and is screwed onto four corner posts. Four
  ears on the floor (5.3 mm holes) screw the box onto the frame (M5 + T-nut)
  or under the desk.

Nothing on the Mega is soldered: it keeps its pins free and can be reused,
and a port is rewired by moving jumpers. The MobiFlight firmware is flashed
from the Connector through the Mega's USB jack in the left wall, with the
lid on.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | Arduino Mega 2560 | MobiFlight board |
| 1 | prototype board, 50 x 70 mm | bus header, extra circuits if needed |
| 1 | female header strip, 8 pin, 2.54 mm | bus header |
| 6 | RJ45 breakout board, 34 x 28 mm, angled 8 pin header | the ports |
| 18 | M2 x 6 self tapping screw | RJ45 boards |
| 4 | M2 x 6 screw | prototype board |
| 6 | M3 x 6 self tapping screw | Mega |
| 4 | M3 x 10 self tapping screw | lid |
| - | insulated wire, about 0.25 mm2, 6 colors | the bus |
| ~12 | male-female jumper wire, 20 cm | RJ45 SIG and AUX pins to the Mega |
| ~6 | male-male jumper wire, 10 cm | bus header to the Mega |

Per port used: a stranded copper Cat5 patch cable, soldered at the
component end (see [Cables](#cables)).

**MEASURE when they arrive**: the RJ45 boards (`rj_*`): the jack's height
and its position on the board, the header position and the mounting holes
(guessed from the listing picture; fix `rj_holes` before printing, the
build checks that the bosses stay on the board). The
prototype board's hole positions (`proto_*`; if its holes are smaller than
M2, use M1.6 screws). The Mega values are from the Arduino drawing.

### Wiring

**Bus**: pins 1-6 of all 6 boards are soldered together, one insulated
wire per line (S0, S1, S2, 5 V, GND, S3; one color each):

- Along the row: one wire per pin number, from port 1 to port 6. Strip a short piece of insulation where it passes each pin and
  solder it there, at the pin's base by the header, so it does not touch
  the other pins it crosses.
- To the prototype board: six wires from port 1's pins 1-6 to an 8 pin
  female header on it: S0, S1, S2, S3, 5 V, GND, 5 V, GND.

Pins 7 and 8 stay free for the jumpers.

| From | To | Jumper |
|------|----|--------|
| each port pin 7 (SIG) | its Mega pin (table above) | male-female |
| each port pin 8 (AUX) | its Mega pin (table above) | male-female |
| bus header S0-S3 | Mega pins 22-25 | male-male |
| bus header 5 V, GND | Mega 5 V, GND | male-male |

Port 1's AUX goes to D2, the trim indicator servo's signal; add a Servo
device on that pin in the Connector.

### Assembly

1. Screw the RJ45 boards onto their bosses (M2 x 6).
2. Solder the bus wires along the row.
3. Solder the bus header onto the prototype board and wire it to port 1.
4. Screw the prototype board and the Mega onto their standoffs.
5. Plug the jumpers as above, label the SIG and AUX jumpers.
6. Screw the lid on.

# Throttle quadrant

[`throttle/`](throttle): throttle, mixture and carb heat in one box.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

Each control is a 6 mm rod that comes out of the front of the box and moves
the slider of a linear potentiometer inside: long pots (130 mm) for the
throttle and mixture, a short one (75 mm) for the carb heat. The pots sit on
stands and are held down by printed pins. A printed clamp on each rod has a
slot that takes the pot's slider ear, so pulling the knob moves the slider.
An ESP32 on a pedestal at the back reads them and connects to the simulator
over USB.

The box mounts in the [cockpit frame](#cockpit-frame) and has no lid: it
goes through a cut-out in the panel sheet and stands on the front rail. Its
front wall is the face, with a 10 mm flange on the top and the two sides
(none at the bottom, where the box sits on the rail) that is screwed onto
the sheet with M3 screws, nuts behind the sheet. Two M5 bolts through the
floor, at the front between the rod supports, go into T-nuts in the front
rail's top slot, so pulling a knob does not load the sheet alone.

| File | Parts |
|------|-------|
| `throttle_box.scad` | the box with its face flange (printed in one piece), pot holder, cable cradle |
| `carb_heat_knob.scad` | carb heat knob and button |
| `clamp.scad` | rod clamps for the pot sliders |
| `pin.scad` | pot hold-down pins |

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | linear potentiometer, 130 mm | throttle, mixture |
| 1 | linear potentiometer, 75 mm | carb heat |
| 3 | 6 mm rod, with nuts | one per control |
| 1 | ESP32 board | reads the pots, USB to the PC |
| - | M3 screws | pot hold-downs, cable cradle |
| 5 | M3 x 10 pan head screw + nut | face flange onto the cockpit sheet |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the front rail (counted in the frame) |

# Switch panel

[`switchpanel/`](switchpanel): the lower left switch panel of the 172N.
Similar in function to the Saitek Switch Panel, but it should look as close
to the real panel as possible. Every switch position is a raw input for
MobiFlight, active low, like a switch to GND.

It is two panels, printed separately and mounted side by side: the ignition
on the left and the switch row, which also carries the input multiplexer
for both. Their basics are in `panel.inc.scad`: both are 3 mm thick,
with the same rim, flange, mount holes and lettering. The back of each
panel is 80 mm high (`panel_h`), closed by an 8 mm rim, and goes through a
hole in the cockpit sheet ([frame](#cockpit-frame)); a 10 mm face flange
(`flange_w`) on the top, the bottom and the outer end sits on the sheet
and is screwed to it with M3 screws, nuts behind the sheet. Where the two
panels meet there is no flange and the corners are square, so together
they look like the one piece panel of the airplane (about 309 x 100 mm,
the face 3 mm in front of the sheet).

## Ignition switch

[![Ignition switch](https://robertbraeutigam.github.io/cessna172/switchpanel/ignition_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/ignition_montage.png)

`ignition.scad`: the OFF - R - L - BOTH - START key switch. The key turns
clockwise; OFF, R, L and BOTH are detents, START is spring loaded and
returns to BOTH.

### How it works

It is built around a cheap mailbox (cabinet) cam lock. The lock's cam and
its stop washer are removed: these locks usually turn only 90°, so the
assembly has its own end stops for the whole OFF..START sweep. The key can
only be pulled at the lock's home position, which is OFF.

A printed rotor on the lock's spindle sits in a housing behind the panel,
closed by a cover:

- **Detents:** a steel ball, pushed by a spring in a radial channel of the
  housing, drops into notches in the rotor rim. START has no notch.
- **End stops:** a lug on the rotor rim moves in a pocket of the housing.
- **START return:** an M3 screw through the cover is a pin in an arc slot of
  the rotor. From OFF to BOTH it moves freely in the narrow part of the
  slot. Past BOTH it pushes a printed shoe that compresses a spring in the
  wide part, and the spring pushes the key back to BOTH.
- **Sensing:** a magnet in the rotor lug and one digital hall sensor per
  position in the cover. The sensors (A3144, unipolar, not latching) are
  open collector and pull low over the magnet, so each one is wired like a
  switch to GND.

Printed parts: panel, housing, rotor, shoe, cover.

The panel is 87 x 100 mm (the back 77 x 80 mm), printed front side down, with the position labels,
tick marks and MAGNETOS engraved around the key. The lock body goes through
a cutout with flats, so it cannot turn, and the housing sits on the back,
between the rims. The labels are placed for the key pointing at OFF in the
lock's home position: **MEASURE** where the key really points
(`key_off_angle`) once the lock is here.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | mailbox / cabinet cam lock | key and spindle (**MEASURE** it and update the `lock_*` values, they are guesses) |
| 1 | 6 mm steel ball + spring | detent (`detent_spring_*`, spring OD below 6 mm) |
| 1 | spring, 5 mm OD, 15 mm | START return (`start_spring_*`) |
| 1 | cube magnet, 5 x 5 x 5 mm | position sensing (`magnet_*`) |
| 5 | A3144 hall sensor | one per position (OFF is optional) |
| 4 | M3 screw | cover |
| 4 | M3 x 10 screw | panel to housing |
| 1 | M3 x 8 screw | START pin |
| 4 | M3 x 10 pan head screw + nut | panel onto the cockpit sheet |

### Assembly

1. Put the lock through the panel and the housing, screw the panel to the
   housing, tighten the lock nut.
2. Mount the rotor with the lock's cam screw.
3. Insert the ball and its spring, and the shoe and its spring.
4. Check which magnet face triggers the sensors, then glue in the magnet and
   the sensors.
5. Screw on the cover, then put in the START pin.

The positions (30° apart) should be verified against the real switch.

## Switches

[![Switch panel](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)

`switches.scad`: the switch row. The red split MASTER (ALT, BAT) on the
left, toggle switches in the middle (FUEL PUMP, BEACON, LAND, TAXI, NAV,
STROBE, PITOT HEAT) and the split AVIONICS (BUS 1, BUS 2) on the right, with
the labels engraved. Up is ON, like in the airplane. Above the toggles is a
row of circuit breakers, like on the real panel; they are for show only.

The switch list (`groups` in the source) drives the layout; it follows the
X-Plane 172 SP. For a 172N remove FUEL PUMP and the panel gets shorter. The
panel is 221.6 x 100 mm (the back 211.6 x 80 mm), printed front side
down; the switches and labels need about 68 mm of the back's height, the
rest is split between above and below them. The rim on the back stiffens
it.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 7 | toggle switch, M12 neck, 18 mm lever | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
| 6 | M3 x 10 pan head screw + nut | panel onto the cockpit sheet (`mount_count`) |
| 1 | CD74HC4067 16 channel mux breakout board | all inputs, see [Multiplexer](#multiplexer) |
| 2 | M2 x 6 screw | mux onto its standoffs |
| 7 | printed dummy breaker (`switches_breakers.stl`) + glue | circuit breakers, see [Circuit breakers](#circuit-breakers) |
| 1 | 4.7 kOhm resistor | SIG pull-up on the mux |
| 1 | Cat5 patch cable, stranded copper (see [Cables](#cables)) | to hub port 3, soldered to the mux |
| 1 | cable tie, up to 3.6 mm wide | the cable onto its block (`tie`) |
| - | wire, heat shrink | see [Wiring](#wiring) |

### Double rocker switches

[Double Rocker Switch 6-Pin 250V 16A/AC Red Rocker Illuminated On/Off](https://www.amazon.de/-/en/Double-Rocker-Switch-6-Pin-Illuminated/dp/B0DLTMGKSS),
in red for MASTER and black for AVIONICS. Two independent rockers side by
side in one housing, tall and narrow like the real split switches.

They snap into a cutout from the front: ramps on their top and bottom end
catch behind the panel, which is thinned there by a pocket in the back.
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
(`switches_breakers.stl`, nut side down). They are glued into 1 mm deep hex
pockets in the front of the panel, which locate them and keep them
straight; nothing goes through the panel. Print them in black and paint the
nut silver and the rating white, or print the nut and the button in
different colors.

The list (`breakers` in the source, name and rating) is placed over the
toggles, one above each, from the left; the build checks that the row
still fits the panel height, and the top middle mount screw moves between
two breakers. Real breakers
(e.g. Klixon push-to-reset) would need a bigger hole and room behind the
panel, so making them functional later means changing the pockets into
holes.

### Multiplexer

All switches and the ignition go to one CD74HC4067 breakout board on the
back of the switch panel. MobiFlight reads it as a Multiplexer device: 16
inputs through one Mega pin. So everything is soldered on the panels, and
only one Cat5 cable runs to the hub (port 3).

The board sits on two standoffs in the strip behind the group labels, on
the left (pilot side) half, where the ignition cable comes in. Mount it with
the chip outwards, so the solder joints face you; `assert`s check that it
clears the switches and fits inside the rim.

**MEASURE when it arrives** (`mux_*`): the board is 40 x 18 mm in the
listings (one says 41 x 18.7 mm). The mounting holes (`mux_holes`, guessed
on the center line 17.5 mm from the middle) and the order of the control
pins (`mux_ctl_names`) are guesses. If the board turns out bigger the build
fails; then increase `margin_top`. If it has no mounting holes, glue it onto
the standoffs.

#### Inputs

| Mux | Input | Mux | Input |
|-----|-------|-----|-------|
| C0 | MASTER ALT | C8 | PITOT HEAT |
| C1 | MASTER BAT | C9 | AVIONICS BUS 1 |
| C2 | FUEL PUMP | C10 | AVIONICS BUS 2 |
| C3 | BEACON | C11 | ignition OFF |
| C4 | LAND | C12 | ignition R |
| C5 | TAXI | C13 | ignition L |
| C6 | NAV | C14 | ignition BOTH |
| C7 | STROBE | C15 | ignition START |

That is all 16. The switches are in label order (the `groups` order), and
the ignition positions are consecutive. In the MobiFlight Connector every
channel is a button: a toggle or rocker sets its dataref to 1 on press and
to 0 on release, an ignition position sets the key position on press, and
START holds the starter while it is pressed. Without FUEL PUMP (172N) or
the OFF hall sensor, one input stays free.

#### Cable to the hub

The mux goes to hub port 3 (see [Port pinout](#port-pinout)) with a Cat5
cable soldered straight into its control row (see [Cables](#cables)):

| Mux pin | Wire (T568B) | Mega (at the hub) |
|---------|--------------|-------------------|
| S0, S1, S2, S3 | white-orange, orange, white-green, green | pins 22, 23, 24, 25 (shared by all muxes) |
| VCC | blue | 5 V |
| GND | white-blue | GND |
| SIG | white-brown | D28, the mux's data pin in the MobiFlight Connector |
| EN | - | not to the hub: bridge it to GND on the board (enable is active low) |

The brown wire (AUX) is not used: cut it short and insulate it. The cable
comes in over the top rim and is tied down with a cable tie on the block
right of the mux (`tie_block`: the tie goes through the slot at the panel
and around the cable in the groove on top), so the wires fan out from
there to the pins without any pull on them. **MEASURE** the cable
(`cable_d`, 6 mm) and the tie (`tie`, 3.6 x 1.3 mm).

The switches and the hall sensors have no pull-up resistors of their own:
one 4.7 kOhm resistor from SIG to VCC on the mux board pulls whichever
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

So on the switch panel: one GND wire daisy chained over all 11 switches to
the mux GND, and one signal wire from each switch to its C pin, soldered
straight into the board. The ignition cable (5 signals, 5 V, GND) is best
plugged in with a 7 pin Dupont or JST connector, so the two panels can be
separated. GND and VCC get several wires (switch chain, EN bridge,
ignition, Cat5 cable): join the extra wires into one before the pin, with
solder and heat shrink.

### Assembly

1. Solder the wires to the switches first; the rockers are hard to get out
   again once snapped in.
2. Put the toggles in from the back and tighten their nuts.
3. Snap the rockers in from the front.
4. Solder the other wire ends to the mux and screw it onto its standoffs.
5. Solder the Cat5 cable to the mux control row and tie it onto its
   block.
6. Glue the dummy breakers into their pockets.
7. Mount the panel.

### Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock (ALT pushes BAT on, BAT pushes ALT off); X-Plane does not need
  it.
