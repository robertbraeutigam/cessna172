// Standard analogue instrument, shared by the files in instruments/
//
// A 3 1/8" round instrument behind a round hole in the frame's sheet (the
// stage 2 holes, frame/), like the real ones: the case goes into the hole
// from behind, its front flush with the sheet's front, and four screws
// from the front on the diagonals hold it (they show, like on the real
// panel). The needle is turned by a 28BYJ-48 geared stepper through two
// printed gears (1:1). A disc magnet in the motor gear passes a hall
// sensor, which homes the needle. MobiFlight on an Arduino Nano of its own
// drives it through the ULN2003 board; both sit on a printed carrier.
//
// Small gears, the motor behind the case (its body over the needle's
// axis), the carrier on posts behind the motor, its boards facing forward;
// nothing outside the case's outline, so it fits between the six-pack's
// neighbours, but 47 mm deep behind the sheet (the frame sets the force
// feedback yoke's housing back for it).
//
// Front to back: the lip (the window), the clear sheet (glass), the dial
// (a shallow cup: its rim holds the glass against the lip, the face is
// glued into it), the needle on a 3 mm steel axle, the needle gear, the
// back plate (the axle's bearing; three posts press the dial forward; the
// motor on its back). The motor gear is on the motor's shaft beside the
// needle gear, in the case's bore and a pocket in its wall.
//
// - The face is a colour print on paper (<file>_face.pdf, a print marker with
//   a colour list, see the Makefile): an instrument draws it as a 2D
//   module, every shape in ink(colour). The Makefile renders it once per
//   colour, with only that colour's shapes, and lays the layers over each
//   other in the order given; later colours cover earlier ones, so white
//   markings go over the black dial (white is the paper on any printer).
//   print_page() puts the faces and the glass's cut template on the page,
//   with registration dots in every layer (the PDF export centers each
//   layer on its own outline, so all of them need the same one).
// - Parts: the case (printed back side down), the dial (back down), the
//   back plate (back down), the two gears, the needle (front down) and the
//   board carrier. Everything black but the needle (white).
//
// Coordinates: x to the right, y away from the pilot, z up. The origin is
// the needle's axis on the sheet's front face.
//
// Parts to buy (per instrument):
// - 28BYJ-48 stepper (5 V) with its ULN2003 driver board (motor_*, uln_*)
// - Arduino Nano (ATmega328P, 5 V) and a USB cable (nano_*)
// - A3144 hall sensor (sensor), 2 x disc magnet 5 x 1 mm, stacked (magnet)
// - 3 mm steel dowel pin, 12 mm (axle)
// - clear sheet 1 mm, PET or acrylic (glass_t), the face printed on paper
//   (paper_t)
// - M3 x 8 button head, black (4, through the sheet into the case),
//   M3 x 8 countersunk self tapping (4, back plate into the case),
//   M3 x 8 countersunk + nut (2, motor ears), M3 x 6 self tapping
//   (4, ULN2003 board), M3 x 8 countersunk self tapping (4, board carrier:
//   from the back plate's front into its posts)
//
// Assembly: magnet into the motor gear's pocket (check which face pulls
// the sensor low), sensor into its pocket on the back plate (flat face
// out, legs through the slot), motor onto the back plate, boards onto
// their carrier, the carrier onto the back plate, wire it. Gear onto the
// axle, the axle into the back plate. Glass into the case from behind,
// the dial behind it, the back plate on (the gears mesh as it goes on),
// screwed into the case. Flash and set up MobiFlight, let it home, press
// the needle on at the face's zero. Case into the sheet's hole, the four
// screws from the front.

// --- The frame's sheet (frame/) ---
sheet_t = 3;
cut_d = 81;                  // the instrument's hole (inst_cut_d)
inst_pitch = [89, 88];       // check only: the six-pack's centres across and down (frame/)
nav_dx = 100;                // check only: the NAV indicators' column right of the six-pack's right one (frame's n172_nav_dx)

// --- The stepper drive (lib/stepper.inc.scad: the 28BYJ-48, the ULN2003
// board, the A3144 sensor, the magnet) and the Nano (lib/nano.inc.scad) ---
include <stepper.inc.scad>
include <nano.inc.scad>

