// Cockpit frame
//
// Aluminium extrusion ladder on the desk, panel frame on its front edge and
// one ACM sheet over it, with a cut-out for every component. Values,
// layout and checks are in frame.inc.scad; this file has the views, the
// cut list (echo) and the printed throttle mount.
//
// Bought parts (lengths: see the echo of the build, or the README):
// - 2040 extrusion: front rail left, front rail right, rear rail
// - 2020 extrusion: 5 crossbars, 4 uprights, top bar, 4 braces (45 degree
//   ends)
// - corner brackets, M5 screws and T-nuts (6 mm slot)
// - 3 mm ACM sheet, frame_w x sheet_h
// - desk clamps (the ones the throttle used), on the rails
//
// Printed:
// - throttle_mount, 2x: holds the throttle box by its clamp pockets, bolted
//   through the sheet into the front rail
//
// Assembly:
// 1. Bolt the ladder together: rails, crossbars. Stand the uprights on the
//    front rail, the top bar on them, the braces from the uprights to the
//    crossbars.
// 2. Cut the sheet (cuts, sheet_screws in the echo, the "sheet" view),
//    drill its screw holes, and screw it onto the front slots with T-nuts.
// 3. Put the frame on the desk, the yoke into the bay, clamp both.
// 4. Push the throttle box through its cut-out onto the rail and the middle
//    crossbar, the throttle mounts into its clamp pockets, and bolt them
//    through the sheet into the rail.

include <frame.inc.scad>

$fn = 40;

// --- View colors ---
c_alu = "#c3c9d0";
c_sheet = "#4a4f57";
c_desk = "#c8a77a";
c_device = "#2b2e33";
c_display = "#c0392b";
c_box = "#5b6f8a";
c_mount = "#e8a33a";
c_switch = "#3a3d42";

echo(frame = [frame_w, frame_d, sheet_h]);
echo(rails_2040 = [x_bay0, frame_w - x_bay1, frame_w]);
echo(crossbars_2020 = len(crossbar_xs), crossbar_len = crossbar_len);
echo(uprights_2020 = len(upright_xs), upright_len = upright_len, top_bar = frame_w);
echo(braces_2020 = len(upright_xs), brace_long_edge = brace_long);
echo(sheet = [frame_w, sheet_h], screws = len(sheet_screws) + len(tm_bolts));
echo(switch_cut = switch_cut, bay_cut = bay_cut, throttle_cut = throttle_cut, radio_cut = radio_cut);
echo(sheet_screws = sheet_screws, throttle_mount_bolts = tm_bolts);

// --- Frame ---

module bar(p0, size) {
   color(c_alu) translate(p0) cube(size);
}

// 45 degree brace behind the upright at x: its long edge from under the top
// bar on the upright down to the crossbar, ends cut flush to them
module brace(x) {
   a = [ext, rail.y + brace_rise];
   d = [1, -1] / sqrt(2);       // along the brace (y, z)
   n = [-1, -1] / sqrt(2);      // towards the corner
   color(c_alu)
      intersection() {
         translate([x - 1, ext, rail.y]) cube([ext + 2, frame_d, sheet_h]);
         multmatrix([[1, 0, 0, x], [0, d.x, n.x, a.x], [0, d.y, n.y, a.y], [0, 0, 0, 1]])
            translate([0, -ext * 2, 0]) cube([ext, brace_long + ext * 4, ext]);
      }
}

module frame_part() {
   bar([0, 0, 0], [x_bay0, rail.x, rail.y]);
   bar([x_bay1, 0, 0], [frame_w - x_bay1, rail.x, rail.y]);
   bar([0, rear_y, 0], [frame_w, rail.x, rail.y]);
   for (x = crossbar_xs)
      bar([x, rail.x, 0], [ext, crossbar_len, ext]);
   for (x = upright_xs) {
      bar([x, 0, rail.y], [ext, ext, upright_len]);
      brace(x);
   }
   bar([0, 0, sheet_h - ext], [frame_w, ext, ext]);
}

