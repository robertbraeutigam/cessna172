// Cockpit frame basics, shared by the files in frame/
//
// The frame is two parts of 2020 extrusion, each built on its own and then
// bolted together. 3 mm aluminium composite (ACM) sheet covers the front;
// every cockpit component brings its own front face, a hole is cut into
// the sheet for it and its face is screwed onto the sheet. Heavy or pulled
// components (the throttle box) also stand on the frame and are bolted to
// it.
//
// Coordinates, seen from the pilot: x to the right, y away from the pilot
// (towards the monitor), z up. The origin is the front left corner of the
// frame at desk height: the front part has its front face at y = 0, the
// sheet is in front of it (y = -sheet_t .. 0).
//
// The layout follows the X-Plane 172N panel (the n172_* values), with
// the yoke on the desk and its column as the reference: the lower panel
// (switch row, primer, throttle, flaps) hangs below the desk top, as far
// below the column as in the 172N (or lower where the desk or the yoke's
// clamps are in the way); the pilot lowers the chair for it.
//
//   left sheet (L shaped)                      upper right sheet
//   six-pack | NAV 1/2 (stage 2), monitor      radio stack
//   yoke column, RPM (stage 2)
//   ---------------------------- desk top ------------------------------
//   ignition + primer, switches   |  lower right sheet: throttle, flaps
//   (pedestal with the trim wheel on the apron under the throttle)
//
// Stage 1 (now): the left sheet is only as high as the yoke column needs,
// the monitor behind it shows the six-pack, the NAV indicators and (partly)
// the RPM. Stage 2 (physical instruments): the left end upright is
// swapped for a longer one, the left top bar moves up to the right one's
// height and a full height left sheet gets the reserved instrument holes
// (inst_c, outlined in the "sheet" view); nothing else moves.
//
// - Front part, vertical, in front of the desk edge: a bottom bar under
//   the lower panel, the uprights, a waist bar (two bars, one on the
//   other) just under the desk top right of the yoke's clamps, and two top
//   bars: the left one low, the right one over the radio stack. The
//   uprights: the left end one (as high as the right part, for its brace
//   and the stage 2 top bar), the split upright between the switch
//   panel and the throttle box (from the bottom bar to the waist bar), the
//   step upright left of the radios (on the waist bar, up to the right top
//   bar) and the right end one. Their backs and the waist bar's touch the
//   desk edge (felt pads). Under the throttle an apron hangs from the
//   bottom bar: two hangers and a lower bar, for the trim wheel pedestal.
//   Behind the uprights under the desk, the throttle bar carries the
//   throttle box and the flaps panel.
// - Desk part, flat on the desk behind it: a ladder (front rail, rear rail,
//   crossbars), the front rail cut at the yoke, which stands on the desk
//   with its own clamps on the desk edge. The front part is bolted to the
//   front rail, and a 45 degree brace from each upright that reaches the
//   desk down to a crossbar stops it from rocking: a stock length, cut
//   square, held by a bought 45 degree connector at each end. The powered
//   USB hub (README.md, Connections) stands on the desk between the step upright's
//   and the right end crossbar.
//
// The front rail runs past the sheet at both ends (ear_len): there a
// bought screw clamp (rubber jaws) on each end clamps the rail onto the
// desk. All metal, printed parts creep under constant load.
// knee_w around the yoke column is the pilot's leg room: below the desk
// top everything there stays above knee_z (the knees with the chair
// lowered).
//
// The desk part's bars are stock lengths (multiples of round_d); the
// front part's are cut to length (round_cut), as its heights come from
// the parts on the sheet.

// --- Extrusion: 2020 only, 6 mm slot, M5 T-nuts everywhere ---
ext = 20;
round_d = 50;                // the desk part's bars rounded to this (stock lengths)
round_cut = 10;              // the front part's bars and heights rounded to this (cut)
brace_len = 200;             // a stock length, cut square
slot_w = 6;
m5_d = 5.3;                  // M5 clearance, sheet and printed parts
m5_head_d = 9.5;             // button head

// --- Sheet ---
sheet_t = 3;                 // ACM, the same as the printed panel_t
sheet_h_max = 260;           // stage 1: left panel height above the desk at most; the monitor shows the
                             // instruments over it (sheet_h is computed from the parts on it)
sheet_h_r_max = 330;         // the right part's (sheet_h_r) at most: it may cover the monitor's bottom right
                             // corner, where X-Plane draws its own radios
sheet_edge = 25;             // sheet edge to a cut-out, at least
sheet_web = 20;              // sheet between two cut-outs, at least
screw_edge = 6;              // screw hole center to a cut-out, at least
screw_step = 150;            // screws along a bar, at most this far apart
screw_step_upright = 100;

// --- Desk and pilot, MEASURE ---
desk = [1200, 700, 28];      // width, depth, thickness
desk_skirt = 0;              // frame or drawer under the top at its front edge, height below the top
desk_clear = 3;              // anything under the desk to its underside, at least
knee_w = 460;                // the pilot's leg room, centered on the yoke column
knee_z = -200;               // MEASURE: top of the knees below the desk top, the chair lowered
edge_play = 2;               // front part back to the desk edge: a felt pad, the front part stops the frame against the edge
frame_overhang = ext + edge_play;     // frame front in front of the desk edge
desk_low = -(desk.z + desk_skirt);    // the desk's underside at its front edge