// A board's own coordinates (lib/: the Nano's, the ULN2003's; the board
// on z=0, its parts up) on a plate whose face looks along +y at y: its
// middle at c ([x, z]), its +y (the Nano's USB jack) pointing "down", "up",
// "left" or "right". Proper rotations: a mirror would swap its sides.
function board_plate_m(dir) =
     dir == "down" ? [[1, 0, 0, 0], [0, 0, 1, 0], [0, -1, 0, 0], [0, 0, 0, 1]]
   : dir == "up" ? [[-1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]]
   : dir == "right" ? [[0, 1, 0, 0], [0, 0, 1, 0], [1, 0, 0, 0], [0, 0, 0, 1]]
   : assert(dir == "left") [[0, -1, 0, 0], [0, 0, 1, 0], [-1, 0, 0, 0], [0, 0, 0, 1]];
module on_board_plate(c, y, dir) {
   translate([c.x, y, c.y])
      multmatrix(board_plate_m(dir))
         children();
}

// --- Other bought parts, MEASURE ---
axle = [3, 12];              // steel dowel pin: diameter, length
glass_t = 1;                 // clear sheet
paper_t = 0.2;               // the face's paper (photo paper)
nut = [5.5, 2.4];            // M3: across flats, height

// --- Screws ---
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;
csk_d = 6.2;
head_d = 5.7;                // button head

// --- Case ---
tube_d = cut_d - 0.6;        // in the sheet's hole
window_d = 72;               // the lip's opening: the dial you see
lip_t = 1;
bore_d = 77.7;               // inside, the glass and the dial slide in from behind
case_d = 84;                 // behind the sheet
ear_r = 46;                  // the screws through the sheet, on the diagonals
ear_d = 9;
wall = 2;
front_screw = 8;             // M3 x 8 from the front, through the sheet
back_screw = 8;              // M3 x 8 from behind, through the back plate

// --- Dial, needle ---
rim_w = 1.4;                 // the dial's rim, round the face
dial_t = 1.5;
needle_gap = 2;              // glass to the needle
needle_t = 0.8;
needle_skin = 0.4;           // in front of the axle's end
hub_d = 6;
hub_h = 1.5;                 // the hub behind the blade
hub_gap = 0.5;               // hub to the face
needle_len = 33;
needle_tail = 8;
needle_w = [2.2, 0.8];       // at the hub, at the tip

// --- Gears and back plate ---
gear_m = 1;
gear_z = 26;                 // both: 1:1
gear_t = 5;
gear_play = 0.1;             // thinner teeth and a wider center distance
gear_gap = 0.5;              // to the dial and to the back plate
back_t = 3.5;
post_d = 3.4;                // the dial's posts on the back plate
post_angles = [90, 180, 270];
mag_r = 8.2;                 // magnet and sensor from the motor's shaft
mag_angle = 0;               // right, away from the motor's body
motor_dir = -1;              // the motor's body left of its shaft (over the axis)

// --- Boards ---
car_t = 2.5;                 // carrier plate
car_post_d = 7;              // the carrier's posts
board_gap = 2;               // motor cover to the ULN2003 board, boards apart

// --- Face and print ---
font = "Liberation Sans:style=Bold";
mono = "Liberation Mono:style=Bold";
print_copies = 2;
print_gap = 8;

