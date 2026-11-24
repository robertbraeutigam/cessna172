// Turn coordinator on two 28BYJ-48 steppers
//
// The six-pack's bottom left instrument (frame/): left of the heading
// indicator, under the airspeed indicator. It has the standard
// instrument's case front (instrument.inc.scad: the hole, the lip, the
// glass, four screws on the diagonals), like the 172N's, and no knob.
//
// What you see, front to back:
// - the white airplane (seen from behind: wings, round fuselage, fin),
//   banking with the turn rate; wings level at the marks at 9 and
//   3 o'clock, a standard rate turn (2 minutes) at the L and R marks
//   under them (rate_a);
// - the face: TURN COORDINATOR, D.C. ELEC., 2 MIN., NO PITCH
//   INFORMATION, white on black, and the inclinometer's tube: a curved
//   slot through the face (round the axis, under it) with the two black
//   wires across its middle (bridges of the face plate);
// - the black ball in the tube: printed on a white paper ring on the
//   ball disc behind the face, which turns round the axis, so the ball
//   runs along the slot's curve.
//
// What moves:
// - The airplane is pressed onto a 3 mm steel axle; its gear (layer y_g,
//   next to the back plate) is turned 1:1 by motor A's, like the
//   standard's needle. The magnet in A's gear homes it.
// - The ball disc turns on the dial's hub; an internal ring gear on its
//   back (80 teeth) is turned by motor B's pinion (16 teeth, 5 motor
//   turns a disc turn), the heading indicator's bug drive. The magnet is
//   in the ball disc, the sensor in the dial's front: one home a turn
//   (the disc turns round to home, the ball out of sight behind the face).
//
// The two motors lie side by side on the back plate's back, their bodies
// slanted so that their wire covers pass each other, as in the heading
// indicator. A board carrier on four posts behind them holds two ULN2003
// boards and the Arduino Nano (MobiFlight, its own USB cable, the jack
// up), facing back, shifted left of the axis to keep off the heading
// indicator's carrier. That part is deeper than the standard (tc_depth
// echo), but it is above tc_deep_z (from the axis); under it (the case
// and the back plate) the instrument is as shallow as tc_low_depth: the
// force feedback yoke's housing is under the TC's lower edge (the frame
// checks both).
//
// Parts (printed): the case (back side down), the face plate (back
// down), the ball disc (front down), the dial (back down), the axle
// gear, motor gear A, the pinion (on its teeth), the back plate (front
// down), the carrier (front down), black; the airplane (front down),
// white.
//
// Parts to buy:
// - 2 x 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and
//   a mini USB cable, 2 x A3144 hall sensor, 2 x disc magnet 6 x 3 mm
// - 3 mm steel dowel pin, 20 mm (tc_axle_len)
// - clear sheet 1 mm (glass), the face and the ball ring printed on
//   photo paper
// - M3 x 8 button head, black (4, through the sheet into the case),
//   M3 x 8 countersunk self tapping (3, back plate into the case; 4, the
//   carrier onto the back plate's posts), M3 x 8 countersunk + nut (4,
//   motor ears), M3 x 6 self tapping (8, ULN2003 boards)
//
// Assembly: see the README.
//
// Coordinates as in instrument.inc.scad: x to the right, y away from the
// pilot, z up, the origin on the axis at the sheet's front face.

$fn = 60;

include <instrument.inc.scad>

// Preview: the airplane's bank (degrees, right wing down), the ball (degrees, to the right), the parts apart by explode
view_roll = 20;
view_ball = -8;
explode = 25;

// --- Face ---
rate_a = 20;                 // the standard rate marks under the wings level marks (the airplane's bank at a 2 minute turn)
mark = [30.5, 35, 1.6];      // the marks: from, to, width
lr = [31, 11, 3.6];          // L and R: from the axis, past the rate mark (degrees), size
ball_r = 21;                 // the ball's path (the tube's middle) round the axis
ball_d = 6;
slot_h = 7.2;                // the tube's width (the slot)
slot_a = 32;                 // its ends' middles from 6 o'clock: the ball's travel either way
wire_w = 0.8;                // the two wires across the tube (bridges of the face plate)
wire_gap = 0.5;              // the centred ball to each wire
tube_rim = [0.15, 0.8];      // the tube's white rim on the face: from the slot's edge (a black cut line), to
// the words: text, size, y of the middle
words = [["TURN COORDINATOR", 2.6, 24], ["D.C. ELEC.", 1.8, 19.8], ["2 MIN.", 2.6, -10.5],
         ["NO PITCH", 1.8, -28.4], ["INFORMATION", 1.8, -31.2]];
ball_paper = [ball_r - 6, ball_r + 6];   // the ball ring: inner and outer radius
// the airplane (white, on the axle): span, wing root and tip width, fuselage diameter, fin height and width at its base and top,
// tail plane span and width (at the fin's base)
plane = [57, 2.6, 1.4, 7.5, 10.5, 2.6, 1, 11, 1.2];
plane_gap = 1.5;             // the glass to the airplane
// colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_white = "white";
face_colors = [c_black, c_white];

