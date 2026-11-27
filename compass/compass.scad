// Magnetic compass: the card on a 28BYJ-48 stepper
//
// The 172's wet compass (an Airpath C2300: 2.57" square front, about 4"
// deep), standing on the frame's right top bar over the panel (frame/),
// about where the windshield's middle is. The card is a drum turned by a
// 28BYJ-48 geared stepper; the X-Plane compass heading comes from
// MobiFlight on an Arduino Nano of its own (like every component), which
// homes the card on a hall sensor at start.
//
// - The drum is an inverted cup (top disc and band) pushed onto the
//   motor's shaft (double D bore, through: it stops where the flats end,
//   and a pin pushed in from the top on the shaft's end takes it off;
//   a sliding fit, a drop of CA glue if it turns on the shaft). It
//   hangs over the motor, which stands on two posts under its ears.
//   Windows in the top disc, between spokes, show the motor and the
//   sensor under the magnet pad.
// - The card is the band itself, printed in black: its ticks and
//   N 3 6 E 12 ... stand out of it (mark_h), white. Seen from the
//   front the numbers fall to the right (E is left of N), like on the real
//   card, which stays put while the aircraft turns around it.
// - Home: a disc magnet in a pad under the drum's top disc passes over a
//   digital hall sensor (A3144) lying on a post. MobiFlight turns the card
//   until the sensor pulls low and calls that its zero; wherever N is
//   then, an offset in MobiFlight's transform puts it under the lubber
//   line (see the README), so the magnet's place does not matter.
// - The case was printed around the earlier paper card, so the case's
//   sizes stay (y_bz) and the band is a little smaller (card_r) so the
//   marks clear the side walls.
// - The Nano lies in rails on the floor behind the motor, its USB jack at
//   the back wall, held by the base alone (the shell only clears it, so
//   it is tested with the shell off). Beside the jack two stops (a plug
//   pulled out pulls the board against them, they stand in pockets in the
//   back wall's foot) with hooks over the board's corners; in front of it
//   a stop (a plug pushed in pushes against it) and a printed keeper
//   screwed down over the far end's corners (keeper_*). The board goes in
//   jack end first under the hooks, then the far end down, then the
//   keeper on. The hooks and the keeper are over the board by the shared
//   rails' gap (nano_rail_gap), from print geometry only.
// - The ULN2003 driver board stands behind a plate at the back, far enough
//   in front of the back wall for the Dupont plugs on its pins
//   (uln_plug_room). The plate fills the case's section (the shell
//   round it), so no light of the board's LEDs or the Nano's gets to the
//   window; the Nano passes through a notch under it and the motor's
//   cable through a slot right of the board, both low, under the drum.
//   Light from these goes only under the drum, against the wire shield.
// - The coils stay on (MobiFlight holds the card), so the motor and the
//   ULN2003 get warm: slots in the floor under the drum let air in, it
//   rises past the motor, out through the drum's windows and through slots
//   across the shell's top.
// - A wall under the drum (the wire shield), round its front half and up
//   into the band, the sensor post in it, hides the wires from the window
//   under the card.
// - Two colours: the marks, the bezel's lettering and the lubber line are
//   separate white parts (*_white STLs) in pockets of the black ones.
// - Parts: the base (floor with all of the above on it, printed flat),
//   the Nano keeper (printed flat),
//   the shell (sides, top and back, printed top down), the bezel (the
//   front with the window, printed back side down, the N-S and E-W
//   compensator screws as dummies, lettering for a paint pen; flat
//   behind), the bezel back (a plate behind it with the window, the glass
//   pocket in its front and the lubber line, printed back side down), the
//   drum (printed top down) and the stand (bolted onto the top bar's
//   slot). A clear sheet (cut from 1 mm PET or acrylic) lies in the bezel
//   back's pocket on a ledge round the window, held by the bezel (no
//   glue), its edges behind the bezel's front.
//
// Coordinates: x to the right, y away from the pilot, z up. The origin is
// the card's axis at the band's middle (the window's middle).
//
// Parts to buy:
// - 28BYJ-48 stepper (5 V) with its ULN2003 driver board (motor_*, uln_*)
// - Arduino Nano (ATmega328P, 5 V) and a USB cable (nano_*)
// - A3144 hall sensor (sensor), 2 x disc magnet 5 x 1 mm, stacked (magnet)
// - M3 self tapping screws: 2x 6 mm (motor ears), 6x 8 mm (ULN2003
//   board, Nano keeper), 4x 10 mm countersunk (bezel), 2x 10 mm countersunk (base into
//   the shell), 4x 10 mm countersunk (base onto the stand)
// - 2x M5 x 10 button head + T-nut (stand onto the top bar)
// - clear sheet 1 mm (glass_*), white filament (one colour: white acrylic paint)
//
// Assembly (one colour: paint the white parts first): stand onto the base (screws
// from inside), magnet into the drum's pad (check which face triggers the
// sensor), sensor onto its post, motor onto its posts, Nano into its
// rails (jack end under the hooks, far end down, the keeper screwed on), ULN2003 board behind its plate, the motor's cable through the slot
// beside it; wire it (see the README), no wires over the USB jack. Press
// the drum on. Shell over it (the USB cable through the notch), two
// screws from below, the glass into the bezel back, the bezel over it,
// both screwed on. Flash and set up MobiFlight and set the offset that
// puts N under the lubber line after homing.

$fn = 60;

include <nano.inc.scad>
include <usb.inc.scad>   // usb_plug: the plug through the back wall

// Preview: card at this heading, parts apart by explode
view_heading = 30;
explode = 30;

// --- The stepper drive (lib/stepper.inc.scad: the 28BYJ-48, the ULN2003
// board, the A3144 sensor, the magnet) ---
include <stepper.inc.scad>

motor_screw_head = 2.5;      // pan head over the ears

// --- The Nano (lib/nano.inc.scad), along y, its USB jack at the back end ---