// --- Calculated ---
glass_d = bore_d - 0.3;
rim_od = bore_d - 0.3;
rim_id = rim_od - 2 * rim_w;
face_d = rim_id - 0.4;                        // the paper
case_r = case_d / 2;
y_sheet1 = sheet_t;                           // the sheet's back, the case's front behind it
y_glass0 = lip_t;
y_glass1 = y_glass0 + glass_t;
y_needle0 = y_glass1 + needle_gap;            // the needle's front
y_needle1 = y_needle0 + needle_t;
y_face = y_needle1 + hub_h + hub_gap;         // the paper's front
y_dial0 = y_face + paper_t;                   // the dial's front (the paper on it)
y_dial1 = y_dial0 + dial_t;
y_gear0 = y_dial1 + gear_gap;
y_gear1 = y_gear0 + gear_t;
y_back0 = y_gear1 + gear_gap;                 // the back plate, the case's back
y_back1 = y_back0 + back_t;                   // the motor's flange on it
y_shaft_end = y_back1 - shaft_len;
y_axle0 = y_needle0 + needle_skin;
y_axle1 = y_axle0 + axle[1];
depth = y_back1 - y_sheet1;                   // behind the sheet's back (countersunk heads, flush)
gear_rp = gear_m * gear_z / 2;
gear_ra = gear_rp + gear_m;
gear_rf = gear_rp - 1.25 * gear_m;
drive_a = 2 * gear_rp + gear_play;            // the motor's shaft from the axis, along x
arm_r = gear_ra + 1 + wall;                   // the case's wall round the motor gear
cols = [for (a = [45 : 90 : 315]) ear_r * [cos(a), sin(a)]];   // case screw columns [x, z]
post_r = (rim_od + 0.3) / 2 - post_d / 2 - 0.15;
motor_c = [drive_a + motor_dir * motor_shaft_dy, 0];   // the motor body's middle, its cover further out
ears = [for (s = [-1, 1]) [motor_c.x, s * motor_ear_dx]];
sensor_c = [drive_a + mag_r * cos(mag_angle), mag_r * sin(mag_angle)];
cover_x1 = motor_c.x + motor_dir * motor_cover[1];      // the cover's end
// boards: the ULN2003 board left of the cover, the Nano behind the motor,
// both in front of the carrier
uln_x0 = cover_x1 - board_gap - uln_board.x;
car_x0 = uln_x0 - 1;
nano_x = cover_x1 + nano_rail_hw;   // its middle; along z, USB down
car_x1 = nano_x + nano_rail_hw + 1;
car_h = max(uln_board.y, nano_board.y + 3) + 4;
y_car0 = y_back1 + motor_flange_t + motor_h + 1 + nano_under + nano_t + nano_usb[1];   // the carrier plate
y_car1 = y_car0 + car_t;
uln_holes = [for (x = [0, 1], z = [-1, 1])
   [uln_x0 + uln_hole_in + x * (uln_board.x - 2 * uln_hole_in), z * (uln_board.y / 2 - uln_hole_in)]];
// the right posts beside the Nano, as low as the motor's body and the motor gear (the screw heads) let them
post_x = car_x1 + car_post_d / 2;
post_z = ceil(sqrt(max(0, pow(motor_d / 2 + car_post_d / 2 + 1, 2) - pow(post_x - motor_c.x, 2),
                          pow(gear_ra + csk_d / 2 + 0.5, 2) - pow(post_x - drive_a, 2))));
car_screws = [for (s = [-1, 1]) each [[uln_x0 + uln_board.x / 2, s * (uln_board.y / 2 + 1 + car_post_d / 2)],
                                       [post_x, s * post_z]]];
instrument_depth = y_car1 - y_sheet1;         // behind the sheet's back (the frame's inst_depth)

echo(instrument_depth = instrument_depth, case_depth = depth, drive_a = drive_a,
     face_d = face_d, glass_d = glass_d, axle_in_plate = y_axle1 - y_back0);

// --- Checks ---
assert(window_d + 2 <= rim_id, "The dial's rim shows in the window");
assert(face_d >= window_d + 1, "The face's edge shows in the window");
assert(tube_d / 2 - bore_d / 2 >= 1.2, "The case's tube in the hole too thin");
assert(ear_r - head_d / 2 >= cut_d / 2 + 1, "The front screws' heads hang over the hole");
assert(ear_r - ear_d / 2 >= bore_d / 2 + 2, "Case ears run into the bore");
assert(y_axle1 <= y_back1 - 0.8 && y_axle1 >= y_back0 + 1.5, "The axle does not end in the back plate");
assert(post_r - post_d / 2 >= gear_ra + 1, "The dial's posts run into the needle gear");
for (a = post_angles)
   assert(norm(post_r * [cos(a), sin(a)] - [drive_a, 0]) >= gear_ra + post_d / 2 + 1, "A dial post runs into the motor gear");
