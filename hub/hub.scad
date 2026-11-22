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
//   jumpers onto a header in RJ45 order (some peeled off to loose pins
//   beside what they go to, all of ports 4 and 5); it joins the shared lines (5 V and
//   GND of all ports, S0-S3 of the mux ports) and carries every resistor
//   of the hub (330 Ohm in series with S0-S3 and the two servo signals, a
//   4.7 kOhm x 8 bussed network for the pull-ups to 5 V on the mux SIG
//   lines and on the direct-port switch and encoder lines). It is
//   double sided with plated through holes and wired on the bench
//   (`shield` view): each line to the Mega has a row, its resistor or
//   network pin in the hole beside the Mega pin and a solder bridge on top
//   onto it; neighbouring pins that belong together are bridged on the
//   back, and the pins are placed so that this is every connection (no
//   wires): those that are a line of their own, or power, loose. The
//   servos' power has the double header's second 5 V and GND pins.
// - Nothing in the box is soldered and no wire goes to the Mega: the
//   shield comes off with 4 screws, and the Mega can be reused.
// - Behind the front ports is a strip for their jumper plugs, then the
//   Mega (its USB and power jacks through the left wall) with the shield
//   on it, left of the right ports' jumper strip.
// - A lid with a locating lip is screwed onto four corner posts. Four ears
//   on the floor bolt the box into two crossbars of the frame.
//
// Coordinates: x along the front wall (port 1 on the left), y away from it,
// z up; the inside of the front wall is at y=0, the floor top at z=0.
// The box is printed floor down, the lid top down.
//
// Parts to buy (details in the README):
// - Arduino Mega 2560
// - 6 RJ45 breakout boards (34 x 28 mm, 9 pin angled header: 1-8 and SH)
// - shield: 90 x 70 mm perfboard (31 x 26 holes, double sided, plated
//   through), a 2 x 18 and ten 1 x 8
//   male pin headers, 6 x 330 Ohm, a 4.7 kOhm x 8 bussed network (SIP 9),
//   tinned wire for the bridges
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
// Mount ears on the floor, M5 into T-nuts in the frame's crossbars right
// of the yoke (frame/frame.inc.scad places the hub and checks them):
// two on the left wall into the step upright's crossbar, one on the front
// and one on the back wall into the hub crossbar right of it
ear = [14, 12];              // along the wall x out
ear_t = 4;
ear_hole = 5.3;              // M5
ear_slot_dx = 156.5;         // frame: the step crossbar's slot to the hub crossbar's slot
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
// The 2 x 3 ICSP header in the middle of the Mega, under the shield: nothing
// on the shield may stick out above it (measured: the middle between its
// two rows 33 mm from the double header's outer edge, its middle pin
// 27 mm from the analog headers' outer edge)
mega_icsp = [mega_double.x + 2.54 * 1.5 - 33, mega_analog[0].y - 2.54 / 2 + 27];
mega_icsp_size = [2 * 2.54, 3 * 2.54];  // its plastic, along x and y
mega_icsp_h = mega_header_h;  // as high as the other headers
icsp_clear = 1;              // around it, kept free on the shield

// --- Shield (measured: a 90 x 70 mm perfboard, 2.54 mm grid) ---
// Plugged onto the Mega's analog headers and double header, screwed onto
// four posts at its corner holes. Every RJ45 pin is plugged onto it, it
// carries every resistor. Double sided, plated through holes.
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
sh_sip_h = 6.5;              // the pull-up network (SIP 9), standing
sh_stack = 2.5;              // header plastic under the shield, on the Mega's sockets
sh_solder = 1.5;             // solder joints and wires under the shield
// Where it sits on the Mega: these shield holes take the double header's
// even column and the analog headers
sh_dbl_col = 29;
sh_ana_row = 3;