// --- Face plate, ball disc, dial ---
fp_t = 1.2;                  // the face plate (the paper on its front)
key = [3, 0.8];              // the dial rim's lug into the face plate's notch: width, height
tc_axle_len = 20;            // the 3 mm steel dowel pin, MEASURE
bd_t = 1.2;                  // the ball disc's plate (the ball ring's paper on it)
rm = 0.8;                    // module of the ball's gears (the heading indicator's bug's)
z_ring = 80;                 // the ball disc's internal ring
z_pin = 16;                  // motor B's pinion
ring_t = 3;
ring_wall = 1.2;             // outside the ring's roots
r_play = 0.2;                // the pinion off the ring: its tips off the ring's roots
dhub_d = 12;                 // the dial's hub, the ball disc turns on it
sleeve_w = 1.5;              // the ball disc's sleeve round it
bmag = [11, 0];              // the ball's magnet: radius, angle (clockwise from 12 o'clock, on the disc with the ball centred)
bsens_out = 19;              // the ball sensor's legs: along a groove out to here, then back
dp_t = 2.5;                  // the dial's plate
pin_hub = 4.5;               // the pinion's hub (radius)

// --- Motors: shaft [x, z], the body's direction from it (the heading indicator's) ---
mA = [[drive_a, 0], [cos(160), sin(160)]];          // the airplane (the standard's place, 1:1)
b_drive = rm * (z_ring - z_pin) / 2 - r_play;       // the pinion from the axis, in the ring
mB = [[-b_drive, 0], [cos(-20), sin(-20)]];         // the ball

// --- Screws: four through the sheet (the diagonals), three from the back plate ---
front_cols = cols;
back_cols = [cols[0], cols[1], [0, -ear_r]];

// --- Board carrier: on the back plate's posts behind the motors, the boards facing back ---
tc_posts = [[34, 14], [32, -12], [-32, 18], [-34, -14]];
uln_r = [uln_board.y, uln_board.x];   // the ULN2003 boards turned upright
tc_nano_x = -2.5;             // the Nano's middle, along z, the USB jack up (left of the axis: the HI's carrier is right)
tc_car_z = [-24, 24];        // the carrier plate's bottom and top
usb_plug = 20;               // the plug over the Nano's end (a straight mini USB plug, then the cable bends back)
hi_car_x0 = -45.1;           // the heading indicator's carrier's left edge from its axis (hi.scad's hi_car_x[0], keep in sync)

// --- Calculated ---
function g_ra(z, m) = m * z / 2 + m;
function g_rf(z, m) = m * z / 2 - 1.25 * m;
function m_body(m) = m[0] + motor_shaft_dy * m[1];
function m_perp(m) = [m[1].y, -m[1].x];
function m_ears(m) = [for (s = [-1, 1]) m_body(m) + s * motor_ear_dx * m_perp(m)];
// clear of a motor's wire cover: a circle of radius r at p
function clear_cover(m, p, r) = let(d = p - m_body(m), t = d * m[1], s = d * m_perp(m))
   t >= motor_cover[1] + r || t <= -r || abs(s) >= motor_cover[0] / 2 + r;
// the cover's four corners
function cover_pts(m) = [for (t = [0, motor_cover[1]], s = [-1, 1]) m_body(m) + t * m[1] + s * motor_cover[0] / 2 * m_perp(m)];
function plane_a(r) = r;                            // the airplane: clockwise from 12 o'clock, right wing down
function ball_a(b) = -b;                            // the ball disc: the ball to the right turns it counter clockwise
function text_w(s, size) = 0.78 * size * len(s);    // a word's width, about (Liberation Sans Bold)

ring_R = rm * z_ring / 2;
bd_r = ring_R + 1.25 * rm + ring_wall;              // the ball disc
bsens_hole = pol(bsens_out, bmag[1]);
wire_da = (ball_d / 2 + wire_gap + wire_w / 2) / ball_r * 180 / PI;   // the wires from 6 o'clock (degrees)
uln_xz = [[tc_nano_x + nano_rail_hw + 1.5, tc_car_z[0] + 1],           // A (airplane), right
          [tc_nano_x - nano_rail_hw - 1.5 - uln_r.x, tc_car_z[0] + 1]]; // B (ball), left
uln_holes_a = [for (b = uln_xz, i = [0, 1], j = [0, 1])
   [b.x + uln_hole_in + i * (uln_r.x - 2 * uln_hole_in), b.y + uln_hole_in + j * (uln_r.y - 2 * uln_hole_in)]];
nano_z0 = tc_car_z[0] + 2;                          // the Nano's bottom end (on the stop)
nano_zc = nano_z0 + nano_board.y / 2;               // its middle
tc_car_x = [uln_xz[1].x - 1, uln_xz[0].x + uln_r.x + 1];

