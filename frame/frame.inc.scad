// Cockpit frame basics, shared by the files in frame/
//
// The frame is two parts of 2020 extrusion, each built on its own and then
// bolted together. 3 mm aluminium composite (ACM) sheet covers the front;
// every cockpit component brings its own front face, a hole is cut into
// the sheet for it and its face is screwed onto the sheet. Heavy or pulled
// components also stand on the frame (the throttle box only rests on it).
//
// Coordinates, seen from the pilot: x to the right, y away from the pilot
// (towards the monitor), z up. The origin is the front left corner of the
// frame at desk height: the front part has its front face at y = 0, the
// sheet is in front of it (y = -sheet_t .. 0).
//
//   left part           yoke bay           right part
//   ignition+switches   Saitek yoke        Saitek radio panel
//                       (on the desk)      throttle box under it
//
// - Front part, vertical, in front of the desk edge: a rectangle (top bar,
//   bottom bar, an upright at each end) with an upright on each side of the
//   yoke bay. The bottom bar lies just
//   under the desk top (its top at desk height), its back against the desk
//   edge (a felt pad); the yoke's front sits on it, the yoke's own clamps go
//   around it and the desk. Under the throttle a smaller rectangle hangs
//   from the bottom bar: the apron, two hangers and a lower bar, for the
//   trim wheel / fuel selector pedestal. The parking brake hangs under the
//   bottom bar in the bay, directly below the yoke.
// - Desk part, flat on the desk behind it: a ladder (front rail, rear rail,
//   crossbars) with the front rail cut at the yoke bay. The front part is
//   bolted to its front rail, and a 45 degree brace from each upright down
//   to a crossbar stops it from rocking: a stock length, cut square, held
//   by a bought 45 degree connector at each end. The throttle box stands on the
//   front rail and the crossbar under its middle.
//
// The front rail runs past the sheet at both ends (ear_len): there a
// bought screw clamp (rubber jaws) on each end clamps the rail onto the
// desk. All metal, printed parts creep under constant load.
// knee_w around the yoke stays open for the legs; only the bottom bar and
// the thin parking brake are there, just under the desk top.
//
// Lengths are rounded to stock lengths (multiples of round_d), except the
// apron's lower bar. The height is the lowest that the parts on the sheet
// allow, with stock length uprights.

// --- Extrusion: 2020 only, 6 mm slot, M5 T-nuts everywhere ---
ext = 20;
round_w = 100;               // frame width rounded up to this
round_d = 50;                // the other bars rounded to this (stock lengths)
round_cut = 10;              // the apron's lower bar: between the leg room and the pedestal, no stock length fits
brace_len = 200;             // a stock length, cut square
slot_w = 6;
m5_d = 5.3;                  // M5 clearance, sheet and printed parts
m5_head_d = 9.5;             // button head

// --- Sheet ---
sheet_t = 3;                 // ACM, the same as the printed panel_t
sheet_h_max = 260;           // panel height above the desk at most; limited by the monitor
                             // (sheet_h is computed from the parts on it)
sheet_edge = 25;             // sheet edge to a cut-out, at least
sheet_web = 20;              // sheet between two cut-outs, at least
screw_edge = 6;              // screw hole center to a cut-out, at least
screw_step = 150;            // screws along a bar, at most this far apart
screw_step_upright = 100;

// --- Desk, MEASURE ---
desk = [1200, 700, 28];      // width, depth, thickness
desk_skirt = 0;              // frame or drawer under the top at its front edge, height below the top
knee_w = 460;                // kept open under the desk for the legs, centered on the yoke
edge_play = 2;               // front part back to the desk edge: a felt pad, the front part stops the frame against the edge
frame_overhang = ext + edge_play;     // frame front in front of the desk edge

