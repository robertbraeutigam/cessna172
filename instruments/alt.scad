// Altimeter on two 28BYJ-48 steppers
//
// The six-pack's top right instrument (frame/), right of the attitude
// indicator, over the VSI. It has the standard instrument's case front
// (instrument.inc.scad: the hole, the lip, the glass, four screws on the
// diagonals; the lower left one is the knob's place, like the real one),
// two needles on concentric shafts, Kollsman windows at 3 o'clock (inHg)
// and 9 o'clock (hPa) and their setting knob at the lower left. It is deeper than the standard
// (alt_depth echo), but it is in the top row, over the force feedback
// yoke's housing (the frame's alt_depth checks it).
//
// What moves:
// - The needles: 100 ft (long, in front) on a 3 mm steel axle, 1000 ft
//   (short and wide) on a 4 mm brass tube round it. No 10000 ft needle:
//   the airplane stays under 10000 ft. Each needle has a motor of its
//   own: no clockwork, so each one homes on its own.
//   - 100 ft: the axle goes back through everything to motor C on the
//     rear plate, its shaft on the axis: a coupler joins them (direct,
//     2.04 steps a foot). The coupler's magnet homes it.
//   - 1000 ft: its gear (14 teeth) in the gear layer next to the back
//     plate, turned by a 28 tooth gear on motor B on the back plate: the
//     needle turns twice per motor turn, so the motor's one home a turn
//     is one place of the needle. B's magnet passes a sensor in the back
//     plate.
// - The Kollsman windows: a disc behind the dial (a printed paper ring on
//   it: 28.1 to 31.0 inHg inside, the same in hPa, 952 to 1049, outside)
//   shows through two windows in the dial, inHg at 3 o'clock, hPa at
//   9 o'clock (each window only over its scale; both scales follow the
//   one setting: 1 inHg is 33.86 hPa). The knob
//   turns it through a gear train (the knob's pinion, an idler on a steel
//   pin, an internal ring gear on the disc; their gears in the front
//   layer), and a 10 turn pot on the knob's shaft tells MobiFlight where
//   it is: absolute, nothing to keep in step with X-Plane. The pot's end
//   stops end the scale.
// - The keeper (in front of the gear layers) holds the disc on the dial's
//   hub, its two legs press the dial forward against the spacer ring and
//   the glass and key it (the windows stay at 3 and 9 o'clock).
// - A board carrier behind motor C holds the two ULN2003 boards and the
//   Arduino Nano (MobiFlight, its own USB cable), facing back.
//
// Parts (printed): the case (back side down), the spacer ring, the dial
// (front down), the Kollsman disc (front down), the keeper (front down),
// the idler (its big gear down), the knob shaft (on its pinion's end),
// the knob (front down), the two needles (front down, white), the needle
// gear, motor gear B, the coupler (back down), the back plate and the
// rear plate (front down, the posts up), the carrier (front down). Black
// but the needles.
//
// Parts to buy:
// - 2 x 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and
//   a mini USB cable, 2 x A3144 hall sensor, 2 x disc magnet 6 x 3 mm
// - 3 mm silver steel rod (the axle, axle_len, and the idler's pin,
//   pin_len), brass tube 4 x 0.45 mm (tube, tube_len)
// - a 10 turn pot 10k with a 6.35 mm shaft (3590S type, pot_*)
// - clear sheet 1 mm (glass), the face and the Kollsman ring printed on
//   photo paper
// - M3 x 8 button head, black (3, through the sheet into the case),
//   M3 x 8 countersunk self tapping (3, back plate into the case; 4, rear
//   plate onto the back plate's posts; 4, the carrier onto the rear
//   plate's posts), M3 x 8 countersunk + nut (4, motor ears), M3 x 6 self
//   tapping (8, ULN2003 boards)
//
// Assembly (see the README): magnets into motor gear B and the coupler.
// Motor B, the pot and sensor B onto the back plate, gear B on its
// shaft; motor C and sensor C onto the rear plate, the coupler on its
// shaft; the rear plate onto the back plate's posts. The needle gear onto
// the tube (glue), the idler's pin into the back plate, the idler on it.
// The axle through the back plate into the coupler, the tube over it
// into its bearing. Paper ring onto the disc, face onto the dial. Glass
// into the case, the spacer ring, the dial, the disc on the dial's hub
// (28.1 at the index with the knob at its low stop), the keeper; then
// the back plate's stack, the gears meshing, screwed into the case. Knob
// shaft onto the pot's shaft (glue). Wire it, home it, press the needles
// on at 0. Into the panel: the case into the hole from behind, the knob's
// shaft through its hole, the three screws, the knob on.
//
// Coordinates as in instrument.inc.scad: x to the right, y away from the
// pilot, z up, the origin on the needles' axis at the sheet's front face.

$fn = 60;

include <instrument.inc.scad>

// Preview: the needles at this altitude, the windows at this setting
view_ft = 3780;
view_baro = 29.92;
explode = 25;

// --- Face ---
num_r = 25.5;                // the numerals 0..9 (hundreds of feet)
num_size = 5.5;
r_tick = 35.5;               // the ticks' outer edge
tick_20 = [2.6, 0.5];        // every 20 ft: length, width
tick_100 = [4.8, 0.9];       // every 100 ft
label_size = 2.2;
small_size = 1.5;
win_hg = [15.5, 23.5];       // the Kollsman windows: inHg at 3 o'clock (the disc's inner scale): inner and outer radius
win_hpa = [24, 31.9];        // hPa at 9 o'clock (its outer scale)
win_h = 8;                   // their height
win_line = 0.35;             // the white line round them (cut on its inside)
// colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_white = "white";
face_colors = [c_black, c_white];

// --- Needles: 100 ft, 1000 ft (front to back) ---
nd_front = 1.5;              // the glass to the 100 ft needle
nd_t = 0.8;                  // blades
nd_hub_h = 1;                // their hubs, behind the blades
nd_gap = 0.3;                // a hub to the next blade
nd_hub = [6, 7.5];           // the hubs' diameters
nd100 = [33, 8, 2.2, 0.8];   // length, tail, width at the hub, at the tip
nd1000 = [21, 14, 4.6];      // tip, where it narrows to it, width
tube = [4, 3.1];             // MEASURE: the brass tube (1000 ft): OD, ID
run_c = 0.3;                 // turning clearance on a diameter
press_c = 0.1;               // pressed on

// --- Needle drive ---
nm = 1;                      // module of the needles' gears
z_mg = 28;                   // motor gears A and B
z_ng = 14;                   // the needles' gears: twice the motor's turns
gw = 4.5;                    // the gear layers' width
lay_gap = 0.5;
mag_rm = 7;                  // magnets from their shafts
cp = [11, 5.5, 7, 6];        // the coupler: radius, disc width, hub diameter, hub length (the axle in it)

