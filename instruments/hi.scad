// Heading indicator on two 28BYJ-48 steppers
//
// The six-pack's bottom middle instrument (frame/), the directional gyro:
// left of the VSI, right of the turn coordinator, under the attitude
// indicator. It has the standard instrument's case front
// (instrument.inc.scad: the hole, the lip, the glass), two screws on the
// top diagonals and two knobs at the lower corners, like the 172N's.
//
// What you see, front to back:
// - a white airplane (printed, glued onto the glass's back) in the middle;
// - the fixed ring (the mask, a printed paper ring on it) round the
//   window: a white index at the top (the lubber line) and white marks
//   every 45 degrees;
// - the card: N 3 6 E ... 33, a tick every 5 degrees, turning with the
//   heading so that it shows at the index (the card turns counter
//   clockwise in a right turn);
// - the orange heading bug on a ring between the card's edge and the
//   fixed ring: it is the edge of the bug disc behind the card.
//
// What moves:
// - The card is pressed onto a 3 mm steel axle; its gear (layer y_g,
//   next to the back plate) is turned 1:1 by motor A's, like the
//   standard's needle. The magnet in A's gear homes it.
// - The bug disc turns on the dial's hub; an internal ring gear on its
//   back (80 teeth) is turned by motor B's pinion (16 teeth, 5 motor
//   turns a bug turn). The magnet is in the bug disc itself, the sensor
//   in the dial's front, so the bug has one home a turn.
// - The knobs are rotary encoders with push switches (EC11): the left one
//   sets the gyro (push: to the magnetic heading), the right one the bug
//   (push: to the heading). Each is held in a bracket of the case at its
//   corner, its nut behind the sheet; the shaft goes through the sheet.
//
// The two motors lie side by side on the back plate's back, their bodies
// slanted so that their wire covers pass each other. A board carrier on
// four posts behind them holds two ULN2003 boards and the Arduino Nano
// (MobiFlight, its own USB cable, the jack up), facing back. That part is
// deeper than the standard (hi_depth echo), but it is above hi_deep_z
// (from the axis); under it (the case, the back plate, the encoders) the
// instrument is as shallow as hi_low_depth: the force feedback yoke's
// housing is under the HI's middle (the frame checks both).
//
// Parts (printed): the case (back side down), the mask (front down), the
// card (front down), the bug disc (front down), the dial (front down),
// the axle gear, motor gear A, the pinion (on its teeth), the back plate
// (front down), the carrier (front down), two knobs (front down), black;
// the airplane, white.
//
// Parts to buy:
// - 2 x 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and
//   a mini USB cable, 2 x A3144 hall sensor, 2 x disc magnet 6 x 3 mm
// - 2 x EC11 rotary encoder with push switch, 20 mm D shaft (enc_*)
// - 3 mm steel dowel pin, 16 mm (hi_axle_len)
// - clear sheet 1 mm (glass), the card, the bug ring and the mask ring
//   printed on photo paper
// - M3 x 8 button head, black (2, through the sheet into the case),
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

// Preview: the heading, the bug's heading, the parts apart by explode
view_hdg = 30;
view_bug = 75;
explode = 25;

// --- Face ---
card_r = 28;                 // the card and its paper
mask_r = 31.5;               // the fixed ring's opening
card_tick_r = 27.4;          // the card's ticks' outer edge
tick_5 = [2.2, 0.5];         // every 5 degrees: length, width
tick_10 = [3.8, 0.8];        // every 10 degrees
card_num_r = 20.2;           // the numbers' middle
card_num_size = 4.3;
card_letter_size = 5.2;      // N, E, S, W
mark_45 = [32.1, 35.4, 1];   // the fixed ring's marks: from, to, width
index_tri = [32.1, 35.4, 4]; // the index at the top: tip, base, base width
bug_w = [6, 2.2];            // the bug: width (across), its notch's width
bug_notch = 1.6;             // the notch's depth from the inner edge
bug_paper = [26.5, 33];      // the bug ring's paper: inner and outer radius
mask_paper = [mask_r, 37];   // the mask's paper
// the airplane (white, on the glass): wing span, wing chord, length, fuselage width, tail span, tail chord
plane = [26, 3.2, 24, 2.6, 10, 2.2];
plane_nose = 11;             // its nose from the axis (the tail further down)
plane_t = 0.8;
// colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_white = "white";
c_orange = "#f07a10";
face_colors = [c_black, c_white, c_orange];

