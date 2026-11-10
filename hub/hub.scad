// Hub: the MobiFlight Mega and the Cat5 ports
//
// The box under the cockpit that holds the Arduino Mega with the MobiFlight
// firmware and one RJ45 breakout board per port. Every
// component (switch panel, pedestal, ...) plugs into a port with a straight
// Cat5 patch cable; all ports have the same pinout (README, Connections).
//
// - The RJ45 boards sit in two rows of six along the front wall, their
//   jacks behind cut-outs in it, numbered 1-6 (bottom) and 7-12 (top) from
//   the left, the numbers beside the jacks. The bottom boards are screwed
//   onto bosses on the floor (M2 from below), the top ones stand on bought
//   M2 brass standoffs on the bottom ones, in the same holes. Their 8 pin
//   angled headers point into the box.
// - The bus: pins 1-6 (S0, S1, S2, 5 V, GND, S3) of all boards are soldered
//   together, an insulated wire per line along each row and a short link
//   between the rows, so only pins 7 and 8 (SIG, AUX) of each port get a
//   jumper. Six wires take the bus from port 1 to a header on the
//   prototype board, where the Mega plugs in.
// - Behind them is a free strip for the jumper wires, then one row: the
//   Mega (left, its USB and power jacks through the left wall) and the
//   prototype board on standoffs (right, the bus header and room for small
//   extra circuits).
// - Nothing on the Mega is soldered: jumper wires go from the RJ45 pins
//   and the bus header to it. Servos and encoders go straight to Mega
//   pins, MobiFlight drives them without a second board.
// - A lid with a locating lip is screwed onto four corner posts. Four ears
//   on the floor screw the box onto the frame or under the desk.
//
// Coordinates: x along the front wall (port 1 on the left), y away from the
// ports, z up; the inside of the front wall is at y=0, the floor top at z=0.
// The box is printed floor down, the lid top down.
//
// Parts to buy (details in the README):
// - Arduino Mega 2560, 50 x 70 mm prototype board, an 8 pin female header (the bus header)
// - 12 RJ45 breakout boards (34 x 28 mm, 8 pin angled header)
// - 18 M2 x 20 female-female brass standoffs, 18 M2 x 12 screws (from
//   below), 18 M2 x 5 screws (top boards)
// - 6 x M3 x 6 self tapping screws (Mega), 4 x M3 x 10 (lid), 4 x M2 x 6
//   (prototype board)
// - insulated wire for the bus, male-female and male-male jumper wires
//
// Assembly: screw the bottom boards on with the standoffs, solder their
// bus, screw the top boards onto the standoffs and solder theirs and the
// link, wire the bus to the prototype board, screw it and the Mega on,
// plug the jumpers as in the README, screw the lid on.

$fn = 48;

// --- Printer ---
bed = [255, 255];            // Kobra 3 V2

// --- Box ---
wall = 2.5;
floor_t = 2.5;
inner_h = 50;                // floor top to the lid
post = 8;                    // lid screw posts in the corners, square
post_hole = 2.8;             // M3 self tapping into plastic
lid_t = 2.5;
lid_hole = 3.3;              // M3
lip_h = 3;                   // locating lip under the lid, inside the walls
lip_w = 1.5;
lip_clear = 0.4;
ear = [14, 12];              // mount ears on the floor, x along the wall x out
ear_t = 4;
ear_hole = 5.3;              // M5 (frame T-nut), or a wood screw into the desk
round_r = 2;                 // outer vertical edges

