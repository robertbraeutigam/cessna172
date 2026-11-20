// KMA 26 audio panel
//
// A home cockpit copy of the Bendix/King KMA 26 audio panel, the top unit
// of the radio stack (radio.inc.scad), over the two KX155s and as wide as
// them; its height is the real 1.30". The face copies the real one, spread
// out to the stack's width:
// - at the left the marker beacon lamps O (blue), M (amber), I (white),
//   a dummy photocell and the MKR MUTE button
// - two small toggle switches: HI SENS / LO SENS / TEST (marker
//   sensitivity, TEST momentary) and PILOT / CREW / ALL (intercom)
// - the INTERCOM knob (VOL)
// - the 10 audio select buttons in two rows, COM1 COM2 COM3 NAV1 NAV2 and
//   MKR DME ADF AUX MONI, each with its annunciator bar
// - at the right the MIC selector knob: EMG, C1, C2, C3, PA
// The real knobs are dual concentric (intercom: VOL and CREW/PASS; mic:
// the selector and PUSH SPKR). X-Plane has nothing for the second knob, so
// each is one printed knob shaped like the pair, on one shaft.
//
// - Buttons: printed caps through the face, held by their flange behind
//   the plate, a post on their back presses a tactile switch. The
//   annunciator bar is a slot through the cap; a 2 x 5 mm rectangular LED
//   on the board reaches into a channel in the cap's back and lights it.
// - Marker lamps: printed lenses (natural, translucent filament, the
//   letter engraved into the front), their ears clamped in a pocket of
//   the plate front by the face; a 3 mm LED in its own cell behind each.
// - Toggles: mini toggle switches (MTS type, 6 mm bushing), the volume a
//   10 kOhm pot, the mic selector the KT 76C's 1 pole 12 way rotary switch
//   set to 5 positions; all nutted onto the face.
// - Inside: two front perfboards on bosses on the plate back: the marker
//   board (lamp LEDs, MKR MUTE switch) and the button board (10 switches,
//   10 LEDs), every LED with its resistor beside it. The radio stack's Mega
//   has only 5 pins left, so the audio panel has its own MobiFlight board:
//   an Arduino Nano on the logic board, a perfboard in rails on the
//   floor (like the KX155's driver boards) with a CD74HC4067 mux for the
//   inputs and two 74HC595 shift registers for the 13 lamps. Its USB
//   cable runs out of the open back to the powered USB hub, tied onto
//   tie_block.
//
// Coordinates: radio.inc.scad (installed: x right, y backwards, z up).
// Printed: the body front side down, the face front side up, the button
// caps (gray, the labels engraved, fill them with white paint), the MKR
// MUTE cap (white) and the knobs on their front, the lenses (natural)
// front side down.
//
// Parts to buy:
// - 1 Arduino Nano (ATmega328P, 5 V) and its USB cable (nano_*)
// - 1 CD74HC4067 mux breakout (mux_board), 2 74HC595 + DIP 16 sockets
// - 1 rotary switch, 1 pole 12 way, 6 mm shaft, with stop washer (rot_*)
// - 1 pot 10 kOhm linear, 6 mm shaft (vol_*)
// - 1 mini toggle ON-OFF-(ON) (TEST momentary), 1 mini toggle ON-OFF-ON,
//   6 mm bushing (tg_*)
// - 11 tactile switches 6 x 6 mm, 5 mm high (tact)
// - 10 rectangular LEDs 2 x 5 mm, white (bar_led), 3 mm LEDs: 1 blue,
//   1 amber, 1 white (led), 13 resistors 1 kOhm
// - perfboard: marker board, button board, logic board
// - M3: 4x M3x10 pan head + nuts (face onto the sheet), 4x M3x8 self
//   tapping (front boards onto the bosses)
//
// Assembly: lenses into their pockets in the plate front, face on (it
// clamps them). Button caps and the MUTE cap in from the back. Solder the
// switches, LEDs and resistors onto the front boards (the LEDs standing
// on the board), screw them onto their bosses. Toggles, pot and rotary
// switch through plate and face from the back, nuts on the front. Logic
// board into its rails, wiring, USB cable tied onto the tie block. Knobs
// on last, the mic knob pointing at EMG with the switch turned fully left.
// Into the sheet over the KX155s, the 4 screws through the end flanges.

$fn = 64;

include <radio.inc.scad>

explode = 30;

// --- Unit ---
ap_h = 33;                   // KMA 26 face height, 1.30"

// --- Mini toggle switch, MEASURE (MTS type, 6 mm bushing; guesses) ---
tg_bush = [6, 9];            // threaded bushing: diameter, length from the mounting face
tg_nut = [9, 2];             // its nut: across flats, thickness
tg_body = [8, 13, 10];       // body: x, z (along the throw), depth behind the mounting face
tg_lugs = 5;                 // solder lugs behind the body
tg_bat = [2.5, 9];           // lever: diameter, length from the bushing's end
tg_throw = 25;               // degrees each way (views)

// --- Volume pot, MEASURE (16 mm, 6 mm shaft; guesses) ---
vol_bush = [7, 7];
vol_nut = [10, 2];
vol_body = [17, 10];         // diameter, depth behind the mounting face (with the lugs)
vol_shaft = [6, 15];         // diameter, length from the mounting face

