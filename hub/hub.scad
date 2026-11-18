// Hub: the MobiFlight Mega and the Cat5 ports
//
// The box under the cockpit that holds the Arduino Mega with the MobiFlight
// firmware and one RJ45 breakout board per port. Every
// component (switch panel, pedestal, ...) plugs into a port with a Cat5
// cable, soldered straight to the component at its other end. Ports 1-3
// are mux ports (S0-S3, SIG, AUX), ports 4-6 direct ports (six lines
// to their own Mega pins, servo power on the orange pair); 5 V and GND are
// pins 4 and 5 on all of them (README, Connections).
//
// - The RJ45 boards sit along two walls, their jacks behind cut-outs in
//   them, the numbers beside the jacks: the mux ports 1-3 along the front
//   wall from the left, the direct ports 4-6 along the right wall from the
//   front. They are screwed onto bosses on the floor (M3 self
//   tapping, from above). Their 8 pin angled headers point into the box.
//   More components than ports (or than the 6 muxes MobiFlight takes on a
//   Mega) get a second hub with its own Mega, not more ports here.
// - The distributor board: a 30 x 70 mm perfboard with male pin headers,
//   soldered on the bench and then screwed onto standoffs behind the Mega
//   (`board` view). It joins the shared lines (5 V and GND of all ports,
//   S0-S3 of the mux ports) and carries every resistor of the hub: 330 Ohm
//   in series with S0-S3 and the two servo signals, 4.7 kOhm pull-ups to
//   5 V on the mux SIG lines and on the direct-port switch and encoder
//   lines. Female-female jumpers go from the RJ45 pins to it, male-female
//   ones from it to the Mega.
// - Lines that need neither (AUX, pots, servo power) go from the RJ45 pin
//   straight to the Mega with a male-female jumper. Servos and encoders
//   go to Mega pins, MobiFlight drives them without a second board; a
//   servo's power goes to its own 5 V and GND pins on the Mega.
// - Nothing in the box is soldered: every wire is a plugged jumper, so a
//   port is rewired by moving jumpers and the Mega can be reused.
// - Behind the front ports is a strip for the jumper plugs, then the Mega
//   (its USB and power jacks through the left wall), left of the right
//   ports' jumper strip. The board is behind the Mega, on the right; left
//   of it is room for the power bus later (the hole in the back wall).
// - A lid with a locating lip is screwed onto four corner posts. Four ears
//   on the floor screw the box onto the frame or under the desk.
//
// Coordinates: x along the front wall (port 1 on the left), y away from it,
// z up; the inside of the front wall is at y=0, the floor top at z=0.
// The box is printed floor down, the lid top down.
//
// Parts to buy (details in the README):
// - Arduino Mega 2560
// - 6 RJ45 breakout boards (34 x 28 mm, 8 pin angled header)
// - distributor board: 30 x 70 mm perfboard, 52 male pin headers (2.54 mm),
//   6 x 330 Ohm, 8 x 4.7 kOhm, tinned wire
// - 24 M3 x 6 self tapping screws (RJ45 boards), 6 + 4 x M3 x 6 self
//   tapping screws (Mega, board), 4 x M3 x 10 (lid)
// - about 34 female-female and 28 male-female jumper wires, 20 cm
//
// Assembly: solder the distributor board on the bench, screw the RJ45
// boards, the Mega and the board on, plug the jumpers as in the README,
// screw the lid on.

$fn = 48;

// --- Printer ---
bed = [255, 255];            // Kobra 3 V2

