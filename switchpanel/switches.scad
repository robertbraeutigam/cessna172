// Switch panel: master, lights, avionics
//
// The switch row, separate from the ignition: the red split MASTER (ALT,
// BAT) on the left, toggle switches in the middle and the split AVIONICS
// (BUS 1, BUS 2) on the right. Up is ON, like in the airplane.
//
// - MASTER and AVIONICS are double rocker switches (two independent
//   rockers in one housing, 6 pins). They snap into a cutout from the
//   front: ramps on their top and bottom end catch behind the panel, which
//   is thinned to rk_grip there by a pocket in the back.
// - The middle switches are mini toggle switches (MTS-202, ON-ON). They go
//   in from the back and a nut on the front clamps them. Their body sits
//   in a shallow pocket in the back so they cannot turn.
// - A rim and bosses on the back stiffen the long, thin panel.
//
// Wiring: every switch closes one contact: one side to a common GND wire,
// the other to a SimVim input (active low, like any switch to GND). ALT and
// BAT are independent, there is no mechanical interlock between them.
//
// Coordinates: the front of the panel is at z=0, +z points towards the
// pilot, x to the pilot's right, y up. The panel starts at x=-margin_x, the
// switch centers are at y=0. The panel is printed front side down.
//
// Parts to buy (details in switches.md):
// - 1 red and 1 black double rocker switch, 6 pin
// - 7 MTS-202 mini toggle switches
// - mount_count x M3 screws to mount the panel
// - wire: one GND wire daisy chained over all switches, one wire per switch
//
// Assembly: solder the wires first (the rockers are hard to get out again),
// put the toggles in from the back and tighten their nuts, snap the rockers
// in from the front, then mount the panel.

$fn = 48;

// Preview: which switches are shown ON, in label order (missing ones are OFF)
view_on = [1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1];

// --- Printer ---
bed = [220, 220];            // MEASURE: the printer bed

// --- Double rocker switch, 6 pin (MEASURE: from the listing) ---
rk_bezel = [24.3, 31.3];     // front lip, width x height
rk_bezel_t = 2;
rk_bezel_r = 1.5;
rk_cutout = [22, 28.5];      // panel cutout
rk_cutout_clear = 0.15;      // added on every side of the cutout
rk_body = [21.7, 25.3];      // body behind the ramps
rk_depth = 31.5;             // front of the lip to the end of the pins
rk_tab = [4.8, 0.8, 7];      // quick connect tabs, width x thickness x length
rk_pin_pitch = 7;            // 3 tabs per rocker, in a column (guess)
rk_grip = 1.5;               // MEASURE: panel thickness the ramps snap behind
rk_clip_room = [0, 1.5];     // room for the ramps behind the panel, per side
rk_frame = 1.5;              // lip around and between the two rockers
rk_rocker_h = 3;             // rocker center height in front of the lip
rk_rocker_tilt = 10;

// --- Toggle switch ---
toggle = "MTS-202";          // "MTS-202" (mini, M6) or "KN3C-202" (standard, M12)
mts = toggle == "MTS-202";
// MEASURE: from listings, the KN3C values are rough guesses
tg_thread_d = mts ? 6 : 12;
tg_hole = tg_thread_d + 0.2;
tg_thread_len = mts ? 9 : 9.5;  // from the body
tg_body = mts ? [12.8, 11.4] : [13, 18];  // body, orientation unknown (the pocket is square)
tg_body_depth = mts ? 9.5 : 20;
tg_nut_af = mts ? 8 : 14;    // nut across flats
tg_nut_t = mts ? 2 : 2.5;
tg_washer_d = mts ? 10 : 16;
tg_washer_t = 0.6;
tg_lever_len = mts ? 10 : 20;
tg_lever_d = mts ? [3, 2.4] : [4.5, 3.5];  // base, tip
tg_lever_tilt = 14;
tg_tab = mts ? [2, 0.5, 4.5] : [3, 0.8, 6];
tg_pin_pitch = mts ? [4.7, 4.7] : [6, 6];  // between the 2 poles, along the throw
tg_pitch = mts ? 19 : 24;
tg_pocket_depth = 1;         // body pocket in the back, keeps the toggle from turning

