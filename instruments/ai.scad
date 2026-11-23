// Attitude indicator on two 28BYJ-48 steppers
//
// The six-pack's top middle instrument (frame/), between the airspeed
// indicator and the altimeter, over the heading indicator. It has the
// standard instrument's case front (instrument.inc.scad: the hole, the
// lip, the glass, the four screws through the sheet), but it is deeper:
// the horizon is a drum, and two motors drive it.
//
// What moves:
// - Roll: the roll frame turns in a printed sleeve in the case. Its front
//   is the roll dial (sky and ground halves, the bank marks 10, 20, 30,
//   60, 90, white lines in the ground: a colour print, ai_face.pdf), behind
//   it two arms carry the drum; its back disc carries the roll gear. The
//   bank index (an orange triangle at 12 o'clock, on the sleeve's front
//   ring) and the airplane are fixed, between the glass and the dial: the
//   orange wing bars and dot on a black mount, rising from a black mask
//   over the window's bottom, with a dummy knob in front of the glass on a
//   stem through it (the real one sets the airplane's height). Like the
//   X-Plane 172N's, the dial turns with the horizon and the index reads
//   its bank marks.
// - Pitch: the drum (a cylinder across the dial's window, sky and ground
//   with the pitch lines on a printed strip, ai_drum.pdf) turns on its
//   axis across the roll frame. Its drive comes through the roll axis: a
//   pitch axle inside the roll frame's tube carries a sun gear, a planet
//   gear on the roll frame meshes it, and a bevel pinion on the planet's
//   shaft turns a bevel gear on the drum's end (their apex on the drum's
//   axis). The drum turns by the axle's turn
//   relative to the roll frame (1:1 overall), so both motors stay on the
//   back plate and no wires go into the turning part; MobiFlight adds the
//   roll to the pitch motor's position (README). The drum turns round
//   freely, so homing one motor while the other stands still jams nothing.
//   It turns pitch_k degrees per degree of pitch (more than a sphere would,
//   so the pitch lines are far enough apart).
// - Behind the roll frame: the roll gear (on the roll frame's tube) and
//   the pitch gear (on the pitch axle) are 1:1 with the standard's motor
//   gears, the roll motor right, the pitch motor left (mirrored), both on
//   the back plate's back with their bodies over the axis. A disc magnet
//   in each motor gear passes an A3144 hall sensor in the back plate for
//   homing. A board carrier on four posts behind the motors holds the two
//   ULN2003 boards and the Arduino Nano (MobiFlight, its own USB cable),
//   facing back.
//
// It is deeper than the standard instrument (ai_depth echo), but it is in
// the six-pack's top row, over the force feedback yoke's housing (the
// frame's ai_depth checks it).
//
// Parts (printed): the case (back side down), the sleeve with the front
// ring and the bank index (ring down), the airplane with its mount and the
// mask (flat), the knob (front down), the roll dial
// with the arms (dial down), the roll back disc with the roll gear (front
// down), the drum (left end down), the drum's bevel gear (disc down), the
// sun, planet, pinion and pitch gears, the two motor gears, the back
// plate with the carrier's posts (front down), the board carrier (flat).
// All black; paint the index and the airplane's wings and dot orange.
//
// Parts to buy:
// - 2 x 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and
//   a mini USB cable (angled plug), 2 x A3144 hall sensor, 2 x disc magnet
//   6 x 3 mm
// - steel dowel pins 3 mm: 2 x 20 (drum), 1 x 24 (planet shaft), 1 x 20
//   (pitch axle)
// - clear sheet 1 mm (glass, a 3.4 mm hole for the knob's stem), the two
//   prints on photo paper
// - M3 x 8 button head, black (4, through the sheet into the case),
//   M3 x 8 countersunk self tapping (4, back plate into the case; 2, the
//   roll back disc onto the arms; 4, the carrier onto its posts),
//   M3 x 8 countersunk + nut (4, motor ears), M3 x 6 self tapping (8,
//   ULN2003 boards)
//
// Assembly (see the README): drum strip onto the drum, bevel gear into the
// drum's right end; roll dial face onto the dial. Drum between the arms,
// pins through the arms into its hubs. Pinion and planet gear onto their
// shaft (through the front boss), sun onto the pitch axle, back disc onto
// the arms (its tube over the sun's hub). Airplane's mask into the
// sleeve's ring. Knob through the glass into the mask (glue).
// Glass into the case, the sleeve behind it, the roll frame into the
// sleeve. Pitch gear onto the axle, magnets into the motor gears, sensors
// and motors onto the back plate, motor gears on, back plate into the
// case. Carrier onto its posts, boards on it, wire it.
//
// Coordinates as in instrument.inc.scad: x to the right, y away from the
// pilot, z up, the origin on the roll axis at the sheet's front face.

$fn = 60;

include <instrument.inc.scad>

// Preview: bank (right wing down positive) and pitch (nose up positive),
// parts apart by explode
view_roll = 20;
view_pitch = 10;
explode = 25;

// --- Display ---
pitch_k = 1.5;               // drum degrees per degree of pitch
pitch_max = 60;              // MobiFlight clamps the pitch here (the drum at 90: the horizon at the window's edge)
pitch_lines = [[5, 5], [10, 10], [15, 5], [20, 10]];   // nose up and down: pitch, length
line_w = 0.6;
horizon_w = 1;
bank_short = [10, 20];       // bank marks, both sides
bank_long = [30, 60];
mark_r1 = 35;                // the marks' outer end
mark_len = [3, 5.5];         // short, long
mark_w = [0.7, 1];
ground_lines = [20, 45];     // the dial's ground: white lines this far under the horizon, both sides
ground_w = 0.8;
// colours, in the prints' order (keep the print markers below the same)
c_black = "black";
c_sky = "#4ba3d1";
c_ground = "#7a4a2c";
c_white = "white";
face_colors = [c_black, c_sky, c_ground, c_white];
c_plane = "#ff8c1a";         // view only: the airplane's wings and dot, the index (paint)

// --- Fixed parts in the case: the sleeve, its ring, the airplane ---
ring_t = 2.6;                // the sleeve's front ring, behind the glass
ring_id = 71.6;              // just inside the window: the roll dial's rim runs on its back
sleeve_wall = 2;
bore_play = 0.15;            // sleeve to the case's bore, radial
leg_w = 6;                   // the sleeve's legs behind the roll frame, to the back plate
leg_angles = [0, 120, 240];  // clockwise from 12 o'clock, off the motor gears
plane_t = 1.5;
plane_glass = 0.5;           // the airplane behind the glass
index_tip = 29;              // the fixed bank index's tip from the axis
index_w = 6.5;
index_t = 1.4;
wing = [5.5, 18, 2.2];       // the airplane's wing bars: from, to (x), thickness
dot_d = 4.5;
mount_w = [3, 16];           // its black mount: width at the top, at the mask
mask_z = -21;                // the black mask over the window's bottom: its top edge
foot_r = 37.4;               // the mask's edge in the ring's notch, outer radius
knob = [10, 4, 1.2];         // the dummy knob in front of the glass: diameter, length, knurl depth
knob_z = -28.5;              // its axis
knob_pin = 3;                // its stem, through a hole in the glass into the mask

