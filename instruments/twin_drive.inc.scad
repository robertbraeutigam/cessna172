// Two motor drive, shared by the heading indicator (hi.scad) and the turn
// coordinator (tc.scad)
//
// The standard instrument's drive (instrument.inc.scad) plus a second
// motor that turns a disc round the axis:
// - Motor A turns the 3 mm steel axle 1:1 through the standard's gears
//   (layer y_g, next to the back plate), the magnet in A's gear over sensor
//   A in the back plate, like the standard's needle. What the axle carries
//   (a card, an airplane) is the instrument's.
// - The disc (y_b) turns on the dial's hub; an internal ring gear on its
//   back (z_ring teeth) is turned by motor B's pinion (z_pin teeth). The
//   disc's magnet is in the disc itself, its sensor in the dial's front
//   (its legs out along a groove, then back through the gear layer and the
//   back plate), so the disc has one home a turn. Its paper (y_bd) is the
//   instrument's.
// - The dial (y_d): the plate with the disc's sensor, its rim forward and
//   its hub (twin_dial(), the instrument says how far forward).
// - The two motors lie side by side on the back plate's back, their bodies
//   slanted so that their wire covers pass each other; three screws hold
//   the back plate in the case (back_cols). A board carrier on four posts
//   (twin_posts) behind them holds two ULN2003 boards (upright, A right of
//   the Nano, B left) and the Arduino Nano (in rails along z, the USB jack
//   up), facing back.
//
// Include it after instrument.inc.scad and after these, which the
// instrument defines:
// - y_bd: the disc's paper's front (y), the disc and everything behind it
//   follows from it;
// - y_ax: the axle's front and back end;
// - twin_nano_x: the Nano's middle on the carrier (x from the axis);
// - twin_posts: the carrier's four posts ([x, z]).
// The instrument draws its own case (twin_back_outline() behind the
// sheet), what is on the axle and in front of the disc, and the papers.
//
// Coordinates as in instrument.inc.scad: x to the right, y away from the
// pilot, z up, the origin on the axis at the sheet's front face.

// --- The disc and its gears ---
bd_t = 1.2;                  // the disc's plate (its paper on the front)
rm = 0.8;                    // module of the disc's gears
z_ring = 80;                 // the disc's internal ring
z_pin = 16;                  // motor B's pinion
ring_t = 3;
ring_wall = 1.2;             // outside the ring's roots
r_play = 0.2;                // the pinion off the ring: its tips off the ring's roots
dhub_d = 12;                 // the dial's hub, the disc turns on it
sleeve_w = 1.5;              // the disc's sleeve round it
bmag = [11, 0];              // the disc's magnet: radius, angle (clockwise from 12 o'clock, on the disc at its home)
bsens_out = 19;              // the disc sensor's legs: along a groove out to here, then back
dp_t = 2.5;                  // the dial's plate
pin_hub = 4.5;               // the pinion's hub (radius)

// --- Motors: shaft [x, z], the body's direction from it ---
mA = [[drive_a, 0], [cos(160), sin(160)]];          // the axle (the standard's place, 1:1)
b_drive = rm * (z_ring - z_pin) / 2 - r_play;       // the pinion from the axis, in the ring
mB = [[-b_drive, 0], [cos(-20), sin(-20)]];         // the disc

// --- Screws: three from the back plate into the case ---
back_cols = [cols[0], cols[1], [0, -ear_r]];

// --- Board carrier: on the back plate's posts behind the motors, the boards facing back ---
uln_r = [uln_board.y, uln_board.x];   // the ULN2003 boards turned upright
twin_car_z = [-24, 24];      // the carrier plate's bottom and top
usb_plug = 20;               // the plug over the Nano's end (a straight mini USB plug, then the cable bends back)