// --- RJ45 breakout board (MEASURE: from the listing, holes are guesses) ---
port_cols = 6;
port_rows = 2;
ports = port_cols * port_rows;
rj = [34, 28];               // PCB, along the wall x depth; the jack is on the 34 edge
rj_pcb_t = 1.4;
rj_jack = [16, 16, 13.5];    // width x depth x height (height MEASURE)
rj_jack_x = 7;               // PCB left edge to the jack (MEASURE)
rj_jack_inset = 0.5;         // PCB front edge to the jack face (MEASURE)
rj_holes = [[3.5, 8], [29.5, 5], [30, 15]];  // MEASURE: PCB front left corner
rj_screw_clear = 2.4;        // M2 from below through the floor boss
rj_counterbore = [4.2, 1.8]; // M2 screw head, from below
rj_standoff = [5.5, 4];      // floor boss, diameter x height
rj_solder = 1.5;             // solder joints under a PCB
rj_stack = 20;               // M2 female-female brass standoff between the rows
rj_stack_d = 4.6;            // its hex, across the corners
rj_pins = 8;
rj_pin_x = 9.5;              // PCB left edge to pin 1 (MEASURE)
rj_pin_y = 19;               // PCB front edge to the header (MEASURE)
rj_pin_reach = 8;            // angled pins, past the header towards the back
port_gap = 4;                // between the boards
port_margin = 2;             // between a corner post and the first board
jack_clear = 0.4;            // around the jack in the wall cut-out
label_size = 5;              // port numbers beside the jacks
label_depth = 0.6;
font = "Liberation Sans:style=Bold";

// --- Jumper wires and spacing ---
dupont = 30;                 // a plugged jumper: housing + bent wire, above its pin
cable_gap = 30;              // free strip behind the RJ45 boards
board_gap = 15;              // at least, between two boards in the row

// --- Arduino Mega 2560 (from the Arduino drawing) ---
mega = [101.6, 53.34];
mega_pcb_t = 1.6;
mega_holes = [[13.97, 2.54], [15.24, 50.8], [66.04, 7.62],
              [66.04, 35.56], [90.17, 50.8], [96.52, 2.54]];
mega_standoff = [6, 5];      // diameter x height
mega_screw_hole = 2.8;       // M3 self tapping
mega_header_h = 8.5;
// Jacks on the left edge: y from, y to, height, reach past the PCB edge
mega_usb = [31.75, 43.75, 10.9, 6.2];
mega_power = [3.3, 12.2, 11, 1.8];
jack_cut_clear = 0.6;

// --- Prototype board, 50 x 70 mm (MEASURE) ---
proto = [50, 70, 1.6];       // along the wall x depth
proto_holes_inset = 2.5;     // hole centers from the edges
proto_screw_hole = 2.1;      // M2 pilot hole
proto_standoff = [5.5, 6];   // room for the solder side under it
proto_parts_h = 9;           // tallest part soldered on it (female headers 8.5)
bus_header = 8;              // S0, S1, S2, S3, 5 V, GND, 5 V, GND

// --- Power bus (later) ---
power_hole_d = 9;            // through the back wall, behind the prototype board

// --- Derived ---
port_x0 = post + port_margin;
port_x = function(c) port_x0 + c * (rj.x + port_gap);
inner_x = 2 * port_x0 + port_cols * rj.x + (port_cols - 1) * port_gap;
port_z = function(r) rj_standoff[1] + r * (rj_pcb_t + rj_stack);  // PCB bottom
jack_z = function(r) port_z(r) + rj_pcb_t;                        // jack bottom
// The board row: Mega (left), prototype board (right)
row_y = rj.y + cable_gap;
mega_x = mega_usb[3] - wall;  // the USB jack ends flush with the outside
mega_z = mega_standoff[1];
proto_x = mega_x + mega.x + board_gap + 5;  // close to port 1, the bus wires are short
proto_y = row_y;
inner_y = max(row_y + mega.y + post + 1, proto_y + proto.y + 2);
outer = [inner_x + 2 * wall, inner_y + 2 * wall, floor_t + inner_h];
ear_xs = [0, inner_x - ear.x];
proto_hole_pos = [for (x = [proto_holes_inset, proto.x - proto_holes_inset],
                       y = [proto_holes_inset, proto.y - proto_holes_inset]) [x, y]];

// --- Checks ---
assert(outer.x <= bed.x && outer.y + 2 * ear.y <= bed.y,
       "Box does not fit the printer bed");
assert(outer.x <= bed.x && outer.y <= bed.y, "Lid does not fit the printer bed");
assert(rj_jack_x + rj_jack.x <= rj.x && rj_jack_inset + rj_jack.y < rj_pin_y,
       "RJ45 jack does not fit its board");