// --- Saitek Pro Flight Yoke, MEASURE ---
// Spec sheet: 310 mm wide (the wheel), 380-464 mm deep with the shaft in /
// out. The housing is about 100 mm high and about as wide as the radio
// panel that sat on it (from memory). It stands on the desk, its front at
// the desk edge, its two clamps on the desk edge: their spines go down in
// front of the edge (behind the sheet), their jaws under the desk.
yoke_housing = [283, 280, 100];   // housing body: width, depth, height
ffb_h = 130;                 // the future force feedback yoke's height
// The force feedback yoke (DIY, stage 2, with the physical instruments):
// its housing as wide and deep as the Saitek's (a guess), set back this
// far behind the Saitek's front (the desk edge), so the instruments' cases
// fit in front of it; its shaft is made as long as that needs.
ffb_back = 30;
yoke_shaft_z = 65;           // shaft center above the desk (the yoke column)
yoke_shaft_d = 22;           // the shaft through the sheet
yoke_hole_d = 28;            // its round hole in the sheet
yoke_play = 5;               // housing to the front rail ends
yoke_reach = 100;            // housing front to the wheel's front, shaft in (spec: 380 deep) (view only)
yoke_wheel_t = 45;           // the wheel with its grips, front to back
yoke_wheel_w = 310;          // view only
yoke_clamp_dx = 100;         // its clamps from the housing's middle
yoke_clamp_w = 30;           // across (x)
yoke_clamp_t = 10;           // spine, in front of the desk edge
yoke_clamp_low = 20;         // below the desk underside (jaw and screw pad)

// --- Saitek Pro Flight Radio Panel, MEASURE ---
// Spec sheet: 283 x 84 mm front, 55 mm deep (106 mm with the bracket).
// Logitech publishes the cut-out ("Construction dimensions for Flight
// Panels"); radio_body is a guess until then.
radio_front = [283, 84];
radio_front_t = 3;
radio_body = [275, 76];      // what goes through the sheet
radio_depth = 55;            // behind the sheet

// --- DIY radio stack, from radio/ ---
// Reserved: the frame still has the Saitek radio panel, but the upper
// right sheet is already as high as the DIY stack needs, which hangs from
// where the 172N's starts (n172_stack_dz), the Saitek panel at its bottom.
// Its units are stack_w wide with a flange on the left and right ends
// only, stacked without gaps in one cut-out as high as the stack. When it
// replaces the Saitek panel, the upper right sheet is cut again.
stack_w = 224;               // unit_w
stack_flange = 9;            // flange_w
stack_cut_clear = 1;         // sheet_cut_clear
// unit heights, top to bottom: KMA 26 audio panel (ap_h), KX155 (unit_h)
// twice, KT 76C (xp_h)
stack_units_h = [33, 50.8, 50.8, 41.9];
stack_h = stack_units_h[0] + stack_units_h[1] + stack_units_h[2] + stack_units_h[3];

// --- Throttle box, from throttle/throttle_box.scad ---
// The box (full_width x (depth + 2 * roundness) x height, open top) goes
// through its cut-out in the lower right sheet and stands on the throttle
// bar under the desk, its body under the desk top. Its front wall
// (face_t) is the face; the flange (flange_w, on the top and the two
// sides, none at the bottom) is screwed onto the sheet with M3 (drill
// through the box's holes), and two M5 bolts through its floor go into
// the throttle bar's top slot.
throttle_size = [150, 190, 50];
throttle_rod_xs = [20, 75, 130];  // roundness + end_gap + i * control_gap
throttle_rod_z = 38;         // wall + stand + pot module + 15 + 7
throttle_face_t = 3;         // face_t
throttle_flange = 10;        // flange_w
throttle_play = 1;           // box to its cut-out, sheet_cut_clear
throttle_bolt_xs = [47.5, 102.5]; // floor_bolt_xs
throttle_bolt_y = 36;        // floor_bolt_y, from the face front

// --- Flaps panel, DIY (lever pot and indicator servo, not designed yet;
// these sizes are placeholders until it is) ---
// Right of the mixture, like in the 172N: its front plate is screwed onto
// the sheet, its body goes through the cut-out and rests on the throttle bar.
flaps_plate = [50, 63];      // front plate, width x height
flaps_body = [44, 57, 64];   // through the sheet (a guess: 3 mm smaller than the plate all round), depth behind it
flaps_play = 0.5;            // body to its cut-out
flaps_gap = 70;              // throttle box face to the flaps plate (172N)

// --- Compass, from compass/compass.scad ---
// It stands over the panel on the right top bar, about at the windshield's
// middle like the 172's (which hangs from the windshield's top): a printed
// stand, its foot bolted into the bar's top slot (two M5, T-nuts), the
// compass on its neck. It has its own Nano on a USB cable, nothing on the
// sheet.
compass_body = [65, 107.6, 65];   // body_w, depth (bezel to back), body_h
compass_face_dy = -34.1;     // the bezel's front from the card axis (axis_to_face)
compass_stand_dy = 14;       // stand_dy: the stand's middle behind the card axis
compass_rise = 25;           // rise: the compass's bottom over the bar
compass_foot = [70, 20, 5];  // foot
compass_neck = [28, 20];     // neck
compass_bolt_dx = 25;        // foot_bolt_dx