// --- Kollsman windows ---
baro_range = [28.1, 31.0];   // inHg, the scale (numbers every 0.1, ticks every 0.02)
baro_std = 29.92;
hpa_per_inhg = 33.8639;      // the hPa scale: the same disc, the same setting
k_baro = 100;                // degrees of the disc per inHg
km = 0.8;                    // module of the knob's train
z_k = [14, 23, 13, 90];      // knob pinion, idler gear, idler pinion, the disc's internal ring
k_play = 0.2;                // the idler pinion off the ring: its tips off the ring's roots
kd_t = 1.2;                  // the disc's plate (the paper on its front)
kr_t = 3;                    // its ring gear, behind the plate
kr_wall = 1.2;               // outside the ring's roots
dhub_r = 14.5;               // the dial's hub, the disc turns on it
kp_r = 12.5;                 // the keeper's legs, from the axis
kp_angles = [0, 180];        // clockwise from 12 o'clock (between motor gears A and B)
kp_d = 4;
kpin = [2, 2];               // pins: the dial's hub into the keeper, the legs into the back plate: diameter, length
keep_r = 16;                 // the keeper's disc (over the disc's plate's inner edge)
ring_paper = [15, 32.5];     // the Kollsman ring's paper: inner and outer radius
baro_num_r = 15.7;           // the inHg numbers' inner end (reading outwards at 3 o'clock)
baro_num_size = 1.9;
baro_tick = [[22, 23.3, 0.3], [21.3, 23.3, 0.45]];     // inHg, every 0.02, every 0.1: from, to, width (at the index, outside)
hpa_num_r = 31.7;            // the hPa numbers' outer end (reading inwards at 9 o'clock)
hpa_num_size = 1.8;
hpa_tick = [[24.2, 25.2, 0.3], [24.2, 25.7, 0.45]];    // hPa, every 1, every 5 (numbered): from, to, width (at the index, inside)

// --- 10 turn pot (3590S type), MEASURE ---
pot_body = [22.5, 20];       // diameter, length behind its mounting face (with the lugs)
pot_bush = [9.5, 9.5];       // bushing: diameter, length
pot_nut = [14.3, 2.4];       // across flats, height
pot_shaft = [6.35, 22];      // diameter, length from the mounting face
pot_turns = 10;
pot_boss = 2;                // on the back plate's back: the bushing reaches less far forward

// --- Knob ---
alt_knob = [14, 8, 1.2];     // diameter, length, knurl depth
knob_gap = 0.5;              // to the sheet
ks_d = 6;                    // the knob's printed shaft through the sheet (a 7 mm hole)
ks_sleeve = 9;               // round the pot's shaft

// --- Motors: shaft [x, z], the body's direction from it ---
// (the shaft is motor_shaft_dy from the body's middle, the ears across)
mount_play = 0.5;

// --- Posts and boards ---
bp_posts = [[0, 30], [0, -30], [33, 18], [-36, -12]];    // the back plate's (its back) to the rear plate
rp_posts = [[28, 26], [-28, 26], [-28, -20], [5, -36]];  // the rear plate's (its back) to the carrier
rp_r = 42;                   // the rear plate
uln_xz = [[-37, 6], [-37, -28]];   // the ULN2003 boards' lower left corners: B (1000), C (100)
nano_xz = [12, -47];         // the Nano's lower left corner, along z, its USB jack down
alt_nano_c = nano_xz + [nano_board.x / 2, nano_board.y / 2];   // its middle
car_box = [-39, -49, 39, 40];   // carrier plate: x0, z0, x1, z1

// --- Calculated ---
function g_ra(z, m) = m * z / 2 + m;
function g_rf(z, m) = m * z / 2 - 1.25 * m;
function dir(a) = [cos(a), sin(a)];                   // a: from +x, counter clockwise
function m_body(m) = m[0] + motor_shaft_dy * m[1];
function m_perp(m) = [m[1].y, -m[1].x];
function m_ears(m) = [for (s = [-1, 1]) m_body(m) + s * motor_ear_dx * m_perp(m)];
function m_cover(m) = m_body(m) + motor_cover[1] * m[1];
// clear of a motor's wire cover: a circle of radius r at p
function clear_cover(m, p, r) = let(d = p - m_body(m), t = d * m[1], s = d * m_perp(m))
   t >= motor_cover[1] + r || t <= -r || abs(s) >= motor_cover[0] / 2 + r;
function baro_a(v) = 90 + k_baro * (v - baro_std);  // on the disc (clockwise from 12), at baro_std
function hpa_a(v) = 270 + k_baro * (v / hpa_per_inhg - baro_std);

a_drive = nm * (z_mg + z_ng) / 2 + gear_play;         // motor B from the axis
mB = [[-a_drive, 0], [0, 1]];                         // 1000 ft, its body up
mC = [[0, 0], [0, 1]];                                // 100 ft, on the rear plate
R4 = km * z_k[3] / 2;                                 // the ring's pitch radius
kd_ro = R4 + 1.25 * km + kr_wall;                     // the disc
k_dir = dir(225);                                     // the knob's train: down left
idler_c = ((z_k[3] - z_k[2]) * km / 2 - k_play) * k_dir;
knob_c = idler_c + (km * (z_k[0] + z_k[1]) / 2 + gear_play) * k_dir;
k_ratio = z_k[1] / z_k[0] * z_k[3] / z_k[2];          // knob turns per disc turn
ra_k = [for (z = z_k) g_ra(z, km)];
ks_boss = ra_k[0] + 1 + wall;                         // the case round the knob's pinion
ki_boss = ra_k[1] + 1 + wall;                         // and round the idler's gear
pot_boss_r = pot_body[0] / 2 + 1.5;
snsB = mB[0] + mag_rm * [0, -1];                      // B's (down)
snsC = mC[0] + mag_rm * [0, -1];                      // C's (down)
kp_xz = [for (a = kp_angles) pol(kp_r, a)];