// --- Shield layout ---
// Holes by [column, row]: columns from the left (the USB end), row 0 at the
// front. The board is double sided with plated through holes, so a hole
// joins its pads on both sides. Every line that goes to the double header
// has its own row: its resistor (or its pin of the pull-up network) stands
// in the two holes before the Mega pin, and a solder bridge on top joins
// the hole next to the pin onto it (the Mega pins' pads on the back are
// under their header's plastic, so they are only soldered on top). An
// analog line goes from its port pin over the hole behind the analog pin,
// bridged on the back and on top. Everything else is a solder bridge
// between two neighbouring pins that belong together (the mux bus across
// the mux ports, the 5 V and GND rows, ...) or a wire-wrap wire on the
// back, from pin to pin (none so far: the loose pins are placed so).
// Port headers: [pin 1, step to the next pin]. The mux ports stand side by
// side over the analog header (pin 8, AUX, at the front), so the pins they
// share are neighbours, and port 3's S0-S3 pins are next to their
// resistors; port 6 lies along the analog header; ports 4 and 5 stand side
// by side behind them, their shared pins neighbours.
sh_ports = [[[23, 12], [0, -1]], [[24, 12], [0, -1]], [[25, 12], [0, -1]],
            [[24, 20], [0, -1]], [[25, 20], [0, -1]], [[11, 5], [1, 0]]];
// Except the loose pins: a line of its own (or the servo power), each pulled
// out of its port's header and set beside what it goes to, its jumper
// peeled off the port's ribbon: the pins with a pull-up in one strip next
// to the pull-up network, each beside its network pin, the servo signals
// beside their 330 Ohm, port 5's pot two holes behind a free analog pin,
// the servo power beside the double header's outer 5 V and GND pins, and
// the 5 V and GND pins of all ports in a row of neighbours each, onto the
// Mega's 5 V and GND (ports 4 and 5 have no header left): [[port, pin], hole]
sh_loose_pins = [[[1, 7], [26, 20]], [[2, 7], [26, 19]], [[4, 3], [26, 18]], [[3, 7], [26, 17]],
                 [[5, 8], [26, 16]], [[4, 6], [26, 15]], [[5, 6], [26, 14]], [[4, 8], [26, 13]],
                 [[4, 7], [26, 9]], [[5, 7], [26, 8]], [[5, 3], [22, 5]],
                 [[4, 1], [30, 23]], [[5, 1], [30, 24]], [[4, 2], [30, 2]], [[5, 2], [30, 1]],
                 [[6, 4], [23, 22]], [[1, 4], [24, 22]], [[2, 4], [25, 22]], [[3, 4], [26, 22]],
                 [[4, 4], [27, 22]], [[5, 4], [28, 22]],
                 [[6, 5], [25, 1]], [[1, 5], [26, 1]], [[2, 5], [27, 1]], [[3, 5], [28, 1]],
                 [[5, 5], [28, 2]], [[4, 5], [28, 3]]];
function loose(port, p) = len([for (x = sh_loose_pins) if (x[0] == [port, p]) 1]) > 0;
function sh_pin(port, p) =
   let (m = [for (x = sh_loose_pins) if (x[0] == [port, p]) x[1]])
   len(m) ? m[0] : sh_ports[port - 1][0] + (p - 1) * sh_ports[port - 1][1];
