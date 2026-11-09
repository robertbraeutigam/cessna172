// Cockpit frame
//
// Aluminium extrusion ladder on the desk, panel frame on its front edge and
// one ACM sheet over it, with a cut-out for every component; below the
// desk top the clamp hangers, the apron under the throttle and the bay bar
// with the parking brake. Values, layout and checks are in frame.inc.scad;
// this file has the views and the cut list (echo). It has no printed parts.
//
// Bought parts (lengths: see the echo of the build, or the README):
// - 2040 extrusion: front rail left, front rail right, rear rail
// - 2020 extrusion: 5 crossbars, 4 uprights, top bar, 4 braces (45 degree
//   ends), 4 hangers (2 short), 4 clamp arms, lower bar, bay bar
// - corner brackets, M5 screws and T-nuts (6 mm slot)
// - 3 mm ACM sheet, frame_w x sheet_h, and the apron sheet
// - 4 M5 x 40 knurled thumb screws (DIN 464) and 4 self-adhesive rubber
//   bumpers (20 mm), for the clamps
//
// Assembly:
// 1. Bolt the ladder together: rails, crossbars. Stand the uprights on the
//    front rail, the top bar on them, the braces from the uprights to the
//    crossbars.
// 2. Cut the sheet (cuts, sheet_screws in the echo, the "sheet" view),
//    drill its screw holes, and screw it onto the front slots with T-nuts.
// 3. Clamps: tap the top end of each hanger and the front end of each arm
//    M5. Drill an access hole (5 mm) down through the front rail over each
//    hanger, its centre over the rail's front bottom slot. Screw an M5 x 12
//    button head into the hanger's end, slide its head into the slot and
//    tighten it through the access hole, then add a corner bracket on each
//    side of the hanger. Drill through each hanger (front to back) at
//    arm_bolt_z and bolt the arm to its back face (M5 x 30 from the front),
//    a corner bracket under the arm. Drill the arm through at arm_screw_y,
//    put a T-nut in its bottom slot there and screw the thumb screw in
//    from below. Glue a felt pad on each hanger's back, at the desk edge.
// 4. The lower bar between the two long hangers, the apron sheet on their
//    front slots (its holes: apron_screws, apron_head_holes for the arm bolt
//    heads). Screw the bay bar under the two rail ends (bay_bar_bolts:
//    drill through the bar, T-nut in the rail's front bottom slot).
// 5. Stick a rubber bumper on the desk underside over each thumb screw. Put
//    the frame on the desk, the hangers against the desk edge, and tighten
//    the thumb screws by hand up against the bumpers. Put the yoke into the
//    bay and clamp it with its own clamps.
// 6. Push the throttle box through its cut-out onto the rail and the middle
//    crossbar until its face is on the sheet, bolt its floor into the rail
//    (throttle_bolts), drill the sheet through its flange holes and screw
//    the flange on (M3, nuts behind the sheet). The pedestal goes in the
//    same way onto the lower bar, the parking brake under the bay bar, when
//    they exist.

include <frame.inc.scad>

$fn = 40;

// --- View colors ---
c_alu = "#c3c9d0";
c_sheet = "#4a4f57";
c_desk = "#c8a77a";
c_device = "#2b2e33";
c_display = "#c0392b";
c_box = "#5b6f8a";
c_switch = "#3a3d42";

echo(frame = [frame_w, frame_d, sheet_h]);
echo(rails_2040 = [x_bay0, frame_w - x_bay1, frame_w]);
echo(crossbars_2020 = len(crossbar_xs), crossbar_len = crossbar_len);
echo(uprights_2020 = len(upright_xs), upright_len = upright_len, top_bar = frame_w);
echo(braces_2020 = len(upright_xs), brace_long_edge = brace_long);
echo(sheet = [frame_w, sheet_h], screws = len(sheet_screws));
echo(switch_cut = switch_cut, bay_cut = bay_cut, throttle_cut = throttle_cut, radio_cut = radio_cut);
echo(sheet_screws = sheet_screws, throttle_bolts = throttle_bolts);
echo(hangers_2020 = [for (h = hangers) h[1]], clamp_arms_2020 = [len(hangers), arm_len],
     arm_bolt_z = arm_bolt_z, arm_screw_y = arm_screw_y, lower_bar = apron_bar[1] - apron_bar[0],
     bay_bar = bay_bar[1] - bay_bar[0]);
echo(apron_sheet = [apron[1] - apron[0], apron_h], apron_screws = len(apron_screws),
     apron_head_holes = apron_head_holes, apron_head_d = apron_head_d);
echo(pedestal_cut = pedestal_cut, pedestal_bolts = pedestal_bolts, bay_bar_bolts = bay_bar_bolts);
echo(m5 = len(sheet_screws) + len(apron_screws) + 2 * len(hangers) + 2 + 2 + 2 + 2,
     corner_brackets = 3 * len(hangers));

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
   // below the desk top
   for (h = hangers) {
      bar([h[0], 0, -h[1]], [ext, ext, h[1]]);
      bar([h[0], ext, arm_z0], [ext, arm_len, ext]);
   }
   bar([apron_bar[0], 0, -apron_h], [apron_bar[1] - apron_bar[0], ext, ext]);
   bar([bay_bar[0], 0, -ext], [bay_bar[1] - bay_bar[0], ext, ext]);
}