// --- Rectangular LED for the annunciator bars, MEASURE ---
bar_led = [5, 2, 7];         // x, z, height over the board

// --- Arduino Nano, MEASURE ---
nano_board = [18, 45];       // x, y (the USB jack at the back end)
nano_high = 14;              // over the logic board: female header, board, USB jack

// --- CD74HC4067 breakout (switchpanel/switches.scad) ---
mux_board = [41, 18];

// --- Logic board ---
lg_board = [72, 50];         // perfboard in the rails: x, y
lg_high = 14;                // the parts on it, above the board
lg_cx = 131;                 // its middle

// --- Marker lamps, top to bottom ---
lamps = [["O", "#2448c8"], ["M", "#e8901c"], ["I", "#f2f2ee"]];
lamp_x = 16;
lamp_z0 = 24;                // top lamp
lamp_pitch = 7.5;
lamp = [6, 5.5];             // window: x, z
lamp_ear = 1.2;              // lens ears, left and right
lamp_ear_t = 0.8;            // in a pocket in the plate front
lamp_text = 4;
lamp_engrave = 0.5;
cell_wall = 0.8;

// --- MKR MUTE, photocell (a dummy: a hole in the face) ---
mute_x = 25;
mute_z = 12.5;
mute_d = 4.5;                // cap at the face
mute_out = 1.5;              // in front of the face
mute_flange = [7.5, 1.2];    // diameter, thickness
cell_pos = [25, 18.5];
cell_d = 3.2;

// --- Toggles ---
tg_x = 37;
tg_zs = [23.5, 9.5];
tg_labels = [["HI SENS", "LO SENS", "TEST"], ["PILOT", "CREW", "ALL"]];
tg_line = 3.4;               // label line pitch, the middle line at the switch

// --- Buttons ---
btn = [15, 10.5];            // cap at the face: x, z
btn_out = 2;                 // in front of the face
btn_flange = [17.5, 12.5, 1.2];
btn_play = 0.2;
btn_r = 1;
btn_text = 2.6;
btn_text_dz = 1.8;           // label over the cap's middle
bar = [9, 1.2];              // annunciator slot: x, z
bar_dz = -2.8;               // its middle under the cap's
bar_in = 1;                  // LED tip into the cap's channel
tact_dz = 1.9;               // tactile switch over the cap's middle
btn_x0 = 93;
btn_pitch = 18.5;
btn_zs = [23.2, 9.4];        // rows, top to bottom
btn_names = [["COM1", "COM2", "COM3", "NAV1", "NAV2"], ["MKR", "DME", "ADF", "AUX", "MONI"]];
groove = [0.6, 0.4];         // divider lines left and right of the buttons: width, depth
groove_dx = 3.5;             // from the outer caps
hole_d = 2;                  // the small dummy hole between COM2 and COM3

// --- Knobs ---
vol_x = 67;
vol_z = 16.5;
mic_x = 197;
mic_z = 16;
mics = ["EMG", "C1", "C2", "C3", "PA"];
mic_a0 = -60;                // EMG, degrees clockwise from up
mic_r = 12;                  // labels' inner end from the knob axis
knob_gap = 0.5;              // knob back to the face
// stepped knobs: back part (diameter, length, ribs), front part (diameter, ribs)
v_back_part = [14.5, 4.5, 30];
v_front_part = [10, 20];
v_front = 1.5;               // in front of the shaft's tip
m_back_part = [20, 5.5, 36];
m_front_part = [13, 24];
m_front = 1.5;

// --- Lettering ---
lbl_big = 2.8;
lbl_small = 2.0;

// --- Body ---
board_gap = 0.5;
board_edge = 0.5;            // front boards to the walls
lg_gap = 3;                  // logic board behind the parts on the face
tie_x = 175;

// --- Calculated ---
x_in0 = flange_w + wall;
x_in1 = unit_w - flange_w - wall;
lamp_zs = [for (i = [0 : len(lamps) - 1]) lamp_z0 - i * lamp_pitch];
btn_xs = [for (i = [0 : 4]) btn_x0 + i * btn_pitch];
// Buttons: [label, x, z]
buttons = [for (r = [0, 1], c = [0 : 4]) [btn_names[r][c], btn_xs[c], btn_zs[r]]];
groove_xs = [btn_xs[0] - btn.x / 2 - groove_dx, btn_xs[4] + btn.x / 2 + groove_dx];
hole_pos = [(btn_xs[1] + btn_xs[2]) / 2, (btn_zs[0] + btn_zs[1]) / 2];

btn_y1 = plate_t + btn_flange.z;             // flange back
board_y = btn_y1 + bar_led.z - bar_in;       // front boards' front
btn_stem = board_y - tact.y - tact.z - btn_y1;   // post behind the flange onto the switch
btn_len = face_t + btn_out + plate_t;        // the part through the face
mute_len = face_t + mute_out + plate_t;
chan = [max(bar_led.x + 0.6, bar.x), bar_led.y + 0.6];   // LED channel in the cap

// Front boards: [x0, x1], z from board_z[0] to board_z[1]
board_z = [wall + board_gap, ap_h - wall - board_gap];
mk_board_x = [x_in0 + board_edge, mute_x + 6.5];
bt_margin = 6.5;                             // button board beyond the outer flanges' pitch
bt_board_x = [btn_xs[0] - btn_pitch / 2 - bt_margin, btn_xs[4] + btn_pitch / 2 + bt_margin];
bosses = [[mute_x + 3.5, 5.5], [mute_x + 3.5, 27],
          [bt_board_x[0] + 3.3, ap_h / 2], [bt_board_x[1] - 3.3, ap_h / 2]];
