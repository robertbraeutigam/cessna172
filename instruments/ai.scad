// Attitude indicator on two 28BYJ-48 steppers
//
// The six-pack's top middle instrument (frame/), between the airspeed
// indicator and the altimeter, over the heading indicator. It has the
// standard instrument's case front (instrument.inc.scad: the hole, the
// lip, the glass), a square bezel in front of the sheet (the case's four
// screws through its corners and the sheet), and it is deeper:
// the horizon is a bowl on a roll frame, the pitch motor rides on it.
//
// What moves:
// - Roll: the roll frame turns in a printed sleeve in the case. Its front
//   is the roll dial: a thin ring (sky and ground halves, the bank marks
//   0, 10, 20, 30, a dot at 45, 60, 90, the
//   long ones ending at its window: a colour print, ai_face.pdf); two arms
//   go back from it to a back disc with the roll gear. Modelled on the RC
//   Allen 172 instrument. The bank index (a yellow triangle hanging from
//   the sleeve's front ring at 12 o'clock, a slit down its middle for the
//   dial's zero line) and the airplane
//   are fixed, between the glass and the dial: yellow wing bars, a Y and
//   a dot on a stem from a light brown pedestal, which stands on a black
//   mask over the window's bottom; a dummy knob on the bezel's bottom edge
//   (the real one sets the airplane's height).
//   The dial turns with the horizon and the index reads its bank marks.
//   The roll motor is on the back plate (1:1 to the roll gear), its gear's
//   magnet homes it over a hall sensor.
// - Pitch: the bowl, a part of a sphere (bowl_r) behind the dial's window,
//   turns on two pins in the arms, one degree per degree of pitch, like
//   the real instrument's sphere. It is two printed halves (sky blue and
//   ground brown filament) glued at the horizon; the horizon, the pitch
//   ladder (1 0, 2 0) in the sky and the lines with 10, 20 and the two
//   slanted rails in the ground are raised ribs, painted white. The pitch motor rides on the
//   roll frame, inside the bowl, on a bracket from the back disc; its
//   pinion turns a gear sector on the bowl's left hub (3:1). A magnet in
//   the bowl's right side passes a hall sensor in the right arm just past
//   the nose down end (home_pitch). The bowl turns pitch_max each way.
// - The pitch motor's and sensor's 7 wires cross the roll axis through a
//   capsule slip ring (MSM-12-08A, 8 wires): its flange is screwed onto the
//   back plate, its rotor wires come out of its front end into the roll
//   frame, its body goes through the back plate.
// - A board carrier on four posts of the back plate, behind the roll motor,
//   holds the two ULN2003 boards and the Arduino Nano (MobiFlight, its own
//   USB cable), facing back.
//
// It is deeper than the standard instrument (ai_depth echo), but it is in
// the six-pack's top row, over the force feedback yoke's housing (the
// frame's ai_depth checks it).
//
// Parts (printed): the case (back side down), the sleeve with the front
// ring and the bank index (ring down), the airplane with its mount and the
// mask (flat), the bezel (back down), the knob (front down), the roll dial with the arms (dial
// down), the back disc with the roll gear (front down), the two bowl
// halves (horizon face down, supports under the inside: sky half in blue,
// ground half in brown), the pitch gear sector, the pinion and the roll
// motor gear (flat), the pitch motor's bracket (plate down), the back
// plate with the carrier's posts (front down), the board carrier (flat).
// Black but the bowl; paint the index's triangle and the airplane
// yellow, its pedestal light brown, the bowl's ribs white.
//
// Parts to buy:
// - 2 x 28BYJ-48 stepper (5 V) with its ULN2003 board, an Arduino Nano and
//   a mini USB cable (angled plug), 2 x A3144 hall sensor, 2 x disc magnet
//   6 x 3 mm, a capsule slip ring with 8 wires (MSM-12-08A: 12 mm, a 24 mm
//   flange with 3 holes)
// - 2 x steel dowel pin 3 x 10 mm (the bowl's pivots)
// - clear sheet 1 mm (glass), the dial's face printed on photo paper
// - M3 x 12 button head, black (4, through the bezel and the sheet into the case),
//   M3 x 8 countersunk self tapping (4, back plate into the case; 2, back
//   disc onto the arms; 2, back disc onto the bracket; 4, the carrier onto
//   its posts), M3 x 8 countersunk + nut (2, roll motor ears), M3 x 8 pan
//   head + nut (2, pitch motor ears), M3 x 6 pan head self tapping (3,
//   slip ring flange), M3 x 6 self tapping (8, ULN2003 boards)
//
// Assembly (see the README): face onto the dial. Bowl halves glued at the
// horizon, the gear sector onto the left hub, the magnet into the right
// side. Pitch motor onto its bracket, the pinion on its shaft, the bracket
// onto the back disc. Bowl between the arms, the pins through the arms
// into its hubs (the pinion meshing), sensor into the right arm. Back
// disc onto the arms. Airplane's mask into the sleeve's ring. Glass into
// the case, the sleeve behind it, the roll frame into the sleeve; knob
// into the bezel (glue). Slip ring onto the back plate,
// roll motor, its sensor and gear on, its rotor wires through the back
// disc to the pitch motor and sensor; back plate into the case. Carrier
// onto its posts, boards on it, wire it. Into the panel: the case into
// the hole from behind, the bezel in front, the four screws through both.
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
pitch_max = 30;              // the bowl turns this far each way (MobiFlight clamps the pitch here)
home_pitch = -33;            // the pitch sensor's place: just past nose down
// the bowl's markings (raised ribs), like the RC Allen 172 instrument's: pitch, length, label
sky_lines = [[2, 3.5], [4, 3.5], [6, 3.5], [8, 3.5], [10, 4, "1"], [15, 4.5], [20, 4, "2"], [25, 4.5]];   // the label's "1" left, "0" right
ground_lines = [[-5, 9], [-10, 16, "10"], [-15, 20], [-20, 24, "20"], [-25, 26]];   // the label at both ends
rails = [[1.4, -1.5], [15.7, -30]];   // the ground's two slanted lines: from [x, pitch] to [x, pitch], both sides
label_size = 2.4;
line_w = 0.8;                // the bowl's ribs
horizon_w = 1.2;
rib_h = 0.4;
bank_short = [10, 20];       // bank marks, both sides
bank_long = [0, 30, 60];     // 0: the line the index's slit shows
bank_dot = [45, 1.4];        // a dot: angle, diameter
mark_r1 = 35;                // the marks' outer end
mark_len = [3, 5.5];         // short, long: the long ones end at the dial's window
mark_w = [0.7, 1];
// colours, in the print's order (keep the print marker below the same)
c_black = "black";
c_sky = "#4ba3d1";
c_ground = "#7a4a2c";
c_white = "white";
face_colors = [c_black, c_sky, c_ground, c_white];
c_plane = "#f2c200";         // view only: the airplane and the index (paint them yellow)
c_pedestal = "#a88660";      // view only: the airplane's pedestal (paint it light brown)

