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
// - The shield: a 90 x 70 mm perfboard plugged onto the Mega's analog
//   headers and its double header (they share a 2.54 mm grid, the digital
//   header does not) and screwed onto four posts at its corner holes. Every
//   RJ45 pin goes to it, each port as one 8 wire ribbon of female-female
//   jumpers onto a header in RJ45 order; it joins the shared lines (5 V and
//   GND of all ports, S0-S3 of the mux ports), carries every resistor of
//   the hub (330 Ohm in series with S0-S3 and the two servo signals,
//   4.7 kOhm pull-ups to 5 V on the mux SIG lines and on the direct-port
//   switch and encoder lines) and is wired on its back, on the bench
//   (`shield` view). The servos' power has the double header's second
//   5 V and GND pins.
// - Nothing in the box is soldered and no wire goes to the Mega: the
//   shield comes off with 4 screws, and the Mega can be reused.
// - Behind the front ports is a strip for their jumper plugs, then the
//   Mega (its USB and power jacks through the left wall) with the shield
//   on it, left of the right ports' jumper strip.
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
// - shield: 90 x 70 mm perfboard (31 x 26 holes), a 2 x 18 and eight 1 x 8
//   male pin headers, 6 x 330 Ohm, 8 x 4.7 kOhm, wire-wrap and tinned wire
// - 24 + 6 M3 x 6 self tapping screws (RJ45 boards, Mega), 4 x M3 x 8
//   self tapping (shield), 4 x M3 x 10 (lid)
// - 48 female-female jumper wires, 15 cm, as 8 wire ribbons
//
// Assembly: build the shield on the bench, screw the RJ45 boards and the
// Mega on, plug the shield onto the Mega and screw it onto its posts, plug
// each port's ribbon onto its header, screw the lid on.

$fn = 48;

// --- Printer ---
bed = [255, 255];            // Kobra 3 V2

// --- Box ---
wall = 2.5;
floor_t = 2.5;
inner_h = 48;                // floor top to the lid: the jumpers on the shield
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

// --- RJ45 breakout board (measured) ---
port_front = 3;              // ports 1-3 on the front wall (the mux ports)
port_side = 3;               // ports 4-6 on the right wall (the direct ports)
port_cols = port_front + port_side;
rj = [34, 28];               // PCB, along the wall x depth; the jack is on the 34 edge
rj_pcb_t = 1.4;              // (measured)
rj_jack = [16, 16, 15];      // width x depth x height (width, height measured)
rj_jack_x = (rj.x - rj_jack.x) / 2;  // centred on the board (measured)
rj_jack_inset = 0;           // PCB front edge to the jack face: flush (measured)
rj_hole_pitch = [28, 11];    // 4 corner holes, centre to centre (measured)
rj_hole_y = 5;               // PCB front edge to the front holes' centres (measured, 4.5-5)
// Centred along the board, from the PCB front left corner
rj_holes = [for (i = [0, 1], j = [0, 1])
   [(rj.x - rj_hole_pitch.x) / 2 + i * rj_hole_pitch.x, rj_hole_y + j * rj_hole_pitch.y]];
rj_screw_hole = 2.8;         // M3 self tapping, in the floor boss
rj_screw_depth = 5.5;        // into the boss and the floor, for an M3 x 6
rj_standoff = [6, 4];        // floor boss, diameter x height
rj_solder = 1.5;             // solder joints under a PCB
rj_pins = 9;                 // pins 1-8 and SH (shield), one row, 2.54 mm
rj_pin_x = 7 + 1.27;         // PCB left edge to the header, to pin 1's centre (measured)
rj_pin_y = rj.y - 2 - 1;     // header 2 mm wide, 2 mm before the back edge (measured)
rj_pin_reach = rj.y + 4 - rj_pin_y;  // angled pins, 4 mm past the back edge (measured)
port_gap = 4;                // between the boards
port_margin = 2;             // between a corner post and the first board
jack_clear = 0.4;            // around the jack in the wall cut-out
label_size = 5;              // port numbers beside the jacks
label_depth = 0.6;
font = "Liberation Sans:style=Bold";