// --- Calculated ---
ring_R = rm * z_ring / 2;
bd_r = ring_R + 1.25 * rm + ring_wall;              // the disc
bsens_hole = pol(bsens_out, bmag[1]);               // the disc sensor's wires through the back
uln_xz = [[twin_nano_x + nano_rail_hw + 1.5, twin_car_z[0] + 1],           // A, right
          [twin_nano_x - nano_rail_hw - 1.5 - uln_r.x, twin_car_z[0] + 1]]; // B, left
uln_holes_a = [for (b = uln_xz, i = [0, 1], j = [0, 1])
   [b.x + uln_hole_in + i * (uln_r.x - 2 * uln_hole_in), b.y + uln_hole_in + j * (uln_r.y - 2 * uln_hole_in)]];
nano_z0 = twin_car_z[0] + 2;                        // the Nano's bottom end (on the stop)
nano_zc = nano_z0 + nano_board.y / 2;               // its middle
twin_car_x = [uln_xz[1].x - 1, uln_xz[0].x + uln_r.x + 1];
ring_ratio = z_ring / z_pin;

// y, front to back, from the disc's paper
y_b = [y_bd + paper_t, y_bd + paper_t + bd_t, y_bd + paper_t + bd_t + ring_t];   // the disc: plate, ring's back
y_d = [y_b[2] + 0.3, y_b[2] + 0.3 + dp_t];          // the dial's plate
y_pn = [y_b[1] + 0.3, y_b[2] - 0.2];                // the pinion's teeth
y_g = [y_d[1] + gear_gap, y_d[1] + gear_gap + gear_t];   // the axle's gears
y_p = [y_g[1] + gear_gap, y_g[1] + gear_gap + back_t];   // the back plate, the case's back
y_sh = y_p[1] - shaft_len;                          // the motors' shafts' ends
y_mb = y_p[1] + motor_flange_t + motor_h;           // their bodies' backs
y_k = [y_mb + 1, y_mb + 1 + car_t];                 // the carrier
// behind the sheet's back: all of it, the case and the back plate; the motors and the carrier are above twin_deep_z (from the axis)
twin_depth = y_k[1] + max(uln_standoff + uln_t + uln_plug_room, nano_under + nano_t + nano_usb[1]) - y_sheet1;
twin_case_depth = y_p[1] - y_sheet1;
twin_deep_z = min(concat([twin_car_z[0]], [for (m = [mA, mB]) m_body(m).y - motor_d / 2],
                         [for (m = [mA, mB], e = m_ears(m)) e.y - motor_ear_w / 2],
                         [for (m = [mA, mB], p = cover_pts(m)) p.y]));