assert(y_shaft_end <= y_gear0 && y_shaft_end + flat_len >= y_gear1 - 0.5, "The motor's shaft (its flats) does not reach through the gear");
assert(y_shaft_end >= y_sheet1 + 2, "The motor's shaft runs into the sheet");
for (c = cols) {
   assert(norm(c) >= gear_ra + ear_d / 2 + 1 && norm(c - [drive_a, 0]) >= gear_ra + ear_d / 2 + 1,
          "A case column runs into a gear");
   assert(norm(c) - ear_d / 2 >= bore_d / 2 + 1, "A case column runs into the bore");
}
assert(front_screw - sheet_t + back_screw - back_t + 1 <= y_back0 - y_sheet1, "Front and back screws meet in the columns");
assert(mag_r + magnet[0] / 2 + 0.5 <= gear_rf && mag_r - magnet[0] / 2 >= shaft_d / 2 + 2, "Magnet does not fit the motor gear");
assert(gear_t - magnet[1] - 0.1 >= 1, "Magnet pocket too deep for the gear");
assert(gear_gap + 0.1 <= magnet_gap_max, "Magnet too far from the sensor");
assert(norm(sensor_c - motor_c) >= motor_d / 2 + 2 && min([for (e = ears) norm(sensor_c - e)]) >= nut[0] / 2 + sensor.x / 2 + 2,
       "Sensor's legs run into the motor or its ear screws");
