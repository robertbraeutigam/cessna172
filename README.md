# Cessna 172 home cockpit

A home cockpit of the Cessna 172 for the X-Plane flight simulator. The parts
are designed in [OpenSCAD](https://openscad.org/) and 3D printed, and the
controls are read by [SimVim](https://simvim.com/) on an Arduino Mega (the
throttle quadrant uses its own ESP32).

Each cockpit component has its own directory:

| Directory | Component |
|-----------|-----------|
| [`throttle/`](throttle) | throttle quadrant: throttle, mixture and carb heat |
| [`switchpanel/`](switchpanel) | the 172N lower left switch panel: ignition key, master, lights, avionics |
| [`frame/`](frame) | the aluminium frame and panel sheet that everything mounts on |

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

An aluminium extrusion ladder lies on the desk and is held by desk clamps
on its rails. On its front edge stands a panel frame: four 2020 uprights,
a top bar and a 45 degree brace behind each upright. One 3 mm aluminium
composite (ACM) sheet is screwed onto its front slots.

Seen from the pilot, left to right:

- **Switch panel** (ignition + switches), low on the left.
- **Yoke bay**: the front rail is split here, so the Saitek yoke stays
  on the desk with its own clamps, its housing in a notch in the sheet.
  A future force feedback yoke bolts to a crossbar in the bay instead.
- **Saitek radio panel**, with the **throttle box** under it.

Below the desk top hang two **aprons** for the controls that are under the
panel in the airplane: the left one carries the **parking brake**, the right
one, under the throttle, the **pedestal** with the trim wheel and the fuel
selector. Each apron is two 2020 hangers under the front rail (a corner
bracket on each side, in the rail's front bottom slot), a 2020 lower bar
between their ends and a small ACM sheet in front, flush under the main
sheet. Between the aprons, around the yoke, `knee_w` (460 mm) stays open
for the legs. For the hangers the frame overhangs the desk edge by 25 mm
(`frame_overhang`, a hanger and 5 mm play), so the front rail still lies
15 mm on the desk and the yoke housing sits 25 mm behind the sheet. The
pedestal and the parking brake are future components; their sizes
(`pedestal_size`, `park_size`) are guesses that reserve the space and set
the apron height (199 mm below the desk top), and their holes are cut when
they exist. Their bodies must stay below the desk underside.

The rule for every component: it brings its own front face, a hole is cut
into the sheet for it and its face is screwed onto the sheet. Heavy or
pulled components also stand on the frame: the throttle box sits on the
front rail and a crossbar, its face flange is screwed onto the sheet like
the switch panel's and two M5 bolts through its floor go into the rail.
The under-desk components do the same on the lower bar of their apron.
The extrusion carries the
loads, the sheet only covers the front, so cut-outs do not weaken it.
Keep at least 25 mm of sheet to the edge and 20 mm between cut-outs, and
drill the corners of a cut-out before sawing it. Holes for future
components are cut when they arrive.

All values are in `frame.inc.scad`; the layout (cut-outs, screw holes) is
computed from the component sizes, and the build prints the cut list
(`echo`). With the current guesses the frame is 985 x 365 mm, the sheet
985 x 260 mm, the apron sheets 275 x 199 and 250 x 199 mm.

| File | Parts |
|------|-------|
| `frame.inc.scad` | extrusion and sheet standard, component sizes, layout, checks |
| `frame.scad` | views, cut list (no printed parts) |

**MEASURE:** the desk (`desk`, and `desk_skirt` if it has a frame or
drawer under the top at the front edge), the leg room the pilot needs
(`knee_w`), the Saitek yoke housing (`yoke_housing`,
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
| 20 | 2020 extrusion, 6 mm slot | 5 crossbars, 4 uprights, top bar, 4 braces (45 degree ends), 4 hangers, 2 lower bars |
| - | corner brackets, M5 screws, M5 T-nuts | frame joints (2 per hanger at the rail) |
| 3 | 3 mm ACM sheet | panel, cut to frame_w x sheet_h; the two apron sheets |
| 52 | M5 button head screw + T-nut | sheets, throttle box floor into the front rail, under-desk floors into the lower bars |
| 2-4 | desk clamp | frame onto the desk |

## Connections (plan)

- One hub box under the frame: the SimVim Arduino Mega and a powered USB
  hub, so one USB cable runs to the PC (Mega, throttle ESP32, Saitek yoke,
  Saitek radio panel, later the FFB yoke).
- SimVim modules connect with Cat5 patch cables (RJ45): 5 V, GND, mux
  S0-S3 (shared by all ports), mux SIG (one Mega pin per port) and one
  analog line. Each module has one mux and one jack. The switch panel's
  7 wire mux cable is port 1; the under-desk controls (trim wheel, fuel
  selector, parking brake) share port 2.
- Power: USB only for now. With lighting, gauges or the FFB yoke comes one
  24 V PSU with fused branches, buck converters for 5 V, a separate cut-off
  switch on the FFB motor power and one star ground at the PSU.

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
SimVim, active low, like a switch to GND.

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
| 1 | magnet, 5 x 2 mm | position sensing (`magnet_*`) |
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
| 1 | 8 pin straight header + Dupont housing | cable to the Mega |
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
back of the switch panel. It is SimVim's standard input extension: 16
inputs, read through one Mega pin. So everything is soldered on the panels,
and only one 7 wire cable runs to the Mega.

(A SimVim "slave" board does not work here: the only slave for inputs is
the key matrix board, and it takes momentary buttons only, no toggle
switches.)

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
the ignition positions are consecutive, which suits a SimVim multi-position
switch (M, one input per position). In the SimVim configurator assign the
toggles and rockers as toggle switches (S). Without FUEL PUMP (172N) or the
OFF hall sensor, one input stays free.

#### Cable to the Mega

| Mux pin | Mega |
|---------|------|
| S0, S1, S2, S3 | pins 22, 23, 24, 25 (fixed by SimVim, shared by all muxes) |
| SIG | any free digital pin, select it in the SimVim configurator |
| VCC | 5 V |
| GND | GND |
| EN | not to the Mega: bridge it to GND on the board (enable is active low) |

Solder the header into the control row (short pin ends towards the panel)
and plug an 8 pin Dupont housing onto it, with the EN position left empty. A
second mux elsewhere in the cockpit shares S0..S3; it only needs its own SIG
pin.

The switches and the hall sensors have no pull-up resistors: this assumes
SimVim turns on the Mega's internal pull-up on the SIG pin, which its docs
do not say outright. **Test it on the bench first** with one switch on the
mux, before soldering all of them. If the input floats, add one 10k
resistor from SIG to 5 V.

### Wiring

Every input is wired like a switch to GND (active low, as SimVim expects):

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
ignition, Mega cable): join the extra wires into one before the pin, with
solder and heat shrink.

### Assembly

1. Solder the wires to the switches first; the rockers are hard to get out
   again once snapped in.
2. Put the toggles in from the back and tighten their nuts.
3. Snap the rockers in from the front.
4. Solder the other wire ends to the mux and screw it onto its standoffs.
5. Glue the dummy breakers into their pockets.
6. Mount the panel.

### Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock (ALT pushes BAT on, BAT pushes ALT off); X-Plane does not need
  it.