// --- Jumper wires and spacing ---
dupont = 20;                 // a plugged jumper: housing (14) + bent wire, past its pin
cable_gap = rj_pin_y + dupont - rj.y;  // strip behind the RJ45 boards, for the jumper plugs

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

// --- Mega headers the shield plugs into (Arduino drawing) ---
// The analog headers and the double header are on one 2.54 mm grid; the
// digital header on the back edge is not (the 1.5 mm offset between D7
// and D8), the shield leaves it alone.
mega_analog = [[50.8, 2.54], [73.66, 2.54]];  // A0 and A8, the first pin of each 8 pin header
mega_double = [96.52, 5.08]; // double header: the even column (inside), the GND row
mega_double_rows = 18;       // GND, 52/53 ... 22/23, 5V from the front

// --- Shield (measured: a 90 x 70 mm perfboard, 2.54 mm grid) ---
// Plugged onto the Mega's analog headers and double header, screwed onto
// four posts at its corner holes. Every RJ45 pin is plugged onto it, it
// carries every resistor, and it is wired on its back.
sh = [90, 70];               // along the Mega x across it
sh_t = 1.6;
pitch = 2.54;
sh_grid = [31, 26];          // holes along x, along y (measured); row 0 at the front
sh_hole_edge = 3;            // corner holes' centres from both edges (measured, 3 mm holes)
sh_holes = [for (x = [sh_hole_edge, sh.x - sh_hole_edge], y = [sh_hole_edge, sh.y - sh_hole_edge]) [x, y]];
sh_post_d = 6;               // floor posts under the corner holes
sh_screw_hole = 2.8;         // M3 self tapping, through the board's 3 mm holes
sh_screw_depth = 7;          // an M3 x 8 through the board into the post
sh_screw_head = 5.6;         // its pan head, clear of the pins
sh_header_h = 8.5;           // a male pin header above the board
sh_res_h = 11;               // a resistor standing upright
sh_stack = 2.5;              // header plastic under the shield, on the Mega's sockets
sh_solder = 1.5;             // solder joints and wires under the shield
// Where it sits on the Mega: these shield holes take the double header's
// even column and the analog headers
sh_dbl_col = 29;
sh_ana_row = 3;

// --- Shield layout ---
// Holes by [column, row]: columns from the left (the USB end), row 0 at the
// front. Every RJ45 pin has a male pin on the shield, in a header of 8 in
// RJ45 order, so each port is one 8 wire ribbon of female-female jumpers.
// Port headers, [col of pin 1, row]: the mux ports side by side at the
// front edge (their ribbons come from the front wall), the direct ports
// on the right, one behind the other in wall order (theirs come from the
// right wall).
sh_ports = [[1, 1], [10, 1], [19, 1], [20, 6], [20, 10], [20, 14]];
function sh_pin(port, p) = sh_ports[port - 1] + [p - 1, 0];
// Resistors stand in two banks behind the direct ports, next to the Mega
// pins they go to: the body on [col, row], the lead one row behind
sh_pull_cols = [13, 15, 17, 19, 21, 23, 25, 27];  // 4.7 kOhm, the leads on the 5 V rail
sh_pull_row = 16;
sh_series_cols = [17, 19, 21, 23, 25, 27];   // 330 Ohm: S0-S3, servo P4, servo P5
sh_series_row = 19;
// What goes through them: [[port, RJ45 pin], Mega pin, name]
sh_s_pins = [1, 2, 3, 6];                // S0-S3 on the mux ports
sh_series = [for (i = [0 : 3]) [[3, sh_s_pins[i]], ["D", 22 + i], str("S", i)]];
sh_servos = [[[4, 7], ["D", 32], "P4 C"], [[5, 7], ["D", 35], "P5 C"]];
sh_pulls = [[[1, 7], ["D", 26], "SIG1"], [[2, 7], ["D", 27], "SIG2"], [[3, 7], ["D", 28], "SIG3"],
            [[4, 3], ["D", 30], "P4 A"], [[4, 6], ["D", 31], "P4 B"], [[4, 8], ["D", 33], "P4 D"],
            [[5, 6], ["D", 34], "P5 B"], [[5, 8], ["D", 36], "P5 D"]];
