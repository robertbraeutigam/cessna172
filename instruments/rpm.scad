// RPM indicator on a 28BYJ-48 stepper
//
// A standard instrument (instrument.inc.scad) in the "deep" layout: the
// stage 2 hole beside the yoke column (frame/), under the VSI; the force
// feedback yoke's housing is set back far enough behind it (the frame's
// ffb_back), so the motor and the boards are behind the case, within its
// outline. MobiFlight on its own Arduino Nano moves
// the needle from X-Plane's engine RPM and homes it on the hall sensor
// at start.
//
// The face (rpm_face.pdf, a colour print): 0 to 35 hundred RPM over 240
// degrees, a tick every 100, numbers every 500; the 172N's stepped green
// arc (2100-2450 at sea level, to 2575 at 5000 ft, to 2700 at 10000 ft,
// narrower with each step) and the red line at 2700; RPM / HUNDREDS over
// the hub and a dummy hour meter (HOURS) under it.
//
// Parts and assembly: see instrument.inc.scad and the README.

$fn = 60;

layout = "deep";             // the VSI over it (instrument.inc.scad)

include <instrument.inc.scad>

// Preview: the needle at this RPM, parts apart by explode
view_rpm = 2350;
explode = 25;

// --- Scale ---
rpm_max = 3500;
sweep = 240;                 // 0 at 8 o'clock, 3500 at 4 o'clock
green = [2100, 2450, 2575, 2700];   // the stepped arc: sea level, 5000 ft, 10000 ft
red_line = 2700;
// face colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_green = "#1f9e3a";
c_white = "white";
c_red = "#e02020";
face_colors = [c_black, c_green, c_white, c_red];

r_tick = 34;                 // the ticks' and arcs' outer edge
tick_100 = [3, 0.5];         // length, width
tick_500 = [5.5, 0.9];
arc_w = [3.6, 2.4, 1.2];     // the green arc's steps, from the outer edge
red_w = [7, 1.1];
num_r = 23.5;
num_size = 4.6;
hours = "01753";             // the dummy hour meter: whole hours, then tenths in the last cell
cell = [3, 4.4];
meter_z = -12.5;

// --- Calculated ---
function rpm_a(v) = -sweep / 2 + sweep * v / rpm_max;

assert(r_tick <= window_d / 2 - 1.5, "Scale too close to the window's edge");
assert(num_r + num_size * 0.8 <= r_tick - tick_500[0] - 0.5, "Numbers run into the ticks");
assert(len(hours) * cell.x / 2 + 1 <= abs(pol(num_r, rpm_a(0)).x) - num_size,
       "Hour meter runs into the 0 and the 35");

// --- Face, 2D: x right, y up, the axis at the origin ---
module rpm_face_2d() {
   ink(c_black) circle(d = face_d, $fn = 180);
   // the stepped green arc, its steps narrower towards 2700
   ink(c_green) for (i = [0 : 2])
      arc_2d(r_tick - arc_w[i], r_tick, rpm_a(green[i]), rpm_a(green[i + 1]));
   ink(c_white) {
      for (v = [0 : 100 : rpm_max]) {
         t = v % 500 == 0 ? tick_500 : tick_100;
         tick_2d(rpm_a(v), r_tick - t[0], r_tick, t[1]);
         if (v % 500 == 0)
            translate(pol(num_r, rpm_a(v)))
               text(str(v / 100), size = num_size, font = font, halign = "center", valign = "center");
      }
      translate([0, 13]) text("RPM", size = 3.6, font = font, halign = "center", valign = "center");
      translate([0, 8]) text("HUNDREDS", size = 2, font = font, halign = "center", valign = "center");
      translate([0, meter_z - cell.y / 2 - 2.8]) text("HOURS", size = 2, font = font, halign = "center", valign = "center");
      // hour meter: white frame, white digits on black, the tenths black on white
      translate([0, meter_z]) {
         w = len(hours) * cell.x;
         difference() {
            square([w + 0.8, cell.y + 0.8], center = true);
            square([w, cell.y], center = true);
         }
         for (i = [0 : len(hours) - 1]) translate([-w / 2 + (i + 0.5) * cell.x, 0])
            if (i < len(hours) - 1)
               text(hours[i], size = 2.6, font = mono, halign = "center", valign = "center");
            else difference() {
               square([cell.x, cell.y], center = true);
               text("4", size = 2.6, font = mono, halign = "center", valign = "center");
            }
         for (i = [1 : len(hours) - 1]) translate([-w / 2 + i * cell.x - 0.1, -cell.y / 2]) square([0.2, cell.y]);
      }
      // the axle's hole, to punch
      circle(d = axle[0] + 0.2);
   }
   ink(c_red) tick_2d(rpm_a(red_line), r_tick - red_w[0], r_tick + 0.8, red_w[1]);
}

module rpm_print() {
   print_page("RPM") rpm_face_2d();
}

// --- Views ---
module rpm_parts(v = view_rpm, e = 0, with_case = true) {
   instrument_parts(rpm_a(v), face_colors, e, with_case) rpm_face_2d();
}

module assembled_view(v = view_rpm) {
   sheet_part(150, 120, -75);
   rpm_parts(v);
}

module exploded_view(v = view_rpm) {
   rpm_parts(v, explode);
}

module inside_view(v = view_rpm) {
   rpm_parts(v, explode / 2, with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) rpm_face_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_back0]) rotate([-90, 0, 0]) case(); // Make module case
translate([0, 0, y_dial1]) rotate([-90, 0, 0]) dial(); // Make module dial
translate([0, 0, y_back1]) rotate([-90, 0, 0]) back_plate(); // Make module back
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) needle_gear(); // Make module needle_gear
translate([0, 0, -y_gear0]) rotate([90, 0, 0]) translate([-drive_a, 0, 0]) motor_gear(); // Make module motor_gear
translate([0, 0, -y_needle0]) rotate([90, 0, 0]) needle(); // Make module needle
carrier_print(); // Make module carrier

rpm_print(); // Make print face black,#1f9e3a,white,#e02020

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
