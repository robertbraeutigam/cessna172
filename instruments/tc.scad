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
// the ball disc, its gears, the dial, the motors: twin_drive.inc.scad (the heading indicator's bug drive; its home: the ball centred)

// --- Screws: four through the sheet (the diagonals), three from the back plate (back_cols) ---
front_cols = cols;

// --- Board carrier: on the back plate's posts behind the motors, the boards facing back ---
twin_posts = [[34, 14], [32, -12], [-32, 18], [-34, -14]];
twin_nano_x = -2.5;          // the Nano's middle, along z, the USB jack up (left of the axis: the HI's carrier is right)

// --- Calculated ---
function plane_a(r) = r;                            // the airplane: clockwise from 12 o'clock, right wing down
function ball_a(b) = -b;                            // the ball disc: the ball to the right turns it counter clockwise
function text_w(s, size) = 0.78 * size * len(s);    // a word's width, about (Liberation Sans Bold)

wire_da = (ball_d / 2 + wire_gap + wire_w / 2) / ball_r * 180 / PI;   // the wires from 6 o'clock (degrees)

// y, front to back
y_pl = [y_glass1 + plane_gap, y_glass1 + plane_gap + needle_t];   // the airplane's blade
y_ph = y_pl[1] + hub_h;                             // its hub's end
y_fc = y_ph + hub_gap;                              // the face's paper
y_f = [y_fc + paper_t, y_fc + paper_t + fp_t];      // the face plate
y_bd = y_f[1] + 0.3;                                // the ball ring's paper
y_ax = [y_pl[0] + needle_skin, y_pl[0] + needle_skin + tc_axle_len];

// --- The ball's drive and the airplane's, behind the ball ring's paper (y_bd) ---
include <twin_drive.inc.scad>

y_dh = y_f[1];                                      // the dial's hub's front, under the face plate's middle
tc_car_x = twin_car_x;
tc_depth = twin_depth;
tc_low_depth = twin_case_depth;                     // under tc_deep_z
tc_deep_z = twin_deep_z;

echo(tc_depth = tc_depth, tc_low_depth = tc_low_depth, tc_deep_z = tc_deep_z, case_depth = twin_case_depth,
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
assert(y_d[0] - y_dh >= 2.5, "Dial's hub too short");
assert(key[1] <= fp_t - 0.3, "The face plate's notch goes through it");
// the carrier between the neighbours' (instrument.inc.scad)
carrier_in_slot("TC", tc_car_x);

// --- Outlines, x right, z up (behind the sheet's back: twin_back_outline()) ---
module tc_case_outline() {
   twin_back_outline();
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

// --- Ball disc: twin_disc(), a notch in the edge at the magnet: the ball ring's top mark goes there ---
module tc_ball_disc(a = 0) {
   twin_disc(a) along_y(y_b[0] - 1, y_b[1] + 1) translate(pol(bd_r, bmag[1])) rotate(-bmag[1]) rotate(45) square(1.6, center = true);
}

// --- Dial: twin_dial(), its rim forward to the face plate, its lug into the face plate's notch at the top
// (the gears, the back plate, the carrier: twin_drive.inc.scad) ---
module tc_dial() {
   twin_dial(y_f[1], y_dh) along_y(y_f[1] - key[1], y_f[1] + 0.01) intersection() {
      translate([-key[0] / 2, 0]) square([key[0], rim_od]);
      difference() {
         circle(d = rim_od, $fn = 180);
         circle(d = rim_id, $fn = 180);
      }
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
// all parts at bank r, the ball at b; e: apart by this
module tc_parts(r = view_roll, b = view_ball, e = 0, with_case = true) {
   ap = plane_a(r);
   ab = ball_a(b);
   translate([0, -0.4 * e, 0]) {
      color(c_case) render() tc_face_plate();
      paper_part(y_fc, 0, face_colors) tc_face_2d();
   }
   twin_drive_parts(ap, ab, face_colors, e) {
      ball_ring_2d();
      tc_ball_disc();
   }
   translate([0, 1.5 * e, 0]) {
      color(c_case) render() tc_dial();
      twin_dial_sensor_part();
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
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) twin_axle_gear(); // Make module plane_gear
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) translate([-mA[0].x, 0, -mA[0].y]) twin_motor_gear(); // Make module motor_gear
translate([0, 0, -y_pn[0]]) rotate([90, 0, 0]) translate([-mB[0].x, 0, -mB[0].y]) twin_pinion(); // Make module pinion
translate([0, 0, -y_p[0]]) rotate([90, 0, 0]) twin_back_plate(); // Make module back
translate([0, 0, -y_k[0]]) rotate([90, 0, 0]) twin_carrier(); // Make module carrier
translate([0, 0, -y_pl[0]]) rotate([90, 0, 0]) tc_plane(); // Make module airplane

tc_print(); // Make print face black,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
