# Cessna 172 home cockpit

A home cockpit of the Cessna 172 for the X-Plane flight simulator. The parts
are designed in [OpenSCAD](https://openscad.org/) and 3D printed, and the
controls are read by [MobiFlight](https://www.mobiflight.com/) on an
Arduino Mega.

Each cockpit component has its own directory, and its own `README.md`
there with the working principle, the parts list with shop links, the
wiring and the assembly:

| Directory | Component |
|-----------|-----------|
| [`throttle/`](throttle/README.md) | throttle quadrant: throttle, mixture and carb heat |
| [`switchpanel/`](switchpanel/README.md) | the 172N lower left switch panel: master, lights, avionics; the primer below it |
| [`ignition/`](ignition/README.md) | the ignition key switch, the left end of the switch panel |
| [`frame/`](frame/README.md) | the aluminium frame and panel sheet that everything mounts on |
| [`hub/`](hub/README.md) | the box with the MobiFlight Mega and the Cat5 ports |
| [`yoke/`](yoke/README.md) | the hollow control wheel: PTT, trim rocker, a mux inside |
| [`compass/`](compass/README.md) | the magnetic compass over the panel: a printed card on a 28BYJ-48 stepper, on its own Nano |
| [`instruments/`](instruments/README.md) | the analogue instruments: the RPM and airspeed indicators, a 28BYJ-48 stepper behind a colour printed face |
| [`radio/`](radio/README.md) | the radio stack: the KMA 26 audio panel, two KX155 NAV/COMs and the KT 76C transponder, on their own Mega (the audio panel on its own Nano) |

How the components connect to the computer (the hub's ports, their
pinout and the cables) is in [the hub's Connections](hub/README.md#connections).

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
renders it. A print is a 2D drawing for paper (the compass card): exported
1:1 to an A4 PDF, filled black, with OpenSCAD's scale bar to check it. With
a list of colours it is a colour print (an instrument's face): rendered
once per colour, the file drawing only that colour's shapes
(`print_color`), and the layers laid over each other in that order with
[qpdf](https://qpdf.sourceforge.io/), which has to be installed for it. `{{gitrev}}` in the source is replaced with the short git hash,
so the version is embossed into the parts.

Values and modules shared by several files of a component go into a
`*.inc.scad` file that the others `include`. It is not rendered itself, and
changing it renders the whole component again.

The printer is an Anycubic Kobra 3 V2 (255 x 255 mm bed). Large parts must
fit on it, and the files check it. Values that depend on bought parts
are marked MEASURE in the source; `assert()`s check that the derived
geometry still fits, so a wrong measurement fails the build instead of
printing a bad part.

## Components

### [Cockpit frame](frame/README.md)

The aluminium extrusion frame on the desk that carries all components, and
the panel sheets over it, laid out like the X-Plane 172N's panel.

[![Cockpit frame](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)

### [Hub](hub/README.md)

The box with the MobiFlight Mega and 6 RJ45 ports: every component connects
to its own port with one Cat5 cable.

[![Hub](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)

### [Throttle quadrant](throttle/README.md)

Throttle, mixture and carb heat: 6 mm rods moving linear potentiometers in
one box.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

### [Switch panel](switchpanel/README.md)

The 172N's lower left switch panel: master, avionics, lights and dummy
circuit breakers on a mux, and the primer below the ignition key.

[![Switch panel](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)

[![Primer](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)

### [Ignition](ignition/README.md)

The OFF - R - L - BOTH - START key switch, built around a mailbox cam lock,
with a spring-return START and a hall sensor per position.

[![Ignition switch](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)](https://robertbraeutigam.github.io/cessna172/ignition/ignition_montage.png)

### [Yoke](yoke/README.md)

The hollow Cessna control wheel with PTT buttons, an electric trim rocker
and a mux inside.

[![Yoke](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)

### [Compass](compass/README.md)

The magnetic compass over the panel: a drum card with a printed paper
strip, turned by a 28BYJ-48 stepper and homed on a hall sensor, on an
Arduino Nano of its own.

[![Compass](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)](https://robertbraeutigam.github.io/cessna172/compass/compass_montage.png)

### [Instruments](instruments/README.md)

The analogue instruments, built on one standard: a 3 1/8" case behind the
panel, a colour printed face, a needle turned by a 28BYJ-48 stepper through
two printed gears. So far the RPM indicator (motor on an arm beside the
case, for the yoke housing behind it) and the airspeed indicator (motor
and boards behind the case, to fit the six-pack).

[![RPM indicator](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/rpm_montage.png)

[![Airspeed indicator](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)](https://robertbraeutigam.github.io/cessna172/instruments/asi_montage.png)

### [Radio stack](radio/README.md)

The KMA 26 audio panel, two KX155 NAV/COMs and the KT 76C transponder, on a
Mega of their own (the audio panel on its own Nano).

[![KMA 26](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)

[![KX155](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)

[![KT 76C](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)
