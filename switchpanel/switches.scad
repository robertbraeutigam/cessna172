// Switch panel: master, lights, avionics
//
// A row of rocker switches, separate from the ignition: the red split
// MASTER (ALT, BAT) on the left, the single switches in the middle and the
// white split AVIONICS (BUS 1, BUS 2) on the right. Up is ON, like in the
// airplane.
//
// The switches are cheap KCD1 snap-in rockers (see switches.md). They snap
// into a cutout from the front. Their clips are made for thin panels, so
// the panel is thinned to sw_grip around each cutout by a pocket in the
// back. A rim and bosses on the back stiffen the long, thin panel.
//
// Every switch is plain SPST: one tab goes to a common GND wire, the other
// to a SimVim input (active low, like any switch to GND). ALT and BAT are
// separate switches, there is no mechanical interlock between them.
//
// Coordinates: the front of the panel is at z=0, +z points towards the
// pilot, x to the pilot's right, y up. The center of the first switch is at
// x=0, the switch centers are at y=0. The panel is printed front side down.
//
// Parts to buy (details in switches.md):
// - KCD1 rocker switches, 2 pin ON-OFF: 2 red, 7 black, 2 white
// - mount_count x M3 screws to mount the panel
// - wire: one GND wire daisy chained over all switches, one wire per switch
//
// Assembly: solder the wires (it is easier before the switch is in the
// panel), snap the switches in from the front, ON ("I") up, then mount the
// panel.

$fn = 48;

// Preview: which switches are shown ON, in panel order (missing ones are OFF)
view_on = [1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1];

// --- Printer ---
bed = [220, 220];            // MEASURE: the printer bed

// --- Rocker switch, KCD1-101 (MEASURE: nominal values from the listings) ---
sw_bezel = [15, 21];         // front bezel, x (width) and y (height)
sw_bezel_t = 2;              // bezel thickness in front of the panel
sw_bezel_r = 1;
sw_cutout = [13, 19];        // nominal panel cutout
sw_cutout_clear = 0.15;      // added on every side of the cutout
sw_grip = 1.5;               // panel thickness the snap clips hold best
sw_clip_room = 1.5;          // room around the cutout for the clips
sw_body_depth = 13;          // body length behind the front of the panel
sw_tab = [4.8, 0.8, 8];      // solder / quick connect tabs, width x thickness x length
sw_tab_pitch = 8;            // the two tabs are on the vertical center line
sw_rocker = [11.5, 17.5];
sw_rocker_h = 3;             // rocker center height in front of the bezel
sw_rocker_tilt = 14;

// --- Layout ---
// Groups from left to right: label above the group, switch labels (one
// list of lines each, top line first), switch pitch, color
groups = [
   ["MASTER", [["ALT"], ["BAT"]], 16, "red"],
   ["", [["FUEL", "PUMP"], ["BEACON"], ["LAND"], ["TAXI"], ["NAV"], ["STROBE"], ["PITOT", "HEAT"]], 19, "black"],
   ["AVIONICS", [["BUS 1"], ["BUS 2"]], 16, "white"],
];
group_gap = 21;              // between the switch centers of two groups

// --- Panel ---
panel_t = 3;
corner_r = 4;
margin_x = 7;                // panel end to the outer bezels
margin_bottom = 12;          // panel bottom to the bezels
margin_top = 4;              // panel top to the top label
rim_w = 2.5;
rim_h = 8;
mount_d = 3.3;               // M3
mount_inset = 6;             // mount hole center to the panel edge
mount_center = true;         // also a hole in the middle of the top and bottom edge
boss_d = 8;                   // overlaps the rim (mount_inset - boss_d / 2 < rim_w)

// --- Labels, engraved into the front ---
font = "Liberation Sans:style=Bold";
label_size = 3;
label_line = 4.2;            // line pitch of two-line labels
label_gap = 2.5;             // bezel to the lowest label line
label_depth = 0.6;
group_label_size = 3.2;
group_line_w = 0.6;          // line under a group label, over its switches
gitrev_depth = 0.4;

// --- Derived ---
function group_x(g) = g == 0 ? 0 : group_x(g - 1) + (len(groups[g - 1][1]) - 1) * groups[g - 1][2] + group_gap;
function group_end_x(g) = group_x(g) + (len(groups[g][1]) - 1) * groups[g][2];

// One entry per switch: [x, label lines, color]
switches = [for (g = [0 : len(groups) - 1]) for (i = [0 : len(groups[g][1]) - 1])
              [group_x(g) + i * groups[g][2], groups[g][1][i], groups[g][3]]];
last_x = switches[len(switches) - 1][0];

cutout = sw_cutout + 2 * [sw_cutout_clear, sw_cutout_clear];
pocket = cutout + 2 * [sw_clip_room, sw_clip_room];

label_y = sw_bezel.y / 2 + label_gap;               // lowest label baseline
group_line_y = label_y + label_line + label_size + 1;
group_label_y = group_line_y + group_line_w + 1.5;