// --- Layout ---
// Groups from left to right: label above the group, type ("rocker2" or
// "toggle"), switch labels (one list of lines each, top line first), color.
// A rocker2 group is one double rocker, so it has exactly two switches.
groups = [
   ["MASTER", "rocker2", [["ALT"], ["BAT"]], "red"],
   ["", "toggle", [["FUEL", "PUMP"], ["BEACON"], ["LAND"], ["TAXI"], ["NAV"], ["STROBE"], ["PITOT", "HEAT"]], "chrome"],
   ["AVIONICS", "rocker2", [["BUS", "1"], ["BUS", "2"]], "black"],
];
group_space = 4;             // between two groups

// --- Panel ---
panel_t = 3;
corner_r = 4;
margin_x = 11;               // panel end to the outer switches, room for the group labels
margin_bottom = 12;          // panel bottom to the rockers
margin_top = 4;              // panel top to the top label
rim_w = 2.5;
rim_h = 8;
mount_d = 3.3;               // M3
mount_inset = 6;             // mount hole center to the panel edge
mount_center = true;         // also a hole in the middle of the top and bottom edge
boss_d = 8;                  // overlaps the rim (mount_inset - boss_d / 2 < rim_w)

// --- Labels, engraved into the front ---
font = "Liberation Sans:style=Bold";
label_size = 3;
label_line = 4.2;            // line pitch of two-line labels
label_gap = 2.5;             // switch to the lowest label line
label_depth = 0.6;
group_label_size = 3.2;
group_line_w = 0.6;          // line under a group label, over its switches
gitrev_depth = 0.4;

// --- Derived ---
rk_cutout_c = rk_cutout + 2 * [rk_cutout_clear, rk_cutout_clear];
rk_pocket = rk_cutout_c + 2 * rk_clip_room;
rk_window = [(rk_bezel.x - 3 * rk_frame) / 2, rk_bezel.y - 2 * rk_frame];
rk_dx = (rk_window.x + rk_frame) / 2;              // rocker centers at +-rk_dx
rk_body_depth = rk_depth - rk_bezel_t - rk_tab.z;  // body behind the front of the panel
tg_pocket = [1, 1] * (max(tg_body) + 0.4);      // square: fits either way, still cannot turn
tg_body_z = -panel_t + tg_pocket_depth;            // top of the toggle body
tg_front_r = max(tg_washer_d, tg_nut_af / cos(30)) / 2;

function count_before(g) = g == 0 ? 0 : count_before(g - 1) + len(groups[g - 1][2]);
function group_w(g) = groups[g][1] == "rocker2" ? rk_bezel.x : len(groups[g][2]) * tg_pitch;
function group_left(g) = g == 0 ? 0 : group_left(g - 1) + group_w(g - 1) + group_space;

// One entry per switch unit: [x, type, labels, color, index of its first switch]
units = [for (g = [0 : len(groups) - 1])
            for (u = groups[g][1] == "rocker2" ? [0] : [for (i = [0 : len(groups[g][2]) - 1]) i])
               groups[g][1] == "rocker2"
                  ? [group_left(g) + rk_bezel.x / 2, "rocker2", groups[g][2], groups[g][3], count_before(g)]
                  : [group_left(g) + (u + 0.5) * tg_pitch, "toggle", [groups[g][2][u]], groups[g][3], count_before(g) + u]];
switch_count = count_before(len(groups));

function is_rocker(u) = u[1] == "rocker2";
function unit_label_xs(u) = is_rocker(u) ? [u[0] - rk_dx, u[0] + rk_dx] : [u[0]];
function unit_pocket(u) = is_rocker(u) ? rk_pocket : tg_pocket;
function unit_front_w(u) = is_rocker(u) ? rk_bezel.x : 2 * tg_front_r;

rk_label_y = rk_bezel.y / 2 + label_gap;
tg_label_y = tg_front_r + label_gap;
function unit_label_y(u) = is_rocker(u) ? rk_label_y : tg_label_y;
group_line_y = rk_label_y + label_line + label_size + 1;
group_label_y = group_line_y + group_line_w + 1.5;