function P(port, p) = sh_pin(port, p);
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
// Lines: [name, port pins [port, pin], resistor ("330" in series, "4k7"
// pull-up to 5 V, "" none), Mega pin]. MobiFlight takes any of the D pins
// for a button, encoder or servo; the outer column of the double header
// (odd pins) has no free hole beside it, so only the even ones are used.
sh_lines = [
   ["S0", [[1, 1], [2, 1], [3, 1]], "330", ["D", 38]],
   ["S1", [[1, 2], [2, 2], [3, 2]], "330", ["D", 40]],
   ["S2", [[1, 3], [2, 3], [3, 3]], "330", ["D", 42]],
   ["S3", [[1, 6], [2, 6], [3, 6]], "330", ["D", 48]],
   ["SIG1", [[1, 7]], "4k7", ["D", 22]],
   ["SIG2", [[2, 7]], "4k7", ["D", 24]],
   ["SIG3", [[3, 7]], "4k7", ["D", 28]],
   ["AUX1", [[1, 8]], "", ["A", 11]],
   ["AUX2", [[2, 8]], "", ["A", 12]],
   ["AUX3", [[3, 8]], "", ["A", 13]],
   ["P4 A", [[4, 3]], "4k7", ["D", 26]],
   ["P4 B", [[4, 6]], "4k7", ["D", 32]],
   ["P4 C", [[4, 7]], "330", ["D", 44]],
   ["P4 D", [[4, 8]], "4k7", ["D", 36]],
   ["P5 A", [[5, 3]], "", ["A", 10]],
   ["P5 B", [[5, 6]], "4k7", ["D", 34]],
   ["P5 C", [[5, 7]], "330", ["D", 46]],
   ["P5 D", [[5, 8]], "4k7", ["D", 30]],
   ["P6 E", [[6, 1]], "", ["A", 0]],
   ["P6 F", [[6, 2]], "", ["A", 1]],
   ["P6 A", [[6, 3]], "", ["A", 2]],
   ["P6 B", [[6, 6]], "", ["A", 5]],
   ["P6 C", [[6, 7]], "", ["A", 6]],
   ["P6 D", [[6, 8]], "", ["A", 7]],
   ["5V", [for (k = [1 : 6]) [k, 4]], "", ["5V", 0]],
   ["GND", [for (k = [1 : 6]) [k, 5]], "", ["GND", 0]],
   ["servo 5V", [[4, 1], [5, 1]], "", ["5V", 1]],
   ["servo GND", [[4, 2], [5, 2]], "", ["GND", 1]]];
// A 330 Ohm line is two nets: its name up to the resistor, "<name> Mega" after it
function mega_net(l) = l[2] == "330" ? str(l[0], " Mega") : l[0];
function line(name) = [for (l = sh_lines) if (l[0] == name) l][0];
function hole_before(m) = mega_hole(m) - [1, 0];    // the hole beside a double header pin
function hole_behind(m) = mega_hole(m) + [0, 1];    // the hole behind an analog pin
// 330 Ohm resistors, standing in their row: [body hole, line]; the lead
// goes into the hole beside the Mega pin. S0-S3 stand a hole further left
// (the lead over the hole between), next to port 3's pins.
sh_330 = [[[26, 12], "S0"], [[26, 11], "S1"], [[26, 10], "S2"], [[27, 9], "P4 C"],
          [[27, 8], "P5 C"], [[26, 7], "S3"]];
function r330(name) = [for (r = sh_330) if (r[1] == name) r[0]][0];
function r330_lead(name) = hole_before(line(name)[3]);
// The pull-ups: one 4.7 kOhm x 8 bussed resistor network (SIP 9, pin 1 the
// common) standing across the 8 pull-up rows, two holes before the Mega
// pins, pin 1 in the 5 V row above them: [pin 1, step to the next pin]
sh_sip = [[27, 21], [0, -1]];
sip_pins = 9;
function sip_pin(k) = sh_sip[0] + (k - 1) * sh_sip[1];
function sip_in_row(r) = [for (k = [1 : sip_pins]) if (sip_pin(k).y == r) sip_pin(k)][0];
// Links from pin to pin: [hole, hole, kind, net]: kind 0 signal, 1 5 V,
// 2 GND, 3 servo power. Between two neighbours a link is a bridge on the
// back, else a wire-wrap wire on the back.
sh_links = concat(
   // From each line's (last) port pin to its resistor or network pin
   [for (l = sh_lines) if (l[2] != "") let (p = l[1][len(l[1]) - 1])
      [P(p[0], p[1]), l[2] == "330" ? r330(l[0]) : sip_in_row(mega_hole(l[3]).y), 0, l[0]]],
   [// 5 V: port 6, the mux ports, ports 4 and 5, onto the Mega
    [P(6, 4), P(1, 4), 1, "5V"], [P(3, 4), P(4, 4), 1, "5V"], [P(5, 4), hole_before(["5V", 0]), 1, "5V"],
    // GND the same way
    [P(6, 5), P(1, 5), 2, "GND"], [P(3, 5), P(5, 5), 2, "GND"], [P(4, 5), hole_before(["GND", 0]), 2, "GND"],
    // Servo power
    [P(4, 1), mega_hole(["5V", 1]) + [0, 1], 3, "servo 5V"],
    [P(4, 2), mega_hole(["GND", 1]) - [0, 1], 3, "servo GND"]]);