assert(rj_pin_x + (rj_pins - 1) * 2.54 < rj.x, "RJ45 header does not fit its board");
for (h = rj_holes) {
   assert(h.x - rj_standoff[0] / 2 >= 0 && h.x + rj_standoff[0] / 2 <= rj.x
          && h.y - rj_standoff[0] / 2 >= 0 && h.y + rj_standoff[0] / 2 <= rj.y,
          "RJ45 standoff sticks out of its board");
   assert(h.x + rj_stack_d / 2 < rj_jack_x || h.x - rj_stack_d / 2 > rj_jack_x + rj_jack.x,
          "Brass standoff runs into the jack");
   assert(h.y + rj_stack_d / 2 < rj_pin_y - 1.27
          || h.x + rj_stack_d / 2 < rj_pin_x - 1.27
          || h.x - rj_stack_d / 2 > rj_pin_x + (rj_pins - 0.5) * 2.54,
          "Brass standoff runs into the header");
}
assert(jack_z(0) + rj_jack.z + 1 <= port_z(1) - rj_solder,
       "Top RJ45 board sits on the bottom jack: longer standoffs");
assert(port_z(1) - jack_clear - (jack_z(0) + rj_jack.z + jack_clear) >= 3,
       "Too little wall between the jack rows");
assert(jack_z(port_rows - 1) + rj_jack.z + jack_clear <= inner_h - lip_h,
       "Top jacks run into the lid lip");
assert(rj.x - rj_jack_x - rj_jack.x - jack_clear - 1 + port_gap >= 1.4 * label_size,
       "No room for the port numbers beside the jacks");
assert(floor_t + rj_standoff[1] - rj_counterbore[1] >= 3, "Floor bosses too thin under the screw heads");
assert(rj_pin_y + rj_pin_reach + 15 <= row_y,
       "No room for the jumpers behind the RJ45 boards");
assert(proto_x + proto.x <= inner_x - post, "Prototype board runs into the right posts");
assert(bus_header * 2.54 <= proto.x - 10, "Bus header does not fit the prototype board");
assert(row_y + mega.y <= inner_y - post, "Mega runs into the back posts");
assert(mega_z + mega_pcb_t + mega_header_h + dupont <= inner_h,
       "No room for the jumpers above the Mega");
assert(proto_standoff[1] + proto.z + proto_parts_h + dupont <= inner_h,
       "No room above the prototype board");
assert(mega_z + mega_pcb_t + mega_usb[2] + jack_cut_clear < inner_h - lip_h,
       "USB cut-out runs into the lid lip");
assert(power_hole_d < proto.x, "Power bus hole does not fit behind the prototype board");

// --- Box ---

module rounded_rect(size, r) {
   translate([r, r]) offset(r) square([size.x - 2 * r, size.y - 2 * r]);
}

