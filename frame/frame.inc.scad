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
// The layout follows the X-Plane 172N panel (the 172n_* values), so the
// panel can grow into a full 172N panel later:
//
//   left sheet                              right sheet (higher)
//   (six-pack, stage 2, over the monitor)   radio stack
//   yoke column
//   ignition + primer, switches             throttle box, flaps
//
// Stage 1 (now): the panel is only as high as the parts on it, the
// monitor behind it shows the six-pack above the left sheet. Stage 2
// (physical instruments): the left and the split upright are swapped for longer ones,
// a full height left sheet gets the six-pack cut-outs (six_*, reserved,
// outlined in the "sheet" view) and the monitor goes up over the
// glareshield; nothing else moves. The left top bar stays as a mid bar
// under the six-pack.
//
// - Front part, vertical, in front of the desk edge: a rectangle (top bar,
//   bottom bar, an upright at each end) with two more uprights, at the
//   sheet split and right of the radios. The bottom bar lies just
//   under the desk top (its top at desk height), its back against the desk
//   edge (a felt pad). Under the throttle a smaller rectangle hangs
//   from the bottom bar: the apron, two hangers and a lower bar, for the
//   trim wheel pedestal. The parking brake hangs under the
//   bottom bar, directly below the yoke column.
// - Desk part, flat on the desk behind it: a ladder (front rail, rear rail,
//   crossbars). The front part is
//   bolted to its front rail, and a 45 degree brace from each upright down
//   to a crossbar stops it from rocking: a stock length, cut square, held
//   by a bought 45 degree connector at each end. The throttle box stands on the
//   front rail and the crossbar under its middle; the hub stands behind
//   it, bolted into that crossbar and the hub crossbar.
// - Yoke stand, on two crossbars of the desk part: four posts, two side
//   bars along y and two cross bars on them. The yoke housing stands on the
//   cross bars right behind the front part, over the switch panel's back,
//   and its shaft comes through a round hole in the sheet like the 172N's
//   column. Its desk clamps are taken off and their screws hold it down
//   through holes drilled in the cross bars.
//
// The front rail runs past the sheet at both ends (ear_len): there a
// bought screw clamp (rubber jaws) on each end clamps the rail onto the
// desk. All metal, printed parts creep under constant load.
// knee_w around the yoke column stays open for the legs; only the bottom bar and
// the thin parking brake are there, just under the desk top.
//
// Lengths are rounded to stock lengths (multiples of round_d), except the
// apron's lower bar and the stand's posts. The height is the lowest that
// the parts on the sheet allow, with stock length uprights.

// --- Extrusion: 2020 only, 6 mm slot, M5 T-nuts everywhere ---
ext = 20;
round_d = 50;                // the other bars rounded to this (stock lengths)
round_cut = 10;              // the apron's lower bar and the yoke stand's posts: no stock length fits
brace_len = 200;             // a stock length, cut square
slot_w = 6;
m5_d = 5.3;                  // M5 clearance, sheet and printed parts
m5_head_d = 9.5;             // button head

// --- Sheet ---
sheet_t = 3;                 // ACM, the same as the printed panel_t
sheet_h_max = 260;           // stage 1: left panel height above the desk at most; the monitor shows the
                             // six-pack over it (sheet_h is computed from the parts on it)
sheet_h_r_max = 330;         // the right part's (sheet_h_r) at most: it may cover the monitor's bottom right
                             // corner, where X-Plane draws its own radios; check the six-pack stays visible
sheet_edge = 25;             // sheet edge to a cut-out, at least
sheet_web = 20;              // sheet between two cut-outs, at least
screw_edge = 6;              // screw hole center to a cut-out, at least
screw_step = 150;            // screws along a bar, at most this far apart
screw_step_upright = 100;

// --- Desk, MEASURE ---
desk = [1200, 700, 28];      // width, depth, thickness
desk_skirt = 0;              // frame or drawer under the top at its front edge, height below the top
knee_w = 460;                // kept open under the desk for the legs, centered on the yoke column
edge_play = 2;               // front part back to the desk edge: a felt pad, the front part stops the frame against the edge
frame_overhang = ext + edge_play;     // frame front in front of the desk edge