// --- Sheet, x / z on the sheet ---

module rect(r) {
   translate([r[0], r[1]]) square([r[2] - r[0], r[3] - r[1]]);
}

module sheet_2d() {
   difference() {
      square([frame_w, sheet_h]);
      for (c = cuts) rect(c);
      for (p = concat(sheet_screws, tm_bolts))
         translate(p) circle(d = m5_d);
   }
}

module sheet_part() {
   color(c_sheet)
      rotate([90, 0, 0])
         linear_extrude(sheet_t) sheet_2d();
}

// --- Components, view only ---

module desk_part() {
   color(c_desk)
      translate([-100, frame_overhang, -desk.z])
         cube([frame_w + 200, desk.y, desk.z]);
}

module yoke_part() {
   x = (x_bay0 + x_bay1) / 2;
   color(c_device) {
      translate([x - yoke_housing.x / 2, yoke_front_y, 0])
         cube(yoke_housing);
      translate([x, yoke_front_y + 1, yoke_shaft_z])
         rotate([90, 0, 0]) cylinder(d = 22, h = 90);
      translate([x, yoke_front_y - 100, yoke_shaft_z]) {
         cube([yoke_wheel_w - 80, 24, 26], center = true);
         for (s = [-1, 1])
            translate([s * (yoke_wheel_w / 2 - 20), 0, 0])
               rotate([0, s * 15, 0]) cylinder(d = 32, h = 110, center = true);
      }
   }
}

module radio_part() {
   translate([x_rc, -sheet_t, radio_front_z0]) {
      color(c_device) {
         translate([-radio_front.x / 2, -radio_front_t, 0])
            cube([radio_front.x, radio_front_t, radio_front.y]);
         translate([-radio_body.x / 2, 0, (radio_front.y - radio_body.y) / 2])
            cube([radio_body.x, radio_depth, radio_body.y]);
      }
      color(c_display)
         for (sx = [-1, 1], z = [0.3, 0.7])
            translate([sx * radio_front.x / 4 - 45, -radio_front_t - 0.5, z * radio_front.y - 6])
               cube([90, 1, 12]);
   }
}

module switch_panel_part() {
   y_face = -sheet_t - 8 - 3;       // rim_h, panel_t
   color(c_sheet) {
      translate([x_sw0, y_face, switch_z])
         cube([92 - 0.3, 3, switch_panel.y]);
      translate([x_sw0 + 92, y_face, switch_z])
         cube([switch_panel.x - 92, 3, switch_panel.y]);
      difference() {
         translate([x_sw0, y_face + 3, switch_z]) cube([switch_panel.x, 8, switch_panel.y]);
         translate([x_sw0 + switch_rim_w, y_face, switch_z + switch_rim_w])
            cube([switch_panel.x - 2 * switch_rim_w, 20, switch_panel.y - 2 * switch_rim_w]);
      }
   }
   color(c_switch)
      translate([switch_cut[0] + 2, 0, switch_cut[1] + 2])
         cube([switch_cut[2] - switch_cut[0] - 4, switch_depth, switch_cut[3] - switch_cut[1] - 4]);
   // key, rockers and toggles on the face
   color("#b9c0c8") translate([x_sw0 + 46, y_face, switch_z + 40]) rotate([90, 0, 0]) cylinder(d = 24, h = 4);
   color("#c0392b") translate([x_sw0 + 105, y_face - 4, switch_z + 22]) cube([24, 4, 31]);
   color("#222") translate([x_sw1 - 32, y_face - 4, switch_z + 22]) cube([24, 4, 31]);
   for (i = [0 : 6])
      color("#d0d4da") translate([x_sw0 + 145 + i * 18, y_face, switch_z + 36])
         rotate([90, 0, 0]) cylinder(d = 4, h = 18);
}