function next_to(l) = norm(l[0] - l[1]) == 1;
sh_wires = [for (l = sh_links) if (!next_to(l)) l];

// Bridges between neighbouring holes, on the back (side 0) or on top
// (side 1): [a, b, side, net]
function B(a, b, net) = [a, b, 0, net];
function T(a, b, net) = [a, b, 1, net];
mux_nets = ["S0", "S1", "S2", "5V", "GND", "S3"];   // mux port pins 1-6
p45_nets = [[1, "servo 5V"], [2, "servo GND"], [4, "5V"], [5, "GND"]];
sh_runs = concat(
   // Digital lines: the hole beside the Mega pin onto it, a pull-up's
   // network pin onto that hole
   [for (l = sh_lines) if (l[3][0] == "D") T(hole_before(l[3]), mega_hole(l[3]), mega_net(l))],
   [for (l = sh_lines) if (l[2] == "4k7") B(sip_in_row(mega_hole(l[3]).y), hole_before(l[3]), l[0])],
   // Analog lines: the hole behind the analog pin onto it, the port pin
   // onto that hole when it is the next one
   [for (l = sh_lines) if (l[3][0] == "A") each
      concat([T(hole_behind(l[3]), mega_hole(l[3]), l[0])],
             P(l[1][0][0], l[1][0][1]) == mega_hole(l[3]) + [0, 2]
             ? [B(P(l[1][0][0], l[1][0][1]), hole_behind(l[3]), l[0])] : [])],
   // The mux bus: pins 1-6 across the three mux ports
   [for (p = [1 : 6], k = [1, 2]) B(P(k, p), P(k + 1, p), mux_nets[p - 1])],
   // Ports 4 and 5: their power pins
   [for (q = p45_nets) B(P(4, q[0]), P(5, q[0]), q[1])],
   // 5 V and GND onto the Mega pins, the network's common onto 5 V
   [B(sip_pin(1), hole_before(["5V", 0]), "5V"), T(hole_before(["5V", 0]), mega_hole(["5V", 0]), "5V"),
    T(hole_before(["GND", 0]), mega_hole(["GND", 0]), "GND")],
   // Servo power onto the double header's outer 5 V and GND
   [T(mega_hole(["5V", 1]) + [0, 1], mega_hole(["5V", 1]), "servo 5V"),
    T(mega_hole(["GND", 1]) - [0, 1], mega_hole(["GND", 1]), "servo GND")],
   // Links between neighbours
   [for (l = sh_links) if (next_to(l)) B(l[0], l[1], l[3])]);
sh_port_pins = [for (port = [1 : 6], p = [1 : 8]) sh_pin(port, p)];
sh_res_holes = [for (r = sh_330) each [r[0], r330_lead(r[1])]];
sh_sip_holes = [for (k = [1 : sip_pins]) sip_pin(k)];
function run_holes(r) = [r[0], r[1]];
function net_holes(n) = [for (r = sh_runs) if (r[3] == n) each run_holes(r),
                         for (w = sh_wires) if (w[3] == n) each [w[0], w[1]]];

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
// Ear holes [x, y] (box coordinates) and the wall they stand out of:
// [-1, 0] left, [0, -1] front, [0, 1] back
ear_left_x = -wall - ear.y / 2;              // the left ears' holes, over the step crossbar's slot
ears = [[[ear_left_x, -wall + round_r + ear.x / 2], [-1, 0]],
        [[ear_left_x, inner_y + wall - round_r - ear.x / 2], [-1, 0]],
        [[ear_left_x + ear_slot_dx, -wall - ear.y / 2], [0, -1]],
        [[ear_left_x + ear_slot_dx, inner_y + wall + ear.y / 2], [0, 1]]];

// --- Checks ---
assert(ears[2][0].x - ear.x / 2 >= port_x(port_front - 1) + rj_jack_x + rj_jack.x + jack_clear + 2
       && ears[2][0].x + ear.x / 2 <= inner_x + wall - round_r,
       "Front ear in front of a jack or off the front wall");