// --- Saitek Pro Flight Yoke, MEASURE ---
// Spec sheet: 310 mm wide (the wheel), 380-464 mm deep with the shaft in /
// out. The housing is about 100 mm high and about as wide as the radio
// panel that sat on it (from memory).
yoke_housing = [283, 280, 100];   // housing body: width, depth, height
ffb_h = 130;                 // the future force feedback yoke's height, the stand and the six-pack leave room for it
yoke_shaft_z = 65;           // shaft center above the housing's bottom
yoke_shaft_d = 22;           // the shaft through the sheet (the FFB yoke's may be thicker: the hole)
yoke_hole_d = 28;            // its round hole in the sheet
yoke_screw_y = [45, 230];    // its desk clamps' screw threads in the housing bottom, from its front
                             // (the cross bars of the stand go under them)
yoke_reach = 100;            // housing front to the wheel's front, shaft in (spec: 380 deep) (view only)
yoke_wheel_t = 45;           // the wheel with its grips, front to back
yoke_wheel_w = 310;          // view only

// --- Saitek Pro Flight Radio Panel, MEASURE ---
// Spec sheet: 283 x 84 mm front, 55 mm deep (106 mm with the bracket).
// Logitech publishes the cut-out ("Construction dimensions for Flight
// Panels"); radio_body is a guess until then.
radio_front = [283, 84];
radio_front_t = 3;
radio_body = [275, 76];      // what goes through the sheet
radio_depth = 55;            // behind the sheet

// --- DIY radio stack, from radio/ ---
// Reserved: the frame still has the Saitek radio panel, but the right part
// is already as high as the DIY stack needs, centered over the throttle
// box like the Saitek panel, from the same height. Its units are stack_w
// wide with a flange on the left and right ends only, stacked without gaps
// in one cut-out as high as the stack. When it replaces the Saitek panel,
// the right sheet is cut again (the Saitek's cut-out is wider than the
// stack's faces).
stack_w = 224;               // unit_w
stack_flange = 9;            // flange_w
stack_cut_clear = 1;         // sheet_cut_clear
// unit heights, top to bottom: KMA 26 audio panel (ap_h), KX155 (unit_h)
// twice, KT 76C (xp_h)
stack_units_h = [33, 50.8, 50.8, 41.9];
stack_h = stack_units_h[0] + stack_units_h[1] + stack_units_h[2] + stack_units_h[3];

// --- Throttle box, from throttle/throttle_box.scad ---
// The box (full_width x (depth + 2 * roundness) x height, open top) goes
// through its cut-out and stands on the front rail and the middle
// crossbar, its front overhanging the front part. Its front wall (face_t)
// is the face; the flange (flange_w, on the top and the two sides, none at
// the bottom) is screwed onto the sheet with M3 (drill through the box's
// holes), and two M5 bolts through its floor go into the front rail's top
// slot.
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
// the sheet, its body goes through the cut-out and rests on the front rail.
flaps_plate = [50, 63];      // front plate, width x height
flaps_body = [44, 57, 64];   // through the sheet (a guess: 3 mm smaller than the plate all round), depth behind it
flaps_play = 0.5;            // body to its cut-out
flaps_gap = 70;              // throttle box face to the flaps plate (172N)

// --- Hub, from hub/hub.scad ---
// The box with the MobiFlight Mega and the RJ45 ports stands on the desk
// part behind the throttle box, across the throttle's crossbar and the hub
// crossbar right of it: the two ears on its left wall are bolted into
// the first one's top slot, the ears on its front and back walls into the
// second one's (M5, T-nuts). Its front ports (1-3) face the pilot, port 3
// behind the throttle box (hub_cable_room for its plug), its right ports
// (4-6) face right and its USB jack left, towards the yoke stand.
hub_size = [172, 135, 53];   // outer, with the lid
hub_ear_out = 12;            // ear.y: how far the ears stand out, their holes in the middle
hub_ear_slot_dx = 156.5;     // ear_slot_dx: the left ears' holes to the front and back ears'
hub_ear_left_ys = [9, 126];  // the left ears' holes from the box's front (round_r + ear.x / 2 from its ends)
hub_jacks = [29.5, 67.5, 105.5];   // the 3 jacks' middles along the front and the right wall (view only)
hub_usb_y = 88;              // its USB jack from the box's front (wall + row_y + mega_usb)
hub_cable_room = 50;         // throttle box back to the hub's front: port 3's plug and cable