module throttle_part() {
   r = 10;
   translate([throttle_x0, throttle_y0, rail.y]) {
      color(c_box)
         hull()
            for (x = [r, throttle_size.x - r], y = [r, throttle_size.y - r])
               translate([x, y, 0]) cylinder(r = r, h = throttle_size.z);
      for (i = [0 : 2])
         translate([throttle_rod_xs[i], 0, throttle_rod_z]) {
            color("#b9c0c8") rotate([90, 0, 0]) cylinder(d = 6, h = 60);
            color(["#9aa0a8", "#222", "#c0392b"][i])
               translate([0, -60, 0]) rotate([90, 0, 0]) cylinder(d = 26, h = 14);
         }
   }
}

// --- Throttle mount, in frame coordinates ---

module throttle_mount_at(i) {
   cx = tm_cx(i);
   difference() {
      union() {
         translate([cx - tm_plate_w / 2, throttle_y0 - tm_plate_t, tm_plate_z[0]])
            cube([tm_plate_w, tm_plate_t, tm_plate_z[1] - tm_plate_z[0]]);
         translate([cx - throttle_pocket.x / 2 + tm_fit, throttle_y0 - 0.01, rail.y + throttle_pocket_z + tm_fit])
            difference() {
               cube([throttle_pocket.x - 2 * tm_fit, throttle_pocket.y - 2, throttle_pocket.z - 2 * tm_fit]);
               // lead-in at the tip
               translate([-1, throttle_pocket.y - 2, 0])
                  rotate([45, 0, 0]) cube([throttle_pocket.x, 2, 2], center = true);
            }
      }
      for (s = [-1, 1])
         translate([cx + s * tm_bolt_dx, throttle_y0 + 1, rail.y / 2])
            rotate([90, 0, 0]) cylinder(d = m5_d, h = tm_plate_t + 2);
      // version on top of the tongue
      translate([cx, throttle_y0 + throttle_pocket.y / 2, rail.y + throttle_pocket_z + throttle_pocket.z - tm_fit - 0.4])
         linear_extrude(1)
            rotate(90) text("{{gitrev}}", size = 4, halign = "center", valign = "center",
                            font = "Liberation Sans:style=Bold");
   }
}

module throttle_mount_part(i) {
   color(c_mount) throttle_mount_at(i);
}

// Print orientation: plate front on the bed, tongue up
module throttle_mount() {
   rotate([90, 0, 0])
      translate([-tm_cx(0), -(throttle_y0 - tm_plate_t), -(tm_plate_z[0] + tm_plate_z[1]) / 2])
         throttle_mount_at(0);
}

module components() {
   yoke_part();
   radio_part();
   switch_panel_part();
   throttle_part();
   for (i = [0, 1]) throttle_mount_part(i);
}

module cockpit_view() {
   desk_part();
   frame_part();
   sheet_part();
   components();
}

// Sheet cutting view: the sheet with the frame behind it
module sheet_view() {
   frame_part();
   sheet_part();
   color("#e8433a", 0.6)
      for (p = tm_bolts) translate([p.x, -sheet_t - 0.5, p.y]) rotate([90, 0, 0]) cylinder(d = 12, h = 0.5);
}

module throttle_mount_view() {
   intersection() {
      union() {
         frame_part();
         sheet_part();
         throttle_part();
         for (i = [0, 1]) throttle_mount_part(i);
      }
      translate([throttle_x0 - 40, -100, -1]) cube([throttle_size.x + 80, 400, 120]);
   }
}

throttle_mount(); // Make module throttle_mount
//cockpit_view(); // Make view main 62,0,-35
//cockpit_view(); // Make view front 90,0,0
//cockpit_view(); // Make view back 55,0,150
//frame_part(); // Make view frame 55,0,-35
//sheet_view(); // Make view sheet 90,0,0
//throttle_mount_view(); // Make view throttle_mount 55,0,-40
//throttle_mount(); // Make view throttle_mount_print 50,0,30