// Straight to an analog pin: [[port, RJ45 pin], An]: AUX, the pots, port 6's free lines
sh_analog = [[[1, 8], 1], [[2, 8], 2], [[3, 8], 3], [[5, 3], 4],
             [[6, 3], 5], [[6, 6], 6], [[6, 7], 7], [[6, 8], 8], [[6, 1], 9], [[6, 2], 10]];
// Mega pins: ["D", n], ["A", n], ["5V", 0 logic / 1 servo], ["GND", 0 / 1]
function mega_pin_pt(m) =
   m[0] == "A" ? mega_analog[m[1] < 8 ? 0 : 1] + [(m[1] % 8) * pitch, 0]
   : m[0] == "D" ? mega_double + [(m[1] % 2) * pitch, (mega_double_rows - 2 - floor((m[1] - 22) / 2)) * pitch]
   : mega_double + [m[1] * pitch, m[0] == "5V" ? (mega_double_rows - 1) * pitch : 0];
// A hole on the shield, from its front left corner, the grid centered
function sh_hole(c, r) = [(sh.x - (sh_grid.x - 1) * pitch) / 2 + c * pitch,
                          (sh.y - (sh_grid.y - 1) * pitch) / 2 + r * pitch];
// The shield's front left corner on the Mega
sh_o = [mega_double.x - sh_hole(sh_dbl_col, 0).x, mega_analog[0].y - sh_hole(0, sh_ana_row).y];
function sh_cr(pt) = (pt - sh_o - sh_hole(0, 0)) / pitch;
function mega_hole(m) = let (cr = sh_cr(mega_pin_pt(m))) [round(cr.x), round(cr.y)];
// Every Mega header pin under the shield (all soldered in, for strength)
sh_mega_pins = concat([for (n = [0 : 15]) ["A", n]], [for (n = [22 : 53]) ["D", n]],
                      [["5V", 0], ["5V", 1], ["GND", 0], ["GND", 1]]);
sh_stacked = [for (m = sh_mega_pins) mega_hole(m)];
function series_top(i) = [sh_series_cols[i], sh_series_row];
function series_bot(i) = [sh_series_cols[i], sh_series_row + 1];
function pull_top(i) = [sh_pull_cols[i], sh_pull_row];
sh_rail = [[sh_pull_cols[0], sh_pull_row + 1], [sh_pull_cols[len(sh_pull_cols) - 1], sh_pull_row + 1]];
// Resistors: [body hole, lead hole, value, name]
sh_res = concat(
   [for (i = [0 : 5]) [series_top(i), series_bot(i), "330", concat(sh_series, sh_servos)[i][2]]],
   [for (i = [0 : 7]) [pull_top(i), pull_top(i) + [0, 1], "4k7", sh_pulls[i][2]]]);
// Bare tinned wire on the back: [hole, hole]
sh_bridges = [[sh_pin(4, 4), sh_pin(6, 4)], [sh_pin(4, 5), sh_pin(6, 5)],  // 5 V, GND through ports 4-6
              [sh_pin(4, 1), sh_pin(5, 1)], [sh_pin(4, 2), sh_pin(5, 2)],  // servo power of ports 4, 5
              sh_rail];                                                    // 5 V rail of the pull-ups