// --- Switch panel, from ignition/ and switchpanel/ ---
// Two panels side by side, each with its own hole and a face flange
// (flange_w) all round, screwed onto the sheet with M3 (drill through the
// panel's holes): the ignition (back 77 wide) on the left, switch_ign_rise
// higher than the switches (back 196.6), with the primer under it. Both
// backs are panel_h high; sheet_web of sheet between their holes.
switch_ign_w = 77;
switch_back = [196.6, 80];   // the switches' back; panel_h
switch_ign_rise = 49;        // as little as the primer under the ignition allows
switch_flange = 10;          // flange_w
switch_cut_clear = 1;        // sheet_cut_clear
switch_backs_gap = sheet_web + 2 * switch_cut_clear;   // ignition back to the switches' back
switch_panel = [switch_ign_w + switch_backs_gap + switch_back.x, switch_back.y] + 2 * [switch_flange, switch_flange];   // both faces
switch_depth = 40;           // switches and the mux carrier behind the sheet's back (+ 5 mm), MEASURE
switch_back_y = 5 + switch_depth;   // the switch panel's back ends here; the yoke stand stays behind it
switch_z = ext + 5;          // the switches' face bottom above the desk; the ignition's is switch_ign_rise higher

// Primer, from switchpanel/primer.scad: its own small panel below the
// ignition key (in the middle of the ignition panel), like in the X-Plane
// 172N, as low as the switch panel (primer_z0). The square back
// (primer_back, the tube for the knob) goes through its own cut-out, the
// face flange (all round) is screwed onto the sheet; the bracket with the
// pot behind it is wider than the cut-out and goes on from behind.
primer_back = 27;            // back_w
primer_flange = 10;          // flange_w
primer_face = primer_back + 2 * primer_flange;
primer_depth = 193;          // behind the panel with the knob in (view only)
primer_tube = 50.5;          // tube_len (view only)
primer_bracket = [38.1, 26, 95.2];   // beside the rod towards the pilot's right, height, length (view only)
primer_z0 = switch_z;        // face bottom above the desk: the back clear of the front rail behind the sheet

// --- Under-desk controls ---
// Pedestal (trim wheel and trim indicator), a future component, same rule
// as the throttle box: the
// body (width x depth x height) goes through its cut-out in the apron sheet
// and stands on the lower bar, the face flange (top and sides) is screwed
// onto the sheet with M3, and two M5 bolts through the floor go into the
// lower bar's top slot. The body must be below the desk.
under_face_t = 3;
under_flange = 10;
under_play = 1;              // body to its cut-out
under_bolt_y = 16;           // floor bolts from the face front, over the lower bar's slot
pedestal_size = [75, 120, 150];   // 75 x 150 front (MEASURE), the depth a guess
desk_clear = 3;              // a body to the desk underside, at least
// Parking brake: no face. A thin body (width x depth x height) under the
// desk top, behind the bottom bar, hangs from the bottom bar's bottom slot (two
// M5). Its T-handle is in front of the bar: released, it is almost flush
// and lies sideways; set, it is pulled out by park_pull and turned to point
// down.
park_size = [40, 90, 22];
park_bolt_dx = 12;           // bolts from its center, into the bottom bar's bottom slot
park_pull = 50;              // handle travel
park_handle = 60;            // T-handle length (view only)

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
// (0.59 mm per pixel of a 1440 pixel wide screenshot), x from the switch
// panel's left face edge, z above the desk with the switch row where it is
// here. Some are moved a little so the parts fit (see each).
frame_w = 1000;              // the 172N panel's width
n172_col_dx = 235;           // yoke column (172N: 241)
n172_col_z = 184;            // yoke column (shaft) height, the stand is built for it
n172_six_dx = -15;           // six-pack's middle column from the yoke column (172N: -9; left for the sheet split)
n172_six_dz = [92, 180];     // six-pack's rows above the yoke column
n172_throttle_dx = 485;      // throttle rod, the throttle box's middle (172N: 472; right for the sheet split)
n172_radio_dx = 105;         // radio stack's middle right of the throttle (172N: 106)
n172_glare_z = 425;          // glareshield (the panel top) above the desk, stage 2
// Six-pack (stage 2, reserved): 3 1/8" instruments on 3.5" centres
six_step = 89;
six_cut_d = 81;              // their hole
inst_body_d = 50;            // a DIY instrument's body behind the sheet (round display or gauge), a guess
inst_depth = 45;             // and its depth behind the sheet's back, a guess

