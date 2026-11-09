// Cockpit frame basics, shared by the files in frame/
//
// The frame is an aluminium extrusion ladder that lies on the desk, with a
// vertical panel frame on its front edge. One
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
//
// The frame overhangs the desk edge by a 2020 (plus play), so extrusion can
// go down in front of the desk edge:
// - Clamps: four 2020 hangers under the front rail, each with a 2020 arm
//   that reaches back under the desk top and an M5 thumb screw in it that
//   presses up against the desk underside. All metal, every load on a
//   screw in a drilled hole or a T-nut pulled onto its slot lips. Two short
//   hangers on the left, the two apron hangers on the right.
// - Apron, under the throttle: the two right hangers go further down, a
//   lower bar joins their ends and a small ACM sheet covers them. It
//   carries the pedestal (trim wheel, fuel selector).
// - Bay bar: a 2020 under the yoke bay, under the two front rail ends. The
//   parking brake hangs under it, directly below the yoke: a thin body under
//   the desk top and a T-handle in front of the bar.
// knee_w around the yoke stays open for the legs; only the bay bar and the
// thin parking brake are there, just under the desk top.

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
desk_skirt = 0;              // frame or drawer under the top at its front edge, height below the top
knee_w = 460;                // kept open under the desk for the legs, centered on the yoke
hanger_play = 2;             // hanger back to the desk edge: a felt pad, the hangers stop the frame against the edge
frame_overhang = ext + hanger_play;   // frame front in front of the desk edge, for the hangers

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
// desk top, behind the bay bar, hangs from the bay bar's bottom slot (two
// M5). Its T-handle is in front of the bar: released, it is almost flush
// and lies sideways; set, it is pulled out by park_pull and turned to point
// down.
park_size = [40, 90, 22];
park_bolt_dx = 12;           // bolts from its center, into the bay bar's bottom slot
park_pull = 50;              // handle travel
park_handle = 60;            // T-handle length (view only)
// MEASURE: the Saitek yoke's own desk clamps, the free width between them
// at the desk edge; the parking brake body goes there
yoke_clamp_gap = 120;

// --- Desk clamps, all metal ---
// Each hanger is held under the front rail by a blind joint: an M5 button
// head screw in the hanger's tapped top end, its head in the rail's bottom
// slot, tightened through an access hole drilled down through the rail;
// two corner brackets keep it square. A 2020 arm runs from the hanger's
// back face back under the desk top: an M5 through the hanger (drilled,
// head on its front face) into the arm's tapped end, and a corner bracket
// under the arm. An M5 thumb screw from below goes through a T-nut in the
// arm's bottom slot and a hole drilled through the arm, and presses up on a
// rubber pad stuck to the desk underside, so the desk top is clamped
// between the frame on it and the arms under it.
arm_len = 80;                // from the hanger back face (y)
arm_gap = 5;                 // arm top to the desk underside: the pad and play
pad_t = 3;                   // self-adhesive rubber bumper, 20 mm
pad_d = 20;
thumb_len = 40;              // MEASURE: M5 knurled thumb screw (DIN 464), thread length
thumb_head = [16, 10];       // MEASURE: its head diameter and height
arm_screw_y = ext + arm_len - 15;   // thumb screw from the frame front
bracket_leg = 20;            // 2020 corner bracket (view only)
bracket_t = 3;

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

// --- Below the desk top (z < 0) ---
yoke_c = (x_bay0 + x_bay1) / 2;
legs = [yoke_c - knee_w / 2, yoke_c + knee_w / 2];       // open for the legs
under_z = desk.z + desk_skirt + desk_clear;              // desk top to the top of the bodies
// Hangers: a hanger's own width of rail beside it for a corner bracket on
// each side, outside the leg room. [left side, length]
arm_z1 = -(desk.z + desk_skirt + arm_gap);               // arm top
arm_z0 = arm_z1 - ext;
arm_bolt_z = arm_z0 + ext / 2;                           // M5 through the hanger into the arm
thumb_z = -(desk.z + desk_skirt + pad_t) - thumb_len;    // thumb screw head top, the tip on the pad
clamp_h = -arm_z0 + bracket_leg;                         // short hanger: the bracket under the arm
apron_h = under_z + pedestal_size.z + under_play + ext;
apron_bar_z = -apron_h + ext;                            // top of the lower bar
apron = [legs[1], frame_w];                              // [x0, x1] of the apron sheet
hangers = [[ext, clamp_h], [min(x_bay0 - 3 * ext, legs[0] - ext), clamp_h],
           [apron[0], apron_h], [frame_w - 2 * ext, apron_h]];