// --- Housing (the C2300's front, 2.57") ---
body_w = 65;
body_h = 65;
corner_r = 6;
wall = 2.5;
floor_t = 2.5;
bezel_t = 4;
block = 7;                   // screw blocks and columns
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;
csk_d = 6.2;                 // M3 countersunk head
screw_depth = 9;

// --- Card ---
card_d = 57.5;               // the band, under the marks
mark_h = 0.6;                // the marks stand out of the band
mark_in = 0.6;               // and go this deep into it (white filament: thick enough not to look grey)
band_t = 1.2;
band_h = 22;
disc_t = 2;
hub_d = 10;
bore_play = 0.25;            // the double D bore over the shaft (sliding fit; a drop of CA if loose)
shaft_skin = 0.5;            // drum top over the shaft end
win_rim = 1.5;               // the top disc's windows from the hub, the band and the magnet pad
spoke_w = 4;                 // between the windows
side_gap_min = 0.6;          // card to the side walls
card_gap = 1;                // card to the bezel's back (the lubber line), at least
bz_back = 31.1;              // axis to the bezel back (the shell's front edge): the case is printed, keep it
tick_w = 1;                  // two lines of a 0.4 mm nozzle
tick_10 = 5;                 // every 10 degrees
tick_5 = 3;
tick_top = 1.5;              // band top to the ticks
label_size = 6.5;
label_y = 7;                 // label middle over the band bottom
card_font = "Liberation Sans:style=Bold";

// --- Window and bezel ---
window_d = 48;
window_h = band_h + 4;       // flat top and bottom: only the card shows
glass_t = 1;                 // MEASURE: clear sheet
glass_edge = 2;              // glass past the window, all round
bz_front_t = 2;              // the bezel, flat behind; the bezel back is the rest of bezel_t, the glass in a pocket in its front
lubber_w = 1.2;
comp_screw_d = 4;            // the dummy compensator screws
comp_screw_dx = 10;
font = "Liberation Sans:style=Bold";
text_size = 3;
label_raise = 0.6;
label_in = 0.6;              // the lettering, into the bezel's front
lubber_in = 1.5;             // the lubber bar's ends, into the ledge above and under the window

// --- Home sensor ---
mag_r = 20;                  // magnet and sensor from the axis
mag_skin = 0.8;              // over the magnet, in the top disc
pad_d = magnet[0] + 3;
sensor_gap = 1.5;            // magnet to the sensor
sensor_pocket = 0.8;
post_d = 6.5;                // motor posts
spost = 7;                   // sensor post, square

// --- Boards ---
br_t = 3;                    // ULN2003 plate
gusset = [8, 16];            // the plate's gussets: reach in front of it, height
plate_gap = 2;               // the plate to the card, at least
plate_clear = 0.5;           // the plate to the shell's inside: it fills the section, so no LED light gets past it
cable_slot = [8, 16];        // through the plate, right of the ULN2003 board: the motor's cable and plug
nano_clear = 5.5;            // the plate's notch over the Nano's top (the jack): room for its wires
uln_over = 4;                // the ULN2003 board's bottom over the notch's top
// --- Hooks over the Nano's jack end corners (on the base, beside the jack) and the keeper's hoods over its far end (the middle left free for an ICSP header) ---
hood_reach = 3;              // over the board, from its end
hood_x0 = 4.5;               // from the middle: clear of the jack
hood_t = 1.2;                // the hooks
keeper_t = 2;                // the keeper: a flat plate on the far stop and two bosses
keeper_sx = 13.5;            // its two screws (M3 self tapping, from above), from the middle
keeper_dy = 4;               // and behind the far stop's front
keeper_boss_d = 5.5;         // the bosses, and the screws' pan heads
keeper_hole = 6;             // pilot hole depth, from the boss top
// --- The USB plug's notch in the back wall ---
usb_clear = 0.4;             // the plug's housing to the notch, sides and top
// --- Wire shield and vents (the coils stay on: the motor and the ULN2003 get warm) ---
shield_t = 1.6;              // a wall under the drum, round its front half, the sensor post in it
shield_over = 6;             // its top over the band's bottom edge, inside the drum
shield_gap = 1;              // to the band's inside and under the magnet pad
vent_w = 2;                  // slots: in the floor under the drum, across the shell's top
vent_pitch = 4;
vent_rim = 1.5;              // floor slots to what stands on the floor
top_vent_n = 8;
top_vent_len = 40;
top_vent_y0 = 4;             // the first top slot's middle, behind the axis

// --- Stand, on the frame's 2020 top bar ---
rise = 25;                   // the compass's bottom over the bar
foot = [70, 20, 5];          // on the bar (20 wide)
foot_bolt_dx = 25;           // M5 into T-nuts in its top slot
m5_d = 5.3;
m5_head_d = 9.5;
neck = [28, 20];
stand_dy = 14;               // the stand's middle behind the axis
stand_screw = [8, 6];        // its 4 screws from its middle, x and y
bed = [255, 255];