cell_box = [lamp_x - lamp.x / 2 - fit - cell_wall, lamp_zs[len(lamps) - 1] - lamp.y / 2 - fit - cell_wall,
            lamp_x + lamp.x / 2 + fit + cell_wall, lamp_zs[0] + lamp.y / 2 + fit + cell_wall];

// Knobs, distances in front of the plate (s = -y)
k_back = face_t + knob_gap;
v_tip = vol_shaft[1] - plate_t;
v_bore = v_tip - k_back;
v_len = v_bore + v_front;
v_nut_recess = [corners(vol_nut[0]) + 0.9, face_t + vol_nut[1] + 0.5 - k_back];
v_bush_recess = [vol_bush[0] + 0.6, vol_bush[1] - plate_t + 0.5 - k_back];
m_tip = rot_shaft[1] - plate_t;
m_bore = m_tip - k_back;
m_len = m_bore + m_front;
m_nut_recess = [corners(rot_nut[0]) + 0.9, face_t + rot_nut[1] + 0.5 - k_back];
m_bush_recess = [rot_bush[0] + 0.6, rot_bush[1] - plate_t + 0.5 - k_back];

// Logic board in its rails, behind everything on the face
lg_y0 = max(board_y + board_t, plate_t + rot_body[1], plate_t + tg_body.z + tg_lugs, plate_t + vol_body[1]) + lg_gap;
lg_pitch = lg_board.x - 2 * drv_over + 2 * fit + rail.x;    // rail to rail
lg_x = lg_cx - lg_pitch / 2 - rail.x / 2;                  // left rail
lg_board_x0 = lg_x + rail.x + fit - drv_over;
lg_board_z = wall + rail.y - 1.6 - board_t;
unit_d = lg_y0 + lg_board.y + 4;

bed = [255, 255];

// Label positions, sizes and boxes [x0, z0, x1, z1]
function tw(s, size) = len(s) * size * 0.92;    // Liberation Sans Bold capitals, about
function box(p, s, size, h = "center") =
   let (w = tw(s, size), x0 = h == "left" ? p.x : h == "right" ? p.x - w : p.x - w / 2)
      [x0, p.y - size * 0.4, x0 + w, p.y + size * 0.4];
function apart(a, b) = a[2] + 0.5 <= b[0] || b[2] + 0.5 <= a[0] || a[3] + 0.5 <= b[1] || b[3] + 0.5 <= a[1];
// box a off the round thing [x, z, d]
function apart_c(a, c) = norm([max(a[0] - c[0], 0, c[0] - a[2]), max(a[1] - c[1], 0, c[1] - a[3])]) >= c[2] / 2 + 0.5;
function mic_a(i) = mic_a0 + i * rot_step;
function mic_pos(i) = [mic_x + mic_r * sin(mic_a(i)), mic_z + mic_r * cos(mic_a(i))];
function mic_h(i) = mic_a(i) < -20 ? "right" : mic_a(i) > 20 ? "left" : "center";
tg_lx = tg_x + corners(tg_nut[0]) / 2 + 1;     // toggle labels' left end
// [text, position, size, halign]
labels = concat(
   [["MKR", [lamp_x + lamp.x / 2 + 2.5, lamp_zs[0]], lbl_big, "left"],
    ["MKR", [mute_x, 7.6], lbl_small, "center"],
    ["MUTE", [mute_x, 4.6], lbl_small, "center"],
    ["INTERCOM", [vol_x, 28.4], 2.6, "center"],
    ["PUSH VOX", [vol_x, 25.6], lbl_small, "center"],
    ["VOL", [vol_x, 6.9], lbl_small, "center"],
    ["CREW", [vol_x - 2, 3.3], lbl_small, "right"],
    ["PASS", [vol_x + 2, 3.3], lbl_small, "left"],
    ["MIC", [mic_x - 13.5, 29.6], 2.6, "center"],
    ["PUSH SPKR", [mic_x, 3], lbl_small, "center"],
    ["KMA 26", [unit_w - flange_w - 1, 29.8], lbl_small, "right"]],
   [for (t = [0, 1], l = [0 : 2]) [tg_labels[t][l], [tg_lx, tg_zs[t] + (1 - l) * tg_line], lbl_small, "left"]],
   [for (i = [0 : len(mics) - 1]) [mics[i], mic_pos(i), label_size, mic_h(i)]]);
label_boxes = [for (l = labels) box(l[1], l[0], l[2], l[3])];

// Things on the face the labels must stay off: boxes [x0, z0, x1, z1] and
// round things [x, z, d]
face_boxes = concat(
   [for (z = lamp_zs) [lamp_x - lamp.x / 2, z - lamp.y / 2, lamp_x + lamp.x / 2, z + lamp.y / 2]],
   [for (b = buttons) [b[1] - btn.x / 2, b[2] - btn.y / 2, b[1] + btn.x / 2, b[2] + btn.y / 2]],
   [for (x = groove_xs) [x - groove.x / 2, 0, x + groove.x / 2, ap_h]]);