// --- Box ---
wall = 2.5;
floor_t = 2.5;
inner_h = 36;                // floor top to the lid
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
port_front = 3;              // ports 1-3 on the front wall (the mux ports)
port_side = 3;               // ports 4-6 on the right wall (the direct ports)
port_cols = port_front + port_side;
rj = [34, 28];               // PCB, along the wall x depth; the jack is on the 34 edge
rj_pcb_t = 1.4;
rj_jack = [16, 16, 15];      // width x depth x height (height measured, width MEASURE)
rj_jack_x = (rj.x - rj_jack.x) / 2;  // centred on the board (measured)
rj_jack_inset = 0.5;         // PCB front edge to the jack face (MEASURE)
rj_hole_pitch = [28, 11];    // 4 corner holes, centre to centre (measured)
rj_hole_y = 5;               // PCB front edge to the front holes' centres (measured, 4.5-5)
// Centred along the board, from the PCB front left corner
rj_holes = [for (i = [0, 1], j = [0, 1])
   [(rj.x - rj_hole_pitch.x) / 2 + i * rj_hole_pitch.x, rj_hole_y + j * rj_hole_pitch.y]];
rj_screw_hole = 2.8;         // M3 self tapping, in the floor boss
rj_screw_depth = 5.5;        // into the boss and the floor, for an M3 x 6
rj_standoff = [6, 4];        // floor boss, diameter x height
rj_solder = 1.5;             // solder joints under a PCB
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
dupont = 20;                 // a plugged jumper: housing (14) + bent wire, past its pin
cable_gap = 15;              // strip behind the RJ45 boards, for the jumper plugs

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

// --- Distributor board (MEASURE: a 30 x 70 mm perfboard, 2.54 mm grid) ---
pb = [70, 30];               // along the back wall x depth
pb_t = 1.6;
pitch = 2.54;
pb_grid = [24, 10];          // holes along x, along y; row 0 faces the Mega
pb_holes = [[2.5, 2.5], [67.5, 2.5], [2.5, 27.5], [67.5, 27.5]];  // MEASURE: corner holes
pb_standoff = [5, 5];        // diameter x height
pb_screw_hole = 2.8;         // M3 self tapping
pb_header_h = 8.5;           // a male pin header above the board
pb_res_h = 11;               // a resistor standing upright
pb_gap = 2;                  // between the Mega and the board

// --- Distributor board layout ---
// Holes by [column, row]: columns from the left, row 0 towards the Mega.
// P<port>.<RJ45 pin> is a pin with a female-female jumper from that RJ45
// pin, D<n> one with a male-female jumper to that Mega pin.
pb_s_cols = [1, 3, 5, 7];        // S0-S3; behind them the servo signals
pb_gnd_col = 10;
pb_5v_col = 12;
pb_rails = [3, 6];               // 5 V rails from the 5V column to the right
pb_pull_cols = [14, 16, 18, 20, 22];
pb_power_names = ["P1", "P2", "P3", "P4", "P5", "P6", "Mega", "spare"];
pb_servos = [["P4.7", "D2"], ["P5.7", "D3"]];
// Pull-ups: [column index, back tier, from, to, name]
pb_pullups = [[0, false, "P1.7", "D26", "SIG P1"], [1, false, "P2.7", "D27", "SIG P2"],
              [2, false, "P3.7", "D28", "SIG P3"], [3, false, "P4.3", "D30", "P4 A"],
              [4, false, "P4.6", "D31", "P4 B"], [0, true, "P4.8", "D32", "P4 D"],
              [1, true, "P5.6", "D33", "P5 B"], [2, true, "P5.8", "D34", "P5 D"]];
// Column headings: [column, back side, text, kind]
pb_heads = concat(
   [for (i = [0 : 3]) [pb_s_cols[i], false, str("S", i), 0]],
   [[pb_gnd_col, false, "GND", 2], [pb_5v_col, false, "5V", 3]],
   [for (i = [0 : 1]) [pb_s_cols[i], true, str("P", 4 + i, " servo"), 4]],
   [for (i = [2 : 3]) [pb_s_cols[i], true, "spare", 5]],
   [for (i = [0 : len(pb_pull_cols) - 1], back = [false, true])
      let (l = [for (u = pb_pullups) if (u[0] == i && u[1] == back) u])
         [pb_pull_cols[i], back, len(l) ? l[0][4] : "spare", len(l) ? 1 : 5]]);
