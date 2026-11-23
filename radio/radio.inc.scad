// Radio stack basics, shared by the units of the radio stack
//
// The stack is the KMA 26 audio panel (kma26.scad), two KX155 NAV/COM
// units (kx155.scad) and the KT 76C transponder (kt76c.scad), top to
// bottom, stacked without gaps like in the real panel.
// All units are unit_w wide, as wide as the KX155 has to be for its 7
// segment digits; each has its real height. They go through
// one cut-out in the cockpit sheet (frame/). Each unit's face has a flange on
// its left and right ends only (none at the top and bottom, where the units
// meet), with two M3 screws in each flange onto the sheet, nuts behind it.
// Stacked units' bodies touch: the cut-out is as high as the stack.
//
// Coordinates are the cockpit's: x to the pilot's right, y backwards (into
// the panel), z up. A unit's face plate starts at y=0 (its front) and is
// plate_t thick, the separate thin front face is in front of it (y from
// -face_t to 0), the body goes back from it. x goes from 0 (the face's left
// end) to unit_w, z from 0 (its bottom) to the unit's height (unit_h for
// the KX155).

// --- Unit ---
unit_w = 224;                // every unit, the KX155's width (kx155.scad checks it)
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

// --- Parts the units share, MEASURE ---
tact = [6, 3.5, 1.5];        // tactile switch 6 x 6: body square, body height, button above the body
drv_board = [32, 32];        // MAX7219 8x8 matrix kit board: x, y (lying on the floor)
drv_high = 14;               // the parts on it, above the board

// --- Arduino Nano, MEASURE (instruments/instrument.inc.scad has the same values) ---
// Every unit has its own, running MobiFlight, with a USB cable out of the
// open back to the powered USB hub (hub/README.md)
nano_board = [18, 45];       // x, y (the USB jack at the back end)
nano_t = 1.6;
nano_under = 2.5;            // in floor rails: parts and solder stubs under the board
nano_usb = [8, 4];           // jack: width, height over the board
nano_high = 14;              // on a logic board: female header, board, USB jack
nano_rail_w = 1.5;

// --- CD74HC4067 breakout, MEASURE ---
mux_board = [41, 18];

// --- Rotary switch, MEASURE (1 pole 12 way, Lorlin CK type; all guesses) ---
// KT 76C function selector, KMA 26 mic selector
rot_bush = [9.5, 9];         // threaded bushing (3/8"): diameter, length from the mounting face
rot_nut = [14, 2.4];         // its nut: across flats, thickness
rot_body = [26, 16];         // body: diameter, depth behind the mounting face (with the lugs)
rot_shaft = [6, 18];         // diameter, length from the mounting face
rot_step = 30;               // degrees per position

// --- 3 mm LED, MEASURE ---
led = [3, 3.8, 5.3];         // diameter, flange diameter, height over the board

// --- Printing ---
fit = 0.3;
pilot_d = 2.8;               // M3 self tapping
boss_d = 5.6;
rail = [3, 5, 1];            // driver board rails: width, height, groove depth
drv_over = 1;                // driver board edge in the groove
tie_block = [10, 6, 6];      // x, y, z
rib_w = 0.8;                 // knob ribs
rib_depth = 0.6;
bore_play = 0.15;            // D bore
crush = [0.3, 0.45];         // round bores: oversize, crush ribs reaching this far in

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

// Mount holes of a unit w wide and h high: [x, z], two in each end flange
function unit_holes(w, h = unit_h) =
   [for (x = [mount_inset, w - mount_inset], z = [mount_inset, h - mount_inset]) [x, z]];

// Nut across the flats -> across the corners
function corners(af) = af / cos(30);

// Face outline in x/z
module unit_face_2d(w, h = unit_h) {
   offset(r = corner_r) offset(delta = -corner_r)
      square([w, h]);
}