// --- Fixed parts in the case: the sleeve, its ring, the airplane ---
ring_t = 2.6;                // the sleeve's front ring, behind the glass
ring_id = 71.6;              // just inside the window: the roll dial's rim runs on its back
sleeve_wall = 2;
bore_play = 0.15;            // sleeve to the case's bore, radial
leg_w = 6;                   // the sleeve's legs behind the roll frame, to the back plate
leg_angles = [0, 120, 240];  // clockwise from 12 o'clock, off the roll motor's gear
plane_t = 1.5;
index_tip = 29;              // the fixed bank index: a yellow triangle hanging from the ring at the top, pointing down: its tip from the axis
index_w = 8;                 // its width at the ring
index_slit = 0.6;            // the slit down its middle: the zero line's width and this each side
index_t = 1.4;
wing = [7.7, 20.8, 2.1];     // the airplane's wing bars: from, to (x), thickness
y_arm = [7.2, -2.5, 1.2, -7];   // the Y's arms: from the wings' inner ends down to [x, z], then in to [x, z]
stem_w = 2.5;                // the stem from the Y down to the pedestal
dot_d = 2.6;                 // the dot on the horizon, on a thin neck
pedestal = [-14, 17.6, 24];  // the light brown pedestal from the mask: its top z, width there, width at the mask
mask_z = -21;                // the black mask over the window's bottom: its top edge
foot_r = 37.4;               // the mask's edge in the ring's notch, outer radius
knob = [12, 5, 1.2];         // the dummy knob on the bezel's bottom: diameter, length, knurl depth
knob_z = -40;                // its axis
knob_pin = [3, 3];           // its stem, glued into the bezel: diameter, depth

// --- Front bezel: square, in front of the sheet, the case's 4 screws through its corners ---
bezel = [86, 4, 6];          // size, thickness, corner radius
bezel_chamfer = 1.2;         // round the window
ai_front_screw = 12;         // M3 x 12 button head through the bezel and the sheet into the case
head_cb = [6.4, 1.5];        // their heads' counterbore: diameter, depth

// --- Roll frame ---
roll_play = 0.3;             // radial, the roll dial and the back disc in the sleeve
rd_t = 1.5;                  // the roll dial
face_r = 35.6;               // the dial's paper face, outer edge (under the ring's edge)
dial_gap = 0.4;              // airplane to the dial's face
arm = [4.5, 8];              // arms: x, z
bd_t = 2.5;                  // back disc
gear_bore = 14.5;            // the roll gear's bore, round the slip ring's front end

// --- Bowl ---
bowl_r = 33;                 // outside
bowl_t = 1.4;
bowl_x = 30;                 // its side plates' outsides from the middle
side_t = 1.5;
bowl_gap = 0.8;              // the roll dial to the bowl
bowl_a = 94;                 // the shell, from the front up and down (the window's edge at pitch_max and a bit)
hub_r = 4;                   // the right hub; the left one a hexagon:
hex_af = 7;                  // across flats, the gear sector on it
hub_l = 4;
pivot_gap = 0.5;             // side plate to arm
mag_rb = 9.5;                // the pitch magnet from the pivot, in the right side plate

// --- Pitch drive ---
gm = 0.8;                    // module
z_sector = 24;               // the bowl's gear (a sector)
z_pinion = 8;
gw = 3.5;                    // their width
sector_a = 50;               // the sector, each way round the back
br_t = 2;                    // the motor's bracket plate
pad = [6, 8, 6];             // its feet on the back disc: x, y, z

// --- Pins, steel dowels ---
pin_d = 3;
press_d = 2.9;               // pressed in
run_d = 3.3;                 // turning in
pin_pivot = 10;

// --- Slip ring MSM-12-08A, MEASURE ---
sr_d = 12;                   // body
sr_front = 7;                // body in front of the flange (the turning wires come out here)
sr_back = 16;                // behind the flange (the fixed wires)
sr_fl = [24, 1];             // flange: diameter, thickness
sr_holes = [18, 3.2, [30, 150, 270]];   // its 3 holes: circle (MEASURE), diameter, angles (off the roll motor's ear)
sr_head = 2;                 // the flange screws' pan heads

// --- Roll motor and boards ---
mflange_r = 12.5;            // the roll motor gear's flange behind its teeth, the magnet in it
posts = [[22, 26], [-31, 18], [-31, -12], [0, -34]];   // the carrier's posts on the back plate
uln_xz = [[2, 7], [-37, 7]]; // the ULN2003 boards' lower left corners (x, z): right (roll), left (pitch)
nano_xz = [-26.5, -27];      // the Nano's lower left corner, lying along x, its USB jack left
car_box = [-39, -38, 39, 41];   // carrier plate: x0, z0, x1, z1