assert(norm(sensor_c - [drive_a, 0]) + sensor.z / 2 + 3 <= arm_r + 1, "Sensor off the back plate");
assert(norm(nano_board) <= 2 * car_h, "Nano carrier too small");
assert(drive_a + gear_ra + 1 + wall <= case_r + 1.5, "Motor gear bulges out of the case");
// the motor's shaft end in a pocket in the dial's back
assert(y_shaft_end - 0.3 - y_dial0 >= 0.6, "Motor's shaft too close to the face");
for (e = ears) {
   assert(norm(e) + csk_d / 2 <= bore_d / 2 - 1, "Motor ear screws off the back plate");
   assert(norm(e) >= gear_ra + nut[0] / 2 + 1, "Motor ear nuts on the axle's bearing");
}
assert(cover_x1 >= -bore_d / 2 + 2, "Motor's cover off the back plate");
for (s = car_screws) {
   assert(norm(s - motor_c) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into the motor");
   assert(min([for (e = ears) norm(s - e)]) >= motor_ear_w / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
   assert(norm(s - [drive_a, 0]) >= gear_ra + csk_d / 2 + 0.4 && norm(s) >= gear_ra + csk_d / 2 + 0.5,
          "A carrier screw's head under a gear");
   assert(norm(s - sensor_c) >= car_post_d / 2 + sensor.x / 2 + 1.5, "A carrier post runs into the sensor's legs");
   assert(norm(s) + csk_d / 2 <= bore_d / 2 - 1, "A carrier screw off the back plate");
   assert(min([for (a = post_angles) norm(s - post_r * [cos(a), sin(a)])]) >= post_d / 2 + csk_d / 2 + 1,
          "A carrier screw runs into a dial post");
   assert(s.x - car_post_d / 2 >= car_x1 - 1 || s.x + car_post_d / 2 <= car_x0 + 1
          || abs(s.y) - car_post_d / 2 >= uln_board.y / 2 + 0.5, "A carrier post runs into the ULN2003 board");
}
assert(y_car0 - y_back1 - motor_flange_t - motor_h >= nano_under + nano_t + nano_usb[1] + 0.9, "Nano runs into the motor");
assert(y_car0 - uln_standoff - uln_t - uln_parts >= y_back1 + 1, "ULN2003 board's parts run into the back plate");
assert(uln_x0 + uln_board.x + 1 <= cover_x1, "ULN2003 board runs into the motor's cover");
// between the six-pack's neighbours (they are as big), clear of the case screws' heads
assert(max(abs(car_x0), post_x + car_post_d / 2, car_x1) <= inst_pitch.x / 2 - 1 && car_h / 2 <= inst_pitch.y / 2 - 1,
       "Board carrier runs into the next instrument");
for (i = [0 : 3]) let(c = cols[i], q = [min(max(c.x, car_x0), car_x1), min(max(c.y, -car_h / 2), car_h / 2)])
   assert(norm(c - q) >= csk_d / 2 + 2, "Board carrier over a case screw");

// --- The carriers side by side (frame/): behind the cases, neighbours' board carriers share the width between their
// axes. Each carrier's place, x from its own axis, is here; each instrument checks that its carrier is in it
// (carrier_in_slot()), and here the neighbours are checked against each other (as if all were as deep). A new
// instrument in a row gets its place here. ---
inst_rows = [["TC", "HI", "VSI", "NAV 1"], ["ASI", "AI", "ALT", "NAV 2"]];   // the frame's inst_names, the lower row first
inst_col_x = [-inst_pitch.x, 0, inst_pitch.x, inst_pitch.x + nav_dx];
car_slot_gap = 1;            // between two neighbours' places
std_car_x = [car_x0, max(car_x1, post_x + car_post_d / 2)];   // the standard's carrier
carrier_slots = [["ASI", std_car_x], ["VSI", std_car_x],      // the standard
                 ["TC", [-48, 42.7]],                         // tc.scad (tc_car_x), shifted left
                 ["HI", [-45.2, 45.2]],                       // hi.scad (twin_car_x)
                 ["AI", [-39, 39]],                           // ai.scad (car_box)
                 ["ALT", [-39, 39]]];                         // alt.scad (car_box)
function carrier_slot(name) = [for (s = carrier_slots) if (s[0] == name) s[1]][0];

for (row = inst_rows, i = [0 : len(row) - 2]) let(a = carrier_slot(row[i]), b = carrier_slot(row[i + 1]))
   if (a != undef && b != undef)
      assert(a[1] + car_slot_gap <= inst_col_x[i + 1] - inst_col_x[i] + b[0], str(row[i], "'s carrier runs into ", row[i + 1], "'s"));

// the instrument's carrier, from x[0] to x[1] (from its axis), in its place
module carrier_in_slot(name, x) {
   s = carrier_slot(name);
   assert(s != undef, str("No carrier place for ", name));
   assert(x[0] >= s[0] && x[1] <= s[1], str(name, "'s carrier off its place (carrier_slots)"));
}

// --- Helpers ---
function pol(r, a) = [r * sin(a), r * cos(a)];        // a: clockwise from 12 o'clock, as on the face

// along y, from y0 to y1, a 2D shape in x (right) and z (up)
module along_y(y0, y1) {
   translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}

module csk_hole(depth_ = 20) {
   // countersunk from z = 0 into -z
   translate([0, 0, -depth_]) cylinder(d = clear_d, h = depth_ + 0.01);
   translate([0, 0, -(csk_d - clear_d) / 2]) cylinder(d1 = clear_d, d2 = csk_d, h = (csk_d - clear_d) / 2 + 0.01);
   cylinder(d = csk_d, h = 5);
}

module double_d(d, flat, h) {
   intersection() {
      cylinder(d = d, h = h);
      translate([-d / 2, -flat / 2, 0]) cube([d, flat, h]);
   }
}

// Involute spur gear, 20 degree pressure angle; play thins the teeth
module gear_2d(z, m = gear_m, play = gear_play) {
   rp = m * z / 2;
   rb = rp * cos(20);
   ra = rp + m;
   rf = rp - 1.25 * m;
   tmax = sqrt(ra * ra / (rb * rb) - 1);
   hb = 90 / z + (tan(20) - 20 * PI / 180) * 180 / PI - play / 2 / rp * 180 / PI;   // half tooth on the base circle
   flank = [for (i = [0 : 12]) let(t = tmax * i / 12) [rb * sqrt(1 + t * t), hb - (t - atan(t) * PI / 180) * 180 / PI]];
   circle(r = max(rf, rb - 0.01), $fn = 4 * z);
   for (k = [0 : z - 1]) rotate(k * 360 / z)
      polygon(concat([[0, 0]],
                     [for (p = flank) p[0] * [cos(-p[1]), sin(-p[1])]],
                     [for (i = [len(flank) - 1 : -1 : 0]) flank[i][0] * [cos(flank[i][1]), sin(flank[i][1])]]));
}

// The instruments with mechanisms of their own (ai, alt, hi, tc) share these

// a gear's tip and root radius
function g_ra(z, m) = m * z / 2 + m;
function g_rf(z, m) = m * z / 2 - 1.25 * m;
// a motor m = [its shaft [x, z], the direction of its body from it]: the body's middle, a unit vector across, its ears
function m_body(m) = m[0] + motor_shaft_dy * m[1];
function m_perp(m) = [m[1].y, -m[1].x];
function m_ears(m) = [for (s = [-1, 1]) m_body(m) + s * motor_ear_dx * m_perp(m)];
// clear of a motor's wire cover: a circle of radius r at p
function clear_cover(m, p, r) = let(d = p - m_body(m), t = d * m[1], s = d * m_perp(m))
   t >= motor_cover[1] + r || t <= -r || abs(s) >= motor_cover[0] / 2 + r;
// the cover's four corners
function cover_pts(m) = [for (t = [0, motor_cover[1]], s = [-1, 1]) m_body(m) + t * m[1] + s * motor_cover[0] / 2 * m_perp(m)];

// along y from y0 to y1, a 2D shape at p ([x, z])
module along_xz(p, y0, y1) {
   along_y(y0, y1) translate(p) children();
}

// motor m's flange on y = yf, its body behind it
module motor_at(m, yf) {
   translate([m[0].x, yf, m[0].y]) rotate([0, atan2(m[1].x, m[1].y), 0]) rotate([90, 0, 0]) motor_local();
}

// internal ring gear, teeth inward, out to radius ro
module ring_gear_2d(z, m, ro) {
   difference() {
      circle(r = ro, $fn = 4 * z);
      gear_2d(z, m, -gear_play);
      circle(r = m * z / 2 - m, $fn = 4 * z);
   }
}

// sensor: flat face towards -y at y, legs out along z (s: up or down) to the back,
// their slot narrower than the body, so it stays centred at p
module sensor_pocket(p, y, s, depth = back_t) {
   translate([p.x - sensor.x / 2 - 0.15, y - 0.01, p.y - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
   translate([p.x - sensor_legs_w / 2, y - 1, s > 0 ? p.y + sensor.z / 2 - 1 : p.y - sensor.z / 2 - 1.5]) cube([sensor_legs_w, depth + 2, 2.5]);
}

// --- Outlines, x right, z up ---
module case_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (c = [for (i = [0 : 3]) cols[i]]) translate(c) circle(d = ear_d);
   }
   hull() {
      circle(d = case_d, $fn = 180);
      translate([drive_a, 0]) circle(r = arm_r, $fn = 120);
      for (c = cols) if (c.x > 0) translate(c) circle(d = ear_d);
   }
}


// --- Case: the tube in the hole with the lip, the body behind the sheet ---
module case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_back0) case_outline();
      }
      // window, glass and dial
      along_y(-1, y_glass0 + 0.01) circle(d = window_d, $fn = 180);
      along_y(y_glass0, y_back0 + 1) circle(d = bore_d, $fn = 180);
      // the motor gear, open towards the sheet: no bridge to print over it
      along_y(y_sheet1 - 0.01, y_back0 + 1) translate([drive_a, 0]) circle(r = gear_ra + 1, $fn = 120);
      // screws from the front (the ears) and from behind (all columns)
      for (i = [0 : len(cols) - 1]) {
         c = cols[i];
         if (i < 4) translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
         translate([c.x, y_back0 + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
      }
   }
}