// --- Switch panel, from ignition/ and switchpanel/ ---
// Two panels side by side, each with its own hole and a face flange
// (flange_w) all round, screwed onto the sheet with M3 (drill through the
// panel's holes): the ignition (back 77 wide) on the left, switch_ign_rise
// higher than the switches (back 196.6), with the primer under it. Both
// backs are panel_h high; sheet_web of sheet between their holes. Their
// backs reach behind the sheet, under the desk, so they stay under the
// desk's underside (the switches' also under the yoke's clamps).
switch_ign_w = 77;
switch_back = [196.6, 80];   // the switches' back; panel_h
switch_ign_rise_max = 49;    // the ignition over the switches at most (the 172N has it level)
switch_flange = 10;          // flange_w
switch_cut_clear = 1;        // sheet_cut_clear
switch_backs_gap = sheet_web + 2 * switch_cut_clear;   // ignition back to the switches' back
switch_panel = [switch_ign_w + switch_backs_gap + switch_back.x, switch_back.y] + 2 * [switch_flange, switch_flange];   // both faces
switch_depth = 40;           // switches and the mux carrier behind the sheet's back (+ 5 mm), MEASURE
switch_back_y = 5 + switch_depth;   // the switch panel's back ends here

// Primer, from switchpanel/primer.scad: its own small panel below the
// ignition key (in the middle of the ignition panel), like in the X-Plane
// 172N, sheet_web under the ignition's hole. The square back
// (primer_back, the tube for the knob) goes through its own cut-out, the
// face flange (all round) is screwed onto the sheet; the bracket with the
// pot behind it is wider than the cut-out and goes on from behind.
primer_back = 27;            // back_w
primer_flange = 10;          // flange_w
primer_face = primer_back + 2 * primer_flange;
primer_depth = 193;          // behind the panel with the knob in (view only)
primer_tube = 50.5;          // tube_len (view only)
primer_bracket = [38.1, 26, 95.2];   // beside the rod towards the pilot's right, height, length (view only)

// --- Under the lower panel ---
// Pedestal (trim wheel and trim indicator), a future component, same rule
// as the throttle box: the
// body (width x depth x height) goes through its cut-out in the apron sheet
// and stands on the lower bar, the face flange (top and sides) is screwed
// onto the sheet with M3, and two M5 bolts through the floor go into the
// lower bar's top slot.
under_face_t = 3;
under_flange = 10;
under_play = 1;              // body to its cut-out
under_bolt_y = 16;           // floor bolts from the face front, over the lower bar's slot
pedestal_size = [75, 120, 150];   // 75 x 150 front (MEASURE), the depth a guess
// Parking brake: a thin body (width x depth x height) on the bottom bar,
// under the yoke column, two M5 into the bar's top slot; its T-handle
// comes through a small hole in the sheet: released, it is almost flush
// and lies sideways; set, it is pulled out by park_pull and turned to
// point down.
park_size = [40, 90, 22];
park_bolt_dx = 12;           // bolts from its center, into the bottom bar's top slot
park_pull = 50;              // handle travel
park_handle = 60;            // T-handle length (view only)
park_hole_d = 12;            // the handle's shaft through the sheet

// --- Desk clamps: bought screw clamps with rubber jaws, MEASURE ---
// One on each front rail end (ear), beside the sheet: the fixed jaw on the
// rail top, the spine in front of the rail, the screw jaw under the desk.
// The jaws sit where the rail lies on the desk (frame_overhang .. 2 * ext).
ear_len = 50;                // front rail past the sheet at each end
clamp_open = 50;             // MEASURE: largest opening, jaw to jaw
clamp_reach = 40;            // MEASURE: spine inner face to the screw axis
clamp_w = 25;                // MEASURE: across the clamp (x), the widest part
clamp_pad_d = 20;            // MEASURE: rubber jaw diameter
clamp_y = (frame_overhang + 2 * ext) / 2;  // screw axis from the frame front

// --- 172N layout ---
// Measured off the X-Plane 172N panel, scaled by its 3 1/8" instruments
// (0.59 mm per pixel of a 1440 pixel wide screenshot): x from the switch
// panel's left face edge or as noted, z from the yoke column.
n172_col_dx = 241;           // yoke column
n172_switch_dz = 159;        // the column over the switch row's face bottom
n172_throttle_dz = 56;       // throttle rods over the switch row's face bottom
n172_throttle_dx = 472;      // throttle rod, the throttle box's middle
n172_six_dx = -9;            // six-pack's middle column from the yoke column
n172_six_dz = [92, 180];     // six-pack's (and the NAV indicators') rows over the yoke column
n172_nav_dx = 100;           // NAV indicators' column right of the six-pack's right one
n172_rpm = [6, 6];           // RPM indicator from the six-pack's right column / the yoke column
n172_stack_dz = 224;         // radio stack's top over the yoke column
n172_glare_dz = 241;         // glareshield (the panel top) over the yoke column
n172_compass_dx = 290;       // the compass (the windshield's middle) right of the yoke column, a guess:
                             // about over the radio stack's left edge