// --- Saitek Pro Flight Yoke, MEASURE ---
// Spec sheet: 310 mm wide (the wheel), 380-464 mm deep with the shaft in /
// out. The housing is about 100 mm high and about as wide as the radio
// panel that sat on it (from memory).
yoke_housing = [283, 280, 100];   // housing body: width, depth, height
ffb_h = 130;                 // the future force feedback yoke's height, the notch is made for it
yoke_front_y = 0;            // housing front, on the bottom bar; its clamps go around the bar and the desk
yoke_play = 5;               // housing to the bay sides and the notch top
yoke_shaft_z = 65;           // shaft center above the desk (view only)
yoke_wheel_w = 310;          // view only

// --- Saitek Pro Flight Radio Panel, MEASURE ---
// Spec sheet: 283 x 84 mm front, 55 mm deep (106 mm with the bracket).
// Logitech publishes the cut-out ("Construction dimensions for Flight
// Panels"); radio_body is a guess until then.
radio_front = [283, 84];
radio_front_t = 3;
radio_body = [275, 76];      // what goes through the sheet
radio_depth = 55;            // behind the sheet

// --- Throttle box, from throttle/throttle_box.scad ---
// The box (full_width x (depth + 2 * roundness) x height, open top) goes
// through its cut-out and stands on the front rail and the middle
// crossbar, its front overhanging the front part. Its front wall (face_t)
// is the face; the flange (flange_w, on the top and the two sides, none at
// the bottom) is screwed onto the sheet with M3 (drill through the box's
// holes); its floor only rests on the rail.
throttle_size = [150, 190, 50];
throttle_rod_xs = [20, 75, 130];  // roundness + end_gap + i * control_gap
throttle_rod_z = 38;         // wall + stand + pot module + 15 + 7
throttle_face_t = 3;         // face_t
throttle_flange = 10;        // flange_w
throttle_play = 1;           // box to its cut-out, sheet_cut_clear

// --- Switch panel, from switchpanel/ ---
// The backs of the ignition (77) and the switches (211.6), panel_h high,
// go through one hole in the sheet; the face flange (flange_w, on the top,
// the bottom and the two outer ends) is screwed onto the sheet with M3
// (drill through the panel's holes).
switch_ign_w = 77;
switch_back = [switch_ign_w + 211.6, 80];  // panel_h
switch_flange = 10;          // flange_w
switch_cut_clear = 1;        // sheet_cut_clear
switch_panel = switch_back + 2 * [switch_flange, switch_flange];   // the face
switch_depth = 40;           // switches behind the sheet (view only)
switch_z = ext + 5;          // face bottom above the desk

// --- Under-desk controls, future components (guesses until designed) ---
// Pedestal (trim wheel, fuel selector), same rule as the throttle box: the
// body (width x depth x height) goes through its cut-out in the apron sheet
// and stands on the lower bar, the face flange (top and sides) is screwed
// onto the sheet with M3, and two M5 bolts through the floor go into the
// lower bar's top slot. The body must be below the desk.
under_face_t = 3;
under_flange = 10;
under_play = 1;              // body to its cut-out
under_bolt_y = 16;           // floor bolts from the face front, over the lower bar's slot
pedestal_size = [90, 120, 150];
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
// MEASURE: the Saitek yoke's own desk clamps, the free width between them
// at the desk edge; the parking brake body goes there
yoke_clamp_gap = 120;

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

// --- Layout ---
gap = 25;                    // between two parts; the bay uprights stand in it
right_w = max(radio_front.x, throttle_size.x + 2 * throttle_flange);
bay_w = yoke_housing.x + 2 * yoke_play;
parts_w = switch_panel.x + gap + bay_w + gap + right_w;
frame_w = ceil((parts_w + 2 * sheet_edge) / round_w) * round_w;
margin = (frame_w - parts_w) / 2;           // sheet edge to the outer cut-outs

x_sw0 = margin;                              // switch panel
x_sw1 = x_sw0 + switch_panel.x;
x_bay0 = x_sw1 + gap;                        // yoke bay
x_bay1 = x_bay0 + bay_w;
x_r0 = x_bay1 + gap;                         // radio and throttle
x_r1 = x_r0 + right_w;
x_rc = (x_r0 + x_r1) / 2;

// front part
upright_xs = [0, x_bay0 - ext, x_bay1, frame_w - ext];   // left sides
throttle_x0 = x_rc - throttle_size.x / 2;
throttle_y0 = -sheet_t - throttle_face_t;    // face front, the face on the sheet