// --- Dial: a disc with a rim forward to the glass, the face glued in ---
module dial() {
   difference() {
      union() {
         along_y(y_dial0, y_dial1) circle(d = rim_od, $fn = 180);
         along_y(y_glass1, y_dial0 + 0.01) difference() {
            circle(d = rim_od, $fn = 180);
            circle(d = rim_id, $fn = 180);
         }
      }
      along_y(y_dial0 - 1, y_dial1 + 1) circle(d = axle[0] + 0.3);
      // the motor's shaft end
      if (drive_a - shaft_d < rim_od / 2) along_y(y_shaft_end - 0.3, y_dial1 + 1) translate([drive_a, 0]) circle(d = shaft_d + 1);
   }
}

// --- Needle: white blade, hub behind it, pressed onto the axle ---
module needle_2d() {
   hull() {
      circle(d = hub_d);
      translate([0, needle_len - needle_w[1] / 2]) circle(d = needle_w[1]);
   }
   hull() {
      translate([-needle_w[0] / 2, -needle_tail]) square([needle_w[0], 1]);
      circle(d = needle_w[0]);
   }
}

// pointing at a (clockwise from 12 o'clock, seen from the front)
module needle(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_needle0, y_needle1) needle_2d();
         along_y(y_needle1 - 0.01, y_needle1 + hub_h) circle(d = hub_d);
      }
      along_y(y_axle0, y_needle1 + hub_h + 1) circle(d = axle[0] - 0.1);
   }
}

// --- Gears ---
module needle_gear(a = 0) {
   rotate([0, a, 0]) difference() {
      along_y(y_gear0, y_gear1) gear_2d(gear_z);
      along_y(y_gear0 - 1, y_gear1 + 1) circle(d = axle[0] - 0.1);
   }
}