panel_x0 = -margin_x;
panel_x1 = group_left(len(groups) - 1) + group_w(len(groups) - 1) + margin_x;
panel_y0 = -rk_bezel.y / 2 - margin_bottom;
panel_y1 = group_label_y + group_label_size + margin_top;
panel_size = [panel_x1 - panel_x0, panel_y1 - panel_y0];
panel_cx = (panel_x0 + panel_x1) / 2;

mount_holes = concat(
   [for (x = [panel_x0 + mount_inset, panel_x1 - mount_inset], y = [panel_y0 + mount_inset, panel_y1 - mount_inset]) [x, y]],
   mount_center ? [[panel_cx, panel_y0 + mount_inset], [panel_cx, panel_y1 - mount_inset]] : []);
mount_count = len(mount_holes);

// Distance from a point to a centered box
function box_dist(p, c, size) = norm([max(0, abs(p.x - c.x) - size.x / 2), max(0, abs(p.y - c.y) - size.y / 2)]);
min_boss_dist = min([for (h = mount_holes, u = units) box_dist(h, [u[0], 0], unit_pocket(u)) - boss_d / 2]);
min_web = min([for (i = [1 : len(units) - 1])
                  units[i][0] - units[i - 1][0] - (unit_pocket(units[i]).x + unit_pocket(units[i - 1]).x) / 2]);
min_front_gap = min([for (i = [1 : len(units) - 1])
                  units[i][0] - units[i - 1][0] - (unit_front_w(units[i]) + unit_front_w(units[i - 1])) / 2]);

echo(panel_size = panel_size, switches = switch_count);

// --- Sanity checks ---
assert(panel_size.x <= bed.x && panel_size.y <= bed.y, "Panel does not fit the printer bed");
assert([for (g = groups) if (g[1] == "rocker2" && len(g[2]) != 2) g] == [], "A rocker2 group needs exactly two switches");
assert(panel_t - rk_grip >= 1, "Rocker pockets too shallow, make panel_t thicker or rk_grip thinner");
assert(rk_grip >= 0.8, "Panel too thin around the rockers");
assert(rk_cutout.x >= rk_body.x && rk_cutout.y >= rk_body.y, "Rocker body does not fit the cutout");
assert(rk_bezel.x >= rk_cutout_c.x + 1.5 && rk_bezel.y >= rk_cutout_c.y + 1.5, "Rocker lip does not cover the cutout");
assert(tg_thread_len + tg_body_z >= tg_washer_t + tg_nut_t + 1, "Toggle thread too short for the panel");
assert(tg_pocket_depth < panel_t - 1, "Toggle body pocket too deep");
assert(norm(tg_body) >= tg_pocket.x + 1, "Toggle body could turn in its square pocket");
assert(min_front_gap >= 1, "Switches too close to each other, increase tg_pitch or group_space");
assert(min_web >= 1.2, "Too thin a wall between two pockets, increase tg_pitch or group_space");
assert(min_boss_dist >= 0.5, "A mount boss runs into a switch pocket, increase the margins");
assert(panel_y0 + rim_w + 0.5 <= -max(rk_pocket.y, tg_pocket.y) / 2, "Rim runs into a switch pocket, increase margin_bottom");
assert(mount_inset - boss_d / 2 <= rim_w - 0.3, "Mount bosses must overlap the rim");
assert(len(view_on) <= switch_count, "view_on has more entries than there are switches");

// --- Helpers ---
module rrect(size, r) {
   offset(r = r)
      square(size - 2 * [r, r], center = true);
}

module panel_outline() {
   translate([panel_cx, (panel_y0 + panel_y1) / 2])
      rrect(panel_size, corner_r);
}

module labels_2d() {
   for (u = units) {
      xs = unit_label_xs(u);
      for (j = [0 : len(xs) - 1]) {
         lines = u[2][j];
         for (i = [0 : len(lines) - 1])
            translate([xs[j], unit_label_y(u) + i * label_line])
               text(lines[len(lines) - 1 - i], size = label_size, font = font, halign = "center");
      }
   }
   for (g = [0 : len(groups) - 1])
      if (groups[g][0] != "") {
         x0 = group_left(g);
         x1 = x0 + group_w(g);
         translate([(x0 + x1) / 2, group_label_y])
            text(groups[g][0], size = group_label_size, font = font, halign = "center");
         translate([x0, group_line_y])
            square([x1 - x0, group_line_w]);
      }
}