assert(outer.x + ear.y <= bed.x && outer.y + 2 * ear.y <= bed.y,
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
assert(sh_z + sh_t + max(sh_res_h, sh_sip_h) <= inner_h - 5, "Resistors on the shield reach the lid");
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
// Every component hole has one use, the screw heads stay clear of the pins
sh_used = concat(sh_port_pins, sh_stacked, sh_res_holes, sh_sip_holes);
sh_run_holes = [for (r = sh_runs) each run_holes(r)];
sh_wire_ends = [for (w = sh_wires) each [w[0], w[1]]];
// Nothing soldered above the ICSP header: no pin, resistor, Mega pin, run
// or wire end, and the shield's solder joints clear its top
for (u = concat(sh_used, sh_run_holes, sh_wire_ends)) {
   d = sh_o + sh_hole(u.x, u.y) - mega_icsp;   // from its middle, on the Mega
   assert(abs(d.x) > mega_icsp_size.x / 2 + icsp_clear || abs(d.y) > mega_icsp_size.y / 2 + icsp_clear,
          str("Shield hole ", u, " above the Mega's ICSP header"));
   assert(u.x >= 0 && u.x < sh_grid.x && u.y >= 0 && u.y < sh_grid.y, str("Shield hole ", u, " off the grid"));
   for (h = sh_holes)
      assert(norm(sh_hole(u.x, u.y) - h) >= sh_screw_head / 2 + 1.3, str("Shield hole ", u, " under a screw head"));
}
assert(mega_z + mega_pcb_t + mega_icsp_h + sh_solder <= sh_z,
       "The shield's solder joints touch the Mega's ICSP header");
for (i = [0 : len(sh_used) - 1], j = [0 : len(sh_used) - 1])
   assert(i == j || sh_used[i] != sh_used[j], str("Shield hole ", sh_used[i], " used twice"));
// Bridges only join two neighbours. On top a bridge goes onto a Mega pin
// from the hole beside it, which has no header plastic, resistor body or
// network on that side; on the back it joins two holes that are used
// (pins, resistor legs, wire ends, or the hole beside a Mega pin) and
// passes no Mega pin (their pads there are under the plastic). Wires are on
// the back, so they do not end on a Mega pin either.
sh_top_blocked = concat(sh_port_pins, [for (r = sh_330) r[0]], sh_sip_holes);
sh_beside = [for (r = sh_runs) if (r[2] == 1) each [r[0], r[1]]];
sh_wired = concat(sh_used, sh_wire_ends, sh_beside);
function in(h, list) = len([for (x = list) if (x == h) 1]) > 0;
for (r = sh_runs) {
   assert(norm(r[0] - r[1]) == 1, str("Bridge ", r, " does not join two neighbours"));
   if (r[2] == 1)
      assert(len([for (h = [r[0], r[1]]) if (in(h, sh_stacked)) 1]) == 1
             && !len([for (h = [r[0], r[1]]) if (in(h, sh_top_blocked)) 1]),
             str("Bridge on top ", r, " not possible"));
   else
      for (h = [r[0], r[1]]) {
         assert(!in(h, sh_stacked), str("Bridge on the back on Mega pin ", h));
         assert(in(h, sh_wired), str("Bridge on the back to an unused hole ", h));
      }
}
// A 330 Ohm's lead stays in its row, over free holes only
for (r = sh_330) {
   l = r330_lead(r[1]);
   assert(l.y == r[0].y && l.x > r[0].x, str("330 Ohm of ", r[1], " not before its Mega pin"));
   for (c = [r[0].x + 1 : 1 : l.x - 1])
      assert(!in([c, l.y], concat(sh_used, sh_wire_ends)), str("330 Ohm lead of ", r[1], " over a used hole"));
}
for (u = sh_wire_ends) assert(!len([for (m = sh_stacked) if (m == u) 1]), str("Wire ends on Mega pin ", u));
// Nets: no hole is on two of them, and each one is in one piece
sh_net_holes = concat([for (r = sh_runs, h = run_holes(r)) [h, r[3]]],
                      [for (w = sh_wires, h = [w[0], w[1]]) [h, w[3]]]);
for (a = sh_net_holes) {
   other = [for (b = sh_net_holes) if (b[0] == a[0] && b[1] != a[1]) b[1]];
   assert(!len(other), str("Shield hole ", a[0], " on ", a[1], " and ", other[0]));
}
sh_nets = [for (l = sh_lines) each (l[2] == "330" ? [l[0], mega_net(l)] : [l[0]])];
function touch(a, b) = len([for (x = a, y = b) if (x == y) 1]) > 0;
function grow(segs, have) =
   let (more = [for (i = [0 : len(segs) - 1])
                   if (!len([for (h = have) if (h == i) 1]) && len([for (h = have) if (touch(segs[h], segs[i])) 1])) i])
   len(more) ? grow(segs, concat(have, more)) : have;
function has(n, h) = len([for (x = net_holes(n)) if (x == h) 1]) > 0;
for (n = sh_nets) {
   segs = concat([for (r = sh_runs) if (r[3] == n) run_holes(r)], [for (w = sh_wires) if (w[3] == n) [w[0], w[1]]]);
   assert(len(segs) && len(grow(segs, [0])) == len(segs), str("Net ", n, " is not in one piece"));
}
for (n = concat([for (r = sh_runs) r[3]], [for (w = sh_wires) w[3]]))
   assert(len([for (x = sh_nets) if (x == n) 1]), str("Unknown net ", n));
// Every line reaches its port pins, its resistor and its Mega pin; each
// pull-up row has one pin of the network, its common is on 5 V
for (l = sh_lines) {
   for (p = l[1]) assert(has(l[0], P(p[0], p[1])), str(l[0], " does not reach P", p[0], ".", p[1]));
   assert(has(mega_net(l), mega_hole(l[3])), str(l[0], " does not reach its Mega pin"));
   if (l[2] == "330")
      assert(has(l[0], r330(l[0])) && has(mega_net(l), r330_lead(l[0])), str(l[0], " misses its 330 Ohm"));
   assert(len([for (k = [2 : sip_pins]) if (has(l[0], sip_pin(k))) 1]) == (l[2] == "4k7" ? 1 : 0),
          str(l[0], l[2] == "4k7" ? " misses its pull-up" : " has a pull-up"));
}
for (l = sh_lines) if (l[2] == "4k7")
   assert(len([for (k = [2 : sip_pins]) if (norm(P(l[1][0][0], l[1][0][1]) - sip_pin(k)) == 1) 1]) == 1,
          str(l[0], ": its pin is not beside its network pin"));
assert(len([for (l = sh_lines) if (l[2] == "4k7") 1]) == sip_pins - 1 && has("5V", sip_pin(1)),
       "The pull-up network does not fit its lines");

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
         for (e = ears)
            translate(concat(e[0] - e[1] * ear.y / 4, -floor_t))
               linear_extrude(ear_t)
                  square(e[1].x ? [ear.y * 1.5, ear.x] : [ear.x, ear.y * 1.5], center = true);
      }
      // Inside
      cube([inner_x, inner_y, inner_h + 1]);
      // Ear holes
      for (e = ears)
         translate(concat(e[0], -floor_t - 1)) cylinder(d = ear_hole, h = ear_t + 2);
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
         translate(mega_icsp - mega_icsp_size / 2) cube(concat(mega_icsp_size, mega_icsp_h));
         translate([36, 20, 0]) rotate([0, 0, 45]) cube([14, 14, 1.2]);
      }
   }
}