// --- Layout ---
x_sw0 = sheet_edge;                          // switch panel, left face edge
x_sw1 = x_sw0 + switch_panel.x;
col_x = x_sw0 + n172_col_dx;                 // yoke column
x_rc = x_sw0 + n172_throttle_dx;             // the throttle box's middle
radio_x = x_rc + n172_radio_dx;              // the radio's and the DIY stack's middle
throttle_face_w = throttle_size.x + 2 * throttle_flange;

// front part
throttle_x0 = x_rc - throttle_size.x / 2;
throttle_y0 = -sheet_t - throttle_face_t;    // face front, the face on the sheet

throttle_cut = [throttle_x0 - throttle_play, ext,
                throttle_x0 + throttle_size.x + throttle_play, ext + throttle_size.z + throttle_play];
throttle_face = [throttle_x0 - throttle_flange, ext,
                 throttle_x0 + throttle_size.x + throttle_flange, ext + throttle_size.z + throttle_flange];
// flaps: right of the throttle box, its body on the front rail
flaps_x = x_rc + throttle_face_w / 2 + flaps_gap + flaps_plate.x / 2;
flaps_cut = [flaps_x - flaps_body.x / 2 - flaps_play, ext,
             flaps_x + flaps_body.x / 2 + flaps_play, ext + flaps_body.y + 2 * flaps_play];
flaps_z = (flaps_cut[1] + flaps_cut[3]) / 2;           // center
flaps_face = [flaps_x - flaps_plate.x / 2, flaps_z - flaps_plate.y / 2,
              flaps_x + flaps_plate.x / 2, flaps_z + flaps_plate.y / 2];
radio_z0 = max(throttle_cut[3], flaps_cut[3]) + sheet_web;
radio_cut = [radio_x - radio_body.x / 2 - 0.5, radio_z0,
             radio_x + radio_body.x / 2 + 0.5, radio_z0 + radio_body.y + 1];
radio_front_z0 = radio_cut[1] + 0.5 - (radio_front.y - radio_body.y) / 2;
// the DIY stack (reserved, not cut): its cut-out and its faces
stack_cut = [radio_x - stack_w / 2 + stack_flange - stack_cut_clear, radio_z0,
             radio_x + stack_w / 2 - stack_flange + stack_cut_clear, radio_z0 + stack_h];
stack_face = [radio_x - stack_w / 2, radio_z0, radio_x + stack_w / 2, radio_z0 + stack_h];
// primer: under the ignition key, at the bottom; the ignition above it
primer_x = x_sw0 + switch_flange + switch_ign_w / 2;    // rod axis
primer_z = primer_z0 + primer_flange + primer_back / 2;
primer_cut = [primer_x - primer_back / 2 - switch_cut_clear, primer_z - primer_back / 2 - switch_cut_clear,
              primer_x + primer_back / 2 + switch_cut_clear, primer_z + primer_back / 2 + switch_cut_clear];
primer_face_r = [primer_x - primer_face / 2, primer_z - primer_face / 2,
                 primer_x + primer_face / 2, primer_z + primer_face / 2];
ign_z = switch_z + switch_ign_rise;          // the ignition's face bottom
x_ign1 = x_sw0 + switch_flange + switch_ign_w;   // the ignition back's right end
x_s0 = x_ign1 + switch_backs_gap;                // the switches' back's left end
ign_cut = [x_sw0 + switch_flange - switch_cut_clear, ign_z + switch_flange - switch_cut_clear,
           x_ign1 + switch_cut_clear, ign_z + switch_flange + switch_back.y + switch_cut_clear];
switch_cut = [x_s0 - switch_cut_clear, switch_z + switch_flange - switch_cut_clear,
              x_sw1 - switch_flange + switch_cut_clear, switch_z + switch_flange + switch_back.y + switch_cut_clear];
cuts = [ign_cut, switch_cut, throttle_cut, radio_cut, primer_cut, flaps_cut];   // [x0, z0, x1, z1] on the sheet

// Six-pack (stage 2, reserved): centres [x, z], row by row
six_x = col_x + n172_six_dx;
six_c = [for (z = n172_six_dz, i = [-1 : 1]) [six_x + i * six_step, n172_col_z + z]];
six_box = [six_x - six_step - six_cut_d / 2, n172_col_z + n172_six_dz[0] - six_cut_d / 2,
           six_x + six_step + six_cut_d / 2, n172_col_z + n172_six_dz[1] + six_cut_d / 2];

