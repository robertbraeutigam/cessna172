# Cessna 172 home cockpit

A home cockpit of the Cessna 172 for the X-Plane flight simulator. The parts
are designed in [OpenSCAD](https://openscad.org/) and 3D printed, and the
controls are read by [MobiFlight](https://www.mobiflight.com/), on an
Arduino Nano in every component.

Each cockpit component has its own directory, and its own `README.md`
there with the working principle, the parts list with shop links, the
wiring and the assembly:

| Directory | Component |
|-----------|-----------|
| [`throttle/`](throttle/README.md) | throttle quadrant: throttle, mixture and carb heat |
| [`flaps/`](flaps/README.md) | the wing flap lever and the flap position indicator right of the throttle |
| [`pedestal/`](pedestal/README.md) | the trim wheel and the trim indicator under the throttle |
| [`switchpanel/`](switchpanel/README.md) | the 172N lower left switch panel: master, lights, avionics; the primer below it |
| [`ignition/`](ignition/README.md) | the ignition key switch, the left end of the switch panel |
| [`frame/`](frame/README.md) | the aluminium frame and panel sheet that everything mounts on |
| [`yoke/`](yoke/README.md) | the hollow control wheel: PTT, trim rocker, a Nano inside |
| [`compass/`](compass/README.md) | the magnetic compass over the panel: a printed drum card on a 28BYJ-48 stepper, on its own Nano |
| [`instruments/`](instruments/README.md) | the analogue instruments: the RPM, airspeed, vertical speed, attitude and heading indicators, the altimeter, the turn coordinator and the NAV indicators (CDI), 28BYJ-48 steppers behind colour printed faces |
| [`radio/`](radio/README.md) | the radio stack: the KMA 26 audio panel, two KX155 NAV/COMs and the KT 76C transponder, each on its own Nano |

Every component has its own Arduino Nano running
MobiFlight and one USB cable to a powered USB hub; see
[Connections](#connections).

The pictures are rendered from the current `master` by the
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
card_print(); // Make print card                     -> target/<file>_card.pdf
face_print(); // Make print face black,#1f9e3a,white -> target/<file>_face.pdf, in colour
```

A leading `//` only hides a line from the OpenSCAD preview; the build still
renders it. A print is a 2D drawing for paper: exported
1:1 to an A4 PDF, filled black, with OpenSCAD's scale bar to check it. With
a list of colours it is a colour print (an instrument's face): rendered
once per colour, the file drawing only that colour's shapes
(`print_color`), and the layers laid over each other in that order with
[qpdf](https://qpdf.sourceforge.io/), which has to be installed for it. `{{gitrev}}` in the source is replaced with the short git hash,
so the version is embossed into the parts.

Values and modules shared by several files of a component go into a
`*.inc.scad` file that the others `include`. It is not rendered itself, and
changing it renders the whole component again. Bought parts that every
component uses are in [`lib/`](lib/): [`lib/nano.inc.scad`](lib/nano.inc.scad)
has the Arduino Nano (its sizes, pinout and a view model) and the shallow
rails it slides into, whose ledges and lips stay clear of the pin rows'
solder. The Makefile copies `lib/*.inc.scad` into every component's
`target/` with its own includes, and changing one renders every
component again. The rails are snug (0.15 mm a side): measure your Nano's
width (`nano_board`) before printing, clones differ.
[`lib/stepper.inc.scad`](lib/stepper.inc.scad) has the stepper drive of
the compass and the instruments: the 28BYJ-48, the ULN2003 board (with
the places of its standoffs), the A3144 hall sensor and the homing
magnet, their sizes and view models.
[`lib/usb.inc.scad`](lib/usb.inc.scad) has the USB cable (plug, cable and
tie sizes) and what it is tied onto, so that pulling it does not lever
the Nano's jack: the tie block in line behind the plug (the cable in a
groove on its top, the tie through a slot at its foot) and, where there
is no room behind the plug, the tie post beside it (the radio units).

The printer is an Anycubic Kobra 3 V2 (255 x 255 mm bed). Large parts must
fit on it, and the files check it. Values that depend on bought parts
are marked MEASURE in the source; `assert()`s check that the derived
geometry still fits, so a wrong measurement fails the build instead of
printing a bad part.

## Connections

There is no central box: every component has a board of its own running
MobiFlight (an Arduino Nano; each radio unit too), with one USB cable to
a powered USB hub on the desk, and one cable from there to the PC. Each
component's README has its pins, its wiring and what it takes from USB.

- **One board per component.** Everything inside a component is
  soldered to its own Nano, and its USB cable is the only connection to
  the rest of the cockpit. So each component is tested on the bench with
  nothing but that cable, and swapped without touching the others. A
  Nano is about 4 EUR; a shared board would save no money (it needs
  ports, cables and a wiring board of its own) and gives that up.
- **Plenty for each component.** MobiFlight's limits for a Nano
  (`arduino_nano.board.json` in its firmware): 18 buttons, 8 analog
  inputs, 9 encoders, 8 servos, 4 steppers, 6 multiplexers. Its pins: D2
  to D12 and A0 to A5 for buttons, encoders, servos and stepper wires
  (D13 has the LED: not for inputs), A6 and A7 only analog. Short wires
  inside a component need no resistors: switches go to GND and use the
  Nano's internal pull-ups.
- **Names, not ports.** The Connector names each board when it flashes
  it and stores that with a serial on the board, so identical Nanos are
  told apart whichever COM port Windows gives them. The configuration
  (one file for the whole cockpit) refers to them by that name.
- **The USB cable** plugs into the Nano at the component (no connector of
  our own), with a cable tie next to the plug where the cable could pull
  on it. USB 2.0 is good for 5 m, plenty from the panel to the desk.

### MobiFlight

[MobiFlight](https://www.mobiflight.com/) is free and open source (MIT,
[GitHub](https://github.com/MobiFlight/MobiFlight-Connector)). The
MobiFlight Connector runs on the PC (**Windows only**) and talks to X-Plane
11/12 directly through its datarefs and commands (X-Plane's UDP interface,
no plugin). It also flashes the MobiFlight firmware onto the boards over
USB; give each one the component's name then.

In the Connector, each board gets one device per thing on it: a *Button*,
an *Encoder*, an *Analog input*, a *Servo* or a *Stepper* on its pins.
Each input then sets a dataref or sends a command on press and on
release, each output follows a dataref. The configuration is a file: keep
it with the cockpit.

MobiFlight sends an X-Plane command only once; it cannot hold one while a
button is pressed (still open:
[MobiFlight-Connector#2405](https://github.com/MobiFlight/MobiFlight-Connector/issues/2405)).
Where a command has to be held, like the ignition START, a small
FlyWithLua (NG) plugin script in X-Plane does it (see
[In X-Plane](ignition/README.md#in-x-plane)).

### Powered USB hub

It stands on the desk right of the yoke (see
[Cockpit frame](frame/README.md)). Every component's README says how many
ports it takes and how much current (its *USB* paragraph). With the whole
six-pack, the NAV indicators, the RPM, the four radio units, the pedestal,
the flaps and the Saitek devices that is about 22 ports: a 16
port hub, or two hubs, one into the other (USB takes up to 127 devices),
and one cable from the first to the PC.

The current is the limit. At rest it is small: every stepper has its
coils off when it is at its target, except the compass's (about 0.25 A
all the time), so the whole panel takes a few hundred mA. The peak is at start, when every needle homes at once for a
few seconds: with the compass and about 13 steppers in the instruments
3.5-4 A. That is more than many cheap "powered" hubs give (their supply
often has 2-3 A, shared by all ports; too little shows as boards
resetting and needles losing their home). So the hub:

- has a supply for the peak: 5 V / 4 A or more, or a 12 V supply (the
  hub's own converter; 12 V / 3 A, 36 W, gives about 6 A at 5 V);
- gives each port at least 500 mA (in its specs: BC 1.2 charging ports, or
  "x A per port"), so a two stepper instrument is not cut off;
- has every board's cable short and of a decent gauge (the cheap thin ones
  drop voltage).

The NAV indicators' flags have a 9 g servo each, the pedestal's trim
indicator has one, and so has the flaps panel's indicator, each on the
component's Nano: about 0.15-0.3 A when it moves,
up to 0.7 A stalled. Put a 470 uF capacitor across its supply at the
servo; if its Nano resets when it moves, feed it from the USB 5 V before
the Nano's diode (the 5V pin is behind it).

### Power (later)

USB only for now. With lighting or the FFB yoke comes one 24 V PSU with
fused branches, a DC-DC converter to a 5 V bus, a separate cut-off switch
on the FFB motor power and one star ground at the PSU. Bigger loads
(backlighting, several servos in one component) then get their current
from the 5 V bus with a 2 pin plug per component (e.g. JST-VH or a
5.08 mm screw terminal), their GND joined to the Nano's GND there, not
over USB. Leave room for that plug in components with loads.

## Components

### [Cockpit frame](frame/README.md)

The aluminium extrusion frame on the desk that carries all components, and
the panel sheets over it, laid out like the X-Plane 172N's panel.

[![Cockpit frame](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)

### [Throttle quadrant](throttle/README.md)

Throttle, mixture and carb heat: 6 mm rods moving linear potentiometers in
one box, read by a Nano on its floor.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

### [Flaps panel](flaps/README.md)

The continuous wing flap lever, an arm swinging on a rod behind the
panel through the 172N's stepped slot (stops at 10 and 20, FULL at 40),
read by a rotary pot through a gear sector, and the flap position
indicator, its pointer moved by a servo through a scotch yoke.

[![Flaps panel](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)](https://robertbraeutigam.github.io/cessna172/flaps/flaps_montage.png)

### [Pedestal](pedestal/README.md)

The elevator trim wheel and the trim indicator under the throttle: the
wheel on a rotary encoder sending trim commands, the pointer on a rack
moved by a servo.

[![Pedestal](https://robertbraeutigam.github.io/cessna172/pedestal/pedestal_montage.png)](https://robertbraeutigam.github.io/cessna172/pedestal/pedestal_montage.png)

### [Switch panel](switchpanel/README.md)

The 172N's lower left switch panel: master, avionics, lights and dummy
circuit breakers on a Nano, and the primer below the ignition key.

[![Switch panel](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)

[![Primer](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)

### [Ignition](ignition/README.md)

The OFF - R - L - BOTH - START key switch, built around a mailbox cam lock,
with a spring-return START and a hall sensor per position.

[![Ignition switch](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)

### [Yoke](yoke/README.md)

The hollow Cessna control wheel with PTT buttons, an electric trim rocker
and a Nano inside.

[![Yoke](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)

### [Compass](compass/README.md)

The magnetic compass over the panel: a printed drum card, its marks
standing out of it and painted white, turned by a 28BYJ-48 stepper and
homed on a hall sensor, on an Arduino Nano of its own.

[![Compass](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)

### [Instruments](instruments/README.md)

The analogue instruments, built on one standard: a 3 1/8" case behind the
panel, a colour printed face, a needle turned by a 28BYJ-48 stepper through
two printed gears, the motor and boards behind the case. So far the RPM
indicator, the airspeed indicator, the vertical speed indicator, the attitude indicator (a thin
roll dial and a horizon bowl, the pitch motor riding on the roll frame
through a slip ring; deeper than the others) and the altimeter (two
needles on concentric shafts, a motor each, and Kollsman windows in
inHg and hPa set by its knob through a 10 turn pot; deeper too) and the
heading indicator (the card and an orange bug disc behind it, a motor
each, two knobs on rotary encoders) and the turn coordinator (the
airplane on the axle, the ball on a disc behind the face's tube, a motor
each) and the NAV indicators (VOR course deviation indicators: the
needle on a motor, the TO/FROM flag on a servo, the azimuth card turned
by the OBS knob and read by a magnetic angle sensor).

[![RPM indicator](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)

[![Airspeed indicator](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)

[![Vertical speed indicator](https://robertbraeutigam.github.io/cessna172/instruments/vsi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/vsi_montage.png)

[![Attitude indicator](https://robertbraeutigam.github.io/cessna172/instruments/ai_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/ai_montage.png)

[![Altimeter](https://robertbraeutigam.github.io/cessna172/instruments/alt_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/alt_montage.png)

[![Heading indicator](https://robertbraeutigam.github.io/cessna172/instruments/hi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/hi_montage.png)

[![Turn coordinator](https://robertbraeutigam.github.io/cessna172/instruments/tc_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/tc_montage.png)

[![NAV indicator](https://robertbraeutigam.github.io/cessna172/instruments/cdi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/cdi_montage.png)

### [Radio stack](radio/README.md)

The KMA 26 audio panel, two KX155 NAV/COMs and the KT 76C transponder, each
on an Arduino Nano of its own.

[![KMA 26](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)

[![KX155](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)

[![KT 76C](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)
