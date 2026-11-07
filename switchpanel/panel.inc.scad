// Panel basics, shared by the ignition and the switch panel
//
// The two panels are printed separately and mounted side by side, the
// ignition on the left (seen from the front), like the one piece lower left
// panel of the 172N. So they share their height, thickness, rim, mount
// holes, corners and lettering. Both files "include" this one.
//
// The panels are modeled in their own coordinates, so the shared geometry
// here is in print orientation: front at z=0, back towards +z. x and y are
// the caller's.

// --- Panel ---
panel_h = 80;                // height of both panels
panel_t = 3;
panel_corner_r = 4;          // outer corners; the two corners where the panels meet are square
rim_w = 2.5;                 // stiffening rim around the back
rim_h = 8;
mount_d = 3.3;               // M3
mount_inset = 6;             // mount hole center to the panel edge
boss_d = 8;                  // overlaps the rim (mount_inset - boss_d / 2 < rim_w)

// --- Lettering, engraved into the front and filled in ---
font = "Liberation Sans:style=Bold";
label_size = 3;
label_depth = 0.6;
group_label_size = 3.2;
gitrev_depth = 0.4;          // version on the back

// --- View colors ---
c_panel = "#4a4f57";
c_label = "#f4f4f4";

assert(mount_inset - boss_d / 2 <= rim_w - 0.3, "Mount bosses must overlap the rim");

// Mount holes in the four corners of a panel from x0 to x1, y0 up
function panel_corner_holes(x0, x1, y0) =
   [for (x = [x0 + mount_inset, x1 - mount_inset], y = [y0 + mount_inset, y0 + panel_h - mount_inset]) [x, y]];

// Outline from x0 to x1, y0 up. round0 / round1: round the corners on the
// x0 / x1 side, square ones meet the other panel.
module panel_outline_2d(x0, x1, y0, round0 = true, round1 = true) {
   r = panel_corner_r;
   hull()
      for (c = [[x0, round0, 1], [x1, round1, -1]], y = [y0 + r, y0 + panel_h - r]) {
         x = c[0] + c[2] * r;
         translate([x, y])
            if (c[1])
               circle(r = r);
            else
               square(2 * r, center = true);
      }
}

// Front plate, rim and mount bosses with their holes, front at z=0
module panel_blank(x0, x1, y0, holes, round0 = true, round1 = true) {
   difference() {
      union() {
         linear_extrude(panel_t)
            panel_outline_2d(x0, x1, y0, round0, round1);
         translate([0, 0, panel_t - 0.01])
            linear_extrude(rim_h + 0.01)
               difference() {
                  panel_outline_2d(x0, x1, y0, round0, round1);
                  offset(delta = -rim_w)
                     panel_outline_2d(x0, x1, y0, round0, round1);
               }
         for (h = holes)
            translate([h.x, h.y, panel_t - 0.01])
               cylinder(d = boss_d, h = rim_h + 0.01);
      }
      for (h = holes)
         translate([h.x, h.y, -1])
            cylinder(d = mount_d, h = panel_t + rim_h + 2);
   }
}

// Pan head screw from the front: head on z=0 (outside is -z), shank to +z
module mount_screw(len, c = "#b9c0c8") {
   color(c) {
      difference() {
         scale([1, 1, 0.45])
            sphere(d = 5.6, $fn = 32);
         translate([0, 0, 0])
            cylinder(d = 10, h = 5);
         translate([-1.6, -0.3, -3.6])
            cube([3.2, 0.6, 3]);
         translate([-0.3, -1.6, -3.6])
            cube([0.6, 3.2, 3]);
      }
      cylinder(d = 3, h = len);
   }
}