module mount_holes_2d(w, h = unit_h) {
   for (p = unit_holes(w, h))
      translate(p)
         circle(d = mount_d, $fn = 24);
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

// Boss on the plate back, up to y1, with a pilot hole
module boss(x, z, y1) {
   translate([x, plate_t - 0.01, z])
      rotate([-90, 0, 0])
         difference() {
            cylinder(d = boss_d, h = y1 - plate_t + 0.01, $fn = 32);
            translate([0, 0, 2])
               cylinder(d = pilot_d, h = y1, $fn = 24);
         }
}

// Version, engraved into the back of the plate at x, z (on a flange)
module gitrev_cut(x, z) {
   translate([x, plate_t + 0.01, z])
      rotate([90, 0, 0])
         linear_extrude(gitrev_depth + 0.01)
            mirror([1, 0])
               rotate([0, 0, 90])
                  text("{{gitrev}}", size = 3, halign = "center", valign = "center");
}

// Ribbed round knob body along +z, back at z=0, front chamfered
module knob_body(d, len, ribs, skirt = [0, 0], ch = 1) {
   difference() {
      rotate_extrude($fn = 96)
         polygon(concat(
            skirt[0] > 0 ? [[0, 0], [skirt[0] / 2, 0], [skirt[0] / 2, skirt[1]], [d / 2, skirt[1] + (skirt[0] - d) / 2]]
                         : [[0, 0], [d / 2, 0]],
            [[d / 2, len - ch], [d / 2 - ch, len], [0, len]]));
      for (i = [0 : ribs - 1])
         rotate([0, 0, i * 360 / ribs])
            translate([d / 2, 0, skirt[1] + (skirt[0] > 0 ? (skirt[0] - d) / 2 : 0) + 0.5])
               rotate([0, 0, 45])
                  cube([rib_w, rib_w, len], center = false);
   }
}

// Round bore with three crush ribs, from z=z0, depth long
module crush_bore(d, z0, depth) {
   translate([0, 0, z0])
      difference() {
         cylinder(d = d + crush[0], h = depth, $fn = 48);
         for (a = [0, 120, 240])
            rotate([0, 0, a])
               translate([d / 2 - crush[1] / 2 + crush[0] / 2, -0.4, -1])
                  cube([crush[1] + 1, 0.8, depth + 2]);
      }
}

// Recesses in a knob's back for the nut and the bushing
module recesses(nut, bush) {
   translate([0, 0, -1]) cylinder(d = nut[0], h = nut[1] + 1, $fn = 6);
   translate([0, 0, -1]) cylinder(d = bush[0], h = bush[1] + 1, $fn = 48);
}

// --- View-only parts ---

// One 7 segment digit, c is "0".."9" or " ", dp: the point after it
seg_on = ["abcdef", "bc", "abdeg", "abcdg", "bcfg", "acdfg", "acdefg", "abc", "abcdefg", "abcdfg"];
module digit_2d(c, dp = false) {
   w = 3.8; h = dig_char_h; t = 0.9;
   segs = c == " " ? "" : seg_on[ord(c) - ord("0")];
   rects = [["a", [-w / 2, h / 2 - t, w, t]], ["d", [-w / 2, -h / 2, w, t]], ["g", [-w / 2, -t / 2, w, t]],
            ["f", [-w / 2, 0.2, t, h / 2 - 0.2]], ["e", [-w / 2, -h / 2, t, h / 2 - 0.2]],
            ["b", [w / 2 - t, 0.2, t, h / 2 - 0.2]], ["c", [w / 2 - t, -h / 2, t, h / 2 - 0.2]]];
   multmatrix([[1, 0.1, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) {
      for (r = rects)
         if (len([for (k = segs) if (k == r[0]) 1]) > 0)
            translate([r[1][0], r[1][1]]) square([r[1][2], r[1][3]]);
      if (dp)
         translate([w / 2 + 1, -h / 2 + 0.45]) circle(d = 0.9, $fn = 12);
   }
}

// A 3 digit module's body, front at y=0, left end at x=0, centered on z=0
module digit_module_part() {
   color(c_part)
      translate([0.1, 0, -dig_mod.z / 2])
         cube([dig_mod.x - 0.2, dig_mod.y, dig_mod.z]);
}

// MAX7219 kit board without the matrix, board's bottom left front corner at 0
module driver_board_part() {
   color("#c23b30") cube([drv_board.x, drv_board.y, board_t]);
   color(c_part) translate([drv_board.x / 2 - 7.6, 4, board_t]) cube([15.2, 31.8 - 8, 4]);
   color("#202020")
      for (dx = [3, drv_board.x - 5.5])
         translate([dx, 4, board_t]) cube([2.5, 20.3, 8.5]);
}

// The Nano's floor rails: a ledge under each long edge, a lip over it and
// a stop at the front; it slides in from the open back, its USB jack at
// y1, centered on x = cx (a dab of hot glue keeps it there)
module nano_rails(cx, y1) {
   y0 = y1 - nano_board.y;
   for (s = [-1, 1]) {
      xo = cx + s * (nano_board.x / 2 + 0.1);
      translate([s > 0 ? xo : xo - nano_rail_w, y0 - nano_rail_w, wall - 0.01])
         cube([nano_rail_w, nano_board.y + nano_rail_w, nano_under + nano_t + 0.8 + 0.01]);
      translate([s > 0 ? xo - 1.2 : xo, y0, wall - 0.01])
         cube([1.2, nano_board.y, nano_under + 0.01]);
      translate([s > 0 ? xo - 0.8 : xo, y0, wall + nano_under + nano_t + 0.1])
         cube([0.8 + 0.01, nano_board.y, 0.7]);
   }
   translate([cx - nano_board.x / 2 - 0.1, y0 - nano_rail_w, wall - 0.01])
      cube([nano_board.x + 0.2, nano_rail_w, nano_under + nano_t + 0.01]);
}

// The Nano in its floor rails (view only)
module nano_part(cx, y1) {
   translate([cx - nano_board.x / 2, y1 - nano_board.y, wall + nano_under]) {
      color("#1d4fa0") cube([nano_board.x, nano_board.y, nano_t]);
      color("#202020") translate([nano_board.x / 2 - 3.5, 18, nano_t]) cube([7, 7, 1.2]);
      color("#b9c0c8") translate([nano_board.x / 2 - nano_usb.x / 2, nano_board.y - 8, nano_t]) cube([nano_usb.x, 9, nano_usb.y]);
   }
}

// Tactile switch, the button's top at y=0, pressed along +y, centered on x/z
module tact_part() {
   color(c_part) translate([-tact.x / 2, tact.z, -tact.x / 2]) cube([tact.x, tact.y, tact.x]);
   color("#3a3a3a") rotate([-90, 0, 0]) cylinder(d = 3.5, h = tact.z + 0.1, $fn = 24);
}