// --- Calculated ---
card_r = card_d / 2;
card_ro = card_r + mark_h;                   // the marks' tops
band_ri = card_r - band_t;
z_top = band_h / 2;                          // drum top
z_band0 = -band_h / 2;
z_shaft_end = z_top - shaft_skin;
z_flange = z_shaft_end - shaft_len;          // the flange's top
z_hub0 = z_shaft_end - flat_len;
z_ear0 = z_flange - motor_flange_t;          // ear underside: the posts' tops
z_motor0 = z_ear0 - motor_h;
z_bot = -body_h / 2;
z_floor = z_bot + floor_t;
z_ceil = body_h / 2 - wall;
xi = body_w / 2 - wall;                      // inside, half width
y_bz = -bz_back;                             // bezel back, the shell's front edge
y_face = y_bz - bezel_t;
motor_y = motor_shaft_dy;                    // the motor body's middle
nano_y0 = motor_y + motor_cover[1] + 1;      // behind the wire cover
y_bi = nano_y0 + nano_board.y;               // back wall, inside: the board's end, the jack in the wall
notch_hw = usb_plug.x / 2 + usb_clear;       // the plug's notch, half width
stop_pocket = nano_rail_end - nano_board.y / 2 + 0.2;   // the jack stops, into the back wall
nano_c = [0, nano_y0 + nano_board.y / 2];    // the Nano's middle
nano_rail_y0 = nano_c.y - nano_rail_end;     // the front of the stop in front of it
y_back = y_bi + wall;
depth = y_back - y_face;
z_nano = z_floor + nano_under;               // Nano underside
nano_top = z_nano + nano_t + nano_usb[1];
usb_z = z_nano + nano_t + nano_usb[1] / 2;
z_notch = nano_top + nano_clear;             // the plate's notch for the Nano, top
z_uln0 = z_notch + uln_over;                 // ULN2003 board bottom
y_plate1 = y_bi - uln_plug_room - uln_t - uln_standoff;   // plate back
y_plate0 = y_plate1 - br_t;
uln_c = [0, z_uln0 + uln_board.y / 2];     // the ULN2003 board's middle, [x, z]
uln_holes = [for (h = uln_hole_xy) uln_c + h];
plate_w = uln_board.x + 2;
z_plate1 = z_uln0 + uln_board.y + 1;      // the ULN2003 board's top, and a little
cable_x0 = uln_board.x / 2 + 2;            // the cable slot, from the gusset out
keeper_z = nano_top_h + nano_rail_gap;       // the keeper's and the hooks' underside, over the floor
hook_z1 = keeper_z + hood_t;                 // the hooks' top, over the floor
jack_stop_x = usb_plug.x / 2 + 0.5;          // the jack stops' inner faces (nano_rails' stop_x)
keeper_sy = -nano_rail_end + keeper_dy;      // the keeper's screws, y from the Nano's middle
keeper_y1 = -nano_board.y / 2 + hood_reach;  // the keeper's back edge, over the board
pocket_h = hook_z1 + 0.5;                    // the shell's pockets for the jack stops, over the floor
notch_top = usb_z + usb_plug.y / 2 + usb_clear;
sx = xi - block / 2;                         // bezel screws, x and z
back_screws = [for (s = [-1, 1]) [s * sx, y_bi - block / 2]];
stand_screws = [for (x = [-1, 1], y = [-1, 1]) [x * stand_screw.x, stand_dy + y * stand_screw.y]];
// home sensor: magnet in a pad under the top disc, the sensor on a post
z_pad0 = z_top - mag_skin - magnet[1] - 0.1;
z_sensor1 = z_pad0 - sensor_gap;             // its flat face
z_spost = z_sensor1 - sensor.y + sensor_pocket;
spost_c = [0, -mag_r];
// window: round, flat top and bottom
glass = [window_d + 2 * glass_edge, window_h + 2 * glass_edge];
y_bzb = y_face + bz_front_t;                 // the bezel back's front, the glass's front
y_glass = y_bzb;
y_stop = y_bzb + glass_t;                    // the pocket's floor: the glass's back, on the bezel back's ledge
comp_hole = bz_front_t - 0.6;                // the dummy compensator screws' holes, deep
// wire shield: from the sensor post's front face out, under the band
shield_r0 = mag_r + spost / 2;
shield_r1 = shield_r0 + shield_t;
z_shield1 = z_band0 + shield_over;
// floor slots: inside the shield, in front of the stand's neck
vent_y1 = stand_dy - neck.y / 2 - vent_rim;
top_vent_y1 = y_bi - block - 1;              // the last top slot's middle, in front of the back columns
comp_z = -(window_h / 2 + (body_h / 2 - window_h / 2) * 0.35);

echo(compass_depth = depth, axis_to_face = y_face,
     compass_bottom = z_bot, stand = [stand_dy, rise]);

// --- Checks ---
assert(card_ro + side_gap_min <= xi, "Card rubs on the side walls");
assert(card_ro + card_gap <= bz_back, "Card rubs on the lubber line");
assert(band_t - mark_in >= 0.6, "Band too thin behind the marks");
assert(bz_front_t - label_in >= 1, "Bezel too thin behind the lettering");
assert(abs(comp_z) + comp_screw_d / 2 + 1.5 + text_size + 1 <= body_h / 2 - 1, "Lettering runs off the bezel");
assert(window_h / 2 + lubber_in <= body_h / 2 - wall, "Lubber bar's ends run out of the bezel back");
assert(norm([motor_cover[0] / 2, motor_y + motor_cover[1]]) <= band_ri - 0.5, "Wire cover runs into the band");
assert(z_band0 >= z_motor0 + motor_wire_h + 0.5, "Band hangs over the motor's wires");
assert(norm([motor_ear_dx + post_d / 2, motor_y]) <= band_ri - 0.5
       && norm([motor_ear_dx + motor_ear_w / 2, motor_y]) <= band_ri - 0.5, "Ears or posts run into the band");
assert(motor_ear_dx - post_d / 2 >= motor_d / 2 + 0.2, "Motor posts touch the motor body");
assert(z_hub0 >= z_flange + motor_boss[1] + 1, "Drum hub runs onto the motor's boss");
assert(z_pad0 >= z_flange + motor_screw_head + 1, "Magnet pad hits the ear screws");
assert(mag_r + pad_d / 2 <= band_ri - 0.5 && mag_r - pad_d / 2 >= hub_d / 2 + 0.5, "Magnet pad runs into the band or the hub");
assert(band_ri - win_rim - (hub_d / 2 + win_rim) >= 8, "No room for the drum's windows");
assert(norm([spost / 2, mag_r + spost / 2]) <= band_ri - 0.5, "Sensor post runs into the band");
assert(mag_r - spost / 2 >= motor_d / 2 - motor_y + 0.5, "Sensor post runs into the motor");
assert(sensor.z + 0.3 <= spost && sensor.x + 0.3 <= spost - 1, "Sensor does not fit its post");
assert(sensor_gap + 0.1 <= magnet_gap_max, "Magnet too far from the sensor");
assert(z_motor0 >= z_floor + 0.5, "Motor stands on the floor");
assert(nano_rail_hw + 0.2 <= motor_ear_dx - post_d / 2 || nano_rail_y0 >= motor_y + post_d / 2,
       "Nano rails run into the motor posts");