// The sheet split: as far right as the throttle box allows (the six-pack
// needs the room on the left sheet in stage 2)
sheet_split = throttle_cut[0] - sheet_edge;  // left sheet to the right sheet, x
x_um = max(radio_cut[2], stack_cut[2], flaps_cut[2]) + sheet_edge;   // the upright right of the radios
upright_xs = [0, sheet_split, x_um, frame_w - ext];   // left sides

// Height: sheet_web over the highest cut-out (or the radio front), then the
// top bar; the uprights (on the bottom bar, under the top bar) a stock
// length. The front part is stepped: the right part (the uprights at the
// split, right of the radios and at the end) is as high as the DIY
// stack needs, the left part as low as its parts allow (the yoke hole is
// made to fit under its top bar). Its top bar ends against the side of
// the split upright, the right one sits on the right uprights. The sheet
// is cut in two at the split, so the right sheet can be cut again for the
// DIY stack on its own.
upright_len = ceil((max(ign_cut[3], switch_cut[3], primer_cut[3]) + sheet_web) / round_d) * round_d;
upright_len_r = max(upright_len,
   ceil((max(radio_front_z0 + radio_front.y, stack_cut[3]) + sheet_web) / round_d) * round_d);
upright_lens = [upright_len, upright_len_r, upright_len_r, upright_len_r];   // along upright_xs
sheet_h = upright_len + ext;                 // left panel height above the desk (the sheet also covers the bottom bar, ext more)
sheet_h_r = upright_len_r + ext;             // right panel height
// stage 2: the uprights for the full panel (left ones swapped, right ones too if they are shorter)
upright_len_full = ceil((max(six_box[3] + sheet_web, n172_glare_z) - ext) / round_d) * round_d;

// Yoke stand: posts on two crossbars, side bars along y on them, cross
// bars across on those under the housing's clamp screws. Its housing
// stands over the switch panel's back, right behind the front part.
yoke_front_y = ext + 2;                      // housing front
stand_w = floor((yoke_housing.x - ext) / round_d) * round_d;   // cross bar length, under the housing
stand_xs = [col_x - stand_w / 2, col_x + stand_w / 2 - ext];   // side bars' (and their crossbars') left sides
stand_bar_ys = [for (y = yoke_screw_y) yoke_front_y + y - ext / 2];   // cross bars' front sides
stand_y0 = stand_bar_ys[0];                  // side bars' front
stand_len = ceil((stand_bar_ys[1] + ext - stand_y0) / round_d) * round_d;   // side bars
stand_post = round((n172_col_z - yoke_shaft_z - 3 * ext) / round_cut) * round_cut;
yoke_z0 = 3 * ext + stand_post;              // housing bottom (crossbar, post, side bar, cross bar)
col_z = yoke_z0 + yoke_shaft_z;              // shaft, the column
col_cut = [col_x - yoke_hole_d / 2, col_z - yoke_hole_d / 2, col_x + yoke_hole_d / 2, col_z + yoke_hole_d / 2];
yoke_top = yoke_z0 + max(yoke_housing.z, ffb_h);

// desk part: the front rail behind the front part, at least ear_len past
// the sheet at both ends
// Hub behind the throttle box, its left ears over the throttle crossbar's slot,
// the front and back ears over the hub crossbar's slot
hub_slot_x = [x_rc, x_rc + hub_ear_slot_dx];
// the uprights', the throttle's, the hub's and the stand's (left sides)
crossbar_xs = concat(upright_xs, [x_rc - ext / 2, hub_slot_x[1] - ext / 2], stand_xs);
hub_x0 = hub_slot_x[0] + hub_ear_out / 2;                    // outer left wall
hub_y0 = throttle_y0 + throttle_size.y + hub_cable_room;     // outer front wall
// M5 through its ears into T-nuts in the crossbars' top slots, [x, y]
hub_bolts = concat([for (y = hub_ear_left_ys) [hub_slot_x[0], hub_y0 + y]],
                   [for (y = [-hub_ear_out / 2, hub_size.y + hub_ear_out / 2]) [hub_slot_x[1], hub_y0 + y]]);
crossbar_len = ceil(max(max(stand_y0 + stand_len, throttle_y0 + throttle_size.y) - ext,
                        hub_bolts[3].y + m5_head_d / 2 - 2 * ext) / round_d) * round_d;