panel_x0 = -sw_bezel.x / 2 - margin_x;
panel_x1 = last_x + sw_bezel.x / 2 + margin_x;
panel_y0 = -sw_bezel.y / 2 - margin_bottom;
panel_y1 = group_label_y + group_label_size + margin_top;
panel_size = [panel_x1 - panel_x0, panel_y1 - panel_y0];
panel_cx = (panel_x0 + panel_x1) / 2;

mount_holes = concat(
   [for (x = [panel_x0 + mount_inset, panel_x1 - mount_inset], y = [panel_y0 + mount_inset, panel_y1 - mount_inset]) [x, y]],
   mount_center ? [[panel_cx, panel_y0 + mount_inset], [panel_cx, panel_y1 - mount_inset]] : []);
mount_count = len(mount_holes);

// Distance from a mount boss to the nearest clip pocket (box to circle)
function box_dist(p, c, size) = norm([max(0, abs(p.x - c.x) - size.x / 2), max(0, abs(p.y - c.y) - size.y / 2)]);
min_boss_dist = min([for (h = mount_holes, s = switches) box_dist(h, [s[0], 0], pocket) - boss_d / 2]);
// Panel material between the clip pockets of neighbouring switches, <= 0
// means one shared pocket (fine, the cutouts are still apart)
webs = [for (i = [1 : len(switches) - 1]) switches[i][0] - switches[i - 1][0] - pocket.x];
min_web = min([for (w = webs) w > 0 ? w : 100]);
min_bezel_gap = min([for (i = [1 : len(switches) - 1]) switches[i][0] - switches[i - 1][0] - sw_bezel.x]);

echo(panel_size = panel_size, switches = len(switches));

// --- Sanity checks ---
assert(panel_size.x <= bed.x && panel_size.y <= bed.y, "Panel does not fit the printer bed");
assert(panel_t - sw_grip >= 1, "Clip pockets too shallow, make panel_t thicker or sw_grip thinner");
assert(sw_grip >= 0.8, "Panel too thin around the switches");
assert(min_bezel_gap >= 0.5, "Switch bezels touch, increase the pitch");
assert(min([for (i = [1 : len(switches) - 1]) switches[i][0] - switches[i - 1][0]]) - cutout.x >= 2,
       "Too little panel between two cutouts, increase the pitch");
assert(min_web >= 1.2, "Too thin a wall between two clip pockets, change the pitch");
assert(min_boss_dist >= 0.5, "A mount boss runs into a clip pocket, increase the margins");
assert(panel_y0 + rim_w + 0.5 <= -pocket.y / 2, "Rim runs into the clip pockets, increase margin_bottom");
assert(panel_x0 + rim_w + 0.5 <= -pocket.x / 2, "Rim runs into the clip pockets, increase margin_x");
assert(mount_inset - boss_d / 2 <= rim_w - 0.3, "Mount bosses must overlap the rim");
assert(len(view_on) <= len(switches), "view_on has more entries than there are switches");

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
   for (s = switches) {
      lines = s[1];
      for (i = [0 : len(lines) - 1])
         translate([s[0], label_y + i * label_line])
            text(lines[len(lines) - 1 - i], size = label_size, font = font, halign = "center");
   }
   for (g = [0 : len(groups) - 1])
      if (groups[g][0] != "") {
         x0 = group_x(g) - sw_bezel.x / 2;
         x1 = group_end_x(g) + sw_bezel.x / 2;
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
      for (s = switches)
         translate([s[0], 0, 0]) {
            translate([0, 0, -panel_t - 1])
               linear_extrude(panel_t + 2)
                  square(cutout, center = true);
            // Thin the panel for the snap clips
            translate([0, 0, -panel_t - 1])
               linear_extrude(panel_t - sw_grip + 1)
                  square(pocket, center = true);
         }
      for (h = mount_holes)
         translate([h.x, h.y, -panel_t - rim_h - 1])
            cylinder(d = mount_d, h = panel_t + rim_h + 2);
      translate([0, 0, -label_depth])
         linear_extrude(label_depth + 1)
            labels_2d();
      // Version on the back, mirrored so it reads from behind
      translate([panel_cx, panel_y1 - mount_inset, -panel_t - 1])
         linear_extrude(gitrev_depth + 1)
            mirror([1, 0])
               text("{{gitrev}}", size = 3, halign = "center", valign = "center");
   }
}

// --- Views (rendered to PNG by "make views") ---

c_panel = "#4a4f57";
c_cut = "#3d7bd9";            // panel in the section view
c_label = "#f4f4f4";
c_body = "#2a2b2e";
c_tab = "#d9b24a";
c_steel = "#b9c0c8";
c_line = "#8fd0ff";
c_gnd = "#1d1f22";
wire_colors = ["#e8433a", "#f5a030", "#f2d03b", "#4caf50", "#3d7bd9", "#8e5bd6", "#9aa3ad", "#eceff2"];
wire_d = 1.2;