// The shield, built: port headers on top, the Mega's header pins under it
// (their plastic on the Mega's sockets), standing resistors and network
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
   for (r = sh_330) translate([0, 0, sh_t]) {
      b = sh_hole(r[0].x, r[0].y);
      l = sh_hole(r330_lead(r[1]).x, r330_lead(r[1]).y);
      color(c_330) translate(b) cylinder(d = 2.3, h = sh_res_h - 1.5, $fn = 12);
      color(c_steel) hull() {
         translate(concat(b, sh_res_h - 1)) sphere(d = 0.6, $fn = 6);
         translate(concat(l, sh_res_h - 1)) sphere(d = 0.6, $fn = 6);
      }
      color(c_steel) translate(l) cylinder(d = 0.6, h = sh_res_h - 1, $fn = 6);
   }
   color(c_4k7) hull() for (k = [1, sip_pins])
      translate(concat(sh_hole(sip_pin(k).x, sip_pin(k).y), sh_t + 0.5))
         translate([-1.25, -1.25, 0]) cube([2.5, 2.5, sh_sip_h - 0.5]);
}

// The shield drawing: the component side, the wiring of its back drawn
// through it (the wires as straight lines, run them as you like), row 0 at
// the bottom
module shield_view() {
   lt = 0.05;  // layers, stacked so the preview shows the upper one
   module layer(n) translate([0, 0, n * lt]) linear_extrude(lt) children();
   module label(t, size = 0.6, c = "#222222", ha = "left", va = "center", patch = false, l = 9) {
      color(c) layer(l) text(t, size = size, font = font, halign = ha, valign = va);
      if (patch) color(c_perf) layer(l - 1) offset(delta = 0.15) hull()
         text(t, size = size, font = font, halign = ha, valign = va);
   }
   function at(u) = sh_hole(u.x, u.y);
   c_top = "#f1c40f";
   color(c_perf) layer(0) difference() {
      offset(r = 0.6) offset(delta = -0.6) square(sh);
      for (h = sh_holes) translate(h) circle(d = 3, $fn = 24);
   }
   color("#b08a3e") layer(1)
      for (c = [0 : sh_grid.x - 1], r = [0 : sh_grid.y - 1]) translate(sh_hole(c, r)) circle(d = 0.75, $fn = 12);
   color("#3a2f1a") layer(2)
      for (c = [0 : sh_grid.x - 1], r = [0 : sh_grid.y - 1]) translate(sh_hole(c, r)) circle(d = 0.3, $fn = 8);
   // The Mega's ICSP header under the shield: keep its area free
   color("#e74c3c") layer(1) translate(mega_icsp - sh_o) difference() {
      square(mega_icsp_size + [2, 2] * icsp_clear, center = true);
      square(mega_icsp_size + [2, 2] * icsp_clear - [0.5, 0.5], center = true);
   }
   translate(mega_icsp - sh_o + [-mega_icsp_size.x / 2 - icsp_clear - 0.4, 0])
      label("ICSP below: keep free", 0.5, "#e74c3c", "right", "center", true);
   // The back: bridges, then the wires
   color("#7f8c8d") layer(3)
      for (r = sh_runs) if (r[2] == 0) hull() for (u = [r[0], r[1]]) translate(at(u)) circle(d = 0.7, $fn = 12);
   for (w = sh_wires) color(c_wire[w[2]]) layer(4)
      hull() for (u = [w[0], w[1]]) translate(at(u)) circle(d = 0.22, $fn = 8);
   // The Mega's header pins under the shield: used ones red, the rest grey
   used = [for (r = sh_runs) if (r[2] == 1) each [r[0], r[1]]];
   for (u = sh_stacked) translate(at(u)) {
      color(len([for (w = used) if (w == u) 1]) ? "#c0392b" : "#a0a0a0")
         layer(5) difference() { square(1.5, center = true); square(0.9, center = true); }
   }
   // Solder bridges on top
   color(c_top) layer(8)
      for (r = sh_runs) if (r[2] == 1) hull() for (u = [r[0], r[1]]) translate(at(u)) circle(d = 0.6, $fn = 12);
   // 330 Ohm resistors, standing: the body on the dot, the lead to the right
   for (r = sh_330) {
      color("#555555") layer(5) hull() for (u = [r[0], r330_lead(r[1])]) translate(at(u)) circle(d = 0.15, $fn = 6);
      color(c_330) layer(6) translate(at(r[0])) circle(d = 1.35, $fn = 24);
      color("#555555") layer(6) translate(at(r330_lead(r[1]))) circle(d = 0.45, $fn = 12);
   }
   // The pull-up network, pin 1 (the common) marked
   color(c_4k7) layer(6) hull() for (k = [1, sip_pins]) translate(at(sip_pin(k))) square(1.3, center = true);
   color("#ffffff") layer(7) translate(at(sip_pin(1))) circle(d = 0.6, $fn = 16);
   color("#ffffff") layer(7) for (k = [2 : sip_pins]) translate(at(sip_pin(k))) circle(d = 0.3, $fn = 8);
   // Port headers: the pin numbers on the pins, the port before pin 1
   for (port = [1 : 6]) {
      for (p = [1 : 8]) translate(at(sh_pin(port, p))) {
         moved = loose(port, p);
         color(moved ? "#1a5276" : p == 1 ? "#7b241c" : c_black) layer(6) square(1.4, center = true);
         label(moved ? str(port, ".", p) : str(p), moved ? 0.42 : 0.75, "#f4d03f", "center", "center", l = 7);
      }
      // The mux ports side by side: one label left of them
      d = sh_ports[port - 1][1];
      if (port == 1)
         translate(at(sh_pin(1, 1)) - [1.1, 0]) label("P1 P2 P3", 0.85, "#c0392b", "right", "center", true);
      else if (port > 3 && !loose(port, 1))
         translate(at(sh_pin(port, 1)) - d * 1.3)
            label(str("P", port), 0.85, "#2471a3", d.x ? "right" : "center", d.x ? "center" : "bottom", true);
   }
   // Mega pin names: analog in front of their row, the double header's rows
   // (only the inner pins and the servo power on the outer ones are used) on
   // the right with their lines
   for (n = [0 : 15]) translate(at(mega_hole(["A", n])) - [0, 0.95])
      label(str("A", n), 0.45, "#666666", "center", "top", true);
   for (l = sh_lines) if (l[3][0] == "A")
      translate(at(mega_hole(l[3])) - [0, 1.75]) label(l[0], 0.4, "#1e8449", "center", "top", true);
   function line_at(m) = [for (l = sh_lines) if (l[3] == m) l[0]];
   for (n = [22 : 2 : 52]) translate(at(mega_hole(["D", n + 1])) + [1.0, 0]) {
      ln = line_at(["D", n]);
      label(str("D", n, len(ln) ? str("  ", ln[0]) : ""), 0.5, len(ln) ? "#1e8449" : "#666666", "left", patch = true);
   }
   translate(at(mega_hole(["5V", 1])) + [1.0, 0]) label("5V, servo 5V", 0.5, c_wire[1], "left", patch = true);
   translate(at(mega_hole(["GND", 1])) + [1.0, 0]) label("GND, servo GND", 0.5, c_wire[2], "left", patch = true);
   translate([sh.x / 2, -2.2]) label("front wall side: ribbons from ports 1-3", 0.9, "#666666", "center");
   translate([sh.x + 1, sh.y + 1.6]) label("right wall side: ribbons from ports 4-6 ->", 0.9, "#666666", "right");
   // Legend
   legend = [[0, "port header pin (pin 1 dark red), ribbon from that port; blue: port.pin, a loose pin"],
             [1, "Mega header pin under the shield (red: wired)"],
             [2, "330 Ohm in series, standing, body on the dot, lead into the hole beside the Mega pin"],
             [3, "4.7 kOhm x 8 bussed network (SIP 9), pin 1 (common, 5 V) on the big dot"],
             [4, "solder bridge (or tinned wire) on the back between two neighbouring pins"],
             [5, "solder bridge on top: the hole beside a Mega pin onto it"],
             if (len(sh_wires)) [6, "wire-wrap wire on the back, pin to pin: signal, 5 V, GND, servo power"]];
   for (i = [0 : len(legend) - 1]) translate([2, -5.5 - i * 2.2]) {
      k = legend[i][0];
      if (k == 0) { color("#7b241c") layer(6) square(1.4, center = true); }
      else if (k == 1) color("#c0392b") layer(5) difference() { square(1.5, center = true); square(0.9, center = true); }
      else if (k == 2) color(c_330) layer(6) circle(d = 1.35, $fn = 24);
      else if (k == 3) { color(c_4k7) layer(6) square([1.3, 2], center = true);
                         color("#ffffff") layer(7) translate([0, 0.5]) circle(d = 0.6, $fn = 16); }
      else if (k == 4) color("#7f8c8d") layer(3) square([2, 0.7], center = true);
      else if (k == 5) color(c_top) layer(8) square([2, 0.6], center = true);
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