rear_y = 2 * ext + crossbar_len;
frame_d = rear_y + ext;
rail_len = ceil((frame_w + 2 * ear_len) / round_d) * round_d;
rail = [(frame_w - rail_len) / 2, (frame_w + rail_len) / 2];   // [x0, x1]
clamp_xs = [rail[0] + ear_len / 2, rail[1] - ear_len / 2];   // desk clamps, on the rail ends
brace_room = 30;             // upright above the brace, for the connector's leg
// Brace: its inner edge (towards the corner) from the upright's back at
// brace_top down to the crossbar top, brace_rise lower and further back;
// a 45 degree connector in the obtuse angle at each end, so at the top the
// upright needs brace_room above it
brace_rise = brace_len / sqrt(2);
brace_top = ext + brace_rise;

// --- Below the desk top (z < 0) ---
legs = [col_x - knee_w / 2, col_x + knee_w / 2];       // open for the legs
under_z = desk.z + desk_skirt + desk_clear;              // desk top to the top of the bodies
// Apron: two hangers under the bottom bar (corner brackets), the right one
// under the end upright, and the lower bar between their ends
hanger_len = ceil((under_z + pedestal_size.z + under_play - ext) / round_d) * round_d;
apron_bar_z = -ext - hanger_len;                         // top of the lower bar
apron_h = -apron_bar_z + ext;                            // desk top to the apron bottom
apron_bar_len = floor((frame_w - 2 * ext - legs[1]) / round_cut) * round_cut;
hangers = [frame_w - 2 * ext - apron_bar_len, frame_w - ext];   // left sides
apron_bar = [hangers[0] + ext, hangers[1]];
apron = [hangers[0], frame_w];                           // [x0, x1] of the apron sheet, z -apron_h .. -ext
park_x = col_x;
park_z = -under_z - park_size.z;                         // body bottom
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
sheet_screws = [for (p = concat(
      [for (i = [0 : 3], z = spread(20, upright_lens[i] - 20, screw_step_upright)) [upright_xs[i] + ext / 2, z]],
      [for (x = spread(ext / 2, sheet_split - ext / 2, screw_step)) [x, sheet_h - ext / 2]],
      [for (x = spread(sheet_split + ext / 2, frame_w - ext / 2, screw_step)) [x, sheet_h_r - ext / 2]],
      [for (x = spread(ext / 2, sheet_split - ext / 2, screw_step)) [x, -ext / 2]],
      [for (x = spread(sheet_split + ext / 2, frame_w - ext / 2, screw_step)) [x, -ext / 2]]))
   if (clear_of(p, avoid, screw_edge)) p];
// apron sheet: its hangers and the lower bar, [x, z]
apron_screws = [for (p = concat(
      [for (h = hangers, z = spread(-apron_h + ext / 2, -ext - ext / 2, screw_step_upright)) [h + ext / 2, z]],
      [for (x = spread(apron_bar[0] + ext / 2, apron_bar[1] - ext / 2, screw_step)) [x, -apron_h + ext / 2]]))
   if (clear_of(p, [pedestal_cut, pedestal_face], screw_edge)) p];
// M5 through the throttle box floor into T-nuts in the front rail's top slot, [x, y]
throttle_bolts = [for (x = throttle_bolt_xs) [throttle_x0 + x, throttle_y0 + throttle_bolt_y]];
// M5 through the pedestal floor into T-nuts in the lower bar's top slot, [x, y]
pedestal_bolts = [for (s = [-1, 1]) [pedestal_x + s * pedestal_size.x / 4, under_y0 + under_bolt_y]];

// --- Checks ---
assert(x_sw0 >= ext + 3, "No room for the left upright next to the cut-outs");
assert(ign_cut[0] >= sheet_edge && primer_cut[0] >= sheet_edge, "Cut-outs too close to the sheet edge");
assert(sheet_split - max(switch_cut[2], col_cut[2]) >= sheet_edge, "Left part's cut-outs too close to the sheet split");
assert(sheet_split - six_box[2] >= sheet_edge && six_box[0] >= sheet_edge,
       "Six-pack (stage 2) too close to the left sheet's edges");
assert(six_box[1] >= sheet_h + 3, "Six-pack (stage 2) runs into the left top bar (the mid bar then)");
assert(x_um - max(radio_cut[2], stack_cut[2], flaps_cut[2]) >= sheet_edge && x_um + ext <= frame_w - ext - 3,
       "No room for the upright right of the radios");