// Instruments (stage 2, reserved): 3 1/8" on 3.5" centres, the standard
// instrument from instruments/instrument.inc.scad: the case goes into the
// hole from behind, four screws through the sheet on the diagonals
six_step = 89;
inst_cut_d = 81;             // their hole (cut_d)
inst_body_d = 84;            // the case behind the sheet (case_d), its screw ears on the diagonals
inst_ear = [46, 9];          // the screw ears: from the axis, diameter (ear_r, ear_d)
// The standard instrument (instruments/instrument.inc.scad): the motor and the boards behind the case, within its
// outline, this deep behind the sheet's back (instrument_depth echo)
inst_depth = 46.6;
// The attitude indicator (instruments/ai.scad) is deeper (its drum and two
// motors, ai_depth echo): it must be in the top row, over the force
// feedback yoke's housing
ai_depth = 120.1;

// --- Layout, x ---
x_sw0 = sheet_edge;                          // switch panel, left face edge
x_sw1 = x_sw0 + switch_panel.x;
x_ign1 = x_sw0 + switch_flange + switch_ign_w;   // the ignition back's right end
x_s0 = x_ign1 + switch_backs_gap;                // the switches' back's left end
col_x = x_sw0 + n172_col_dx;                 // yoke column
x_rc = x_sw0 + n172_throttle_dx;             // the throttle box's middle
throttle_x0 = x_rc - throttle_size.x / 2;
throttle_face_w = throttle_size.x + 2 * throttle_flange;
flaps_x = x_rc + throttle_face_w / 2 + flaps_gap + flaps_plate.x / 2;
primer_x = x_sw0 + switch_flange + switch_ign_w / 2;    // rod axis
// instruments (stage 2): six-pack, NAV 1 and 2 right of it, RPM under its right column
six_x = col_x + n172_six_dx;
nav_x = six_x + six_step + n172_nav_dx;
// yoke: housing, clamps, the front rail's ends
yoke_x = [col_x - yoke_housing.x / 2, col_x + yoke_housing.x / 2];
yoke_clamp_x = [for (s = [-1, 1]) [col_x + s * yoke_clamp_dx - yoke_clamp_w / 2, col_x + s * yoke_clamp_dx + yoke_clamp_w / 2]];
x_bay0 = yoke_x[0] - yoke_play;
x_bay1 = yoke_x[1] + yoke_play;
// the split upright (the lower sheets' joint) left of the throttle box,
// the step upright (the upper sheets' joint) right of the NAV indicators
x_a = throttle_x0 - throttle_play - sheet_edge;
x_r = nav_x + inst_cut_d / 2 + sheet_edge;
radio_x = x_r + sheet_edge + radio_body.x / 2 + 0.5;   // the radio's and the DIY stack's middle
compass_x = col_x + n172_compass_dx;         // its card axis, on the right top bar
compass_bolts = [for (s = [-1, 1]) [compass_x + s * compass_bolt_dx, ext / 2]];   // M5 into the right top bar's top slot, [x, y]

// --- Layout, z ---
// Lower panel: the backs reach behind the sheet under the desk, so they
// stay under the desk's underside and, where the yoke's clamps are, under
// those.
function overlaps(a, b) = a[0] < b[1] && b[0] < a[1];
function back_top_max(xs) =
   (len([for (c = yoke_clamp_x) if (overlaps(xs, c)) 1]) > 0 ? desk_low - yoke_clamp_low : desk_low) - desk_clear;
col_z = yoke_shaft_z;
switch_z = min(col_z - n172_switch_dz,
               back_top_max([x_s0, x_sw1 - switch_flange]) - switch_flange - switch_back.y);   // the switches' face bottom
switch_ign_rise = min(switch_ign_rise_max,
                      back_top_max([x_sw0 + switch_flange, x_ign1]) - switch_flange - switch_back.y - switch_z);
ign_z = switch_z + switch_ign_rise;          // the ignition's face bottom
ign_cut = [x_sw0 + switch_flange - switch_cut_clear, ign_z + switch_flange - switch_cut_clear,
           x_ign1 + switch_cut_clear, ign_z + switch_flange + switch_back.y + switch_cut_clear];
switch_cut = [x_s0 - switch_cut_clear, switch_z + switch_flange - switch_cut_clear,
              x_sw1 - switch_flange + switch_cut_clear, switch_z + switch_flange + switch_back.y + switch_cut_clear];
primer_cut = [primer_x - primer_back / 2 - switch_cut_clear, ign_cut[1] - sheet_web - primer_back - 2 * switch_cut_clear,
              primer_x + primer_back / 2 + switch_cut_clear, ign_cut[1] - sheet_web];
primer_z = (primer_cut[1] + primer_cut[3]) / 2;
primer_face_r = [primer_x - primer_face / 2, primer_z - primer_face / 2,
                 primer_x + primer_face / 2, primer_z + primer_face / 2];
// throttle box: rods as far over the switch row as in the 172N, the box under the desk on the throttle bar
throttle_z = min(switch_z + n172_throttle_dz - throttle_rod_z,
                 back_top_max([throttle_x0, throttle_x0 + throttle_size.x]) - throttle_size.z);   // box floor
