// NAV indicator (VOR CDI) on a stepper and a servo
//
// The NAV indicators (course deviation indicators) right of the six-pack (frame/), one print for both
// (each with its own Nano, their MobiFlight setups differ only in the
// datarefs). Like the 172N's VOR indicators, without the glideslope: the
// standard instrument's case front (instrument.inc.scad: the hole, the
// lip, the glass, three screws; the lower left one is the knob's place),
// the OBS knob at the lower left.
//
// What you see, front to back:
// - two white indexes on the lip, at the top (the course) and the
//   bottom (its reciprocal), painted with a paint pen;
// - the azimuth card: a ring round the window, 0 to 33 every 30 degrees,
//   a tick every 5; the course is under the top index;
// - the needle, hanging from a pivot at the top (hidden behind the
//   card), swinging left and right over the face: 5 dots each side,
//   2 degrees a dot, 10 degrees full scale;
// - the face, and in it right of the middle the TO / OFF / FROM window:
//   a white triangle up (TO), red and white stripes (OFF, no signal) or a
//   white triangle down (FROM).
//
// What moves:
// - The card is turned by the knob, mechanically: the knob's pinion
//   (36 teeth) meshes with the teeth round the card's band (120), 3.33
//   knob turns a card turn, clockwise raises the course. Behind the dial a
//   15 tooth gear on the knob's shaft turns a 50 tooth gear 1:1 with the
//   card, with a diametric magnet in its hub over an AS5600 magnetic
//   angle sensor: its analog output tells MobiFlight the course
//   absolutely, all round, no end stops (X-Plane's OBS is set from it,
//   nothing to keep in step). The card rides on a guide ring on the dial.
// - The needle is pressed onto a 3 mm steel axle at the pivot; a gear
//   sector on the axle (60 teeth on the full circle) is turned by a 28BYJ-48's pinion (15): the motor turns
//   4 times the needle's angle, so its gearbox's play shows a quarter as
//   much. A magnet in the sector passes a hall sensor in the back plate
//   with the needle in the middle: that is its home.
// - The flag is a printed sector on a 9 g servo (SG90): its three fields
//   (paper) show in the window at three servo angles, OFF in the middle.
//
// Layers, front to back: the glass, the card (its paper on the front
// plate, its toothed band behind it), the needle, the dial (the face
// glued on it; the spacer ring and the guide ring glued on its front),
// layer 1 (the flag; the knob's gear and the sensor gear), layer 2 (the
// sector and the motor's pinion; the AS5600 board), the back plate (the
// motor, the servo; posts to the carrier). The carrier holds the ULN2003
// board and the Arduino Nano (MobiFlight, its own USB cable), facing back.
// It is deeper than the standard (nav_depth echo; the frame checks it).
//
// Parts (printed): the case (back side down), the spacer ring and the
// guide ring (flat), the card (front down), the dial (front down), the
// needle (front down, white), the sector (front down), the motor's
// pinion, the knob's shaft (on its pinion's front), the knob's gear, the
// sensor gear (front down), the flag (front down), the back plate (front
// down), the carrier (front down), the knob (front down). Black but the
// needle.
//
// Parts to buy:
// - 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and a
//   mini USB cable, A3144 hall sensor, 2 x disc magnet 5 x 1 mm (stacked)
// - SG90 9 g servo with its screws (sv_*)
// - AS5600 magnetic angle sensor board with its diametric magnet 6 x 2.5
//   mm (as_*)
// - 3 mm steel dowel pin (the axle, axle_len echo)
// - clear sheet 1 mm (glass), the face, the card and the flag fields
//   printed on photo paper
// - M3 x 8 button head, black (3, through the sheet into the case),
//   M3 x 8 countersunk self tapping (3, back plate into the case; 4, the
//   carrier onto the back plate's posts), M3 x 8 countersunk + nut (2,
//   motor ears), M3 x 6 self tapping (4, ULN2003 board; 2, AS5600 board)
//
// Assembly: see the README.
//
// Coordinates as in instrument.inc.scad: x to the right, y away from the
// pilot, z up, the origin on the case's axis at the sheet's front face.

$fn = 60;

include <instrument.inc.scad>

// Preview: the needle's deflection (dots, right positive), the course, the flag (0: OFF, 1: TO, 2: FROM)
view_dots = 2;
view_obs = 30;
view_flag = 1;
explode = 25;

// --- Face (the dial, inside the card) ---
dots = 5;                    // each side
dot_dx = 4;                  // apart, along the row through the middle
dot_d = 1.6;
ctr_ring = [4.6, 0.5];       // the middle: a ring, diameter and line
win_c = [11, 7.5];           // the flag's window: middle [x, z], size
win = [7, 5.5];
win_line = 0.35;             // the white line round it (cut on its inside)

// --- Card ---
cd_r = [26, 36.9];           // the card's plate (its paper): inner, outer radius
cd_t = 1;
cd_tick_r = 36.5;            // the ticks' outer end (the window shows up to 36)
tick_5 = [2, 0.5];           // every 5 degrees: length, width
tick_10 = [3.4, 0.8];        // every 10 degrees
cd_num_r = 30.4;             // the numbers' middle
cd_num_size = 3.4;
cm = 0.6;                    // module of the card's train
z_card = 120;                // round the card's band
z_kp = 36;                   // the knob's pinion: 3.33 knob turns a card turn
cb_in = 34.1;                // the band's inside (on the guide ring)
idx = [1.6, 3.2];            // the lip's indexes: into the window, base

// --- Guide ring (on the dial's front, the card's band turns on it) ---
gr_r = [32.6, 33.8];
groove = 0.4;                // its groove in the dial

// --- Needle and its drive ---
pivot = [0, 29.5];           // the needle's axle
nd_len = 49;                 // the pivot to the tip
nd_w = [1.8, 1.2];           // at the hub, at the tip
nd_t = 0.8;
nd_hub = [5, 1];             // behind the blade: diameter, length
over = 3;                    // degrees past full scale it may go
sm = 0.8;                    // module of the sector and the pinion
z_sec = 60;                  // the sector's teeth on its full circle
z_mp = 15;                   // the motor's pinion
sec_extra = 2;               // teeth beyond the swing, each side
sec_hub = 8;
mag_sec = 17;                // the magnet in the sector, from the pivot (down)