// y, front to back
y_pl = [y_glass1 + plane_gap, y_glass1 + plane_gap + needle_t];   // the airplane's blade
y_ph = y_pl[1] + hub_h;                             // its hub's end
y_fc = y_ph + hub_gap;                              // the face's paper
y_f = [y_fc + paper_t, y_fc + paper_t + fp_t];      // the face plate
y_bd = y_f[1] + 0.3;                                // the ball ring's paper
y_b = [y_bd + paper_t, y_bd + paper_t + bd_t, y_bd + paper_t + bd_t + ring_t];   // the ball disc: plate, ring's back
y_dh = y_f[1];                                      // the dial's hub's front, under the face plate's middle
y_d = [y_b[2] + 0.3, y_b[2] + 0.3 + dp_t];          // the dial's plate
y_pn = [y_b[1] + 0.3, y_b[2] - 0.2];                // the pinion's teeth
y_g = [y_d[1] + gear_gap, y_d[1] + gear_gap + gear_t];   // the airplane's gears
y_p = [y_g[1] + gear_gap, y_g[1] + gear_gap + back_t];   // the back plate, the case's back
y_sh = y_p[1] - shaft_len;                          // the motors' shafts' ends
y_mb = y_p[1] + motor_flange_t + motor_h;           // their bodies' backs
y_k = [y_mb + 1, y_mb + 1 + car_t];                 // the carrier
y_ax = [y_pl[0] + needle_skin, y_pl[0] + needle_skin + tc_axle_len];
tc_depth = y_k[1] + max(uln_standoff + uln_t + uln_parts, nano_under + nano_t + nano_usb[1]) - y_sheet1;
tc_low_depth = y_p[1] - y_sheet1;                   // under tc_deep_z
tc_deep_z = min(concat([tc_car_z[0]], [for (m = [mA, mB]) m_body(m).y - motor_d / 2],
                       [for (m = [mA, mB], e = m_ears(m)) e.y - motor_ear_w / 2],
                       [for (m = [mA, mB], p = cover_pts(m)) p.y]));
ring_ratio = z_ring / z_pin;

echo(tc_depth = tc_depth, tc_low_depth = tc_low_depth, tc_deep_z = tc_deep_z, case_depth = y_p[1] - y_sheet1,
     ball_ratio = ring_ratio, steps_plane = 2038, steps_ball = 2038 * ring_ratio, tc_car_x = tc_car_x,
     gear_from_end = y_ax[1] - y_g[1]);

// --- Checks ---
// the face
assert(plane[0] / 2 <= mark[0] - 1, "The airplane's wings run over the marks");
assert(mark[1] <= window_d / 2 - 0.5, "The marks off the window");
assert(lr[0] + lr[2] * 0.6 <= window_d / 2 - 0.5 && lr[0] - lr[2] * 0.6 >= plane[0] / 2 - 3, "L or R off the window");
let(t = pol(ball_r, 180 + slot_a)) assert(norm(pol(lr[0], 270 - rate_a - lr[1]) - t) >= lr[2] / 2 + slot_h / 2 + 2, "L runs into the tube");
assert(slot_h >= ball_d + 0.6, "The ball does not fit the tube");
assert(ball_r + slot_h / 2 + tube_rim[1] <= face_d / 2 - 3, "The tube too close to the face's edge");
assert(ball_r - slot_h / 2 - tube_rim[1] >= plane[3] / 2 + 6, "The tube too close to the airplane's fuselage");
assert(2 * wire_da < slot_a, "The wires do not fit the tube");
for (w = words) let(x = text_w(w[0], w[1]) / 2, y = abs(w[2]) + w[1] / 2)
   assert(norm([x, y]) <= window_d / 2 - 1.5, str(w[0], " off the window"));
// the words under the axis: 2 MIN. over the tube, the rest under it
for (w = words) if (w[2] < 0) let(x = text_w(w[0], w[1]) / 2, near = w[2] + w[1] / 2 > -ball_r)
   assert(near ? norm([x, w[2] - w[1] / 2]) <= ball_r - slot_h / 2 - tube_rim[1] - 1 && w[2] + w[1] / 2 <= -plane[3] / 2 - 1
               : abs(w[2]) - w[1] / 2 >= ball_r + slot_h / 2 + tube_rim[1] + 1,
          str(w[0], " runs into the tube or the airplane"));