// y, front to back
y_nd = [for (i = [0 : 1]) y_glass1 + nd_front + i * (nd_t + nd_hub_h + nd_gap)];   // the blades' fronts
y_fc = y_nd[1] + nd_t + nd_hub_h + 0.5;               // the paper's front
y_dl0 = y_fc + paper_t;                               // the dial
y_dl1 = y_dl0 + dial_t;
y_kd0 = y_dl1 + 0.3;                                  // the Kollsman disc's plate
y_kd1 = y_kd0 + kd_t;                                 // its ring
y_kd2 = y_kd1 + kr_t;
y_hb = y_kd1 + 0.3;                                   // the dial's hub's end, the keeper's front
y_l1 = [y_kd2 + lay_gap, y_kd2 + lay_gap + gw];       // gear layer 1: the idler's gear, the knob's pinion
y_l2 = [y_l1[1] + lay_gap, y_l1[1] + lay_gap + gw];   // gear layer 2: 1000 ft
y_bp = [y_l2[1] + lay_gap, y_l2[1] + lay_gap + back_t];   // back plate, the case's back
y_msh = y_bp[1] - shaft_len;                          // A's and B's shafts' ends
y_mb = y_bp[1] + motor_flange_t + motor_h;            // their bodies' backs
y_cp = [y_mb + 0.5, y_mb + 0.5 + cp[1]];              // the coupler's disc
y_rp = [y_cp[1] + 0.5, y_cp[1] + 0.5 + back_t];       // rear plate
y_csh = y_rp[1] - shaft_len;                          // C's shaft's end
y_kr = [y_rp[1] + motor_flange_t + motor_h + 1, y_rp[1] + motor_flange_t + motor_h + 1 + car_t];   // carrier
y_pm = y_bp[1] + pot_boss;                            // the pot's mounting face
y_pot_front = y_pm - pot_bush[1];                     // its bushing's front
y_ks = [-knob_gap - alt_knob[1] + 1, y_pot_front - 0.5];   // the knob's shaft
y_axle = [y_nd[0] + needle_skin, y_csh - 0.5];
y_tube = [y_nd[1], y_bp[0] + 2];
y_pin = [y_kd1 + 0.6, y_bp[0] + 3];
axle_len = y_axle[1] - y_axle[0];
tube_len = y_tube[1] - y_tube[0];
pin_len = y_pin[1] - y_pin[0];
ai_arm = [-inst_pitch.x + drive_a, 0];               // the attitude indicator's motor gear pocket, on its right
vsi_c = [0, -inst_pitch.y];                           // the VSI under it
uln_holes_a = [for (b = uln_xz, i = [0, 1], j = [0, 1])
   [b.x + uln_hole_in + i * (uln_board.x - 2 * uln_hole_in), b.y + uln_hole_in + j * (uln_board.y - 2 * uln_hole_in)]];
alt_depth = y_kr[1] + max(uln_standoff + uln_t + uln_parts, nano_under + nano_t + nano_usb[1]) - y_sheet1;
baro_span = k_baro * (baro_range[1] - baro_range[0]);
pot_span = pot_turns * 360 / k_ratio;                 // the disc's turn over the pot's 10 turns

echo(alt_depth = alt_depth, case_depth = y_bp[1] - y_sheet1, axle_len = axle_len, tube_len = tube_len, pin_len = pin_len,
     knob_ratio = k_ratio, baro_span = baro_span, pot_span = pot_span,
     knob_turns_per_inHg = k_baro * k_ratio / 360, steps_per_ft = [2038 / 1000, 2038 * z_ng / z_mg / 10000]);

// --- Checks ---
// the face
assert(num_r + num_size / 2 + 0.5 <= r_tick - tick_100[0], "Numerals run into the ticks");
// the 20 ft ticks next to 3 and 9 o'clock (3.6 degrees off), within the windows' height
let(t = pol(r_tick - tick_20[0], 90 - 3.6))
   assert(t.y <= win_h / 2 + win_line && t.x - tick_20[1] / 2 - 0.3 >= max(win_hg[1], win_hpa[1]) + win_line, "A Kollsman window runs into the ticks");
for (a = [72, 108, 252, 288]) assert(abs(pol(num_r, a).y) - num_size / 2 >= win_h / 2 + win_line + 0.5, "A numeral runs into a Kollsman window");
assert(win_hg[0] >= dhub_r + 1 && win_hg[0] >= ring_paper[0] + 0.5 && win_hpa[1] <= ring_paper[1] - 0.5, "Windows off the Kollsman ring");
assert(win_hg[1] + 0.3 <= win_hpa[0], "The inHg scale shows in the hPa window");
assert(baro_num_r >= win_hg[0] && baro_num_r + 0.78 * baro_num_size * 3.5 <= baro_tick[1][0] - 0.2 && baro_tick[0][1] <= win_hg[1] - 0.1,
       "inHg scale off its window");
assert(hpa_num_r <= win_hpa[1] - 0.1 && hpa_num_r - 0.78 * hpa_num_size * 4 >= hpa_tick[1][1] + 0.2 && hpa_tick[0][0] >= win_hpa[0] + 0.1,
       "hPa scale off its window");