// Pins: [column, row, label, kind]: 0 from an RJ45 pin, 1 to the Mega, 2 GND, 3 5 V
pb_pins = concat(
   [for (c = pb_s_cols, r = [0 : 2]) [c, r, str("P", r + 1), 0]],
   [for (i = [0 : 3]) [pb_s_cols[i], 5, str("D", 22 + i), 1]],
   [for (i = [0 : 1]) each [[pb_s_cols[i], 6, pb_servos[i][0], 0],
                            [pb_s_cols[i], 9, pb_servos[i][1], 1]]],
   [for (c = [pb_gnd_col, pb_5v_col], r = [0 : 7])
      [c, r, pb_power_names[r], c == pb_gnd_col ? 2 : 3]],
   [for (u = pb_pullups) each [[pb_pull_cols[u[0]], u[1] ? 9 : 0, u[2], 0],
                               [pb_pull_cols[u[0]], u[1] ? 8 : 1, u[3], 1]]]);
// Resistors, standing: [column, body row, lead row, value]
pb_res = concat(
   [for (c = pb_s_cols) [c, 3, 4, "330"]],
   [for (i = [0 : 1]) [pb_s_cols[i], 7, 8, "330"]],
   [for (u = pb_pullups) u[1] ? [pb_pull_cols[u[0]], 7, 6, "4k7"]
                              : [pb_pull_cols[u[0]], 2, 3, "4k7"]]);
// Joined on the back (solder bridges, tinned wire): [col, row, col, row]
pb_links = concat(
   [for (c = pb_s_cols) each [[c, 0, c, 3], [c, 4, c, 5]]],
   [for (i = [0 : 1]) each [[pb_s_cols[i], 6, pb_s_cols[i], 7],
                            [pb_s_cols[i], 8, pb_s_cols[i], 9]]],
   [[pb_gnd_col, 0, pb_gnd_col, 7], [pb_5v_col, 0, pb_5v_col, 7]],
   [for (r = pb_rails) [pb_5v_col, r, pb_pull_cols[len(pb_pull_cols) - 1], r]],
   [for (u = pb_pullups) u[1] ? [pb_pull_cols[u[0]], 7, pb_pull_cols[u[0]], 9]
                              : [pb_pull_cols[u[0]], 0, pb_pull_cols[u[0]], 2]]);
// A hole on the board, from its front left corner, the grid centered
function pb_hole(c, r) = [(pb.x - (pb_grid.x - 1) * pitch) / 2 + c * pitch,
                          (pb.y - (pb_grid.y - 1) * pitch) / 2 + r * pitch];

// --- Power bus (later) ---
power_hole_d = 9;            // through the back wall, left of the board
power_room = 30;             // left of the board, for its distribution board

// --- Derived ---
port_x0 = post + port_margin;
port_x = function(i) port_x0 + i * (rj.x + port_gap);  // along its wall
port_z = rj_standoff[1];       // PCB bottom
jack_z = port_z + rj_pcb_t;    // jack bottom
// The Mega behind the ports, on the left
row_y = rj.y + cable_gap;
mega_x = mega_usb[3] - wall;  // the USB jack ends flush with the outside
mega_z = mega_standoff[1];
// The right ports: their jumpers end side_reach from the wall, clear of the
// front ports and the Mega
side_reach = rj_pin_y + dupont;
inner_x = max(port_x(port_front - 1) + rj.x, mega_x + mega.x) + side_reach + 2;
inner_y = max(row_y + mega.y + post + 1, port_x(port_side - 1) + rj.x + port_x0);
// Port c in its wall's frame: x along the wall (left to right from outside),
// y into the box from the inside of the wall, z up from the floor top
module at_port(c) {
   if (c < port_front) translate([port_x(c), 0, 0]) children();
   else translate([inner_x, port_x(c - port_front), 0]) rotate([0, 0, 90]) children();
}
// The distributor board behind the Mega, against the right ports' jumpers
pb_x = inner_x - side_reach - pb.x;
pb_y = row_y + mega.y + pb_gap;
pb_z = pb_standoff[1];
power_x = (post + pb_x) / 2;
outer = [inner_x + 2 * wall, inner_y + 2 * wall, floor_t + inner_h];
ear_xs = [0, inner_x - ear.x];

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
   assert(h.x + rj_standoff[0] / 2 <= rj_jack_x || h.x - rj_standoff[0] / 2 >= rj_jack_x + rj_jack.x
          || h.y - rj_standoff[0] / 2 >= rj_jack_inset + rj_jack.y,
          "RJ45 standoff under the jack");
}
assert(rj_standoff[1] >= rj_solder, "Floor bosses lower than the solder joints");
assert(rj_screw_depth <= floor_t + rj_standoff[1] - 0.8, "RJ45 screw holes go through the floor");
assert(jack_z + rj_jack.z + jack_clear <= inner_h - lip_h,
       "Jacks run into the lid lip");