face_rounds = concat(
   [[mute_x, mute_z, mute_d], [cell_pos.x, cell_pos.y, cell_d], [hole_pos.x, hole_pos.y, hole_d],
    [vol_x, vol_z, v_back_part[0]], [mic_x, mic_z, m_back_part[0]],
    [tg_x, tg_zs[0], corners(tg_nut[0])], [tg_x, tg_zs[1], corners(tg_nut[0])]],
   [for (p = unit_holes(unit_w, ap_h)) [p.x, p.y, 5.6]]);

// --- Checks ---
assert(unit_w <= bed.x && unit_d <= bed.y, "Body does not fit the bed");
for (i = [0 : len(labels) - 1]) {
   assert(label_boxes[i][1] >= 1.5 && label_boxes[i][3] <= ap_h - 1.5, str(labels[i][0], " runs off the face"));
   for (t = face_boxes)
      assert(apart(label_boxes[i], t), str(labels[i][0], " runs into something on the face"));
   for (c = face_rounds)
      assert(apart_c(label_boxes[i], c), str(labels[i][0], " runs into a knob, nut, hole or screw"));
   for (j = [0 : len(labels) - 1])
      if (j > i)
         assert(apart(label_boxes[i], label_boxes[j]), str(labels[i][0], " and ", labels[j][0], " overlap"));
}
// Lamps
assert(lamp_pitch - lamp.y - 2 * fit >= 1.2, "Lamp cells' walls too thin");
assert(lamp.y + 2 * fit >= led[1] + 0.4 && lamp.x + 2 * fit >= led[1] + 0.4, "Lamp LED does not fit its cell");
assert(board_y - led[2] >= plate_t + 0.3, "Lamp LEDs touch the lenses");
assert(cell_box[0] >= x_in0 + 0.3 && cell_box[1] >= wall && cell_box[3] <= ap_h - wall, "Lamp cells do not fit");
assert(lamp_x - lamp.x / 2 - lamp_ear - fit >= mount_inset + 2.8 + 0.5, "Lamp lens pocket runs under the mount screw heads");
assert(lamp_ear_t < plate_t - 0.8, "Lamp lens pocket too deep for the plate");
// Marker board
assert(mute_x - tact.x / 2 >= cell_box[2] + 0.5, "MUTE switch hits the lamp cells");
assert(bosses[0][1] + boss_d / 2 + 0.5 <= mute_z - tact.x / 2, "Lower marker board screw hits the MUTE switch");
assert(bosses[1][1] - boss_d / 2 - 0.5 >= mute_z + tact.x / 2, "Upper marker board screw hits the MUTE switch");
for (b = [bosses[0], bosses[1]])
   assert(b[0] + pilot_d / 2 + 1.5 <= mk_board_x[1] && b[1] - pilot_d / 2 - 1.5 >= board_z[0] && b[1] + pilot_d / 2 + 1.5 <= board_z[1], "Marker board screw too close to its edge");