assert(z_plate1 <= z_ceil - 1, "ULN2003 board too high");

assert(y_plate0 >= card_ro + plate_gap, "ULN2003 plate runs into the card");
assert(y_plate0 >= motor_y + motor_cover[1] + 5, "No room for the motor's cable in front of the ULN2003 plate");
assert(z_floor + gusset[1] <= z_band0 - 1 || y_plate0 - gusset[0] >= card_ro + 1, "ULN2003 plate's gussets run into the card");
assert(norm([plate_w / 2 - 1, y_plate0 - gusset[0] - motor_y]) >= motor_d / 2 + 1, "ULN2003 plate's gussets run into the motor");
assert(y_plate1 <= y_bi - block - 0.5, "ULN2003 plate runs into the back columns");
assert(cable_x0 + cable_slot.x <= xi - plate_clear - 1, "Cable slot runs out of the plate");
assert(z_floor + cable_slot.y <= z_band0 - 1, "Cable slot not hidden under the drum");
assert(cable_x0 - 1 >= plate_w / 2, "Cable slot runs into the gusset");
assert(notch_hw <= usb_plug.x / 2 + 0.5 - 0.1, "The plug's housing runs into the jack stops");
assert(wall - stop_pocket >= 0.5, "Back wall too thin over the jack stops");
assert(nano_board.y / 2 - (nano_row_pins - 1) / 2 * nano_pin_pitch - nano_pad_d / 2 >= hood_reach + 0.3, "Nano hooks or keeper reach onto the pin rows");
assert(hood_x0 <= nano_rail_in - 2, "Nano hooks or keeper's hoods too narrow");
assert(hood_x0 >= nano_usb.x / 2 + 0.4, "Nano hooks run into the jack");
assert(jack_stop_x <= nano_rail_in - 1.5, "Nano jack stops too narrow");
assert(wall - stop_pocket >= 0.5 && body_h / 2 - wall - z_floor >= pocket_h, "No room for the jack stops' pockets");
assert(z_floor + keeper_z + keeper_t <= z_motor0 - 1, "Nano keeper runs into the motor");
assert(keeper_sx - keeper_boss_d / 2 >= nano_rail_in + 0.3, "Nano keeper's bosses run into the rails' grooves");
assert(nano_c.y + keeper_sy + keeper_boss_d / 2 <= y_plate0 - gusset[0]
       || keeper_sx + keeper_boss_d / 2 + 0.2 <= plate_w / 2 - 2, "Nano keeper's screws run into the ULN2003 plate's gussets");
assert(nano_c.y + keeper_sy + keeper_boss_d / 2 <= y_plate0 - 0.5, "Nano keeper runs into the ULN2003 plate");
assert(norm([keeper_sx, nano_c.y + keeper_sy]) >= card_ro + 1.8, "Nano keeper's screws not reached past the drum");
assert(keeper_dy >= nano_rail_stop / 2 && keeper_sy + keeper_boss_d / 2 >= keeper_y1, "Nano keeper's screws not beside its plate");
assert(keeper_t + keeper_hole >= 8 && keeper_z + floor_t - keeper_hole >= 0.6, "Nano keeper's pilot holes: too short for 8 mm screws, or through the floor");
assert(window_h <= window_d - 6, "Window as high as round");
assert(window_h / 2 >= band_h / 2, "Window smaller than the card");
assert(norm([glass.x / 2, glass.y / 2]) + 0.2 <= norm([sx, sx]) - csk_d / 2 - 1, "Bezel screws run into the glass");
assert(sx - block / 2 >= z_top + 0.5, "Bezel screw blocks run into the card");
assert(bz_front_t >= (csk_d - clear_d) / 2 + 0.3, "Bezel too thin for the screw heads");
assert(y_bz - y_stop >= 0.8, "Bezel back too thin behind the glass pocket");
assert(abs(comp_z) - comp_screw_d / 2 >= glass.y / 2 + 0.15 + 1, "Compensator screws run into the glass pocket");
for (s = stand_screws)
   assert(abs(s.x) + csk_d / 2 <= motor_ear_dx - post_d / 2 || abs(s.y - motor_y) >= post_d / 2 + csk_d / 2,
          "Stand screws under the motor posts")
   assert(s.y + csk_d / 2 <= nano_rail_y0 || abs(s.x) - csk_d / 2 >= nano_rail_hw + 0.2,
          "Stand screws under the Nano rails")
   assert(norm(s - spost_c) >= spost / 2 + csk_d / 2, "Stand screws under the sensor post");
assert(stand_dy + stand_screw.y + csk_d / 2 <= nano_rail_y0, "Stand screws under the Nano");
assert(foot.y <= 20 && foot_bolt_dx - m5_head_d / 2 >= neck.x / 2 + 1, "M5 heads run into the neck");
assert(abs(stand_screw.x) + 3 <= neck.x / 2 && abs(stand_screw.y) + 3 <= neck.y / 2, "Stand screws off the neck");
assert(rise - foot.z >= screw_depth + 2, "Stand neck too short for the screws");
assert(2 * PI * card_ro / 72 >= tick_w + 1, "Ticks too close");
assert(shield_r1 <= band_ri - shield_gap, "Wire shield rubs on the band");
assert(norm([spost / 2, shield_r0]) <= shield_r1, "Sensor post sticks out of the wire shield");
assert(mag_r + pad_d / 2 <= shield_r0 || z_shield1 <= z_pad0 - shield_gap, "Wire shield hits the magnet pad");
assert(z_shield1 > z_band0 + 2, "Wire shield does not reach up into the drum");
assert(sqrt(pow(motor_d / 2, 2) - pow(motor_y, 2)) <= shield_r0 - shield_gap, "Motor runs into the wire shield");
assert(motor_y - post_d / 2 >= shield_gap, "Motor posts run into the wire shield's ends");
assert(norm([sx - block / 2, y_bz + block + 1]) >= shield_r1 + shield_gap, "Wire shield runs into the bezel's posts");
assert(vent_y1 > 0, "No room for the floor slots in front of the stand");
assert(top_vent_len / 2 <= body_w / 2 - corner_r - 1 && top_vent_len / 2 <= sx - block / 2 - 1, "Top slots run into the shell's corners or the back columns");
assert(top_vent_y0 - vent_w / 2 >= y_bz + block + 2, "Top slots run into the bezel's screw blocks");
assert((top_vent_y1 - top_vent_y0) / (top_vent_n - 1) >= vent_w + 2, "Top slots too close");
assert(depth <= bed.x && body_w <= bed.y, "Shell does not fit the bed");