throttle_cut = [throttle_x0 - throttle_play, ext,
                throttle_x0 + throttle_size.x + throttle_play, ext + throttle_size.z + throttle_play];
throttle_face = [throttle_x0 - throttle_flange, ext,
                 throttle_x0 + throttle_size.x + throttle_flange, ext + throttle_size.z + throttle_flange];
radio_cut = [x_rc - radio_body.x / 2 - 0.5, throttle_cut[3] + sheet_web,
             x_rc + radio_body.x / 2 + 0.5, throttle_cut[3] + sheet_web + radio_body.y + 1];
radio_front_z0 = radio_cut[1] + 0.5 - (radio_front.y - radio_body.y) / 2;
switch_cut = [x_sw0 + switch_flange - switch_cut_clear, switch_z + switch_flange - switch_cut_clear,
              x_sw1 - switch_flange + switch_cut_clear, switch_z + switch_flange + switch_back.y + switch_cut_clear];
bay_cut = [x_bay0, 0, x_bay1, max(yoke_housing.z, ffb_h) + yoke_play];
cuts = [switch_cut, bay_cut, throttle_cut, radio_cut];   // [x0, z0, x1, z1] on the sheet

// Height: sheet_web over the highest cut-out (or the radio front), then the
// top bar; the uprights (on the bottom bar, under the top bar) a stock length
upright_len = ceil((max(radio_front_z0 + radio_front.y, bay_cut[3], switch_cut[3]) + sheet_web) / round_d) * round_d;
sheet_h = upright_len + ext;                 // panel height above the desk (the sheet also covers the bottom bar, ext more)

// desk part: the front rail behind the front part, cut at the bay
crossbar_xs = concat(upright_xs, [x_rc - ext / 2]);      // the last one carries the throttle box
crossbar_len = ceil((max(yoke_front_y + yoke_housing.y, throttle_y0 + throttle_size.y) - ext) / round_d) * round_d;
rear_y = 2 * ext + crossbar_len;
frame_d = rear_y + ext;
// front rail left and right, [x0, x1]: at least ear_len past the sheet, rounded up
rails = [[x_bay0 - ceil((x_bay0 + ear_len) / round_d) * round_d, x_bay0],
         [x_bay1, x_bay1 + ceil((frame_w - x_bay1 + ear_len) / round_d) * round_d]];
clamp_xs = [rails[0][0] + ear_len / 2, rails[1][1] - ear_len / 2];   // desk clamps, on the rail ends
brace_room = 30;             // upright above the brace, for the connector's leg
// Brace: its inner edge (towards the corner) from the upright's back at
// brace_top down to the crossbar top, brace_rise lower and further back;
// a 45 degree connector in the obtuse angle at each end, so at the top the
// upright needs brace_room above it
brace_rise = brace_len / sqrt(2);
brace_top = ext + brace_rise;

// --- Below the desk top (z < 0) ---
yoke_c = (x_bay0 + x_bay1) / 2;
legs = [yoke_c - knee_w / 2, yoke_c + knee_w / 2];       // open for the legs
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
park_x = yoke_c;
park_z = -under_z - park_size.z;                         // body bottom
// pedestal cut-out and face, [x0, z0, x1, z1] on the apron sheet
pedestal_x = x_rc;
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
avoid = concat(cuts, [throttle_face]);
sheet_screws = [for (p = concat(
      [for (ux = upright_xs, z = spread(20, sheet_h - ext - 20, screw_step_upright)) [ux + ext / 2, z]],
      [for (x = spread(ext / 2, frame_w - ext / 2, screw_step)) [x, sheet_h - ext / 2]],
      [for (x = spread(ext / 2, frame_w - ext / 2, screw_step)) [x, -ext / 2]]))
   if (clear_of(p, avoid, screw_edge)) p];
