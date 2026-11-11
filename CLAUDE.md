# Cessna 172 Home Cockpit

Hardware project to build a Cessna 172 cockpit for the X-Plane flight simulator.
Parts are designed in OpenSCAD and 3D printed. Each cockpit component lives in
its own top-level directory; new components should follow the same layout.

## Projects

- `throttle/` — throttle quadrant: throttle, mixture and carb heat controls.
  - `throttle_box.scad` — the main box. Linear potentiometers sit on stands
    inside, 6 mm rods (one per control) exit the front, an ESP32 sits on a
    pedestal at the back. It is printed in one piece and has no lid: it goes
    through a cut-out in the frame's sheet, its front wall is the face with
    a flange (top and sides, `flange_w`) screwed onto the sheet, and two M5
    bolts through the floor go into the frame's front rail; `frame/frame.inc.scad`
    repeats these sizes.
    Its views show the pots, rods with knobs, clamps, pins, ESP32 and wiring
    as view-only parts; the knob, clamp and pin shapes there are copies of
    the other files, keep them in sync.
  - `carb_heat_knob.scad`, `clamp.scad`, `pin.scad` — small parts (knob,
    rod clamps, pot hold-down pins).
- `switchpanel/` — the Cessna 172N lower-left switch panel (ignition key,
  master, light switches, ...). Similar in function to the Saitek Switch Panel,
  but it should look as close to the real 172N panel as possible, and every
  switch position is a raw output wire for MobiFlight (active low, like a switch
  to GND). It is two panels printed separately and mounted side by side,
  ignition on the left.
  - `panel.inc.scad` — included by both: back height (`panel_h`, the same
    for both), thickness, rim, face flange (`flange_w`) with the mount
    holes, lettering, the separate front face (`face_t`, printed front
    side up, labels standing out of it for a paint pen) and the
    `panel_blank` plate (square corners and no
    flange where the panels meet). The back goes through a hole in the
    frame's sheet, the flange is screwed onto it; `frame/frame.inc.scad`
    repeats these sizes.
  - `ignition.scad` — its panel and face and the
    OFF/R/L/BOTH/START key switch built around a cheap
    mailbox cam lock (its 90° stop removed). It has a ball detent, end stops
    on a rotor lug, a spring-return START (pin + shoe + spring in an arc slot),
    and one magnet with a digital hall sensor per position. The header comment
    has the parts list and assembly order. The `lock_*` values are guesses
    until the real lock is measured.
  - `ignition.lua` — FlyWithLua script for X-Plane that holds the starter
    while START is pressed (MobiFlight writes its dataref; it cannot hold
    a command itself).
  - `switches.scad` — a separate panel with the switch row: a red double
    rocker for MASTER (ALT, BAT), M12 toggles in the middle (lights,
    pitot heat, fuel pump) and a black double rocker for
    AVIONICS (BUS 1, BUS 2), with the labels on its face. Above the
    toggles is a row of printed dummy circuit breakers (`breakers`, for
    show only, glued into hex holes in the face). A CD74HC4067
    input mux on standoffs on the back collects all switches and the
    ignition, so one Cat5 cable runs to hub port 3 (soldered to the mux,
    tied onto `tie_block` next to it). The switch list
    (`groups`) drives the layout. The `rk_*` values come from the rocker
    listing; `tg_*` are guesses until the switches are measured.

- `hub/` — `hub.scad`: the box (and lid) with the Arduino Mega running
  MobiFlight (the Connector on the Windows PC talks to X-Plane; servos and
  encoders go straight to Mega pins, encoders never through a mux), a
  prototype board (bus header, room for extra circuits) and 6 RJ45 breakout
  boards in one row (MobiFlight takes at most 6 muxes per Mega; more
  ports means a second hub with its own Mega). Ports 1-3 are mux ports
  (S0..S3, 5 V, GND, SIG, AUX), ports 4-6 direct ports (5 V and GND on
  the same pins 4 and 5, the other six wires are lines to their own Mega
  pins, a servo takes its power on the orange pair), for components
  without a mux (servos, encoders, pots). The bus wires join pins 4 and 5
  of all boards and S0..S3 of the mux ports; everything else goes to the
  Mega or to the servo header on the prototype board with jumper wires,
  nothing is soldered on the Mega. Every MobiFlight component connects to
  its own numbered port with one Cat5 cable, RJ45 plug at the hub and
  soldered straight to the component (no connector there); the port
  pinouts and the port list are in the README's Connections section, keep
  components and README in sync with them. The `rj_*` and `proto_*`
  values are guesses until the parts are measured.

- `frame/` — the aluminium extrusion frame on the desk and the ACM panel
  sheet over it, all 2020 profile. `frame.inc.scad` holds the
  extrusion/sheet standard, the
  sizes of the components it carries (copies of the other components'
  values and MEASURE values for the bought Saitek yoke and radio panel,
  keep them in sync), the layout and its checks; `frame.scad` has the
  views and the cut list (echo), no printed parts. Every
  component brings its own front face and is screwed onto a cut-out in the
  sheet; heavy or pulled ones also stand on the frame. The frame is two
  parts bolted together: the vertical front part in front of the desk
  edge (a rectangle with the uprights, its bottom bar just under the desk
  top, and the apron hanging under the throttle for the trim wheel
  pedestal and the DIY flaps panel (not designed yet); the thin parking
  brake hangs under the bottom bar below the yoke), and the desk part (a
  ladder on the desk, its front rail cut at the yoke), with 45 degree
  braces between them (stock bars cut square, bought 45 degree
  connectors). Lengths are rounded to stock lengths (`round_*`). The front rail
  runs past the sheet at both ends (`ear_len`), where two bought screw
  clamps clamp it onto the desk (no printed parts in the load path: they
  creep under constant load). `knee_w` around the yoke stays open for the
  legs.