assert(nd100[0] <= r_tick, "100 ft needle past the ticks");
assert(baro_span <= pot_span - 10 && baro_span <= 340, "Kollsman scale longer than the pot's turns or the disc");
// needles, tubes
assert(y_nd[0] >= y_glass1 + 1, "100 ft needle against the glass");
assert(nd_hub[1] / 2 - tube[0] / 2 >= 1.2, "1000 ft needle's hub too thin");
assert(axle[0] <= tube[1] - 0.05, "The axle does not slide into the tube");
assert(g_rf(z_ng, nm) - tube[0] / 2 >= 2, "Needle gear too small for the tube");
// gear layers: the idler and the knob's pinion in layer 1, B in layer 2
assert(y_msh <= y_l2[0] && y_msh + flat_len >= y_l2[1] - 0.5, "B's shaft (its flats) does not reach through its gear");
assert(mag_rm + magnet[0] / 2 + 0.5 <= g_rf(z_mg, nm) && mag_rm - magnet[0] / 2 >= shaft_d / 2 + 1.2, "Magnet does not fit a motor gear");
assert(gw - magnet[1] - 0.1 >= 1.2, "Magnet pocket too deep for its gear");
assert(a_drive + g_ra(z_mg, nm) + 1 <= bore_d / 2, "Motor gear runs into the case");
for (p = kp_xz) {
   assert(norm(p) - kp_d / 2 >= g_ra(z_ng, nm) + 1.5, "A keeper leg runs into a needle gear");
   assert(norm(p - mB[0]) >= g_ra(z_mg, nm) + kp_d / 2 + 1, "A keeper leg runs into B's gear");
   assert(norm(p - idler_c) >= ra_k[1] + kp_d / 2 + 1, "A keeper leg runs into the idler");
   for (e = m_ears(mB)) assert(norm(p - e) >= kpin[0] / 2 + csk_d / 2 + 1, "A keeper leg's pin on a motor ear's screw");
}
assert(norm(idler_c - mB[0]) >= ra_k[1] + shaft_d / 2 + 1 && norm(idler_c - mB[0]) >= g_ra(z_mg, nm) + 3, "Idler runs into B's gear or shaft");
assert(norm(idler_c) - ra_k[1] >= g_ra(z_ng, nm) + 1, "Idler runs into the needle gear");
assert(norm(idler_c) - ra_k[2] >= keep_r + 1, "Idler pinion runs into the keeper");
assert(norm(knob_c - mB[0]) >= g_ra(z_mg, nm) + pot_nut[0] / cos(30) / 2 + 1, "Pot's nut runs into B's gear");
assert(norm(knob_c - idler_c) >= pot_nut[0] / cos(30) / 2 + 1.5 + 1, "Pot's nut runs into the idler's pin");
assert(g_rf(z_k[0], km) - (pot_shaft[0] + 0.1) / 2 >= 1.2, "Knob pinion too small for the pot's shaft");
assert(g_rf(z_k[2], km) - (axle[0] + run_c) / 2 >= 1.5, "Idler pinion too small for its pin");
assert(ks_sleeve / 2 <= norm(knob_c - idler_c) - ra_k[2] - 1, "Knob shaft's sleeve runs into the idler's pinion");
assert(kd_ro <= bore_d / 2 - 0.4, "Kollsman disc runs into the case");
assert(norm(idler_c) + ra_k[2] + 0.1 <= R4 + km, "Idler pinion hits the ring's roots");
assert(y_ks[0] + 1 <= -knob_gap && y_pot_front - pot_shaft[1] + pot_bush[1] < y_l1[0], "Knob shaft");
assert(y_pot_front >= y_l1[1] + 1 && y_bp[0] - pot_nut[1] >= y_pot_front, "Pot's bushing runs into the knob's pinion or its nut does not fit");
assert(y_pm - pot_shaft[1] >= y_sheet1 && y_pm - pot_shaft[1] <= y_l1[0] - 2, "Pot's shaft does not reach through the knob's pinion");
// back: motors, sensors, pot, coupler, posts
for (m = [mB]) {
   assert(norm(m_body(m)) >= motor_d / 2 + axle[0] / 2 + 2, "A motor's body over the axle");
   for (e = m_ears(m)) assert(norm(e) >= nut[0] / cos(30) / 2 + axle[0] / 2 + 1.5, "A motor's ear nut on the axle");
}
assert(norm(snsB - m_body(mB)) + sensor.z / 2 >= motor_d / 2 + 1.5, "Sensor B's legs (out of the far end) run into B");
assert(norm(snsC - m_body(mC)) + sensor.z / 2 >= motor_d / 2 + 1.5, "Sensor C's legs (out of the far end) run into C");
assert(cp[0] - mag_rm - magnet[0] / 2 >= 0.8 && cp[1] - magnet[1] - 0.1 >= 1.2, "Coupler too small for its magnet");
assert(y_csh >= y_cp[0] - cp[3] + 3.5 && y_cp[1] - y_csh >= flat_len - 0.5, "C's shaft (its flats) does not reach through the coupler, or leaves the axle no room");
assert(norm(m_body(mB)) - motor_d / 2 >= cp[2] / 2 + 1, "Coupler's hub runs into B");
assert(norm(knob_c - m_body(mB)) >= pot_body[0] / 2 + motor_d / 2 + 1, "Pot runs into B");
for (p = bp_posts) {
   for (m = [mB]) {
      assert(norm(p - m_body(m)) >= motor_d / 2 + car_post_d / 2 + 0.9, "A back plate post runs into a motor");
      for (e = m_ears(m)) assert(norm(p - e) >= motor_ear_w / 2 + car_post_d / 2 + 0.5, "A back plate post runs into a motor ear");
      assert(clear_cover(m, p, car_post_d / 2 + 0.5), "A back plate post runs into a motor's cover");
   }
   assert(norm(p - knob_c) >= pot_body[0] / 2 + car_post_d / 2 + 1, "A back plate post runs into the pot");
   assert(norm(p) + car_post_d / 2 <= rp_r, "A back plate post off the rear plate");
   // the rear plate's screws, flush in its back, under motor C's flange
   assert(norm(p - m_body(mC)) >= motor_d / 2 + csk_d / 2 + 0.5 && clear_cover(mC, p, csk_d / 2 + 0.5)
          && min([for (e = m_ears(mC)) norm(p - e)]) >= motor_ear_w / 2 + csk_d / 2 + 0.5, "A rear plate screw under motor C");
}
for (p = rp_posts) {
   assert(norm(p - m_body(mC)) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into motor C");
   for (e = m_ears(mC)) assert(norm(p - e) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into C's ear");
   assert(clear_cover(mC, p, car_post_d / 2 + 0.5), "A carrier post runs into C's cover");
   assert(norm(p) + car_post_d / 2 <= rp_r, "A carrier post off the rear plate");
   assert(min([for (q = bp_posts) norm(p - q)]) >= car_post_d / 2 + csk_d / 2 + 0.5, "A carrier post on a rear plate screw");
   assert(min([for (h = uln_holes_a) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
   assert(p.x + csk_d / 2 <= nano_xz.x - 1.7 || p.x - csk_d / 2 >= nano_xz.x + nano_board.x + 1.7
          || p.y + csk_d / 2 <= nano_xz.y - 1.7 || p.y - csk_d / 2 >= nano_xz.y + nano_board.y + 1.7, "A carrier screw under the Nano's rails");
   assert(p.x - car_post_d / 2 >= car_box[0] && p.x + car_post_d / 2 <= car_box[2] && p.y - car_post_d / 2 >= car_box[1]
          && p.y + car_post_d / 2 <= car_box[3], "A carrier post off the carrier");
}
for (i = [0 : len(uln_xz) - 1]) let(b = uln_xz[i]) {
   assert(b.x >= car_box[0] + 1 && b.x + uln_board.x <= car_box[2] - 1 && b.y >= car_box[1] + 1 && b.y + uln_board.y <= car_box[3] - 1,
          "ULN2003 board off the carrier");
   for (j = [0 : len(uln_xz) - 1]) if (j > i) let(c = uln_xz[j])
      assert(abs(b.x - c.x) >= uln_board.x + 2 || abs(b.y - c.y) >= uln_board.y + 2, "ULN2003 boards overlap");
   assert(b.x >= nano_xz.x + nano_board.x + 2 || b.x + uln_board.x + 2 <= alt_nano_c.x - nano_rail_hw
          || b.y >= nano_xz.y + nano_board.y + 2 || b.y + uln_board.y + 2 <= nano_xz.y, "A ULN2003 board over the Nano");
}
assert(alt_nano_c.x - nano_rail_hw - 0.5 >= car_box[0] && alt_nano_c.x + nano_rail_hw + 0.5 <= car_box[2]
       && nano_xz.y - 1 >= car_box[1] && nano_xz.y + nano_board.y + 2 <= car_box[3], "Nano off the carrier");
// the neighbours: the attitude indicator on the left (its case and motor gear pocket, as deep as this),
// the VSI under it (the standard, its case and ears; only the case and the back plate are as far forward)
left_parts = concat([for (e = m_ears(mB)) [e, motor_ear_w / 2 + 1.5]], [[knob_c, pot_boss_r], [knob_c, ks_boss],
                           [idler_c, ki_boss], [[0, 0], rp_r]], [for (p = bp_posts) [p, car_post_d / 2]]);
for (p = left_parts)
   assert(norm(p[0] - ai_arm) >= arm_r + p[1] + 1 && norm(p[0] - [-inst_pitch.x, 0]) >= case_r + p[1] + 1, "Runs into the attitude indicator");
assert(car_box[0] >= -inst_pitch.x + 39 + 2, "Carrier runs into the attitude indicator's carrier");
for (p = [[knob_c, pot_boss_r], [knob_c, ks_boss], [idler_c, ki_boss], [knob_c, pot_body[0] / 2]]) {
   assert(norm(p[0] - vsi_c) >= case_r + p[1] + 1, "Runs into the VSI's case");
   for (c = [for (i = [0 : 3]) cols[i] + vsi_c]) assert(norm(p[0] - c) >= ear_d / 2 + p[1] + 1, "Runs into a VSI ear");
}
assert(norm(knob_c) - alt_knob[0] / 2 >= cut_d / 2 - 6, "Knob over the window");
assert(abs(knob_c.x) + alt_knob[0] / 2 + 1 <= inst_pitch.x - 86 / 2, "Knob runs into the attitude indicator's bezel");
for (i = [0, 1, 3]) assert(norm(knob_c - cols[i]) >= alt_knob[0] / 2 + head_d / 2 + 2, "Knob over a case screw");

// --- Helpers ---
module along_xz(p, y0, y1) {
   along_y(y0, y1) translate(p) children();
}

module motor_at(m, yf) {
   translate([m[0].x, yf, m[0].y]) rotate([0, atan2(m[1].x, m[1].y), 0]) rotate([90, 0, 0]) motor_local();
}

// internal ring gear, teeth inward, out to radius ro
module ring_gear_2d(z, m, ro) {
   difference() {
      circle(r = ro, $fn = 4 * z);
      gear_2d(z, m, -gear_play);
      circle(r = m * z / 2 - m, $fn = 4 * z);
   }
}

module win_2d(d = 0) {
   translate([win_hg[0] - d, -win_h / 2 - d]) square([win_hg[1] - win_hg[0] + 2 * d, win_h + 2 * d]);
   translate([-win_hpa[1] - d, -win_h / 2 - d]) square([win_hpa[1] - win_hpa[0] + 2 * d, win_h + 2 * d]);
}

// sensor: flat face towards -y at y, legs out along z (s: up or down) to the back
module sensor_pocket(p, y, s, depth = back_t) {
   translate([p.x - sensor.x / 2 - 0.15, y - 0.01, p.y - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
   translate([p.x - sensor.x / 2 - 0.15, y - 1, s > 0 ? p.y + sensor.z / 2 - 1 : p.y - sensor.z / 2 - 1.5]) cube([sensor.x + 0.3, depth + 2, 2.5]);
}

// --- Outlines, x right, z up ---
module alt_case_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (i = [0, 1, 3]) translate(cols[i]) circle(d = ear_d);
      translate(knob_c) circle(r = ks_boss);
      translate(idler_c) circle(r = ki_boss);
   }
}

module alt_back_outline() {
   alt_case_outline();
   hull() {
      circle(d = case_d, $fn = 180);
      translate(knob_c) circle(r = pot_boss_r);
   }
   for (e = m_ears(mB)) hull() {
      circle(d = case_d - 10, $fn = 180);
      translate(e) circle(d = motor_ear_w + 3);
   }
}

// --- Case: the standard's front, three screws, the knob's train in a pocket down left ---
module alt_case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_bp[0]) alt_case_outline();
      }
      along_y(-1, y_glass0 + 0.01) circle(d = window_d, $fn = 180);
      along_y(y_glass0, y_bp[0] + 1) circle(d = bore_d, $fn = 180);
      // the idler's gear and the knob's pinion, open to the sheet (no bridge, printed back side down)
      along_y(y_sheet1 - 0.01, y_bp[0] + 1) hull() {
         translate(idler_c) circle(r = ra_k[1] + 1);
         translate(knob_c) circle(r = ra_k[0] + 1);
      }
      for (i = [0, 1, 3]) {
         c = cols[i];
         translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
         translate([c.x, y_bp[0] + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
      }
   }
}

// --- Spacer ring: the glass against the lip ---
module alt_spacer() {
   along_y(y_glass1, y_dl0) difference() {
      circle(d = rim_od, $fn = 180);
      circle(d = rim_id, $fn = 180);
   }
}

// --- Dial: flat, the two windows, the hub on its back (the disc on it), pins into the keeper ---
module alt_dial() {
   difference() {
      union() {
         along_y(y_dl0, y_dl1) circle(d = rim_od, $fn = 180);
         along_y(y_dl1 - 0.01, y_hb) circle(r = dhub_r, $fn = 120);
         for (p = kp_xz) along_xz(p, y_hb - 0.01, y_hb + kpin[1]) circle(d = kpin[0]);
      }
      along_y(y_dl0 - 1, y_hb + 1) circle(d = tube[0] + run_c);
      along_y(y_dl0 - 1, y_dl1 + 0.01) win_2d();
   }
}

// --- Kollsman disc: the plate (paper ring on its front), the internal ring behind it; a: clockwise ---
module alt_disc(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_kd0, y_kd1) circle(r = kd_ro, $fn = 180);
         along_y(y_kd1 - 0.01, y_kd2) ring_gear_2d(z_k[3], km, kd_ro);
      }
      along_y(y_kd0 - 1, y_kd2 + 1) circle(r = dhub_r + 0.3, $fn = 120);
   }
}