// Insulated wire (wire-wrap) on the back: [hole, hole, kind]: 0 signal,
// 1 5 V, 2 GND, 3 servo power
function P(port, p) = sh_pin(port, p);
sh_wires = concat(
   // S0-S3 from pin to pin over the mux ports, through a 330 to the Mega
   [for (i = [0 : 3], k = [1 : 2]) [P(k, sh_s_pins[i]), P(k + 1, sh_s_pins[i]), 0]],
   [for (i = [0 : 3]) [P(3, sh_s_pins[i]), series_top(i), 0]],
   [for (i = [0 : 3]) [series_bot(i), mega_hole(sh_series[i][1]), 0]],
   // Servo signals through a 330
   [for (i = [0 : 1]) [P(sh_servos[i][0][0], sh_servos[i][0][1]), series_top(4 + i), 0]],
   [for (i = [0 : 1]) [series_bot(4 + i), mega_hole(sh_servos[i][1]), 0]],
   // Pulled-up lines: the pin to the resistor, the resistor to the Mega
   [for (i = [0 : 7]) [P(sh_pulls[i][0][0], sh_pulls[i][0][1]), pull_top(i), 0]],
   [for (i = [0 : 7]) [pull_top(i), mega_hole(sh_pulls[i][1]), 0]],
   [for (a = sh_analog) [P(a[0][0], a[0][1]), mega_hole(["A", a[1]]), 0]],
   // 5 V and GND over the mux ports to the direct ports' bridges, then to the Mega
   [for (k = [1 : 3]) [P(k, 4), P(k + 1, 4), 1]],
   [[P(6, 4), mega_hole(["5V", 0]), 1], [sh_rail[1], mega_hole(["5V", 0]), 1]],
   [for (k = [1 : 3]) [P(k, 5), P(k + 1, 5), 2]],
   [[P(6, 5), mega_hole(["GND", 0]), 2]],
   // Servo power on the double header's other 5 V and GND
   [[P(5, 1), mega_hole(["5V", 1]), 3], [P(5, 2), mega_hole(["GND", 1]), 3]]);
sh_port_pins = [for (port = [1 : 6], p = [1 : 8]) sh_pin(port, p)];
sh_res_holes = [for (r = sh_res) each [r[0], r[1]]];

// --- Derived ---
port_x0 = post + port_margin;
port_x = function(i) port_x0 + i * (rj.x + port_gap);  // along its wall
port_z = rj_standoff[1];       // PCB bottom
jack_z = port_z + rj_pcb_t;    // jack bottom
// The Mega behind the ports, on the left, far enough back that the
// shield's front posts stand behind the front ports' jumpers
sh_post_y = sh_o.y + sh_hole_edge;   // front posts from the Mega's front edge
row_y = max(rj.y + cable_gap, rj_pin_y + dupont + sh_post_d / 2 + 0.5 - sh_post_y);
mega_x = mega_usb[3] - wall;  // the USB jack ends flush with the outside
mega_z = mega_standoff[1];
// The right ports: their jumpers end side_reach from the wall, clear of the
// front ports and the Mega
side_reach = rj_pin_y + dupont;
inner_x = max(port_x(port_front - 1) + rj.x, mega_x + mega.x) + side_reach + 2;
inner_y = max(row_y + mega.y + post + 1, row_y + sh_o.y + sh.y + lip_w + lip_clear,
              port_x(port_side - 1) + rj.x + port_x0);
// Port c in its wall's frame: x along the wall (left to right from outside),
// y into the box from the inside of the wall, z up from the floor top
module at_port(c) {
   if (c < port_front) translate([port_x(c), 0, 0]) children();
   else translate([inner_x, port_x(c - port_front), 0]) rotate([0, 0, 90]) children();
}
// The shield on the Mega's headers
sh_x = mega_x + sh_o.x;
sh_y = row_y + sh_o.y;
sh_z = mega_z + mega_pcb_t + mega_header_h + sh_stack;
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
assert(sh_z + sh_t + sh_header_h + dupont <= inner_h,
       "No room for the jumpers above the shield");