// --- Card, bug disc, dial ---
card_gap = 0.3;              // the airplane to the card
card_t = 1.2;
card_hub = [7, 1.3];         // behind the card: diameter, length
hi_axle_len = 16;            // the 3 mm steel dowel pin, MEASURE
// the bug disc, its gears, the dial, the motors: twin_drive.inc.scad (bug 0 is the disc's home)

// --- Knobs: EC11 rotary encoders with push switch, MEASURE ---
enc_r = 49;                  // from the axis, at the lower corners
enc_a = [225, 135];          // left (gyro), right (bug): clockwise from 12 o'clock
enc_body = [12.5, 6.5, 5];   // square body: side, depth, pins behind it
enc_bush = [7, 7];           // threaded bushing M7: diameter, length
enc_nut = [9.5, 2];          // its nut: across flats, height
enc_shaft = [6, 4.5, 20];    // D shaft: diameter, across the flat, length from the mounting face
enc_push = 0.5;              // push travel
enc_boss = 7.5;              // the case's bracket round it (radius)
hi_knob = [14, 10, 1.2];     // diameter, length, knurl depth
knob_gap = 1;                // to the sheet (more than the push)

// --- Screws: two through the sheet (the top diagonals), three from the back plate ---
front_cols = [cols[0], cols[1]];

// --- Board carrier: on the back plate's posts behind the motors, the boards facing back ---
twin_posts = [[34, 14], [32, -18], [-32, 18], [-34, -14]];
twin_nano_x = 0;             // the Nano's middle, along z, the USB jack up

// --- Calculated ---
function card_a(h) = -h;                            // the card: clockwise from 12 o'clock
function bug_a(b, h) = b - h;                       // the bug

enc_c = [for (a = enc_a) pol(enc_r, a)];

// y, front to back
y_pl = [y_glass1, y_glass1 + plane_t];              // the airplane, on the glass
y_cd = y_pl[1] + card_gap;                          // the card's paper
y_c = [y_cd + paper_t, y_cd + paper_t + card_t];    // its plate
y_ch = y_c[1] + card_hub[1];                        // its hub's end
y_bd = y_c[1] + 0.3;                                // the bug ring's paper
y_ax = [y_c[0] + needle_skin, y_c[0] + needle_skin + hi_axle_len];

// --- The bug's drive and the card's, behind the bug ring's paper (y_bd) ---
include <twin_drive.inc.scad>

y_mk = [y_glass1, y_bd - 0.3];                      // the mask (its paper on the front)
y_dh = y_ch + 0.3;                                  // the dial's hub's front
y_em = y_sheet1 + enc_bush[1];                      // the encoders' mounting face (the bushing's front at the sheet's back)
y_eb = y_sheet1 + enc_nut[1] + 0.3;                 // their brackets' front (the nut in front of it)
knob_y0 = y_em - enc_shaft[2] - 1;                  // the knob's front (the shaft's end 1 mm inside)
hi_depth = twin_depth;
hi_low_depth = max(twin_case_depth, y_em + enc_body[1] + enc_body[2] - y_sheet1);   // under hi_deep_z
hi_deep_z = twin_deep_z;

echo(hi_depth = hi_depth, hi_low_depth = hi_low_depth, hi_deep_z = hi_deep_z, case_depth = twin_case_depth,
     bug_ratio = ring_ratio, steps_card = 2038, steps_bug = 2038 * ring_ratio, knob_y0 = knob_y0,
     gear_from_end = y_ax[1] - y_g[1]);

