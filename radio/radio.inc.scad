// Radio stack basics, shared by the units of the radio stack
//
// The stack is two KX155 NAV/COM units (kx155.scad) and, later, the
// transponder, stacked without gaps like in the real panel. All units are
// as wide as the KX155 has to be for its 7 segment digits, and they go through
// one cut-out in the cockpit sheet (frame/). Each unit's face has a flange on
// its left and right ends only (none at the top and bottom, where the units
// meet), with two M3 screws in each flange onto the sheet, nuts behind it.
// Stacked units' bodies touch: the cut-out is as high as the stack.
//
// Coordinates are the cockpit's: x to the pilot's right, y backwards (into
// the panel), z up. A unit's face plate starts at y=0 (its front) and is
// plate_t thick, the separate thin front face is in front of it (y from
// -face_t to 0), the body goes back from it. x goes from 0 (the face's left
// end) to the unit's width, z from 0 (its bottom) to unit_h.

// --- Unit ---
unit_h = 50.8;               // KX155 face height, 2.00"
plate_t = 2;                 // printed plate behind the face
face_t = 1;                  // separate front face, printed front side up
flange_w = 9;                // face beyond the body, left and right
wall = 2;                    // body walls
corner_r = 1;                // face corners
mount_d = 3.3;               // M3
mount_inset = 4.5;           // mount hole center to the face's end and its top/bottom
mount_nut_r = 3.2;           // M3 nut, across the corners / 2, behind the sheet
sheet_cut_clear = 1;         // sheet cut-out beyond the bodies, left and right (frame/)

// --- 7 segment digits, MEASURE (0.28" 3 digit, common cathode, e.g. LDT-N2804RI) ---
dig_n = 3;                   // digits per module
dig_pitch = 7.5;             // digit to digit
dig_mod = [22.5, 6.1, 10];   // module: width (x), depth (y, without pins), height (z)
dig_char_h = 7;              // lit digit height (0.28")
filter_t = 2;                // red transparent acrylic behind the windows
board_t = 1.6;               // perfboard

// --- Lettering, standing out of the face for a white paint pen ---
label_raise = 0.6;
font = "Liberation Sans:style=Bold";
label_size = 2.4;
gitrev_depth = 0.4;

// --- View colors ---
c_face = "#1e1f22";
c_plate = "#3d7bd9";
c_label = "#f4f4f4";
c_knob = "#141516";
c_filter = "#5a0a0a";
c_lit = "#ff3a1a";
c_board = "#2f7d4a";
c_part = "#2a2b2e";
c_steel = "#b9c0c8";

assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear,
       "Mount nuts do not sit on the sheet, make flange_w wider");
assert(mount_d / 2 + 1.2 <= mount_inset, "Mount holes too close to the face edge");
assert(abs(dig_mod.x - dig_n * dig_pitch) < 0.5, "Digit modules do not butt into an even row");

// Mount holes of a unit w wide: [x, z], two in each end flange
function unit_holes(w) =
   [for (x = [mount_inset, w - mount_inset], z = [mount_inset, unit_h - mount_inset]) [x, z]];

// Face outline in x/z
module unit_face_2d(w) {
   offset(r = corner_r) offset(delta = -corner_r)
      square([w, unit_h]);
}

// Extrudes a 2D shape in x/z (z as the 2D y) from y0 to y0 + t
module ext_y(y0, t) {
   translate([0, y0 + t, 0])
      rotate([90, 0, 0])
         linear_extrude(t)
            children();
}

// Pan head screw from the front, head at y=0, shank to +y
module mount_screw(len) {
   color(c_steel)
      rotate([-90, 0, 0]) {
         translate([0, 0, -1.8]) cylinder(d = 5.6, h = 1.8, $fn = 24);
         cylinder(d = 3, h = len, $fn = 16);
      }
}
