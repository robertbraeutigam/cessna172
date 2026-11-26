// The stepper drive: a 28BYJ-48 stepper, its ULN2003 driver board, the
// A3144 hall sensor and the disc magnet that home it, shared by the
// compass and the instruments (bought parts: sizes and view models). The
// Makefiles copy lib/*.inc.scad into each component's target/, so a file
// includes it as <stepper.inc.scad>. The holders (motor posts or plates,
// the boards' carriers, the sensor pockets) are each component's own; the
// ULN2003 standoffs are drawn by every carrier with uln_hole_xy.

// --- 28BYJ-48 stepper, MEASURE ---
motor_d = 28;
motor_h = 19;                // body: back face to the flange
motor_flange_t = 1;          // the flange with the two ears
motor_ear_dx = 17.5;         // ear holes from the body's middle (35 apart)
motor_ear_w = 7;             // ear width (round ends)
motor_ear_hole = 4.2;
motor_shaft_dy = 8;          // shaft from the body's middle, away from the wire cover
motor_boss = [9, 1.5];       // boss on the flange around the shaft: diameter, height
shaft_d = 5;
shaft_flat = 3;              // across the two flats
shaft_len = 10;              // over the flange
flat_len = 6;                // the flats, at its end
motor_cover = [14.6, 17];    // blue wire cover: width, reach from the body's middle
motor_wire_h = 6;            // the wires leave the cover up to this over its back face

// --- ULN2003 driver board, MEASURE ---
uln_board = [35, 32];        // width (x) x height (y)
uln_t = 1.6;
uln_hole_in = 2.7;           // its 4 holes from the edges
uln_parts = 14;              // the parts on its front (socket, chip, header pins)
uln_plug_room = 29.5;        // in front of it with female Dupont plugs on its pins (and the motor's plug), their wires bent
uln_pins = 3;                // solder stubs behind it
uln_standoff = 4;            // on printed standoffs this high
uln_standoff_d = 6;
// Its holes from its middle, [x, y]
uln_hole_xy = [for (x = [-1, 1], y = [-1, 1]) [x * (uln_board.x / 2 - uln_hole_in), y * (uln_board.y / 2 - uln_hole_in)]];

// --- A3144 hall sensor and the disc magnet, MEASURE ---
sensor = [4.1, 1.6, 3.1];    // A3144 (TO-92S): width, thickness (flat face), height
sensor_legs_w = 3.6;         // the legs' slot: wider than the legs (2.54 + a leg), narrower than the body,
                             // so the body stays centred in its pocket over the magnet
magnet = [5, 2];             // disc magnet: diameter, height (two 5 x 1 stacked)
magnet_gap_max = 2.5;        // magnet to the sensor's flat face: two 5 x 1 switch it reliably up to about 3,
                             // centred over its middle

// The stepper for the views: the flange's top at z = 0, the shaft at the
// origin pointing up (+z), the body towards +y
module motor_local() {
   color("#b9c0c8") {
      translate([0, motor_shaft_dy, -motor_flange_t - motor_h]) cylinder(d = motor_d, h = motor_h);
      translate([0, motor_shaft_dy, -motor_flange_t]) linear_extrude(motor_flange_t) difference() {
         hull() for (s = [-1, 1]) translate([s * motor_ear_dx, 0]) circle(d = motor_ear_w);
         for (s = [-1, 1]) translate([s * motor_ear_dx, 0]) circle(d = motor_ear_hole);
      }
      cylinder(d = motor_boss[0], h = motor_boss[1]);
      cylinder(d = shaft_d, h = shaft_len);
   }
   color("#2f6fc0") translate([-motor_cover[0] / 2, motor_shaft_dy, -motor_flange_t - motor_h])
      cube([motor_cover[0], motor_cover[1], motor_h - 2]);
}

// The ULN2003 board for the views: its middle over the origin, on its
// standoffs over a plate at z = 0, its parts up (+z)
module uln_part() {
   translate([-uln_board.x / 2, -uln_board.y / 2, uln_standoff]) {
      color("#2f7d4a") cube([uln_board.x, uln_board.y, uln_t]);
      color("#202020") translate([8, 6, uln_t]) cube([19, 7, 6]);
      color("#f0f0f0") translate([7, uln_board.y - 9, uln_t]) cube([12, 6, 7]);
      color("#c0392b") for (i = [0 : 3]) translate([uln_board.x - 6, 6 + i * 4, uln_t]) cube([2, 2, 2]);
   }
}