assert(ball_paper[0] <= ball_r - slot_h / 2 - 2 && ball_paper[1] >= ball_r + slot_h / 2 + 2, "The ball ring does not fill the tube");
assert(ball_paper[1] <= bd_r && ball_paper[0] >= dhub_d / 2 + sleeve_w + 1, "The ball ring off the ball disc");
// the front stack
assert(y_pl[0] >= y_glass1 + 1, "The airplane against the glass");
assert(y_ax[1] <= y_p[1] - 0.8 && y_ax[1] >= y_p[0] + 1.5, "The axle does not end in the back plate");
assert(bd_r <= rim_id / 2 - 0.4, "The ball disc runs into the dial's rim");
assert(y_d[0] - y_dh >= 2.5, "Dial's hub too short");
assert(dhub_d / 2 - (axle[0] + 0.3) / 2 >= 3, "Dial's hub too thin");
assert(key[1] <= fp_t - 0.3, "The face plate's notch goes through it");
// the ball's gears
assert(b_drive + g_ra(z_pin, rm) + 0.1 <= ring_R + rm, "Pinion hits the ring's roots");
assert(b_drive - g_ra(z_pin, rm) >= bmag[0] + magnet[0] / 2 + 1.5 + 0.5, "Pinion runs into the ball's magnet boss");
assert(b_drive - g_ra(z_pin, rm) >= dhub_d / 2 + 0.15 + sleeve_w + 1, "Pinion runs into the ball disc's sleeve");
assert(y_pn[0] >= y_b[1] + 0.2 && y_pn[1] <= y_b[2], "Pinion off the ring");
assert(y_sh >= y_pn[1] + 0.5 && y_sh + flat_len >= y_g[1] - 0.5, "B's shaft (its flats) does not reach into the pinion's hub");
assert(y_sh <= y_g[0] && y_sh + flat_len >= y_g[1] - 0.5, "A's shaft (its flats) does not reach through its gear");
assert(y_sh >= y_d[0] + 0.5, "A's shaft runs into the ball disc");
assert(g_rf(z_pin, rm) >= pin_hub && pin_hub - shaft_d / 2 >= 1.5, "Pinion's hub");
assert(norm(mB[0]) - pin_hub >= gear_ra + 1.5, "Pinion's hub runs into the airplane's gear");
assert(norm(mB[0] - mA[0]) >= gear_ra + pin_hub + 2, "Pinion's hub runs into A's gear");
assert(bmag[0] - magnet[0] / 2 - 1.5 <= dhub_d / 2 + 0.15 + sleeve_w, "Ball magnet boss off the sleeve");
assert(ring_t - magnet[1] - 0.1 + bd_t >= 1, "Ball magnet pocket too deep");
// the ball's sensor in the dial, its legs in a groove to the hole, through the gear layer and the back plate
assert(dp_t - sensor.y - 0.1 >= 0.5, "Ball sensor pocket too deep for the dial");
assert(norm(bsens_hole) - 1.5 >= gear_ra + 1.5 && norm(bsens_hole - mA[0]) - 1.5 >= gear_ra + 1.5, "Ball sensor's wires run into an airplane gear");
assert(norm(bsens_hole - mB[0]) >= pin_hub + 3, "Ball sensor's wires run into the pinion");
for (m = [mA, mB]) {
   assert(norm(bsens_hole - m_body(m)) >= motor_d / 2 + 1.5 && clear_cover(m, bsens_hole, 1.5), "Ball sensor's wires under a motor");
   for (e = m_ears(m)) assert(norm(bsens_hole - e) >= nut[0] / cos(30) / 2 + 2, "Ball sensor's wires under a motor's ear");
}
// the dial's posts
for (a = post_angles) let(p = post_r * [cos(a), sin(a)]) {
   assert(norm(p - mA[0]) >= gear_ra + post_d / 2 + 1, "A dial post runs into A's gear");
   assert(norm(p - mB[0]) >= pin_hub + post_d / 2 + 1, "A dial post runs into the pinion's hub");
   assert(norm(p - bsens_hole) >= post_d / 2 + 2.5, "A dial post on the ball sensor's wires");
}
// the motors on the back plate
assert(norm(m_body(mA) - m_body(mB)) >= motor_d + 1, "The motors run into each other");
for (i = [0, 1]) let(m = [mA, mB][i], o = [mA, mB][1 - i]) {
   assert(min([for (p = cover_pts(m)) norm(p - m_body(o))]) >= motor_d / 2 + 1, "A motor's cover runs into the other motor");
   for (e = m_ears(m)) {
      assert(norm(e) + csk_d / 2 <= bore_d / 2 - 1, "A motor ear's screw off the back plate");
      assert(norm(e) >= nut[0] / cos(30) / 2 + axle[0] / 2 + 1.5, "A motor's ear nut on the axle");
      assert(norm(e - m_body(o)) >= motor_d / 2 + motor_ear_w / 2 + 0.5 && clear_cover(o, e, motor_ear_w / 2 + 0.5),
             "A motor's ear runs into the other motor");
   }
}
for (p = cover_pts(mA)) assert(clear_cover(mB, p, 1), "The motors' covers run into each other");
for (p = cover_pts(mB)) assert(clear_cover(mA, p, 1), "The motors' covers run into each other");
assert(norm(sensor_c - m_body(mA)) + sensor.z / 2 >= motor_d / 2 + 1.5 && clear_cover(mA, sensor_c, sensor.x),
       "Sensor A's legs run into motor A");