// --- Card geometry ---
// card angle (0 = +x, counterclockwise from above) of heading h with the
// card at heading H: h faces the pilot (-y) at H = h; the card turns
// counterclockwise (seen from above) as the heading grows
function card_angle(h, H = 0) = -90 - h + H;
function card_label(h) = h == 0 ? "N" : h == 90 ? "E" : h == 180 ? "S" : h == 270 ? "W" : str(h / 10);

// A mark (tick, label) flat: x along the band, y = z
module card_mark_2d(h) {
   len = h % 10 == 0 ? tick_10 : tick_5;
   translate([-tick_w / 2, z_top - tick_top - len]) square([tick_w, len]);
   if (h % 30 == 0)
      translate([0, z_band0 + label_y])
         text(card_label(h), size = label_size, font = card_font, halign = "center", valign = "center");
}

// --- Helpers ---
// The front outline: x, z
module section(inset = 0) {
   offset(r = corner_r - inset) square([body_w - 2 * corner_r, body_h - 2 * corner_r], center = true);
}

// along y, from y0 to y1
module along_y(y0, y1) {
   translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}

module window_2d(grow = 0) {
   intersection() {
      circle(d = window_d + 2 * grow, $fn = 120);
      square([window_d + 2 * grow, window_h + 2 * grow], center = true);
   }
}

module csk_hole(depth_ = 20) {
   // countersunk from z = 0 into -z
   translate([0, 0, -depth_]) cylinder(d = clear_d, h = depth_ + 0.01);
   translate([0, 0, -(csk_d - clear_d) / 2]) cylinder(d1 = clear_d, d2 = csk_d, h = (csk_d - clear_d) / 2 + 0.01);
   cylinder(d = csk_d, h = 5);
}

module double_d(d, flat, h) {
   intersection() {
      cylinder(d = d, h = h);
      translate([-d / 2, -flat / 2, 0]) cube([d, flat, h]);
   }
}

// --- Drum ---
// Two colours: drum() is the black part, drum_marks() the white one (the
// marks, standing out of the band and inlaid into it, their tops on its
// cylinder), the same place in the print; drum_body() is the drum without
// the marks' pockets.
module drum_marks() {
   intersection() {
      for (h = [0 : 5 : 355]) rotate([0, 0, card_angle(h)])
         translate([band_ri, 0, 0]) rotate([90, 0, 90]) linear_extrude(card_ro + 1 - band_ri) card_mark_2d(h);
      translate([0, 0, z_band0]) difference() {
         cylinder(r = card_ro, h = band_h, $fn = 360);
         translate([0, 0, -1]) cylinder(r = card_r - mark_in, h = band_h + 2, $fn = 360);
      }
   }
}

module drum() {
   difference() {
      drum_body();
      drum_marks();
   }
}

module drum_body() {
   difference() {
      union() {
         // top disc and band
         translate([0, 0, z_top - disc_t]) cylinder(r = card_r, h = disc_t, $fn = 180);
         translate([0, 0, z_band0])
            difference() {
               cylinder(r = card_r, h = band_h, $fn = 180);
               translate([0, 0, -1]) cylinder(r = band_ri, h = band_h + 2, $fn = 180);
            }
         // hub
         translate([0, 0, z_hub0]) cylinder(d = hub_d, h = z_top - z_hub0);
         // magnet pad, in front at home
         translate([spost_c.x, spost_c.y, z_pad0]) cylinder(d = pad_d, h = z_top - z_pad0);
      }
      translate([0, 0, z_hub0 - 0.01]) double_d(shaft_d + bore_play, shaft_flat + bore_play, z_top - z_hub0 + 1);
      translate([spost_c.x, spost_c.y, z_pad0 - 0.01]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 0.1 + 0.01);
      // windows: four between spokes, the one to the pad as wide as the pad
      translate([0, 0, z_top - disc_t - 1]) linear_extrude(disc_t + 2) drum_windows_2d();
   }
}

module drum_windows_2d() {
   difference() {
      circle(r = band_ri - win_rim, $fn = 180);
      circle(d = hub_d + 2 * win_rim);
      for (a = [0 : 90 : 270]) rotate(a) translate([0, -spoke_w / 2]) square([card_r, spoke_w]);
      hull() {
         translate(spost_c) circle(d = pad_d + 2 * win_rim);
         translate([-spoke_w / 2, 0]) square([spoke_w, 0.01]);
      }
   }
}

