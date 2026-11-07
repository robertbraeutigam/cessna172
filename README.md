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

The printer is an Anycubic Kobra 3 V2 (255 x 255 mm bed). Large parts are
sliced to fit, and the files check it. Values that depend on bought parts
are marked MEASURE in the source; `assert()`s check that the derived
geometry still fits, so a wrong measurement fails the build instead of
printing a bad part.

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

| File | Parts |
|------|-------|
| `throttle_box.scad` | the box: underside sliced into three printable pieces joined by screwed seams, the lid, pot holder, cable cradle |
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
| - | M3 screws | seams, lid |

# Switch panel

[`switchpanel/`](switchpanel): the lower left switch panel of the 172N.
Similar in function to the Saitek Switch Panel, but it should look as close
to the real panel as possible. Every switch position is a raw input for
SimVim, active low, like a switch to GND. The ignition key is its own part,
and the switch row is a separate panel that carries the input multiplexer
for both.

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

Printed parts: housing, rotor, shoe, cover.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | mailbox / cabinet cam lock | key and spindle (**MEASURE** it and update the `lock_*` values, they are guesses) |
| 1 | 6 mm steel ball + spring | detent (`detent_spring_*`, spring OD below 6 mm) |
| 1 | spring, 5 mm OD, 15 mm | START return (`start_spring_*`) |
| 1 | magnet, 5 x 2 mm | position sensing (`magnet_*`) |
| 5 | A3144 hall sensor | one per position (OFF is optional) |
| 4 | M3 screw | cover |
| 1 | M3 x 8 screw | START pin |
| - | M3 screws | panel mounting |

### Assembly

1. Put the lock through the panel and the housing, tighten its nut.
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
X-Plane 172 SP. For a 172N remove FUEL PUMP and the panel adapts. The panel
is 211.6 x 67.8 mm, printed front side down. A rim and bosses on the back
stiffen it.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 7 | toggle switch, M12 neck, 18 mm lever | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
| 6 | M3 pan head screw + nut | panel mounting (`mount_count`) |
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
toggles, one above each, from the left; the panel grows to fit the row and
the top middle mount screw moves between two breakers. Real breakers
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
clears the switches and the mount bosses.

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
