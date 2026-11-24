// Vertical speed indicator on a 28BYJ-48 stepper
//
// A standard instrument (instrument.inc.scad) in the six-pack's bottom
// right hole (frame/), under the altimeter, with the heading indicator
// 89 mm to its left, NAV 1 to its right and the RPM indicator under it;
// the motor and the boards are behind the case, within its outline, in
// front of the force feedback yoke's housing (47 mm deep, the standard).
// MobiFlight on its own Arduino Nano moves the needle from X-Plane's
// vertical speed and homes it on the hall sensor at start.
//
// The face (vsi_face.pdf, a colour print), like the 172N's: 0 at
// 9 o'clock, UP clockwise over the top, DOWN counterclockwise under it,
// to 2000 ft/min each way, the two 20s either side of 3 o'clock. The
// scale (vsi_cal) is wider to 1000 (a tick every 100) and narrower above
// it (a tick every 250), numbers 0, 5, 10, 15, 20 (hundreds of ft/min);
// UP and DOWN with an arrow inside the scale on the left, VERTICAL SPEED
// and 100 FEET PER MINUTE right of the hub. All white on black.
// The needle rests at 0.
//
// Parts and assembly: see instrument.inc.scad and the README.

$fn = 60;

include <instrument.inc.scad>

// Preview: the needle at this vertical speed (ft/min), parts apart by explode
view_fpm = 700;
explode = 25;

// --- Scale ---
// ft/min (either way) -> the needle's angle from 0 (9 o'clock), clockwise
// for UP; the needle is driven through the same points (the README's
// MobiFlight interpolation)
vsi_cal = [[0, 0], [500, 50], [1000, 96], [1500, 136], [2000, 170]];
fpm_max = 2000;
fine = [100, 1000];          // a tick every 100 to 1000
coarse = 250;                // then every 250
// face colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_white = "white";
face_colors = [c_black, c_white];

r_tick = 34.5;               // the ticks' outer edge
tick_s = [3, 0.5];           // small: length, width
tick_m = [4.2, 0.7];         // every 250 above 1000
tick_l = [5.5, 1];           // every 500
num_r = 24;
num_size = 4.6;
updown_r = 15.5;             // UP and DOWN: their middle from the axis, on the left
updown_a = 52;               // and from 9 o'clock, up and down
updown_size = 2.6;
arrow_r = 11.8;              // the arrows inside them, along the circle
arrow_len = 26;              // degrees
label_x = 5;                 // VERTICAL SPEED etc.: their left end, right of the hub
label_size = 2;
unit_size = 1.6;

// --- Calculated ---
function vsi_d(v) = sign(v) * lookup(min(abs(v), fpm_max), vsi_cal);   // degrees from 0
function vsi_a(v) = -90 + vsi_d(v);                                    // clockwise from 12 o'clock
function text_w(s, size) = 0.78 * size * len(s);    // a word's width, about (Liberation Sans Bold)
function reach(s, size, a, along = false) =
   let(w = text_w(s, size) / 2, h = size / 2)
   along ? abs(w * cos(a)) + abs(h * sin(a)) : abs(w * sin(a)) + abs(h * cos(a));

nums = [0, 500, 1000, 1500, 2000];
ticks = concat([for (v = [0 : fine[0] : fine[1]]) v], [for (v = [fine[1] + coarse : coarse : fpm_max]) v]);
labels = [["VERTICAL", label_size, 4.8], ["SPEED", label_size, 1.8], ["100 FEET", unit_size, -2], ["PER MINUTE", unit_size, -4.5]];

for (i = [1 : len(vsi_cal) - 1]) assert(vsi_cal[i][1] > vsi_cal[i - 1][1], "vsi_cal must grow");
assert(vsi_cal[len(vsi_cal) - 1][0] >= fpm_max, "vsi_cal ends before fpm_max");
assert(r_tick <= window_d / 2 - 1.5, "Scale too close to the window's edge");
// the two ends either side of 3 o'clock, apart: the 20s and their ticks
assert(2 * num_r * sin(180 - vsi_d(fpm_max)) >= 2 * reach(str(fpm_max / 100), num_size, vsi_a(fpm_max), true) + 1,
       "UP 20 and DOWN 20 too close");