## Documentation

`README.md` at the top level is the only documentation file: it describes
every component (working principle, hardware with shop links, wiring,
assembly) and embeds the montage images. Keep it in sync when a design,
part list or wiring changes; do not add per-component docs files. The scad
header comments stay as the in-source summary.

The README images are not committed. The `Build` workflow
(`.github/workflows/build.yml`) runs `make` in every component on each push
and, on `master`, deploys the STLs and PNGs to GitHub Pages at
`https://robertbraeutigam.github.io/cessna172/<component>/<file>`; the
README links there. It caches each component's `target/` together with
`target/.sources.sha256` (hashes of the sources it was made from), so only
changed `.scad` files are rendered again; a changed Makefile re-renders the
whole component. Unchanged parts therefore keep the `{{gitrev}}` and montage
date of the build that last rendered them.

## Building

Run `make` inside a component directory (e.g. `throttle/`). The OpenSCAD binary
comes from the `OPENSCAD` environment variable (set in the user's environment
to an OpenSCAD 2021.01 AppImage; the Makefile does not define it):

```sh
cd throttle
make                       # render every .scad that changed (STLs + views)
make models                # only the STLs
make views                 # only the PNG views
make target/throttle_box   # render a single file
make clean                 # remove target/
```

All projects share the same Makefile; keep the copies identical.

`*.inc.scad` files hold values and modules shared by the files of a
component, which `include <name.inc.scad>` them. They are not rendered, the
Makefile copies them into `target/` (models are rendered from there) and
every model depends on them, and the build workflow renders the whole
component again when one changes. Do not assign a variable again that the
include already defines: OpenSCAD silently takes the last value.

Output goes to `target/` (not committed). `target/<file>` and
`target/<file>.views` are empty markers used by make to skip up-to-date files;
the STLs and PNGs sit next to them. Old STLs are not
removed when a module is renamed or deleted, so `make clean` if in doubt.

### Modules: one scad file, several printable STLs

A "module" here means one unit of 3D printing, not an OpenSCAD `module`. A file
declares them with marker comments on the line that instantiates the geometry:

```openscad
box_lid(); // Make module lid
//#big_pots(); // Ignore module
```

- `// Make module <name>` — the Makefile renders a separate
  `target/<file>_<name>.stl` containing only that line. It first comments out
  every marker line, then uncomments one at a time. **A leading `//` on a Make
  module line does not disable it in the build**; it only hides it from the
  OpenSCAD GUI preview. To stop building a module, remove the marker.
- `// Ignore module` — never rendered. Used for reference geometry (pots, rods,
  ESP32 board) that is shown with `#` in the preview while designing.
- Files without any `Make module` marker are rendered whole to
  `target/<file>.stl`, unless they have `Make view` markers: then they
  only make views (their asserts are still checked), like `frame.scad`.

Marker format is strict: the name is a single word, separated by single
spaces, and it must be the last thing on the line (trailing spaces are OK).
The whole statement must fit on that one line, e.g.
`translate([0, 0, z]) rotor(); // Make module rotor`, because the Makefile
comments out and uncomments whole lines.

### Views: PNG pictures of the design

```openscad
//exploded_view(pos = 0); // Make view main 62,0,32
```

`// Make view <name> <rx>,<ry>,<rz>` renders that line alone to
`target/<file>_<name>.png`, with the camera rotated as given (`0,0,0` looks
from +z) and automatically framed. Views use the colored OpenSCAD preview
renderer (OpenCSG), so they need a display, and they are rendered at twice
the size and then trimmed, scaled and padded with ImageMagick (`convert`) if it
is installed. With ImageMagick, `target/<file>_montage.png` combines them: a
title (the first comment line of the scad file), the `main` view (or the first
view if there is no `main`) and the other views as captioned thumbnails.
View lines are usually commented out in the source so the GUI
preview shows the parts; as with modules, that does not stop them from being
built. Keep view-only geometry and colors (bought parts, labels, exploded
layouts) in `*_view` / `*_part` modules so they never end up in an STL.

The Makefile also replaces `{{gitrev}}` in the source with the short git hash,
so a version can be embossed into a part. Files are rendered from the copy in
`target/`, so any `use`/`include` paths would resolve relative to `target/`.

## Design conventions

- Units are millimetres. `$fn` is set at the top of each file.
- Dimensions go in named variables at the top of the file, with derived values
  computed from them; reuse the same names across files (e.g. `pin.scad`
  repeats the `big_pot_*` values from `throttle_box.scad`).
- Hole clearances used so far: 3.2–3.3 mm for M3 screws, 2.1 mm for M2 pilot
  holes, 4.2 mm for M4 / the USB cable, 5.3 mm for M5 (frame), 6.2 mm for the 6 mm rods, 11.2 mm for
  the rod nuts.
- The printer is an Anycubic Kobra 3 V2 with a 255 x 255 mm bed. Pieces must
  fit it; files with big parts check it with a `bed = [255, 255]` parameter.
- Values that depend on bought parts are grouped as parameters marked
  MEASURE, and `assert()`s check that derived geometry still fits, so a
  wrong measurement fails the build instead of printing a bad part.

## Verifying changes

After editing a `.scad` file, run `make` (or the single-file target) in the
component directory and check it finishes without OpenSCAD errors/warnings.

## Git

Commit messages are short imperative summaries, e.g. `Add reverse pin`,
`Modify slider clamp`.
