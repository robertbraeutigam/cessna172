// Hub: Mega, servo Nano and the Cat5 ports
//
// The box under the cockpit that holds the SimVim Arduino Mega, the Nano
// with the SimVim servo firmware and one RJ45 breakout board per port. Every
// component (switch panel, pedestal, ...) plugs into a port with a straight
// Cat5 patch cable; all ports have the same pinout (README, Connections).
//
// - The RJ45 boards stand on low standoffs in a row along the front wall,
//   their jacks behind cut-outs in it, numbered 1.. from the left. Their 8
//   pin angled headers point into the box.
// - Behind them is a free strip for the jumper wires, then the Mega
//   (left, its USB and power jacks through the left wall) and a half size
//   breadboard (right) with the Nano plugged into it. The breadboard is the
//   bus: its rails carry 5 V and GND, four of its columns S0..S3, so every
//   port plugs into it with plain jumper wires.
// - Nothing is soldered: male-female jumpers from the RJ45 pins to the
//   Mega and the breadboard, male-male ones from the breadboard to the Mega.
// - A lid with a locating lip is screwed onto four corner posts. Four ears
//   on the floor screw the box onto the frame or under the desk.
//
// Coordinates: x along the front wall (port 1 on the left), y away from the
// ports, z up; the inside of the front wall is at y=0, the floor top at z=0.
// The box is printed floor down, the lid top down.
//
// Parts to buy (details in the README):
// - Arduino Mega 2560, Arduino Nano, half size breadboard (400 points)
// - ports x RJ45 breakout board (34 x 28 mm, 8 pin angled header)
// - 6 x M3 x 6 self tapping screws (Mega), 4 x M3 x 10 (lid),
//   3 x ports M2 x 6 screws (RJ45 boards)
// - male-female and male-male jumper wires
//
// Assembly: screw the RJ45 boards and the Mega onto their standoffs, stick
// the breadboard into its pocket, plug the Nano into it, wire it as in the
// README, screw the lid on.

$fn = 48;

// --- Printer ---
bed = [255, 255];            // Kobra 3 V2

// --- Box ---
wall = 2.5;
floor_t = 2.5;
inner_h = 52;                // floor top to the lid
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
ports = 6;
rj = [34, 28];               // PCB, along the wall x depth; the jack is on the 34 edge
rj_pcb_t = 1.4;
rj_jack = [16, 16, 13.5];    // width x depth x height (height MEASURE)
rj_jack_x = 7;               // PCB left edge to the jack (MEASURE)
rj_jack_inset = 0.5;         // PCB front edge to the jack face (MEASURE)
rj_holes = [[3.5, 8], [29.5, 5], [29.5, 16]];  // MEASURE: PCB front left corner
rj_hole_d = 3;               // in the PCB
rj_screw_hole = 2.1;         // M2 pilot hole
rj_standoff = [5.5, 4];      // diameter x height
rj_pins = 8;
rj_pin_x = 9.5;              // PCB left edge to pin 1 (MEASURE)
rj_pin_y = 19;               // PCB front edge to the header (MEASURE)
rj_pin_reach = 8;            // angled pins, past the header towards the back
port_gap = 4;                // between the boards
port_margin = 2;             // between a corner post and the first board
jack_clear = 0.4;            // around the jack in the wall cut-out
label_size = 6;              // port numbers above the jacks
label_depth = 0.6;
font = "Liberation Sans:style=Bold";

// --- Jumper wires ---
dupont = 30;                 // a plugged jumper: housing + bent wire, above its pin
cable_gap = 35;              // free strip behind the RJ45 boards

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

// --- Half size breadboard and Nano (MEASURE) ---
bb = [82.5, 54.5, 8.5];
bb_clear = 0.5;
bb_rim = [1.5, 3];           // pocket rim, width x height
nano = [43.2, 18, 1.6];
nano_lift = 2.5;             // under its PCB, above the breadboard
nano_x = 4;                  // from the breadboard's left end

// --- Power bus (later) ---
power_hole_d = 9;            // through the right wall, for the 2 wire 5 V bus

// --- Derived ---
port_x0 = post + port_margin;
port_x = function(i) port_x0 + i * (rj.x + port_gap);
inner_x = 2 * port_x0 + ports * rj.x + (ports - 1) * port_gap;
back_y = rj.y + cable_gap;   // where the Mega and the breadboard start
back_gap = post + 1;
inner_y = back_y + max(mega.y, bb.y + 2 * (bb_clear + bb_rim[0])) + back_gap;
outer = [inner_x + 2 * wall, inner_y + 2 * wall, floor_t + inner_h];
mega_x = mega_usb[3] - wall;  // the USB jack ends flush with the outside
mega_z = mega_standoff[1];
bb_x = inner_x - port_x0 - bb.x - bb_clear - bb_rim[0];
bb_y = back_y + bb_clear + bb_rim[0];
rj_z = rj_standoff[1];
ear_xs = [0, inner_x - ear.x];

// --- Checks ---
assert(outer.x <= bed.x && outer.y + 2 * ear.y <= bed.y,
       "Box does not fit the printer bed");
assert(rj_jack_x + rj_jack.x <= rj.x && rj_jack_inset + rj_jack.y < rj_pin_y,
       "RJ45 jack does not fit its board");