// --- Roll frame ---
roll_play = 0.3;             // radial, the roll dial and the back disc in the sleeve
rd_t = 1.5;                  // the roll dial
vis_r = 23;                  // the dial's window: the drum shows through it
face_r = 35.6;               // the dial's paper face, outer edge (under the ring's edge)
dial_gap = 0.4;              // airplane to the dial's face
arm = [4, 4.5];              // arms: x, z
r_arm = [27.3, 9.5];           // the right arm's inner edge (x) and its bottom (z): over the pinion and the planet
l_arm_x = -25.5;               // the left arm's inner edge
boss_d = 7;
fboss_d = 5.6;               // the planet shaft's front boss, beside the bevel gear's teeth
fboss_l = 5;                 // the planet shaft's front boss, along y
bd_t = 2.5;                  // back disc
rtube_d = [10, 6.4];          // the roll frame's tube: outside, its bore on the sun's hub

// --- Drum ---
drum_r = 25;                 // its shell's outside (the strip on it)
shell_t = 1.2;
drum_half = 24;              // half its length
drum_gap = 0.8;              // the strip to the roll dial
end_t = 1.5;                 // left end
drum_hub_d = 8;
rib = 1;                     // the seat for the bevel gear's disc

// --- Pitch gears, module gm ---
gm = 0.8;
z_sun = 51;
z_planet = 17;
z_pinion = 12;
z_face = 36;
gt = 4;                      // sun and planet
pinion_w = 4;
face_w = 5;                  // the drum's bevel gear's teeth, radial (the pinion's width and a bit)
face_disc_t = 1.5;
face_hub = [7, 5];           // the bevel gear's hub on its outside: diameter, length
sun_hub_d = 6;
pitch_hub_d = 8;             // the pitch gear's hub against the roll tube's end

// --- Pins, steel dowels ---
pin_d = 3;
press_d = 2.9;               // pressed in
run_d = 3.3;                 // turning in
pin_drum = 20;
pin_planet = 24;
pin_axle = 20;

// --- Motors and boards ---
hub1_d = 9;                  // the roll motor gear's hub on the shaft, in the pitch gear's plane
spost = [5, 8];              // the roll sensor's post on the back plate, up to the roll motor gear: x, z
post_xz = [24, 24];          // the carrier's posts on the back plate, the four corners
uln_xz = [[2, 7], [-37, 7]]; // the ULN2003 boards' lower left corners (x, z): right (roll), left (pitch)
nano_xz = [-26.5, -33];        // the Nano's lower left corner, lying along x, its USB jack left
car_box = [-39, -37, 39, 41];   // carrier plate: x0, z0, x1, z1

// --- Calculated ---
sleeve_od = bore_d - 2 * bore_play;
sleeve_id = sleeve_od - 2 * sleeve_wall;
roll_r = sleeve_id / 2 - roll_play;
y_ring0 = y_glass1;
y_ring1 = y_ring0 + ring_t;
y_rd0 = y_ring1;                              // the dial's rim on the ring's back
y_rd1 = y_rd0 + rd_t;
y_rface = y_rd0 - paper_t;                    // the dial's paper, its front
y_plane1 = y_rface - dial_gap;
y_plane0 = y_plane1 - plane_t;
drum_rp = drum_r + paper_t;
y_drum = y_rd1 + drum_gap + drum_rp;          // the drum's axis
xc = gm * (z_sun + z_planet) / 2 + gear_play; // the planet's shaft from the roll axis, along x
rp_pinion = gm * z_pinion / 2;
ra_pinion = rp_pinion + gm;
ra_sun = gm * z_sun / 2 + gm;
ra_planet = gm * z_planet / 2 + gm;
r_fc = gm * z_face / 2;                       // the drum's bevel gear's pitch radius (at the pinion's middle)
y_pin0 = y_drum + r_fc - pinion_w / 2;
y_pin1 = y_pin0 + pinion_w;
// the bevel pair: the apex where the planet's shaft meets the drum's axis, [xc, y_drum, 0];
// the drum's gear's pitch cone at radius r (from the drum's axis) is at x_pitch(r), its teeth scale with r
function x_pitch(r) = xc - r * z_pinion / z_face;
function x_root(r) = x_pitch(r) - 1.25 * gm * r / r_fc;
function x_tip(r) = x_pitch(r) + gm * r / r_fc;
r_f = [r_fc - face_w / 2, r_fc + face_w / 2];   // the drum's gear's teeth, radial
x_fr = x_root(r_f[1]);                        // the disc's outside
pin_s = [(y_pin0 - y_drum) / r_fc, (y_pin1 - y_drum) / r_fc];   // the pinion's scale at its ends
y_fb1 = y_pin0 - 0.4;                         // the front boss
y_fb0 = y_fb1 - fboss_l;
y_s0 = y_drum + drum_rp + 0.8;                // sun and planet
y_s1 = y_s0 + gt;
y_b0 = y_s1 + 0.4;                            // back disc
y_b1 = y_b0 + bd_t;
y_rg0 = y_b1 + gear_gap;                      // the roll motor gear's teeth (the roll gear from y_b1)
y_rg1 = y_rg0 + gear_t;
y_pg0 = y_rg1 + gear_gap;                     // pitch gear
y_pg1 = y_pg0 + gear_t;
y_bk0 = y_pg1 + gear_gap;                     // back plate, the case's back
y_bk1 = y_bk0 + back_t;
y_mshaft = y_bk1 - shaft_len;                 // the motors' shaft ends
y_ax1 = y_bk1 - 0.8;                          // pitch axle, in a blind hole in the back plate
y_ax0 = y_ax1 - pin_axle;
y_pl1 = y_b1;                                 // planet shaft, flush with the back disc's back
y_pl0 = y_pl1 - pin_planet;
x_ra1 = r_arm.x + arm.x;                      // the right arm's outer edge
x_la0 = l_arm_x - arm.x;                      // the left arm's outer edge
rboss = [r_arm.x + arm.x / 2, r_arm.y + arm.y / 2];   // the arms' screw bosses at their back ends
lboss = [l_arm_x - arm.x / 2, 0];
x_rpin = [x_ra1 - pin_drum, x_ra1];           // drum pins, flush with the arms' outsides
x_lpin = [x_la0, x_la0 + pin_drum];
x_fdisc = x_fr - face_disc_t;                 // the bevel gear's disc, inside
mot = [drive_a, -drive_a];                    // shafts: roll motor (right), pitch motor (left)
mot_c = [for (x = mot) x - sign(x) * motor_shaft_dy];  // bodies, over the axis
ai_ears = [for (c = mot_c, s = [-1, 1]) [c, s * motor_ear_dx]];
sensors = [[drive_a + mag_r, 0], [-drive_a - mag_r, 0]];   // roll (on its post), pitch (in the back plate)
y_sensor = [y_pg0, y_bk0];                    // their pockets' fronts
posts = [for (sx = [-1, 1], sz = [-1, 1]) [sx * post_xz.x, sz * post_xz.y]];
y_cr0 = y_bk1 + motor_flange_t + motor_h + 1; // carrier plate, the boards behind it
y_cr1 = y_cr0 + car_t;
ai_uln_holes = [for (b = uln_xz, i = [0, 1], j = [0, 1])
   [b.x + uln_hole_in + i * (uln_board.x - 2 * uln_hole_in), b.y + uln_hole_in + j * (uln_board.y - 2 * uln_hole_in)]];