assert(sh_z + sh_t + sh_res_h <= inner_h - 5, "Resistors on the shield reach the lid");
assert(mega_z + mega_pcb_t + mega_header_h + sh_solder <= sh_z,
       "The shield's solder joints touch the Mega's digital header");
assert(sh_grid.x * pitch <= sh.x && sh_grid.y * pitch <= sh.y, "Hole grid does not fit the shield");
assert(sh_x >= 0 && sh_x + sh.x <= inner_x && sh_y + sh.y <= inner_y - lip_clear - lip_w,
       "Shield runs into the walls");
// Every Mega header pin it takes lands on a hole of the grid
for (m = sh_mega_pins) {
   cr = sh_cr(mega_pin_pt(m));
   assert(norm(cr - [round(cr.x), round(cr.y)]) < 0.05, str("Mega pin ", m, " off the shield's grid"));
   assert(cr.x >= 0 && cr.x < sh_grid.x && cr.y >= 0 && cr.y < sh_grid.y, str("Mega pin ", m, " off the shield"));
}
// The posts stand beside the Mega, not on it, and behind the front ports' jumpers
for (h = sh_holes) {
   y = sh_o.y + h.y;
   assert(y + sh_post_d / 2 + 0.5 <= 0 || y - sh_post_d / 2 - 0.5 >= mega.y,
          "Shield post stands on the Mega");
   assert(row_y + y - sh_post_d / 2 >= rj_pin_y + dupont, "Shield post in the front ports' jumpers");
}
// Every hole has one use, the screw heads stay clear of the pins
sh_used = concat(sh_port_pins, sh_stacked, sh_res_holes);
for (i = [0 : len(sh_used) - 1], j = [0 : len(sh_used) - 1])
   assert(i == j || sh_used[i] != sh_used[j], str("Shield hole ", sh_used[i], " used twice"));
for (u = sh_used, h = sh_holes)
   assert(norm(sh_hole(u.x, u.y) - h) >= sh_screw_head / 2 + 1.3, str("Shield hole ", u, " under a screw head"));
for (u = concat(sh_used, [for (b = sh_bridges) each b]))
   assert(u.x >= 0 && u.x < sh_grid.x && u.y >= 0 && u.y < sh_grid.y, "Shield layout runs off the grid");

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
   // Shield posts, under its corner holes
   for (h = sh_holes)
      translate([sh_x + h.x, sh_y + h.y, 0])
         difference() {
            cylinder(d = sh_post_d, h = sh_z);
            translate([0, 0, sh_z - sh_screw_depth]) cylinder(d = sh_screw_hole, h = sh_screw_depth + 1);
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
         // Headers: power and analog at the front, digital at the back, the double row at the end
         translate([27.94 - 1.27, 2.54 - 1.27, 0]) cube([8 * 2.54, 2.54, mega_header_h]);
         for (a = mega_analog) translate(a - [1.27, 1.27]) cube([8 * 2.54, 2.54, mega_header_h]);
         translate(mega_double - [1.27, 1.27]) cube([5.08, mega_double_rows * 2.54, mega_header_h]);
         translate([18, mega.y - 3.2, 0]) cube([72, 2.54, mega_header_h]);
         translate([36, 20, 0]) rotate([0, 0, 45]) cube([14, 14, 1.2]);
      }
   }
}