// --- Keeper: holds the disc, its legs press the dial forward ---
module alt_keeper() {
   difference() {
      union() {
         along_y(y_hb, y_kd2) circle(r = keep_r, $fn = 120);
         for (p = kp_xz) {
            along_xz(p, y_kd2 - 0.01, y_bp[0]) circle(d = kp_d);
            along_xz(p, y_bp[0] - 0.01, y_bp[0] + kpin[1]) circle(d = kpin[0]);
         }
      }
      along_y(y_hb - 1, y_kd2 + 1) circle(d = tube[0] + run_c);
      for (p = kp_xz) along_xz(p, y_hb - 0.01, y_hb + kpin[1] + 0.3) circle(d = kpin[0] + 0.3);
   }
}

// --- Needles: 2D, x right, y up (pointing at 12 o'clock) ---
module alt_needle_2d(i) {
   if (i == 0) {
      hull() {
         circle(d = nd_hub[0]);
         translate([0, nd100[0] - nd100[3] / 2]) circle(d = nd100[3]);
      }
      hull() {
         translate([-nd100[2] / 2, -nd100[1]]) square([nd100[2], 1]);
         circle(d = nd100[2]);
      }
   } else {
      circle(d = nd_hub[1]);
      w = nd1000[2];
      polygon([[-w / 2, -4], [w / 2, -4], [w * 0.45, nd1000[1]], [0, nd1000[0]], [-w * 0.45, nd1000[1]]]);
   }
}