// --- Checks ---
// the face
assert(card_tick_r <= card_r - 0.4, "Card ticks off the card");
assert(card_num_r + card_letter_size / 2 + 0.6 <= card_tick_r - tick_10[0], "Card numbers run into the ticks");
assert(card_num_r - card_letter_size / 2 - 1 >= norm([plane[0] / 2, plane[1]]) && card_num_r - card_letter_size / 2 - 1 >= plane_nose,
       "Card numbers under the airplane");
assert(plane[2] - plane_nose <= card_num_r - card_letter_size / 2 - 1, "The airplane's tail over the numbers");
assert(mask_r - card_r >= bug_w[0] / 2 && mask_r - card_r >= 2.5, "No room for the bug between the card and the fixed ring");
assert(index_tri[0] >= mask_r + 0.3 && index_tri[1] <= window_d / 2 - 0.5 && mark_45[1] <= window_d / 2 - 0.5, "Fixed ring marks off the ring");
assert(mask_paper[1] >= window_d / 2 + 0.5 && mask_paper[1] <= rim_od / 2 - 0.3, "Mask paper does not cover the window or is too big");
assert(bug_paper[0] <= card_r - 1 && bug_paper[0] >= dhub_d / 2 + sleeve_w + 1 && bug_paper[1] >= mask_r + 1 && bug_paper[1] <= bd_r,
       "Bug paper off the bug disc or shows");
// the front stack
assert(y_cd >= y_pl[1] + 0.2, "The card against the airplane");
assert(y_mk[1] - y_mk[0] - paper_t >= 1.5, "The mask is too thin");
assert(bd_r >= mask_r + 1.5, "The bug disc does not reach under the mask");
assert(card_hub[0] / 2 <= dhub_d / 2 + 0.15 - 0.5, "The card's hub runs into the bug disc's sleeve");
assert(y_dh >= y_ch + 0.2 && y_d[0] - y_dh >= 2.5, "Dial's hub: against the card or too short");
// the knobs' encoders: behind the case's brackets, outside its wall
for (c = enc_c) {
   assert(enc_r - enc_body[0] / 2 >= case_r + 0.5, "An encoder runs into the case's wall");
   assert(enc_r - enc_shaft[0] / 2 - 0.5 >= cut_d / 2 + 4, "An encoder's shaft hole too close to the instrument's hole");
   assert(abs(c.x) + enc_body[0] / sqrt(2) <= inst_pitch.x - case_r - 1 && abs(c.x) + enc_boss <= inst_pitch.x - case_r - 1,
          "An encoder runs into the next instrument");
   assert(norm(c - [inst_pitch.x * sign(c.x), 0] - cols[c.x > 0 ? 2 : 3]) >= enc_body[0] / sqrt(2) + ear_d / 2 + 1, "An encoder runs into the next instrument's ear");
   assert(norm(c - mA[0]) >= arm_r + enc_body[0] / sqrt(2) + 1, "An encoder runs into the case's arm");
   for (s = front_cols) assert(norm(c - s) >= hi_knob[0] / 2 + head_d / 2 + 2, "A knob over a case screw");
   assert(norm(c - [0, -ear_r]) >= enc_body[0] / sqrt(2) + ear_d / 2 + 1, "An encoder runs into the bottom column");
   assert(norm(c) - hi_knob[0] / 2 >= cut_d / 2 - 6, "A knob over the window");
}
assert(y_eb + 2 <= y_em, "Encoder bracket too thin");
assert(knob_y0 + 1 <= -knob_gap - 5, "Encoder's shaft too short for the knob");
assert(hi_knob[1] >= -knob_gap - knob_y0, "Knob shorter than the shaft in it");
assert(knob_gap >= enc_push + 0.3, "The knob hits the sheet when pushed");
// the carrier between the neighbours' (instrument.inc.scad)
carrier_in_slot("HI", twin_car_x);

// --- Helpers ---
module d_shaft_2d(d, flat) {
   intersection() {
      circle(d = d);
      translate([-d / 2, -d / 2]) square([d, flat]);
   }
}

// --- Outline, x right, z up (behind the sheet: twin_back_outline()) ---
module hi_bracket_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (c = front_cols) translate(c) circle(d = ear_d);
      for (c = enc_c) translate(c) circle(r = enc_boss);
   }
}