assert(mk_board_x[1] + 1 <= tg_x - tg_body.x / 2, "Marker board hits the toggles");
// Toggles
assert(tg_zs[0] - tg_body.y / 2 >= tg_zs[1] + tg_body.y / 2 + 0.5, "Toggle bodies touch");
assert(tg_zs[1] - tg_body.y / 2 >= wall + 0.3 && tg_zs[0] + tg_body.y / 2 <= ap_h - wall - 0.3, "Toggles hit the floor or the top");
assert(tg_bush[1] - plate_t - face_t >= tg_nut[1] + 1, "Toggle bushing too short for the face and its nut");
assert(tg_x + tg_body.x / 2 + 1 <= vol_x - vol_body[0] / 2, "Toggles hit the pot");
// Pot and its knob
assert(vol_z - vol_body[0] / 2 >= wall + 0.5 && vol_z + vol_body[0] / 2 <= ap_h - wall - 0.5, "Pot does not fit in the height");
assert(vol_x + vol_body[0] / 2 + 0.5 <= bt_board_x[0], "Pot hits the button board");
assert(vol_bush[1] - plate_t - face_t >= vol_nut[1] + 1, "Pot bushing too short for the face and its nut");
assert(v_back_part[0] / 2 - v_nut_recess[0] / 2 >= 0.8, "Volume knob too thin around the nut");
assert(v_bush_recess[1] <= v_back_part[1] || v_front_part[0] / 2 - v_bush_recess[0] / 2 >= 1, "Volume knob front too thin around the bushing");
assert(v_bore - v_bush_recess[1] >= 5, "Volume knob holds too little of its shaft");
assert(v_len - v_back_part[1] >= 4, "Volume knob front part too short");
// Buttons
assert(btn_pitch >= btn_flange.x + 0.8, "Button flanges touch");
assert(btn_zs[0] - btn_zs[1] >= btn_flange.y + 0.8, "Button rows' flanges touch");
assert(btn_zs[1] - btn_flange.y / 2 >= wall + 0.5 && btn_zs[0] + btn_flange.y / 2 <= ap_h - wall - 0.5, "Button flanges hit the floor or the top");
assert(btn_stem >= 0.5, "Front boards too close to the plate for the tactile switches");
assert(bar_dz + bar_led.y / 2 + 0.5 <= tact_dz - tact.x / 2, "Bar LED hits the tactile switch");
assert(bar_dz - chan.y / 2 >= -btn.y / 2 + 0.8, "Cap too thin under the LED channel");
assert(bar.y <= chan.y, "Bar slot higher than the LED channel");
assert(tact_dz + 1.75 <= btn.y / 2 - 0.8, "Switch post runs out of the cap");
assert(btn_text_dz - btn_text * 0.4 >= bar_dz + bar.y / 2 + 0.6, "Button label runs into the bar");
assert(bosses[2][0] + boss_d / 2 + 0.5 <= btn_xs[0] - btn_flange.x / 2 && bosses[3][0] - boss_d / 2 - 0.5 >= btn_xs[4] + btn_flange.x / 2, "Button board screws hit the caps");
assert(bosses[2][0] - pilot_d / 2 - 1.5 >= bt_board_x[0] && bosses[3][0] + pilot_d / 2 + 1.5 <= bt_board_x[1], "Button board screws too close to its edge");
// Mic selector
assert(bt_board_x[1] + 0.5 <= mic_x - rot_body[0] / 2, "Button board hits the rotary switch");
assert(mic_z - rot_body[0] / 2 >= wall + 0.3 && mic_z + rot_body[0] / 2 <= ap_h - wall - 0.3, "Rotary switch does not fit in the height");
assert(mic_x + rot_body[0] / 2 <= x_in1 - 0.3, "Rotary switch hits the right wall");
assert(mic_x + m_back_part[0] / 2 <= unit_w - flange_w, "Mic knob runs onto the flange");
assert(mic_r >= m_back_part[0] / 2 + 1.5, "Mic labels under the knob");
assert(m_back_part[0] / 2 - m_nut_recess[0] / 2 >= 1, "Mic knob too thin around the nut");
assert(m_bush_recess[1] <= m_back_part[1] || m_front_part[0] / 2 - m_bush_recess[0] / 2 >= 1.2, "Mic knob front too thin around the bushing");
assert(m_bore - m_bush_recess[1] >= 5, "Mic knob holds too little of its shaft");
assert(rot_bush[1] - plate_t - face_t >= rot_nut[1] + 1, "Rotary switch bushing too short for the face and its nut");
assert(len(mics) * rot_step <= 360 && len(mics) <= 12, "Too many mic positions for the rotary switch");
// Logic board
assert(lg_x >= x_in0 + 0.5 && lg_x + lg_pitch + rail.x <= x_in1 - 0.5, "Logic board does not fit");
assert(lg_board_z + board_t + max(lg_high, nano_high) <= ap_h - wall - 0.5, "Parts on the logic board hit the top");
assert(nano_board.x + mux_board.x + 6 <= lg_board.x && nano_board.y + 4 <= lg_board.y, "Nano and mux do not fit the logic board");
assert(tie_x + tie_block.x <= x_in1 - 0.5 && (tie_x >= lg_x + lg_pitch + rail.x + 1 || tie_x + tie_block.x <= lg_x - 1), "Tie block does not fit beside the rails");
// Inputs: 10 buttons, MUTE, 2 per toggle on the mux
assert(len(buttons) + 1 + 4 <= 16, "More inputs than the mux has");
assert(len(buttons) + len(lamps) <= 16, "More lamps than the two shift registers have");

// --- 2D shapes in x/z ---

module lamp_windows_2d(grow = 0) {
   for (z = lamp_zs)
      translate([lamp_x, z])
         square([lamp.x + 2 * grow, lamp.y + 2 * grow], center = true);
}

module button_slots_2d(grow) {
   for (b = buttons)
      translate([b[1], b[2]])
         offset(r = btn_r + grow) offset(delta = -btn_r)
            square([btn.x, btn.y], center = true);
   translate([mute_x, mute_z]) circle(d = mute_d + 2 * grow, $fn = 32);
}

// Holes for everything nutted onto the face
module bush_holes_2d() {
   for (z = tg_zs) translate([tg_x, z]) circle(d = tg_bush[0] + 0.4, $fn = 32);
   translate([vol_x, vol_z]) circle(d = vol_bush[0] + 0.4, $fn = 32);
   translate([mic_x, mic_z]) circle(d = rot_bush[0] + 0.4, $fn = 32);
}

module labels_2d() {
   for (l = labels)
      translate(l[1])
         text(l[0], size = l[2], font = font, halign = l[3], valign = "center");
   // CREW -o- PASS: the balance mark between the words
   translate([vol_x, 3.3]) {
      difference() {
         circle(d = 1.6, $fn = 24);
         circle(d = 0.7, $fn = 16);
      }
      translate([-1.8, -0.2]) square([1.05, 0.4]);
      translate([0.75, -0.2]) square([1.05, 0.4]);
   }
}

// --- Printed parts ---