// --- Flag: SG90 servo, MEASURE ---
sv_c = [25, 10];             // its shaft [x, z]
sv_dir = [0, -1];            // its body from the shaft
sv_body = [22.8, 12.2, 22.7];   // length, width, height (its top to its bottom)
sv_shaft_dx = 5.9;           // the shaft from the body's near end
sv_boss = [11.8, 4];         // the round boss on its top round the shaft: diameter, height
sv_bump = [6, 8];            // the small bump beside it: diameter, from the shaft (through the plate's slot)
sv_spline = [4.8, 3];        // the output spline: diameter, length
sv_spline_fit = 4.6;         // the flag's hole, pressed on (and its screw)
sv_tab = [32.3, 2.5, 4.5];   // the mounting tabs: length over both, thickness, the body's top to their top
sv_tab_hole = 27.8;          // their holes apart
sv_pilot = 1.8;              // the servo's own 2 mm screws
fl_step = 40;                // the fields apart (servo degrees)
fl_field = [8.5, 7];         // a field on the paper: across, along the radius
fl_t = 1.2;                  // the flag's plate (its paper on it)
fl_hub = 8;

// --- Course: AS5600 board and magnet, MEASURE ---
km = 0.8;                    // module of the sensor's train
z_kg = 15;                   // on the knob's shaft
z_sg = 50;                   // the sensor gear: 1:1 with the card (50 / 15 = 120 / 36)
sg_hub = [9, 2.5];           // the sensor gear's hub behind it (the magnet in it): diameter, length
sg_peg = 4;                  // the dial's peg it turns on
as_board = [23, 23];         // the AS5600 board, the chip in its middle
as_t = 1.6;
as_chip = 1.5;               // the chip and the parts on its front
as_gap = 1;                  // the magnet to the chip (0.5 to 3)
as_holes = [[-8.5, -8.5], [8.5, 8.5]];   // its holes from its middle (board coordinates)
as_hole_d = 3.2;
as_rot = 45;                 // the board turned (counter clockwise, seen from the front)
as_mag = [6, 2.5];           // the diametric magnet: diameter, height
as_slot = [14, 3];           // the wires' slot through the back plate, along the board's lower edge

// --- Knob ---
kn = [15, 9, 1.2];           // the knob: diameter, length, knurl depth
knob_gap = 0.5;              // to the sheet
ks_d = 6;                    // its spigot through the sheet (7 mm hole), into the knob's shaft
ks_rd = 5;                   // the knob's shaft behind its pinion
kp_hub = 10;                 // the pinion's hub forward to the sheet

// --- Dial posts (on the back plate, pins into the dial) ---
dp_r = 36.4;
dp_angles = [305, 180, 135]; // clockwise from 12 o'clock
dp_pin = [2, 1];

// --- Back: the motor, the posts, the boards ---
mount_play = 0.5;
car_posts = [[-30, 20], [22, 29], [28, -24], [-30, -20]];   // the back plate's (its back) to the carrier
uln_c = [-18, 15];           // the ULN2003 board's middle
nav_nano_c = [12, -10];      // the Nano's middle, along z, its USB jack down
car_box = [-37, -40, 41, 38];   // the carrier plate: x0, z0, x1, z1 (x0: right of the force feedback yoke's housing, the frame's nav_deep_x)

// --- Colours of the print (keep the print marker below the same) ---
c_black = "black";
c_red = "red";
c_white = "white";
face_colors = [c_black, c_red, c_white];

// --- Calculated ---
function rot2(p, a) = [p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a)];   // counter clockwise
function angdiff(a, b) = ((a - b) % 360 + 540) % 360 - 180;
function pol_a(d) = atan2(d.x, d.y);                  // the pol() angle of a direction
// a circle (p, r) clear of what turns about c within ro, at pol angles dir +- half
function sweep_clear(p, r, c, ro, dir, half, m = 0.5) = let(d = p - c)
   norm(d) >= ro + r + m || abs(angdiff(pol_a(d), dir)) >= half + asin(min(1, (r + m) / norm(d)));
// a circle (p, r) clear of a rectangle (its middle c, size s, turned by a)
function rect_clear(p, r, c, s, a, m = 0.5) = let(q = rot2(p - c, -a))
   norm([max(abs(q.x) - s.x / 2, 0), max(abs(q.y) - s.y / 2, 0)]) >= r + m;

full_x = dots * dot_dx;
function dev_a(d) = atan(d * dot_dx / pivot.y);        // the needle's angle (from down, right positive) at d dots
th_full = dev_a(dots);
th_max = th_full + over;
sec_ratio = z_sec / z_mp;
a_sec = sm * (z_sec + z_mp) / 2 + gear_play;
mp_c = pivot - [0, a_sec];                            // the motor's shaft
mA = [mp_c, [-1, 0]];                                 // its body to the left
sec_ra = g_ra(z_sec, sm);
sec_half = th_max + sec_extra * 360 / z_sec;          // the sector's teeth, each side of down
home_c = pivot - [0, mag_sec];                        // the magnet at home (the needle in the middle), the sensor

k_dir = [cos(225), sin(225)];                         // the knob: down left
knob_c = (cm * (z_card + z_kp) / 2 + gear_play) * k_dir;
sg_c = knob_c - (km * (z_kg + z_sg) / 2 + gear_play) * k_dir;
k_ratio = z_card / z_kp;
ra_kp = g_ra(z_kp, cm);
ra_kg = g_ra(z_kg, km);
ra_sg = g_ra(z_sg, km);
kp_boss = ra_kp + 1 + wall;                           // the case round the knob's pinion

d_win = win_c - sv_c;
fl_rf = norm(d_win);                                  // the fields' middles from the servo's shaft
aw = pol_a(d_win);                                    // the window's direction from it
fl_fh = atan((fl_field.x / 2 + 0.5) / (fl_rf - fl_field.y / 2));   // a field's half angle
fl_span = fl_step + fl_fh;                            // the flag's half angle
fl_ro = fl_rf + fl_field.y / 2 + 0.5;
fl_sweep = fl_span + fl_step;
function flag_a(f) = f == 1 ? -fl_step : f == 2 ? fl_step : 0;   // clockwise: TO, FROM, OFF
sv_body_c = sv_c + (sv_body[0] / 2 - sv_shaft_dx) * sv_dir;
sv_tab_holes = [for (s = [-1, 1]) sv_body_c + s * sv_tab_hole / 2 * sv_dir];
dp_xz = [for (a = dp_angles) pol(dp_r, a)];
as_hole_xz = [for (h = as_holes) sg_c + rot2(h, as_rot)];
as_slot_c = sg_c + rot2([0, -as_board.y / 2 + as_slot[1] / 2 + 0.5], as_rot);
uln_holes_c = [for (h = uln_hole_xy) uln_c + h];