leg_r = sleeve_id / 2 + 0.2;                  // legs: their inside (the outside the sleeve's)
strip_len = 2 * PI * (drum_r + paper_t / 2);
ai_depth = y_cr1 + max(uln_standoff + nano_t + uln_parts, nano_under + nano_t + nano_usb[1]) - y_sheet1;

echo(ai_depth = ai_depth, case_depth = y_bk1 - y_sheet1, drum_axis = y_drum, roll_r = roll_r, strip_len = strip_len,
     pitch_mm_per_10 = drum_rp * sin(10 * pitch_k));

// --- Checks ---
// the front
assert(y_plane0 >= y_glass1 + 0.3, "Airplane against the glass");
assert(index_t <= y_rface - 0.6 - y_ring0, "Bank index runs into the dial");
assert(ring_id / 2 < window_d / 2 && ring_id / 2 <= roll_r - 0.4, "The ring must hide the dial's rim and hold it");
assert(face_r <= ring_id / 2 - 0.15 && face_r >= window_d / 2 - 1, "Dial face edge shows or is covered");
assert(mark_r1 <= face_r - 0.3 && index_tip <= mark_r1 - 1, "Bank marks off the face or not under the index");
assert(mark_r1 - mark_len[1] >= vis_r + 3, "Bank marks into the window");
assert(-mask_z + 1 <= vis_r && -mask_z >= dot_d / 2 + 10, "Mask over the horizon or not over the window's bottom");
assert(norm([wing[1], wing[2] / 2]) <= vis_r + 3 && wing[0] >= dot_d / 2 + 1, "Wings");
assert(abs(knob_z) - knob[0] / 2 >= -mask_z + 1 && abs(knob_z) + knob[0] / 2 <= window_d / 2 - 0.5, "Knob off the mask");
assert(foot_r <= sleeve_od / 2 - 1, "Mask's foot through the ring");
// drum
assert(drum_half >= vis_r + 1 && drum_r >= vis_r + 2, "Drum does not fill the dial's window");
assert(norm([drum_half, drum_rp]) <= roll_r - 1, "Drum does not turn in the sleeve");
assert(drum_half + 1.5 <= r_arm.x && drum_half + 1.5 <= -l_arm_x, "Drum runs into an arm");
assert(z_sun * z_pinion == z_planet * z_face, "Drum is not 1:1 with the pitch axle (homing)");
assert(xc - pin_d / 2 - 0.5 >= drum_half, "Planet shaft runs into the drum");
assert(norm([y_pin1 - y_drum, ra_pinion * pin_s[1]]) <= drum_r - shell_t - 1, "Pinion runs into the drum's shell");
assert(r_f[0] <= y_pin0 - y_drum - 0.4 && r_f[1] >= y_pin1 - y_drum + 0.4, "Drum's gear's teeth narrower than the pinion");
assert(r_f[1] <= drum_r - shell_t - rib - 0.5, "Drum's gear's teeth on the rib");
assert(x_tip(r_f[0]) <= drum_half && x_root(r_f[0]) - x_fr >= 0, "Drum's gear's teeth out of the drum");
assert(face_hub[0] / 2 + 1 <= y_fb0 - y_drum, "Bevel gear's hub runs into the front boss");
assert(x_fr + face_hub[1] <= x_ra1 - 1, "Bevel gear's hub runs into the right arm");
assert(xc - fboss_d / 2 >= x_tip(r_f[0]) + 0.3 || y_fb1 - y_drum + 0.3 <= r_f[0] - fboss_d / 2,
       "Front boss runs into the drum's gear's teeth");