// needle i (0: 100 ft, 1: 1000 ft) at a (clockwise from 12 o'clock)
module alt_needle(i, a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_nd[i], y_nd[i] + nd_t) alt_needle_2d(i);
         along_y(y_nd[i] + nd_t - 0.01, y_nd[i] + nd_t + nd_hub_h) circle(d = nd_hub[i]);
      }
      if (i == 0) along_y(y_axle[0], y_nd[0] + nd_t + nd_hub_h + 1) circle(d = axle[0] - press_c);
      else along_y(y_nd[i] - 1, y_nd[i] + nd_t + nd_hub_h + 1) circle(d = tube[0] - press_c);
   }
}

// --- Gears ---
// the 1000 ft needle's, in layer 2 on the tube
module alt_needle_gear(a = 0) {
   rotate([0, a, 0]) difference() {
      along_y(y_l2[0], y_l2[1]) gear_2d(z_ng, nm);
      along_y(y_l2[0] - 1, y_l2[1] + 1) circle(d = tube[0] - press_c);
   }
}

// motor B's, in layer 2, the magnet in its back
module alt_motor_gear(a = 0) {
   translate([mB[0].x, 0, mB[0].y]) rotate([0, a, 0]) difference() {
      along_y(y_l2[0], y_l2[1]) rotate(180 / z_mg) gear_2d(z_mg, nm);
      translate([0, y_l2[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, gw + 2);
      mp = snsB - mB[0];
      translate([mp.x, y_l2[1] + 0.01, mp.y]) rotate([90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

// the coupler: motor C's shaft to the axle, the magnet in its back
module alt_coupler(a = 0) {
   rotate([0, a, 0]) difference() {
      union() {
         along_y(y_cp[0], y_cp[1]) circle(r = cp[0]);
         along_y(y_cp[0] - cp[3], y_cp[0] + 0.01) circle(d = cp[2]);
      }
      translate([0, y_cp[1] + 0.01, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y_cp[1] - y_csh + 0.3);
      along_y(y_cp[0] - cp[3] - 1, y_csh - 0.5) circle(d = axle[0] - press_c);
      translate([snsC.x, y_cp[1] + 0.01, snsC.y]) rotate([90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

// the idler: its pinion (in the disc's ring) and its gear (layer 1, the knob's pinion); a: clockwise
module alt_idler(a = 0) {
   translate([idler_c.x, 0, idler_c.y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_kd1 + 0.3, y_kd2 + 0.01) gear_2d(z_k[2], km);
         along_y(y_kd2, y_l1[0] + 0.01) circle(r = g_rf(z_k[2], km));
         along_y(y_l1[0], y_l1[1]) gear_2d(z_k[1], km);
      }
      along_y(y_kd1, y_l1[1] + 1) circle(d = axle[0] + run_c);
   }
}

// the knob's shaft: its pinion (layer 1) on a sleeve over the pot's shaft, a printed shaft forward through the sheet
module alt_knob_shaft(a = 0) {
   y_end = y_pm - pot_shaft[1];
   translate([knob_c.x, 0, knob_c.y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_ks[0], y_end + 0.01) difference() {
            circle(d = ks_d);
            translate([-ks_d / 2, ks_d / 2 - 0.6]) square([ks_d, 1]);   // a flat for the knob
         }
         along_y(y_end, y_ks[1]) circle(d = ks_sleeve);
         along_y(y_l1[0], y_l1[1]) rotate(180 / z_k[0]) gear_2d(z_k[0], km);
      }
      along_y(y_end - 0.01, y_ks[1] + 1) circle(d = pot_shaft[0] + press_c);
   }
}

module alt_knob(a = 0) {
   y0 = -knob_gap - alt_knob[1];
   translate([knob_c.x, 0, knob_c.y]) rotate([0, a, 0]) difference() {
      along_y(y0, -knob_gap) circle(d = alt_knob[0], $fn = 60);
      for (k = [0 : 20 : 340]) rotate([0, k, 0]) translate([alt_knob[0] / 2, y0 - 1, 0]) rotate([-90, 0, 0])
         cylinder(d = alt_knob[2] * 1.6, h = alt_knob[1] + 2, $fn = 12);
      along_y(y_ks[0] - 0.3, -knob_gap + 1) difference() {
         circle(d = ks_d + 0.2);
         translate([-ks_d / 2, ks_d / 2 - 0.5]) square([ks_d, 1]);
      }
   }
}

// --- Back plate: motors A and B, the pot, sensor B, the bearings; its posts to the rear plate on its back ---
module alt_back_plate() {
   difference() {
      union() {
         along_y(y_bp[0], y_bp[1]) alt_back_outline();
         along_xz(knob_c, y_bp[1] - 0.01, y_pm) circle(r = pot_boss_r);
         for (p = bp_posts) along_xz(p, y_bp[1] - 0.01, y_rp[0]) circle(d = car_post_d);
      }
      for (i = [0, 1, 3]) translate([cols[i].x, y_bp[1], cols[i].y]) rotate([-90, 0, 0]) csk_hole();
      // the middle tube's bearing, the axle through
      along_y(y_bp[0] - 1, y_tube[1] + 0.3) circle(d = tube[0] + run_c);
      along_y(y_bp[0], y_bp[1] + 1) circle(d = axle[0] + 2 * run_c);
      // motors A and B: their bosses, the ears (countersunk from the front, nuts behind the ears)
      for (m = [mB]) {
         translate([m[0].x, y_bp[0] - 1, m[0].y]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
         for (e = m_ears(m)) translate([e.x, y_bp[0], e.y]) rotate([90, 0, 0]) csk_hole();
      }
      sensor_pocket(snsB, y_bp[0], -1);
      // the keeper's legs' pins, sensor A's wires
      for (p = kp_xz) along_xz(p, y_bp[0] - 0.01, y_bp[0] + kpin[1] + 0.3) circle(d = kpin[0] - 0.1);
      // the idler's pin, pressed in
      along_xz(idler_c, y_bp[0] - 0.01, y_pin[1]) circle(d = axle[0] - press_c);
      // the pot's bushing
      along_xz(knob_c, y_bp[0] - 1, y_pm + 1) circle(d = pot_bush[0] + 0.4);
      for (p = bp_posts) translate([p.x, y_rp[0] + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
   }
}

// --- Rear plate: motor C, sensor C; its posts to the carrier on its back ---
module alt_rear_plate() {
   difference() {
      union() {
         along_y(y_rp[0], y_rp[1]) circle(r = rp_r, $fn = 180);
         for (p = rp_posts) along_xz(p, y_rp[1] - 0.01, y_kr[0]) circle(d = car_post_d);
      }
      for (p = bp_posts) translate([p.x, y_rp[1], p.y]) rotate([-90, 0, 0]) csk_hole();
      translate([mC[0].x, y_rp[0] - 1, mC[0].y]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
      for (e = m_ears(mC)) translate([e.x, y_rp[0], e.y]) rotate([90, 0, 0]) csk_hole();
      sensor_pocket(snsC, y_rp[0], -1);
      for (p = rp_posts) translate([p.x, y_kr[0] + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - car_t + 1);
   }
}

// --- Board carrier: the two ULN2003 boards and the Nano behind it (facing back) ---
module alt_carrier() {
   y1 = y_kr[1];
   difference() {
      union() {
         along_y(y_kr[0], y1) translate([car_box[0], car_box[1]]) square([car_box[2] - car_box[0], car_box[3] - car_box[1]]);
         for (h = uln_holes_a) along_xz(h, y1 - 0.01, y1 + uln_standoff) circle(d = uln_standoff_d);
         // Nano rails along z (lib/nano.inc.scad), a stop at the top end
         on_board_plate(alt_nano_c, y1, "down")
            nano_rails(y1 = nano_board.y / 2 + 1, far_stop = true);
      }
      for (h = uln_holes_a) along_xz(h, y1 - 1, y1 + uln_standoff + 1) circle(d = pilot_d);
      for (p = rp_posts) translate([p.x, y1, p.y]) rotate([-90, 0, 0]) csk_hole();
   }
}

// --- Face, 2D: x right, y up, the axis at the origin ---
module alt_face_2d() {
   ink(c_black) circle(d = face_d, $fn = 180);
   ink(c_white) {
      for (i = [0 : 49]) {
         t = i % 5 == 0 ? tick_100 : tick_20;
         tick_2d(i * 7.2, r_tick - t[0], r_tick, t[1]);
      }
      for (i = [0 : 9]) translate(pol(num_r, i * 36))
         text(str(i), size = num_size, font = font, halign = "center", valign = "center");
      translate([0, 16]) text("100 FEET", size = label_size, font = font, halign = "center", valign = "center");
      translate([0, -12.5]) text("1000 FEET", size = label_size, font = font, halign = "center", valign = "center");
      translate([0, -16.8]) text("CALIBRATED TO", size = small_size, font = font, halign = "center", valign = "center");
      translate([0, -19.3]) text("20,000 FEET", size = small_size, font = font, halign = "center", valign = "center");
      // the windows' lines
      difference() {
         win_2d(win_line);
         win_2d();
      }
      // the indexes at the ticks' side: inHg's outside, hPa's inside
      polygon([[win_hg[1] + 2.4, 1.3], [win_hg[1] + 2.4, -1.3], [win_hg[1], 0]]);
      polygon([[-win_hpa[0] + 2.4, 1.3], [-win_hpa[0] + 2.4, -1.3], [-win_hpa[0], 0]]);
      // the outer tube's hole, to punch
      circle(d = tube[0] + 0.3);
   }
}

// the Kollsman ring's paper (on the disc, at baro_std): inHg inside (shown at 3 o'clock), hPa outside (at 9 o'clock),
// the ticks at their indexes, the numbers upright in their windows
module alt_baro_2d() {
   ink(c_black) difference() {
      circle(r = ring_paper[1], $fn = 180);
      circle(r = ring_paper[0], $fn = 120);
   }
   ink(c_white) {
      for (h = [round(baro_range[0] * 100) : 2 : round(baro_range[1] * 100)]) {
         t = h % 10 == 0 ? baro_tick[1] : baro_tick[0];
         a = baro_a(h / 100);
         tick_2d(a, t[0], t[1], t[2]);
         if (h % 10 == 0) translate(pol(baro_num_r, a)) rotate(90 - a)
            text(str(floor(h / 100), ".", floor(h / 10) % 10), size = baro_num_size, font = font, halign = "left", valign = "center");
      }
      for (v = [ceil(baro_range[0] * hpa_per_inhg) : floor(baro_range[1] * hpa_per_inhg)]) {
         t = v % 5 == 0 ? hpa_tick[1] : hpa_tick[0];
         a = hpa_a(v);
         tick_2d(a, t[0], t[1], t[2]);
         if (v % 5 == 0) translate(pol(hpa_num_r, a)) rotate(270 - a)
            text(str(v), size = hpa_num_size, font = font, halign = "left", valign = "center");
      }
      difference() {
         circle(r = ring_paper[1] + 0.4, $fn = 180);
         circle(r = ring_paper[1], $fn = 180);
      }
   }
}

// the page: two faces, two Kollsman rings under them, the glass's template, the caption; registration dots in every layer
module alt_print() {
   step = face_d + print_gap;
   w = 2 * step + glass_d;
   ring_y = -face_d / 2 - print_gap - ring_paper[1];
   for (i = [0, 1]) {
      translate([i * step, 0]) alt_face_2d();
      translate([i * step, ring_y]) alt_baro_2d();
   }
   ink(c_black) {
      translate([2 * step + glass_d / 2 - face_d / 2, 0]) difference() {
         circle(d = glass_d + 0.6, $fn = 180);
         circle(d = glass_d, $fn = 180);
      }
      lines = [str("ALT: face ", face_d, " mm, cut on its edge;"),
               "window and hole: cut on the",
               "white lines' inside. Kollsman",
               str("ring ", 2 * ring_paper[1], " mm: cut on its edges."),
               str("Glass ", glass_d, " mm: cut on the"),
               "line's inside. Print at 100 %."];
      for (i = [0 : len(lines) - 1]) translate([step + ring_paper[1] + 8, ring_y + 15 - 6 * i]) text(lines[i], size = 3, font = font);
   }
   for (x = [-face_d / 2 - 2, w - face_d / 2 + 2], y = [ring_y - ring_paper[1] - 2, glass_d / 2 + 2]) translate([x, y]) square(0.1, center = true);
}

// --- View only ---
c_brass = "#c9a227";

module alt_face_part() {
   for (i = [0 : len(face_colors) - 1])
      color(face_colors[i]) translate([0, y_fc - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = face_colors[i])
         difference() {
            alt_face_2d();
            win_2d();          // cut out
         }
}

module alt_baro_part(a) {
   rotate([0, a, 0]) for (i = [0 : len(face_colors) - 1])
      color(face_colors[i]) translate([0, y_kd0 - 0.02 - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = face_colors[i])
         difference() {
            alt_baro_2d();
            circle(r = ring_paper[0] - 1);
         }
}

module pot_part() {
   color("#2a5db0") along_xz(knob_c, y_pm, y_pm + pot_body[1]) circle(d = pot_body[0]);
   color(c_steel) {
      along_xz(knob_c, y_pot_front, y_pm) circle(d = pot_bush[0]);
      along_xz(knob_c, y_bp[0] - pot_nut[1], y_bp[0]) circle(d = pot_nut[0] / cos(30), $fn = 6);
      along_xz(knob_c, y_pm - pot_shaft[1], y_pot_front) circle(d = pot_shaft[0]);
   }
}

module alt_boards_part() {
   for (b = uln_xz) on_board_plate(b + uln_board / 2, y_kr[1], "up") uln_part();
   on_board_plate(alt_nano_c, y_kr[1], "down") nano_part(c_board);
}

module alt_shafts_part() {
   color(c_steel) along_y(y_axle[0], y_axle[1]) circle(d = axle[0]);
   color(c_steel) along_xz(idler_c, y_pin[0], y_pin[1]) circle(d = axle[0]);
   color(c_brass) along_y(y_tube[0], y_tube[1]) difference() {
      circle(d = tube[0]);
      circle(d = tube[1]);
   }
}

module alt_magnets_part(a100, mgb) {
   color(c_magnet) {
      rotate([0, a100, 0]) translate([snsC.x, y_cp[1], snsC.y]) rotate([90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
      translate([mB[0].x, 0, mB[0].y]) rotate([0, mgb, 0]) translate([snsB.x - mB[0].x, y_l2[1], snsB.y - mB[0].y]) rotate([90, 0, 0])
         cylinder(d = magnet[0], h = magnet[1]);
   }
}

// a piece of the sheet round the hole, the screws and the knob's hole
module alt_sheet_part(w = 150, h = 120, x0 = -75) {
   color(c_sheet) along_y(0, sheet_t) difference() {
      translate([x0, -h / 2]) square([w, h]);
      circle(d = cut_d, $fn = 180);
      for (i = [0, 1, 3]) translate(cols[i]) circle(d = clear_d);
      translate(knob_c) circle(d = ks_d + 1);
   }
   color("#111111") for (i = [0, 1, 3]) translate([cols[i].x, 0, cols[i].y]) rotate([90, 0, 0]) cylinder(d = head_d, h = 1.65);
}

// all parts at ft feet and the setting b (inHg); e: apart by this
module alt_parts(ft = view_ft, b = view_baro, e = 0, with_case = true) {
   a = [ft * 360 / 1000, ft * 360 / 10000];
   ad = -k_baro * (b - baro_std);                    // the disc, clockwise
   ak = -ad * k_ratio;                               // the knob
   mgb = -a[1] * z_ng / z_mg;
   color("#45484d") translate([0, -1.6 * e, 0]) render() alt_knob(ak);
   for (i = [0 : 1]) color(c_needle) render() alt_needle(i, a[i]);
   translate([0, 0.6 * e, 0]) {
      color(c_case) render() alt_dial();
      alt_face_part();
   }
   translate([0, 1.1 * e, 0]) {
      color(c_case) render() alt_disc(ad);
      alt_baro_part(ad);
   }
   translate([0, 1.6 * e, 0]) {
      color(c_case) render() alt_keeper();
   }
   translate([0, 2.2 * e, 0]) {
      color(c_case) render() alt_needle_gear(a[1]);
      color(c_case) render() alt_motor_gear(mgb);
      color(c_case) render() alt_idler(-ak * z_k[0] / z_k[1]);
      color(c_case) render() alt_knob_shaft(ak);
      alt_shafts_part();
      alt_magnets_part(a[0], mgb);
      color(c_case) render() alt_coupler(a[0]);
   }
   translate([0, 3 * e, 0]) {
      color(c_case) render() alt_back_plate();
      motor_at(mB, y_bp[1]);
      pot_part();
      color("#202020") translate([snsB.x - sensor.x / 2, y_bp[0], snsB.y - sensor.z / 2]) cube(sensor);
   }
   translate([0, 3.8 * e, 0]) {
      color(c_case) render() alt_rear_plate();
      motor_at(mC, y_rp[1]);
      color("#202020") translate([snsC.x - sensor.x / 2, y_rp[0], snsC.y - sensor.z / 2]) cube(sensor);
   }
   translate([0, 4.6 * e, 0]) {
      color(c_case) alt_carrier();
      alt_boards_part();
   }
   if (with_case) translate([0, -e, 0]) {
      color(c_case) render() alt_case();
      color(c_case) alt_spacer();
      color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
   }
}

module assembled_view() {
   alt_sheet_part();
   alt_parts();
}

module exploded_view() {
   alt_parts(e = explode);
}

module inside_view() {
   alt_parts(with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) {
      alt_face_2d();
   }
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_bp[0]]) rotate([-90, 0, 0]) alt_case(); // Make module case
translate([0, 0, -y_glass1]) rotate([90, 0, 0]) alt_spacer(); // Make module spacer
translate([0, 0, -y_dl0]) rotate([90, 0, 0]) alt_dial(); // Make module dial
translate([0, 0, -y_kd0]) rotate([90, 0, 0]) alt_disc(); // Make module disc
translate([0, 0, -y_hb]) rotate([90, 0, 0]) alt_keeper(); // Make module keeper
translate([0, 0, y_l1[1]]) rotate([-90, 0, 0]) translate([-idler_c.x, 0, -idler_c.y]) alt_idler(); // Make module idler
translate([0, 0, y_ks[1]]) rotate([-90, 0, 0]) translate([-knob_c.x, 0, -knob_c.y]) alt_knob_shaft(); // Make module knob_shaft
translate([0, 0, knob_gap + alt_knob[1]]) rotate([90, 0, 0]) translate([-knob_c.x, 0, -knob_c.y]) alt_knob(); // Make module knob
translate([0, 0, -y_nd[0]]) rotate([90, 0, 0]) alt_needle(0); // Make module needle_100
translate([0, 0, -y_nd[1]]) rotate([90, 0, 0]) alt_needle(1); // Make module needle_1000
translate([0, 0, -y_l2[0]]) rotate([90, 0, 0]) alt_needle_gear(); // Make module needle_gear
translate([0, 0, -y_l2[0]]) rotate([90, 0, 0]) translate([-mB[0].x, 0, -mB[0].y]) alt_motor_gear(); // Make module motor_gear
translate([0, 0, y_cp[1]]) rotate([-90, 0, 0]) alt_coupler(); // Make module coupler
translate([0, 0, -y_bp[0]]) rotate([90, 0, 0]) alt_back_plate(); // Make module back
translate([0, 0, -y_rp[0]]) rotate([90, 0, 0]) alt_rear_plate(); // Make module rear
translate([0, 0, -y_kr[0]]) rotate([90, 0, 0]) alt_carrier(); // Make module carrier

alt_print(); // Make print face black,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