module unit_body() {
   difference() {
      union() {
         ext_y(0, plate_t)
            unit_face_2d(unit_w, ap_h);
         // Walls
         ext_y(0, unit_d)
            difference() {
               translate([flange_w, 0]) square([unit_w - 2 * flange_w, ap_h]);
               translate([x_in0, wall]) square([x_in1 - x_in0, ap_h - 2 * wall]);
            }
         // Lamp cells
         ext_y(plate_t - 0.01, board_y - 0.3 - plate_t + 0.01)
            difference() {
               translate([cell_box[0], cell_box[1]]) square([cell_box[2] - cell_box[0], cell_box[3] - cell_box[1]]);
               lamp_windows_2d(fit);
            }
         // Front board bosses
         for (b = bosses)
            boss(b[0], b[1], board_y);
         // Logic board rails and their front stop
         for (i = [0, 1])
            translate([lg_x + i * lg_pitch, lg_y0 - 2, wall - 0.01])
               cube([rail.x, unit_d - lg_y0 + 2, rail.y + 0.01]);
         translate([lg_x, lg_y0 - 2, wall - 0.01])
            cube([lg_pitch + rail.x, 2, rail.y + 0.01]);
         // Cable tie block, at the back
         translate([tie_x, unit_d - tie_block.y, wall - 0.01])
            cube(tie_block + [0, 0, 0.01]);
      }
      // Lamp windows and the pockets for the lens ears
      ext_y(-1, plate_t + 2)
         lamp_windows_2d(fit);
      ext_y(-1, 1 + lamp_ear_t)
         for (z = lamp_zs)
            translate([lamp_x, z])
               square([lamp.x + 2 * (lamp_ear + fit), lamp.y + 2 * fit], center = true);
      ext_y(-1, plate_t + 2)
         union() {
            button_slots_2d(btn_play);
            bush_holes_2d();
            mount_holes_2d(unit_w, ap_h);
         }
      // Grooves in the rails for the logic board edges
      for (i = [0, 1])
         translate([lg_x + i * lg_pitch - drv_over - fit, lg_y0, wall + rail.y - 1.6 - board_t - fit])
            cube([rail.x + 2 * (drv_over + fit), unit_d, board_t + 2 * fit]);
      // Tunnel for the cable tie
      translate([tie_x - 1, unit_d - tie_block.y / 2 - 2, wall + 1.5])
         cube([tie_block.x + 2, 4, 2]);
      gitrev_cut(unit_w - flange_w / 2, ap_h / 2);
   }
}

// The front face with the lettering standing out of it
module face() {
   ext_y(-face_t - label_raise, label_raise + 0.01)
      labels_2d();
   difference() {
      ext_y(-face_t, face_t)
         difference() {
            unit_face_2d(unit_w, ap_h);
            lamp_windows_2d();
            button_slots_2d(btn_play);
            bush_holes_2d();
            mount_holes_2d(unit_w, ap_h);
            translate(cell_pos) circle(d = cell_d, $fn = 32);
            translate(hole_pos) circle(d = hole_d, $fn = 24);
         }
      // Divider lines
      ext_y(-face_t - 1, groove[1] + 1)
         for (x = groove_xs)
            translate([x - groove.x / 2, -1]) square([groove.x, ap_h + 2]);
   }
}

// Marker lamp lens, installed: centered on its lamp in x/z, front at y=0
module lens(letter) {
   difference() {
      union() {
         translate([-lamp.x / 2, 0, -lamp.y / 2]) cube([lamp.x, plate_t, lamp.y]);
         translate([-lamp.x / 2 - lamp_ear, 0, -lamp.y / 2]) cube([lamp.x + 2 * lamp_ear, lamp_ear_t, lamp.y]);
      }
      ext_y(-1, 1 + lamp_engrave)
         text(letter, size = lamp_text, font = font, halign = "center", valign = "center");
   }
}

// Button cap, flange back at z=0, front to +z, the label engraved into
// its front (fill it with white paint), the annunciator slot through it;
// the post behind the flange presses the switch, the LED reaches into the
// channel from the back
module button_cap(label) {
   difference() {
      union() {
         translate([0, tact_dz, -btn_stem])
            cylinder(d = 3.5, h = btn_stem + 0.01, $fn = 24);
         translate([-btn_flange.x / 2, -btn_flange.y / 2, 0])
            cube([btn_flange.x, btn_flange.y, btn_flange.z + 0.01]);
         linear_extrude(btn_flange.z + btn_len)
            offset(r = btn_r) offset(delta = -btn_r)
               square([btn.x, btn.y], center = true);
      }
      translate([0, btn_text_dz, btn_flange.z + btn_len - label_raise])
         linear_extrude(label_raise + 0.01)
            text(label, size = btn_text, font = font, halign = "center", valign = "center");
      translate([-bar.x / 2, bar_dz - bar.y / 2, -1])
         cube([bar.x, bar.y, btn_flange.z + btn_len + 2]);
      translate([-chan.x / 2, bar_dz - chan.y / 2, -1])
         cube([chan.x, chan.y, btn_flange.z + btn_len - 1 + 1]);
   }
}

// All 10 caps for one print, on their front
module button_caps() {
   for (i = [0 : len(buttons) - 1])
      translate([(i % 5) * (btn_flange.x + 3), floor(i / 5) * (btn_flange.y + 3), btn_flange.z + btn_len])
         rotate([180, 0, 0])
            button_cap(buttons[i][0]);
}

// MKR MUTE cap, like a button cap
module mute_cap() {
   translate([0, 0, -btn_stem]) cylinder(d = 3.5, h = btn_stem + 0.01, $fn = 24);
   cylinder(d = mute_flange[0], h = mute_flange[1] + 0.01, $fn = 32);
   cylinder(d = mute_d, h = mute_flange[1] + mute_len, $fn = 32);
}

// The three lenses for one print, front side down
module lenses() {
   for (i = [0 : len(lamps) - 1])
      translate([i * (lamp.x + 2 * lamp_ear + 3), 0, 0])
         rotate([90, 0, 0])
            lens(lamps[i][0]);
}

