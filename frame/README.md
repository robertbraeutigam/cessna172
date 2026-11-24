# Cockpit frame

[Cessna 172 home cockpit](../README.md) / `frame/`

The frame on the desk that carries all components, and
the panel sheet over it.

[![Cockpit frame](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)](https://robertbraeutigam.github.io/cessna172/frame/frame_montage.png)

The panel is laid out like the X-Plane 172N's (the `n172_*` values,
measured off its panel and scaled by its 3 1/8" instruments), with the
yoke on the desk and its column as the reference: the six-pack above the
column with the two NAV indicators right of it and the RPM indicator
beside the column, the radio stack right of those, and the lower panel
(ignition with the primer, switch row, throttle, flaps) below the desk
top, as far below the column as in the 172N or lower where the desk or
the yoke's clamps are in the way. Lower the chair for it: the knees go
under the lower panel. In stage 1 (now) the left part above the desk is
only as high as the yoke column needs and the monitor behind it shows
the instruments; in stage 2 physical instruments go into a full height
left sheet without moving anything else (see below).

The frame is all 2020 extrusion (one profile, M5 T-nuts everywhere) in two
parts, each built on its own and then bolted together:

- **Front part**, vertical, in front of the desk edge, from below the
  lower panel up to the top bars: a bottom bar under the lower panel; four
  uprights: the left end one, the split one between the switch panel and
  the throttle box (from the bottom bar up to the waist bars), the step
  one right of the NAV indicators (on the waist bars, up to the right top
  bar) and the right end one; two waist bars, one on the other, just under
  the desk top from the split upright to the right end (left of it the
  yoke's clamps are there); a low left top bar between the left end and
  the step upright, just over the yoke's shaft, and the right top bar over
  the radios. The left end upright is as high as the right part already,
  for its brace and the stage 2 top bar. Behind the split and right end
  uprights, under the desk, the throttle bar carries the throttle box and
  the flaps panel. The uprights' and waist bars' backs touch the desk edge
  (felt pads), so pushing the frame away hits a stop. Its bars are cut to
  length (`round_cut`), as its heights come from the parts on the sheet.
  Three 3 mm aluminium composite (ACM) sheets are screwed onto its front
  slots: the left one, L shaped (down to the bottom left, and above the
  desk to the step upright), the lower right one (throttle, flaps) and the
  upper right one (radios), which can be cut again on its own when the
  radios change. The lower and upper sheets meet between the two waist
  bars, each screwed onto one.
- **Desk part**, flat on the desk behind it: a ladder of a front rail, a
  rear rail and three crossbars (under the left end, step and right end
  uprights), stock lengths. The front rail is cut at
  the yoke. The front part is bolted to the front rail with corner
  brackets, and a 45 degree brace from the left end, step and right end
  uprights down to a crossbar stops it from rocking. The braces are 200 mm
  stock bars cut square, held by a bought 45 degree connector for 2020 at
  each end, in the obtuse angle (at the top the upright needs 30 mm above
  the brace for it).

**Yoke**: the Saitek yoke stands on the desk between the front rail's
halves, its front on the desk edge, clamped on the edge with its own
clamps, whose spines go down behind the sheet (no part of the front part
is there). Its shaft comes through a round hole in the left sheet
(`yoke_hole_d`, 28 mm), 65 mm above the desk (`yoke_shaft_z`) and 266 mm
from the left edge; the left top bar is just over it, so the left sheet
ends 100 mm above the desk. With the shaft in, the wheel is about 30 mm in
front of the sheet (`yoke_reach`, checked). The stand-in for a future
force feedback yoke (DIY, comes with the stage 2 instruments: `ffb_h`,
130 mm high) stands 30 mm over the left sheet, its housing 30 mm further
back than the Saitek's (`ffb_back`, its shaft made as long as that needs),
so the instruments' cases fit in front of it. The Saitek could not go
back: its clamps need the desk edge, and its wheel would come within
about 2 mm of the sheet with the shaft in.

**Lower panel**, below the desk top. The panels' backs reach behind the
sheet under the desk, so they stay under its underside (28 mm, `desk`)
and, where the yoke's clamps are, under those (`yoke_clamp_low`, 20 mm
more): the switch row's face starts 141 mm below the desk top (in the
172N it is 159 mm under the column, here 206 mm, because of the clamps),
the ignition 20 mm higher (as high as the desk allows, `switch_ign_rise`),
the primer under its key 20 mm of sheet under the ignition's hole, the
throttle box with its rods 56 mm over the switch row's bottom like in the
172N (85 mm below the desk top), its body under the desk on the throttle
bar, and the flaps panel (lever pot and indicator servo, on a Nano of its own; not
designed yet, so its 50 x 63 mm front plate and 64 mm depth are
placeholders) 70 mm (`flaps_gap`) right of the throttle box face, its
body on the throttle bar too. The **parking brake** sits on the bottom bar
under the yoke column, its T-handle through a small hole under the switch
row: released, it is almost flush and lies sideways; set, it is pulled
out 50 mm and turned to point down. The bottom bar is just under the
lowest hole (the primer's), so the lower panel ends 190 mm below the
desk top, which the build checks against `knee_z` (the top of the knees
with the chair lowered, MEASURE).

**Apron**, under the throttle: two hangers under the bottom bar (corner
brackets; the left one right of the leg room, the right one under the
end upright) and a lower bar between their ends, covered by a small ACM
sheet. It carries the **pedestal** with the trim wheel and the trim
indicator (75 x 150 mm front), as far left under the throttle box as the
leg room (`knee_w`, 460 mm around the yoke column) allows, which stands
on the lower bar like the throttle box on its bar. The pedestal and the
parking brake are future components; their sizes (`pedestal_size`,
`park_size`) reserve the space (the depths are guesses), and their holes
are cut when they exist.

**Right part**: the **Saitek radio panel**, at the bottom of the place of
the DIY [radio stack](../radio/README.md), right of the NAV indicators. The
stack hangs from where the 172N's starts (`n172_stack_dz`, its top 289 mm
above the desk): the KMA 26 audio panel (33 mm, 1.30"), the two KX155s and
the KT 76C, 176.5 mm in all (`stack_units_h`). The right top bar is over
the instruments' top row and at the 172N's glareshield, so the right part
is 330 mm high, checked against `sheet_h_r_max` (330 mm): it covers the
monitor's bottom right corner, where X-Plane draws its own radios. The
`sheet` view outlines the stack's place. The frame ends 25 mm of sheet
right of the radio panel (`frame_w` is computed, 850 mm).

**Stage 2, physical instruments.** The instruments' places are reserved
(`inst_c`, outlined in the `sheet` view): 81 mm holes (3 1/8"
instruments) on 89 mm (3.5") centres, the six-pack in two rows 92 and
180 mm over the yoke column, its middle column 9 mm left of it; NAV 1 and
NAV 2 in a column 100 mm right of the six-pack's, in the same rows; the
RPM indicator beside the column, under the VSI. In stage 1 the
six-pack and the NAV indicators are above the left sheet, where the
monitor shows them; the RPM is mostly behind it. For stage 2 the left top
bar moves up to the right one's height (the left end upright already
reaches there), and a new left sheet, as high as the right part, is cut
with all the left holes; the monitor goes up behind the glareshield. The
build checks that the instruments stay on the left sheet, clear of each
other, the yoke column hole and the split upright, and that their cases
fit in front of the force feedback yoke's housing (`inst_body_d`,
`inst_depth`: the [standard instrument](../instruments/README.md)'s case
with the motor and boards behind it, 84 mm round and 47 mm deep behind the sheet; the VSI, NAV 1
and the RPM are in front of the housing). The
[attitude indicator](../instruments/README.md#attitude-indicator) is
deeper, 116 mm (`ai_depth`), and has a square 86 mm front bezel
(`ai_bezel`, checked against its neighbours' holes), so it must stay in the top row, over the
housing; so must the [altimeter](../instruments/README.md#altimeter),
98 mm deep (`alt_depth`: two motors behind each other). The
[heading indicator](../instruments/README.md#heading-indicator) is in
the bottom row over the housing's top: its boards make it 62 mm deep
(`hi_depth`), but only above 24 mm under its axis (`hi_deep_z`), which
is over the housing; under that it is 19 mm deep (`hi_low_depth`). The
[turn coordinator](../instruments/README.md#turn-coordinator) left of it
is built the same way: 65 mm deep (`tc_depth`) above 24 mm under its
axis (`tc_deep_z`), 22 mm under that (`tc_low_depth`). The ADF's place in the 172N, under NAV 2 at the column's height,
is free as well.

The frame overhangs the desk edge by 22 mm (`frame_overhang`: a 2020 and
a 2 mm felt pad), so the sheet is 22 mm in front of the desk edge; the
front rail lies 18 mm on the desk.

**Desk clamps**: the front rail runs at least 50 mm past the sheet at each
end (`ear_len`; its halves are 200 and 500 mm). There a
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

The rule for every component: it brings its own front face, a hole is cut
into the sheet for it and its face is screwed onto the sheet. Heavy or
pulled components also stand on the frame: the throttle box sits on the
throttle bar, its face flange is screwed onto the sheet like the switch
panel's and two M5 bolts through its floor go into the bar.
The pedestal does the same on the apron's lower bar. Every component has
its own Arduino Nano and USB cable; the
[powered USB hub](../README.md#powered-usb-hub) they plug into stands
on the desk right of the yoke, between the step upright's and the right
end crossbar (not bolted down). The Saitek yoke and radio panel plug
into it too, with their own USB cables (a port each, a few hundred mA
together). The crossbars are as long as the force
feedback yoke's housing needs.
The [compass](../compass/README.md) stands over the panel on the right
top bar, about over the radio stack's left edge (`n172_compass_dx`, a
guess for the windshield's middle): its printed stand's foot is bolted
into the bar's top slot (two M5, T-nuts, `compass_bolts`).
The extrusion carries the
loads, the sheet only covers the front, so cut-outs do not weaken it.
Keep at least 25 mm of sheet to the edge and 20 mm between cut-outs
(between the instruments it is 8 mm, as in the 172N), and
drill the corners of a cut-out before sawing it. Holes for future
components are cut when they arrive.

All values are in `frame.inc.scad`; the layout (cut-outs, screw holes) is
computed from the component sizes and the 172N positions, and the build
prints the cut list (`echo`). With the current guesses the frame is 850 x
360 mm, the left part 100 mm and the right part 330 mm high above the
desk, the lower panel 190 mm below it; the left sheet is 511.5 x 290 mm
(396 mm wide under the waist), the lower right one 454 x 170 mm, the upper
right one 338.5 x 350 mm, the apron sheet 350 x 220 mm. With the ears the
frame takes 993 mm of the desk width.

| Part | 2020 bars |
|------|-----------|
| front part (cut) | bottom bar 850, uprights 480 (left end), 130 (split), 310 (step), 480 (right end), 2 waist bars 434, top bar left 491.5 and right 338.5, throttle bar 434, 2 apron hangers 200, lower bar 310 |
| desk part | front rail left 200 and right 500, rear rail 850, 3 crossbars 300, 3 braces 200 (cut square) |

| File | Parts |
|------|-------|
| `frame.inc.scad` | extrusion and sheet standard, component sizes, 172N layout, layout, checks |
| `frame.scad` | views, cut list |

**MEASURE:** the desk (`desk`, and `desk_skirt` if it has a frame or
drawer under the top at the front edge), the pilot's leg room (`knee_w`)
and knee height with the chair lowered (`knee_z`), the desk clamps
(`clamp_open`, `clamp_reach`, `clamp_w`, `clamp_pad_d`), the Saitek yoke
(`yoke_housing`, guessed 283 mm wide like the radio panel and about 100
mm high; spec sheet: 310 mm wide with the wheel; its shaft height and
diameter `yoke_shaft_z`, `yoke_shaft_d`, the wheel's reach `yoke_reach`,
`yoke_wheel_t`, and its clamps `yoke_clamp_*`: where they are and how far
below the desk they reach set how low the switch row goes), the force
feedback yoke's height and set back (`ffb_h`, `ffb_back`), how deep the switch panel reaches
behind the sheet (`switch_depth`), the radio panel body that goes through
the sheet (`radio_body`, from Logitech's "Construction dimensions for
Flight Panels" drawing) and the panel heights the monitor allows
(`sheet_h_max`, `sheet_h_r_max`).

The ignition and the switch row each have their own hole, 1 mm larger
than their back all round, with 20 mm of sheet between them. Drill the M3
mount holes through the panels' own holes, with the panels in place. The
primer has its own, smaller hole under the ignition key, 20 mm of sheet
below the ignition's, 1 mm larger than its square back, and its four
flange holes are drilled the same way. The same goes for the throttle
box: its cut-out is 1 mm larger than the box at the sides and the top,
and starts at the throttle bar's top, and its flange holes are drilled
with the box in place.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 21 | 2020 extrusion, 6 mm slot | front part: bottom bar, 4 uprights, 2 waist bars, top bar left and right, throttle bar, 2 apron hangers, lower bar; desk part: front rail left and right, rear rail, 3 crossbars, 3 braces (cut square) |
| 6 | 45 degree connector for 2020 | brace ends |
| - | corner brackets, M5 screws, M5 T-nuts | frame joints, and the front part onto the front rail |
| 4 | 3 mm ACM sheet | panel: left (L shaped), lower right and upper right sheet (sheet_* in the echo); the apron sheet |
| 57 | M5 button head screw + T-nut (+ washer at the throttle box floor) | sheets, throttle box, pedestal, parking brake and compass stand |
| 2 | screw clamp with rubber jaws, 50 mm opening | rail ends onto the desk |
| 4 | felt pad | on the uprights' and the waist bars' backs, against the desk edge |