throttle_y0 = -sheet_t - throttle_face_t;    // face front, the face on the sheet
throttle_cut = [throttle_x0 - throttle_play, throttle_z,
                throttle_x0 + throttle_size.x + throttle_play, throttle_z + throttle_size.z + throttle_play];
throttle_face = [throttle_x0 - throttle_flange, throttle_z,
                 throttle_x0 + throttle_size.x + throttle_flange, throttle_z + throttle_size.z + throttle_flange];
// flaps: right of the throttle box, its body on the throttle bar too
flaps_cut = [flaps_x - flaps_body.x / 2 - flaps_play, throttle_z,
             flaps_x + flaps_body.x / 2 + flaps_play, throttle_z + flaps_body.y + 2 * flaps_play];
flaps_z = (flaps_cut[1] + flaps_cut[3]) / 2;           // center
flaps_face = [flaps_x - flaps_plate.x / 2, flaps_z - flaps_plate.y / 2,
              flaps_x + flaps_plate.x / 2, flaps_z + flaps_plate.y / 2];
// bottom bar under the lowest cut-out, the sheet down to its bottom
low_cuts = [ign_cut, switch_cut, primer_cut, throttle_cut, flaps_cut];
z_bb = floor((min([for (c = low_cuts) c[1]]) - 3) / round_cut) * round_cut;   // bottom bar's top
sheet_bottom = z_bb - ext;
// parking brake on the bottom bar under the yoke column, its handle through the sheet
park_x = col_x;
park_z = z_bb;                               // body bottom
park_cut = [park_x - park_hole_d / 2, park_z + park_size.z / 2 - park_hole_d / 2,
            park_x + park_hole_d / 2, park_z + park_size.z / 2 + park_hole_d / 2];
// waist: two bars, one on the other, under the desk top, the lower and upper sheets meet between them
z_waist = -2 * ext;
// yoke column hole; the left top bar just over the shaft
col_cut = [col_x - yoke_hole_d / 2, col_z - yoke_hole_d / 2, col_x + yoke_hole_d / 2, col_z + yoke_hole_d / 2];
z_tl = ceil(max(col_z + yoke_shaft_d / 2 + 3, col_cut[3] + sheet_web - ext) / round_cut) * round_cut;   // left top bar's bottom
sheet_h = z_tl + ext;                        // left sheet's top above the desk (stage 1)
// instruments (stage 2), centres [x, z]
inst_c = concat([for (z = n172_six_dz, i = [-1 : 1]) [six_x + i * six_step, col_z + z]],
                [for (z = n172_six_dz) [nav_x, col_z + z]],
                [[six_x + six_step + n172_rpm[0], col_z + n172_rpm[1]]]);
inst_names = ["TC", "HI", "VSI", "ASI", "AI", "ALT", "NAV 1", "NAV 2", "RPM"];   // the lower row first
inst_box = [min([for (c = inst_c) c.x]) - inst_cut_d / 2, min([for (c = inst_c) c.y]) - inst_cut_d / 2,
            max([for (c = inst_c) c.x]) + inst_cut_d / 2, max([for (c = inst_c) c.y]) + inst_cut_d / 2];
// right top bar: over the instruments' top row (stage 2), at the glareshield
z_tr = ceil(max(inst_box[3] + sheet_web, col_z + n172_glare_dz - ext) / round_cut) * round_cut;
sheet_h_r = z_tr + ext;                      // right part's top (and the whole panel's in stage 2)
// radio: the DIY stack hangs from the 172N's stack top, the Saitek panel at its bottom
stack_top = min(col_z + n172_stack_dz, z_tr - sheet_web);
radio_z0 = stack_top - stack_h;
radio_cut = [radio_x - radio_body.x / 2 - 0.5, radio_z0,
             radio_x + radio_body.x / 2 + 0.5, radio_z0 + radio_body.y + 1];
radio_front_z0 = radio_cut[1] + 0.5 - (radio_front.y - radio_body.y) / 2;
stack_cut = [radio_x - stack_w / 2 + stack_flange - stack_cut_clear, radio_z0,
             radio_x + stack_w / 2 - stack_flange + stack_cut_clear, stack_top];
stack_face = [radio_x - stack_w / 2, radio_z0, radio_x + stack_w / 2, stack_top];

// frame width: the right end upright right of the radios and the flaps
frame_w = ceil((max(radio_cut[2], stack_face[2], flaps_face[2], throttle_face[2]) + sheet_edge) / round_d) * round_d;

cuts = [ign_cut, switch_cut, throttle_cut, radio_cut, primer_cut, flaps_cut, park_cut];   // [x0, z0, x1, z1] on the sheet (col_cut is round)

// Front part: uprights [left side x, z0, z1]
uprights = [[0, z_bb, z_tr],                 // left end, as high as the right part: it carries a brace (and the stage 2 top bar)
            [x_a, z_bb, z_waist],            // split, to the waist bars
            [x_r, 0, z_tr],                  // step, on the waist bars
            [frame_w - ext, z_bb, z_tr]];    // right end