// Stepped knob, like a concentric pair: back part (d, len, ribs), front part (d, ribs), total length len
module knob_stepped(bp, fp, len) {
   knob_body(bp[0], bp[1], bp[2], ch = 0.8);
   translate([0, 0, bp[1] - 0.01])
      knob_body(fp[0], len - bp[1] + 0.01, fp[1]);
}

module knob_vol() {
   difference() {
      knob_stepped(v_back_part, v_front_part, v_len);
      recesses(v_nut_recess, v_bush_recess);
      crush_bore(vol_shaft[0], 0, v_bore);
   }
}

// Mic selector knob, a pointer line engraved into its front at +y
// (fill it with white paint)
module knob_mic() {
   difference() {
      knob_stepped(m_back_part, m_front_part, m_len);
      recesses(m_nut_recess, m_bush_recess);
      crush_bore(rot_shaft[0], 0, m_bore);
      translate([-0.6, m_front_part[0] / 2 - 1.2 - 4, m_len - label_raise])
         cube([1.2, 4, label_raise + 1]);
   }
}

// --- View-only parts ---

c_cap = "#55585e";

module caps_part(e = 0) {
   color(c_cap)
      for (b = buttons)
         translate([b[1], btn_y1 - 2 * e, b[2]])
            rotate([90, 0, 0])
               button_cap(b[0]);
   color(c_label)
      for (b = buttons)
         translate([b[1], -face_t - btn_out + label_raise / 2 - 2 * e, b[2] + btn_text_dz])
            rotate([90, 0, 0])
               linear_extrude(0.02)
                  text(b[0], size = btn_text, font = font, halign = "center", valign = "center");
   color("#efe6c8")
      translate([mute_x, btn_y1 - 2 * e, mute_z])
         rotate([90, 0, 0])
            mute_cap();
}

// Lit: the annunciator bars that are on, by label
module bars_part(lit, e = 0) {
   for (b = buttons)
      if (len([for (w = lit) if (w == b[0]) 1]) > 0)
         color("#fff6d8")
            translate([b[1] - bar.x / 2, -face_t - btn_out + 0.3 - 2 * e, b[2] + bar_dz - bar.y / 2])
               cube([bar.x, 0.2, bar.y]);
}

// Lenses in place; lit: the letters of the lamps that are on
module lenses_part(lit, e = 0) {
   for (i = [0 : len(lamps) - 1])
      let (on = len([for (w = lit) if (w == lamps[i][0]) 1]) > 0)
         translate([lamp_x, -e, lamp_zs[i]]) {
            color(lamps[i][1], on ? 1 : 0.55) lens(lamps[i][0]);
            color("#1a1a1a")
               ext_y(lamp_engrave - 0.05, 0.06)
                  text(lamps[i][0], size = lamp_text, font = font, halign = "center", valign = "center");
         }
}

module boards_part() {
   color(c_board) {
      translate([mk_board_x[0], board_y, board_z[0]])
         cube([mk_board_x[1] - mk_board_x[0], board_t, board_z[1] - board_z[0]]);
      translate([bt_board_x[0], board_y, board_z[0]])
         cube([bt_board_x[1] - bt_board_x[0], board_t, board_z[1] - board_z[0]]);
   }
   for (b = buttons) {
      translate([b[1], board_y - tact.y - tact.z, b[2] + tact_dz])
         tact_part();
      color("#f4f4f0", 0.9)
         translate([b[1] - bar_led.x / 2, board_y - bar_led.z, b[2] + bar_dz - bar_led.y / 2])
            cube([bar_led.x, bar_led.z, bar_led.y]);
   }
   translate([mute_x, board_y - tact.y - tact.z, mute_z])
      tact_part();
   for (i = [0 : len(lamps) - 1])
      translate([lamp_x, board_y, lamp_zs[i]])
         rotate([90, 0, 0])
            color(lamps[i][1], 0.8) {
               cylinder(d = led[1], h = 1, $fn = 24);
               cylinder(d = led[0], h = led[2] - led[0] / 2, $fn = 24);
               translate([0, 0, led[2] - led[0] / 2]) sphere(d = led[0], $fn = 24);
            }
}

// Logic board: Nano at the back right (USB jack at the back edge),
// mux at the front left, the two shift registers behind it
module logic_part() {
   translate([lg_board_x0, lg_y0, lg_board_z]) {
      color(c_board) cube([lg_board.x, lg_board.y, board_t]);
      translate([0, 0, board_t]) {
         translate([lg_board.x - 3 - nano_board.x, lg_board.y - nano_board.y, 0]) {
            color("#202020") for (dx = [0.5, nano_board.x - 3]) translate([dx, 1, 0]) cube([2.5, nano_board.y - 2, nano_high - 4.6]);
            color("#1d4fa0") translate([0, 0, nano_high - 4.6]) cube([nano_board.x, nano_board.y, 1.6]);
            color(c_steel) translate([nano_board.x / 2 - 4, nano_board.y - 5, nano_high - 3]) cube([8, 5.5, 3]);
         }
         translate([3, 3, 0]) {
            color("#202020") for (dy = [0.5, mux_board.y - 3]) translate([1, dy, 0]) cube([mux_board.x - 2, 2.5, 2.5]);
            color("#1d4fa0") translate([0, 0, 2.5]) cube([mux_board.x, mux_board.y, 1.6]);
         }
         color(c_part)
            for (dx = [3, 25])
               translate([dx, mux_board.y + 8, 0]) cube([20, 7.5, 7]);
      }
   }
}