// --- Calculated ---
sleeve_od = bore_d - 2 * bore_play;
sleeve_id = sleeve_od - 2 * sleeve_wall;
roll_r = sleeve_id / 2 - roll_play;
vis_r = mark_r1 - mark_len[1];                // the dial's window: the ring ends at the long marks
y_ring0 = y_glass1;
y_ring1 = y_ring0 + ring_t;
y_rd0 = y_ring1;                              // the dial's rim on the ring's back
y_rd1 = y_rd0 + rd_t;
y_rface = y_rd0 - paper_t;                    // the dial's paper, its front
y_plane1 = y_rface - dial_gap;
y_plane0 = y_plane1 - plane_t;
y_p = y_rd1 + bowl_gap + bowl_r;              // the bowl's pivot (and its sphere's middle)
x_side = bowl_x - side_t;                     // the side plates' insides
sweep = bowl_a + max(pitch_max, -home_pitch); // the shell's furthest angle from the front
y_b0 = y_p - bowl_r * cos(sweep) + 0.6;       // back disc, behind the shell's sweep
y_b1 = y_b0 + bd_t;
y_rg0 = y_b1 + gear_gap;                      // the roll motor gear's teeth (the roll gear from y_b1)
y_rg1 = y_rg0 + gear_t;
y_bk0 = y_rg1 + sr_head + 0.5 + sr_fl[1];     // back plate, the case's back (the slip ring's flange and screws in front of it)
y_bk1 = y_bk0 + back_t;
y_mshaft = y_bk1 - shaft_len;
y_sr0 = y_bk0 - sr_fl[1] - sr_front;          // the slip ring's front end
y_sr1 = y_bk0 + sr_back;                      // its back end
x_arm = bowl_x + pivot_gap;                   // the arms' insides
a_pitch = gm * (z_sector + z_pinion) / 2 + gear_play;   // the pinion behind the pivot
x_g = [-x_side + 0.5, -x_side + 0.5 + gw];    // the sector and the pinion, along x
x_f = x_g[0] + shaft_len;                     // the pitch motor's flange (its shaft's end at the sector's outside)
y_pm = y_p + a_pitch - motor_shaft_dy;        // the pitch motor's body's middle
pm_ears = [for (s = [-1, 1]) [y_pm, s * motor_ear_dx]];   // [y, z]
pad_z = [for (s = [-1, 1]) s * (sqrt(pow(motor_d / 2, 2) - pow(y_b0 - pad.y - y_pm, 2)) + 0.7 + pad.z / 2)];   // the bracket's feet, beside the motor's body
rm_c = [drive_a, -motor_shaft_dy];            // the roll motor's body, beside its shaft (down)
rm_ears = [for (s = [-1, 1]) [drive_a + s * motor_ear_dx, -motor_shaft_dy]];
rsensor = [drive_a, mag_r];                   // the roll motor gear's magnet passes it (up)
psensor_y = y_p - mag_rb;                     // the pitch sensor in the right arm, in front of the pivot
x_pin = [x_arm + arm.x - pin_pivot, x_arm + arm.x];   // the pivot pins, flush with the arms' outsides
ra_sector = gm * z_sector / 2 + gm;
ra_pinion = gm * z_pinion / 2 + gm;
y_cr0 = y_bk1 + motor_flange_t + motor_h + 1; // carrier plate, the boards behind it
y_cr1 = y_cr0 + car_t;
ai_uln_holes = [for (b = uln_xz, i = [0, 1], j = [0, 1])
   [b.x + uln_hole_in + i * (uln_board.x - 2 * uln_hole_in), b.y + uln_hole_in + j * (uln_board.y - 2 * uln_hole_in)]];
leg_r = sleeve_id / 2 + 0.2;                  // legs: their inside (the outside the sleeve's)
sr_hole_xz = [for (a = sr_holes[2]) sr_holes[0] / 2 * [cos(a), sin(a)]];
arm_screw = [x_arm + arm.x / 2, 0];           // the back disc's screws into the arms (both sides)
pad_screws = [for (z = pad_z) [x_f + pad.x / 2, z]];
ai_depth = y_cr1 + max(uln_standoff + nano_t + uln_parts, nano_under + nano_t + nano_usb[1]) - y_sheet1;

echo(ai_depth = ai_depth, case_depth = y_bk1 - y_sheet1, pivot = y_p, back_disc = y_b0, window = 2 * vis_r,
     pitch_mm_per_10 = bowl_r * sin(10), pitch_steps_per_degree = 2038 * z_sector / z_pinion / 360);

// --- Checks ---
// the front
assert(y_plane0 >= y_glass1 + 0.3, "Airplane against the glass");
assert(index_t <= y_rface - 0.6 - y_ring0, "Bank index runs into the dial");
assert(ring_id / 2 < window_d / 2 && ring_id / 2 <= roll_r - 0.4, "The ring must hide the dial's rim and hold it");
assert(face_r <= ring_id / 2 - 0.15 && face_r >= window_d / 2 - 1, "Dial face edge shows or is covered");
assert(mark_r1 <= face_r - 0.3 && index_tip <= mark_r1 - mark_len[0] && index_tip >= vis_r - 1, "Bank index not over the marks");
assert(index_w / 2 - mark_w[1] / 2 - index_slit >= 1.5, "Bank index too narrow for its slit");
assert(-mask_z + 1 <= vis_r && -mask_z >= -pedestal[0] + 3, "Mask over the horizon or not over the window's bottom");
assert(norm([wing[1], wing[2] / 2]) <= vis_r - 1 && wing[0] >= dot_d / 2 + 2, "Wings");
assert(y_arm[3] - stem_w / 2 >= pedestal[0] + 2 && pedestal[2] / 2 >= pedestal[1] / 2, "Airplane's stem");
assert(abs(knob_z) - knob_pin[0] / 2 >= window_d / 2 + bezel_chamfer + 1 && abs(knob_z) + knob_pin[0] / 2 <= bezel[0] / 2 - 1, "Knob's stem off the bezel");
assert(ai_front_screw - bezel[1] - sheet_t >= 4 && head_cb[1] <= bezel[1] - 2, "Bezel screws");
for (c = [for (i = [0 : 3]) cols[i]]) assert(max(abs(c.x), abs(c.y)) + head_cb[0] / 2 + 1 <= bezel[0] / 2
                                             && norm(c) - head_cb[0] / 2 >= window_d / 2 + bezel_chamfer + 1, "Bezel screw off the bezel");
assert(foot_r <= sleeve_od / 2 - 1, "Mask's foot through the ring");
// bowl
assert(bowl_r <= roll_r - 1, "Bowl does not turn in the sleeve");
assert(bowl_x >= vis_r + 0.3 && sqrt(bowl_r * bowl_r - bowl_x * bowl_x) >= hub_r + 6, "Bowl narrower than the window or its sides too small");
assert(bowl_a >= asin(vis_r / bowl_r) + pitch_max, "Bowl's shell does not fill the window at pitch_max");
assert(norm([x_arm + arm.x, arm.y / 2]) <= roll_r - 0.8, "Arms off the roll frame");
assert(arm_screw.x - pilot_d / 2 >= x_arm + 0.6 && arm_screw.x + pilot_d / 2 <= x_arm + arm.x - 0.6, "Arm too thin for its screw");
assert(x_pin[0] <= x_side - hub_l + 1 && x_pin[0] >= x_side - hub_l - 0.5, "Pivot pin does not reach into the hub");
assert(mag_rb + magnet[0] / 2 + 0.5 <= sqrt(bowl_r * bowl_r - bowl_x * bowl_x) && mag_rb - magnet[0] / 2 >= hub_r + 0.5,
       "Pitch magnet off the bowl's side");