// The shield, built: port headers on top, the Mega's header pins under it
// (their plastic on the Mega's sockets), standing resistors
c_perf = "#d9c79a";
c_330 = "#e08a2c";
c_4k7 = "#2e86c1";
c_wire = ["#1e8449", "#c0392b", "#222222", "#8e44ad"];  // signal, 5 V, GND, servo power
module shield_part() {
   color(c_perf)
      difference() {
         cube([sh.x, sh.y, sh_t]);
         for (h = sh_holes) translate([h.x, h.y, -1]) cylinder(d = 3, h = sh_t + 2);
      }
   for (u = sh_port_pins) translate(sh_hole(u.x, u.y)) translate([0, 0, sh_t]) {
      color(c_black) translate([-1.27, -1.27, 0]) cube([2.54, 2.54, 2.5]);
      color(c_pin) translate([-0.32, -0.32, 0]) cube([0.64, 0.64, sh_header_h]);
   }
   for (u = sh_stacked) translate(sh_hole(u.x, u.y)) {
      color(c_black) translate([-1.27, -1.27, -sh_stack]) cube([2.54, 2.54, sh_stack]);
      color(c_pin) translate([-0.32, -0.32, -sh_stack - 6]) cube([0.64, 0.64, 6 + sh_t + 1]);
   }
   for (r = sh_res) translate([0, 0, sh_t]) {
      color(r[2] == "330" ? c_330 : c_4k7)
         translate(sh_hole(r[0].x, r[0].y)) cylinder(d = 2.3, h = sh_res_h - 1.5, $fn = 12);
      color(c_steel) hull() {
         translate(concat(sh_hole(r[0].x, r[0].y), sh_res_h - 1)) sphere(d = 0.6, $fn = 6);
         translate(concat(sh_hole(r[1].x, r[1].y), sh_res_h - 1)) sphere(d = 0.6, $fn = 6);
      }
      color(c_steel) translate(sh_hole(r[1].x, r[1].y)) cylinder(d = 0.6, h = sh_res_h - 1, $fn = 6);
   }
}

