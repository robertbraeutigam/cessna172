// Cockpit frame basics, shared by the files in frame/
//
// The frame is an aluminium extrusion ladder that lies on the desk and is
// held by desk clamps, with a vertical panel frame on its front edge. One
// 3 mm aluminium composite (ACM) sheet covers the panel frame; every
// cockpit component brings its own front face, a hole is cut into the
// sheet for it and its face is screwed onto the sheet. Heavy or pulled
// components (the throttle box) also stand on the frame.
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
// full_width x (depth + 2 * roundness) x (height + lid)
throttle_size = [150, 190, 52];
throttle_rod_xs = [20, 75, 130];  // roundness + end_gap + i * control_gap
throttle_rod_z = 38;         // wall + stand + pot module + 15 + 7
throttle_nut_d = 11.2;
// Clamp pockets at the front: 20 x 20, 35 deep from the front, open at
// the front, in housings of 20 + 2 * wall
throttle_pocket = [20, 32, 20];   // x, depth from the front, z
throttle_pocket_xs = [13, 117];   // pocket left side: roundness + wall, width - 20 - wall + roundness
throttle_pocket_z = 3;       // floor
throttle_housing_h = 26;
throttle_play = 1;           // box to its cut-out

// --- Switch panel, from switchpanel/ ---
// ignition (92) + switches (211.6), both panel_h high; the rim on the back
// (rim_w wide, rim_h deep) sits on the sheet.
switch_panel = [304, 80];
switch_rim_w = 2.5;
switch_depth = 40;           // switches behind the sheet (view only)
switch_z = rail.y + 5;       // panel bottom above the desk

// --- Layout ---
gap = 25;                    // between two parts; the bay uprights stand in it
right_w = max(radio_front.x, throttle_size.x + 2 * throttle_play);
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
throttle_y0 = -sheet_t;                      // box front flush with the sheet front
crossbar_xs = concat(upright_xs, [x_rc - ext / 2]);      // the last one carries the throttle box

throttle_cut = [throttle_x0 - throttle_play, rail.y,
                throttle_x0 + throttle_size.x + throttle_play, rail.y + throttle_size.z + throttle_play];
radio_cut = [x_rc - radio_body.x / 2 - 0.5, throttle_cut[3] + sheet_web,
             x_rc + radio_body.x / 2 + 0.5, throttle_cut[3] + sheet_web + radio_body.y + 1];
radio_front_z0 = radio_cut[1] + 0.5 - (radio_front.y - radio_body.y) / 2;
switch_cut = [x_sw0 + switch_rim_w, switch_z + switch_rim_w,
              x_sw1 - switch_rim_w, switch_z + switch_panel.y - switch_rim_w];
bay_cut = [x_bay0, 0, x_bay1, yoke_housing.z + yoke_play];
cuts = [switch_cut, bay_cut, throttle_cut, radio_cut];   // [x0, z0, x1, z1] on the sheet

frame_d = max(yoke_front_y + yoke_housing.y, throttle_y0 + throttle_size.y) + ext + rail.x;
rear_y = frame_d - rail.x;
crossbar_len = rear_y - rail.x;
upright_len = sheet_h - rail.y - ext;
brace_rise = upright_len - ext;              // its long edge, from under the top bar to the crossbar
brace_long = brace_rise * sqrt(2);

// --- Throttle mount (printed, 2x): a tongue in a clamp pocket and a plate
// in front of the sheet, bolted through the sheet into the front rail ---
tm_fit = 0.3;
tm_plate_t = 5;
tm_plate_w = throttle_pocket.x + 6;
tm_plate_z = [2, rail.y + throttle_housing_h];       // plate bottom and top
tm_bolt_dx = 7;                                       // two bolts, +-, into the rail slot
function tm_cx(i) = throttle_x0 + throttle_pocket_xs[i] + throttle_pocket.x / 2;
tm_plates = [for (i = [0, 1]) [tm_cx(i) - tm_plate_w / 2, tm_plate_z[0], tm_cx(i) + tm_plate_w / 2, tm_plate_z[1]]];

// --- Sheet screws: M5 through the sheet into T-nuts in the front slots ---
function spread(a, b, step) = let(n = max(1, ceil((b - a) / step))) [for (i = [0 : n]) a + (b - a) * i / n];
function clear_of(p, rects, m) =
   len([for (r = rects) if (p.x > r[0] - m && p.x < r[2] + m && p.y > r[1] - m && p.y < r[3] + m) 1]) == 0;
avoid = concat(cuts, tm_plates);
sheet_screws = [for (p = concat(
      [for (ux = upright_xs, z = spread(rail.y + 20, sheet_h - ext - 20, screw_step_upright)) [ux + ext / 2, z]],
      [for (x = spread(ext / 2, frame_w - ext / 2, screw_step)) [x, sheet_h - ext / 2]],
      [for (x = spread(ext / 2, x_bay0 - ext / 2, screw_step)) [x, rail.y / 2]],
      [for (x = spread(x_bay1 + ext / 2, frame_w - ext / 2, screw_step)) [x, rail.y / 2]]))
   if (clear_of(p, avoid, screw_edge)) p];
tm_bolts = [for (i = [0, 1], s = [-1, 1]) [tm_cx(i) + s * tm_bolt_dx, rail.y / 2]];

// --- Checks ---
assert(gap >= ext + 3 && sheet_edge >= ext + 3, "No room for the uprights next to the cut-outs");
assert(switch_cut[1] >= rail.y, "Switch panel cut-out runs into the front rail");
assert(throttle_y0 + throttle_size.y <= rear_y, "Throttle box does not fit on the frame");
assert(yoke_front_y + yoke_housing.y <= rear_y, "Yoke housing runs into the rear rail");
assert(radio_body.x <= radio_front.x - 6 && radio_body.y <= radio_front.y - 6,
       "Radio front does not cover its cut-out");
assert(radio_front_z0 >= throttle_cut[3] + 2, "Radio front runs into the throttle box");
assert(radio_front_z0 + radio_front.y <= sheet_h - ext - sheet_web, "Radio panel too high for the sheet");
assert(bay_cut[3] <= sheet_h - ext - sheet_web, "Yoke notch too high for the sheet");
assert(switch_cut[3] <= sheet_h - ext - sheet_web, "Switch panel too high for the sheet");
assert(tm_plate_z[1] <= rail.y + throttle_rod_z - throttle_nut_d / 2 - 1, "Throttle mount plate runs into the rod nuts");
assert(ext + brace_rise + ext * sqrt(2) <= rear_y, "Braces do not land on the crossbars");
assert(frame_w <= desk.x && frame_d + frame_overhang <= desk.y, "Frame does not fit on the desk");