upright_xs = [for (u = uprights) u[0]];
// bars along x: [x0, x1, z0] (y 0 .. ext)
front_bars = [[0, frame_w, z_bb - ext],                // bottom bar
              [x_a, frame_w - ext, z_waist],          // waist bars, on the split upright
              [x_a, frame_w - ext, z_waist + ext],
              [ext, x_r, z_tl],                       // left top bar, between the left end and the step upright
              [x_r, frame_w, z_tr]];                  // right top bar
// throttle bar: behind the split and right end uprights (y ext .. 2 ext), the throttle box and flaps on it
throttle_bar = [x_a, frame_w - ext, throttle_z - ext];
// Sheets [x0, z0, x1, z1]: the left one is L shaped (lower part to the
// split, upper part to the step), the lower right one to the waist bars'
// joint, the upper right one from it
sheet_left = [[0, sheet_bottom, x_a, -ext], [0, -ext, x_r, sheet_h]];
sheet_lower_right = [x_a, sheet_bottom, frame_w, -ext];
sheet_upper_right = [x_r, -ext, frame_w, sheet_h_r];

// desk part: the front rail behind the front part, cut at the yoke, at
// least ear_len past the sheet at both ends
crossbar_xs = [0, x_r, frame_w - ext];   // left sides: under the uprights on the desk
brace_xs = [0, x_r, frame_w - ext];
brace_room = 30;             // upright above the brace, for the connector's leg
// Brace: its inner edge (towards the corner) from the upright's back at
// brace_top down to the crossbar top, brace_rise lower and further back;
// a 45 degree connector in the obtuse angle at each end, so at the top the
// upright needs brace_room above it
brace_rise = brace_len / sqrt(2);
brace_top = ext + brace_rise;
brace_foot_y = ext + brace_rise + ext * sqrt(2);   // the brace's back end on the crossbar
yoke_front_y = frame_overhang;               // housing front at the desk edge
ffb_front_y = yoke_front_y + ffb_back;       // the force feedback yoke's housing front (stage 2)
crossbar_len = ceil((ffb_front_y + yoke_housing.y - ext) / round_d) * round_d;
rear_y = 2 * ext + crossbar_len;
frame_d = rear_y + ext;
rails = [[x_bay0 - ceil((x_bay0 + ear_len) / round_d) * round_d, x_bay0],
         [x_bay1, x_bay1 + ceil((frame_w - x_bay1 + ear_len) / round_d) * round_d]];
clamp_xs = [rails[0][0] + ear_len / 2, rails[1][1] - ear_len / 2];   // desk clamps, on the rail ends

// --- Apron, under the lower panel ---
legs = [col_x - knee_w / 2, col_x + knee_w / 2];         // open for the legs (under knee_z)
// Apron: two hangers under the bottom bar (corner brackets), the right one
// under the end upright, and the lower bar between their ends
hanger_len = ceil((pedestal_size.z + under_play + under_flange + screw_edge) / round_d) * round_d;
apron_bar_z = sheet_bottom - hanger_len;                 // top of the lower bar
apron_bar_len = floor((frame_w - 2 * ext - legs[1]) / round_cut) * round_cut;
hangers = [frame_w - 2 * ext - apron_bar_len, frame_w - ext];   // left sides
apron_bar = [hangers[0] + ext, hangers[1]];
apron = [hangers[0], apron_bar_z - ext, frame_w, sheet_bottom];   // the apron sheet [x0, z0, x1, z1]
// pedestal cut-out and face, [x0, z0, x1, z1] on the apron sheet: under
// the throttle box, as far left as the leg room allows
pedestal_x = max(x_rc, apron_bar[0] + pedestal_size.x / 2 + under_flange);
function under_cut(x, size) = [x - size.x / 2 - under_play, apron_bar_z,
                               x + size.x / 2 + under_play, apron_bar_z + size.z + under_play];
function under_face(x, size) = [x - size.x / 2 - under_flange, apron_bar_z,
                                x + size.x / 2 + under_flange, apron_bar_z + size.z + under_flange];
pedestal_cut = under_cut(pedestal_x, pedestal_size);
pedestal_face = under_face(pedestal_x, pedestal_size);
under_y0 = -sheet_t - under_face_t;                     // face front

// --- Sheet screws: M5 through the sheet into T-nuts in the front slots ---
function spread(a, b, step) = let(n = max(1, ceil((b - a) / step))) [for (i = [0 : n]) a + (b - a) * i / n];
function clear_of(p, rects, m) =
   len([for (r = rects) if (p.x > r[0] - m && p.x < r[2] + m && p.y > r[1] - m && p.y < r[3] + m) 1]) == 0;
avoid = concat(cuts, [col_cut, throttle_face, primer_face_r, flaps_face, stack_face]);
sheets = concat(sheet_left, [sheet_lower_right, sheet_upper_right]);
function on_sheet(p) = len([for (r = sheets) if (p.x >= r[0] + 5 && p.x <= r[2] - 5 && p.y >= r[1] + 5 && p.y <= r[3] - 5) 1]) > 0;
sheet_screws = [for (p = concat(
      [for (u = uprights, z = spread(u[1] + 20, min(u[2], u[0] < x_r ? z_tl : u[2]) - 20, screw_step_upright)) [u[0] + ext / 2, z]],
      [for (b = front_bars, x = spread(b[0] + ext / 2, b[1] - ext / 2, screw_step)) [x, b[2] + ext / 2]]))
   if (clear_of(p, avoid, screw_edge) && on_sheet(p)) p];