assert(abs(home_pitch) + asin(magnet[0] / 2 / mag_rb) + 2 <= bowl_a, "Pitch magnet off the side plate's sector");
assert(mag_rb - sensor.z / 2 >= run_d / 2 + 2, "Pitch sensor runs into the pivot");
// pitch drive: the sector and the pinion inside the bowl, the motor clear of the shell
assert(-x_g[0] <= x_side - 0.5 && x_g[1] >= -x_side + hub_l - 0.01, "Sector off the left hub");
assert(a_pitch - ra_pinion >= hex_af / cos(30) / 2 + 0.5, "Pinion runs into the left hub");
assert(sector_a >= max(pitch_max, -home_pitch) + 180 / z_sector * 2, "Sector too short for the bowl's travel");
assert(x_f - shaft_len + flat_len >= x_g[1] + 0.3 && x_f - motor_boss[1] - 0.5 >= x_g[1], "Pitch motor's shaft does not reach through the pinion");
// the motor's body, cover and ears inside the shell (bowl_r - bowl_t from the pivot): [x, y from the pivot, z]
for (x = [x_f, x_f + motor_flange_t + motor_h], p = [[a_pitch - motor_shaft_dy - motor_d / 2, 0],
                                                    [a_pitch - motor_shaft_dy + motor_d / 2, 0], [a_pitch - motor_shaft_dy, motor_d / 2],
                                                    [a_pitch - motor_shaft_dy - motor_cover[1], motor_cover[0] / 2]])
   assert(norm([x, p[0], p[1]]) <= bowl_r - bowl_t - 1, "Pitch motor runs into the bowl's shell");
assert(norm([x_f, a_pitch - motor_shaft_dy, motor_ear_dx + motor_ear_w / 2]) <= bowl_r - bowl_t - 1, "Pitch motor's ear runs into the shell");
assert(x_f + motor_flange_t + motor_h <= x_arm - 1, "Pitch motor runs into the right arm");
assert(a_pitch - motor_shaft_dy + motor_d / 2 <= y_b0 - y_p - 0.3, "Pitch motor runs into the back disc");
for (z = pad_z) assert(abs(z) - pad.z / 2 >= sqrt(max(0, pow(motor_d / 2, 2) - pow(y_b0 - pad.y - y_pm, 2))) + 0.5, "Bracket's foot runs into the motor");
// back disc, roll gear, slip ring, roll motor
assert(gear_bore / 2 >= sr_d / 2 + 0.7 && gear_bore / 2 <= gear_rf - 1.5, "Roll gear's bore");
assert(y_sr0 >= y_b1 + 0.3, "Slip ring runs into the back disc");
assert(y_mshaft <= y_rg1 - 2 && y_bk0 - y_mshaft >= 5.5, "Roll motor's shaft too short in its gear");
assert(drive_a - mflange_r >= sr_fl[0] / 2 + 1 && drive_a - mflange_r >= sr_holes[0] / 2 + 3, "Roll motor gear's flange runs into the slip ring's flange or screws");
for (h = sr_hole_xz) assert(min([for (e = rm_ears) norm(h - e)]) >= csk_d / 2 + pilot_d / 2 + 1, "Slip ring screw on a motor ear screw");
for (e = rm_ears) {
   assert(norm(e) >= sr_d / 2 + max(motor_ear_w, nut[0] + 1) / 2 + 0.5, "Roll motor's ear runs into the slip ring");
}
assert(norm(rsensor - rm_c) >= motor_d / 2 + 2 && rsensor.y + sensor.z / 2 - 1 >= rm_c.y + motor_d / 2 + 0.5, "Roll sensor's legs (their slot) run into the motor");
assert(mag_r + magnet[0] / 2 + 0.5 <= mflange_r && mag_r - magnet[0] / 2 >= shaft_d / 2 + 1.5, "Magnet does not fit the roll motor gear's flange");
assert(norm(rsensor) + sensor.z / 2 + 1 <= bore_d / 2, "Roll sensor off the back plate");
for (a = leg_angles) {
   assert(norm(pol(leg_r + sleeve_wall / 2, a) - [drive_a, 0]) >= gear_ra + 1 + leg_w / 2 + 1, "A leg runs into the roll motor gear");
}
for (c = cols) assert(norm(c - [drive_a, 0]) >= gear_ra + ear_d / 2 + 1, "A case column runs into the roll motor gear");
assert(drive_a + gear_ra + 1 + wall <= case_r + 1.5, "Motor gear bulges out of the case");
// carrier
for (p = posts) {
   assert(norm(p - rm_c) >= motor_d / 2 + car_post_d / 2 + 0.9, "A carrier post runs into the roll motor");
   assert(min([for (e = rm_ears) norm(p - e)]) >= max(motor_ear_w, nut[0] + 1) / 2 + car_post_d / 2 + 0.5, "A carrier post runs into a motor ear");
   assert(p.x + car_post_d / 2 <= rm_c.x - motor_cover[0] / 2 - 0.5 || p.x - car_post_d / 2 >= rm_c.x + motor_cover[0] / 2 + 0.5
          || p.y - car_post_d / 2 >= rm_c.y + 0.5 || p.y + car_post_d / 2 <= rm_c.y - motor_cover[1] - 0.5, "A carrier post runs into the motor's cover");
   assert(norm(p - rsensor) >= car_post_d / 2 + sensor.x / 2 + 1.5, "A carrier post runs into the roll sensor's legs");
   assert(norm(p) >= sr_d / 2 + car_post_d / 2 + 3, "A carrier post on the slip ring's wires");
   assert(norm(p) + car_post_d / 2 <= case_r, "A carrier post off the back plate");
   assert(min([for (h = ai_uln_holes) norm(p - h)]) >= csk_d / 2 + 3.5, "A carrier screw runs into a ULN2003 standoff");
   // off the Nano's rails and stop
   assert(p.x + csk_d / 2 <= nano_xz.x - 1 || p.x - csk_d / 2 >= nano_xz.x + nano_board.y + 1.7
          || p.y + csk_d / 2 <= nano_xz.y - 1.7 || p.y - csk_d / 2 >= nano_xz.y + nano_board.x + 1.7, "A carrier screw under the Nano's rails");
   assert(p.x - car_post_d / 2 >= car_box[0] && p.x + car_post_d / 2 <= car_box[2] && p.y - car_post_d / 2 >= car_box[1]
          && p.y + car_post_d / 2 <= car_box[3], "A carrier post off the carrier");
}
for (b = uln_xz) assert(b.x >= car_box[0] + 1 && b.x + uln_board.x <= car_box[2] - 1 && b.y >= car_box[1] + 1 && b.y + uln_board.y <= car_box[3] - 1,
                        "ULN2003 board off the carrier");
assert(uln_xz[0].x >= 1 && uln_xz[1].x + uln_board.x <= -1, "ULN2003 boards overlap");
assert(nano_xz.y + nano_board.x + 2 <= min([for (b = uln_xz) b.y]) && nano_xz.y - 2 >= car_box[1] && nano_xz.x - 1 >= car_box[0]
       && nano_xz.x + nano_board.y + 2 <= car_box[2], "Nano off the carrier or under a ULN2003 board");
assert(y_cr0 >= y_sr1 + 1, "Slip ring runs into the carrier");
assert(max(abs(car_box[0]), car_box[2]) <= inst_pitch.x / 2 - 1 && max(abs(car_box[1]), car_box[3]) <= inst_pitch.y / 2 - 1,
       "Board carrier runs into the next instrument");

