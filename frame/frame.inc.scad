// Cockpit frame basics, shared by the files in frame/
//
// The frame is an aluminium extrusion ladder that lies on the desk and is
// held by desk clamps, with a vertical panel frame on its front edge. One
// 3 mm aluminium composite (ACM) sheet covers the panel frame; every
// cockpit component brings its own front face, a hole is cut into the
// sheet for it and its face is screwed onto the sheet. Heavy or pulled
// components (the throttle box) also stand on the frame and are bolted to
// it.
//
// Coordinates, seen from the pilot: x to the right, y away from the pilot
// (towards the monitor), z up. The origin is the front left corner of the
// frame at desk height: the front rail and the uprights have their front
// face at y = 0, the sheet is in front of them (y = -sheet_t .. 0).
//
//   left part           yoke bay           right part
//   ignition+switches   Saitek yoke        Saitek radio panel
//                       (on the desk)      throttle box under it
//
// The front rail is two pieces with the yoke bay between them, so the
// Saitek yoke clamps to the desk as before. An upright stands on each side
// of the bay and at the two outer ends, a top bar joins them, and a 45
// degree brace behind each upright stops it from rocking.

// --- Extrusion: 2020 / 2040, 6 mm slot, M5 T-nuts everywhere ---
ext = 20;                    // 2020 profile, and the small side of 2040
rail = [40, 20];             // front and rear rail: 2040 lying flat (y x z)
slot_w = 6;
m5_d = 5.3;                  // M5 clearance, sheet and printed parts
m5_head_d = 9.5;             // button head

// --- Sheet ---
sheet_t = 3;                 // ACM, the same as the printed panel_t
sheet_h = 260;               // panel height above the desk; limited by the monitor
sheet_edge = 25;             // sheet edge to a cut-out, at least
sheet_web = 20;              // sheet between two cut-outs, at least
screw_edge = 6;              // screw hole center to a cut-out, at least
screw_step = 150;            // screws along a bar, at most this far apart
screw_step_upright = 100;

// --- Desk, MEASURE ---
desk = [1200, 700, 25];      // width, depth, thickness
frame_overhang = 2;          // frame front in front of the desk edge, for hangers later

// --- Saitek Pro Flight Yoke, MEASURE ---
// Spec sheet: 310 mm wide (the wheel), 185 mm high, 380-464 mm deep with the
// shaft in / out. The housing is about as wide as the radio panel that sat
// on it (from memory).
yoke_housing = [283, 280, 185];   // housing body: width, depth, height
yoke_front_y = frame_overhang;    // housing front, clamped to the desk edge
yoke_play = 5;               // housing to the bay sides and the notch top
yoke_shaft_z = 120;          // shaft center above the desk (view only)
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
// crossbar. Its front wall (face_t) is the face; the flange (flange_w, on
// the top and the two sides, none at the bottom) is screwed onto the sheet
// with M3 (drill through the box's holes), and two M5 bolts through its
// floor go into the front rail's top slot.
throttle_size = [150, 190, 50];
throttle_rod_xs = [20, 75, 130];  // roundness + end_gap + i * control_gap
throttle_rod_z = 38;         // wall + stand + pot module + 15 + 7
throttle_face_t = 3;         // face_t
throttle_flange = 10;        // flange_w
throttle_play = 1;           // box to its cut-out, sheet_cut_clear
throttle_bolt_xs = [47.5, 102.5]; // floor_bolt_xs
throttle_bolt_y = 16;        // floor_bolt_y, from the face front

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
switch_z = rail.y + 5;       // face bottom above the desk

// --- Layout ---
gap = 25;                    // between two parts; the bay uprights stand in it
right_w = max(radio_front.x, throttle_size.x + 2 * throttle_flange);
bay_w = yoke_housing.x + 2 * yoke_play;

x_sw0 = sheet_edge;                          // switch panel
x_sw1 = x_sw0 + switch_panel.x;
x_bay0 = x_sw1 + gap;                        // yoke bay
x_bay1 = x_bay0 + bay_w;
x_r0 = x_bay1 + gap;                         // radio and throttle
x_r1 = x_r0 + right_w;
frame_w = x_r1 + sheet_edge;
x_rc = (x_r0 + x_r1) / 2;

upright_xs = [0, x_bay0 - ext, x_bay1, frame_w - ext];   // left sides
throttle_x0 = x_rc - throttle_size.x / 2;
throttle_y0 = -sheet_t - throttle_face_t;    // face front, the face on the sheet
crossbar_xs = concat(upright_xs, [x_rc - ext / 2]);      // the last one carries the throttle box