// y, front to back
y_cp = y_glass1 + 0.5;                                // the card's paper
y_cd = [y_cp + paper_t, y_cp + paper_t + cd_t];       // its plate
y_nd = [y_cd[1] + 0.4, y_cd[1] + 0.4 + nd_t];         // the needle's blade
y_fc = y_nd[1] + nd_hub[1] + 0.4;                     // the face's paper
y_dl = [y_fc + paper_t, y_fc + paper_t + dial_t];     // the dial
y_cb1 = y_dl[0] - 0.5;                                // the card's band ends
y_kp = [y_cd[1] + 0.2, y_cb1];                        // the knob's pinion
y_gr = [y_dl[0] + groove, y_cd[1] + 0.3];             // the guide ring: its back (in the groove), its front
y_l1 = [y_dl[1] + 0.5, y_dl[1] + 4.5];                // layer 1: the flag, the knob's gear, the sensor gear
y_fl = [y_l1[0], y_l1[0] + paper_t, y_l1[0] + paper_t + fl_t];   // the flag: its paper, its plate
y_sh = y_l1[1] + sg_hub[1];                           // the sensor gear's hub's back (the magnet)
y_ch = y_sh + as_gap;                                 // the AS5600's chip
y_as = [y_ch + as_chip, y_ch + as_chip + as_t];       // its board
y_l2s = y_l1[1] + 0.5;                                // layer 2: the sector and the pinion
y_bp = [max(y_l2s + 5, y_as[1] + 0.3), max(y_l2s + 5, y_as[1] + 0.3) + back_t];   // back plate, the case's back
y_l2 = [y_l2s, y_bp[0] - 0.5];
y_msh = y_bp[1] - shaft_len;                          // the motor's shaft's end
y_mp = [max(y_l2[0], y_msh), y_l2[1]];                // its pinion
y_svb = y_bp[1] - sv_boss[1];                         // the servo's boss's front
y_svs = y_svb - sv_spline[1];                         // its spline's end
y_kr0 = max(y_bp[1] + motor_flange_t + motor_h, y_bp[1] + sv_body[2]) + 1;
y_kr = [y_kr0, y_kr0 + car_t];                        // carrier
y_axle = [y_nd[0] + needle_skin, y_bp[1] - 0.8];
axle_len = y_axle[1] - y_axle[0];
y_ks = [y_sheet1 + 0.2, y_bp[0] + 2.5];               // the knob's shaft: its pinion's hub's front, its end in the back plate
nav_depth = y_kr[1] + max(uln_standoff + uln_t + uln_plug_room, nano_under + nano_t + nano_usb[1]) - y_sheet1;
// MobiFlight: the needle's steps at X-Plane's dots (+-2.5 full scale: one of them is two of the face's)
function nav_steps(xd) = round(dev_a(2 * xd) * sec_ratio * 2038 / 360);

echo(nav_depth = nav_depth, case_depth = y_bp[1] - y_sheet1, axle_len = axle_len, knob_turns_per_card_turn = k_ratio,
     needle_full_scale_deg = th_full, motor_full_scale_deg = th_full * sec_ratio,
     steps_at_xplane_dots = [for (x = [0 : 0.5 : 2.5]) [x, nav_steps(x)]],
     flag_angles = [flag_a(1), flag_a(0), flag_a(2)], nav_deep_x = car_box[0], nav_low_depth = y_bp[1] - y_sheet1);

// --- Checks ---
// the face and the card
assert(full_x + dot_d / 2 + 1 <= cd_r[0], "Dots under the card");
assert(win_c.x - win.x / 2 - win_line >= ctr_ring[0] / 2 + 1 && win_c.y - win.y / 2 - win_line >= dot_d / 2 + 1,
       "The flag's window runs into the middle or the dots");
assert(norm(win_c + win / 2) + win_line + 0.5 <= cd_r[0], "The flag's window under the card");
assert(cd_tick_r <= cd_r[1] - 0.3 && cd_tick_r >= window_d / 2 + 0.3, "Card ticks off the card or short of the window");
assert(cd_num_r + cd_num_size / 2 + 0.6 <= cd_tick_r - tick_10[0] && cd_num_r - cd_num_size / 2 >= cd_r[0] + 0.8,
       "Card numbers off their ring");
assert(window_d / 2 - idx[0] >= cd_tick_r - tick_10[0], "The lip's indexes reach past the ticks");
// the card's train
assert(g_ra(z_card, cm) <= rim_id / 2 - 0.3, "The card's teeth run into the spacer ring");
assert(cd_r[1] <= rim_id / 2 - 0.3, "The card runs into the spacer ring");
assert(g_rf(z_card, cm) - cb_in >= 0.8 && cb_in >= gr_r[1] + 0.25, "The card's band too thin, or tight on the guide ring");
assert(y_cb1 - y_cd[1] >= 2, "The card's teeth too narrow");
assert(y_kp[0] >= y_sheet1 + 0.5, "The knob's pinion runs into the sheet");
assert(norm(knob_c) - ks_d / 2 - 0.5 >= cut_d / 2 + 2.5, "The knob's shaft too close to the instrument's hole");
assert(norm(knob_c) - ks_rd / 2 - 0.3 >= bore_d / 2 + 1.2, "The knob's shaft's bearing breaks into the bore");
assert(g_rf(z_kp, cm) - (ks_d + 0.2) / 2 >= 1.2 && g_rf(z_kg, km) - (ks_rd + 0.1) / 2 >= 1.1, "A gear too small for the knob's shaft");
assert(y_l1[0] - 0.3 - (y_kp[1] + 0.3) >= 1.5, "No bearing for the knob's shaft in the case");
// the sensor's train
assert(g_rf(z_sg, km) >= sg_hub[0] / 2 + 1 && sg_hub[0] / 2 - as_mag[0] / 2 >= 1, "Sensor gear's hub");
assert(y_sh - as_mag[1] - 0.1 - (y_l1[0] + 0.3) >= 2.5, "Too little of the dial's peg in the sensor gear");
assert(z_sg * z_kp == z_card * z_kg, "The sensor gear does not turn with the card");
assert(norm(sg_c) + ra_sg + 1 <= norm(knob_c) + kp_boss - wall, "Sensor gear runs out of the case");
// the needle
assert(norm(pivot) + nd_hub[0] / 2 <= gr_r[0] - 0.4, "The needle's hub runs into the guide ring");
for (t = [-th_max, 0, th_max]) assert(norm(pivot + pol(nd_len, 180 - t)) + nd_w[1] / 2 <= gr_r[0] - 0.5, "The needle's tip runs into the guide ring");
assert(pivot.y - nd_len <= -cd_r[0] * 0.6, "Needle short");
assert(norm(pivot) + sec_hub / 2 + 0.5 <= bore_d / 2 && norm(pivot) + axle[0] <= bore_d / 2, "Sector's hub runs into the case");
assert(mag_sec + magnet[0] / 2 + 0.8 <= g_rf(z_sec, sm) && mag_sec - magnet[0] / 2 >= sec_hub / 2, "Magnet off the sector");
assert(y_bp[0] - y_l2[1] + 0.1 <= magnet_gap_max, "The sector's magnet too far from its sensor");
assert(y_l2[1] - y_l2[0] - magnet[1] - 0.1 >= 1.2, "Magnet pocket too deep for the sector");
assert(y_msh >= y_l1[1] + 0.3 && y_msh + flat_len >= y_mp[1] - 0.5 && y_mp[1] - y_mp[0] >= 3.5, "The motor's shaft (its flats) and the pinion");
assert(g_rf(z_mp, sm) - (shaft_d + 0.1) / 2 >= 1, "Pinion too small for the shaft");
// layer 2: the sector's sweep, the pinion, the AS5600 board, the hubs and posts
l2_parts = concat([[mp_c, g_ra(z_mp, sm) + 0.3], [sg_c, sg_hub[0] / 2], [sv_c, fl_hub / 2], [knob_c, ks_rd / 2]],
                  [for (p = dp_xz) [p, post_d / 2]]);