module motor_gear(a = 0) {
   translate([drive_a, 0, 0]) rotate([0, a, 0]) difference() {
      // a gap faces the needle gear's tooth (turned half a tooth if even)
      along_y(y_gear0, y_gear1) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
      // the shaft, on its flats
      translate([0, y_gear1 + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y_gear1 + 1 - y_gear0 + 1);
      // magnet in the back face
      translate([mag_r * cos(mag_angle), y_gear1 + 0.01, mag_r * sin(mag_angle)]) rotate([90, 0, 0])
         cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

// --- Back plate: the axle's bearing, the dial's posts, the motor, the sensor ---
module back_plate() {
   difference() {
      union() {
         along_y(y_back0, y_back1) case_outline();
         for (a = post_angles) translate([post_r * cos(a), y_dial1, post_r * sin(a)]) rotate([-90, 0, 0])
            cylinder(d = post_d, h = y_back0 - y_dial1 + 0.01);
      }
      // the axle, blind
      translate([0, y_back0 - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = axle[0] + 0.1, h = back_t - 0.8);
      // into the case's columns, countersunk from behind
      for (c = cols) translate([c.x, y_back1, c.y]) rotate([-90, 0, 0]) csk_hole();
      // motor: its boss, the ears (countersunk from the front, nuts behind the ears)
      translate([drive_a, y_back0 - 1, 0]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
      for (e = ears) translate([e.x, y_back0, e.y]) rotate([90, 0, 0]) csk_hole();
      // sensor: flat face forward in a pocket, its legs through a slot to the back
      sensor_pocket(sensor_c, y_back0, 1);
      // the board carrier's screws, from the front into its posts
      for (s = car_screws) translate([s.x, y_back0, s.y]) rotate([90, 0, 0]) csk_hole();
   }
}

// --- Board carrier: the ULN2003 board on standoffs, the Nano in rails (USB down) ---
// Drawn with the plate's board side at y = 0, the boards towards +y;
// on_carrier() puts it in place behind the motor, the boards facing forward.
module on_carrier() {
   translate([0, y_car0, 0]) mirror([0, 1, 0]) children();
}

module carrier_outline() {
   hull() {
      translate([car_x0, -car_h / 2]) square([car_x1 - car_x0, car_h]);
      for (s = car_screws) translate(s) circle(d = car_post_d);
   }
}

module carrier() {
   post_h = y_car0 - y_back1;
   on_carrier() difference() {
      union() {
         along_y(-car_t, 0) carrier_outline();
         for (h = uln_holes) translate([h.x, -0.01, h.y]) rotate([-90, 0, 0]) cylinder(d = uln_standoff_d, h = uln_standoff + 0.01);
         // Nano rails (lib/nano.inc.scad), a stop at the top end; it slides
         // in from below, USB end last
         on_board_plate([nano_x, 0], 0, "down")
            nano_rails(y1 = nano_board.y / 2 + 1, far_stop = true);
         // the posts to the back plate
         for (s = car_screws) translate([s.x, -0.01, s.y]) rotate([-90, 0, 0]) cylinder(d = car_post_d, h = post_h + 0.01);
      }
      for (h = uln_holes) translate([h.x, -1, h.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = uln_standoff + 2);
      for (s = car_screws) translate([s.x, post_h - back_screw + back_t - 1, s.y]) rotate([-90, 0, 0])
         cylinder(d = pilot_d, h = back_screw - back_t + 2);
   }
}

// in print orientation: the plate down
module carrier_print() {
   translate([0, 0, y_car1]) rotate([-90, 0, 0]) carrier();
}

// --- Face: colour layers ---
// The Makefile sets print_color to the layer it renders; "" draws all of
// them. $ink picks one layer in the views.
print_color = "";
$ink = "";

module ink(c) {
   if ($ink == "" ? (print_color == "" || print_color == c) : $ink == c) color(c) children();
}

// ring segment from a0 to a1 (clockwise from 12 o'clock)
module arc_2d(r0, r1, a0, a1) {
   n = max(2, ceil(abs(a1 - a0) / 2));
   polygon(concat([for (i = [0 : n]) pol(r1, a0 + (a1 - a0) * i / n)],
                  [for (i = [n : -1 : 0]) pol(r0, a0 + (a1 - a0) * i / n)]));
}

module tick_2d(a, r0, r1, w) {
   rotate(-a) translate([-w / 2, r0]) square([w, r1 - r0]);
}

// The page: copies of the face (children, a 2D face of face_d drawn with
// ink()), a cut template for the glass, the caption, and registration
// dots in every layer
module print_page(title) {
   step = face_d + print_gap;
   w = print_copies * step + glass_d;
   for (i = [0 : print_copies - 1]) translate([i * step, 0]) children();
   translate([print_copies * step + glass_d / 2 - face_d / 2, 0]) ink("black") difference() {
      circle(d = glass_d + 0.6, $fn = 180);
      circle(d = glass_d, $fn = 180);
   }
   translate([-face_d / 2, -face_d / 2 - 8]) ink("black")
      text(str(title, ": face ", face_d, " mm, glass ", glass_d, " mm (cut on the line's inside), print at 100 %"),
           size = 3, font = font);
   for (x = [-face_d / 2 - 2, w - face_d / 2 + 2], y = [-face_d / 2 - 11, glass_d / 2 + 2])
      translate([x, y]) square(0.1, center = true);
}

// --- View only ---
c_case = "#1d1f22";
c_steel = "#b9c0c8";
c_board = "#1d4fa0";
c_glass = [0.75, 0.85, 0.95, 0.15];
c_sheet = "#2a2d31";
c_needle = "#f4f4f4";
c_magnet = "#8a8f96";

// the face's layers (colours in the print's order), just in front of the dial
// (the colour on the 3D layer: linear_extrude drops a 2D shape's colour)
module face_part(colors) {
   for (i = [0 : len(colors) - 1])
      color(colors[i]) translate([0, y_face - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = colors[i]) children();
}

module motor_part() {
   translate([drive_a, y_back1, 0]) rotate([0, motor_dir > 0 ? 0 : 180, 0]) rotate([0, 90, 0]) rotate([90, 0, 0]) motor_local();
}

module carrier_uln_part() {
   on_carrier() on_board_plate([uln_x0 + uln_board.x / 2, 0], 0, "up") uln_part();
}

module carrier_nano_part() {
   on_carrier() on_board_plate([nano_x, 0], 0, "down") nano_part(c_board);
}

module sensor_part() {
   color("#202020") translate([sensor_c.x - sensor.x / 2, y_back0, sensor_c.y - sensor.z / 2]) cube([sensor.x, sensor.y, sensor.z]);
}

module magnet_part(a) {
   translate([drive_a, 0, 0]) rotate([0, a, 0]) color(c_magnet)
      translate([mag_r * cos(mag_angle), y_gear1, mag_r * sin(mag_angle)]) rotate([90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
}

module axle_part(a) {
   color(c_steel) translate([0, y_axle0, 0]) rotate([-90, 0, 0]) cylinder(d = axle[0], h = axle[1]);
}

module glass_part() {
   color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
}

// a piece of the sheet round the hole, with the screws
module sheet_part(w = 230, h = 120, x0 = -75) {
   color(c_sheet) along_y(0, sheet_t) difference() {
      translate([x0, -h / 2]) square([w, h]);
      circle(d = cut_d, $fn = 180);
      for (i = [0 : 3]) translate(cols[i]) circle(d = clear_d);
   }
   color("#111111") for (i = [0 : 3]) translate([cols[i].x, 0, cols[i].y]) rotate([90, 0, 0]) cylinder(d = head_d, h = 1.65);
}


// All parts; a: the needle's angle; e: apart by this; face: the 2D face (children)
module instrument_parts(a, colors, e = 0, with_case = true, with_back = true) {
   translate([0, 4 * e, 0]) {
      if (with_back) color(c_case) back_plate();
      motor_part();
      sensor_part();
   }
   translate([0, 5.5 * e, 0]) {
      color(c_case) carrier();
      carrier_uln_part();
      carrier_nano_part();
   }
   translate([0, 2.5 * e, 0]) {
      color(c_case) render() needle_gear(a);
      color(c_case) render() motor_gear(-a);
      magnet_part(-a);
      axle_part();
   }
   translate([0, e, 0]) {
      color(c_case) dial();
      face_part(colors) children();
   }
   color(c_needle) render() needle(a);
   if (with_case) translate([0, -e, 0]) {
      color(c_case) case();
      glass_part();
   }
}