assert(norm([y_fb1 - y_drum, fboss_d / 2]) <= drum_r - shell_t - 1, "Front boss runs into the drum's shell");
assert(y_fb0 - y_drum >= 4 + 1, "Front boss runs into the drum's axle boss");
assert(y_s0 >= y_drum + drum_rp + 0.5, "Sun and planet run into the drum");
// roll frame
assert(xc + ra_planet + 1 <= roll_r, "Planet off the roll frame");
assert(norm([x_ra1, r_arm.y + arm.y]) <= roll_r - 1 && x_la0 >= -roll_r + 2, "Arms off the roll frame");
assert(r_arm.y >= ra_pinion * pin_s[1] + 0.8 && norm([r_arm.x, r_arm.y] - [xc, 0]) >= ra_planet + 0.5, "Right arm runs into the pinion or the planet");
assert(norm(rboss - [xc, 0]) >= ra_planet + boss_d / 2 + 0.5 && norm(rboss) + boss_d / 2 <= roll_r - 1, "Right screw boss");
assert(norm(lboss) - boss_d / 2 >= ra_sun + 0.5 && -l_arm_x >= ra_sun + 1, "Left arm runs into the sun");
assert(norm([r_arm.x, r_arm.y]) >= ra_sun + 1, "Right arm runs into the sun");
assert(x_rpin[0] <= x_fdisc - 4 && x_lpin[1] >= -drum_half + end_t + 4, "Drum pins too short in the hubs");
assert(y_pl0 >= y_fb0 && y_pl0 <= y_fb1 - 2.5, "Planet shaft does not end in the front boss");
assert(y_ax0 >= y_s0 && y_ax0 <= y_s0 + 2, "Pitch axle does not reach through the sun");
assert(rtube_d[1] >= sun_hub_d + 0.3 && rtube_d[0] / 2 <= gear_rf - 1, "Roll tube");
assert(pitch_hub_d / 2 <= rtube_d[0] / 2, "Pitch gear's hub off the roll tube's end");
// motors and gears behind it
assert(y_mshaft <= y_pg0 && y_mshaft + flat_len >= y_pg1 - 0.5, "Pitch motor's shaft does not reach through its gear");
assert(y_bk0 - y_mshaft >= 5, "Roll motor's shaft too short in its gear");
assert(drive_a - hub1_d / 2 - gear_ra >= 0.8, "Roll motor gear's hub runs into the pitch gear");
assert(mag_r - spost.x / 2 >= hub1_d / 2 + 0.5 && drive_a + mag_r - spost.x / 2 >= gear_ra + 1, "Roll sensor's post runs into a gear");
assert(norm([drive_a + mag_r + spost.x / 2, spost.y / 2]) <= bore_d / 2 - 0.3, "Roll sensor's post off the bore");
assert(spost.y >= sensor.z + 2 && spost.x >= sensor.x + 0.8, "Roll sensor's post too small");
assert(drive_a - shaft_d / 2 >= gear_ra + 1, "Pitch motor's shaft runs into the roll gear");
assert(drive_a - motor_shaft_dy - motor_d / 2 >= 1 && drive_a - motor_shaft_dy - motor_cover[1] >= 0.5, "Motors run into each other");
for (a = leg_angles) for (x = mot) {
   assert(norm(pol(leg_r + sleeve_wall / 2, a) - [x, 0]) >= gear_ra + 1 + leg_w / 2 + 1, "A leg runs into a motor gear");
   assert(min([for (e = ai_ears) norm(pol(leg_r + sleeve_wall / 2, a) - e)]) >= csk_d / 2 + leg_w / 2, "A leg on a motor ear screw");
}
for (e = ai_ears) {
   assert(norm(e) + csk_d / 2 <= bore_d / 2 - 1, "Motor ear screw off the back plate");
   assert(norm(e) >= gear_ra + csk_d / 2 + 0.5 && norm(e - [-drive_a, 0]) >= gear_ra + csk_d / 2 + 0.5
          && norm(e - [drive_a, 0]) >= hub1_d / 2 + csk_d / 2 + 0.5, "Motor ear screw head under a gear");
}
for (i = [0, 1]) let(s = sensors[i], c = [mot_c[i], 0]) {
   assert(norm(s - c) >= motor_d / 2 + 2 && min([for (e = ai_ears) norm(s - e)]) >= nut[0] / 2 + sensor.x / 2 + 2, "Sensor's legs run into a motor");
   assert(norm(s) + sensor.z / 2 + 1 <= bore_d / 2, "Sensor off the back plate");
}
for (c = cols) assert(norm(c - [drive_a, 0]) >= gear_ra + ear_d / 2 + 1 && norm(c + [drive_a, 0]) >= gear_ra + ear_d / 2 + 1,
                      "A case column runs into a motor gear");