for (i = [0 : len(l2_parts) - 1]) let(p = l2_parts[i]) {
   if (i > 0) assert(sweep_clear(p[0], p[1], pivot, sec_ra, 180, sec_half + th_max), "Runs into the sector's sweep");
   if (i != 1) assert(rect_clear(p[0], p[1], sg_c, as_board, as_rot), "Runs into the AS5600 board");
}
assert(norm(sg_c - mp_c) >= sg_hub[0] / 2 + g_ra(z_mp, sm) + 1, "Sensor gear's hub runs into the pinion");
for (s = [-1, 1], t = [-1, 1]) assert(norm(sg_c + rot2([s * as_board.x / 2, t * as_board.y / 2], as_rot)) <= bore_d / 2 - 0.5,
                                      "AS5600 board runs into the case");
for (h = as_hole_xz) assert(rect_clear(h, 0, sg_c, as_board - [5, 5], as_rot, 0), "AS5600 hole off the board");
// layer 1: the flag's sweep, the gears, the axle, the posts
for (p = concat([[sg_c, ra_sg], [knob_c, ra_kg], [pivot, axle[0] / 2 + 0.3]], [for (p = dp_xz) [p, post_d / 2]]))
   assert(sweep_clear(p[0], p[1], sv_c, fl_ro, aw, fl_sweep), "Runs into the flag's sweep");
for (p = dp_xz) {
   assert(norm(p - sg_c) >= ra_sg + post_d / 2 + 0.5 && norm(p) + post_d / 2 <= bore_d / 2 - 0.2, "A dial post runs into the sensor gear or the case");
   assert(norm(p - win_c) >= norm(win / 2) + 2, "A dial post behind the window");
}
for (a = [-fl_sweep : 5 : fl_sweep]) assert(norm(sv_c + pol(fl_ro, aw + a)) <= bore_d / 2 - 0.3, "The flag runs into the case");
assert(y_svs - 0.2 >= y_fl[2] + 1.5, "The servo's spline reaches the flag's plate");
assert(y_svb + 0.01 >= y_bp[0] - 0.6, "The servo's boss not in the back plate");
// back: the motor, the servo, the sensors, the posts
assert(clear_cover(mA, home_c, sensor.z / 2 + 1) && norm(home_c + [0, sensor.z / 2] - m_body(mA)) >= motor_d / 2 + 1,
       "The needle's sensor's legs run into the motor");
let(sv_box = [sv_body[1], sv_body[0]])
   for (p = concat([[m_body(mA), motor_d / 2]], [for (e = m_ears(mA)) [e, motor_ear_w / 2]], [[home_c, sensor.x]]))
      assert(rect_clear(p[0], p[1], sv_body_c, [sv_body[1], sv_tab[0]], 0, 1), "The servo runs into the motor or a sensor");
