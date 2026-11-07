# Cessna 172 Home Cockpit

Hardware project to build a Cessna 172 cockpit for the X-Plane flight simulator.
Parts are designed in OpenSCAD and 3D printed. Each cockpit component lives in
its own top-level directory (currently only `throttle/`); new components should
follow the same layout.

## Projects

- `throttle/` — throttle quadrant: throttle, mixture and carb heat controls.
  - `throttle_box.scad` — the main box. Linear potentiometers sit on stands
    inside, 6 mm rods (one per control) exit the front, an ESP32 sits on a
    pedestal at the back, and there are two clamp housings at the front. The underside is
    printed in one piece, plus a lid.
    Its views show the pots, rods with knobs, clamps, pins, ESP32 and wiring
    as view-only parts; the knob, clamp and pin shapes there are copies of
    the other files, keep them in sync.
  - `carb_heat_knob.scad`, `clamp.scad`, `pin.scad` — small parts (knob,
    rod clamps, pot hold-down pins).
- `switchpanel/` — the Cessna 172N lower-left switch panel (ignition key,
  master, light switches, ...). Similar in function to the Saitek Switch Panel,
  but it should look as close to the real 172N panel as possible, and every
  switch position is a raw output wire for SimVim (active low, like a switch
  to GND).
  - `ignition.scad` — OFF/R/L/BOTH/START key switch built around a cheap
    mailbox cam lock (its 90° stop removed). It has a ball detent, end stops
    on a rotor lug, a spring-return START (pin + shoe + spring in an arc slot),
    and one magnet with a digital hall sensor per position. The header comment
    has the parts list and assembly order. The `lock_*` values are guesses
    until the real lock is measured.
  - `switches.scad` — a separate panel with the switch row: a red double
    rocker for MASTER (ALT, BAT), M12 toggles in the middle (lights,
    pitot heat, fuel pump) and a black double rocker for
    AVIONICS (BUS 1, BUS 2), with the labels engraved. Above the toggles
    is a row of printed dummy circuit breakers (`breakers`, for show only,
    glued into hex pockets). A CD74HC4067
    input mux on standoffs on the back collects all switches and the
    ignition, so one cable runs to the SimVim Mega. The switch list
    (`groups`) drives the layout. The `rk_*` values come from the rocker
    listing; `tg_*` are guesses until the switches are measured.

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
  `target/<file>.stl`.

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
  holes, 4.2 mm for M4 / the USB cable, 6.2 mm for the 6 mm rods, 11.2 mm for
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