// Corner bracket: its corner at the origin, legs along +x and -z, ext wide in y
module corner_bracket() {
   translate([0, ext, 0]) rotate([90, 0, 0]) linear_extrude(ext)
      polygon([[0, 0], [bracket_leg, 0], [bracket_leg, -bracket_t], [bracket_t, -bracket_leg], [0, -bracket_leg]]);
}

// Clamp hardware, view only: brackets, the arm bolt head, the thumb screw
// (its tip on the rubber pad) and the pad
module clamp_hw_part(h) {
   x = h[0] + ext / 2;
   color("#9aa0a8") {
      translate([h[0], 0, 0]) mirror([1, 0, 0]) corner_bracket();
      translate([h[0] + ext, 0, 0]) corner_bracket();
      translate([h[0] + ext, ext, arm_z0]) rotate([0, 0, 90]) corner_bracket();
   }
   color("#6f757d") {
      translate([x, 0, arm_bolt_z]) rotate([90, 0, 0]) cylinder(d = m5_head_d, h = 2.75);
      translate([x, arm_screw_y, thumb_z]) {
         cylinder(d = 5, h = thumb_len);
         translate([0, 0, -thumb_head[1]]) cylinder(d = thumb_head[0], h = thumb_head[1], $fn = 24);
      }
   }
   color("#222") translate([x, arm_screw_y, -desk.z - desk_skirt - pad_t]) cylinder(d = pad_d, h = pad_t);
}

module clamps_part() {
   for (h = hangers) clamp_hw_part(h);
}

// --- Sheet, x / z on the sheet ---

module rect(r) {
   translate([r[0], r[1]]) square([r[2] - r[0], r[3] - r[1]]);
}

module sheet_2d() {
   difference() {
      square([frame_w, sheet_h]);
      for (c = cuts) rect(c);
      for (p = sheet_screws)
         translate(p) circle(d = m5_d);
   }
}

// apron sheet, x / z on the sheet (z < 0)
module apron_2d() {
   difference() {
      translate([apron[0], -apron_h]) square([apron[1] - apron[0], apron_h]);
      rect(pedestal_cut);
      for (p = apron_screws)
         translate(p) circle(d = m5_d);
      for (p = apron_head_holes)
         translate(p) circle(d = apron_head_d);
   }
}

module sheet_part() {
   color(c_sheet)
      rotate([90, 0, 0])
         linear_extrude(sheet_t) {
            sheet_2d();
            apron_2d();
         }
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
   f = switch_flange;
   y_face = -sheet_t - 3;           // panel_t, the face on the sheet
   z_back = switch_z + f;
   color(c_sheet) {
      translate([x_sw0, y_face, switch_z])
         cube([f + switch_ign_w - 0.3, 3, switch_panel.y]);
      translate([x_sw0 + f + switch_ign_w, y_face, switch_z])
         cube([switch_panel.x - f - switch_ign_w, 3, switch_panel.y]);
      // rims, through the sheet
      for (p = [[x_sw0 + f, switch_ign_w - 0.3], [x_sw0 + f + switch_ign_w, switch_back.x - switch_ign_w]])
         difference() {
            translate([p[0], y_face + 3, z_back]) cube([p[1], 8, switch_back.y]);
            translate([p[0] + 2.5, y_face, z_back + 2.5]) cube([p[1] - 5, 20, switch_back.y - 5]);
         }
   }
   color(c_switch)
      translate([switch_cut[0] + 4, 5, switch_cut[1] + 4])
         cube([switch_cut[2] - switch_cut[0] - 8, switch_depth, switch_cut[3] - switch_cut[1] - 8]);
   // key, rockers and toggles on the face
   color("#b9c0c8") translate([x_sw0 + f + 38.5, y_face, z_back + 40]) rotate([90, 0, 0]) cylinder(d = 24, h = 4);
   color("#c0392b") translate([x_sw0 + f + 92, y_face - 4, z_back + 22]) cube([24, 4, 31]);
   color("#222") translate([x_sw1 - f - 32, y_face - 4, z_back + 22]) cube([24, 4, 31]);
   for (i = [0 : 6])
      color("#d0d4da") translate([x_sw0 + f + 132 + i * 18, y_face, z_back + 36])
         rotate([90, 0, 0]) cylinder(d = 4, h = 18);
}