// --- Case: the standard's front, two screws, the encoders' brackets at the lower corners ---
module hi_case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_em) hi_bracket_outline();
         along_y(y_sheet1, y_p[0]) twin_back_outline();
      }
      along_y(-1, y_glass0 + 0.01) circle(d = window_d, $fn = 180);
      along_y(y_glass0, y_p[0] + 1) circle(d = bore_d, $fn = 180);
      // motor A's gear, open to the sheet (no bridge)
      along_y(y_sheet1 - 0.01, y_p[0] + 1) translate(mA[0]) circle(r = gear_ra + 1, $fn = 120);
      for (c = front_cols) translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
      for (c = back_cols) translate([c.x, y_p[0] + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
      // the encoders: the bushing through the bracket, the nut in front of it
      for (c = enc_c) {
         along_xz(c, y_sheet1 - 1, y_em + 1) circle(d = enc_bush[0] + 0.3);
         along_xz(c, y_sheet1 - 0.01, y_eb) circle(d = enc_nut[0] / cos(30) + 1);
      }
   }
}

// --- Mask: the fixed ring behind the glass (its paper on the front) ---
module hi_mask() {
   along_y(y_mk[0] + paper_t, y_mk[1]) difference() {
      circle(d = rim_od, $fn = 180);
      circle(r = mask_r, $fn = 180);
   }
}

// --- Card: the plate (paper on its front), the hub behind it pressed onto the axle; a: clockwise ---
module hi_card(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_c[0], y_c[1]) circle(r = card_r, $fn = 180);
         along_y(y_c[1] - 0.01, y_ch) circle(d = card_hub[0]);
      }
      along_y(y_ax[0], y_ch + 1) circle(d = axle[0] - 0.1);
   }
}

// --- Dial: the rim forward to the mask, the hub to the card's (the bug disc, the gears, the back plate, the carrier: twin_drive.inc.scad) ---
module hi_dial() {
   twin_dial(y_mk[1], y_dh);
}

// --- Knob: on the encoder's D shaft ---
module hi_knob_part(c = [0, 0], a = 0) {
   translate([c.x, 0, c.y]) rotate([0, a, 0]) difference() {
      along_y(-knob_gap - hi_knob[1], -knob_gap) circle(d = hi_knob[0], $fn = 60);
      for (k = [0 : 20 : 340]) rotate([0, k, 0]) translate([hi_knob[0] / 2, -knob_gap - hi_knob[1] - 1, 0]) rotate([-90, 0, 0])
         cylinder(d = hi_knob[2] * 1.6, h = hi_knob[1] + 2, $fn = 12);
      along_y(knob_y0, -knob_gap + 0.01) offset(delta = 0.1) d_shaft_2d(enc_shaft[0], enc_shaft[1]);
   }
}

// --- Airplane: white, glued onto the glass's back ---
module plane_2d() {
   // fuselage, nose at plane_nose
   hull() {
      translate([0, plane_nose - plane[3] / 2]) circle(d = plane[3]);
      translate([-plane[3] / 2 * 0.7, plane_nose - plane[2]]) square([plane[3] * 0.7, 0.1]);
   }
   // wings, a little behind the nose
   wy = plane_nose - 6;
   hull() {
      for (s = [-1, 1]) translate([s * (plane[0] / 2 - plane[1] / 2), wy]) circle(d = plane[1]);
   }
   // tail
   ty = plane_nose - plane[2] + plane[5] / 2 + 0.5;
   hull() {
      for (s = [-1, 1]) translate([s * (plane[4] / 2 - plane[5] / 2), ty]) circle(d = plane[5]);
   }
}

module hi_plane() {
   along_y(y_pl[0], y_pl[1]) plane_2d();
}

