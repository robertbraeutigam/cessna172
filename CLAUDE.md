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
    sliced into three printable pieces joined by screwed seams, plus a lid.
  - `carb_heat_knob.scad`, `clamp.scad`, `pin.scad` — small parts (knob,
    rod clamps, pot hold-down pins).
  - `TODO` — open design tasks.
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

## Building

Run `make` inside a component directory (e.g. `throttle/`). The OpenSCAD binary
comes from the `OPENSCAD` environment variable (set in the user's environment
to an OpenSCAD 2021.01 AppImage; the Makefile does not define it):

```sh
cd throttle
make                       # render every .scad that changed
make target/throttle_box   # render a single file
make clean                 # remove target/
```

Output goes to `target/` (not committed). `target/<file>` is an empty marker
used by make to skip up-to-date files; the STLs sit next to it. Old STLs are not
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
- Pieces must fit the printer bed, which is why large parts are sliced (see
  `box_underside_slice1..3`).
- Values that depend on bought parts are grouped as parameters marked
  MEASURE, and `assert()`s check that derived geometry still fits, so a
  wrong measurement fails the build instead of printing a bad part.

## Verifying changes

After editing a `.scad` file, run `make` (or the single-file target) in the
component directory and check it finishes without OpenSCAD errors/warnings.

## Git

Commit messages are short imperative summaries, e.g. `Add reverse pin`,
`Modify slider clamp`.