// --- Base: the floor with the motor, the sensor and the boards on it ---
module base() {
   difference() {
      union() {
         // floor: the bottom of the front outline
         intersection() {
            along_y(y_bz, y_back) section();
            translate([-body_w, y_bz - 1, z_bot]) cube([2 * body_w, depth + 2, floor_t]);
         }
         // motor posts
         for (s = [-1, 1]) translate([s * motor_ear_dx, motor_y, z_floor - 0.01])
            cylinder(d = post_d, h = z_ear0 - z_floor + 0.01);
         // sensor post
         translate([spost_c.x - spost / 2, spost_c.y - spost / 2, z_floor - 0.01])
            cube([spost, spost, z_spost - z_floor + 0.01]);
         // Nano rails (no lips), through the ULN2003 plate: the stop in front
         // of it (up to the keeper's seat) and the keeper's bosses, the stops
         // beside the jack with hooks over its corners. The jack end goes in
         // under the hooks, the far end drops in, the keeper is screwed on.
         translate([nano_c.x, nano_c.y, z_floor]) {
            nano_rails(far_stop = true, jack_stop = true, plug_w = usb_plug.x, lips = false);
            translate([-nano_rail_in, -nano_rail_end, 0]) cube([2 * nano_rail_in, nano_rail_stop, keeper_z]);
            for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) {
               // the hook, over the board beside the jack up to its end (the plug's housing is behind it)
               translate([hood_x0, nano_board.y / 2 - hood_reach, keeper_z])
                  cube([nano_rail_in - hood_x0 + 0.01, hood_reach + nano_rail_end_clear, hood_t]);
               // the rail wall and the stop up to the hook's top
               translate([nano_rail_in, nano_board.y / 2 - hood_reach, 0])
                  cube([nano_rail_w, nano_rail_end - nano_board.y / 2 + hood_reach, hook_z1]);
               translate([jack_stop_x, nano_rail_end - nano_rail_stop, 0])
                  cube([nano_rail_in - jack_stop_x + 0.01, nano_rail_stop, hook_z1]);
               // the keeper's boss
               translate([keeper_sx, keeper_sy, 0]) cylinder(d = keeper_boss_d, h = keeper_z);
            }
         }
         // wire shield round the drum's front half, under the band
         translate([0, 0, z_floor - 0.01]) linear_extrude(z_shield1 - z_floor + 0.01)
            shield_2d();
         // ULN2003 plate, wall to wall and up to the top (only the floor and
         // the shell round it): the Nano through a notch under it, the motor's
         // cable through a slot right of the board, gussets in front
         difference() {
            intersection() {
               along_y(y_plate0, y_plate1) section(wall + plate_clear);
               translate([-body_w, y_plate0 - 1, z_floor - 0.01]) cube([2 * body_w, br_t + 2, body_h]);
            }
            translate([-nano_rail_hw - 0.5, y_plate0 - 1, z_floor - 1])
               cube([2 * nano_rail_hw + 1, br_t + 2, z_notch - z_floor + 1]);
            translate([cable_x0, y_plate0 - 1, z_floor - 1])
               cube([cable_slot.x, br_t + 2, cable_slot.y + 1]);
         }
         for (s = [-1, 1])
            translate([s * (plate_w / 2 - 1), y_plate0 + 0.01, z_floor - 0.01])
               rotate([90, 0, 90]) translate([0, 0, -1])
                  linear_extrude(2) polygon([[0, 0], [-gusset[0], 0], [0, gusset[1]]]);
         // ULN2003 standoffs, behind the plate
         for (h = uln_holes) translate([h.x, y_plate1 - 0.01, h.y]) rotate([-90, 0, 0])
            cylinder(d = uln_standoff_d, h = uln_standoff + 0.01);
         // front corner posts: the bezel's lower screws
         for (s = [-1, 1]) intersection() {
            translate([s * sx - block / 2, y_bz, z_floor - 0.01]) cube([block, block + 1, block + 0.01]);
            along_y(y_bz, y_back) section(wall - 0.01);
         }
      }
      // vent slots under the drum
      translate([0, 0, z_bot - 1]) linear_extrude(floor_t + 2) floor_vents_2d();
      // the Nano keeper's screws
      for (s = [-1, 1]) translate([nano_c.x + s * keeper_sx, nano_c.y + keeper_sy, z_floor + keeper_z - keeper_hole])
         cylinder(d = pilot_d, h = keeper_hole + 1);
      // motor ear screws
      for (s = [-1, 1]) translate([s * motor_ear_dx, motor_y, z_ear0 - screw_depth])
         cylinder(d = pilot_d, h = screw_depth + 1);
      // sensor pocket (flat face up, legs towards the axis) and the legs' groove down the post
      translate([spost_c.x - sensor.x / 2 - 0.15, spost_c.y - sensor.z / 2 - 0.15, z_spost - sensor_pocket])
         cube([sensor.x + 0.3, sensor.z + 0.3, sensor_pocket + 1]);
      translate([spost_c.x - sensor_legs_w / 2, spost_c.y, z_spost - sensor_pocket])
         cube([sensor_legs_w, spost / 2 + 0.01, sensor_pocket + 1]);
      translate([spost_c.x - sensor.x / 2 - 0.15, spost_c.y + spost / 2 - 1.2, z_floor])
         cube([sensor.x + 0.3, 2, z_spost - z_floor + 1]);
      // ULN2003 board screws through the standoffs and the plate
      for (h = uln_holes) translate([h.x, y_plate0 - 1, h.y]) rotate([-90, 0, 0])
         cylinder(d = pilot_d, h = br_t + uln_standoff + 2);
      // bezel's lower screws
      for (s = [-1, 1]) translate([s * sx, y_bz - 1, -sx]) rotate([-90, 0, 0])
         cylinder(d = pilot_d, h = screw_depth + 1);
      // into the shell's back columns (from below) and onto the stand (from inside)
      for (b = back_screws) translate([b.x, b.y, z_bot]) rotate([180, 0, 0]) csk_hole();
      for (s = stand_screws) translate([s.x, s.y, z_floor]) csk_hole();
      // a notch in the front edge (the front mark for the paper card, no longer needed: the base is printed)
      translate([0, y_bz - 0.01, z_bot - 1]) linear_extrude(floor_t + 2)
         polygon([[-1.5, 0], [1.5, 0], [0, 2]]);
   }
}