assert(rj_pin_x + (rj_pins - 1) * 2.54 < rj.x, "RJ45 header does not fit its board");
for (h = rj_holes)
   assert(h.x - rj_standoff[0] / 2 >= 0 && h.x + rj_standoff[0] / 2 <= rj.x
          && h.y - rj_standoff[0] / 2 >= 0 && h.y + rj_standoff[0] / 2 <= rj.y,
          "RJ45 standoff sticks out of its board");
assert(rj_pin_y + rj_pin_reach + 15 <= back_y,
       "No room for the jumpers behind the RJ45 boards");
assert(mega_x + mega.x + 20 <= bb_x - bb_clear - bb_rim[0],
       "Mega and breadboard are too close for the wiring");
assert(back_y + mega.y <= inner_y - post && bb_y + bb.y <= inner_y - post,
       "Mega or breadboard runs into the back posts");
assert(mega_z + mega_pcb_t + mega_header_h + dupont <= inner_h,
       "No room for the jumpers above the Mega");
assert(bb.z + nano_lift + nano.z + dupont <= inner_h,
       "No room for the jumpers above the breadboard");
assert(nano_x + nano.x <= bb.x && nano.y < bb.y, "Nano does not fit the breadboard");
assert(rj_z + rj_pcb_t + rj_jack.z + jack_clear + label_size + 2 <= inner_h,
       "No room for the port numbers above the jacks");
assert(mega_z + mega_pcb_t + mega_usb[2] + jack_cut_clear < inner_h - lip_h,
       "USB cut-out runs into the lid lip");

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
      for (i = [0 : ports - 1]) {
         x = port_x(i) + rj_jack_x;
         z = rj_z + rj_pcb_t;
         translate([x - jack_clear, -wall - 1, z - jack_clear])
            cube([rj_jack.x + 2 * jack_clear, wall + 2, rj_jack.z + 2 * jack_clear]);
         translate([x + rj_jack.x / 2, -wall + label_depth, z + rj_jack.z + jack_clear + 2])
            rotate([90, 0, 0])
               linear_extrude(label_depth + 1)
                  text(str(i + 1), size = label_size, font = font, halign = "center");
      }
      // Mega USB and power jacks in the left wall
      for (j = [mega_usb, mega_power])
         translate([-wall - 1, back_y + j[0] - jack_cut_clear, mega_z + mega_pcb_t - jack_cut_clear])
            cube([wall + 2, j[1] - j[0] + 2 * jack_cut_clear, j[2] + 2 * jack_cut_clear]);
      // Power bus, later: through the right wall at the back
      translate([inner_x - 1, inner_y - post - power_hole_d, inner_h / 2])
         rotate([0, 90, 0]) cylinder(d = power_hole_d, h = wall + 2);
   }
   // Corner posts for the lid screws
   for (x = [0, inner_x - post], y = [0, inner_y - post])
      translate([x, y, 0])
         difference() {
            cube([post, post, inner_h]);
            translate([post / 2, post / 2, inner_h / 3]) cylinder(d = post_hole, h = inner_h);
         }
   // RJ45 standoffs
   for (i = [0 : ports - 1], h = rj_holes)
      translate([port_x(i) + h.x, h.y, 0])
         standoff(rj_standoff, rj_screw_hole);
   // Mega standoffs
   for (h = mega_holes)
      translate([mega_x + h.x, back_y + h.y, 0])
         standoff(mega_standoff, mega_screw_hole);
   // Breadboard pocket rim
   translate([bb_x - bb_clear, bb_y - bb_clear, 0])
      linear_extrude(bb_rim[1])
         difference() {
            offset(delta = bb_rim[0]) square([bb.x + 2 * bb_clear, bb.y + 2 * bb_clear]);
            square([bb.x + 2 * bb_clear, bb.y + 2 * bb_clear]);
         }
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
            text("SIMVIM HUB {{gitrev}}", size = 8, font = font, halign = "center", valign = "center");
   }
}

// --- View-only parts ---

c_print = "#5b8fd6";
c_lid = "#7aa6e0";
c_pcb_green = "#2f8f4e";
c_pcb_blue = "#1f5fa8";
c_steel = "#b9c0c8";
c_black = "#2b2e33";

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
      color("#d8c070")
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

module bb_part() {
   color("#f2f2ee") cube(bb);
   color("#d6d6d0") translate([0, bb.y / 2 - 1.5, bb.z - 0.5]) cube([bb.x, 3, 1]);
   // Power rails
   color("#d84040") for (y = [3.5, bb.y - 6.5]) translate([2, y, bb.z]) cube([bb.x - 4, 0.6, 0.05]);
   color("#3060c0") for (y = [6.5, bb.y - 3.5]) translate([2, y, bb.z]) cube([bb.x - 4, 0.6, 0.05]);
   // Nano across the middle channel, USB to the left
   translate([nano_x, (bb.y - nano.y) / 2, bb.z + nano_lift]) {
      color(c_pcb_blue) cube(nano);
      color(c_steel) translate([-1.5, nano.y / 2 - 4, nano.z]) cube([9, 8, 4]);
      color(c_black) translate([20, nano.y / 2 - 3.5, nano.z]) rotate([0, 0, 45]) cube([5, 5, 1]);
   }
}

module box_part() { color(c_print) box(); }
module lid_part() { color(c_lid) lid(); }

module inside_parts() {
   for (i = [0 : ports - 1])
      translate([port_x(i), 0, rj_z]) rj_part();
   translate([mega_x, back_y, mega_z]) mega_part();
   translate([bb_x, bb_y, 0]) bb_part();
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
//inside_view(); // Make view top 0,0,0
