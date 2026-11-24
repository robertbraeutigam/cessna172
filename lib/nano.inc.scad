// Arduino Nano: the bought board (sizes, pinout, a view model) and the
// shallow rails it slides into, shared by every component with a Nano.
// The Makefiles copy lib/*.inc.scad into each component's target/, so a
// file includes it as <nano.inc.scad> (or through its component's include).
//
// Its own coordinates: the board's middle at x=y=0, lying on the surface
// the rails stand on (z=0, its underside at nano_under), component side
// up (+z), the mini USB jack at the +y end. Seen from the component side
// with the jack up, the digital row is on the right (+x). Each component
// turns and places it (with a proper rotation, not a mirror, or the rows
// swap sides).

// --- The board, MEASURE ---
nano_board = [18, 45];       // width (x) x length (y), the jack at +y
nano_t = 1.6;
nano_under = 2.5;            // parts and solder stubs under the board
nano_usb = [8, 4];           // jack: width, height over the board
nano_usb_len = 9;            // jack: length, it stands nano_usb_out over the board's end
nano_usb_out = 1;
nano_row = 15.24;            // between the two pin rows
nano_pin_pitch = 2.54;
nano_row_pins = 15;              // per row
nano_pad_d = 1.8;            // pin pads (and their solder) on both sides of the board
// The rows, each from the USB end (the Nano's pinout)
nano_digital_row = ["D12", "D11", "D10", "D9", "D8", "D7", "D6", "D5", "D4", "D3", "D2", "GND", "RST", "RX0", "TX1"];
nano_analog_row = ["D13", "3V3", "REF", "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7", "5V", "RST", "GND", "VIN"];
// Its 4 mounting holes (the official Nano: in line with the pin rows, one
// pitch beyond their ends, 40.64 x 15.24 mm). M2 does not go through
// them (1.8 mm), so the Nano goes in rails; they are only drawn.
nano_holes = [for (sx = [-1, 1], sy = [-1, 1]) [sx * nano_row / 2, sy * (nano_row_pins + 1) / 2 * nano_pin_pitch]];
nano_hole_d = 1.8;

// --- Its rails: a wall along each long edge with a shallow groove for the
// board's edge (a ledge under it, a lip over it). The ledges and lips only
// reach nano_rail_reach over the board, short of the pin rows' pads and
// solder, so the board slides in along y with its wires soldered on. Fitted
// to a real board: snug, it does not fall out. ---
nano_rail_w = 1.5;           // walls, beyond the groove
nano_rail_clear = 0.15;      // the board's long edges to the groove bottoms
nano_rail_reach = 0.35;      // ledges and lips over the board's edges
nano_rail_gap = 0.15;        // the board's top to the lips
nano_rail_lip_t = 0.8;
nano_rail_stop = 1.5;        // the stops at the ends, along y
nano_rail_end_clear = 0.2;   // the board's ends to the stops
// Derived
nano_rail_in = nano_board.x / 2 + nano_rail_clear;        // the groove bottoms, |x|
nano_rail_hw = nano_rail_in + nano_rail_w;                // the walls' outer faces, |x|
nano_rail_tip = nano_board.x / 2 - nano_rail_reach;       // the ledges' and lips' edges, |x|
nano_rail_h = nano_under + nano_t + nano_rail_gap + nano_rail_lip_t;   // the walls' height
nano_rail_end = nano_board.y / 2 + nano_rail_end_clear + nano_rail_stop;   // a stop's outer face, |y|
nano_top_h = nano_under + nano_t;                           // the component side, over the rails' surface

assert(nano_rail_tip >= nano_row / 2 + nano_pad_d / 2 + 0.1, "The Nano's rails reach onto the pin rows' solder, make nano_rail_reach smaller");
assert(nano_rail_reach - nano_rail_clear >= 0.15, "The Nano can slip out of its rails sideways, make nano_rail_clear smaller");

// A pin's place on the board, [x, y]. GND and RST are on both rows: the
// digital row's unless row = "analog".
function nano_pin_digital(name, row) = row == "analog" ? false : search([name], nano_digital_row)[0] != [];
function nano_pin_k(name, row) = let(d = search([name], nano_digital_row)[0], a = search([name], nano_analog_row)[0])
   assert(nano_pin_digital(name, row) ? d != [] : a != [], str("No Nano pin ", name))
   nano_pin_digital(name, row) ? d : a;
function nano_pin(name, row) = [(nano_pin_digital(name, row) ? 1 : -1) * nano_row / 2,
                                (nano_row_pins - 1) / 2 * nano_pin_pitch - nano_pin_k(name, row) * nano_pin_pitch];

// The rails, from y0 to y1 (the board's ends by default). far_stop: a wall
// across the far end (-y), the board slides in jack end last; jack_stop: a
// stop at each side of the jack end, clear of a plug plug_w wide, the board
// slides in from the far end, jack first. The rails run on to the stops.
// lips = false: ledges and walls only, the board drops in from above (where
// something else keeps it down).
module nano_rails(y0 = -nano_board.y / 2, y1 = nano_board.y / 2, far_stop = false, jack_stop = false, plug_w = 12, lips = true) {
   ya = far_stop ? min(y0, -nano_rail_end) : y0;
   yb = jack_stop ? max(y1, nano_rail_end) : y1;
   stop_x = plug_w / 2 + 0.5;
   assert(!jack_stop || nano_rail_in - stop_x >= 1.5, "The Nano's stops too narrow beside the plug");
   h = lips ? nano_rail_h : nano_top_h;
   for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) {
      translate([nano_rail_in, ya, -0.01])
         cube([nano_rail_w, yb - ya, h + 0.01]);
      translate([nano_rail_tip, ya, -0.01])
         cube([nano_rail_in - nano_rail_tip + 0.01, yb - ya, nano_under + 0.01]);
      if (lips)
         translate([nano_rail_tip, ya, nano_top_h + nano_rail_gap])
            cube([nano_rail_in - nano_rail_tip + 0.01, yb - ya, nano_rail_lip_t]);
      if (jack_stop)
         translate([stop_x, nano_rail_end - nano_rail_stop, -0.01])
            cube([nano_rail_in - stop_x + 0.01, nano_rail_stop, h + 0.01]);
   }
   if (far_stop)
      translate([-nano_rail_in, -nano_rail_end, -0.01])
         cube([2 * nano_rail_in, nano_rail_stop, nano_top_h + 0.01]);
}

// The board for the views: pin holes, mounting holes, the chip, the jack
module nano_part(c_board = "#1d4fa0") {
   color(c_board)
      difference() {
         translate([-nano_board.x / 2, -nano_board.y / 2, nano_under])
            cube([nano_board.x, nano_board.y, nano_t]);
         for (n = concat(nano_digital_row, nano_analog_row)) let(p = nano_pin(n))
            translate([p.x, p.y, nano_under - 1])
               cylinder(d = 1, h = nano_t + 2, $fn = 8);
         for (h = nano_holes)
            translate([h.x, h.y, nano_under - 1])
               cylinder(d = nano_hole_d, h = nano_t + 2, $fn = 16);
      }
   color("#202020")
      translate([0, -2, nano_top_h + 0.6])
         rotate([0, 0, 45]) cube([7, 7, 1.2], center = true);
   color("#b9c0c8")
      translate([-nano_usb.x / 2, nano_board.y / 2 + nano_usb_out - nano_usb_len, nano_top_h])
         cube([nano_usb.x, nano_usb_len, nano_usb.y]);
}