// --- Parts ---
module panel() {
   difference() {
      union() {
         translate([0, 0, -panel_t])
            linear_extrude(panel_t)
               panel_outline();
         translate([0, 0, -panel_t - rim_h])
            linear_extrude(rim_h + 0.01)
               difference() {
                  panel_outline();
                  offset(delta = -rim_w)
                     panel_outline();
               }
         for (h = mount_holes)
            translate([h.x, h.y, -panel_t - rim_h])
               cylinder(d = boss_d, h = rim_h + 0.01);
      }
      for (u = units)
         translate([u[0], 0, 0])
            if (is_rocker(u)) {
               translate([0, 0, -panel_t - 1])
                  linear_extrude(panel_t + 2)
                     square(rk_cutout_c, center = true);
               // Thin the panel for the snap ramps
               translate([0, 0, -panel_t - 1])
                  linear_extrude(panel_t - rk_grip + 1)
                     square(rk_pocket, center = true);
            } else {
               translate([0, 0, -panel_t - 1])
                  cylinder(d = tg_hole, h = panel_t + 2);
               // Body pocket, keeps the toggle from turning
               translate([0, 0, -panel_t - 1])
                  linear_extrude(tg_pocket_depth + 1)
                     square(tg_pocket, center = true);
            }
      for (h = mount_holes)
         translate([h.x, h.y, -panel_t - rim_h - 1])
            cylinder(d = mount_d, h = panel_t + rim_h + 2);
      translate([0, 0, -label_depth])
         linear_extrude(label_depth + 1)
            labels_2d();
      // Version on the back, mirrored so it reads from behind
      translate([panel_x1 - 30, panel_y1 - mount_inset, -panel_t - 1])
         linear_extrude(gitrev_depth + 1)
            mirror([1, 0])
               text("{{gitrev}}", size = 3, halign = "center", valign = "center");
   }
}

// --- Views (rendered to PNG by "make views") ---

c_panel = "#4a4f57";
c_cut = "#3d7bd9";           // panel in the section views
c_label = "#f4f4f4";
c_body = "#2a2b2e";
c_bezel = "#1b1c1e";
c_tab = "#d9b24a";
c_steel = "#b9c0c8";
c_chrome = "#e2e6ea";
c_line = "#8fd0ff";
c_gnd = "#1d1f22";
wire_colors = ["#e8433a", "#f5a030", "#f2d03b", "#4caf50", "#3d7bd9", "#8e5bd6", "#9aa3ad", "#eceff2"];
wire_d = 1.2;

function rocker_color(name) = name == "red" ? "#d33a2c" : name == "white" ? "#eeeeea" : "#26282b";
function is_on(i) = i < len(view_on) && view_on[i] == 1;

// Keeps x <= 0 if cut is set (section views). color() outside of it also
// colors the cut faces.
module cut_if(cut) {
   // render() so the preview draws clean cut faces
   if (cut)
      render()
         intersection() {
            children();
            translate([-100, -100, -100])
               cube([100, 200, 200]);
         }
   else
      children();
}

// Quick connect / solder tabs at the given xy positions, below z
module tabs(points, size, z) {
   color(c_tab)
      for (p = points)
         translate([p.x - size.x / 2, p.y - size.y / 2, z - size.z])
            difference() {
               cube(size);
               if (size.x > 2.5)
                  translate([size.x / 2, -1, size.z - 2.5])
                     rotate([-90, 0, 0])
                        cylinder(d = 1.6, h = 3, $fn = 12);
            }
}

function rocker_tab_points() = [for (x = [-rk_dx, rk_dx], y = [-1, 0, 1]) [x, y * rk_pin_pitch]];