for (p = car_posts) {
   assert(norm(p - m_body(mA)) >= motor_d / 2 + car_post_d / 2 + 0.9 && clear_cover(mA, p, car_post_d / 2 + 0.5), "A carrier post runs into the motor");
   for (e = m_ears(mA)) assert(norm(p - e) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
   assert(rect_clear(p, car_post_d / 2, sv_body_c, [sv_body[1], sv_tab[0]], 0, 0.8), "A carrier post runs into the servo");
   assert(norm(p) + car_post_d / 2 <= case_r - 0.5, "A carrier post off the back plate");
   assert(min([for (h = uln_holes_c) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
   assert(abs(p.x - nav_nano_c.x) >= nano_rail_hw + csk_d / 2 + 1.2 || abs(p.y - nav_nano_c.y) >= nano_board.y / 2 + csk_d / 2 + 1.7,
          "A carrier screw under the Nano's rails");
   assert(norm(p - home_c) >= car_post_d / 2 + 3 && norm(p - knob_c) >= car_post_d / 2 + 4, "A carrier post on a sensor or the knob");
   assert(p.x - car_post_d / 2 >= car_box[0] && p.x + car_post_d / 2 <= car_box[2] && p.y - car_post_d / 2 >= car_box[1]
          && p.y + car_post_d / 2 <= car_box[3], "A carrier post off the carrier");
}
assert(uln_c.x - uln_board.x / 2 >= car_box[0] + 1 && uln_c.x + uln_board.x / 2 <= car_box[2] - 1
       && uln_c.y - uln_board.y / 2 >= car_box[1] + 1 && uln_c.y + uln_board.y / 2 <= car_box[3] - 1, "ULN2003 board off the carrier");
assert(abs(uln_c.x - nav_nano_c.x) >= uln_board.x / 2 + nano_rail_hw + 1 || abs(uln_c.y - nav_nano_c.y) >= (uln_board.y + nano_board.y) / 2 + 2,
       "The ULN2003 board over the Nano");
assert(nav_nano_c.x - nano_rail_hw >= car_box[0] + 0.5 && nav_nano_c.x + nano_rail_hw <= car_box[2] - 0.5
       && nav_nano_c.y - nano_board.y / 2 - 1 >= car_box[1] && nav_nano_c.y + nano_board.y / 2 + 2 <= car_box[3], "Nano off the carrier");
assert(min([for (c = cover_pts(mA)) c.x]) >= car_box[0] && m_body(mA).x - motor_d / 2 >= car_box[0] && sv_body_c.x - sv_body[1] / 2 >= car_box[0],
       "Deeper than the back plate left of nav_deep_x (car_box[0]): the force feedback yoke's housing is there");
assert(car_box[3] <= inst_pitch.y / 2 - 1 && -car_box[1] <= inst_pitch.y / 2 - 1, "The carrier runs into the other NAV indicator's");
carrier_in_slot("NAV 1", [car_box[0], car_box[2]]);   // between the neighbours' (instrument.inc.scad)
carrier_in_slot("NAV 2", [car_box[0], car_box[2]]);
// the neighbours: the VSI and the ALT nav_dx to the left (their cases)
for (p = [[knob_c, kp_boss], [knob_c, kn[0] / 2]]) assert(norm(p[0] - [-nav_dx, 0]) >= case_r + p[1] + 1, "Runs into the instrument on the left");
for (i = [0, 1, 3]) assert(norm(knob_c - cols[i]) >= kn[0] / 2 + head_d / 2 + 2, "Knob over a case screw");

// --- Outlines, x right, z up ---
module cdi_case_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (i = [0, 1, 3]) translate(cols[i]) circle(d = ear_d);
      translate(knob_c) circle(r = kp_boss);
   }
}

module wedge_2d(r, dir, half) {
   n = max(2, ceil(2 * half / 3));
   polygon(concat([[0, 0]], [for (i = [0 : n]) pol(r, dir - half + 2 * half * i / n)]));
}

// --- Case: the standard's front, three screws, the indexes on the lip; the knob's pinion in a pocket
// open to the sheet, the gears of layer 1 in one open to the back ---
module cdi_case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_bp[0]) cdi_case_outline();
      }
      along_y(-1, y_glass0 + 0.01) difference() {
         circle(d = window_d, $fn = 180);
         for (a = [0, 180]) rotate(-a) polygon([[0, window_d / 2 - idx[0]], [idx[1] / 2, window_d / 2 + 0.5], [-idx[1] / 2, window_d / 2 + 0.5]]);
      }
      along_y(y_glass0, y_bp[0] + 1) circle(d = bore_d, $fn = 180);
      along_xz(knob_c, y_sheet1 - 0.01, y_kp[1] + 0.3) circle(r = ra_kp + 1);
      along_y(y_l1[0] - 0.3, y_bp[0] + 1) hull() {
         translate(knob_c) circle(r = ra_kg + 1);
         translate(sg_c) circle(r = ra_sg + 1);
      }
      along_xz(knob_c, y_kp[1], y_bp[0] + 1) circle(d = ks_rd + 0.3);
      for (i = [0, 1, 3]) {
         c = cols[i];
         translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
         translate([c.x, y_bp[0] + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
      }
   }
}

// --- Spacer ring: the glass against the lip (glued on the dial), a gap for the knob's pinion ---
module cdi_spacer() {
   along_y(y_glass1, y_dl[0]) difference() {
      circle(d = rim_od, $fn = 180);
      circle(d = rim_id, $fn = 180);
      translate(knob_c) circle(r = ra_kp + 0.6);
   }
}

// --- Guide ring: glued into the dial's groove, the card's band turns on it ---
module cdi_guide() {
   along_y(y_gr[1], y_gr[0]) difference() {
      circle(r = gr_r[1], $fn = 180);
      circle(r = gr_r[0], $fn = 180);
   }
}

// --- Card: the plate (its paper on the front), the toothed band behind it; o: the course ---
module cdi_card(o = 0) {
   rotate([0, -o, 0]) difference() {
      union() {
         along_y(y_cd[0], y_cd[1]) difference() {
            circle(r = cd_r[1], $fn = 180);
            circle(r = cd_r[0], $fn = 180);
         }
         along_y(y_cd[1] - 0.01, y_cb1) difference() {
            rotate(225) gear_2d(z_card, cm);
            circle(r = cb_in, $fn = 180);
         }
      }
   }
}

// --- Dial: flat (the face glued on), the guide ring's groove, the window, the needle's bearing;
// behind it the sensor gear's peg and the posts' pin holes ---
module cdi_dial() {
   difference() {
      union() {
         along_y(y_dl[0], y_dl[1]) circle(d = rim_od, $fn = 180);
         along_xz(sg_c, y_dl[1] - 0.01, y_sh - as_mag[1] - 0.5) circle(d = sg_peg);
      }
      along_y(y_dl[0] - 1, y_gr[0]) difference() {
         circle(r = gr_r[1] + 0.15, $fn = 180);
         circle(r = gr_r[0] - 0.15, $fn = 180);
      }
      along_y(y_dl[0] - 1, y_dl[1] + 1) translate(win_c) square(win, center = true);
      along_xz(pivot, y_dl[0] - 1, y_dl[1] + 1) circle(d = axle[0] + 0.3);
      for (p = dp_xz) along_xz(p, y_dl[1] - dp_pin[1] - 0.1, y_dl[1] + 0.01) circle(d = dp_pin[0] + 0.3);
   }
}

// --- Needle: hanging from the pivot; t: its angle (right positive) ---
module cdi_needle_2d() {
   hull() {
      circle(d = nd_w[0]);
      translate([0, -nd_len + nd_w[1] / 2]) circle(d = nd_w[1]);
   }
   circle(d = nd_hub[0]);
}

module at_pivot(t) {
   translate([pivot.x, 0, pivot.y]) rotate([0, -t, 0]) translate([-pivot.x, 0, -pivot.y]) children();
}

module cdi_needle(t = 0) {
   at_pivot(t) difference() {
      union() {
         along_xz(pivot, y_nd[0], y_nd[1]) cdi_needle_2d();
         along_xz(pivot, y_nd[1] - 0.01, y_nd[1] + nd_hub[1]) circle(d = nd_hub[0]);
      }
      along_xz(pivot, y_axle[0], y_nd[1] + nd_hub[1] + 1) circle(d = axle[0] - 0.1);
   }
}