// --- Nano keeper: a flat plate over the far stop and the board's far
// corners (the middle free for an ICSP header), screwed onto two bosses ---
module keeper_2d() {
   difference() {
      union() {
         translate([-nano_rail_hw, -nano_rail_end]) square([2 * nano_rail_hw, keeper_y1 + nano_rail_end]);
         for (s = [-1, 1]) hull() {
            translate([s * keeper_sx, keeper_sy]) circle(d = keeper_boss_d);
            translate([s > 0 ? nano_rail_in : -keeper_sx, -nano_rail_end]) square([keeper_sx - nano_rail_in, keeper_y1 + nano_rail_end]);
         }
      }
      translate([-hood_x0, -nano_board.y / 2 - nano_rail_end_clear]) square([2 * hood_x0, nano_board.y]);
      for (s = [-1, 1]) translate([s * keeper_sx, keeper_sy]) circle(d = clear_d);
   }
}
module keeper() {
   translate([nano_c.x, nano_c.y, z_floor + keeper_z]) linear_extrude(keeper_t) keeper_2d();
}

// the wire shield: half a ring in front (y <= 0), the sensor post in it
module shield_2d() {
   intersection() {
      difference() {
         circle(r = shield_r1, $fn = 180);
         circle(r = shield_r0, $fn = 180);
      }
      translate([-shield_r1 - 1, -shield_r1 - 1]) square([2 * shield_r1 + 2, shield_r1 + 1]);
   }
}

// slots in the floor: inside the shield, in front of the stand's neck, clear
// of the sensor post; under the motor, so the air rises past it and out
// through the drum's windows
module floor_vents_2d() {
   intersection() {
      for (y = [vent_y1 - vent_w / 2 : -vent_pitch : -shield_r0])
         translate([-shield_r0, y - vent_w / 2]) square([2 * shield_r0, vent_w]);
      difference() {
         intersection() {
            circle(r = shield_r0 - vent_rim, $fn = 180);
            translate([-shield_r0, -shield_r0]) square([2 * shield_r0, shield_r0 + vent_y1]);
         }
         translate(spost_c) square(spost + 2 * vent_rim, center = true);
      }
   }
}

// --- Shell: sides, top and back ---
module shell() {
   difference() {
      union() {
         difference() {
            along_y(y_bz, y_back) section();
            along_y(y_bz - 1, y_bi) section(wall);
            translate([-body_w, y_bz - 2, z_bot - 1]) cube([2 * body_w, depth + 4, z_floor - z_bot + 1]);
         }
         // top front blocks: the bezel's upper screws
         for (s = [-1, 1]) intersection() {
            translate([s * sx - block / 2, y_bz, sx - block / 2]) cube([block, block + 1, z_ceil - sx + block / 2 + 0.01]);
            along_y(y_bz, y_back) section(wall - 0.01);
         }
         // back columns: the base's screws
         for (b = back_screws) intersection() {
            translate([b.x - block / 2, b.y - block / 2, z_floor]) cube([block, block + 0.01, z_ceil - z_floor + 0.01]);
            along_y(y_bz, y_back) section(wall - 0.01);
         }
      }
      for (s = [-1, 1]) translate([s * sx, y_bz - 1, sx]) rotate([-90, 0, 0])
         cylinder(d = pilot_d, h = screw_depth + 1);
      for (b = back_screws) translate([b.x, b.y, z_floor - 0.01]) cylinder(d = pilot_d, h = screw_depth);
      // vent slots across the top, behind the axis
      for (i = [0 : top_vent_n - 1])
         translate([-top_vent_len / 2, top_vent_y0 + i * (top_vent_y1 - top_vent_y0) / (top_vent_n - 1) - vent_w / 2, z_ceil - 1])
            cube([top_vent_len, vent_w, wall + 2]);
      // USB plug notch
      translate([-notch_hw, y_bi - 0.01, z_floor - 1]) cube([2 * notch_hw, wall + 1, notch_top - z_floor + 1]);
      // pockets for the base's jack stops and the rails' ends, in the back wall's foot
      translate([-nano_rail_hw - 0.2, y_bi - 0.01, z_floor - 1]) cube([2 * nano_rail_hw + 0.4, stop_pocket + 0.01, pocket_h + 1]);
   }
}

// --- Bezel: the front, with the window, flat behind ---
module bezel() {
   difference() {
      union() {
         // plate, its front edge chamfered
         along_y(y_face + 1, y_bzb) section();
         hull() {
            along_y(y_face, y_face + 0.01) section(1);
            along_y(y_face + 1, y_face + 1.01) section();
         }
      }
      // the lettering's pockets (bezel_labels)
      bezel_labels();
      // window
      along_y(y_face - 1, y_bzb + 1) window_2d();
      // corner screws, countersunk from the front
      for (x = [-1, 1], z = [-1, 1]) translate([x * sx, y_face, z * sx]) rotate([90, 0, 0]) csk_hole();
      // compensator screws (dummies): a hole each, the slot stands in it
      for (s = [-1, 1]) translate([s * comp_screw_dx, y_face - 1, comp_z]) rotate([-90, 0, 0])
         cylinder(d = comp_screw_d, h = 1 + comp_hole);
   }
   // the screw slots in their holes
   for (s = [-1, 1]) translate([s * comp_screw_dx, y_face, comp_z]) rotate([0, 45 * s, 0])
      translate([-comp_screw_d / 2 + 0.2, 0, -0.4]) cube([comp_screw_d - 0.4, comp_hole, 0.8]);
}

// the lettering, white: standing out of the front and inlaid into it
module bezel_labels() {
   translate([0, y_face + label_in, 0]) rotate([90, 0, 0]) linear_extrude(label_in + label_raise) bezel_labels_2d();
}

// --- Bezel back: the glass in a pocket in its front, on a ledge round the window, and the lubber line ---
// the lubber line, white: a bar across the window behind the glass, its ends in the ledge
module lubber() {
   translate([-lubber_w / 2, y_stop, -window_h / 2 - lubber_in]) cube([lubber_w, y_bz - y_stop, window_h + 2 * lubber_in]);
}