// --- Checks ---
// the disc and its gears
assert(bd_r <= rim_id / 2 - 0.4, "The disc runs into the dial's rim");
assert(b_drive + g_ra(z_pin, rm) + 0.1 <= ring_R + rm, "Pinion hits the ring's roots");
assert(b_drive - g_ra(z_pin, rm) >= bmag[0] + magnet[0] / 2 + 1.5 + 0.5, "Pinion runs into the disc's magnet boss");
assert(b_drive - g_ra(z_pin, rm) >= dhub_d / 2 + 0.15 + sleeve_w + 1, "Pinion runs into the disc's sleeve");
assert(y_pn[0] >= y_b[1] + 0.2 && y_pn[1] <= y_b[2], "Pinion off the ring");
assert(y_sh >= y_pn[1] + 0.5 && y_sh + flat_len >= y_g[1] - 0.5, "B's shaft (its flats) does not reach into the pinion's hub");
assert(y_sh <= y_g[0] && y_sh + flat_len >= y_g[1] - 0.5, "A's shaft (its flats) does not reach through its gear");
assert(y_sh >= y_d[0] + 0.5, "A's shaft runs into the disc");
assert(g_rf(z_pin, rm) >= pin_hub && pin_hub - shaft_d / 2 >= 1.5, "Pinion's hub");
assert(norm(mB[0]) - pin_hub >= gear_ra + 1.5, "Pinion's hub runs into the axle's gear");
assert(norm(mB[0] - mA[0]) >= gear_ra + pin_hub + 2, "Pinion's hub runs into A's gear");
assert(bmag[0] - magnet[0] / 2 - 1.5 <= dhub_d / 2 + 0.15 + sleeve_w, "The disc's magnet boss off the sleeve");
assert(ring_t - magnet[1] - 0.1 + bd_t >= 1, "The disc's magnet pocket too deep");
assert(y_d[0] - y_b[2] + 0.1 <= magnet_gap_max && y_p[0] - y_g[1] + 0.1 <= magnet_gap_max, "A magnet too far from its sensor");
assert(dhub_d / 2 - (axle[0] + 0.3) / 2 >= 3, "Dial's hub too thin");
// the disc's sensor in the dial, its legs in a groove to the hole, through the gear layer and the back plate
assert(dp_t - sensor.y - 0.1 >= 0.5, "The disc's sensor pocket too deep for the dial");
assert(norm(bsens_hole) - 1.5 >= gear_ra + 1.5 && norm(bsens_hole - mA[0]) - 1.5 >= gear_ra + 1.5, "The disc sensor's wires run into an axle gear");
assert(norm(bsens_hole - mB[0]) >= pin_hub + 3, "The disc sensor's wires run into the pinion");
for (m = [mA, mB]) {
   assert(norm(bsens_hole - m_body(m)) >= motor_d / 2 + 1.5 && clear_cover(m, bsens_hole, 1.5), "The disc sensor's wires under a motor");
   for (e = m_ears(m)) assert(norm(bsens_hole - e) >= nut[0] / cos(30) / 2 + 2, "The disc sensor's wires under a motor's ear");
}
// the axle's drive (the standard's): the axle, the dial's posts
assert(y_ax[1] <= y_p[1] - 0.8 && y_ax[1] >= y_p[0] + 1.5, "The axle does not end in the back plate");
for (a = post_angles) let(p = post_r * [cos(a), sin(a)]) {
   assert(norm(p - mA[0]) >= gear_ra + post_d / 2 + 1, "A dial post runs into A's gear");
   assert(norm(p - mB[0]) >= pin_hub + post_d / 2 + 1, "A dial post runs into the pinion's hub");
   assert(norm(p - bsens_hole) >= post_d / 2 + 2.5, "A dial post on the disc sensor's wires");
}
// the motors on the back plate
assert(norm(m_body(mA) - m_body(mB)) >= motor_d + 1, "The motors run into each other");
for (i = [0, 1]) let(m = [mA, mB][i], o = [mA, mB][1 - i]) {
   assert(min([for (p = cover_pts(m)) norm(p - m_body(o))]) >= motor_d / 2 + 1, "A motor's cover runs into the other motor");
   for (e = m_ears(m)) {
      assert(norm(e) + csk_d / 2 <= bore_d / 2 - 1, "A motor ear's screw off the back plate");
      assert(norm(e) >= nut[0] / cos(30) / 2 + axle[0] / 2 + 1.5, "A motor's ear nut on the axle");
      assert(norm(e - m_body(o)) >= motor_d / 2 + motor_ear_w / 2 + 0.5 && clear_cover(o, e, motor_ear_w / 2 + 0.5),
             "A motor's ear runs into the other motor");
   }
}
for (p = cover_pts(mA)) assert(clear_cover(mB, p, 1), "The motors' covers run into each other");
for (p = cover_pts(mB)) assert(clear_cover(mA, p, 1), "The motors' covers run into each other");
assert(norm(sensor_c - m_body(mA)) + sensor.z / 2 >= motor_d / 2 + 1.5 && clear_cover(mA, sensor_c, sensor.x),
       "Sensor A's legs run into motor A");