throttle_cut = [throttle_x0 - throttle_play, rail.y,
                throttle_x0 + throttle_size.x + throttle_play, rail.y + throttle_size.z + throttle_play];
throttle_face = [throttle_x0 - throttle_flange, rail.y,
                 throttle_x0 + throttle_size.x + throttle_flange, rail.y + throttle_size.z + throttle_flange];
radio_cut = [x_rc - radio_body.x / 2 - 0.5, throttle_cut[3] + sheet_web,
             x_rc + radio_body.x / 2 + 0.5, throttle_cut[3] + sheet_web + radio_body.y + 1];
radio_front_z0 = radio_cut[1] + 0.5 - (radio_front.y - radio_body.y) / 2;
switch_cut = [x_sw0 + switch_flange - switch_cut_clear, switch_z + switch_flange - switch_cut_clear,
              x_sw1 - switch_flange + switch_cut_clear, switch_z + switch_flange + switch_back.y + switch_cut_clear];
bay_cut = [x_bay0, 0, x_bay1, yoke_housing.z + yoke_play];
cuts = [switch_cut, bay_cut, throttle_cut, radio_cut];   // [x0, z0, x1, z1] on the sheet

frame_d = max(yoke_front_y + yoke_housing.y, throttle_y0 + throttle_size.y) + ext + rail.x;
rear_y = frame_d - rail.x;
crossbar_len = rear_y - rail.x;
upright_len = sheet_h - rail.y - ext;
brace_rise = upright_len - ext;              // its long edge, from under the top bar to the crossbar
brace_long = brace_rise * sqrt(2);

// --- Sheet screws: M5 through the sheet into T-nuts in the front slots ---
function spread(a, b, step) = let(n = max(1, ceil((b - a) / step))) [for (i = [0 : n]) a + (b - a) * i / n];
function clear_of(p, rects, m) =
   len([for (r = rects) if (p.x > r[0] - m && p.x < r[2] + m && p.y > r[1] - m && p.y < r[3] + m) 1]) == 0;
avoid = concat(cuts, [throttle_face]);
sheet_screws = [for (p = concat(
      [for (ux = upright_xs, z = spread(rail.y + 20, sheet_h - ext - 20, screw_step_upright)) [ux + ext / 2, z]],
      [for (x = spread(ext / 2, frame_w - ext / 2, screw_step)) [x, sheet_h - ext / 2]],
      [for (x = spread(ext / 2, x_bay0 - ext / 2, screw_step)) [x, rail.y / 2]],
      [for (x = spread(x_bay1 + ext / 2, frame_w - ext / 2, screw_step)) [x, rail.y / 2]]))
   if (clear_of(p, avoid, screw_edge)) p];
// M5 through the throttle box floor into T-nuts in the front rail's top slot, [x, y]
throttle_bolts = [for (x = throttle_bolt_xs) [throttle_x0 + x, throttle_y0 + throttle_bolt_y]];

// --- Checks ---
assert(gap >= ext + 3 && sheet_edge >= ext + 3, "No room for the uprights next to the cut-outs");
assert(switch_cut[1] >= rail.y, "Switch panel cut-out runs into the front rail");
assert(throttle_y0 + throttle_size.y <= rear_y, "Throttle box does not fit on the frame");
assert(yoke_front_y + yoke_housing.y <= rear_y, "Yoke housing runs into the rear rail");
assert(radio_body.x <= radio_front.x - 6 && radio_body.y <= radio_front.y - 6,
       "Radio front does not cover its cut-out");
assert(radio_front_z0 >= throttle_face[3] + 2, "Radio front runs into the throttle box face");
assert(radio_front_z0 + radio_front.y <= sheet_h - ext - sheet_web, "Radio panel too high for the sheet");
assert(bay_cut[3] <= sheet_h - ext - sheet_web, "Yoke notch too high for the sheet");
assert(switch_cut[3] <= sheet_h - ext - sheet_web, "Switch panel too high for the sheet");
assert(abs(throttle_y0 + throttle_bolt_y - rail.x / 4) < 0.01, "Throttle floor bolts miss the front rail slot");
assert(ext + brace_rise + ext * sqrt(2) <= rear_y, "Braces do not land on the crossbars");
assert(frame_w <= desk.x && frame_d + frame_overhang <= desk.y, "Frame does not fit on the desk");