module throttle_part() {
   r = 10;
   f = throttle_flange;
   translate([throttle_x0, throttle_y0, rail.y]) {
      color(c_box) {
         difference() {
            hull()
               for (x = [r, throttle_size.x - r], y = [r, throttle_size.y - r])
                  translate([x, y, 0]) cylinder(r = r, h = throttle_size.z);
            translate([3, 3, 3]) cube(throttle_size - [6, 6, 0]);
         }
         translate([-f, 0, 0]) cube([throttle_size.x + 2 * f, throttle_face_t, throttle_size.z + f]);
      }
      color("#b9c0c8")
         for (x = throttle_bolt_xs)
            translate([x, throttle_bolt_y, 3]) cylinder(d = m5_head_d, h = 3);
      for (i = [0 : 2])
         translate([throttle_rod_xs[i], 0, throttle_rod_z]) {
            color("#b9c0c8") rotate([90, 0, 0]) cylinder(d = 6, h = 60);
            color(["#9aa0a8", "#222", "#c0392b"][i])
               translate([0, -60, 0]) rotate([90, 0, 0]) cylinder(d = 26, h = 14);
         }
   }
}

// Under-desk component on its lower bar: box, face with flange, floor bolts
module under_box(x, size) {
   f = under_flange;
   translate([x - size.x / 2, under_y0, apron_bar_z]) {
      color(c_box) {
         difference() {
            cube(size);
            translate([3, 3, 3]) cube(size - [6, 6, 0]);
         }
         translate([-f, 0, 0]) cube([size.x + 2 * f, under_face_t, size.z + f]);
      }
      color("#b9c0c8")
         for (s = [-1, 1])
            translate([size.x / 2 + s * size.x / 4, under_bolt_y, 3]) cylinder(d = m5_head_d, h = 3);
   }
}

module pedestal_part() {
   under_box(pedestal_x, pedestal_size);
   // trim wheel rim out of a slot in the face, fuel selector below it
   z = apron_bar_z + pedestal_size.z;
   color("#222") {
      translate([pedestal_x - 6, under_y0 + 40, z - 55])
         rotate([0, 90, 0]) cylinder(d = 100, h = 12);
      translate([pedestal_x, under_y0, apron_bar_z + 35]) {
         rotate([90, 0, 0]) cylinder(d = 50, h = 6);
         translate([0, -10, 0]) cube([12, 10, 50], center = true);
      }
   }
}

// Parking brake: body under the desk top behind the bay bar, a tab up to
// the bar's bottom slot; the T-handle released (sideways, almost flush) or
// set (pulled out, pointing down)
module park_part(set = false) {
   z = park_z + park_size.z / 2;
   pull = set ? park_pull : 0;
   color(c_box) {
      translate([park_x - park_size.x / 2, 0, park_z]) cube(park_size);
      translate([park_x - park_size.x / 2, 0, park_z]) cube([park_size.x, ext, -ext - park_z]);
   }
   color("#b9c0c8") {
      for (s = [-1, 1])
         translate([park_x + s * park_bolt_dx, ext / 2, -ext]) cylinder(d = 5, h = 1);
      translate([park_x, 1, z]) rotate([90, 0, 0]) cylinder(d = 6, h = 6 + pull);
   }
   color("#c0392b")
      translate([park_x, -10 - pull, z])
         rotate([0, set ? 0 : 90, 0])
            translate([0, 0, set ? -park_handle + 8 : 0])
               cylinder(d = 10, h = park_handle, center = !set);
}

module components() {
   yoke_part();
   radio_part();
   switch_panel_part();
   throttle_part();
   pedestal_part();
   park_part();
   clamps_part();
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
}

// Below the desk top: aprons, under-desk components and the leg room
module under_view() {
   intersection() {
      union() {
         desk_part();
         frame_part();
         sheet_part();
         pedestal_part();
         park_part(set = true);
         clamps_part();
         throttle_part();
      }
      translate([-110, -200, -apron_h - 1]) cube([frame_w + 220, 600, apron_h + 120]);
   }
}

// Close-up of the left clamp, the desk and the frame around it cut off
module clamp_view() {
   h = hangers[0];
   x0 = h[0] - 45;
   x1 = h[0] + ext + 45;
   color(c_desk) translate([x0, frame_overhang, -desk.z]) cube([x1 - x0, arm_len + 40, desk.z]);
   color(c_alu) {
      translate([x0, 0, 0]) cube([x1 - x0, rail.x, rail.y]);
      translate([h[0], 0, -h[1]]) cube([ext, ext, h[1]]);
      translate([h[0], ext, arm_z0]) cube([ext, arm_len, ext]);
   }
   clamp_hw_part(h);
}

module throttle_view() {
   intersection() {
      union() {
         frame_part();
         sheet_part();
         throttle_part();
      }
      translate([throttle_x0 - 40, -100, -1]) cube([throttle_size.x + 80, 400, 120]);
   }
}

//cockpit_view(); // Make view main 62,0,-35
//cockpit_view(); // Make view front 90,0,0
//cockpit_view(); // Make view back 55,0,150
//frame_part(); // Make view frame 55,0,-35
//sheet_view(); // Make view sheet 90,0,0
//throttle_view(); // Make view throttle 55,0,150
//under_view(); // Make view under 80,0,-20
//clamp_view(); // Make view clamp 75,0,-50