// apron sheet: its hangers and the lower bar, [x, z]
apron_screws = [for (p = concat(
      [for (h = hangers, z = spread(apron[1] + ext / 2, sheet_bottom - ext / 2, screw_step_upright)) [h + ext / 2, z]],
      [for (x = spread(apron_bar[0] + ext / 2, apron_bar[1] - ext / 2, screw_step)) [x, apron[1] + ext / 2]]))
   if (clear_of(p, [pedestal_cut, pedestal_face], screw_edge)) p];
// M5 through the throttle box floor into T-nuts in the throttle bar's top slot, [x, y]
throttle_bolts = [for (x = throttle_bolt_xs) [throttle_x0 + x, throttle_y0 + throttle_bolt_y]];
// M5 through the pedestal floor into T-nuts in the lower bar's top slot, [x, y]
pedestal_bolts = [for (s = [-1, 1]) [pedestal_x + s * pedestal_size.x / 4, under_y0 + under_bolt_y]];

// --- Checks ---
function inside(r, b, m) = r[0] >= b[0] + m && r[1] >= b[1] + m && r[2] <= b[2] - m && r[3] <= b[3] - m;
function apart(a, b, m) = a[2] + m <= b[0] || b[2] + m <= a[0] || a[3] + m <= b[1] || b[3] + m <= a[1];
function circ(c, d) = [c.x - d / 2, c.y - d / 2, c.x + d / 2, c.y + d / 2];
assert(x_sw0 >= ext + 3, "No room for the left upright next to the cut-outs");
// cut-outs on their sheets
for (c = [ign_cut, switch_cut, primer_cut, park_cut])
   assert(c[0] >= sheet_edge && c[2] <= x_a - sheet_edge, "A lower left cut-out is too close to the left sheet's edges");
assert(inside(col_cut, sheet_left[1], 0) && col_cut[0] >= sheet_edge && col_cut[3] + sheet_web <= sheet_h,
       "Yoke column hole off the left sheet");
for (c = [throttle_cut, flaps_cut])
   assert(c[0] - x_a >= sheet_edge && c[2] <= frame_w - sheet_edge && c[3] <= -ext - sheet_web,
          "Throttle or flaps cut-out off the lower right sheet");
assert(throttle_face[3] <= z_waist - 3 && flaps_face[3] <= z_waist - 3, "Throttle or flaps face runs into the waist bars");
assert(compass_x - compass_foot.x / 2 >= x_r && compass_x + compass_foot.x / 2 <= frame_w, "Compass stand off the right top bar");
assert(radio_cut[0] - x_r >= sheet_edge && stack_cut[0] - x_r >= sheet_edge, "Radio too close to the step upright");
assert(frame_w - max(radio_cut[2], stack_cut[2], flaps_cut[2]) >= sheet_edge, "Right part's cut-outs too close to the sheet edge");
assert(radio_cut[1] >= -ext + sheet_edge, "Radio too close to the upper right sheet's bottom");
assert(radio_front_z0 + radio_front.y <= z_tr - sheet_web && stack_cut[3] <= z_tr - sheet_web + 0.01,
       "Radio or DIY stack too high for the upper right sheet");
assert(stack_face[0] >= x_r + screw_edge && stack_face[2] <= frame_w - screw_edge, "DIY radio stack runs off the upper right sheet");
assert(radio_body.x <= radio_front.x - 6 && radio_body.y <= radio_front.y - 6, "Radio front does not cover its cut-out");
assert(switch_cut[0] - ign_cut[2] >= sheet_web - 0.01, "Ignition and switch panel holes too close");
assert(x_a - switch_cut[2] >= sheet_edge, "Switch panel too close to the split upright");
assert(primer_face_r[3] + 1 <= ign_z, "Primer face runs into the ignition face");
assert(primer_face_r[2] + 1 <= x_s0 - switch_flange, "Primer face runs into the switch panel's face");
assert(primer_x - primer_back / 2 >= ext + 3, "Primer runs into the left upright behind the sheet");
assert(park_z + park_size.z <= switch_cut[1] - 3 && park_cut[1] >= z_bb + 3, "Parking brake does not fit under the switch panel");
assert(min([for (c = low_cuts) c[1]]) - sheet_bottom >= sheet_web, "Lower panel cut-outs too close to the sheet's bottom");
// the backs behind the sheet: under the desk, under the yoke's clamps
assert(switch_cut[3] <= back_top_max([x_s0, x_sw1 - switch_flange]) + switch_cut_clear,
       "Switch panel's back runs into the desk or the yoke's clamps");