module bezel_back() {
   difference() {
      along_y(y_bzb, y_bz) section();
      along_y(y_bzb - 1, y_bz + 1) window_2d();
      translate([-glass.x / 2 - 0.15, y_bzb - 1, -glass.y / 2 - 0.15]) cube([glass.x + 0.3, y_stop - y_bzb + 1, glass.y + 0.3]);
      for (x = [-1, 1], z = [-1, 1]) translate([x * sx, y_bzb - 1, z * sx]) rotate([-90, 0, 0])
         cylinder(d = clear_d, h = bezel_t + 2);
      lubber();
   }
}

module bezel_labels_2d() {
   for (s = [-1, 1])
      translate([s * comp_screw_dx, comp_z - comp_screw_d / 2 - 1.5])
         text(s < 0 ? "N-S" : "E-W", size = text_size, font = font, halign = "center", valign = "top");
}

// --- Stand: foot on the top bar, neck up to the base ---
module stand() {
   difference() {
      union() {
         translate([-foot.x / 2, -foot.y / 2, 0]) cube(foot);
         translate([-neck.x / 2, -neck.y / 2, 0]) cube([neck.x, neck.y, rise]);
      }
      for (s = [-1, 1]) translate([s * foot_bolt_dx, 0, -1]) cylinder(d = m5_d, h = foot.z + 2);
      for (x = [-1, 1], y = [-1, 1]) translate([x * stand_screw.x, y * stand_screw.y, rise - screw_depth])
         cylinder(d = pilot_d, h = screw_depth + 1);
   }
}

// --- View only: bought parts ---
c_body = "#1d1f22";
c_label = "#f4f4f4";
c_lubber = "#f4f4f4";
c_steel = "#b9c0c8";
c_board = "#1d4fa0";
c_glass = [0.75, 0.85, 0.95, 0.12];
c_stand = "#3d7bd9";
c_alu = "#c3c9d0";
c_magnet = "#8a8f96";

module motor_part() {
   translate([0, 0, z_flange]) motor_local();
   color("#d9d9d9") for (s = [-1, 1]) translate([s * motor_ear_dx, motor_y, z_flange]) cylinder(d = 5.5, h = motor_screw_head);
}

module compass_nano_part() {
   translate([nano_c.x, nano_c.y, z_floor])
      nano_part(c_board);
}

// the ULN2003 board standing on its plate, its parts back
module compass_uln_part() {
   translate([uln_c.x, y_plate1, uln_c.y])
      multmatrix([[-1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
         uln_part();
}

module sensor_part() {
   color("#202020") translate([spost_c.x - sensor.x / 2, spost_c.y - sensor.z / 2, z_spost - sensor_pocket]) cube([sensor.x, sensor.z, sensor.y]);
   color(c_steel) for (i = [-1 : 1]) translate([spost_c.x + i * 1.27 - 0.2, spost_c.y + sensor.z / 2, z_spost - sensor_pocket + 0.5])
      cube([0.4, spost / 2 - sensor.z / 2 + 0.8, 0.4]);
}

module magnet_part(H) {
   rotate([0, 0, H]) color(c_magnet) translate([spost_c.x, spost_c.y, z_pad0]) cylinder(d = magnet[0], h = magnet[1]);
}

module glass_part() {
   color(c_glass) translate([-glass.x / 2, y_glass, -glass.y / 2]) cube([glass.x, glass_t, glass.y]);
}

// the drum's marks, painted white
module card_part(H) {
   rotate([0, 0, H]) color(c_label) render() drum_marks();
}

module top_bar_part() {
   color(c_alu) translate([-60, -10, -20]) cube([120, 20, 20]);
}

module labels_part() {
   color(c_label) bezel_labels();
}

module lubber_part() {
   color(c_lubber) lubber();
}

module compass_parts(H, e = 0, with_shell = true) {
   translate([0, 0, -e]) {
      color(c_body) base();
      motor_part();
      compass_nano_part();
      translate([0, 0, e / 3]) color(c_body) keeper();
      compass_uln_part();
      sensor_part();
   }
   translate([0, 0, e]) {
      rotate([0, 0, H]) color(c_body) render() drum();
      magnet_part(H);
      card_part(H);
   }
   if (with_shell) {
      translate([0, 0, 3.5 * e]) color(c_body) shell();
      translate([0, -2 * e, 0]) {
         color(c_body) bezel();
         translate([0, e / 2, 0]) {
            color(c_body) bezel_back();
            lubber_part();
            glass_part();
         }
         labels_part();
      }
   }
}

module on_stand(e = 0) {
   translate([0, 0, rise - z_bot]) children();
   translate([0, stand_dy, -e]) {
      color(c_stand) stand();
      top_bar_part();
   }
}

module assembled_view(H = view_heading) {
   on_stand() compass_parts(H);
}

module exploded_view(H = view_heading) {
   on_stand(explode) compass_parts(H, explode);
}

module inside_view(H = view_heading) {
   compass_parts(H, explode / 2, with_shell = false);
}

// --- Printable parts, in print orientation ---
translate([0, 0, -z_bot]) base(); // Make module base
translate([0, 0, body_h / 2]) rotate([180, 0, 0]) shell(); // Make module shell
translate([0, 0, -z_floor - keeper_z]) keeper(); // Make module keeper
// Two colours: each part with white on it is two STLs in the same place,
// <part> (black) and <part>_white; load both into the slicer at once as one
// object with two parts and give each its filament
translate([0, 0, y_bzb]) rotate([-90, 0, 0]) bezel(); // Make module bezel
translate([0, 0, y_bzb]) rotate([-90, 0, 0]) bezel_labels(); // Make module bezel_white
translate([0, 0, y_bz]) rotate([-90, 0, 0]) bezel_back(); // Make module bezel_back
translate([0, 0, y_bz]) rotate([-90, 0, 0]) lubber(); // Make module bezel_back_white
translate([0, 0, z_top]) rotate([180, 0, 0]) drum(); // Make module drum
translate([0, 0, z_top]) rotate([180, 0, 0]) drum_marks(); // Make module drum_white
stand(); // Make module stand

//assembled_view(); // Make view main 70,0,-35
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 65,0,-40
//inside_view(); // Make view inside 55,0,-140
//assembled_view(); // Make view back 60,0,150