// --- Sector: on the axle, its teeth down to the motor's pinion, the magnet in its back ---
module cdi_sector(t = 0) {
   at_pivot(t) difference() {
      along_xz(pivot, y_l2[0], y_l2[1]) {
         intersection() {
            rotate(-90) gear_2d(z_sec, sm);
            wedge_2d(sec_ra + 1, 180, sec_half);
         }
         circle(d = sec_hub);
      }
      along_xz(pivot, y_l2[0] - 1, y_l2[1] + 1) circle(d = axle[0] - 0.1);
      translate([home_c.x, y_l2[1] + 0.01, home_c.y]) rotate([90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

// the motor's pinion (a gap up, towards the sector); a: clockwise
module cdi_pinion(a = 0) {
   translate([mp_c.x, 0, mp_c.y]) rotate([0, a, 0]) difference() {
      along_y(y_mp[0], y_mp[1]) rotate(90 - 180 / z_mp) gear_2d(z_mp, sm);
      translate([0, y_mp[1] + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y_mp[1] - y_mp[0] + 2);
   }
}

// --- The knob's train ---
module d_2d(d, flat) {
   intersection() {
      circle(d = d);
      translate([-d / 2, -d / 2]) square([d, d / 2 + flat - d / 2]);
   }
}

// the knob's shaft: the pinion's hub forward to the sheet (the knob's spigot in it), the pinion, a D shaft back; a: clockwise
module cdi_knob_shaft(a = 0) {
   translate([knob_c.x, 0, knob_c.y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_ks[0], y_kp[0] + 0.01) circle(d = kp_hub);
         along_y(y_kp[0], y_kp[1]) rotate(45 - 180 / z_kp) gear_2d(z_kp, cm);
         along_y(y_kp[1] - 0.01, y_ks[1]) d_2d(ks_rd, ks_rd - 0.8);
      }
      along_y(y_ks[0] - 1, y_kp[1] - 0.6) offset(delta = 0.1) d_2d(ks_d, ks_d - 1);
   }
}

module cdi_knob_gear(a = 0) {
   translate([knob_c.x, 0, knob_c.y]) rotate([0, a, 0]) difference() {
      along_y(y_l1[0], y_l1[1]) rotate(45 - 180 / z_kg) gear_2d(z_kg, km);
      along_y(y_l1[0] - 1, y_l1[1] + 1) offset(delta = 0.05) d_2d(ks_rd, ks_rd - 0.8);
   }
}

// the sensor gear: on the dial's peg, the magnet in its hub's back; a: clockwise
module cdi_sensor_gear(a = 0) {
   translate([sg_c.x, 0, sg_c.y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y_l1[0], y_l1[1]) rotate(225) gear_2d(z_sg, km);
         along_y(y_l1[1] - 0.01, y_sh) circle(d = sg_hub[0]);
      }
      along_y(y_l1[0] - 1, y_sh - as_mag[1] - 0.3) circle(d = sg_peg + 0.3);
      along_y(y_sh - as_mag[1] - 0.1, y_sh + 1) circle(d = as_mag[0] + 0.2);
   }
}

// --- Flag: the sector on the servo's spline, its paper on the front; f: 0 OFF, 1 TO, 2 FROM ---
module flag_plate_2d() {
   intersection() {
      circle(r = fl_ro);
      wedge_2d(fl_ro + 1, 0, fl_span);
   }
   circle(d = fl_hub);
}

module cdi_flag(f = 0) {
   translate([sv_c.x, 0, sv_c.y]) rotate([0, aw + flag_a(f), 0]) difference() {
      union() {
         along_y(y_fl[1], y_fl[2]) flag_plate_2d();
         along_y(y_fl[2] - 0.01, y_svb - 0.2) circle(d = fl_hub);
      }
      along_y(y_svs - 0.2, y_svb) circle(d = sv_spline_fit);
      along_y(y_fl[1] - 1, y_svs) circle(d = 2.2);    // the servo's screw
   }
}

// --- Knob: knurled, its D spigot through the sheet into the knob's shaft; a: clockwise ---
module cdi_knob(a = 0) {
   y0 = -knob_gap - kn[1];
   translate([knob_c.x, 0, knob_c.y]) rotate([0, a, 0]) difference() {
      union() {
         along_y(y0, -knob_gap) circle(d = kn[0], $fn = 60);
         along_y(-knob_gap - 0.01, y_kp[1] - 0.8) d_2d(ks_d, ks_d - 1);
      }
      for (k = [0 : 20 : 340]) rotate([0, k, 0]) translate([kn[0] / 2, y0 - 1, 0]) rotate([-90, 0, 0])
         cylinder(d = kn[2] * 1.6, h = kn[1] + 2, $fn = 12);
   }
}

// --- Back plate: the motor, the servo, the needle's sensor, the AS5600 board, the bearings; posts ---
module cdi_back_plate() {
   difference() {
      union() {
         along_y(y_bp[0], y_bp[1]) cdi_case_outline();
         for (p = dp_xz) {
            along_xz(p, y_dl[1], y_bp[0] + 0.01) circle(d = post_d);
            along_xz(p, y_dl[1] - dp_pin[1], y_dl[1] + 0.01) circle(d = dp_pin[0]);
         }
         // the AS5600's standoffs, from the plate to its board
         for (h = as_hole_xz) along_xz(h, y_as[1], y_bp[0] + 0.01) circle(d = 6);
         for (h = sv_tab_holes) along_xz(h, y_bp[1] - 0.01, y_bp[1] + sv_tab[2]) circle(d = 6);
         for (p = car_posts) along_xz(p, y_bp[1] - 0.01, y_kr[0]) circle(d = car_post_d);
      }
      for (i = [0, 1, 3]) translate([cols[i].x, y_bp[1], cols[i].y]) rotate([-90, 0, 0]) csk_hole();
      along_xz(pivot, y_bp[0] - 0.01, y_axle[1] + 0.3) circle(d = axle[0] + 0.1);
      along_xz(knob_c, y_bp[0] - 0.01, y_ks[1] + 0.3) circle(d = ks_rd + 0.3);
      // the motor
      translate([mp_c.x, y_bp[0] - 1, mp_c.y]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
      for (e = m_ears(mA)) translate([e.x, y_bp[0], e.y]) rotate([90, 0, 0]) csk_hole();
      sensor_pocket(home_c, y_bp[0], 1);
      // the servo's boss and bump, its screws
      along_y(y_bp[0] - 1, y_bp[1] + 1) hull() {
         translate(sv_c) circle(d = sv_boss[0] + 0.6);
         translate(sv_c + sv_bump[1] * sv_dir) circle(d = sv_bump[0] + 0.6);
      }
      for (h = sv_tab_holes) along_xz(h, y_bp[1] + 1, y_bp[1] + sv_tab[2] + 1) circle(d = sv_pilot);
      // the AS5600's screws (from its front into the standoffs), its wires' slot
      for (h = as_hole_xz) along_xz(h, y_as[1] - 1, y_as[1] + 6) circle(d = pilot_d);
      along_xz(as_slot_c, y_bp[0] - 1, y_bp[1] + 1) rotate(as_rot) square(as_slot, center = true);
      for (p = car_posts) translate([p.x, y_kr[0] + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - car_t + 1);
   }
}

// --- Board carrier: the ULN2003 board and the Nano behind it (facing back) ---
module cdi_carrier() {
   y1 = y_kr[1];
   difference() {
      union() {
         along_y(y_kr[0], y1) translate([car_box[0], car_box[1]]) square([car_box[2] - car_box[0], car_box[3] - car_box[1]]);
         for (h = uln_holes_c) along_xz(h, y1 - 0.01, y1 + uln_standoff) circle(d = uln_standoff_d);
         on_board_plate(nav_nano_c, y1, "down") nano_rails(y1 = nano_board.y / 2 + 1, far_stop = true);
      }
      for (h = uln_holes_c) along_xz(h, y1 - 1, y1 + uln_standoff + 1) circle(d = pilot_d);
      for (p = car_posts) translate([p.x, y1, p.y]) rotate([-90, 0, 0]) csk_hole();
   }
}

// --- Face, 2D: x right, y up, the axis at the origin ---
face_r = gr_r[0] - 0.3;      // the face's paper, inside the guide ring

module win_2d(d = 0) {
   translate(win_c) square(win + [2 * d, 2 * d], center = true);
}

module cdi_face_2d() {
   ink(c_black) circle(r = face_r, $fn = 180);
   ink(c_white) {
      for (i = [-dots : dots]) if (i != 0) translate([i * dot_dx, 0]) circle(d = dot_d);
      difference() {
         circle(d = ctr_ring[0] + ctr_ring[1]);
         circle(d = ctr_ring[0] - ctr_ring[1]);
      }
      difference() {
         win_2d(win_line);
         win_2d();
      }
      translate([-12, 9]) text("VOR", size = 2.2, font = font, halign = "center", valign = "center");
      translate(pivot) circle(d = axle[0] + 0.3);      // the axle's hole, to punch
   }
}

// the card's paper (at course 0): N 3 6 E ..., a tick every 5 degrees
module cdi_card_2d() {
   ink(c_black) difference() {
      circle(r = cd_r[1], $fn = 180);
      circle(r = cd_r[0], $fn = 180);
   }
   ink(c_white) {
      for (i = [0 : 71]) {
         t = i % 2 == 0 ? tick_10 : tick_5;
         tick_2d(i * 5, cd_tick_r - t[0], cd_tick_r, t[1]);
      }
      for (i = [0 : 11]) rotate(-i * 30) translate([0, cd_num_r])
         text(i % 3 == 0 ? ["N", "E", "S", "W"][i / 3] : str(i * 3), size = cd_num_size, font = font, halign = "center", valign = "center");
      difference() {
         circle(r = cd_r[0] + 0.4, $fn = 180);
         circle(r = cd_r[0], $fn = 180);
      }
   }
}

// the flag's paper (in its own coordinates, the window up at OFF): the three fields, upright in the window
module cdi_flag_2d() {
   module field(f) {
      c = -flag_a(f);
      translate(pol(fl_rf, c)) rotate(aw + flag_a(f)) children();
   }
   ink(c_black) intersection() {
      flag_plate_2d();
      difference() {
         circle(r = fl_ro);
         circle(d = fl_hub + 1);
      }
   }
   field(0) ink(c_red) square(fl_field, center = true);
   ink(c_white) {
      field(0) intersection() {
         square(fl_field, center = true);
         for (i = [-4 : 4]) translate([i * 2.4, 0]) rotate(-35) square([1.2, 20], center = true);
      }
      field(1) polygon([[-2.6, -1.8], [2.6, -1.8], [0, 2.2]]);
      field(2) polygon([[-2.6, 1.8], [2.6, 1.8], [0, -2.2]]);
   }
}

// the page: two faces, two cards, two flags, the glass's template, the caption; registration dots in every layer
module cdi_print() {
   step = 2 * cd_r[1] + print_gap;
   row2 = -cd_r[1] - print_gap - cd_r[1];
   w = 2 * step + glass_d;
   for (i = [0, 1]) {
      translate([i * step, 0]) cdi_card_2d();
      translate([i * step, row2]) cdi_face_2d();
      translate([2 * step + glass_d / 2 - cd_r[1] + i * (2 * fl_ro + 6), row2 + 10]) cdi_flag_2d();
   }
   ink(c_black) {
      translate([2 * step + glass_d / 2 - cd_r[1], 0]) difference() {
         circle(d = glass_d + 0.6, $fn = 180);
         circle(d = glass_d, $fn = 180);
      }
      lines = [str("NAV: card ", 2 * cd_r[1], " mm and face ", 2 * face_r, " mm,"),
               "cut on their edges; the window and",
               "the hole on the white lines' inside.",
               "Flags: cut on their edges.",
               str("Glass ", glass_d, " mm: cut on the line's inside."),
               "Print at 100 %."];
      for (i = [0 : len(lines) - 1]) translate([2 * step - cd_r[1] - 4, row2 - 12 - 5 * i]) text(lines[i], size = 3, font = font);
   }
   x1 = 2 * step + glass_d / 2 - cd_r[1] + 3 * fl_ro + 8;
   for (x = [-cd_r[1] - 2, max(w - cd_r[1], x1) + 2], y = [row2 - 12 - 5 * 6 - 2, glass_d / 2 + 2]) translate([x, y]) square(0.1, center = true);
}

// --- View only ---
module layers_part(y) {
   for (i = [0 : len(face_colors) - 1])
      color(face_colors[i]) translate([0, y - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = face_colors[i]) children();
}

module servo_part() {
   color("#2a5db0") {
      translate([sv_body_c.x, y_bp[1], sv_body_c.y]) rotate([-90, 0, 0]) linear_extrude(sv_body[2])
         square([sv_body[1], sv_body[0]], center = true);
      translate([sv_body_c.x, y_bp[1] + sv_tab[2], sv_body_c.y]) rotate([-90, 0, 0]) linear_extrude(sv_tab[1])
         square([sv_body[1], sv_tab[0]], center = true);
      along_xz(sv_c, y_svb, y_bp[1]) circle(d = sv_boss[0]);
   }
   color("#f4f4f4") along_xz(sv_c, y_svs, y_svb) circle(d = sv_spline[0]);
}

module as5600_part() {
   translate([sg_c.x, 0, sg_c.y]) rotate([0, -as_rot, 0]) {
      color("#1d4fa0") along_y(y_as[0], y_as[1]) square(as_board, center = true);
      color("#202020") along_y(y_ch, y_as[0]) square([5, 4], center = true);
   }
   color(c_magnet) along_xz(sg_c, y_sh - as_mag[1], y_sh) circle(d = as_mag[0]);
}

module cdi_boards_part() {
   on_board_plate(uln_c, y_kr[1], "up") uln_part();
   on_board_plate(nav_nano_c, y_kr[1], "down") nano_part(c_board);
}

module cdi_sheet_part(w = 150, h = 120, x0 = -75) {
   color(c_sheet) along_y(0, sheet_t) difference() {
      translate([x0, -h / 2]) square([w, h]);
      circle(d = cut_d, $fn = 180);
      for (i = [0, 1, 3]) translate(cols[i]) circle(d = clear_d);
      translate(knob_c) circle(d = ks_d + 1);
   }
   color("#111111") for (i = [0, 1, 3]) translate([cols[i].x, 0, cols[i].y]) rotate([90, 0, 0]) cylinder(d = head_d, h = 1.65);
}

// all parts at d dots, the course o and the flag f; e: apart by this
module cdi_parts(d = view_dots, o = view_obs, f = view_flag, e = 0, with_case = true) {
   t = dev_a(d);
   ak = o * k_ratio;                                 // the knob (and its gear), clockwise
   color("#45484d") translate([0, -1.6 * e, 0]) render() cdi_knob(ak);
   translate([0, -0.4 * e, 0]) {
      color(c_case) render() cdi_card(o);
      rotate([0, -o, 0]) layers_part(y_cd[0]) difference() {
         cdi_card_2d();
         circle(r = cd_r[0] - 1);
      }
   }
   color(c_needle) render() cdi_needle(t);
   color(c_steel) at_pivot(t) along_xz(pivot, y_axle[0], y_axle[1]) circle(d = axle[0]);
   translate([0, 0.6 * e, 0]) {
      color(c_case) render() cdi_dial();
      color(c_case) cdi_guide();
      color(c_case) cdi_spacer();
      layers_part(y_fc) difference() {
         cdi_face_2d();
         win_2d();
      }
   }
   translate([0, 1.4 * e, 0]) {
      color(c_case) render() cdi_flag(f);
      translate([sv_c.x, 0, sv_c.y]) rotate([0, aw + flag_a(f), 0]) layers_part(y_fl[0] + 0.1) cdi_flag_2d();
      color(c_case) render() cdi_knob_gear(ak);
      color(c_case) render() cdi_sensor_gear(-o);
      color(c_case) render() cdi_knob_shaft(ak);
   }
   translate([0, 2.2 * e, 0]) {
      color(c_case) render() cdi_sector(t);
      color(c_case) render() cdi_pinion(t * sec_ratio);
      color(c_magnet) at_pivot(t) translate([home_c.x, y_l2[1], home_c.y]) rotate([90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
      as5600_part();
   }
   translate([0, 3 * e, 0]) {
      color(c_case) render() cdi_back_plate();
      motor_at(mA, y_bp[1]);
      servo_part();
      color("#202020") translate([home_c.x - sensor.x / 2, y_bp[0], home_c.y - sensor.z / 2]) cube(sensor);
   }
   translate([0, 4 * e, 0]) {
      color(c_case) cdi_carrier();
      cdi_boards_part();
   }
   if (with_case) translate([0, -e, 0]) {
      color(c_case) render() cdi_case();
      color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
   }
}

module assembled_view() {
   cdi_sheet_part();
   cdi_parts();
}

module exploded_view() {
   cdi_parts(e = explode);
}

module inside_view() {
   cdi_parts(with_case = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) {
      cdi_card_2d();
      cdi_face_2d();
      translate(sv_c) rotate(-(aw + flag_a(view_flag))) cdi_flag_2d();
   }
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_bp[0]]) rotate([-90, 0, 0]) cdi_case(); // Make module case
translate([0, 0, -y_glass1]) rotate([90, 0, 0]) cdi_spacer(); // Make module spacer
translate([0, 0, -y_gr[1]]) rotate([90, 0, 0]) cdi_guide(); // Make module guide
translate([0, 0, -y_cd[0]]) rotate([90, 0, 0]) cdi_card(); // Make module card
translate([0, 0, -y_dl[0]]) rotate([90, 0, 0]) cdi_dial(); // Make module dial
translate([0, 0, -y_nd[0]]) rotate([90, 0, 0]) cdi_needle(); // Make module needle
translate([0, 0, -y_l2[0]]) rotate([90, 0, 0]) cdi_sector(); // Make module sector
translate([0, 0, -y_mp[0]]) rotate([90, 0, 0]) translate([-mp_c.x, 0, -mp_c.y]) cdi_pinion(); // Make module pinion
translate([0, 0, -y_ks[0]]) rotate([90, 0, 0]) translate([-knob_c.x, 0, -knob_c.y]) cdi_knob_shaft(); // Make module knob_shaft
translate([0, 0, -y_l1[0]]) rotate([90, 0, 0]) translate([-knob_c.x, 0, -knob_c.y]) cdi_knob_gear(); // Make module knob_gear
translate([0, 0, -y_l1[0]]) rotate([90, 0, 0]) translate([-sg_c.x, 0, -sg_c.y]) cdi_sensor_gear(); // Make module sensor_gear
translate([0, 0, -y_fl[1]]) rotate([90, 0, 0]) translate([-sv_c.x, 0, -sv_c.y]) cdi_flag(); // Make module flag
translate([0, 0, -y_bp[0]]) rotate([90, 0, 0]) cdi_back_plate(); // Make module back
translate([0, 0, -y_kr[0]]) rotate([90, 0, 0]) cdi_carrier(); // Make module carrier
translate([0, 0, knob_gap + kn[1]]) rotate([90, 0, 0]) translate([-knob_c.x, 0, -knob_c.y]) cdi_knob(); // Make module knob

cdi_print(); // Make print face black,red,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