assert(norm(sensor_c - m_body(mB)) >= motor_d / 2 + 3, "Sensor A runs into motor B");
for (c = back_cols) {
   for (m = [mA, mB]) {
      assert(norm(c - m_body(m)) >= motor_d / 2 + csk_d / 2 + 0.5 && clear_cover(m, c, csk_d / 2 + 0.5), "A case screw under a motor");
      for (e = m_ears(m)) assert(norm(c - e) >= motor_ear_w / 2 + csk_d / 2 + 0.5, "A case screw under a motor's ear");
   }
   assert(norm(c - mA[0]) >= gear_ra + ear_d / 2 + 1, "A case column runs into A's gear");
}
// the carrier: posts clear of the motors, boards on it
for (p = twin_posts) {
   for (m = [mA, mB]) {
      assert(norm(p - m_body(m)) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into a motor");
      for (e = m_ears(m)) assert(norm(p - e) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
      assert(clear_cover(m, p, car_post_d / 2 + 0.5), "A carrier post runs into a motor's cover");
   }
   assert(norm(p - sensor_c) >= car_post_d / 2 + sensor.x / 2 + 1.5, "A carrier post on sensor A's legs");
   assert(norm(p - bsens_hole) >= car_post_d / 2 + 2.5, "A carrier post on the disc sensor's wires");
   for (c = back_cols) assert(norm(p - c) >= car_post_d / 2 + csk_d / 2 + 0.5, "A carrier post on a case screw");
   assert(norm(p) + car_post_d / 2 <= case_r - 0.5, "A carrier post off the back plate");
   assert(p.x - car_post_d / 2 >= twin_car_x[0] && p.x + car_post_d / 2 <= twin_car_x[1] && p.y - car_post_d / 2 >= twin_car_z[0]
          && p.y + car_post_d / 2 <= twin_car_z[1], "A carrier post off the carrier");
   assert(min([for (h = uln_holes_a) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
   assert(abs(p.x - twin_nano_x) - csk_d / 2 >= nano_rail_hw + 1, "A carrier screw under the Nano's rails");
}
for (b = uln_xz) assert(b.y >= twin_car_z[0] + 0.5 && b.y + uln_r.y <= twin_car_z[1] - 0.5, "ULN2003 board off the carrier");
assert(nano_z0 + nano_board.y <= twin_car_z[1] + 1, "Nano off the carrier");
assert(uln_xz[0].x >= twin_nano_x + nano_rail_hw + 1 && uln_xz[1].x + uln_r.x <= twin_nano_x - nano_rail_hw - 1,
       "A ULN2003 board over the Nano's rails");
// the instrument above it: the USB plug stays under its case
assert(nano_z0 + nano_board.y + usb_plug <= inst_pitch.y - case_r - 1, "The USB plug runs into the instrument above");

// --- Outline behind the sheet, x right, z up: the case round the back screws and motor A's gear ---
module twin_back_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (c = back_cols) translate(c) circle(d = ear_d);
   }
   hull() {
      circle(d = case_d, $fn = 180);
      translate(mA[0]) circle(r = arm_r, $fn = 120);
      translate(cols[0]) circle(d = ear_d);
   }
}

// --- The disc: the plate (its paper on it), its sleeve on the dial's hub, the internal ring, the magnet;
// a: clockwise; children: more to cut out of it (at its home) ---
module twin_disc(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_b[0], y_b[1]) circle(r = bd_r, $fn = 180);
         along_y(y_b[1] - 0.01, y_b[2]) ring_gear_2d(z_ring, rm, bd_r);
         along_y(y_b[0], y_b[2]) circle(r = dhub_d / 2 + 0.15 + sleeve_w);
         along_y(y_b[1] - 0.01, y_b[2]) hull() {
            circle(r = dhub_d / 2 + 0.15 + sleeve_w);
            translate(pol(bmag[0], bmag[1])) circle(d = magnet[0] + 3);
         }
      }
      along_y(y_b[0] - 1, y_b[2] + 1) circle(d = dhub_d + 0.3);
      translate([pol(bmag[0], bmag[1]).x, y_b[2] + 0.01, pol(bmag[0], bmag[1]).y]) rotate([90, 0, 0])
         cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
      children();
   }
}