assert(ign_cut[3] <= back_top_max([x_sw0 + switch_flange, x_ign1]) + switch_cut_clear, "Ignition's back runs into the desk or the yoke's clamps");
assert(throttle_cut[3] <= back_top_max([throttle_x0, throttle_x0 + throttle_size.x]) + throttle_play, "Throttle box runs into the desk");
assert(flaps_cut[3] <= back_top_max([flaps_cut[0], flaps_cut[2]]), "Flaps body runs into the desk");
assert(z_waist + 2 * ext <= desk_low + desk.z, "Waist bars above the desk top");
for (c = yoke_clamp_x)
   assert(c[1] + 3 <= x_a && c[0] >= ext + 3, "The yoke's clamps run into the split or the left upright");
assert(yoke_front_y - yoke_reach + yoke_wheel_t <= -sheet_t - 15, "Yoke wheel too close to the sheet with the shaft in");
assert(col_z + yoke_shaft_d / 2 <= z_tl - 3, "Yoke shaft runs into the left top bar");
assert(yoke_hole_d >= yoke_shaft_d + 4, "Yoke column hole too tight");
assert(x_bay0 >= ext + 3 && x_bay1 + 3 <= x_r, "Yoke runs into the left or the step upright's crossbar");
// instruments (stage 2)
for (i = [0 : len(inst_c) - 1])
   let(r = circ(inst_c[i], inst_cut_d)) {
      assert(r[0] >= sheet_edge && r[2] <= x_r - sheet_edge && r[3] <= z_tr - sheet_web + 0.01 && r[1] >= -ext + sheet_edge,
             str(inst_names[i], " (stage 2) off the left sheet"));
      assert(apart(r, col_cut, sheet_web), str(inst_names[i], " (stage 2) too close to the yoke column hole"));
      for (j = [0 : len(inst_c) - 1])
         assert(i == j || norm(inst_c[i] - inst_c[j]) >= max(inst_cut_d + 3, inst_body_d + 1), str(inst_names[i], " (stage 2) runs into another instrument"));
      let(b = circ(inst_c[i], inst_body_d))
         assert(!overlaps([b[0], b[2]], yoke_x) || b[1] >= ffb_h || inst_depth <= ffb_front_y - 3,
                str(inst_names[i], " (stage 2) runs into the force feedback yoke's housing"));
      assert(r[2] <= x_a || r[1] >= z_waist + 2 * ext, str(inst_names[i], " (stage 2) over the split upright"));
   }
let(i = search(["AI"], inst_names)[0], b = circ(inst_c[i], inst_body_d))
   assert(!overlaps([b[0], b[2]], yoke_x) || b[1] >= ffb_h || ai_depth <= ffb_front_y - 3,
          "AI (stage 2) runs into the force feedback yoke's housing");
for (i = [0 : 7])
   assert(inst_c[i].y - inst_cut_d / 2 >= sheet_h, str(inst_names[i], " hidden behind the stage 1 left sheet (the monitor shows it)"));
assert(sheet_h <= sheet_h_max, "Left panel too high for the monitor");
assert(sheet_h_r <= sheet_h_r_max, "Right part of the panel too high for the monitor");
assert(abs(throttle_y0 + throttle_bolt_y - ext * 3 / 2) < 0.01, "Throttle floor bolts miss the throttle bar's slot");
assert(throttle_bar[0] + ext <= throttle_x0 && flaps_cut[2] <= throttle_bar[1], "Throttle box or flaps not on the throttle bar");
assert(ext + brace_rise + ext / sqrt(2) <= rear_y, "Braces do not land on the crossbars");
assert(brace_top + brace_room <= z_tr, "Braces too long: no room for the connector on the upright");
assert(rails[1][1] - rails[0][0] <= desk.x && frame_d <= frame_overhang + desk.y, "Frame does not fit on the desk");
assert(2 * ext - frame_overhang >= 10, "Front rail barely on the desk");
// leg room: under the desk top only what stays over the knees
assert(sheet_bottom >= knee_z + 10 || legs[1] <= 0, "Lower panel runs into the knees (lower the chair, knee_z)");
assert(primer_z - primer_bracket.y / 2 >= knee_z + 10, "Primer runs into the knees");
assert(hangers[0] >= legs[1], "Apron hanger in the leg room");
assert(hangers[0] >= x_a + ext, "Apron hanger not under the throttle side");
assert(abs(under_y0 + under_bolt_y - ext / 2) < 0.01, "Pedestal floor bolts miss the lower bar slot");
assert(pedestal_face[0] >= apron_bar[0] && pedestal_face[2] <= apron_bar[1],
       "Pedestal does not fit between its hangers");
assert(pedestal_face[3] <= sheet_bottom - screw_edge, "Pedestal face runs off its apron sheet");
assert(pedestal_x - pedestal_size.x / 2 <= throttle_x0 + throttle_size.x, "Pedestal not under the throttle box");
assert(clamp_open >= ext + desk.z + 1, "Desk clamps do not open far enough for the rail and the desk");
assert(clamp_reach >= clamp_y + 2, "Desk clamps do not reach over the rail to the desk");
assert(clamp_y - clamp_pad_d / 2 >= frame_overhang - 3, "Desk clamp jaw not under the desk");
assert(clamp_w + 10 <= ear_len, "Desk clamps do not fit on the rail ends beside the sheet");
assert(park_size.y <= desk.y / 3, "Parking brake body too deep under the desk");
assert(park_bolt_dx * 2 + m5_head_d <= park_size.x + 10, "Parking brake bolts do not fit");
