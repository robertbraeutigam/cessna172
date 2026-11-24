// The USB cable from a component's Arduino Nano to the powered USB hub:
// its plug and cable, the cable tie, and the printed blocks the cable is
// tied onto so that pulling it does not lever the Nano's jack. Shared by
// the components (bought parts' sizes, the blocks, a view of the tie). The
// Makefiles copy lib/*.inc.scad into each component's target/, so a file
// includes it as <usb.inc.scad>.

// --- The cable, MEASURE ---
usb_plug = [12, 9, 28];      // mini USB plug: width, height, length with its strain relief
cable_d = 4;
tie = [3.6, 1.3];            // cable tie, width x thickness
tie_clear = 0.6;             // added to the tie's width and thickness in a slot
tie_slot = tie + [tie_clear, tie_clear];

// --- Tie block: in line behind the plug, the cable lies in a groove on
// its top, the tie goes through a slot across its foot and around it ---
tie_block = [10, 13, 6];     // along the cable (x) x across (y) x height
tie_groove = 1.5;            // the cable's groove in its top
tie_gap = 2;                 // the plug's end to the block
tie_cable_h = tie_block.z - tie_groove + cable_d / 2;   // the cable's axis over the block's foot

assert(tie_block.y >= cable_d + 2 * tie_slot.y + 2, "Cable tie block too narrow for the cable");
assert(tie_block.z - tie_groove - tie_slot.y >= 2, "Cable tie block too thin above the slot");
assert(tie_block.x >= tie_slot.x + 4, "Cable tie block too short for the slot");

// The block, its foot on z=0, its middle over the origin, the cable along x
module tie_block() {
   difference() {
      translate([-tie_block.x / 2, -tie_block.y / 2, -0.01])
         cube(tie_block + [0, 0, 0.01]);
      translate([-tie_slot.x / 2, -tie_block.y / 2 - 1, -1])
         cube([tie_slot.x, tie_block.y + 2, tie_slot.y + 1]);
      translate([-tie_block.x / 2 - 1, 0, tie_cable_h])
         rotate([0, 90, 0]) cylinder(d = cable_d, h = tie_block.x + 2);
   }
}

// The tie for the views, around the cable on the block and through its slot
module tie_part(c = "#f0f0f0") {
   color(c)
      translate([0, 0, tie_cable_h])
         rotate([0, 90, 0])
            difference() {
               hull() {
                  cylinder(d = cable_d + 2 * tie.y, h = tie.x, center = true);
                  translate([tie_cable_h - tie_slot.y / 2, 0, 0])
                     cube([tie.y, tie_block.y - 2, tie.x], center = true);
               }
               hull() {
                  cylinder(d = cable_d, h = tie.x + 1, center = true);
                  translate([tie_cable_h - tie_slot.y / 2, 0, 0])
                     cube([0.01, tie_block.y - 2 - 2 * tie.y, tie.x + 1], center = true);
               }
            }
}

// --- Tie post: beside the cable where there is no room behind the plug
// (the radio units' open backs), the tie goes through a tunnel along it
// and around the cable beside it ---
tie_post = [10, 6, 6];       // along the cable (x) x across (y) x height
tie_tunnel = [4, 2];         // across x height, through the post along x
tie_tunnel_z = 1.5;          // its bottom over the post's foot

// The post, its foot on z=0, its middle over the origin
module tie_post() {
   difference() {
      translate([-tie_post.x / 2, -tie_post.y / 2, -0.01])
         cube(tie_post + [0, 0, 0.01]);
      translate([-tie_post.x / 2 - 1, -tie_tunnel.x / 2, tie_tunnel_z])
         cube([tie_post.x + 2, tie_tunnel.x, tie_tunnel.y]);
   }
}