assert(norm(sensor_c - m_body(mB)) >= motor_d / 2 + 3, "Sensor A runs into motor B");
for (c = back_cols) {
   for (m = [mA, mB]) {
      assert(norm(c - m_body(m)) >= motor_d / 2 + csk_d / 2 + 0.5 && clear_cover(m, c, csk_d / 2 + 0.5), "A case screw under a motor");
      for (e = m_ears(m)) assert(norm(c - e) >= motor_ear_w / 2 + csk_d / 2 + 0.5, "A case screw under a motor's ear");
   }
   assert(norm(c - mA[0]) >= gear_ra + ear_d / 2 + 1, "A case column runs into A's gear");
}
// the carrier: posts clear of the motors, boards on it, between the neighbours
for (p = tc_posts) {
   for (m = [mA, mB]) {
      assert(norm(p - m_body(m)) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into a motor");
      for (e = m_ears(m)) assert(norm(p - e) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
      assert(clear_cover(m, p, car_post_d / 2 + 0.5), "A carrier post runs into a motor's cover");
   }
   assert(norm(p - sensor_c) >= car_post_d / 2 + sensor.x / 2 + 1.5, "A carrier post on sensor A's legs");
   assert(norm(p - bsens_hole) >= car_post_d / 2 + 2.5, "A carrier post on the ball sensor's wires");
   for (c = back_cols) assert(norm(p - c) >= car_post_d / 2 + csk_d / 2 + 0.5, "A carrier post on a case screw");
   assert(norm(p) + car_post_d / 2 <= case_r - 0.5, "A carrier post off the back plate");
   assert(p.x - car_post_d / 2 >= tc_car_x[0] && p.x + car_post_d / 2 <= tc_car_x[1] && p.y - car_post_d / 2 >= tc_car_z[0]
          && p.y + car_post_d / 2 <= tc_car_z[1], "A carrier post off the carrier");
   assert(min([for (h = uln_holes_a) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
   assert(abs(p.x - tc_nano_x) - csk_d / 2 >= nano_rail_hw + 1, "A carrier screw under the Nano's rails");
}
for (b = uln_xz) assert(b.y >= tc_car_z[0] + 0.5 && b.y + uln_r.y <= tc_car_z[1] - 0.5, "ULN2003 board off the carrier");
assert(nano_z0 + nano_board.y <= tc_car_z[1] + 1, "Nano off the carrier");
assert(uln_xz[0].x >= tc_nano_x + nano_rail_hw + 1 && uln_xz[1].x + uln_r.x <= tc_nano_x - nano_rail_hw - 1,
       "A ULN2003 board over the Nano's rails");
// the heading indicator is right of it, its carrier as deep as this one; nothing left of the six-pack
assert(tc_car_x[1] <= inst_pitch.x + hi_car_x0 - 1, "Carrier runs into the heading indicator's carrier");
// the airspeed indicator is above: the USB plug stays under its case
assert(nano_z0 + nano_board.y + usb_plug <= inst_pitch.y - case_r - 1, "The USB plug runs into the airspeed indicator");

// --- Helpers ---
module along_xz(p, y0, y1) {
   along_y(y0, y1) translate(p) children();
}

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

// sensor: flat face towards -y at y, legs out along z (s: up or down) to the back
module sensor_pocket(p, y, s, depth = back_t) {
   translate([p.x - sensor.x / 2 - 0.15, y - 0.01, p.y - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
   translate([p.x - sensor.x / 2 - 0.15, y - 1, s > 0 ? p.y + sensor.z / 2 - 1 : p.y - sensor.z / 2 - 1.5]) cube([sensor.x + 0.3, depth + 2, 2.5]);
}

// --- Outlines, x right, z up ---
module tc_back_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (c = back_cols) translate(c) circle(d = ear_d);
   }
   hull() {
      circle(d = case_d, $fn = 180);
      translate(mA[0]) circle(r = arm_r, $fn = 120);
      translate(cols[0]) circle(d = ear_d);
   }
}

module tc_case_outline() {
   tc_back_outline();
   hull() {
      circle(d = case_d, $fn = 180);
      for (c = front_cols) translate(c) circle(d = ear_d);
   }
}

// the tube: a slot round the axis under it, round ends
module slot_2d(grow = 0) {
   r0 = ball_r - slot_h / 2 - grow;
   r1 = ball_r + slot_h / 2 + grow;
   arc_2d(r0, r1, 180 - slot_a, 180 + slot_a);
   for (s = [-1, 1]) translate(pol(ball_r, 180 + s * slot_a)) circle(r = slot_h / 2 + grow, $fn = 48);
}

// --- Case: the standard's front, four screws from the front, three from the back plate ---
module tc_case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_p[0]) tc_case_outline();
      }
      along_y(-1, y_glass0 + 0.01) circle(d = window_d, $fn = 180);
      along_y(y_glass0, y_p[0] + 1) circle(d = bore_d, $fn = 180);
      // motor A's gear, open to the sheet (no bridge)
      along_y(y_sheet1 - 0.01, y_p[0] + 1) translate(mA[0]) circle(r = gear_ra + 1, $fn = 120);
      for (c = front_cols) translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
      for (c = back_cols) translate([c.x, y_p[0] + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
   }
}

// --- Face plate: a cup, its rim forward to the glass, the tube's slot with the two wires, the paper on its front ---
module tc_face_plate() {
   difference() {
      union() {
         along_y(y_f[0], y_f[1]) circle(d = rim_od, $fn = 180);
         along_y(y_glass1, y_f[0] + 0.01) difference() {
            circle(d = rim_od, $fn = 180);
            circle(d = rim_id, $fn = 180);
         }
      }
      along_y(y_f[0] - 1, y_f[1] + 1) difference() {
         slot_2d();
         for (s = [-1, 1]) rotate(-(180 + s * wire_da)) translate([-wire_w / 2, 0]) square([wire_w, 50]);
      }
      along_y(y_f[0] - 1, y_f[1] + 1) circle(d = axle[0] + 0.6);
      // the dial rim's lug, at the top
      along_y(y_f[1] - key[1] - 0.2, y_f[1] + 1) translate([-key[0] / 2 - 0.2, rim_id / 2 - 0.3]) square([key[0] + 0.4, 5]);
   }
}

// --- Ball disc: the plate (the ball ring's paper on it), its sleeve on the dial's hub, the internal ring, the magnet ---
module tc_ball_disc(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_b[0], y_b[1]) circle(r = bd_r, $fn = 180);
         along_y(y_b[1] - 0.01, y_b[2]) ring_gear_2d(z_ring, rm, bd_r);
         along_y(y_b[0], y_b[2]) circle(r = dhub_d / 2 + 0.15 + sleeve_w);
         along_y(y_b[1] - 0.01, y_b[2]) hull() {
            circle(r = dhub_d / 2 + 0.15 + sleeve_w);
            translate(pol(bmag[0], bmag[1])) circle(d = magnet[0] + 3);
         }
      }
      along_y(y_b[0] - 1, y_b[2] + 1) circle(d = dhub_d + 0.3);
      translate([pol(bmag[0], bmag[1]).x, y_b[2] + 0.01, pol(bmag[0], bmag[1]).y]) rotate([90, 0, 0])
         cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
      // a notch in the edge at the magnet: the ball ring's top mark goes there
      along_y(y_b[0] - 1, y_b[1] + 1) translate(pol(bd_r, bmag[1])) rotate(-bmag[1]) rotate(45) square(1.6, center = true);
   }
}