module box() {
   difference() {
      union() {
         // Floor and walls
         translate([-wall, -wall, -floor_t])
            linear_extrude(outer.z) rounded_rect([outer.x, outer.y], round_r);
         // Ears on the floor, front and back
         for (x = ear_xs, side = [0, 1])
            translate([x, side ? inner_y + wall : -wall - ear.y, -floor_t])
               cube([ear.x, ear.y, ear_t]);
      }
      // Inside
      cube([inner_x, inner_y, inner_h + 1]);
      // Ear holes
      for (x = ear_xs, side = [0, 1])
         translate([x + ear.x / 2, side ? inner_y + wall + ear.y / 2 : -wall - ear.y / 2, -floor_t - 1])
            cylinder(d = ear_hole, h = ear_t + 2);
      // Jack cut-outs and port numbers in the front wall
      for (r = [0 : port_rows - 1], c = [0 : port_cols - 1]) {
         x = port_x(c) + rj_jack_x;
         z = jack_z(r);
         translate([x - jack_clear, -wall - 1, z - jack_clear])
            cube([rj_jack.x + 2 * jack_clear, wall + 2, rj_jack.z + 2 * jack_clear]);
         translate([x + rj_jack.x + jack_clear + 1, -wall + label_depth, z + rj_jack.z / 2])
            rotate([90, 0, 0])
               linear_extrude(label_depth + 1)
                  text(str(r * port_cols + c + 1), size = label_size, font = font, valign = "center");
      }
      // RJ45 screws from below, through the floor bosses
      for (c = [0 : port_cols - 1], h = rj_holes)
         translate([port_x(c) + h.x, h.y, -floor_t - 1]) {
            cylinder(d = rj_screw_clear, h = floor_t + rj_standoff[1] + 2);
            cylinder(d = rj_counterbore[0], h = rj_counterbore[1] + 1);
         }
      // Mega USB and power jacks in the left wall
      for (j = [mega_usb, mega_power])
         translate([-wall - 1, row_y + j[0] - jack_cut_clear, mega_z + mega_pcb_t - jack_cut_clear])
            cube([wall + 2, j[1] - j[0] + 2 * jack_cut_clear, j[2] + 2 * jack_cut_clear]);
      // Power bus, later: through the back wall behind the prototype board
      translate([proto_x + proto.x / 2, inner_y - 1, inner_h / 2])
         rotate([-90, 0, 0]) cylinder(d = power_hole_d, h = wall + 2);
   }
   // Corner posts for the lid screws
   for (x = [0, inner_x - post], y = [0, inner_y - post])
      translate([x, y, 0])
         difference() {
            cube([post, post, inner_h]);
            translate([post / 2, post / 2, inner_h / 3]) cylinder(d = post_hole, h = inner_h);
         }
   // RJ45 floor bosses (drilled through above)
   for (c = [0 : port_cols - 1], h = rj_holes)
      translate([port_x(c) + h.x, h.y, 0])
         difference() {
            cylinder(d = rj_standoff[0], h = rj_standoff[1]);
            translate([0, 0, -1]) cylinder(d = rj_screw_clear, h = rj_standoff[1] + 2);
         }
   // Mega standoffs
   for (h = mega_holes)
      translate([mega_x + h.x, row_y + h.y, 0])
         standoff(mega_standoff, mega_screw_hole);
   // Prototype board standoffs
   for (h = proto_hole_pos)
      translate([proto_x + h.x, proto_y + h.y, 0])
         standoff(proto_standoff, proto_screw_hole);
}

module standoff(s, hole) {
   difference() {
      cylinder(d = s[0], h = s[1]);
      translate([0, 0, 1]) cylinder(d = hole, h = s[1]);
   }
}

// --- Lid ---

module lid() {
   c = lip_clear;
   difference() {
      union() {
         translate([-wall, -wall, inner_h])
            linear_extrude(lid_t) rounded_rect([outer.x, outer.y], round_r);
         // Lip inside the walls, cut back around the posts
         translate([0, 0, inner_h - lip_h])
            linear_extrude(lip_h)
               difference() {
                  translate([c, c]) square([inner_x - 2 * c, inner_y - 2 * c]);
                  translate([c + lip_w, c + lip_w])
                     square([inner_x - 2 * (c + lip_w), inner_y - 2 * (c + lip_w)]);
                  for (x = [0, inner_x - post - c], y = [0, inner_y - post - c])
                     translate([x - 0.01, y - 0.01]) square(post + c + 0.02);
               }
      }
      for (x = [post / 2, inner_x - post / 2], y = [post / 2, inner_y - post / 2])
         translate([x, y, inner_h - 1]) cylinder(d = lid_hole, h = lid_t + 2);
      // Name and version on top
      translate([inner_x / 2, inner_y / 2, inner_h + lid_t - label_depth])
         linear_extrude(label_depth + 1)
            text("MOBIFLIGHT HUB {{gitrev}}", size = 8, font = font, halign = "center", valign = "center");
   }
}

// --- View-only parts ---

c_print = "#5b8fd6";
c_lid = "#7aa6e0";
c_pcb_green = "#2f8f4e";
c_pcb_blue = "#1f5fa8";
c_steel = "#b9c0c8";
c_black = "#2b2e33";
c_pin = "#d8c070";

module rj_part() {
   color(c_pcb_green) cube([rj.x, rj.y, rj_pcb_t]);
   translate([0, 0, rj_pcb_t]) {
      color(c_steel)
         difference() {
            translate([rj_jack_x, rj_jack_inset, 0]) cube(rj_jack);
            translate([rj_jack_x + 2.2, rj_jack_inset - 1, 1.5]) cube([rj_jack.x - 4.4, 12, rj_jack.z - 4]);
         }
      color(c_black)
         translate([rj_pin_x - 1.27, rj_pin_y - 1.27, 0]) cube([rj_pins * 2.54, 2.54, 2.54]);
      color(c_pin)
         for (p = [0 : rj_pins - 1])
            translate([rj_pin_x + p * 2.54 - 0.32, rj_pin_y, 1.27 - 0.32])
               cube([0.64, rj_pin_reach, 0.64]);
   }
}

