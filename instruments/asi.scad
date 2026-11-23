// Airspeed indicator on a 28BYJ-48 stepper
//
// A standard instrument (instrument.inc.scad) in the six-pack's top left
// hole (frame/), with the attitude indicator 89 mm to its right and the
// turn coordinator 88 mm under it; the motor and the boards are behind
// the case, within its outline.
// MobiFlight on its own Arduino Nano moves the needle from X-Plane's
// indicated airspeed and homes it on the hall sensor at start.
//
// The face (asi_face.pdf, a colour print): KNOTS outside, 40 to 200 kts
// with a tick every 5 and numbers every 20, on a scale that is not linear
// (asi_cal, like the real one: wider at the low end); MPH inside, 40 to 230
// with numbers every 20. The 172N's arcs: white 41-85 (flaps, on the inside
// of the others), green 47-128, yellow 128-160, the red line at 160 (Vne).
// The needle rests at 12 o'clock, 0.
//
// Parts and assembly: see instrument.inc.scad and the README.

$fn = 60;

include <instrument.inc.scad>

// Preview: the needle at this airspeed, parts apart by explode
view_kts = 105;
explode = 25;

// --- Scale ---
// knots -> needle angle (clockwise from 12 o'clock); the needle is driven
// to it through the same points (the README's MobiFlight interpolation)
asi_cal = [[0, 0], [40, 26], [60, 68], [80, 110], [100, 150], [120, 190],
           [140, 228], [160, 263], [180, 296], [200, 326]];
kts_min = 40;                // the scale's first tick and number
kts_max = 200;
mph_per_kt = 1.150779;
mph_range = [40, 230];
white_arc = [41, 85];        // the 172N's markings, KIAS
green_arc = [47, 128];
yellow_arc = [128, 160];
red_line = 160;
// face colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_green = "#1f9e3a";
c_yellow = "#f2c200";
c_white = "white";
c_red = "#e02020";
face_colors = [c_black, c_green, c_yellow, c_white, c_red];

r_tick = 34.5;               // the knot ticks' and the arcs' outer edge
tick_5 = [3, 0.5];           // length, width
tick_10 = [5, 0.9];
arc_w = 3;                   // green and yellow, at the outer edge
white_w = 1.8;               // the white arc, inside them
red_w = [6.5, 1.1];
num_r = 23.8;                // knots
num_size = 3.8;
mph_r = 18;                  // the MPH ticks' outer edge
mph_tick = [[1.2, 0.4], [1.8, 0.6]];   // every 10, every 20: length, width
mph_num_r = 13.2;
mph_num_size = 2.2;
label_size = 2;

// --- Calculated ---
function kts_a(v) = lookup(v, asi_cal);
function mph_a(v) = kts_a(v / mph_per_kt);
function text_w(s, size) = 0.78 * size * len(s);    // a number's width, about (Liberation Sans Bold digits)
// a number's reach from its middle, radially and along the circle (its box at angle a)
function reach(s, size, a, along = false) =
   let(w = text_w(s, size) / 2, h = size / 2)
   along ? abs(w * cos(a)) + abs(h * sin(a)) : abs(w * sin(a)) + abs(h * cos(a));

kts_nums = [for (v = [kts_min : 20 : kts_max]) v];
mph_nums = [for (v = [mph_range[0] : 20 : mph_range[1]]) v];

assert(asi_cal[len(asi_cal) - 1][0] >= kts_max && kts_a(kts_max) <= 360 - 20, "Scale runs round past 0");
for (i = [1 : len(asi_cal) - 1]) assert(asi_cal[i][1] > asi_cal[i - 1][1], "asi_cal must grow");
assert(mph_range[1] / mph_per_kt <= kts_max, "MPH scale past the knots'");
assert(r_tick <= window_d / 2 - 1.5, "Scale too close to the window's edge");
assert(r_tick - arc_w - white_w >= r_tick - tick_10[0], "White arc inside the ticks' reach");
for (v = kts_nums) assert(num_r + reach(str(v), num_size, kts_a(v)) <= r_tick - tick_10[0] - 0.5
                          && num_r - reach(str(v), num_size, kts_a(v)) >= mph_r + 0.5, str(v, " kts runs into the ticks"));
for (v = mph_nums) assert(mph_num_r + reach(str(v), mph_num_size, mph_a(v)) <= mph_r - mph_tick[1][0] - 0.2,
                          str(v, " mph runs into its ticks"));