assert(rj.x - rj_jack_x - rj_jack.x - jack_clear - 1 + port_gap >= 1.4 * label_size,
       "No room for the port numbers beside the jacks");
assert(rj_pin_y + dupont <= row_y,
       "No room for the jumpers behind the RJ45 boards");
assert(row_y + mega.y <= inner_y - post, "Mega runs into the back posts");
assert(mega_z + mega_pcb_t + mega_header_h + dupont <= inner_h,
       "No room for the jumpers above the Mega");
assert(mega_z + mega_pcb_t + mega_usb[2] + jack_cut_clear < inner_h - lip_h,
       "USB cut-out runs into the lid lip");
assert(inner_x - side_reach >= port_x(port_front - 1) + rj.x
       && inner_x - side_reach >= mega_x + mega.x,
       "Right ports' jumpers run into the front ports or the Mega");
assert(port_x(port_front - 1) + rj.x <= inner_x - post, "Front ports run into the posts");
assert(pb_x - post >= power_room, "No room for the power bus left of the board");
assert(pb_y + pb.y <= inner_y, "Distributor board runs into the back wall");
assert(pb_y + pb_hole(0, pb_grid.y - 1).y + pitch / 2 <= inner_y - lip_clear - lip_w,
       "Jumper plugs on the distributor board run into the lid lip");
assert(pb_z + pb_t + pb_header_h + dupont <= inner_h,
       "No room for the jumpers above the distributor board");
assert(pb_z + pb_t + pb_res_h <= pb_z + pb_t + pb_header_h + dupont - 5,
       "Resistors on the distributor board reach the jumper wires");
assert(pb_grid.x * pitch <= pb.x && pb_grid.y * pitch <= pb.y, "Hole grid does not fit the board");
// The edge columns stay empty: the standoffs may sit under them
for (h = pb_holes)
   assert(abs(h.x - pb_hole(1, 0).x) >= pb_standoff[0] / 2 + 1
          && abs(h.x - pb_hole(pb_grid.x - 2, 0).x) >= pb_standoff[0] / 2 + 1
          && h.x - pb_standoff[0] / 2 >= 0 && h.x + pb_standoff[0] / 2 <= pb.x
          && h.y - pb_standoff[0] / 2 >= 0 && h.y + pb_standoff[0] / 2 <= pb.y,
          "Distributor board standoff under a used hole or outside the board");