apron_bar = [hangers[2][0] + ext, hangers[3][0]];
// Bay bar under the two front rail ends, an M5 at each end through the bar
// into the rail's front bottom slot
bay_bar = [x_bay0 - ext, x_bay1 + ext];
bay_bar_bolts = [bay_bar[0] + ext / 2, bay_bar[1] - ext / 2];
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
// apron sheet: its hangers and the lower bar, [x, z]
apron_screws = [for (p = concat(
      [for (i = [2, 3], z = spread(-apron_h + ext / 2, -ext / 2, screw_step_upright)) [hangers[i][0] + ext / 2, z]],
      [for (x = spread(apron_bar[0] + ext / 2, apron_bar[1] - ext / 2, screw_step)) [x, -apron_h + ext / 2]]))
   if (clear_of(p, [pedestal_cut, pedestal_face], screw_edge)) p];
// apron sheet: clearance for the arm bolt heads on the apron hangers, [x, z]
apron_head_holes = [for (i = [2, 3]) [hangers[i][0] + ext / 2, arm_bolt_z]];
apron_head_d = m5_head_d + 1;
// M5 through the throttle box floor into T-nuts in the front rail's top slot, [x, y]
throttle_bolts = [for (x = throttle_bolt_xs) [throttle_x0 + x, throttle_y0 + throttle_bolt_y]];
// M5 through the pedestal floor into T-nuts in the lower bar's top slot, [x, y]
pedestal_bolts = [for (s = [-1, 1]) [pedestal_x + s * pedestal_size.x / 4, under_y0 + under_bolt_y]];

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
assert(frame_w <= desk.x && frame_d <= frame_overhang + desk.y, "Frame does not fit on the desk");
assert(rail.x - frame_overhang >= 10, "Front rail barely on the desk");
assert(legs[0] <= x_bay0 && legs[1] >= x_bay1, "Leg room narrower than the yoke bay");
assert(hangers[2][0] - ext >= x_bay1 && hangers[3][0] + 2 * ext <= frame_w,
       "Apron hangers not under the front rail");
assert(hangers[1][0] + 2 * ext <= bay_bar[0], "Left clamp hanger runs into the bay bar");
assert(hangers[2][0] - ext >= bay_bar[1], "Right clamp hanger runs into the bay bar");
assert(hangers[1][0] + ext <= legs[0] && hangers[2][0] >= legs[1], "Clamp arms in the leg room");
assert(abs(under_y0 + under_bolt_y - ext / 2) < 0.01, "Pedestal floor bolts miss the lower bar slot");
assert(pedestal_face[0] >= apron_bar[0] && pedestal_face[2] <= apron_bar[1],
       "Pedestal does not fit between its hangers");
assert(pedestal_cut[3] <= -under_z + under_play, "Pedestal runs into the desk");
assert(pedestal_face[3] <= -screw_edge, "Pedestal face runs off its apron sheet");
assert(thumb_head[0] <= ext && hangers[2][0] + ext <= pedestal_x - pedestal_size.x / 2 - under_play
       && hangers[3][0] >= pedestal_x + pedestal_size.x / 2 + under_play,
       "Apron clamp arms run into the pedestal");
assert(arm_screw_y - frame_overhang >= 20, "Clamp thumb screw not under the desk");
assert(arm_screw_y - thumb_head[0] / 2 >= ext + bracket_leg + 3 && arm_screw_y + 8 <= ext + arm_len,
       "Clamp thumb screw runs into the arm's bracket or end");
assert(thumb_z <= arm_z0 - 5, "Clamp thumb screw too short: its head reaches the arm before the desk");
assert(min([for (p = apron_head_holes, q = apron_screws) abs(p.x - q.x) > 1 ? 99 : abs(p.y - q.y)])
       >= (apron_head_d + m5_d) / 2 + 3, "Arm bolt heads run into the apron sheet screws");
assert(park_size.x + 10 <= yoke_clamp_gap, "Parking brake runs into the yoke's desk clamps");
assert(park_size.y <= desk.y / 3, "Parking brake body too deep under the desk");
assert(abs(park_x - yoke_c) < 0.01 && park_bolt_dx * 2 + m5_head_d <= park_size.x + 10,
       "Parking brake bolts do not fit");