module mega_part() {
   color(c_pcb_blue)
      difference() {
         cube([mega.x, mega.y, mega_pcb_t]);
         for (h = mega_holes) translate([h.x, h.y, -1]) cylinder(d = 3.2, h = 4);
      }
   translate([0, 0, mega_pcb_t]) {
      color(c_steel)
         translate([-mega_usb[3], mega_usb[0], 0])
            cube([16.3, mega_usb[1] - mega_usb[0], mega_usb[2]]);
      color(c_black) {
         translate([-mega_power[3], mega_power[0], 0])
            cube([14.2, mega_power[1] - mega_power[0], mega_power[2]]);
         // Headers: power + analog at the front, digital at the back, the double row at the end
         translate([27, 0.6, 0]) cube([66, 2.54, mega_header_h]);
         translate([18, mega.y - 3.2, 0]) cube([72, 2.54, mega_header_h]);
         translate([mega.x - 7.6, 3, 0]) cube([5.08, 46, mega_header_h]);
         translate([36, 20, 0]) rotate([0, 0, 45]) cube([14, 14, 1.2]);
      }
   }
}

module proto_part() {
   color(c_pcb_green)
      difference() {
         cube(proto);
         for (h = proto_hole_pos) translate([h.x, h.y, -1]) cylinder(d = 2.2, h = 4);
      }
   color(c_pin)
      for (x = [6 : 2.54 : proto.x - 5], y = [6 : 2.54 : proto.y - 5])
         translate([x, y, proto.z]) cylinder(d = 1.2, h = 0.05, $fn = 8);
   // The bus header, at the front
   color(c_black) translate([5, 5, proto.z]) cube([bus_header * 2.54, 2.54, 8.5]);
}

// Brass standoffs between the rows
module stack_part() {
   color("#c8a24a")
      for (c = [0 : port_cols - 1], h = rj_holes)
         translate([port_x(c) + h.x, h.y, port_z(0) + rj_pcb_t])
            cylinder(d = rj_stack_d, h = rj_stack, $fn = 6);
}

// The soldered bus: one wire per line (pins 1-6) along each row, linked
// between the rows at port 1 / 7
c_bus = ["#3a7bd5", "#2fa84f", "#e0a020", "#d83a3a", "#2b2e33", "#9b59b6"];
module bus_part() {
   y = rj_pin_y + rj_pin_reach - 2;
   for (p = [0 : 5]) {
      x = rj_pin_x + p * 2.54;
      color(c_bus[p]) {
         for (r = [0 : port_rows - 1])
            translate([port_x(0) + x, y, jack_z(r) + 1.27 + 0.8])
               rotate([0, 90, 0]) cylinder(d = 1.2, h = port_x(port_cols - 1) - port_x(0), $fn = 8);
         translate([port_x(0) + x, y, jack_z(0) + 1.27 + 0.8])
            cylinder(d = 1.2, h = port_z(1) - port_z(0), $fn = 8);
      }
   }
}

module box_part() { color(c_print) box(); }
module lid_part() { color(c_lid) lid(); }

module inside_parts() {
   for (r = [0 : port_rows - 1], c = [0 : port_cols - 1])
      translate([port_x(c), 0, port_z(r)]) rj_part();
   stack_part();
   bus_part();
   translate([mega_x, row_y, mega_z]) mega_part();
   translate([proto_x, proto_y, proto_standoff[1]]) proto_part();
}

// Open, with everything in it
module inside_view() {
   box_part();
   inside_parts();
}

// Closed
module closed_view() {
   box_part();
   lid_part();
}

// The lid lifted off
module exploded_view(e = 45) {
   box_part();
   inside_parts();
   translate([0, 0, e]) lid_part();
}

box(); // Make module box
//lid(); // Make module lid

//inside_view(); // Make view main 35,0,205
//exploded_view(); // Make view exploded 60,0,30
//closed_view(); // Make view ports 70,0,-20
//closed_view(); // Make view right 70,0,70
//inside_view(); // Make view top 0,0,0