// --- Dial: the plate with a rim forward to y_rim, the hub the disc turns on (its front at y_hub),
// the disc's sensor in its front; children: more on it ---
module twin_dial(y_rim, y_hub) {
   difference() {
      union() {
         along_y(y_d[0], y_d[1]) circle(d = rim_od, $fn = 180);
         along_y(y_rim, y_d[0] + 0.01) difference() {
            circle(d = rim_od, $fn = 180);
            circle(d = rim_id, $fn = 180);
         }
         along_y(y_hub, y_d[0] + 0.01) circle(d = dhub_d);
         children();
      }
      along_y(y_hub - 1, y_d[1] + 1) circle(d = axle[0] + 0.3);
      // the pinion's hub and A's shaft end through it
      along_xz(mB[0], y_d[0] - 1, y_d[1] + 1) circle(r = pin_hub + 0.6);
      along_xz(mA[0], y_d[0] - 1, y_d[1] + 1) circle(d = shaft_d + 1.5);
      // the disc's sensor: flat face forward, its legs out in a groove, then back through the hole
      rotate([0, bmag[1], 0]) {
         translate([-sensor.x / 2 - 0.15, y_d[0] - 0.01, bmag[0] - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
         translate([-sensor_legs_w / 2, y_d[0] - 0.01, bmag[0]]) cube([sensor_legs_w, 1, bsens_out - bmag[0] + 1]);
         translate([0, y_d[0] - 1, bsens_out]) rotate([-90, 0, 0]) cylinder(d = 3, h = dp_t + 2);
      }
      // the back plate's posts' ends, keying it
      for (a = post_angles) translate([post_r * cos(a), y_d[1] - 1, post_r * sin(a)]) rotate([-90, 0, 0]) cylinder(d = post_d + 0.3, h = 2);
   }
}

// --- Gears: the axle's, A's (the magnet in its back), B's pinion ---
module twin_axle_gear(a = 0) {
   rotate([0, a, 0]) difference() {
      along_y(y_g[0], y_g[1]) gear_2d(gear_z);
      along_y(y_g[0] - 1, y_g[1] + 1) circle(d = axle[0] - 0.1);
   }
}

module twin_motor_gear(a = 0) {
   translate([mA[0].x, 0, mA[0].y]) rotate([0, a, 0]) difference() {
      along_y(y_g[0], y_g[1]) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
      translate([0, y_g[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, gear_t + 2);
      translate([mag_r * cos(mag_angle), y_g[1] + 0.01, mag_r * sin(mag_angle)]) rotate([90, 0, 0])
         cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

module twin_pinion(a = 0) {
   translate([mB[0].x, 0, mB[0].y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_pn[0], y_pn[1]) gear_2d(z_pin, rm);
         along_y(y_pn[1] - 0.01, y_g[1]) circle(r = pin_hub);
      }
      translate([0, y_g[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y_g[1] + 1 - y_sh + 0.3);
   }
}

// --- Back plate: the axle's bearing, the dial's posts, motors A and B, sensor A; the carrier's posts on its back ---
module twin_back_plate() {
   difference() {
      union() {
         along_y(y_p[0], y_p[1]) twin_back_outline();
         for (a = post_angles) translate([post_r * cos(a), y_d[1] - 0.8, post_r * sin(a)]) rotate([-90, 0, 0])
            cylinder(d = post_d, h = y_p[0] - y_d[1] + 0.8 + 0.01);
         for (p = twin_posts) along_xz(p, y_p[1] - 0.01, y_k[0]) circle(d = car_post_d);
      }
      // the axle, blind
      translate([0, y_p[0] - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = axle[0] + 0.1, h = back_t - 0.8);
      for (c = back_cols) translate([c.x, y_p[1], c.y]) rotate([-90, 0, 0]) csk_hole();
      for (m = [mA, mB]) {
         translate([m[0].x, y_p[0] - 1, m[0].y]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
         for (e = m_ears(m)) translate([e.x, y_p[0], e.y]) rotate([90, 0, 0]) csk_hole();
      }
      sensor_pocket(sensor_c, y_p[0], -1);
      // the disc sensor's wires
      along_xz(bsens_hole, y_p[0] - 1, y_p[1] + 1) circle(d = 3);
      for (p = twin_posts) translate([p.x, y_k[0] + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - car_t + 1);
   }
}

// --- Board carrier: the two ULN2003 boards (upright) and the Nano (USB up) on its back ---
module twin_carrier() {
   y1 = y_k[1];
   difference() {
      union() {
         along_y(y_k[0], y1) translate([twin_car_x[0], twin_car_z[0]]) square([twin_car_x[1] - twin_car_x[0], twin_car_z[1] - twin_car_z[0]]);
         for (h = uln_holes_a) along_xz(h, y1 - 0.01, y1 + uln_standoff) circle(d = uln_standoff_d);
         // Nano rails along z (lib/nano.inc.scad), a stop at the bottom end
         on_board_plate([twin_nano_x, nano_zc], y1, "up")
            nano_rails(y1 = twin_car_z[1] - nano_zc, far_stop = true);
      }
      for (h = uln_holes_a) along_xz(h, y1 - 1, y1 + uln_standoff + 1) circle(d = pilot_d);
      for (p = twin_posts) translate([p.x, y1, p.y]) rotate([-90, 0, 0]) csk_hole();
   }
}

// --- View only ---
// a paper's colour layers (children, a 2D print drawn with ink()) at y, facing forward, turned by a
module paper_part(y, a, colors) {
   rotate([0, a, 0]) for (i = [0 : len(colors) - 1])
      color(colors[i]) translate([0, y - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = colors[i]) children();
}

module twin_boards_part() {
   for (b = uln_xz) on_board_plate(b + uln_r / 2, y_k[1], "right") uln_part();
   on_board_plate([twin_nano_x, nano_zc], y_k[1], "up") nano_part(c_board);
}

// the drive's parts: the axle at aa, the disc at ad (clockwise); children: the disc's paper (2D, in colors) and the disc
// (twin_disc() or the instrument's, at its home); e: apart by this
module twin_drive_parts(aa, ad, colors, e = 0) {
   ma = -aa;                                   // motor A turns the other way (1:1)
   mb = ad * ring_ratio;                       // the pinion turns with the ring
   translate([0, 0.8 * e, 0]) {
      color(c_case) render() rotate([0, ad, 0]) children(1);
      paper_part(y_b[0], ad, colors) children(0);
      rotate([0, ad, 0]) color(c_magnet) translate([pol(bmag[0], bmag[1]).x, y_b[2], pol(bmag[0], bmag[1]).y]) rotate([90, 0, 0])
         cylinder(d = magnet[0], h = magnet[1]);
   }
   translate([0, 2.2 * e, 0]) {
      color(c_case) render() twin_axle_gear(aa);
      color(c_case) render() twin_motor_gear(ma);
      color(c_case) render() twin_pinion(mb);
      color(c_steel) along_y(y_ax[0], y_ax[1]) circle(d = axle[0]);
      translate([mA[0].x, 0, mA[0].y]) rotate([0, ma, 0]) color(c_magnet)
         translate([mag_r * cos(mag_angle), y_g[1], mag_r * sin(mag_angle)]) rotate([90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
   }
   translate([0, 3 * e, 0]) {
      color(c_case) render() twin_back_plate();
      motor_at(mA, y_p[1]);
      motor_at(mB, y_p[1]);
      color("#202020") translate([sensor_c.x - sensor.x / 2, y_p[0], sensor_c.y - sensor.z / 2]) cube(sensor);
   }
   translate([0, 4 * e, 0]) {
      color(c_case) twin_carrier();
      twin_boards_part();
   }
}

// the disc's sensor in the dial (view only), with the dial
module twin_dial_sensor_part() {
   color("#202020") rotate([0, bmag[1], 0]) translate([-sensor.x / 2, y_d[0], bmag[0] - sensor.z / 2]) cube(sensor);
}