assert(switch_cut[1] >= ext, "Switch panel cut-out runs into the bottom of the sheet");
assert(throttle_x0 >= sheet_split + ext + 3 && throttle_x0 + throttle_size.x <= x_um - 3, "Throttle box runs into the uprights");
assert(throttle_y0 + throttle_size.y <= rear_y, "Throttle box does not fit on the frame");
assert(yoke_front_y + yoke_housing.y <= rear_y, "Yoke housing runs into the rear rail");
assert(radio_body.x <= radio_front.x - 6 && radio_body.y <= radio_front.y - 6,
       "Radio front does not cover its cut-out");
assert(radio_front_z0 >= throttle_face[3] + 2, "Radio front runs into the throttle box face");
assert(radio_front_z0 >= flaps_face[3] + 2, "Radio front runs into the flaps plate");
assert(flaps_body.x <= flaps_plate.x - 4 && flaps_body.y <= flaps_plate.y - 4, "Flaps plate does not cover its cut-out");
assert(flaps_cut[0] - throttle_cut[2] >= sheet_web, "Flaps cut-out too close to the throttle box's");
assert(flaps_face[0] >= throttle_face[2] + 2, "Flaps plate runs into the throttle box face");
assert(flaps_cut[2] <= frame_w - sheet_edge && flaps_face[2] <= frame_w - screw_edge, "Flaps panel too close to the sheet edge");
assert(flaps_cut[2] <= frame_w - ext - 3, "Flaps body runs into the end upright");
assert(sheet_h <= sheet_h_max, "Panel too high for the monitor");
assert(sheet_h_r <= sheet_h_r_max, "Right part of the panel too high for the monitor");
assert(radio_front_z0 + radio_front.y <= sheet_h_r - ext - sheet_web, "Radio panel too high for the sheet");
assert(stack_cut[3] <= sheet_h_r - ext - sheet_web, "DIY radio stack too high for the sheet");
assert(stack_face[1] >= flaps_face[3] + 2 && stack_face[1] >= throttle_face[3] + 2,
       "DIY radio stack runs into the throttle box or flaps face");
assert(stack_face[0] >= sheet_split + screw_edge && stack_face[2] <= frame_w - screw_edge,
       "DIY radio stack runs off the right sheet");
assert(min(throttle_cut[0], radio_cut[0], stack_cut[0]) - sheet_split >= sheet_edge,
       "Right part's cut-outs too close to the sheet split");
assert(frame_w - max(radio_cut[2], stack_cut[2], flaps_cut[2]) >= sheet_edge,
       "Right part's cut-outs too close to the sheet edge");
assert(col_cut[3] + sheet_web <= sheet_h, "Yoke column hole too close to the sheet top");
assert(col_z + yoke_shaft_d / 2 <= sheet_h - ext - 3, "Yoke shaft runs into the left top bar");
assert(yoke_hole_d >= yoke_shaft_d + 4, "Yoke column hole too tight");
assert(abs(col_z - n172_col_z) <= 10, "Yoke column far from the 172N's height");
assert(col_cut[1] - switch_cut[3] >= sheet_web || col_cut[1] >= switch_z + switch_panel.y + 3,
       "Yoke column hole runs into the switch panel face");
assert(yoke_z0 >= switch_cut[3] + 2, "Yoke housing runs into the switch panel's back");
assert(stand_y0 >= switch_back_y + 3, "Yoke stand runs into the switch panel's back");
assert(yoke_front_y >= ext + 2, "Yoke housing runs into the front part");
assert(col_x - yoke_housing.x / 2 >= primer_x + primer_bracket.x + 3 || yoke_z0 >= primer_z + primer_bracket.y / 2 + 3,
       "Yoke housing runs into the primer");
assert(stand_xs[0] >= primer_x + primer_bracket.x + 3, "Yoke stand runs into the primer");
assert(stand_xs[0] >= ext + 3 && col_x + yoke_housing.x / 2 <= sheet_split - 2,
       "Yoke housing runs into the left or split upright and its brace");