// Double rocker, front of the panel at z=0. on = [left, right]
module rocker2_part(c, on, cut = false) {
   color(c_bezel)
      cut_if(cut)
         difference() {
            linear_extrude(rk_bezel_t)
               rrect(rk_bezel, rk_bezel_r);
            for (x = [-rk_dx, rk_dx])
               translate([x, 0, -1])
                  linear_extrude(rk_bezel_t + 2)
                     square(rk_window, center = true);
         }
   // Up is ON: the top half pressed in, the bottom half sticks out
   color(rocker_color(c))
      cut_if(cut)
         for (i = [0, 1])
            translate([i == 0 ? -rk_dx : rk_dx, 0, 0])
               intersection() {
                  translate([0, 0, -1])
                     linear_extrude(rk_bezel_t + rk_rocker_h + 4)
                        rrect(rk_window - [0.6, 0.6], 0.8);
                  translate([0, 0, rk_bezel_t + rk_rocker_h])
                     rotate([on[i] ? -rk_rocker_tilt : rk_rocker_tilt, 0, 0])
                        translate([-20, -20, -40])
                           cube([40, 40, 40]);
               }
   color(c_body)
      cut_if(cut) {
         translate([0, 0, -rk_body_depth])
            linear_extrude(rk_body_depth)
               square(rk_body, center = true);
         // Snap ramps on the top and bottom end
         for (m = [0, 1])
            mirror([0, m, 0])
               translate([0, rk_body.y / 2 - 0.1, -rk_grip - 0.3])
                  rotate([90, 0, 90])
                     linear_extrude(rk_body.x * 0.6, center = true)
                        polygon([[0, 0], [(rk_cutout.y - rk_body.y) / 2 + 0.1, 0], [0, -6]]);
      }
   tabs(rocker_tab_points(), rk_tab, -rk_body_depth);
}

function toggle_tab_points() = [for (x = [-1, 1], y = [-1, 0, 1]) [x * tg_pin_pitch.x / 2, y * tg_pin_pitch.y]];

// Toggle switch without its front nut, front of the panel at z=0
module toggle_part(on, cut = false) {
   color(c_body)
      cut_if(cut)
         translate([0, 0, tg_body_z - tg_body_depth])
            linear_extrude(tg_body_depth)
               square(tg_body, center = true);
   color(c_chrome)
      cut_if(cut) {
         translate([0, 0, tg_body_z])
            cylinder(d = tg_thread_d, h = tg_thread_len);
         // Lever, ON is up
         translate([0, 0, tg_body_z + tg_thread_len])
            rotate([on ? -tg_lever_tilt : tg_lever_tilt, 0, 0]) {
               sphere(d = tg_thread_d * 0.6);
               cylinder(d1 = tg_lever_d[0], d2 = tg_lever_d[1], h = tg_lever_len);
               translate([0, 0, tg_lever_len])
                  sphere(d = tg_lever_d[1] * 1.15);
            }
      }
   tabs(toggle_tab_points(), tg_tab, tg_body_z - tg_body_depth);
}

module toggle_nut_part(cut = false) {
   color(c_steel)
      cut_if(cut)
         difference() {
            union() {
               cylinder(d = tg_washer_d, h = tg_washer_t);
               translate([0, 0, tg_washer_t])
                  cylinder(d = tg_nut_af / cos(30), h = tg_nut_t, $fn = 6);
            }
            translate([0, 0, -1])
               cylinder(d = tg_thread_d, h = tg_washer_t + tg_nut_t + 2);
         }
}

module unit_part(u, cut = false, nuts = true) {
   translate([u[0], 0, 0])
      if (is_rocker(u))
         rocker2_part(u[3], [is_on(u[4]), is_on(u[4] + 1)], cut);
      else {
         toggle_part(is_on(u[4]), cut);
         if (nuts)
            toggle_nut_part(cut);
      }
}

module switches_part() {
   for (u = units)
      unit_part(u);
}

// Panel with the engraved labels filled in
module panel_part() {
   color(c_panel)
      panel();
   color(c_label)
      translate([0, 0, -label_depth + 0.01])
         linear_extrude(label_depth - 0.02)
            labels_2d();
}

module pan_head_screw(len) {
   color(c_steel) {
      difference() {
         scale([1, 1, 0.45])
            sphere(d = 5.6, $fn = 32);
         translate([0, 0, -5])
            cylinder(d = 10, h = 5);
         translate([-1.6, -0.3, 0.6])
            cube([3.2, 0.6, 3]);
         translate([-0.3, -1.6, 0.6])
            cube([0.6, 3.2, 3]);
      }
      translate([0, 0, -len])
         cylinder(d = 3, h = len);
   }
}