// --- Dial: the plate with a rim forward to the face plate, the hub the ball disc turns on, the ball sensor in its front ---
module tc_dial() {
   difference() {
      union() {
         along_y(y_d[0], y_d[1]) circle(d = rim_od, $fn = 180);
         along_y(y_f[1], y_d[0] + 0.01) difference() {
            circle(d = rim_od, $fn = 180);
            circle(d = rim_id, $fn = 180);
         }
         along_y(y_dh, y_d[0] + 0.01) circle(d = dhub_d);
         // the lug into the face plate's notch, at the top
         along_y(y_f[1] - key[1], y_f[1] + 0.01) intersection() {
            translate([-key[0] / 2, 0]) square([key[0], rim_od]);
            difference() {
               circle(d = rim_od, $fn = 180);
               circle(d = rim_id, $fn = 180);
            }
         }
      }
      along_y(y_dh - 1, y_d[1] + 1) circle(d = axle[0] + 0.3);
      // the pinion's hub and A's shaft end through it
      along_xz(mB[0], y_d[0] - 1, y_d[1] + 1) circle(r = pin_hub + 0.6);
      along_xz(mA[0], y_d[0] - 1, y_d[1] + 1) circle(d = shaft_d + 1.5);
      // the ball's sensor: flat face forward, its legs out in a groove, then back through the hole
      rotate([0, bmag[1], 0]) {
         translate([-sensor.x / 2 - 0.15, y_d[0] - 0.01, bmag[0] - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
         translate([-sensor.x / 2 - 0.15, y_d[0] - 0.01, bmag[0]]) cube([sensor.x + 0.3, 1, bsens_out - bmag[0] + 1]);
         translate([0, y_d[0] - 1, bsens_out]) rotate([-90, 0, 0]) cylinder(d = 3, h = dp_t + 2);
      }
      // the back plate's posts' ends, keying it
      for (a = post_angles) translate([post_r * cos(a), y_d[1] - 1, post_r * sin(a)]) rotate([-90, 0, 0]) cylinder(d = post_d + 0.3, h = 2);
   }
}

// --- Gears: the airplane's (on the axle), A's (the magnet in its back), B's pinion ---
module tc_axle_gear(a = 0) {
   rotate([0, a, 0]) difference() {
      along_y(y_g[0], y_g[1]) gear_2d(gear_z);
      along_y(y_g[0] - 1, y_g[1] + 1) circle(d = axle[0] - 0.1);
   }
}

module tc_motor_gear(a = 0) {
   translate([mA[0].x, 0, mA[0].y]) rotate([0, a, 0]) difference() {
      along_y(y_g[0], y_g[1]) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
      translate([0, y_g[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, gear_t + 2);
      translate([mag_r * cos(mag_angle), y_g[1] + 0.01, mag_r * sin(mag_angle)]) rotate([90, 0, 0])
         cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

module tc_pinion(a = 0) {
   translate([mB[0].x, 0, mB[0].y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_pn[0], y_pn[1]) gear_2d(z_pin, rm);
         along_y(y_pn[1] - 0.01, y_g[1]) circle(r = pin_hub);
      }
      translate([0, y_g[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y_g[1] + 1 - y_sh + 0.3);
   }
}

// --- Back plate: the axle's bearing, the dial's posts, motors A and B, sensor A; the carrier's posts on its back ---
module tc_back_plate() {
   difference() {
      union() {
         along_y(y_p[0], y_p[1]) tc_back_outline();
         for (a = post_angles) translate([post_r * cos(a), y_d[1] - 0.8, post_r * sin(a)]) rotate([-90, 0, 0])
            cylinder(d = post_d, h = y_p[0] - y_d[1] + 0.8 + 0.01);
         for (p = tc_posts) along_xz(p, y_p[1] - 0.01, y_k[0]) circle(d = car_post_d);
      }
      // the axle, blind
      translate([0, y_p[0] - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = axle[0] + 0.1, h = back_t - 0.8);
      for (c = back_cols) translate([c.x, y_p[1], c.y]) rotate([-90, 0, 0]) csk_hole();
      for (m = [mA, mB]) {
         translate([m[0].x, y_p[0] - 1, m[0].y]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
         for (e = m_ears(m)) translate([e.x, y_p[0], e.y]) rotate([90, 0, 0]) csk_hole();
      }
      sensor_pocket(sensor_c, y_p[0], -1);
      // the ball sensor's wires
      along_xz(bsens_hole, y_p[0] - 1, y_p[1] + 1) circle(d = 3);
      for (p = tc_posts) translate([p.x, y_k[0] + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - car_t + 1);
   }
}

// --- Board carrier: the two ULN2003 boards (upright) and the Nano (USB up) on its back ---
module tc_carrier() {
   y1 = y_k[1];
   difference() {
      union() {
         along_y(y_k[0], y1) translate([tc_car_x[0], tc_car_z[0]]) square([tc_car_x[1] - tc_car_x[0], tc_car_z[1] - tc_car_z[0]]);
         for (h = uln_holes_a) along_xz(h, y1 - 0.01, y1 + uln_standoff) circle(d = uln_standoff_d);
         // Nano rails along z (lib/nano.inc.scad), a stop at the bottom end
         on_board_plate([tc_nano_x, nano_zc], y1, "up")
            nano_rails(y1 = tc_car_z[1] - nano_zc, far_stop = true);
      }
      for (h = uln_holes_a) along_xz(h, y1 - 1, y1 + uln_standoff + 1) circle(d = pilot_d);
      for (p = tc_posts) translate([p.x, y1, p.y]) rotate([-90, 0, 0]) csk_hole();
   }
}

// --- Airplane: seen from behind, white, pressed onto the axle's front end; r: its bank, right wing down ---
module plane_2d() {
   circle(d = plane[3]);
   // wings, tapered to the tips
   for (s = [-1, 1]) hull() {
      circle(d = plane[1]);
      translate([s * (plane[0] / 2 - plane[2] / 2), 0]) circle(d = plane[2]);
   }
   // the fin, up from the fuselage, and the tail plane at its base
   hull() {
      translate([-plane[5] / 2, 0]) square([plane[5], 0.1]);
      translate([0, plane[4] - plane[6] / 2]) circle(d = plane[6]);
   }
   hull() for (s = [-1, 1]) translate([s * (plane[7] / 2 - plane[8] / 2), plane[3] / 2 + 0.6]) circle(d = plane[8]);
}

module tc_plane(r = 0) {
   rotate([0, plane_a(r), 0]) difference() {
      union() {
         along_y(y_pl[0], y_pl[1]) plane_2d();
         along_y(y_pl[1] - 0.01, y_ph) circle(d = hub_d);
      }
      along_y(y_ax[0], y_ph + 1) circle(d = axle[0] - 0.1);
   }
}

// --- Prints, 2D: x right, y up, the axis at the origin ---
// the face: the marks, L and R, the words, the tube's rim (cut out the slot on its black line)
module tc_face_2d() {
   ink(c_black) difference() {
      circle(d = face_d, $fn = 180);
      slot_2d();
   }
   ink(c_white) {
      for (a = [90, 90 + rate_a, 270, 270 - rate_a]) tick_2d(a, mark[0], mark[1], mark[2]);
      for (s = [-1, 1]) translate(pol(lr[0], 180 + s * (90 - rate_a - lr[1])))
         text(s > 0 ? "L" : "R", size = lr[2], font = font, halign = "center", valign = "center");
      for (w = words) translate([0, w[2]]) text(w[0], size = w[1], font = font, halign = "center", valign = "center");
      difference() {
         slot_2d(tube_rim[1]);
         slot_2d(tube_rim[0]);
      }
      // the axle's hole, to punch
      circle(d = axle[0] + 0.2);
   }
}

// the ball ring (the ball centred): white (the paper), the black ball at the bottom with a highlight, a mark at the top
module ball_ring_2d() {
   ink(c_black) {
      difference() {
         circle(r = ball_paper[1], $fn = 180);
         circle(r = ball_paper[1] - 0.3, $fn = 180);
      }
      difference() {
         circle(r = ball_paper[0] + 0.3, $fn = 180);
         circle(r = ball_paper[0], $fn = 180);
      }
      translate([0, -ball_r]) circle(d = ball_d, $fn = 48);
      translate([-0.4, ball_paper[1] - 2.5]) square([0.8, 2.5]);
   }
   ink(c_white) translate([-ball_d * 0.17, -ball_r + ball_d * 0.19]) circle(d = ball_d * 0.22, $fn = 24);
}

// the page: two faces and the glass's template on top, two ball rings under them, the caption;
// registration dots in every layer
module tc_print() {
   gap = print_gap;
   fr = face_d / 2;
   br = ball_paper[1];
   row1 = [fr, 3 * fr + gap, 4 * fr + 2 * gap + glass_d / 2];   // the centres
   row2_y = -fr - gap - br;
   row2 = [br, 3 * br + gap];
   w = row1[2] + glass_d / 2 + 0.3;
   for (i = [0, 1]) translate([row1[i], 0]) tc_face_2d();
   for (i = [0, 1]) translate([row2[i], row2_y]) ball_ring_2d();
   ink(c_black) {
      translate([row1[2], 0]) difference() {
         circle(d = glass_d + 0.6, $fn = 180);
         circle(d = glass_d, $fn = 180);
      }
      translate([0, row2_y - br - 7])
         text(str("TC: face ", face_d, " mm (cut out the tube on its black line), ball ring ", 2 * br,
                  " mm: cut on the edges; glass ", glass_d, " mm: cut on the line's inside. Print at 100 %."),
              size = 3, font = font);
   }
   for (x = [-2, w + 2], y = [row2_y - br - 10, fr + 2]) translate([x, y]) square(0.1, center = true);
}

// --- View only ---
module tc_paper_part(y, a, colors) {
   rotate([0, a, 0]) for (i = [0 : len(colors) - 1])
      color(colors[i]) translate([0, y - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = colors[i]) children();
}

module tc_boards_part() {
   for (b = uln_xz) on_board_plate(b + uln_r / 2, y_k[1], "right") uln_part();
   on_board_plate([tc_nano_x, nano_zc], y_k[1], "up") nano_part(c_board);
}

// all parts at bank r, the ball at b; e: apart by this
module tc_parts(r = view_roll, b = view_ball, e = 0, with_case = true) {
   ap = plane_a(r);
   ab = ball_a(b);
   ma = -ap;                                   // motor A turns the other way (1:1)
   mb = ab * ring_ratio;                       // the pinion turns with the ring
   translate([0, -0.4 * e, 0]) {
      color(c_case) render() tc_face_plate();
      tc_paper_part(y_fc, 0, face_colors) tc_face_2d();
   }
   translate([0, 0.8 * e, 0]) {
      color(c_case) render() tc_ball_disc(ab);
      tc_paper_part(y_bd, ab, face_colors) ball_ring_2d();
      rotate([0, ab, 0]) color(c_magnet) translate([pol(bmag[0], bmag[1]).x, y_b[2], pol(bmag[0], bmag[1]).y]) rotate([90, 0, 0])
         cylinder(d = magnet[0], h = magnet[1]);
   }
   translate([0, 1.5 * e, 0]) {
      color(c_case) render() tc_dial();
      color("#202020") rotate([0, bmag[1], 0]) translate([-sensor.x / 2, y_d[0], bmag[0] - sensor.z / 2]) cube(sensor);
   }
   translate([0, 2.2 * e, 0]) {
      color(c_case) render() tc_axle_gear(ap);
      color(c_case) render() tc_motor_gear(ma);
      color(c_case) render() tc_pinion(mb);
      color(c_steel) along_y(y_ax[0], y_ax[1]) circle(d = axle[0]);
      translate([mA[0].x, 0, mA[0].y]) rotate([0, ma, 0]) color(c_magnet)
         translate([mag_r * cos(mag_angle), y_g[1], mag_r * sin(mag_angle)]) rotate([90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
   }
   translate([0, 3 * e, 0]) {
      color(c_case) render() tc_back_plate();
      motor_at(mA, y_p[1]);
      motor_at(mB, y_p[1]);
      color("#202020") translate([sensor_c.x - sensor.x / 2, y_p[0], sensor_c.y - sensor.z / 2]) cube(sensor);
   }
   translate([0, 4 * e, 0]) {
      color(c_case) tc_carrier();
      tc_boards_part();
   }
   translate([0, -0.8 * e, 0]) color(c_needle) render() tc_plane(r);
   if (with_case) translate([0, -1.2 * e, 0]) color(c_case) render() tc_case();
   // the glass last: the preview draws what is behind a transparent part only if it comes first
   if (with_case) translate([0, -1.2 * e, 0]) color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
}

module assembled_view() {
   sheet_part(150, 120, -75);
   tc_parts();
}

module exploded_view() {
   tc_parts(e = explode);
}

module inside_view() {
   tc_parts(with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02)
      let($ink = face_colors[i]) {
         // the ball ring through the tube, the face over it
         intersection() {
            rotate(-ball_a(view_ball)) ball_ring_2d();
            slot_2d();
         }
         tc_face_2d();
      }
   // the wires
   color(c_black) translate([0, 0, 0.06]) linear_extrude(0.02) intersection() {
      slot_2d();
      for (s = [-1, 1]) rotate(-(180 + s * wire_da)) translate([-wire_w / 2, 0]) square([wire_w, 50]);
   }
   color(c_white) translate([0, 0, 0.1]) linear_extrude(0.02) rotate(-plane_a(view_roll)) plane_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_p[0]]) rotate([-90, 0, 0]) tc_case(); // Make module case
translate([0, 0, y_f[1]]) rotate([-90, 0, 0]) tc_face_plate(); // Make module face_plate
translate([0, 0, -y_b[0]]) rotate([90, 0, 0]) tc_ball_disc(); // Make module ball_disc
translate([0, 0, y_d[1]]) rotate([-90, 0, 0]) tc_dial(); // Make module dial
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) tc_axle_gear(); // Make module plane_gear
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) translate([-mA[0].x, 0, -mA[0].y]) tc_motor_gear(); // Make module motor_gear
translate([0, 0, -y_pn[0]]) rotate([90, 0, 0]) translate([-mB[0].x, 0, -mB[0].y]) tc_pinion(); // Make module pinion
translate([0, 0, -y_p[0]]) rotate([90, 0, 0]) tc_back_plate(); // Make module back
translate([0, 0, -y_k[0]]) rotate([90, 0, 0]) tc_carrier(); // Make module carrier
translate([0, 0, -y_pl[0]]) rotate([90, 0, 0]) tc_plane(); // Make module airplane

tc_print(); // Make print face black,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