// --- Prints, 2D: x right, y up, the axis at the origin ---
// the card (at heading 0): ticks every 5 degrees, N 3 6 E 12 15 S 21 24 W 30 33
module card_2d() {
   names = ["N", "3", "6", "E", "12", "15", "S", "21", "24", "W", "30", "33"];
   ink(c_black) circle(r = card_r, $fn = 180);
   ink(c_white) {
      for (d = [0 : 5 : 355]) let(t = d % 10 == 0 ? tick_10 : tick_5) tick_2d(d, card_tick_r - t[0], card_tick_r, t[1]);
      for (i = [0 : 11]) let(n = names[i], big = len(search(n, "NESW")) > 0 && len(n) == 1)
         rotate(-30 * i) translate([0, card_num_r])
            text(n, size = big ? card_letter_size : card_num_size, font = font, halign = "center", valign = "center");
   }
}

// the bug ring (at bug 0): black, the orange bug at the top between the card's edge and the fixed ring
module bug_ring_2d() {
   ink(c_black) difference() {
      circle(r = bug_paper[1], $fn = 180);
      circle(r = bug_paper[0], $fn = 180);
   }
   ink(c_orange) difference() {
      translate([-bug_w[0] / 2, card_r + 0.3]) square([bug_w[0], bug_paper[1] - card_r - 0.3]);
      translate([-bug_w[1] / 2, card_r]) square([bug_w[1], bug_notch + 0.3]);
   }
}

// the fixed ring: the index at the top, marks every 45 degrees
module mask_ring_2d() {
   ink(c_black) difference() {
      circle(r = mask_paper[1], $fn = 180);
      circle(r = mask_paper[0], $fn = 180);
   }
   ink(c_white) {
      polygon([[0, index_tri[0]], [index_tri[2] / 2, index_tri[1]], [-index_tri[2] / 2, index_tri[1]]]);
      for (a = [45 : 45 : 315]) tick_2d(a, mark_45[0], mark_45[1], mark_45[2]);
   }
}

// the page: two masks and the glass's template on top, two cards and two bug rings under them, the caption;
// registration dots in every layer
module hi_print() {
   gap = print_gap;
   rm_ = mask_paper[1];
   row1 = [rm_, 3 * rm_ + gap, 4 * rm_ + 2 * gap + glass_d / 2];   // the centres
   row2_y = -rm_ - gap - bug_paper[1];
   row2 = [card_r, 3 * card_r + gap, 4 * card_r + 2 * gap + bug_paper[1], 4 * card_r + 3 * gap + 3 * bug_paper[1]];
   w = max(row1[2] + glass_d / 2 + 0.3, row2[3] + bug_paper[1]);
   for (i = [0, 1]) translate([row1[i], 0]) mask_ring_2d();
   for (i = [0, 1]) translate([row2[i], row2_y]) card_2d();
   for (i = [2, 3]) translate([row2[i], row2_y]) bug_ring_2d();
   ink(c_black) {
      translate([row1[2], 0]) difference() {
         circle(d = glass_d + 0.6, $fn = 180);
         circle(d = glass_d, $fn = 180);
      }
      translate([0, row2_y - bug_paper[1] - 7])
         text(str("HI: mask ring ", 2 * mask_paper[1], " mm, card ", 2 * card_r, " mm, bug ring ", 2 * bug_paper[1],
                  " mm: cut on their edges; glass ", glass_d, " mm: cut on the line's inside. Print at 100 %."),
              size = 3, font = font);
   }
   for (x = [-2, w + 2], y = [row2_y - bug_paper[1] - 10, rm_ + 2]) translate([x, y]) square(0.1, center = true);
}

// --- View only ---
module enc_part(c) {
   translate([c.x, 0, c.y]) {
      color(c_steel) {
         along_y(y_em - enc_bush[1], y_em) circle(d = enc_bush[0]);
         along_y(y_eb - enc_nut[1], y_eb) circle(d = enc_nut[0] / cos(30), $fn = 6);
         along_y(knob_y0 + 0.5, y_em) d_shaft_2d(enc_shaft[0], enc_shaft[1]);
         for (i = [-2 : 2]) translate([i * 2.5, y_em + enc_body[1], -enc_body[0] / 2 + 1]) cube([0.6, enc_body[2], 0.6]);
      }
      color("#303438") along_y(y_em, y_em + enc_body[1]) rotate(45) square(enc_body[0], center = true);
   }
}