assert(drive_a + gear_ra + 1 + wall <= case_r + 1.5, "Motor gear bulges out of the case");
// carrier
for (p = posts) {
   assert(min([for (c = mot_c) norm(p - [c, 0])]) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into a motor");
   assert(min([for (e = ai_ears) norm(p - e)]) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
   assert(abs(p.y) - car_post_d / 2 >= motor_cover[0] / 2 + 0.5, "A carrier post runs into a motor's cover");
   assert(min([for (s = sensors) norm(p - s)]) >= car_post_d / 2 + sensor.x / 2 + 1.5, "A carrier post runs into a sensor's legs");
   assert(norm(p) + car_post_d / 2 <= case_r, "A carrier post off the back plate");
   assert(min([for (h = ai_uln_holes) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
}
for (b = uln_xz) assert(b.x >= car_box[0] + 1 && b.x + uln_board.x <= car_box[2] - 1 && b.y >= car_box[1] + 1 && b.y + uln_board.y <= car_box[3] - 1,
                        "ULN2003 board off the carrier");
assert(uln_xz[0].x >= 1 && uln_xz[1].x + uln_board.x <= -1, "ULN2003 boards overlap");
assert(nano_xz.y + nano_board.x + 2 <= min([for (b = uln_xz) b.y]) && nano_xz.y >= car_box[1] + 2 && nano_xz.x >= car_box[0] + 1
       && nano_xz.x + nano_board.y + 2 <= car_box[2], "Nano off the carrier or under a ULN2003 board");
// the Nano's stop at its right end, off the screw heads
assert(min([for (p = posts) p.x > 0 && p.y < 0 ? p.x - csk_d / 2 - (nano_xz.x + nano_board.y + 1.7) : 99]) >= 0.3, "Nano's stop on a carrier screw");
assert(max(abs(car_box[0]), car_box[2]) <= inst_pitch.x / 2 - 1 && max(abs(car_box[1]), car_box[3]) <= inst_pitch.y / 2 - 1,
       "Board carrier runs into the next instrument");

// --- Helpers ---
// a 2D shape in the drum's frame (along its axis: x, round it: s) is drawn
// with drum_frame(): local z along the drum's axis (world x), local x up
module drum_frame() {
   translate([0, y_drum, 0]) rotate([0, 90, 0]) children();
}

// shell sector round the drum's axis (local frame), s0..s1 from the front upwards, along the axis x0..x1
module drum_sector(r0, r1, s0, s1, x0, x1) {
   rotate([0, 0, 270 - s1]) rotate_extrude(angle = s1 - s0, $fn = 180) translate([r0, x0]) square([r1 - r0, x1 - x0]);
}

// Spur gear cut by a rolling rack (20 degrees, play thins the teeth): undercut
// where it needs it, so the small pitch gears mesh with each other and
// with the drum's gear (rack teeth); a tooth at 0 like gear_2d()
module rack_gear_2d(z, m = gm, play = gear_play) {
   rp = m * z / 2;
   p = PI * m;
   function hw(x) = p / 4 + play / 2 + (x - rp) * tan(20);   // the cutter's tooth
   x0 = rp - 1.25 * m;
   x1 = rp + m + 1;
   step = 90 / z / 4;
   rotate(180 / z) difference() {
      circle(r = rp + m, $fn = 8 * z);
      for (k = [0 : z - 1]) rotate(k * 360 / z)
         for (i = [-12 : 11]) hull() for (j = [i, i + 1]) let(a = j * step)
            rotate(-a) translate([0, rp * a * PI / 180]) polygon([[x0, -hw(x0)], [x1, -hw(x1)], [x1, hw(x1)], [x0, hw(x0)]]);
   }
}

// the drum's bevel gear's teeth in its local frame (z along the drum's axis = world x), pointing +z,
// on the pitch cone x_pitch(): straight teeth from r0 to r1, every size in proportion to r
// (the distance from the apex), the root cone under them
module bevel_teeth(z, m, r0, r1, play = gear_play) {
   rc = m * z / 2;
   h = 2.25 * m;
   function hw(t) = PI * m / 4 - play / 2 + (1.25 * m - t) * tan(20);
   prof = [[-hw(0) - 0.3, -0.3], [hw(0) + 0.3, -0.3], [hw(0), 0], [hw(h), h], [-hw(h), h], [-hw(0), 0]];
   for (k = [0 : z - 1]) rotate([0, 0, k * 360 / z]) hull()
      for (r = [r0, r1]) translate([r, 0, x_root(r)]) rotate([90, 0, 90]) linear_extrude(0.01) scale(r / rc) polygon(prof);
   rotate_extrude($fn = 4 * z) polygon([[r0, x_fr - 0.01], [r0, x_root(r0)], [r1, x_root(r1)], [r1, x_fr - 0.01]]);
}

// --- Case: the standard's front, longer, the motor gears' pockets on both sides ---
module ai_case_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (i = [0 : 3]) translate(cols[i]) circle(d = ear_d);
   }
   for (s = [-1, 1]) hull() {
      circle(d = case_d, $fn = 180);
      translate([s * drive_a, 0]) circle(r = arm_r, $fn = 120);
      for (c = cols) if (s * c.x > 0) translate(c) circle(d = ear_d);
   }
}

module ai_case() {
   difference() {
      union() {
         along_y(0, y_sheet1) circle(d = tube_d, $fn = 180);
         along_y(y_sheet1, y_bk0) ai_case_outline();
      }
      along_y(-1, y_glass0 + 0.01) circle(d = window_d, $fn = 180);
      along_y(y_glass0, y_bk0 + 1) circle(d = bore_d, $fn = 180);
      // the motor gears, a 45 degree roof towards the front (printed back side down)
      for (x = mot) hull() {
         along_y(y_b1, y_bk0 + 1) translate([x, 0]) circle(r = gear_ra + 1, $fn = 120);
         along_y(y_b1 - 3, y_b1) translate([x, 0]) circle(r = gear_ra + 1 - 3, $fn = 120);
      }
      for (i = [0 : len(cols) - 1]) {
         c = cols[i];
         if (i < 4) translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = front_screw - sheet_t + 1);
         translate([c.x, y_bk0 + 0.01, c.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - back_t + 1);
      }
   }
}

// --- Sleeve: the ring behind the glass (the bank index on it), the tube the roll frame turns in, legs to the back plate ---
module ai_sleeve() {
   difference() {
      union() {
         along_y(y_ring0, y_ring1) difference() {
            circle(d = sleeve_od, $fn = 180);
            circle(d = ring_id, $fn = 180);
         }
         along_y(y_ring1 - 0.01, y_b1) difference() {
            circle(d = sleeve_od, $fn = 180);
            circle(d = sleeve_id, $fn = 180);
         }
         for (a = leg_angles) along_y(y_b1 - 0.01, y_bk0) intersection() {
            difference() {
               circle(d = sleeve_od, $fn = 180);
               circle(r = leg_r, $fn = 180);
            }
            rotate(-a) translate([-leg_w / 2, 0]) square([leg_w, sleeve_od]);
         }
         // the bank index, pointing down at the dial's marks
         along_y(y_ring0, y_ring0 + index_t) polygon([[0, index_tip], [-index_w / 2, ring_id / 2 + 0.5], [index_w / 2, ring_id / 2 + 0.5]]);
      }
      // the mask's edge, from behind
      along_y(y_plane0, y_ring1 + 1) intersection() {
         circle(r = foot_r + 0.15, $fn = 180);
         translate([-50, mask_z + 0.15 - 50]) square(50 * [2, 1]);
      }
   }
}

// --- Airplane: the wing bars and the dot on a black mount, the mask over the window's bottom ---
// one flat part, printed black; paint the wings and the dot orange
module wings_2d() {
   circle(d = dot_d);
   for (s = [-1, 1]) translate([s > 0 ? wing[0] : -wing[1], -wing[2] / 2]) square([wing[1] - wing[0], wing[2]]);
}

module plane_2d() {
   wings_2d();
   // the mount: from under the dot down to the mask
   polygon([[-mount_w[0] / 2, -dot_d / 2 + 0.5], [mount_w[0] / 2, -dot_d / 2 + 0.5], [mount_w[1] / 2, mask_z + 0.1], [-mount_w[1] / 2, mask_z + 0.1]]);
   // the mask, its edge in the ring's notch
   intersection() {
      circle(r = foot_r, $fn = 180);
      translate([-50, mask_z - 50]) square(50 * [2, 1]);
   }
}

module ai_plane() {
   difference() {
      along_y(y_plane0, y_plane1) plane_2d();
      along_y(y_plane0 - 1, y_plane1 + 1) translate([0, knob_z]) circle(d = knob_pin - 0.1);
   }
}

// the dummy knob (the real one sets the airplane's height): knurled, in front of the glass, its stem through the glass into the mask
module ai_knob() {
   translate([0, 0, knob_z]) {
      difference() {
         along_y(y_glass0 - knob[1], y_glass0 - 0.2) circle(d = knob[0], $fn = 60);
         for (a = [0 : 20 : 340]) rotate([0, a, 0]) translate([knob[0] / 2, y_glass0 - knob[1] - 1, 0]) rotate([-90, 0, 0])
            cylinder(d = knob[2] * 1.6, h = knob[1] + 2, $fn = 12);
      }
      along_y(y_glass0 - 0.21, y_plane1 - 0.2) circle(d = knob_pin);
   }
}

// --- Roll frame: the dial with the arms ---
module ai_roll_dial() {
   difference() {
      union() {
         along_y(y_rd0, y_rd1) difference() {
            circle(r = roll_r, $fn = 180);
            circle(r = vis_r, $fn = 120);
         }
         // arms
         along_y(y_rd1 - 0.01, y_b0) {
            translate([r_arm.x, r_arm.y]) square(arm);
            translate([x_la0, -arm.y / 2]) square(arm);
         }
         // the drum's bearings
         translate([r_arm.x, y_drum - 4, -4]) cube([arm.x, 8, r_arm.y + arm.y + 4]);
         translate([x_la0, y_drum - 4, -4]) cube([arm.x, 8, 8]);
         // the planet shaft's front boss, joined to the right arm
         along_y(y_fb0, y_fb1) hull() {
            translate([xc, 0]) circle(d = fboss_d);
            translate([r_arm.x, r_arm.y]) square(arm);
         }
         // the screw bosses at the arms' back ends
         for (b = [rboss, lboss]) along_y(y_b0 - 8, y_b0) translate(b) circle(d = boss_d);
      }
      for (x = [x_rpin, x_lpin]) translate([x[0] - 1, y_drum, 0]) rotate([0, 90, 0]) cylinder(d = run_d, h = x[1] - x[0] + 2);
      along_y(y_fb0 - 1, y_fb1 + 1) translate([xc, 0]) circle(d = run_d);
      for (b = [rboss, lboss]) translate([b.x, y_b0 + 0.01, b.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - bd_t + 1);
   }
}

// --- Roll frame: the back disc with its tube and the roll gear ---
module ai_roll_back() {
   difference() {
      union() {
         along_y(y_b0, y_b1) circle(r = roll_r, $fn = 180);
         along_y(y_b1 - 0.01, y_rg1) rotate(gear_z % 2 == 0 ? 0 : 0) gear_2d(gear_z);
      }
      along_y(y_b0 - 1, y_rg1 + 1) circle(d = rtube_d[1]);
      along_y(y_b0 - 1, y_b1 + 1) translate([xc, 0]) circle(d = run_d);
      for (b = [rboss, lboss]) translate([b.x, y_b1, b.y]) rotate([-90, 0, 0]) csk_hole();
      // weight: windows between the arms
      along_y(y_b0 - 1, y_b1 + 1) difference() {
         circle(r = roll_r - 3, $fn = 120);
         circle(r = max(gear_ra, ra_sun) + 1);
         translate([xc, 0]) circle(d = boss_d + 2);
         for (b = [rboss, lboss]) translate(b) circle(d = csk_d + 3);
         for (a = [0 : 60 : 300]) rotate(a) translate([0, -2]) square([roll_r, 4]);
      }
   }
}

// --- Drum: the shell with its left end and hub, the rib the bevel gear sits on ---
module ai_drum() {
   ri = drum_r - shell_t;
   drum_frame() difference() {
      union() {
         rotate_extrude($fn = 180) polygon([[ri, -drum_half], [drum_r, -drum_half], [drum_r, drum_half], [ri, drum_half],
                                            [ri, x_fdisc], [ri - rib, x_fdisc], [ri - rib, x_fdisc - 0.5], [ri, x_fdisc - 0.5 - rib]]);
         translate([0, 0, -drum_half]) cylinder(r = ri + 0.01, h = end_t, $fn = 180);
         translate([0, 0, -drum_half]) cylinder(d = drum_hub_d, h = x_lpin[1] - 0.5 + drum_half);
      }
      translate([0, 0, x_lpin[0] - 1]) cylinder(d = press_d, h = x_lpin[1] - x_lpin[0] + 1);
   }
}

// --- The drum's bevel gear: a disc pressed into its right end, teeth outwards, the pin's hub ---
module ai_drum_gear() {
   ri = drum_r - shell_t;
   drum_frame() difference() {
      union() {
         translate([0, 0, x_fdisc]) cylinder(r = ri - 0.1, h = face_disc_t, $fn = 180);
         bevel_teeth(z_face, gm, r_f[0], r_f[1]);
         translate([0, 0, x_fr - 0.01]) cylinder(d = face_hub[0], h = face_hub[1] + 0.01);
      }
      translate([0, 0, x_fdisc - 1]) cylinder(d = press_d, h = face_disc_t + face_hub[1] + 2);
   }
}

// --- Pitch gears ---
module ai_sun() {
   difference() {
      union() {
         along_y(y_s0, y_s1) rack_gear_2d(z_sun);
         along_y(y_s1 - 0.01, y_rg1) circle(d = sun_hub_d);
      }
      along_y(y_s0 - 1, y_rg1 + 1) circle(d = press_d);
   }
}

module ai_planet() {
   translate([xc, 0, 0]) difference() {
      along_y(y_s0, y_s1) rotate(z_planet % 2 == 0 ? 180 / z_planet : 0) rack_gear_2d(z_planet);
      along_y(y_s0 - 1, y_s1 + 1) circle(d = press_d);
   }
}

module ai_pinion() {
   translate([xc, 0, 0]) difference() {
      // a bevel gear: the teeth in proportion to the distance from the apex (the drum's axis)
      translate([0, y_pin1, 0]) rotate([90, 0, 0]) linear_extrude(pinion_w, scale = pin_s[0] / pin_s[1]) scale(pin_s[1]) rotate(180 / z_pinion) rack_gear_2d(z_pinion);
      along_y(y_pin0 - 1, y_pin1 + 1) circle(d = press_d);
   }
}

module ai_pitch_gear() {
   difference() {
      union() {
         along_y(y_pg0, y_pg1) gear_2d(gear_z);
         along_y(y_rg1 + 0.1, y_pg0 + 0.01) circle(d = pitch_hub_d);
      }
      along_y(y_rg1, y_pg1 + 1) circle(d = press_d);
   }
}

// the motor gears: shaft bore on the flats, the magnet in the back face
module motor_bore(y0, y1) {
   translate([0, y1 + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y1 + 1 - y0);
}

module magnet_pocket(r, y1) {
   translate([r, y1 + 0.01, 0]) rotate([90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
}

// the roll motor's: its teeth level with the roll gear (the magnet in their back face, over the sensor's post), a hub behind them on the shaft
module ai_roll_motor_gear() {
   translate([drive_a, 0, 0]) difference() {
      union() {
         along_y(y_rg0, y_rg1) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
         along_y(y_rg1 - 0.01, y_pg1) circle(d = hub1_d);
      }
      motor_bore(y_mshaft - 0.5, y_pg1);
      magnet_pocket(mag_r, y_rg1);
   }
}

// the pitch motor's, the standard's: left of the axis, its magnet away from the motor's body
module ai_pitch_motor_gear() {
   translate([-drive_a, 0, 0]) difference() {
      along_y(y_pg0, y_pg1) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
      motor_bore(y_pg0, y_pg1);
      mirror([1, 0, 0]) magnet_pocket(mag_r, y_pg1);
   }
}

// --- Back plate: the pitch axle's bearing, both motors and sensors, the carrier's posts ---
module ai_back_plate() {
   difference() {
      union() {
         along_y(y_bk0, y_bk1) ai_case_outline();
         for (p = posts) along_y(y_bk1 - 0.01, y_cr0) translate(p) circle(d = car_post_d);
         along_y(y_sensor[0], y_bk0 + 0.01) translate(sensors[0] - spost / 2) square(spost);
      }
      translate([0, y_bk0 - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = pin_d + 0.1, h = back_t - 0.8);
      for (c = cols) translate([c.x, y_bk1, c.y]) rotate([-90, 0, 0]) csk_hole();
      for (x = mot) translate([x, y_bk0 - 1, 0]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
      for (e = ai_ears) translate([e.x, y_bk0, e.y]) rotate([90, 0, 0]) csk_hole();
      // sensors: flat face forward in a pocket, the legs through a slot to the back
      for (i = [0, 1]) let(s = sensors[i], f = y_sensor[i]) {
         translate([s.x - sensor.x / 2 - 0.15, f - 0.01, s.y - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.01, sensor.z + 0.3]);
         translate([s.x - sensor.x / 2 - 0.15, f - 1, s.y + sensor.z / 2 - 1]) cube([sensor.x + 0.3, y_bk1 - f + 2, 2.5]);
      }
      for (p = posts) translate([p.x, y_cr0 + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - car_t + 1);
   }
}

// --- Board carrier: a plate on the posts, the two ULN2003 boards and the Nano behind it (facing back) ---
module ai_carrier() {
   difference() {
      union() {
         along_y(y_cr0, y_cr1) translate([car_box[0], car_box[1]]) square([car_box[2] - car_box[0], car_box[3] - car_box[1]]);
         for (h = ai_uln_holes) translate([h.x, y_cr1 - 0.01, h.y]) rotate([-90, 0, 0]) cylinder(d = 6, h = uln_standoff + 0.01);
         // Nano rails along x: a ledge under each long edge, a lip over it, a stop at the right end
         nz = [nano_xz.y - 0.1, nano_xz.y + nano_board.x + 0.1];
         x0 = nano_xz.x - 1;
         l = nano_board.y + 2;
         for (i = [0, 1]) let(zo = nz[i], s = i == 0 ? -1 : 1) {
            translate([x0, y_cr1 - 0.01, s > 0 ? zo : zo - rail_w]) cube([l, nano_under + nano_t + 0.8 + 0.01, rail_w]);
            translate([x0, y_cr1 - 0.01, s > 0 ? zo - 1.2 : zo]) cube([l, nano_under + 0.01, 1.2]);
            translate([x0, y_cr1 + nano_under + nano_t + 0.1, s > 0 ? zo - 0.8 : zo]) cube([l, 0.7, 0.8 + 0.01]);
         }
         translate([nano_xz.x + nano_board.y + 0.1, y_cr1 - 0.01, nz[0]]) cube([1.5, nano_under + nano_t + 0.01, nz[1] - nz[0]]);
      }
      for (h = ai_uln_holes) translate([h.x, y_cr1 - 1, h.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = uln_standoff + 2);
      for (p = posts) translate([p.x, y_cr1, p.y]) rotate([-90, 0, 0]) csk_hole();
   }
}

// --- Prints ---
// the roll dial's face, 2D (x right, y up, the axis at the origin, level)
module ai_face_2d() {
   ink(c_sky) arc_2d(vis_r, face_r, -90, 90);
   ink(c_ground) arc_2d(vis_r, face_r, 90, 270);
   ink(c_white) {
      for (a = [90, 270]) tick_2d(a, vis_r, face_r, horizon_w);
      for (s = [-1, 1]) {
         for (a = bank_short) tick_2d(s * a, mark_r1 - mark_len[0], mark_r1, mark_w[0]);
         for (a = bank_long) tick_2d(s * a, mark_r1 - mark_len[1], mark_r1, mark_w[1]);
         for (a = ground_lines) tick_2d(s * (90 + a), vis_r, face_r, ground_w);
      }
   }
}

// the drum's strip, 2D: x round the drum (0 the horizon, sky to the right), y along its axis
module ai_strip_2d() {
   function u(p) = (drum_r + paper_t / 2) * pitch_k * p * PI / 180;
   ink(c_sky) translate([0, -drum_half]) square([strip_len / 2, 2 * drum_half]);
   ink(c_ground) translate([-strip_len / 2, -drum_half]) square([strip_len / 2, 2 * drum_half]);
   ink(c_white) {
      translate([-horizon_w / 2, -drum_half]) square([horizon_w, 2 * drum_half]);
      for (l = pitch_lines, s = [-1, 1]) translate([s * u(l[0]) - line_w / 2, -l[1] / 2]) square([line_w, l[1]]);
   }
}

// pages: the cut outlines and the caption in black, registration dots in every layer
module ai_face_print() {
   d = 2 * face_r;
   step = d + print_gap;
   w = 2 * step + glass_d;
   for (i = [0, 1]) translate([i * step, 0]) ai_face_2d();
   ink(c_black) {
      for (i = [0, 1]) translate([i * step, 0]) difference() {
         circle(r = face_r + 0.4, $fn = 180);
         circle(r = face_r, $fn = 180);
      }
      translate([2 * step + glass_d / 2 - face_r, 0]) {
         difference() {
            circle(d = glass_d + 0.6, $fn = 180);
            circle(d = glass_d, $fn = 180);
         }
         // the knob's hole (anywhere at this radius)
         translate([0, knob_z]) difference() {
            circle(d = knob_pin + 0.9);
            circle(d = knob_pin + 0.4);
         }
      }
      translate([-face_r, -face_r - 8])
         text(str("AI: roll dial ", d, " mm (cut the outside on the line's inside, the window on the colours' edge),"), size = 3, font = font);
      translate([-face_r, -face_r - 13])
         text(str("glass ", glass_d, " mm with a ", knob_pin + 0.4, " mm hole for the knob; print at 100 %"), size = 3, font = font);
   }
   for (x = [-face_r - 2, w - face_r + 2], y = [-face_r - 16, glass_d / 2 + 2]) translate([x, y]) square(0.1, center = true);
}

module ai_drum_print() {
   step = 2 * drum_half + print_gap;
   for (i = [0, 1]) translate([0, i * step]) ai_strip_2d();
   ink(c_black) translate([-strip_len / 2, -drum_half - 8])
      text(str("AI: drum strip ", round(strip_len * 10) / 10, " x ", 2 * drum_half,
               " mm, sky up, the horizon at the drum's front; print at 100 %"), size = 3, font = font);
   for (x = [-strip_len / 2 - 2, strip_len / 2 + 2], y = [-drum_half - 11, step + drum_half + 2]) translate([x, y]) square(0.1, center = true);
}

// --- View only ---
module pin_part(p0, p1) {
   color(c_steel) hull() for (p = [p0, p1]) translate(p) sphere(d = pin_d, $fn = 16);
}

module ai_face_part() {
   for (i = [0 : len(face_colors) - 1])
      color(face_colors[i]) translate([0, y_rface + 0.2 - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = face_colors[i]) ai_face_2d();
}

// the strip on the drum, in the drum's frame
module ai_strip_part() {
   da = 180 / PI / drum_r;   // degrees per mm
   color(c_sky) drum_sector(drum_r, drum_rp, 0, 180, -drum_half, drum_half);
   color(c_ground) drum_sector(drum_r, drum_rp, -180, 0, -drum_half, drum_half);
   color(c_white) {
      drum_sector(drum_rp, drum_rp + 0.05, -horizon_w / 2 * da, horizon_w / 2 * da, -drum_half, drum_half);
      for (l = pitch_lines, s = [-1, 1]) let(a = s * l[0] * pitch_k)
         drum_sector(drum_rp, drum_rp + 0.05, a - line_w / 2 * da, a + line_w / 2 * da, -l[1] / 2, l[1] / 2);
   }
}

module ai_motor_part(i) {
   if (i == 0) translate([drive_a, y_bk1, 0]) rotate([0, 180, 0]) rotate([0, 90, 0]) rotate([90, 0, 0]) motor_local();
   else mirror([1, 0, 0]) ai_motor_part(0);
}

module ai_boards_part() {
   for (b = uln_xz) translate([b.x, y_cr1 + uln_standoff, b.y]) {
      color(c_uln) cube([uln_board.x, nano_t, uln_board.y]);
      color("#202020") translate([8, nano_t, 6]) cube([19, 6, 7]);
      color("#f0f0f0") translate([7, nano_t, uln_board.y - 9]) cube([12, 7, 6]);
   }
   translate([nano_xz.x, y_cr1 + nano_under, nano_xz.y]) {
      color(c_board) cube([nano_board.y, nano_t, nano_board.x]);
      color("#202020") translate([20, nano_t, nano_board.x / 2 - 3.5]) cube([7, 1.2, 7]);
      color(c_steel) translate([-1, nano_t, nano_board.x / 2 - nano_usb[0] / 2]) cube([9, nano_usb[1], nano_usb[0]]);
   }
}

module ai_sensors_part() {
   color("#202020") for (i = [0, 1]) let(s = sensors[i]) translate([s.x - sensor.x / 2, y_sensor[i], s.y - sensor.z / 2]) cube([sensor.x, sensor.y, sensor.z]);
}

// the roll frame and what turns with it, at bank r (right wing down) and pitch p (nose up)
module ai_roll_parts(r, p) {
   rotate([0, -r, 0]) {
      color(c_case) ai_roll_dial();
      ai_face_part();
      color(c_case) ai_roll_back();
      translate([0, y_drum, 0]) rotate([pitch_k * p, 0, 0]) translate([0, -y_drum, 0]) {
         color(c_case) ai_drum();
         color(c_case) render() ai_drum_gear();
         drum_frame() ai_strip_part();
      }
      // planet and pinion turn with the drum (1:1 through the bevel gear: z_face / z_pinion)
      let(pa = pitch_k * p * z_face / z_pinion) translate([xc, 0, 0]) rotate([0, pa, 0]) translate([-xc, 0, 0]) {
         color(c_case) render() ai_planet();
         color(c_case) render() ai_pinion();
      }
      pin_part([x_rpin[0], y_drum, 0], [x_rpin[1], y_drum, 0]);
      pin_part([x_lpin[0], y_drum, 0], [x_lpin[1], y_drum, 0]);
      pin_part([xc, y_pl0, 0], [xc, y_pl1, 0]);
   }
}

// the pitch axle turns by the roll plus the drum's turn
module ai_axle_parts(r, p) {
   rotate([0, -r - pitch_k * p, 0]) {
      color(c_case) render() ai_sun();
      color(c_case) render() ai_pitch_gear();
      pin_part([0, y_ax0, 0], [0, y_ax1, 0]);
   }
}

module ai_parts(r = view_roll, p = view_pitch, e = 0, with_case = true, with_sleeve = true) {
   if (with_case) color(c_case) render() ai_case();
   translate([0, -3.4 * e, 0]) {
      if (with_sleeve) color(c_case) render() ai_sleeve();
      color(c_case) ai_plane();
      color(c_plane) translate([0, y_plane0 - 0.02, 0]) rotate([90, 0, 0]) linear_extrude(0.01) wings_2d();
      color(c_plane) translate([0, y_ring0 - 0.02, 0]) rotate([90, 0, 0]) linear_extrude(0.01)
         polygon([[0, index_tip], [-index_w / 2, ring_id / 2 + 0.5], [index_w / 2, ring_id / 2 + 0.5]]);
   }
   ai_roll_parts(r, p);
   ai_axle_parts(r, p);
   translate([0, 0.6 * e, 0]) {
      color(c_case) render() ai_roll_motor_gear();
      color(c_case) render() ai_pitch_motor_gear();
   }
   translate([0, 1.2 * e, 0]) {
      color(c_case) ai_back_plate();
      ai_motor_part(0);
      ai_motor_part(1);
      ai_sensors_part();
   }
   translate([0, 2 * e, 0]) {
      color(c_case) ai_carrier();
      ai_boards_part();
   }
   if (with_case) {
      color(c_case) ai_knob();
      color(c_glass) along_y(y_glass0, y_glass1) difference() {
         circle(d = glass_d, $fn = 180);
         translate([0, knob_z]) circle(d = knob_pin + 0.4);
      }
   }
}

module assembled_view() {
   sheet_part(150, 120, -75);
   ai_parts();
}

module exploded_view() {
   ai_parts(e = explode, with_case = false);
}

module inside_view() {
   ai_parts(with_case = false, with_sleeve = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i]) {
      rotate(-view_roll) ai_face_2d();
      translate([face_r + 10 + strip_len / 2, 0]) ai_strip_2d();
   }
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_bk0]) rotate([-90, 0, 0]) ai_case(); // Make module case
translate([0, 0, -y_ring0]) rotate([90, 0, 0]) ai_sleeve(); // Make module sleeve
translate([0, 0, -y_plane0]) rotate([90, 0, 0]) ai_plane(); // Make module plane
translate([0, 0, -(y_glass0 - knob[1])]) rotate([90, 0, 0]) translate([0, 0, -knob_z]) ai_knob(); // Make module knob
translate([0, 0, -y_rd0]) rotate([90, 0, 0]) ai_roll_dial(); // Make module roll_dial
translate([0, 0, -y_b0]) rotate([90, 0, 0]) ai_roll_back(); // Make module roll_back
translate([0, 0, drum_half]) rotate([0, -90, 0]) translate([0, -y_drum, 0]) ai_drum(); // Make module drum
translate([0, 0, -x_fdisc]) rotate([0, -90, 0]) translate([0, -y_drum, 0]) ai_drum_gear(); // Make module drum_gear
translate([0, 0, -y_s0]) rotate([90, 0, 0]) ai_sun(); // Make module sun
translate([0, 0, -y_s0]) rotate([90, 0, 0]) translate([-xc, 0, 0]) ai_planet(); // Make module planet
translate([0, 0, -y_pin0]) rotate([90, 0, 0]) translate([-xc, 0, 0]) ai_pinion(); // Make module pinion
translate([0, 0, y_pg1]) rotate([-90, 0, 0]) ai_pitch_gear(); // Make module pitch_gear
translate([0, 0, -y_rg0]) rotate([90, 0, 0]) translate([-drive_a, 0, 0]) ai_roll_motor_gear(); // Make module roll_motor_gear
translate([0, 0, y_pg1]) rotate([-90, 0, 0]) translate([drive_a, 0, 0]) ai_pitch_motor_gear(); // Make module pitch_motor_gear
translate([0, 0, -y_bk0]) rotate([90, 0, 0]) ai_back_plate(); // Make module back
translate([0, 0, -y_cr0]) rotate([90, 0, 0]) ai_carrier(); // Make module carrier

ai_face_print(); // Make print face black,#4ba3d1,#7a4a2c,white
ai_drum_print(); // Make print drum black,#4ba3d1,#7a4a2c,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