assert(stand_xs[1] + ext <= sheet_split - 3, "Yoke stand runs into the split upright's crossbar");
assert(stand_w >= yoke_housing.x / 2, "Yoke stand too narrow for the housing");
assert(stand_post >= ext, "Yoke stand posts too short for corner brackets");
assert(yoke_front_y - yoke_reach + yoke_wheel_t <= -sheet_t - 15, "Yoke wheel too close to the sheet with the shaft in");
assert(yoke_top <= six_box[1] + six_cut_d / 2 - inst_body_d / 2 || yoke_front_y >= inst_depth + 3,
       "Yoke housing (FFB) in the way of the six-pack's bottom row (stage 2)");
assert(max(switch_cut[3], ign_cut[3]) <= sheet_h - ext - sheet_web, "Switch panel too high for the sheet");
assert(switch_cut[0] - ign_cut[2] >= sheet_web - 0.01, "Ignition and switch panel holes too close");
assert(primer_cut[3] <= sheet_h - ext - sheet_web, "Primer too high for the sheet");
assert(ign_cut[1] >= primer_cut[3] + sheet_web, "Primer too close under the ignition, raise switch_ign_rise");
assert(primer_face_r[3] + 1 <= ign_z, "Primer face runs into the ignition face");
assert(primer_face_r[2] + 1 <= x_s0 - switch_flange, "Primer face runs into the switch panel's face");
assert(switch_cut[0] - primer_cut[2] >= sheet_web, "Primer too close to the switch panel's cut-out");
assert(primer_cut[1] >= ext, "Primer cut-out runs into the bottom of the sheet");
assert(primer_cut[0] >= sheet_edge, "Primer cut-out too close to the sheet edge");
assert(primer_x - primer_back / 2 >= ext + 3, "Primer runs into the left upright behind the sheet");
assert(abs(throttle_y0 + throttle_bolt_y - ext * 3 / 2) < 0.01, "Throttle floor bolts miss the front rail slot");
assert(abs(hub_slot_x[0] + hub_ear_slot_dx - hub_slot_x[1]) < 0.01,
       "Hub's front and back ears miss the throttle crossbar's slot (ear_slot_dx in hub.scad)");
assert(hub_x0 - hub_ear_out >= sheet_split + ext + 40 && hub_x0 + hub_size.x + hub_ear_out <= x_um - 3,
       "Hub not between the split crossbar (room for its USB plug) and the upright right of the radios");
assert(hub_bolts[3].y + m5_head_d / 2 <= rear_y, "Hub's back ear is off the crossbar");
assert(hub_x0 - 40 >= col_x + yoke_housing.x / 2, "Hub's USB plug runs into the yoke");
assert(ext + brace_rise + ext / sqrt(2) <= rear_y, "Braces do not land on the crossbars");
assert(brace_top + brace_room <= sheet_h - ext, "Braces too long: no room for the connector on the upright");
assert(brace_top + ext / sqrt(2) <= sheet_h, "Braces stick out over the top bar");
assert(rail_len <= desk.x && frame_d <= frame_overhang + desk.y, "Frame does not fit on the desk");
assert(2 * ext - frame_overhang >= 10, "Front rail barely on the desk");
assert(hangers[0] >= legs[1], "Apron hanger in the leg room");
assert(pedestal_x - pedestal_size.x / 2 <= throttle_x0 + throttle_size.x, "Pedestal not under the throttle box");
assert(abs(under_y0 + under_bolt_y - ext / 2) < 0.01, "Pedestal floor bolts miss the lower bar slot");
assert(pedestal_face[0] >= apron_bar[0] && pedestal_face[2] <= apron_bar[1],
       "Pedestal does not fit between its hangers");
assert(pedestal_cut[3] <= -under_z + under_play, "Pedestal runs into the desk");
assert(pedestal_face[3] <= -ext - screw_edge, "Pedestal face runs off its apron sheet");
assert(clamp_open >= ext + desk.z + 1, "Desk clamps do not open far enough for the rail and the desk");
assert(clamp_reach >= clamp_y + 2, "Desk clamps do not reach over the rail to the desk");
assert(clamp_y - clamp_pad_d / 2 >= frame_overhang - 3, "Desk clamp jaw not under the desk");
assert(clamp_w + 10 <= ear_len, "Desk clamps do not fit on the rail ends beside the sheet");
assert(park_size.y <= desk.y / 3, "Parking brake body too deep under the desk");
assert(abs(park_x - col_x) < 0.01 && park_bolt_dx * 2 + m5_head_d <= park_size.x + 10,
       "Parking brake bolts do not fit");