// a piece of the sheet round the hole, the screws and the knobs' holes
module hi_sheet_part(w = 150, h = 120, x0 = -75) {
   color(c_sheet) along_y(0, sheet_t) difference() {
      translate([x0, -h / 2]) square([w, h]);
      circle(d = cut_d, $fn = 180);
      for (c = front_cols) translate(c) circle(d = clear_d);
      for (c = enc_c) translate(c) circle(d = enc_shaft[0] + 1);
   }
   color("#111111") for (c = front_cols) translate([c.x, 0, c.y]) rotate([90, 0, 0]) cylinder(d = head_d, h = 1.65);
}

// all parts at heading h, the bug at b; e: apart by this
module hi_parts(h = view_hdg, b = view_bug, e = 0, with_case = true) {
   ac = card_a(h);
   ab = bug_a(b, h);
   translate([0, -1.6 * e, 0]) for (c = enc_c) color("#45484d") render() hi_knob_part(c);
   translate([0, -0.4 * e, 0]) {
      color(c_case) render() hi_mask();
      paper_part(y_mk[0] + paper_t, 0, [c_black, c_white]) mask_ring_2d();
   }
   translate([0, 0.2 * e, 0]) {
      color(c_case) render() hi_card(ac);
      paper_part(y_c[0], ac, [c_black, c_white]) card_2d();
   }
   twin_drive_parts(ac, ab, [c_black, c_orange], e) {
      bug_ring_2d();
      twin_disc();
   }
   translate([0, 1.5 * e, 0]) {
      color(c_case) render() hi_dial();
      twin_dial_sensor_part();
   }
   if (with_case) translate([0, -1.0 * e, 0]) {
      color(c_case) render() hi_case();
      color(c_needle) hi_plane();
      for (c = enc_c) enc_part(c);
   }
   // the glass last: the preview draws what is behind a transparent part only if it comes first
   if (with_case) translate([0, -1.0 * e, 0]) color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
}

module assembled_view() {
   hi_sheet_part();
   hi_parts();
}

module exploded_view() {
   hi_parts(e = explode);
}

module inside_view() {
   hi_parts(with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02)
      let($ink = face_colors[i]) {
         mask_ring_2d();
         rotate(-card_a(view_hdg)) card_2d();
         rotate(-bug_a(view_bug, view_hdg)) difference() {
            bug_ring_2d();
            circle(r = card_r);
            difference() { circle(r = 50); circle(r = mask_r); }
         }
      }
   color(c_white) translate([0, 0, 0.1]) linear_extrude(0.02) plane_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_p[0]]) rotate([-90, 0, 0]) hi_case(); // Make module case
translate([0, 0, -y_mk[0] - paper_t]) rotate([90, 0, 0]) hi_mask(); // Make module mask
translate([0, 0, -y_c[0]]) rotate([90, 0, 0]) hi_card(); // Make module card
translate([0, 0, -y_b[0]]) rotate([90, 0, 0]) twin_disc(); // Make module bug_disc
translate([0, 0, -y_mk[1]]) rotate([90, 0, 0]) hi_dial(); // Make module dial
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) twin_axle_gear(); // Make module card_gear
translate([0, 0, -y_g[0]]) rotate([90, 0, 0]) translate([-mA[0].x, 0, -mA[0].y]) twin_motor_gear(); // Make module motor_gear
translate([0, 0, -y_pn[0]]) rotate([90, 0, 0]) translate([-mB[0].x, 0, -mB[0].y]) twin_pinion(); // Make module pinion
translate([0, 0, -y_p[0]]) rotate([90, 0, 0]) twin_back_plate(); // Make module back
translate([0, 0, -y_k[0]]) rotate([90, 0, 0]) twin_carrier(); // Make module carrier
translate([0, 0, knob_gap + hi_knob[1]]) rotate([90, 0, 0]) hi_knob_part(); // Make module knob
translate([0, 0, -y_pl[0]]) rotate([90, 0, 0]) hi_plane(); // Make module airplane

hi_print(); // Make print face black,white,#f07a10

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