function switch_color(name) =
   name == "red" ? "#d33a2c" : name == "white" ? "#eeeeea" : "#1b1c1e";
function is_on(i) = i < len(view_on) && view_on[i] == 1;
tab_end_z = -sw_body_depth - sw_tab.z;

// Keeps y <= 0 if cut is set (section view), color() outside of it then
// also colors the cut faces
module cut_if(cut) {
   if (cut)
      intersection() {
         children();
         translate([-100, -100, -100])
            cube([200, 100, 200]);
      }
   else
      children();
}

// KCD1 rocker switch, front of the panel at z=0
module rocker_switch_part(c, on, cut = false) {
   color(c)
      cut_if(cut) {
         difference() {
            linear_extrude(sw_bezel_t)
               rrect(sw_bezel, sw_bezel_r);
            translate([0, 0, -1])
               linear_extrude(sw_bezel_t + 2)
                  square(sw_rocker + [0.6, 0.6], center = true);
         }
         // Up is ON: the top half pressed in, the bottom half sticks out
         intersection() {
            translate([0, 0, -1])
               linear_extrude(sw_bezel_t + sw_rocker_h + 4)
                  rrect(sw_rocker, 0.8);
            translate([0, 0, sw_bezel_t + sw_rocker_h])
               rotate([on ? -sw_rocker_tilt : sw_rocker_tilt, 0, 0])
                  translate([-20, -20, -40])
                     cube([40, 40, 40]);
         }
      }
   color(c_body)
      cut_if(cut) {
         translate([0, 0, -sw_body_depth])
            linear_extrude(sw_body_depth)
               square(sw_cutout - [0.2, 0.2], center = true);
         // Snap clips, they catch behind the thinned panel
         for (m = [0, 1])
            mirror([m, 0, 0])
               translate([sw_cutout.x / 2 - 0.1, 0, -sw_grip - 0.3])
                  rotate([90, 0, 0])
                     linear_extrude(sw_cutout.y * 0.5, center = true)
                        polygon([[0, 0], [0.9, 0], [0, -5]]);
      }
   color(c_tab)
      for (y = [-1, 1])
         translate([-sw_tab.x / 2, y * sw_tab_pitch / 2 - sw_tab.y / 2, tab_end_z])
            difference() {
               cube(sw_tab);
               translate([sw_tab.x / 2, -1, 2.5])
                  rotate([-90, 0, 0])
                     cylinder(d = 1.6, h = 3, $fn = 12);
            }
}

module switches_part() {
   for (i = [0 : len(switches) - 1])
      translate([switches[i][0], 0, 0])
         rocker_switch_part(switch_color(switches[i][2]), is_on(i));
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

// GND daisy chained over the lower tabs, a signal wire on every upper tab,
// all running down to a connector below the panel
module wires_part() {
   gnd_z = tab_end_z + 2.5;
   tab_y = sw_tab_pitch / 2 + sw_tab.y / 2 + wire_d / 2;
   wire(concat(
      [for (s = switches) [s[0], -tab_y, gnd_z]],
      [[last_x + 6, -tab_y, gnd_z], [last_x + 6, panel_y0 - 15, gnd_z]]), c_gnd);
   for (i = [0 : len(switches) - 1]) {
      x = switches[i][0];
      z = gnd_z - 2 - (i % 3) * 1.6;
      wire([[x, tab_y, gnd_z], [x, tab_y + 1.5, z], [x, panel_y0 + 3, z], [x, panel_y0 - 15, z]],
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

module exploded_view(e = 30) {
   panel_part();
   for (s = switches)
      translate([s[0], 0, 0])
         dashed_line(0, e - sw_body_depth);
   for (h = mount_holes)
      translate([h.x, h.y, 0])
         dashed_line(0, 1.6 * e, 0.35);
   translate([0, 0, e])
      switches_part();
   translate([0, 0, 1.6 * e])
      mount_screws();
}

// Cut horizontally through the middle switch: the clip pocket thins the
// panel to sw_grip so the snap clips catch, the rim and a boss behind it
module section_view(w = 50) {
   i = floor(len(switches) / 2);
   x = switches[i][0];
   color(c_cut)
      intersection() {
         panel();
         translate([x - w / 2, panel_y0 - 1, -50])
            cube([w, 1 - panel_y0, 100]);
      }
   translate([x, 0, 0])
      rocker_switch_part(switch_color(switches[i][2]), is_on(i), cut = true);
}

rotate([0, 180, 0]) panel(); // Make module panel

//switches_part(); // Ignore module

//assembled_view(); // Make view main -30,0,-12
//front_view(); // Make view front 0,0,0
//back_view(); // Make view back 150,0,195
//exploded_view(); // Make view exploded 62,0,30
//section_view(); // Make view section 110,0,160