assert(2 * (r_tick - tick_l[0]) * sin(180 - vsi_d(fpm_max)) >= tick_l[1] + 2, "The end ticks run into each other");
for (v = nums) assert(num_r + reach(str(v / 100), num_size, vsi_a(v)) <= r_tick - tick_l[0] - 0.5,
                      str(v, " ft/min runs into the ticks"));
for (i = [1 : len(nums) - 1]) let(a0 = vsi_a(nums[i - 1]), a1 = vsi_a(nums[i]))
   assert(2 * num_r * sin((a1 - a0) / 2) >= reach(str(nums[i - 1] / 100), num_size, a0, true) + reach(str(nums[i] / 100), num_size, a1, true) + 1,
          str(nums[i], " ft/min too close to the one before"));
// the words inside the numbers, clear of the hub
for (l = labels) {
   assert(norm([label_x + text_w(l[0], l[1]), abs(l[2]) + l[1] / 2]) <= num_r - num_size * 0.6 - 1, str(l[0], " runs into the numbers"));
   assert(label_x >= hub_d / 2 + 2, str(l[0], " under the needle's hub"));
}
for (s = [-1, 1]) let(p = pol(updown_r, -90 + s * updown_a))
   assert(norm(p) + text_w("DOWN", updown_size) / 2 <= num_r - num_size * 0.8 && abs(p.y) - updown_size / 2 >= hub_d / 2 + 1,
          "UP or DOWN runs into the numbers or the hub");
assert(arrow_r + 1.4 <= updown_r - updown_size / 2 - 0.5 && arrow_r - 1.4 >= hub_d / 2 + 1, "The arrows run into UP and DOWN or the hub");

// --- Face, 2D: x right, y up, the axis at the origin ---
module arrow_2d(a0, a1) {
   // along the circle from a0 to a1 (clockwise from 12 o'clock), the head at a1
   b = a1 - sign(a1 - a0) * 9;
   arc_2d(arrow_r - 0.4, arrow_r + 0.4, a0, b);
   polygon([pol(arrow_r - 1.4, b), pol(arrow_r + 1.4, b), pol(arrow_r, a1)]);
}

module vsi_face_2d() {
   ink(c_black) circle(d = face_d, $fn = 180);
   ink(c_white) {
      for (s = [-1, 1], v = ticks) if (v > 0 || s > 0) {
         t = v % 500 == 0 ? tick_l : v > fine[1] ? tick_m : tick_s;
         tick_2d(vsi_a(s * v), r_tick - t[0], r_tick, t[1]);
      }
      for (s = [-1, 1], v = nums) if (v > 0 || s > 0) translate(pol(num_r, vsi_a(s * v)))
         text(str(v / 100), size = num_size, font = font, halign = "center", valign = "center");
      for (s = [-1, 1]) {
         translate(pol(updown_r, -90 + s * updown_a))
            text(s > 0 ? "UP" : "DOWN", size = updown_size, font = font, halign = "center", valign = "center");
         arrow_2d(-90 + s * (updown_a - arrow_len / 2), -90 + s * (updown_a + arrow_len / 2));
      }
      for (l = labels) translate([label_x, l[2]]) text(l[0], size = l[1], font = font, valign = "center");
      // the axle's hole, to punch
      circle(d = axle[0] + 0.2);
   }
}

module vsi_print() {
   print_page("VSI") vsi_face_2d();
}

// --- Views ---
module vsi_parts(v = view_fpm, e = 0, with_case = true) {
   instrument_parts(vsi_a(v), face_colors, e, with_case) vsi_face_2d();
}

module assembled_view(v = view_fpm) {
   sheet_part(150, 120, -75);
   vsi_parts(v);
}

module exploded_view(v = view_fpm) {
   vsi_parts(v, explode);
}

module inside_view(v = view_fpm) {
   vsi_parts(v, explode / 2, with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) vsi_face_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_back0]) rotate([-90, 0, 0]) case(); // Make module case
translate([0, 0, y_dial1]) rotate([-90, 0, 0]) dial(); // Make module dial
translate([0, 0, y_back1]) rotate([-90, 0, 0]) back_plate(); // Make module back
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) needle_gear(); // Make module needle_gear
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) translate([-drive_a, 0, 0]) motor_gear(); // Make module motor_gear
translate([0, 0, -y_needle0]) rotate([90, 0, 0]) needle(); // Make module needle
carrier_print(); // Make module carrier

vsi_print(); // Make print face black,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