// The shield drawing: the component side, the wiring of its back drawn
// through it (straight lines, run them as you like), row 0 at the bottom
module shield_view() {
   lt = 0.05;  // layers, stacked so the preview shows the upper one
   module layer(n) translate([0, 0, n * lt]) linear_extrude(lt) children();
   module label(t, size = 0.6, c = "#222222", ha = "left", va = "center", patch = false) {
      color(c) layer(9) text(t, size = size, font = font, halign = ha, valign = va);
      if (patch) color(c_perf) layer(7) offset(delta = 0.15) hull()
         text(t, size = size, font = font, halign = ha, valign = va);
   }
   function at(u) = sh_hole(u.x, u.y);
   color(c_perf) layer(0) difference() {
      offset(r = 0.6) offset(delta = -0.6) square(sh);
      for (h = sh_holes) translate(h) circle(d = 3, $fn = 24);
   }
   color("#b08a3e") layer(1)
      for (c = [0 : sh_grid.x - 1], r = [0 : sh_grid.y - 1]) translate(sh_hole(c, r)) circle(d = 0.75, $fn = 12);
   color("#3a2f1a") layer(2)
      for (c = [0 : sh_grid.x - 1], r = [0 : sh_grid.y - 1]) translate(sh_hole(c, r)) circle(d = 0.3, $fn = 8);
   // The back: bridges, then the wires
   color("#7f8c8d") layer(3)
      for (b = sh_bridges) hull() for (u = b) translate(at(u)) circle(d = 0.7, $fn = 12);
   for (w = sh_wires) color(c_wire[w[2]]) layer(4)
      hull() for (u = [w[0], w[1]]) translate(at(u)) circle(d = 0.22, $fn = 8);
   // The Mega's header pins under the shield: used ones red, the rest grey
   used = [for (w = sh_wires) each [w[0], w[1]]];
   for (u = sh_stacked) translate(at(u)) {
      color(len([for (w = used) if (w == u) 1]) ? "#c0392b" : "#a0a0a0")
         layer(5) difference() { square(1.5, center = true); square(0.9, center = true); }
   }
   // Resistors, standing: the body on the dot
   for (r = sh_res) {
      color("#555555") layer(5) hull() for (u = [r[0], r[1]]) translate(at(u)) circle(d = 0.15, $fn = 6);
      color(r[2] == "330" ? c_330 : c_4k7) layer(6) translate(at(r[0])) circle(d = 1.35, $fn = 24);
      color("#555555") layer(6) translate(at(r[1])) circle(d = 0.45, $fn = 12);
      translate(at(r[1]) + [0, -1.0]) label(r[3], 0.5, r[2] == "330" ? c_330 : c_4k7, "center", "top", true);
   }
   // Port headers, their pin numbers below them, the port in front
   for (port = [1 : 6]) {
      for (p = [1 : 8]) translate(at(sh_pin(port, p))) {
         color(c_black) layer(6) square(1.2, center = true);
         color("#e6c34a") layer(7) square(0.45, center = true);
         translate([0, -0.95]) label(str(p), 0.5, "#444444", "center", "top", true);
      }
      translate(at(sh_pin(port, 1)) + [-1.1, 0])
         label(str("P", port), 0.85, port <= 3 ? "#c0392b" : "#2471a3", "right", patch = true);
   }
   // Mega pin names: analog behind their row, the double header on its sides
   for (n = [0 : 15]) translate(at(mega_hole(["A", n])) + [0, 0.95])
      label(str("A", n), 0.45, "#666666", "center", "bottom", true);
   for (n = [22 : 37]) translate(at(mega_hole(["D", n])) + [n % 2 ? 1.0 : -1.0, 0])
      label(str("D", n), 0.5, "#666666", n % 2 ? "left" : "right", patch = true);
   for (k = [0, 1]) {
      translate(at(mega_hole(["5V", k])) + [k ? 1.0 : -1.0, 0])
         label(k ? "5V servo" : "5V", 0.5, c_wire[1], k ? "left" : "right", patch = true);
      translate(at(mega_hole(["GND", k])) + [k ? 1.0 : -1.0, 0])
         label(k ? "GND servo" : "GND", 0.5, c_wire[2], k ? "left" : "right", patch = true);
   }
   translate([sh.x / 2, -2.2]) label("front wall side: ribbons from ports 1-3", 0.9, "#666666", "center");
   translate([sh.x + 1, sh.y + 1.6]) label("right wall side: ribbons from ports 4-6 ->", 0.9, "#666666", "right");
   // Legend
   legend = [[0, "pin, ribbon from that port, RJ45 pin numbers below"],
             [1, "Mega header pin under the shield (red: wired)"],
             [2, "330 Ohm in series, standing, body on the dot"],
             [3, "4.7 kOhm pull-up, standing, the lead on the 5 V rail"],
             [4, "bare tinned wire on the back"],
             [5, "wire-wrap wire on the back: signal, 5 V, GND, servo power"]];
   for (i = [0 : len(legend) - 1]) translate([2, -5.5 - i * 2.2]) {
      k = legend[i][0];
      if (k == 0) { color(c_black) layer(6) square(1.2, center = true); color("#e6c34a") layer(7) square(0.45, center = true); }
      else if (k == 1) color("#c0392b") layer(5) difference() { square(1.5, center = true); square(0.9, center = true); }
      else if (k < 4) color(k == 2 ? c_330 : c_4k7) layer(6) circle(d = 1.35, $fn = 24);
      else if (k == 4) color("#7f8c8d") layer(3) square([2, 0.7], center = true);
      else for (j = [0 : 3]) color(c_wire[j]) layer(4) translate([-1, -0.45 + j * 0.3]) square([2, 0.22]);
      translate([2, 0]) label(legend[i][1], 0.9);
   }
}

module box_part() { color(c_print) box(); }
module lid_part() { color(c_lid) lid(); }

module inside_parts() {
   for (c = [0 : port_cols - 1])
      at_port(c) translate([0, 0, port_z]) rj_part();
   translate([mega_x, row_y, mega_z]) mega_part();
   translate([sh_x, sh_y, sh_z]) shield_part();
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
//shield_view(); // Make view shield 0,0,0