// --- Helpers ---
// along x, from x0 to x1, a 2D shape in [y, z]
module along_x(x0, x1) {
   translate([x0, 0, 0]) multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) linear_extrude(x1 - x0) children();
}

// the bowl's sphere, round its pivot
module sph(r) {
   translate([0, y_p, 0]) sphere(r = r, $fn = 144);
}

// a wedge round the pivot axis: a0..a1 from the front (-y) upwards, along x from x0 to x1
module bwedge(a0, a1, x0, x1, r = 60) {
   n = max(2, ceil((a1 - a0) / 3));
   along_x(x0, x1) translate([y_p, 0])
      polygon(concat([[0, 0]], [for (i = [0 : n]) let(a = a0 + (a1 - a0) * i / n) r * [-cos(a), sin(a)]]));
}

// Spur gear cut by a rolling rack (20 degrees, play thins the teeth):
// undercut where it needs it, so the small pitch gears mesh; a tooth at 0
// like gear_2d()
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

module motor_bore(y0, y1) {
   translate([0, y1 + 1, 0]) rotate([90, 0, 0]) double_d(shaft_d + 0.1, shaft_flat + 0.1, y1 + 1 - y0);
}

// --- Case: the standard's front, longer, the roll motor gear's pocket on the right ---
module ai_case_outline() {
   hull() {
      circle(d = case_d, $fn = 180);
      for (i = [0 : 3]) translate(cols[i]) circle(d = ear_d);
   }
   hull() {
      circle(d = case_d, $fn = 180);
      translate([drive_a, 0]) circle(r = arm_r, $fn = 120);
      for (c = cols) if (c.x > 0) translate(c) circle(d = ear_d);
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
      // the roll motor gear, a 45 degree roof towards the front (printed back side down)
      hull() {
         along_y(y_b1, y_bk0 + 1) translate([drive_a, 0]) circle(r = gear_ra + 1, $fn = 120);
         along_y(y_b1 - 3, y_b1) translate([drive_a, 0]) circle(r = gear_ra + 1 - 3, $fn = 120);
      }
      for (i = [0 : len(cols) - 1]) {
         c = cols[i];
         if (i < 4) translate([c.x, y_sheet1 - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = ai_front_screw - bezel[1] - sheet_t + 1);
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
         // the bank index, pointing up at the dial's marks
         along_y(y_ring0, y_ring0 + index_t) index_2d();
      }
      // the mask's edge, from behind
      along_y(y_plane0, y_ring1 + 1) intersection() {
         circle(r = foot_r + 0.15, $fn = 180);
         translate([-50, mask_z + 0.15 - 50]) square(50 * [2, 1]);
      }
   }
}

// --- Bank index: a triangle hanging from the ring at the top ---
module index_2d() {
   // a triangle from the ring down to its tip, a slit down its middle (the dial's zero line shows in it)
   difference() {
      polygon([[0, index_tip], [-index_w / 2, ring_id / 2 + 0.5], [index_w / 2, ring_id / 2 + 0.5]]);
      translate([-mark_w[1] / 2 - index_slit, index_tip - 1]) square([mark_w[1] + 2 * index_slit, ring_id / 2 - index_tip + 3]);
   }
}

// --- Airplane: the wing bars, the Y and the dot on a stem from the pedestal, the black mask over the window's bottom ---
// one flat part, printed black; paint the airplane yellow, the pedestal light brown
module wings_2d() {
   translate([0, 0.3]) circle(d = dot_d);
   translate([-0.5, y_arm[3]]) square([1, 0.3 - y_arm[3]]);
   for (s = [-1, 1]) {
      translate([s > 0 ? wing[0] : -wing[1], -wing[2] / 2]) square([wing[1] - wing[0], wing[2]]);
      hull() {
         translate([s * wing[0], 0]) circle(d = wing[2]);
         translate([s * y_arm[0], y_arm[1]]) circle(d = wing[2]);
      }
      hull() {
         translate([s * y_arm[0], y_arm[1]]) circle(d = wing[2]);
         translate([s * y_arm[2], y_arm[3]]) circle(d = wing[2]);
      }
   }
   translate([-stem_w / 2, pedestal[0] - 0.01]) square([stem_w, y_arm[3] - pedestal[0] + 0.5]);
}

module pedestal_2d() {
   polygon([[-pedestal[1] / 2, pedestal[0]], [pedestal[1] / 2, pedestal[0]], [pedestal[2] / 2, mask_z + 0.1], [-pedestal[2] / 2, mask_z + 0.1]]);
}

module plane_2d() {
   wings_2d();
   pedestal_2d();
   // the mask, its edge in the ring's notch
   intersection() {
      circle(r = foot_r, $fn = 180);
      translate([-50, mask_z - 50]) square(50 * [2, 1]);
   }
}

module ai_plane() {
   difference() {
      along_y(y_plane0, y_plane1) plane_2d();
   }
}

// the dummy knob (the real one sets the airplane's height): knurled, on the bezel's bottom, its stem glued into the bezel
module ai_knob() {
   translate([0, 0, knob_z]) {
      difference() {
         along_y(-bezel[1] - knob[1], -bezel[1]) circle(d = knob[0], $fn = 60);
         for (a = [0 : 20 : 340]) rotate([0, a, 0]) translate([knob[0] / 2, -bezel[1] - knob[1] - 1, 0]) rotate([-90, 0, 0])
            cylinder(d = knob[2] * 1.6, h = knob[1] + 2, $fn = 12);
      }
      along_y(-bezel[1] - 0.01, -bezel[1] + knob_pin[1] - 0.2) circle(d = knob_pin[0]);
   }
}

// --- Front bezel: a square plate in front of the sheet, the window chamfered, the case's screws through its corners ---
module ai_bezel() {
   difference() {
      along_y(-bezel[1], 0) offset(r = bezel[2]) square(bezel[0] - 2 * bezel[2], center = true);
      along_y(-bezel[1] - 1, 1) circle(d = window_d, $fn = 180);
      translate([0, -bezel[1] - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d1 = window_d + 2 * bezel_chamfer, d2 = window_d, h = bezel_chamfer, $fn = 180);
      for (i = [0 : 3]) let(c = cols[i]) {
         translate([c.x, 1, c.y]) rotate([90, 0, 0]) cylinder(d = clear_d, h = bezel[1] + 2);
         translate([c.x, -bezel[1] - 0.01, c.y]) rotate([-90, 0, 0]) cylinder(d = head_cb[0], h = head_cb[1] + 0.01);
      }
      translate([0, -bezel[1] - 1, knob_z]) rotate([-90, 0, 0]) cylinder(d = knob_pin[0] + 0.1, h = knob_pin[1] + 1);
   }
}

// --- Roll frame: the dial with the arms, the bowl's bearings and the pitch sensor ---
module ai_roll_dial() {
   difference() {
      union() {
         along_y(y_rd0, y_rd1) difference() {
            circle(r = roll_r, $fn = 180);
            circle(r = vis_r, $fn = 180);
         }
         along_y(y_rd1 - 0.01, y_b0) for (s = [-1, 1]) translate([s > 0 ? x_arm : -x_arm - arm.x, -arm.y / 2]) square(arm);
      }
      // the bowl's pivots
      along_x(-x_arm - arm.x - 1, -x_arm + 1) translate([y_p, 0]) circle(d = run_d);
      along_x(x_arm - 1, x_arm + arm.x + 1) translate([y_p, 0]) circle(d = run_d);
      // the back disc's screws
      for (s = [-1, 1]) translate([s * arm_screw.x, y_b0 + 0.01, 0]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - bd_t + 1);
      // the pitch sensor in the right arm's inside, its flat face to the bowl; its legs back in a groove
      translate([x_arm - 0.01, psensor_y - sensor.z / 2 - 0.15, -sensor.x / 2 - 0.15]) cube([sensor.y + 0.11, sensor.z + 0.3, sensor.x + 0.3]);
      translate([x_arm - 0.01, psensor_y, -sensor.x / 2 - 0.15]) cube([1.2, 2.5, sensor.x / 2 + 3.4]);
      translate([x_arm - 0.01, psensor_y, 2]) cube([1.2, y_b0 - psensor_y + 1, 1.4]);
   }
}

// --- Roll frame: the back disc with the roll gear (round the slip ring's front end) ---
module ai_roll_back() {
   difference() {
      union() {
         along_y(y_b0, y_b1) circle(r = roll_r, $fn = 180);
         along_y(y_b1 - 0.01, y_rg1) gear_2d(gear_z);
      }
      along_y(y_b0 - 1, y_rg1 + 1) circle(d = gear_bore);
      for (s = [-1, 1]) translate([s * arm_screw.x, y_b1, 0]) rotate([-90, 0, 0]) csk_hole();
      for (p = pad_screws) translate([p.x, y_b1, p.y]) rotate([-90, 0, 0]) csk_hole();
      // weight: windows, off the screws
      along_y(y_b0 - 1, y_b1 + 1) difference() {
         circle(r = roll_r - 3, $fn = 120);
         circle(r = gear_ra + 2);
         for (s = [-1, 1]) translate([s * arm_screw.x, 0]) circle(d = csk_d + 4);
         for (p = pad_screws) translate(p) circle(d = csk_d + 4);
         for (a = [0 : 60 : 300]) rotate(a + 30) translate([0, -2.5]) square([roll_r, 5]);
      }
   }
}

// --- Bowl: one half (s = 1 the sky, -1 the ground), shell, side plates, hubs, ribs, the pitch magnet ---
module ai_bowl_half(s) {
   lw = line_w / bowl_r * 180 / PI;
   hw = horizon_w / bowl_r * 180 / PI;
   mag = [y_p - mag_rb * cos(home_pitch), mag_rb * sin(home_pitch)];
   difference() {
      intersection() {
         union() {
            intersection() {
               difference() {
                  sph(bowl_r);
                  sph(bowl_r - bowl_t);
               }
               bwedge(-bowl_a, bowl_a, -bowl_x, bowl_x);
            }
            for (k = [-1, 1]) intersection() {
               sph(bowl_r - bowl_t / 2);
               bwedge(-bowl_a, bowl_a, k > 0 ? x_side : -bowl_x, k > 0 ? bowl_x : -x_side);
            }
            along_x(x_side - hub_l, x_side + 0.01) translate([y_p, 0]) circle(r = hub_r);
            along_x(-x_side - 0.01, -x_side + hub_l) translate([y_p, 0]) circle(d = hex_af / cos(30), $fn = 6);
            along_x(bowl_x - magnet[1] - 0.8, x_side + 0.01) translate(mag) circle(d = magnet[0] + 2.4);
            // the horizon and the pitch lines, raised (paint them white)
            intersection() {
               difference() {
                  sph(bowl_r + rib_h);
                  sph(bowl_r - 0.5);
               }
               union() {
                  bwedge(-hw / 2, hw / 2, -bowl_x, bowl_x);
                  along_y(y_p - bowl_r - 2, y_p) bowl_marks_2d();
               }
            }
         }
         translate([-50, y_p - 50, s > 0 ? 0 : -50]) cube([100, 100, 50]);
      }
      along_x(x_pin[0] - 0.5, bowl_x + 1) translate([y_p, 0]) circle(d = press_d);
      along_x(-bowl_x - 1, -x_pin[0] + 0.5) translate([y_p, 0]) circle(d = press_d);
      along_x(bowl_x - magnet[1] - 0.1, bowl_x + 1) translate(mag) circle(d = magnet[0] + 0.2);
   }
}

// the bowl's markings seen from the front at level (x right, z up): the
// ladder in the sky, the lines, labels and rails in the ground
module bowl_marks_2d() {
   function pz(p) = bowl_r * sin(p);
   for (l = sky_lines) {
      translate([-l[1] / 2, pz(l[0]) - line_w / 2]) square([l[1], line_w]);
      if (len(l) > 2) {
         translate([-l[1] / 2 - 1.5, pz(l[0])]) text(l[2], size = label_size, font = font, halign = "right", valign = "center");
         translate([l[1] / 2 + 1.5, pz(l[0])]) text("0", size = label_size, font = font, halign = "left", valign = "center");
      }
   }
   for (l = ground_lines) {
      translate([-l[1] / 2, pz(l[0]) - line_w / 2]) square([l[1], line_w]);
      if (len(l) > 2) for (s = [-1, 1])
         translate([s * (l[1] / 2 + 1.2), pz(l[0])]) text(l[2], size = label_size, font = font, halign = s > 0 ? "left" : "right", valign = "center");
   }
   for (s = [-1, 1]) hull() for (r = rails) translate([s * r[0], pz(r[1])]) circle(d = line_w + 0.1, $fn = 16);
}

// --- The bowl's gear: a sector round the back, on the left hub's hexagon ---
module ai_sector() {
   along_x(x_g[0], x_g[1]) translate([y_p, 0]) difference() {
      union() {
         intersection() {
            rack_gear_2d(z_sector);
            polygon(concat([[0, 0]], [for (a = [-sector_a : 3 : sector_a]) 20 * [cos(a), sin(a)]], [20 * [cos(sector_a), sin(sector_a)]]));
         }
         circle(r = hex_af / cos(30) / 2 + 2.5);
      }
      circle(d = (hex_af + 0.3) / cos(30), $fn = 6);
   }
}

// --- Pitch motor: the pinion on its shaft, the bracket from the back disc ---
module ai_pinion() {
   along_x(x_g[0], x_g[1]) translate([y_p + a_pitch, 0]) difference() {
      rotate(180 / z_pinion) rack_gear_2d(z_pinion);
      intersection() {
         circle(d = shaft_d + 0.1);
         square([shaft_d + 1, shaft_flat + 0.1], center = true);
      }
   }
}

module ai_bracket() {
   difference() {
      union() {
         along_x(x_f - br_t, x_f) {
            hull() {
               for (e = pm_ears) translate(e) circle(d = motor_ear_w + 2);
               translate([y_p + a_pitch, 0]) circle(d = motor_boss[0] + 4);
            }
            hull() {
               translate([y_p + a_pitch, 0]) circle(d = motor_boss[0] + 4);
               for (z = pad_z) translate([y_b0 - pad.y, z - pad.z / 2]) square([pad.y, pad.z]);
            }
         }
         // the feet on the back disc, beside the motor's body
         for (z = pad_z) translate([x_f - 0.01, y_b0 - pad.y, z - pad.z / 2]) cube([pad.x + 0.01, pad.y, pad.z]);
      }
      along_x(x_f - br_t - 1, x_f + 1) {
         for (e = pm_ears) translate(e) circle(d = clear_d);
         translate([y_p + a_pitch, 0]) circle(d = motor_boss[0] + 0.6);
      }
      for (p = pad_screws) translate([p.x, y_b0 + 0.01, p.y]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = back_screw - bd_t + 1);
   }
}

// --- Roll motor gear: its teeth level with the roll gear, a flange behind them with the magnet (up) ---
module ai_roll_motor_gear() {
   translate([drive_a, 0, 0]) difference() {
      union() {
         along_y(y_rg0, y_rg1) rotate(gear_z % 2 == 0 ? 180 / gear_z : 0) gear_2d(gear_z);
         along_y(y_rg1 - 0.01, y_bk0 - gear_gap) circle(r = mflange_r);
      }
      motor_bore(y_mshaft - 0.5, y_bk0 - gear_gap);
      translate([0, y_bk0 - gear_gap + 0.01, mag_r]) rotate([90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1);
   }
}

// --- Back plate: the slip ring, the roll motor (beside its shaft) and its sensor, the carrier's posts ---
module ai_back_plate() {
   difference() {
      union() {
         along_y(y_bk0, y_bk1) {
            ai_case_outline();
            hull() {
               translate([drive_a, 0]) circle(r = arm_r);
               translate(rm_ears[1]) circle(d = motor_ear_w + 3);
            }
         }
         for (p = posts) along_y(y_bk1 - 0.01, y_cr0) translate(p) circle(d = car_post_d);
      }
      for (c = cols) translate([c.x, y_bk1, c.y]) rotate([-90, 0, 0]) csk_hole();
      // slip ring: its body through, the flange's screws
      along_y(y_bk0 - 1, y_bk1 + 1) circle(d = sr_d + 0.4);
      for (h = sr_hole_xz) translate([h.x, y_bk0 - 0.01, h.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = back_t - 0.8);
      // roll motor: its boss, the ears (countersunk from the front, nuts behind the ears)
      translate([drive_a, y_bk0 - 1, 0]) rotate([-90, 0, 0]) cylinder(d = motor_boss[0] + 0.6, h = back_t + 2);
      for (e = rm_ears) translate([e.x, y_bk0, e.y]) rotate([90, 0, 0]) csk_hole();
      // roll sensor: flat face forward in a pocket, the legs through a slot to the back
      translate([rsensor.x - sensor.x / 2 - 0.15, y_bk0 - 0.01, rsensor.y - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.01, sensor.z + 0.3]);
      translate([rsensor.x - sensor.x / 2 - 0.15, y_bk0 - 1, rsensor.y + sensor.z / 2 - 1]) cube([sensor.x + 0.3, back_t + 2, 2.5]);
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

// --- Print: the roll dial's face, 2D (x right, y up, the axis at the origin, level) ---
module ai_face_2d() {
   ink(c_sky) arc_2d(vis_r, face_r, -90, 90);
   ink(c_ground) arc_2d(vis_r, face_r, 90, 270);
   ink(c_white) {
      for (a = [90, 270]) tick_2d(a, vis_r, face_r, horizon_w);
      for (s = [-1, 1]) {
         for (a = bank_short) tick_2d(s * a, mark_r1 - mark_len[0], mark_r1, mark_w[0]);
         for (a = bank_long) tick_2d(s * a, mark_r1 - mark_len[1], mark_r1, mark_w[1]);
         translate(pol(mark_r1 - bank_dot[1], s * bank_dot[0])) circle(d = bank_dot[1]);
      }
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
      translate([2 * step + glass_d / 2 - face_r, 0]) difference() {
         circle(d = glass_d + 0.6, $fn = 180);
         circle(d = glass_d, $fn = 180);
      }
      translate([-face_r, -face_r - 8])
         text(str("AI: roll dial ", d, " mm (cut the outside on the line's inside, the window on the colours' edge),"), size = 3, font = font);
      translate([-face_r, -face_r - 13])
         text(str("glass ", glass_d, " mm (cut on the line's inside); print at 100 %"), size = 3, font = font);
   }
   for (x = [-face_r - 2, w - face_r + 2], y = [-face_r - 16, glass_d / 2 + 2]) translate([x, y]) square(0.1, center = true);
}


// --- View only ---
module pin_part(p0, p1) {
   color(c_steel) hull() for (p = [p0, p1]) translate(p) sphere(d = pin_d, $fn = 16);
}

module ai_face_part() {
   for (i = [0 : len(face_colors) - 1])
      color(face_colors[i]) translate([0, y_rface + 0.2 - 0.02 * i, 0]) rotate([90, 0, 0]) linear_extrude(0.02) let($ink = face_colors[i]) ai_face_2d();
}

module pitch_motor_part() {
   translate([x_f, y_p + a_pitch, 0]) multmatrix([[0, 0, -1, 0], [0, -1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 1]]) motor_local();
}

module roll_motor_part() {
   translate([drive_a, y_bk1, 0]) multmatrix([[-1, 0, 0, 0], [0, 0, -1, 0], [0, -1, 0, 0], [0, 0, 0, 1]]) motor_local();
}

module slip_ring_part() {
   color("#c9a227") along_y(y_sr0, y_sr1) circle(d = sr_d);
   color("#c9a227") along_y(y_bk0 - sr_fl[1], y_bk0) difference() {
      circle(d = sr_fl[0]);
      for (h = sr_hole_xz) translate(h) circle(d = sr_holes[1]);
   }
   color("#d03030") along_y(y_b0 - 3, y_sr0) circle(d = 3);
   color("#303030") along_y(y_sr1, y_sr1 + 6) circle(d = 3);
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
   color("#202020") {
      translate([rsensor.x - sensor.x / 2, y_bk0, rsensor.y - sensor.z / 2]) cube([sensor.x, sensor.y, sensor.z]);
      translate([x_arm, psensor_y - sensor.z / 2, -sensor.x / 2]) cube([sensor.y, sensor.z, sensor.x]);
   }
}

// the bowl at pitch p (nose up), in its colours, the ribs white
module bowl_part(p) {
   translate([0, y_p, 0]) rotate([p, 0, 0]) translate([0, -y_p, 0]) {
      color(c_sky) render() ai_bowl_half(1);
      color(c_ground) render() ai_bowl_half(-1);
      color(c_white) render() intersection() {
         difference() {
            sph(bowl_r + rib_h + 0.02);
            sph(bowl_r + 0.05);
         }
         union() for (s = [-1, 1]) ai_bowl_half(s);
      }
      color(c_case) render() ai_sector();
   }
}

// the roll frame and what turns with it, at bank r (right wing down) and pitch p (nose up)
module ai_roll_parts(r, p) {
   rotate([0, -r, 0]) {
      color(c_case) ai_roll_dial();
      ai_face_part();
      color(c_case) ai_roll_back();
      bowl_part(p);
      color(c_case) ai_bracket();
      pitch_motor_part();
      translate([0, y_p + a_pitch, 0]) rotate([-p * z_sector / z_pinion, 0, 0]) translate([0, -y_p - a_pitch, 0]) color(c_case) render() ai_pinion();
      for (s = [-1, 1]) pin_part([s * x_pin[0], y_p, 0], [s * x_pin[1], y_p, 0]);
      color("#202020") translate([x_arm, psensor_y - sensor.z / 2, -sensor.x / 2]) cube([sensor.y, sensor.z, sensor.x]);
   }
}

module ai_parts(r = view_roll, p = view_pitch, e = 0, with_case = true, with_sleeve = true) {
   if (with_case) color(c_case) render() ai_case();
   translate([0, -3.4 * e, 0]) {
      if (with_sleeve) color(c_case) render() ai_sleeve();
      color(c_case) ai_plane();
      color(c_plane) translate([0, y_plane0 - 0.02, 0]) rotate([90, 0, 0]) linear_extrude(0.01) wings_2d();
      color(c_pedestal) translate([0, y_plane0 - 0.02, 0]) rotate([90, 0, 0]) linear_extrude(0.01) difference() {
         pedestal_2d();
         wings_2d();
      }
      color(c_plane) translate([0, y_ring0 - 0.02, 0]) rotate([90, 0, 0]) linear_extrude(0.01) index_2d();
   }
   ai_roll_parts(r, p);
   translate([0, 0.8 * e, 0]) color(c_case) render() ai_roll_motor_gear();
   translate([0, 1.4 * e, 0]) {
      color(c_case) ai_back_plate();
      roll_motor_part();
      slip_ring_part();
      color("#202020") translate([rsensor.x - sensor.x / 2, y_bk0, rsensor.y - sensor.z / 2]) cube([sensor.x, sensor.y, sensor.z]);
   }
   translate([0, 2 * e, 0]) {
      color(c_case) ai_carrier();
      ai_boards_part();
   }
   if (with_case) {
      color(c_case) ai_bezel();
      color("#45484d") ai_knob();
      color(c_glass) along_y(y_glass0, y_glass1) circle(d = glass_d, $fn = 180);
   }
}

// a piece of the sheet round the hole, the bezel's screws in front of it
module ai_sheet_part(w = 150, h = 120, x0 = -75) {
   color(c_sheet) along_y(0, sheet_t) difference() {
      translate([x0, -h / 2]) square([w, h]);
      circle(d = cut_d, $fn = 180);
      for (i = [0 : 3]) translate(cols[i]) circle(d = clear_d);
   }
   color("#111111") for (i = [0 : 3]) translate([cols[i].x, -bezel[1] + head_cb[1], cols[i].y]) rotate([90, 0, 0]) cylinder(d = head_d, h = 1.65);
}

module assembled_view() {
   ai_sheet_part();
   ai_parts();
}

module exploded_view() {
   ai_parts(e = explode, with_case = false);
}

module inside_view() {
   ai_parts(with_case = false, with_sleeve = false);
}

module face_view() {
   for (i = [0 : len(face_colors) - 1]) color(face_colors[i]) translate([0, 0, 0.02 * i]) linear_extrude(0.02) let($ink = face_colors[i])
      rotate(-view_roll) ai_face_2d();
}

// --- Printable parts, in print orientation ---
translate([0, 0, y_bk0]) rotate([-90, 0, 0]) ai_case(); // Make module case
translate([0, 0, -y_ring0]) rotate([90, 0, 0]) ai_sleeve(); // Make module sleeve
translate([0, 0, -y_plane0]) rotate([90, 0, 0]) ai_plane(); // Make module plane
translate([0, 0, bezel[1] + knob[1]]) rotate([90, 0, 0]) translate([0, 0, -knob_z]) ai_knob(); // Make module knob
rotate([-90, 0, 0]) ai_bezel(); // Make module bezel
translate([0, 0, -y_rd0]) rotate([90, 0, 0]) ai_roll_dial(); // Make module roll_dial
translate([0, 0, -y_b0]) rotate([90, 0, 0]) ai_roll_back(); // Make module roll_back
translate([0, -y_p, 0]) ai_bowl_half(1); // Make module bowl_sky
rotate([180, 0, 0]) translate([0, -y_p, 0]) ai_bowl_half(-1); // Make module bowl_ground
translate([0, 0, -x_g[0]]) rotate([0, -90, 0]) translate([0, -y_p, 0]) ai_sector(); // Make module sector
translate([0, 0, -x_g[0]]) rotate([0, -90, 0]) translate([0, -y_p - a_pitch, 0]) ai_pinion(); // Make module pinion
translate([0, 0, -(x_f - br_t)]) rotate([0, -90, 0]) translate([0, -y_p, 0]) ai_bracket(); // Make module bracket
translate([0, 0, -y_rg0]) rotate([90, 0, 0]) translate([-drive_a, 0, 0]) ai_roll_motor_gear(); // Make module roll_motor_gear
translate([0, 0, -y_bk0]) rotate([90, 0, 0]) ai_back_plate(); // Make module back
translate([0, 0, -y_cr0]) rotate([90, 0, 0]) ai_carrier(); // Make module carrier

ai_face_print(); // Make print face black,#4ba3d1,#7a4a2c,white

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-50
//inside_view(); // Make view inside 60,0,-55
//assembled_view(); // Make view back 75,0,155
//face_view(); // Make view face 0,0,0
