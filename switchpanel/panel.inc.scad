// Panel basics, shared by the ignition and the switch panel
//
// The two panels are printed separately and mounted side by side, the
// ignition on the left (seen from the front), like the one piece lower left
// panel of the 172N. So they share their height, thickness, rim, flange,
// mount holes, corners and lettering. Both files "include" this one.
//
// They mount on the cockpit sheet (frame/): the back of a panel, panel_h
// high and closed by the rim, goes through a hole in the sheet, and the
// face flange around it is screwed onto the sheet (M3, nuts behind the
// sheet). The flange is on the top, the bottom and the outer end; where
// the two panels meet there is none, so their backs go through one hole.
//
// The panels are modeled in their own coordinates, so the shared geometry
// here is in print orientation: front at z=0, back towards +z. x and y are
// the caller's, and x0, x1, y0 always give the back (the rim's outside).

// --- Panel ---
panel_h = 80;                // height of the back of both panels
panel_t = 3;
panel_corner_r = 4;          // outer corners; the two corners where the panels meet are square
rim_w = 2.5;                 // stiffening rim around the back, goes through the sheet
rim_h = 8;
flange_w = 10;               // face beyond the back, screwed onto the sheet
face_h = panel_h + 2 * flange_w;
mount_d = 3.3;               // M3
mount_inset = 4.5;           // mount hole center to the face edge
mount_nut_r = 3.2;           // M3 nut, across the corners / 2, behind the sheet
sheet_cut_clear = 1;         // sheet hole beyond the back, all round (frame/)

// --- Lettering, engraved into the front and filled in ---
font = "Liberation Sans:style=Bold";
label_size = 3;
label_depth = 0.6;
group_label_size = 3.2;
gitrev_depth = 0.4;          // version on the back

// --- View colors ---
c_panel = "#4a4f57";
c_label = "#f4f4f4";

assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear,
       "Mount nuts do not sit on the sheet, make flange_w wider");
assert(mount_d / 2 + 1.2 <= mount_inset, "Mount holes too close to the face edge");

// Mount holes in the flange: top and bottom row
function panel_mount_y0(y0) = y0 - flange_w + mount_inset;
function panel_mount_y1(y0) = y0 + panel_h + flange_w - mount_inset;

// Mount holes in the four corners of the face of a panel whose back goes
// from x0 to x1, y0 up. round0 / round1 as for panel_outline_2d.
function panel_corner_holes(x0, x1, y0, round0 = true, round1 = true) =
   [for (x = [round0 ? x0 - flange_w + mount_inset : x0 + mount_inset,
              round1 ? x1 + flange_w - mount_inset : x1 - mount_inset],
         y = [panel_mount_y0(y0), panel_mount_y1(y0)]) [x, y]];

// Outline from x0 to x1, y0 up, h high. round0 / round1: round the
// corners on the x0 / x1 side, square ones meet the other panel.
module panel_outline_2d(x0, x1, y0, round0 = true, round1 = true, h = panel_h) {
   r = panel_corner_r;
   hull()
      for (c = [[x0, round0, 1], [x1, round1, -1]], y = [y0 + r, y0 + h - r]) {
         x = c[0] + c[2] * r;
         translate([x, y])
            if (c[1])
               circle(r = r);
            else
               square(2 * r, center = true);
      }
}

// The face: the back's outline with the flange on the top, the bottom and
// the rounded (outer) ends
module panel_face_2d(x0, x1, y0, round0 = true, round1 = true) {
   panel_outline_2d(x0 - (round0 ? flange_w : 0), x1 + (round1 ? flange_w : 0), y0 - flange_w,
                    round0, round1, face_h);
}

// Face plate and rim, with the mount holes in the flange, front at z=0
module panel_blank(x0, x1, y0, holes, round0 = true, round1 = true) {
   difference() {
      union() {
         linear_extrude(panel_t)
            panel_face_2d(x0, x1, y0, round0, round1);
         translate([0, 0, panel_t - 0.01])
            linear_extrude(rim_h + 0.01)
               difference() {
                  panel_outline_2d(x0, x1, y0, round0, round1);
                  offset(delta = -rim_w)
                     panel_outline_2d(x0, x1, y0, round0, round1);
               }
      }
      for (h = holes)
         translate([h.x, h.y, -1])
            cylinder(d = mount_d, h = panel_t + 2);
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