// apron sheet: its hangers and the lower bar, [x, z]
apron_screws = [for (p = concat(
      [for (h = hangers, z = spread(-apron_h + ext / 2, -ext - ext / 2, screw_step_upright)) [h + ext / 2, z]],
      [for (x = spread(apron_bar[0] + ext / 2, apron_bar[1] - ext / 2, screw_step)) [x, -apron_h + ext / 2]]))
   if (clear_of(p, [pedestal_cut, pedestal_face], screw_edge)) p];
// M5 through the pedestal floor into T-nuts in the lower bar's top slot, [x, y]
pedestal_bolts = [for (s = [-1, 1]) [pedestal_x + s * pedestal_size.x / 4, under_y0 + under_bolt_y]];

// --- Checks ---
assert(gap >= ext + 3 && margin >= ext + 3, "No room for the uprights next to the cut-outs");
assert(margin >= sheet_edge, "Cut-outs too close to the sheet edge");
assert(switch_cut[1] >= ext, "Switch panel cut-out runs into the bottom of the sheet");
assert(throttle_x0 >= rails[1][0] && throttle_x0 + throttle_size.x <= frame_w, "Throttle box not on the front rail");
assert(throttle_y0 + throttle_size.y <= rear_y, "Throttle box does not fit on the frame");
assert(yoke_front_y + yoke_housing.y <= rear_y, "Yoke housing runs into the rear rail");
assert(radio_body.x <= radio_front.x - 6 && radio_body.y <= radio_front.y - 6,
       "Radio front does not cover its cut-out");
assert(radio_front_z0 >= throttle_face[3] + 2, "Radio front runs into the throttle box face");
assert(sheet_h <= sheet_h_max, "Panel too high for the monitor");
assert(radio_front_z0 + radio_front.y <= sheet_h - ext - sheet_web, "Radio panel too high for the sheet");
assert(bay_cut[3] <= sheet_h - ext - sheet_web, "Yoke notch too high for the sheet");
assert(switch_cut[3] <= sheet_h - ext - sheet_web, "Switch panel too high for the sheet");
assert(ext + brace_rise + ext / sqrt(2) <= rear_y, "Braces do not land on the crossbars");
assert(brace_top + brace_room <= sheet_h - ext, "Braces too long: no room for the connector on the upright");
assert(brace_top + ext / sqrt(2) <= sheet_h, "Braces stick out over the top bar");
assert(rails[1][1] - rails[0][0] <= desk.x && frame_d <= frame_overhang + desk.y, "Frame does not fit on the desk");
assert(2 * ext - frame_overhang >= 10, "Front rail barely on the desk");
assert(legs[0] <= x_bay0 && legs[1] >= x_bay1, "Leg room narrower than the yoke bay");
assert(hangers[0] >= legs[1], "Apron hanger in the leg room");
assert(hangers[0] >= x_bay1 + ext, "Apron hanger not under the throttle side");
assert(abs(under_y0 + under_bolt_y - ext / 2) < 0.01, "Pedestal floor bolts miss the lower bar slot");
assert(pedestal_face[0] >= apron_bar[0] && pedestal_face[2] <= apron_bar[1],
       "Pedestal does not fit between its hangers");
assert(pedestal_cut[3] <= -under_z + under_play, "Pedestal runs into the desk");
assert(pedestal_face[3] <= -ext - screw_edge, "Pedestal face runs off its apron sheet");
assert(clamp_open >= ext + desk.z + 1, "Desk clamps do not open far enough for the rail and the desk");
assert(clamp_reach >= clamp_y + 2, "Desk clamps do not reach over the rail to the desk");
assert(clamp_y - clamp_pad_d / 2 >= frame_overhang - 3, "Desk clamp jaw not under the desk");
assert(clamp_w + 10 <= ear_len, "Desk clamps do not fit on the rail ends beside the sheet");
assert(park_size.x + 10 <= yoke_clamp_gap, "Parking brake runs into the yoke's desk clamps");
assert(park_size.y <= desk.y / 3, "Parking brake body too deep under the desk");
assert(abs(park_x - yoke_c) < 0.01 && park_bolt_dx * 2 + m5_head_d <= park_size.x + 10,
       "Parking brake bolts do not fit");