// numbers apart along the circle
for (i = [1 : len(kts_nums) - 1]) let(a0 = kts_a(kts_nums[i - 1]), a1 = kts_a(kts_nums[i]))
   assert(2 * num_r * sin((a1 - a0) / 2) >= reach(str(kts_nums[i - 1]), num_size, a0, true) + reach(str(kts_nums[i]), num_size, a1, true) + 1,
          str(kts_nums[i], " kts too close to the one before"));
for (i = [1 : len(mph_nums) - 1]) let(a0 = mph_a(mph_nums[i - 1]), a1 = mph_a(mph_nums[i]))
   assert(2 * mph_num_r * sin((a1 - a0) / 2) >= reach(str(mph_nums[i - 1]), mph_num_size, a0, true) + reach(str(mph_nums[i]), mph_num_size, a1, true) + 0.5,
          str(mph_nums[i], " mph too close to the one before"));
// the gap at the top: the last numbers and the first, and MPH between them
assert(2 * num_r * sin((360 - kts_a(kts_max) + kts_a(kts_min)) / 2) >= 2 * text_w("200", num_size) / 2 + 2, "200 and 40 kts too close");
for (v = [mph_nums[0], mph_nums[len(mph_nums) - 1]])
   assert(abs(pol(mph_num_r, mph_a(v)).x) >= text_w("MPH", label_size * 0.9) / 2 + text_w(str(v), mph_num_size) / 2 + 0.5,
          "MPH runs into its numbers");
// the words over and under the hub, inside the MPH numbers
assert(norm([text_w("AIRSPEED", label_size) / 2, 7.5]) <= mph_num_r - mph_num_size * 1.2, "AIRSPEED runs into the MPH numbers");

// --- Face, 2D: x right, y up, the axis at the origin ---
module asi_face_2d() {
   ink(c_black) circle(d = face_d, $fn = 180);
   ink(c_green) arc_2d(r_tick - arc_w, r_tick, kts_a(green_arc[0]), kts_a(green_arc[1]));
   ink(c_yellow) arc_2d(r_tick - arc_w, r_tick, kts_a(yellow_arc[0]), kts_a(yellow_arc[1]));
   ink(c_white) {
      arc_2d(r_tick - arc_w - white_w, r_tick - arc_w, kts_a(white_arc[0]), kts_a(white_arc[1]));
      for (v = [kts_min : 5 : kts_max]) {
         t = v % 10 == 0 ? tick_10 : tick_5;
         tick_2d(kts_a(v), r_tick - t[0], r_tick, t[1]);
      }
      for (v = kts_nums) translate(pol(num_r, kts_a(v)))
         text(str(v), size = num_size, font = font, halign = "center", valign = "center");
      for (v = [mph_range[0] : 10 : mph_range[1]]) {
         t = v % 20 == 0 ? mph_tick[1] : mph_tick[0];
         tick_2d(mph_a(v), mph_r - t[0], mph_r, t[1]);
      }
      for (v = mph_nums) translate(pol(mph_num_r, mph_a(v)))
         text(str(v), size = mph_num_size, font = font, halign = "center", valign = "center");
      translate([0, mph_num_r]) text("MPH", size = label_size * 0.9, font = font, halign = "center", valign = "center");
      translate([0, 6]) text("KNOTS", size = label_size, font = font, halign = "center", valign = "center");
      translate([0, -6.5]) text("AIRSPEED", size = label_size, font = font, halign = "center", valign = "center");
      // the axle's hole, to punch
      circle(d = axle[0] + 0.2);
   }
   ink(c_red) tick_2d(kts_a(red_line), r_tick - red_w[0], r_tick + 0.8, red_w[1]);
}

module asi_print() {
   print_page("ASI") asi_face_2d();
}

// --- Views ---
module asi_parts(v = view_kts, e = 0, with_case = true) {
   instrument_parts(kts_a(v), face_colors, e, with_case) asi_face_2d();
}

module assembled_view(v = view_kts) {
   sheet_part(150, 120, -75);
   asi_parts(v);
}

module exploded_view(v = view_kts) {
   asi_parts(v, explode);
}

module inside_view(v = view_kts) {
   asi_parts(v, explode / 2, with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) asi_face_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_back0]) rotate([-90, 0, 0]) case(); // Make module case
translate([0, 0, y_dial1]) rotate([-90, 0, 0]) dial(); // Make module dial
translate([0, 0, y_back1]) rotate([-90, 0, 0]) back_plate(); // Make module back
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) needle_gear(); // Make module needle_gear
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) translate([-drive_a, 0, 0]) motor_gear(); // Make module motor_gear
translate([0, 0, -y_needle0]) rotate([90, 0, 0]) needle(); // Make module needle
carrier_print(); // Make module carrier

asi_print(); // Make print face black,#1f9e3a,#f2c200,white,#e02020

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