module mount_screws() {
   for (h = mount_holes)
      translate([h.x, h.y, 0])
         pan_head_screw(panel_t + rim_h + 4);
}

// Wire through a list of points
module wire(points, c) {
   color(c)
      for (i = [1 : len(points) - 1])
         hull() {
            translate(points[i - 1]) sphere(d = wire_d, $fn = 10);
            translate(points[i]) sphere(d = wire_d, $fn = 10);
         }
}

// GND and signal tab of every switch, as [x, y, z of the tab end]. Toggles:
// common (middle) and lower pin of one pole, lever up connects them.
// Rockers: the middle and upper tab of each rocker.
function wire_tabs() = [for (u = units)
   for (p = is_rocker(u) ? [[-rk_dx, 0], [rk_dx, 0]] : [[-tg_pin_pitch.x / 2, 0]])
      is_rocker(u)
         ? [[u[0] + p.x, rk_pin_pitch, -rk_body_depth - rk_tab.z], [u[0] + p.x, 0, -rk_body_depth - rk_tab.z]]
         : [[u[0] + p.x, 0, tg_body_z - tg_body_depth - tg_tab.z], [u[0] + p.x, -tg_pin_pitch.y, tg_body_z - tg_body_depth - tg_tab.z]]];

// GND daisy chained over the switches, a signal wire from every switch,
// all running down to a connector below the panel
module wires_part() {
   t = wire_tabs();
   z = min([for (w = t) w[0].z]) - 2;
   wire(concat(
      [for (w = t) [w[0].x, w[0].y, z]],
      [[panel_x1 - 4, t[len(t) - 1][0].y, z], [panel_x1 - 4, panel_y0 - 15, z]]), c_gnd);
   for (w = t)
      wire([w[0] + [0, 0, 0.5], [w[0].x, w[0].y, z]], c_gnd);
   for (i = [0 : len(t) - 1]) {
      s = t[i][1];
      zs = z - 2 - (i % 3) * 1.6;
      wire([s + [0, 0, 0.5], [s.x + 1.5, s.y, zs], [s.x + 1.5, panel_y0 + 3, zs], [s.x + 1.5, panel_y0 - 15, zs]],
           wire_colors[i % len(wire_colors)]);
   }
}

module dashed_line(from_z, to_z, d = 0.5) {
   color(c_line, 0.6)
      for (z = [from_z : 6 : to_z - 3])
         translate([0, 0, z])
            cylinder(d = d, h = 3, $fn = 8);
}

module assembled_view() {
   panel_part();
   switches_part();
   mount_screws();
}

// The pilot's view
module front_view() {
   assembled_view();
}

module back_view() {
   assembled_view();
   wires_part();
}

// Rockers come in from the front, toggles from the back
module exploded_view(e = 30) {
   panel_part();
   for (u = units)
      translate([u[0], 0, 0])
         if (is_rocker(u)) {
            dashed_line(0, e - rk_body_depth);
            translate([0, 0, e])
               rocker2_part(u[3], [is_on(u[4]), is_on(u[4] + 1)]);
         } else {
            dashed_line(-e + tg_thread_len, e);
            translate([0, 0, -e])
               toggle_part(is_on(u[4]));
            translate([0, 0, e])
               toggle_nut_part();
         }
   for (h = mount_holes)
      translate([h.x, h.y, 0])
         dashed_line(0, 1.6 * e, 0.35);
   translate([0, 0, 1.6 * e])
      mount_screws();
}

// Panel and switch cut vertically through the middle of unit u
module section_view(u, w = 40) {
   color(c_cut)
      render()
         intersection() {
            panel();
            translate([u[0] - w, panel_y0 - 1, -50])
               cube([w, panel_size.y + 2, 100]);
         }
   unit_part(u, cut = true);
}

rotate([0, 180, 0]) panel(); // Make module panel

//switches_part(); // Ignore module

//assembled_view(); // Make view main -30,0,-12
//front_view(); // Make view front 0,0,0
//back_view(); // Make view back 150,0,195
//exploded_view(); // Make view exploded 62,0,30
//section_view(units[0]); // Make view section_rocker 100,0,70
//section_view(units[4], 1.5 * tg_pitch); // Make view section_toggle 100,0,70