for (p = pb_pins, r = pb_res, l = pb_links)
   assert(p[0] > 0 && p[0] < pb_grid.x - 1 && p[1] >= 0 && p[1] < pb_grid.y
          && r[0] > 0 && r[0] < pb_grid.x - 1 && max(r[1], r[2]) < pb_grid.y
          && l[2] < pb_grid.x - 1 && max(l[1], l[3]) < pb_grid.y,
          "Distributor board layout runs off the hole grid");

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
      // Jack cut-outs and port numbers in the walls
      for (c = [0 : port_cols - 1]) at_port(c) {
         x = rj_jack_x;
         z = jack_z;
         translate([x - jack_clear, -wall - 1, z - jack_clear])
            cube([rj_jack.x + 2 * jack_clear, wall + 2, rj_jack.z + 2 * jack_clear]);
         translate([x + rj_jack.x + jack_clear + 1, -wall + label_depth, z + rj_jack.z / 2])
            rotate([90, 0, 0])
               linear_extrude(label_depth + 1)
                  text(str(c + 1), size = label_size, font = font, valign = "center");
      }
      // Mega USB and power jacks in the left wall
      for (j = [mega_usb, mega_power])
         translate([-wall - 1, row_y + j[0] - jack_cut_clear, mega_z + mega_pcb_t - jack_cut_clear])
            cube([wall + 2, j[1] - j[0] + 2 * jack_cut_clear, j[2] + 2 * jack_cut_clear]);
      // Power bus, later: through the back wall, left of the board
      translate([power_x, inner_y - 1, inner_h / 2])
         rotate([-90, 0, 0]) cylinder(d = power_hole_d, h = wall + 2);
   }
   // Corner posts for the lid screws
   for (x = [0, inner_x - post], y = [0, inner_y - post])
      translate([x, y, 0])
         difference() {
            cube([post, post, inner_h]);
            translate([post / 2, post / 2, inner_h / 3]) cylinder(d = post_hole, h = inner_h);
         }
   // RJ45 floor bosses, the pilot holes go on into the floor
   for (c = [0 : port_cols - 1], h = rj_holes) at_port(c)
      translate([h.x, h.y, 0])
         difference() {
            cylinder(d = rj_standoff[0], h = rj_standoff[1]);
            translate([0, 0, rj_standoff[1] - rj_screw_depth])
               cylinder(d = rj_screw_hole, h = rj_screw_depth + 1);
         }
   // Mega standoffs
   for (h = mega_holes)
      translate([mega_x + h.x, row_y + h.y, 0])
         standoff(mega_standoff, mega_screw_hole);
   // Distributor board standoffs
   for (h = pb_holes)
      translate([pb_x + h.x, pb_y + h.y, 0])
         standoff(pb_standoff, pb_screw_hole);
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

// The distributor board, built: pin headers, standing resistors
c_perf = "#d9c79a";
c_pb_pin = ["#1f1f1f", "#1f4e9a", "#1f1f1f", "#b03a0e"];
c_330 = "#e08a2c";
c_4k7 = "#2e86c1";
module pb_part() {
   color(c_perf)
      difference() {
         cube([pb.x, pb.y, pb_t]);
         for (h = pb_holes) translate([h.x, h.y, -1]) cylinder(d = 3, h = pb_t + 2);
      }
   translate([0, 0, pb_t]) {
      for (p = pb_pins) translate(pb_hole(p[0], p[1])) {
         color(c_pb_pin[p[3]]) translate([-1.27, -1.27, 0]) cube([2.54, 2.54, 2.5]);
         color(c_pin) translate([-0.32, -0.32, 0]) cube([0.64, 0.64, pb_header_h]);
      }
      for (r = pb_res) {
         color(r[3] == "330" ? c_330 : c_4k7)
            translate(pb_hole(r[0], r[1])) cylinder(d = 2.3, h = pb_res_h - 1.5, $fn = 12);
         color(c_steel) hull() {
            translate(concat(pb_hole(r[0], r[1]), pb_res_h - 1)) sphere(d = 0.6, $fn = 6);
            translate(concat(pb_hole(r[0], r[2]), pb_res_h - 1)) sphere(d = 0.6, $fn = 6);
         }
         color(c_steel) translate(pb_hole(r[0], r[2])) cylinder(d = 0.6, h = pb_res_h - 1, $fn = 6);
      }
   }
}