module toggle_part(z, a) {
   translate([tg_x, 0, z]) {
      color(c_steel) {
         translate([-tg_body.x / 2, plate_t, -tg_body.y / 2]) cube([tg_body.x, tg_body.z, tg_body.y]);
         for (dz = [-4, 0, 4])
            translate([-1, plate_t + tg_body.z, dz - 0.3]) cube([2, tg_lugs, 0.6]);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = tg_bush[0], h = tg_bush[1], $fn = 32);
         translate([0, plate_t - tg_bush[1], 0])
            rotate([a + 90, 0, 0]) {
               cylinder(d = tg_bat[0], h = tg_bat[1], $fn = 16);
               translate([0, 0, tg_bat[1]]) sphere(d = tg_bat[0] + 0.6, $fn = 16);
            }
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(tg_nut[0]), h = tg_nut[1], $fn = 6);
   }
}

module pot_part() {
   translate([vol_x, 0, vol_z]) {
      color(c_steel) {
         rotate([-90, 0, 0]) translate([0, 0, plate_t]) cylinder(d = vol_body[0], h = vol_body[1], $fn = 48);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = vol_bush[0], h = vol_bush[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = vol_shaft[0], h = vol_shaft[1], $fn = 32);
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(vol_nut[0]), h = vol_nut[1], $fn = 6);
   }
}

module rotary_part() {
   translate([mic_x, 0, mic_z]) {
      color(c_steel) {
         rotate([-90, 0, 0]) translate([0, 0, plate_t]) cylinder(d = rot_body[0], h = rot_body[1], $fn = 48);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = rot_bush[0], h = rot_bush[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = rot_shaft[0], h = rot_shaft[1], $fn = 32);
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(rot_nut[0]), h = rot_nut[1], $fn = 6);
   }
}

// The knobs in place, the mic knob turned to position i
module knobs_part(i, e = 0) {
   color(c_knob) {
      translate([vol_x, -k_back - e, vol_z]) rotate([90, 0, 0]) knob_vol();
      translate([mic_x, -k_back - e, mic_z]) rotate([90, 0, 0]) rotate([0, 0, -mic_a(i)]) knob_mic();
   }
}

module face_part() {
   color(c_face) face();
   color(c_label)
      ext_y(-face_t - label_raise - 0.01, 0.02)
         labels_2d();
   for (p = unit_holes(unit_w, ap_h))
      translate([p.x, -face_t, p.y]) mount_screw(plate_t + face_t + 8);
}

module parts_inside() {
   boards_part();
   logic_part();
   toggle_part(tg_zs[0], tg_throw);
   toggle_part(tg_zs[1], 0);
   pot_part();
   rotary_part();
}

lit_bars = ["COM1", "NAV1", "MKR"];

module assembled_view() {
   color(c_plate) unit_body();
   face_part();
   caps_part();
   bars_part(lit_bars);
   lenses_part(["M"]);
   knobs_part(1);
   parts_inside();
}

module exploded_view(e = explode) {
   color(c_plate) unit_body();
   translate([0, -e, 0]) face_part();
   caps_part(e);
   lenses_part(["M"], e);
   knobs_part(1, 2 * e);
   parts_inside();
}

// Cut through the COM2 and DME buttons, seen from the left
module cut() {
   render()
      intersection() {
         children();
         translate([btn_xs[1], -60, -1]) cube([200, 200, ap_h + 2]);
      }
}

module section_view() {
   color(c_plate) cut() unit_body();
   color(c_face) cut() face();
   color(c_cap) cut() caps_part();
   color(c_board) cut() boards_part();
   color(c_board) cut() logic_part();
}

module parts_view() {
   color(c_cap)
      for (i = [0 : len(buttons) - 1])
         translate([(i % 5) * (btn_flange.x + 3), floor(i / 5) * (btn_flange.y + 3), btn_stem])
            button_cap(buttons[i][0]);
   color("#efe6c8") translate([-14, 0, btn_stem]) mute_cap();
   for (i = [0 : len(lamps) - 1])
      color(lamps[i][1]) translate([-14, 12 + i * 8, 0]) rotate([-90, 0, 0]) lens(lamps[i][0]);
   color(c_knob) {
      translate([-35, 5, 0]) knob_vol();
      translate([-35, 30, 0]) knob_mic();
   }
}

rotate([90, 0, 0]) unit_body(); // Make module body
rotate([-90, 0, 0]) face(); // Make module face
button_caps(); // Make module buttons
translate([0, 0, mute_flange[1] + mute_len]) rotate([180, 0, 0]) mute_cap(); // Make module mute
lenses(); // Make module lenses
translate([0, 0, v_len]) rotate([180, 0, 0]) knob_vol(); // Make module knob_vol
translate([0, 0, m_len]) rotate([180, 0, 0]) knob_mic(); // Make module knob_mic

//assembled_view(); // Ignore module

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-35
//assembled_view(); // Make view back 60,0,150
//section_view(); // Make view section 90,0,-90
//parts_view(); // Make view parts 40,0,20