// The board layout drawing, component side, row 0 (the Mega) at the bottom
c_pb_head = ["#c0392b", "#2471a3", "#222222", "#d35400", "#8e44ad", "#999999"];
module board_view() {
   lt = 0.05;  // layers, stacked so the preview shows the upper one
   module layer(n) translate([0, 0, n * lt]) linear_extrude(lt) children();
   // On the board: on a patch of board color, over the holes
   module label(t, size = 0.8, c = "#222222", ha = "left", patch = false) {
      color(c) layer(6) text(t, size = size, font = font, halign = ha, valign = "center");
      if (patch) color(c_perf) layer(4) offset(delta = 0.15) hull()
         text(t, size = size, font = font, halign = ha, valign = "center");
   }
   color(c_perf) layer(0) offset(r = 0.6) offset(delta = -0.6) square(pb);
   color("#b08a3e") layer(1)
      for (c = [0 : pb_grid.x - 1], r = [0 : pb_grid.y - 1]) translate(pb_hole(c, r)) circle(d = 0.75, $fn = 12);
   color("#3a2f1a") layer(2)
      for (c = [0 : pb_grid.x - 1], r = [0 : pb_grid.y - 1]) translate(pb_hole(c, r)) circle(d = 0.3, $fn = 8);
   color("#7f8c8d") layer(3)
      for (l = pb_links) hull() {
         translate(pb_hole(l[0], l[1])) circle(d = 0.5, $fn = 12);
         translate(pb_hole(l[2], l[3])) circle(d = 0.5, $fn = 12);
      }
   for (r = pb_res) {
      color("#555555") layer(4) hull() {
         translate(pb_hole(r[0], r[1])) circle(d = 0.15, $fn = 6);
         translate(pb_hole(r[0], r[2])) circle(d = 0.15, $fn = 6);
      }
      color("#555555") layer(4) translate(pb_hole(r[0], r[2])) circle(d = 0.45, $fn = 12);
      color(r[3] == "330" ? c_330 : c_4k7) layer(5) translate(pb_hole(r[0], r[1])) circle(d = 1.35, $fn = 24);
      translate(pb_hole(r[0], (r[1] + r[2]) / 2) + [0.9, 0])
         label(r[3], 0.65, r[3] == "330" ? c_330 : c_4k7, patch = true);
   }
   for (p = pb_pins) translate(pb_hole(p[0], p[1])) {
      color(c_pb_pin[p[3]]) layer(5) square(1.2, center = true);
      color("#e6c34a") layer(6) square(0.45, center = true);
      // GND and 5V labelled on the left, clear of the 5 V rails
      left = p[3] >= 2;
      translate([left ? -0.85 : 0.85, 0])
         label(p[2], 0.6, p[3] == 1 ? "#1f4e9a" : "#222222", left ? "right" : "left", true);
   }
   for (h = pb_heads)
      translate([pb_hole(h[0], 0).x, h[1] ? pb.y + 1.6 : -1.6])
         label(h[2], 0.75, c_pb_head[h[3]], "center");
   translate([pb.x / 2, -4.2]) label("Mega side", 0.9, "#666666", "center");
   translate([pb.x / 2, pb.y + 4.2]) label("back wall", 0.9, "#666666", "center");
   // Legend
   legend = [[0, "pin, female-female jumper from that RJ45 pin (P4.7: port 4, pin 7)"],
             [1, "pin, male-female jumper to that Mega pin"],
             [2, "330 Ohm in series, standing, body on the dot"],
             [3, "4.7 kOhm pull-up to the 5 V rail, standing, body on the dot"],
             [4, "joined on the back: solder bridge or tinned wire"]];
   for (i = [0 : len(legend) - 1]) translate([2, -7.5 - i * 2.2]) {
      k = legend[i][0];
      if (k < 2) {
         color(c_pb_pin[k]) layer(5) square(1.2, center = true);
         color("#e6c34a") layer(6) square(0.45, center = true);
      } else if (k < 4) color(k == 2 ? c_330 : c_4k7) layer(5) circle(d = 1.35, $fn = 24);
      else color("#7f8c8d") layer(3) square([2, 0.5], center = true);
      translate([2, 0]) label(legend[i][1], 0.9);
   }
}

module box_part() { color(c_print) box(); }
module lid_part() { color(c_lid) lid(); }

module inside_parts() {
   for (c = [0 : port_cols - 1])
      at_port(c) translate([0, 0, port_z]) rj_part();
   translate([mega_x, row_y, mega_z]) mega_part();
   translate([pb_x, pb_y, pb_z]) pb_part();
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
//board_view(); // Make view board 0,0,0
