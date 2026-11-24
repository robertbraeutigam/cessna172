// KX155 NAV/COM radio
//
// A home cockpit copy of the Bendix/King KX155 of the 172's radio stack,
// two of them (COM1/NAV1, COM2/NAV2), stacked in the cockpit sheet's radio
// cut-out with the transponder (radio.inc.scad). It shows the four
// frequencies like the real one, COM USE and STBY on the left, NAV USE
// and STBY on the right, on red 7 segment LED digits behind red filters,
// and has the real knobs:
// - COM and NAV frequency: a dual concentric knob each, the big outer
//   knob for the MHz, the small inner one for the kHz (push: free button)
// - COM and NAV volume: small knobs on pots with a switch (turned fully
//   left: OFF)
// - COM and NAV flip-flop buttons (USE <-> STBY)
// COM shows 6 digits with three decimals, so the European 8.33 kHz
// channels fit (118.005); NAV has 5 (108.00). The 0.28" digits are 7.5 mm
// apart (the real ones are smaller), so the unit is wider than the real
// 6.25": the height (2.00") and the layout are the real ones.
//
// Inside: each frequency is two 3 digit modules (NAV leaves the first
// digit off, behind the face) driven by its own MAX7219, 4 per unit, in a
// chain (one MobiFlight LED Module with 4 modules: DIN, CLK, CS). The
// digits are on two perfboards (COM, NAV) right behind the filters,
// screwed onto bosses on the plate; the MAX7219s are the cheap 8x8 matrix
// kit boards without the matrix, lying on the floor in rails, wired to the
// digit boards with jumpers. The encoders and the pots are nutted onto the
// face, the flip buttons press tactile switches on small perfboard pieces.
// Everything goes to an Arduino Nano of its own running MobiFlight, in
// rails on the floor right of the driver boards (under the NAV encoder),
// its USB jack at the open back; the USB cable to the powered USB hub is
// tied onto `tie_post` beside it. Each pin is a line of its own
// (nano_pins; the README has the table), so each unit is tested alone.
//
// Coordinates: radio.inc.scad (installed: x right, y backwards, z up).
// Printed: the body front side down, the face front side up, the knobs on
// their front, the flip caps on their flange.
//
// Parts to buy, per unit:
// - 2 dual concentric encoders with push switch (EC11EBB24C03 type, enc_*)
// - 2 pots with switch, 6 mm shaft (pot_*), 10 kOhm linear
// - 2 tactile switches 6 x 6 mm, 5 mm high (tact)
// - 8 7 segment modules, 0.28", 3 digits, common cathode, red (dig_*)
// - 4 MAX7219 8x8 matrix kit boards (drv_board), leave the matrix off
// - 1 Arduino Nano (ATmega328P, 5 V, nano_*), a mini USB cable, a cable tie
// - 4 red transparent acrylic pieces, filter_t thick (filter_size)
// - perfboard: 2 digit boards, 2 flip switch boards
// - M3: 4x M3x10 pan head + nuts (face onto the sheet), 8x M3x8 self
//   tapping (boards onto the bosses)
//
// Assembly: filters into their frames on the plate back, digit boards
// onto their bosses (digits against the filters), flip caps in from the
// back, their switch boards onto the bosses. Face onto the plate, then the
// encoders and pots through both from the back, nuts on the front (the
// face is clamped by them). Driver boards and the Nano into their rails
// from the back, wiring, the USB cable plugged in and tied onto the tie
// block. Knobs pressed on last. Into the
// sheet, the 4 screws through the end flanges.

$fn = 64;

include <radio.inc.scad>

explode = 30;

// --- Dual concentric encoder, MEASURE (EC11EBB24C03 type; the bushing is a guess) ---
enc_bush = [9, 7];           // threaded bushing: diameter, length from the mounting face
enc_nut = [12, 2];           // its nut: across flats, thickness
enc_body = [12, 9, 13];      // body behind the mounting face: x, depth (y), z
enc_pins = 4;                // pins behind the body
enc_outer = [6, 15];         // outer (hollow) shaft: diameter, length from the mounting face
enc_inner = [3.5, 3.0, 25];  // inner shaft: diameter, across the flat, length
enc_push = 0.5;              // inner shaft push travel

// --- Pot with switch, MEASURE ---
pot_bush = [7, 7];
pot_nut = [10, 2];
pot_body = [17, 16];         // diameter, depth behind the mounting face (with the switch)
pot_shaft = [6, 15];         // diameter, length from the mounting face

// --- MAX7219 kit boards (radio.inc.scad) ---
drv_n = 4;

// --- Display layout ---
// [label, digits shown]; each frequency is dig_mods modules, digits not
// shown are the first ones, behind the face
groups = [["USE", 6], ["STBY", 6], ["USE", 5], ["STBY", 5]];
dig_mods = 2;
gap_use = 5;                 // between USE and STBY
gap_half = 8;                // between COM and NAV
dsp_margin = 2;              // first and last module to the inner wall
dig_z = 39;                  // digit center height
win_h = 12;
win_margin = 1.5;            // window beyond the shown digits
filter_over = 1.5;           // filter beyond the window
lip_w = 1;                   // frame around the filters

// --- Bottom row ---
row_z = 15.5;                // knobs
flip_z = 19.5;               // flip buttons

// --- Knobs ---
knob_gap = 0.5;              // knob back to the face
knob_gap_in = 1;             // inner knob back to the outer knob's front, more than enc_push
nut_clear = 0.5;
o_d = 22;                    // outer frequency knob
o_skirt = [25, 1.5];         // smooth flange at its back: diameter, height
o_front = 1.5;               // in front of the outer shaft's tip
o_ribs = 40;
i_d = 13;                    // inner frequency knob
i_front = 2.5;
i_ribs = 24;
v_d = 12.5;                  // volume knob
v_skirt = [14.5, 1.5];
v_front = 1.5;
v_ribs = 20;

// --- Flip buttons ---
flip_btn = [8, 4.5];         // x, z, at the face
flip_out = 2.5;              // in front of the face
flip_flange = [11, 7.5, 1.2];
flip_play = 0.2;
flip_board = [24, 10];       // switch perfboard: x, z
flip_boss_dx = 9;

// --- Body ---
drv_y0 = 22;                 // driver boards from here back
// --- Nano pins, in the order of the README's table ---
nano_pins = [["D2", "MAX7219 DIN"], ["D3", "MAX7219 CS"], ["D4", "MAX7219 CLK"],
             ["D5", "COM outer A"], ["D6", "COM outer B"], ["D7", "COM inner A"], ["D8", "COM inner B"],
             ["D9", "NAV outer A"], ["D10", "NAV outer B"], ["D11", "NAV inner A"], ["D12", "NAV inner B"],
             ["A0", "COM push"], ["A1", "NAV push"], ["A2", "COM flip"], ["A3", "NAV flip"],
             ["A4", "COM on/off"], ["A5", "NAV on/off"], ["A6", "COM volume"], ["A7", "NAV volume"]];

// --- Calculated ---
gw = dig_mods * dig_mod.x;
x_in0 = flange_w + wall;
gx0 = x_in0 + dsp_margin;
gx = [gx0, gx0 + gw + gap_use, gx0 + 2 * gw + gap_use + gap_half, gx0 + 3 * gw + 2 * gap_use + gap_half];
x_in1 = gx[3] + gw + dsp_margin;
function hidden(i) = dig_mods * dig_n - groups[i][1];
function vx(i) = gx[i] + hidden(i) * dig_pitch;
function vw(i) = groups[i][1] * dig_pitch;
function win(i) = [vx(i) - win_margin, dig_z - win_h / 2, vw(i) + 2 * win_margin, win_h];
function filter_size(i) = [vw(i) + 2 * (win_margin + filter_over), win_h + 2 * filter_over];

dig_y0 = plate_t + filter_t;                 // digit fronts
board_y = dig_y0 + dig_mod.y;                // digit boards' front
board_z0 = 25;
board_z1 = unit_h - wall - 0.5;
board_x = [for (h = [0, 1]) [gx[2 * h] - 1.5, gx[2 * h + 1] + gw + 1.5]];
board_boss_z = board_z0 + 3;
board_boss_x = [for (i = [0 : 3]) gx[i] + gw / 2];

// Bottom row: [kind, x, half]
k_vol = 0; k_flip = 1; k_freq = 2;
row = [[k_vol, gx[0] + 9, 0],
       [k_flip, (gx[0] + gw + gx[1]) / 2, 0],
       [k_freq, gx[1] + gw - 14, 0],
       [k_vol, gx[2] + 12, 1],
       [k_flip, (gx[2] + gw + gx[3]) / 2, 1],
       [k_freq, gx[3] + gw - 14, 1]];
function row_x(k, h) = [for (r = row) if (r[0] == k && r[2] == h) r[1]][0];

// Knob positions, as distances in front of the plate (s = -y)
s_face = face_t;
o_tip = enc_outer[1] - plate_t;
o_back = s_face + knob_gap;
o_bore = o_tip - o_back;
o_len = o_bore + o_front;
i_tip = enc_inner[2] - plate_t;
i_back = o_back + o_len + knob_gap_in;
i_bore = i_tip - i_back;
i_len = i_bore + i_front;
v_tip = pot_shaft[1] - plate_t;
v_back = s_face + knob_gap;
v_bore = v_tip - v_back;
v_len = v_bore + v_front;
o_nut_recess = [corners(enc_nut[0]) + 1, s_face + enc_nut[1] + nut_clear - o_back];
o_bush_recess = [enc_bush[0] + 0.6, enc_bush[1] - plate_t + nut_clear - o_back];
v_nut_recess = [corners(pot_nut[0]) + 0.9, s_face + pot_nut[1] + nut_clear - v_back];
v_bush_recess = [pot_bush[0] + 0.6, pot_bush[1] - plate_t + nut_clear - v_back];

flip_y1 = plate_t + flip_flange.z;           // flange back = switch button top
flip_board_y = flip_y1 + tact.z + tact.y;    // switch board front
flip_cap_len = face_t + flip_out + plate_t;  // the part through the face

drv_pitch = drv_board.x - 2 * drv_over + 2 * fit + rail.x;
drv_span = drv_n * drv_pitch + rail.x;
drv_x0 = x_in0 + 1;                          // driver boards at the left wall
unit_d = drv_y0 + drv_board.y + 4;
nano_x = drv_x0 + drv_span + 1 + nano_rail_hw;   // right of them
nano_y1 = unit_d - 0.3;                      // its USB jack at the open back
tie_x = nano_x + nano_rail_hw + 3;

bed = [255, 255];

// --- Checks ---
assert(abs(x_in1 + wall + flange_w - unit_w) < 0.01, "The KX155's layout is not unit_w wide, change unit_w in radio.inc.scad");
assert(unit_w <= bed.x && unit_d <= bed.y, "Body does not fit the bed");
assert(row_z + o_skirt[0] / 2 + 1 <= dig_z - win_h / 2, "Frequency knobs run into the windows");
assert(row_z - o_skirt[0] / 2 >= 1.5, "Frequency knobs run off the face's bottom");
assert(row_z + enc_body.z / 2 <= board_z0 - 0.5, "Encoders hit the digit boards");
assert(row_z + pot_body[0] / 2 <= board_z0 - 0.5, "Pots hit the digit boards");
assert(flip_z + flip_board.y / 2 <= board_z0 - 0.5, "Flip switch boards hit the digit boards");
assert(row_z - pot_body[0] / 2 >= wall + 0.5, "Pots hit the floor");
assert(row_x(k_vol, 0) - pot_body[0] / 2 >= x_in0 + 0.5, "COM volume pot hits the left wall");
assert(row_x(k_freq, 1) + enc_body.x / 2 <= x_in1 - 0.5, "NAV encoder hits the right wall");
assert(row_x(k_freq, 1) + o_skirt[0] / 2 <= unit_w - flange_w, "NAV knob runs onto the flange");
for (h = [0, 1]) {
   assert(row_x(k_vol, h) + v_skirt[0] / 2 + 1 <= row_x(k_flip, h) - flip_flange.x / 2, "Volume knob too close to the flip button");
   assert(row_x(k_vol, h) + pot_body[0] / 2 + 0.5 <= row_x(k_flip, h) - flip_board.x / 2, "Pot hits the flip switch board");
   assert(row_x(k_flip, h) + flip_board.x / 2 + 0.5 <= row_x(k_freq, h) - enc_body.x / 2, "Flip switch board hits the encoder");
   assert(row_x(k_flip, h) + flip_btn.x / 2 + 1 <= row_x(k_freq, h) - o_skirt[0] / 2, "Flip button too close to the frequency knob");
}
assert(row_x(k_freq, 0) + o_skirt[0] / 2 + 1 <= row_x(k_vol, 1) - v_skirt[0] / 2, "COM frequency knob too close to the NAV volume knob");
assert(row_x(k_freq, 0) + enc_body.x / 2 + 0.5 <= row_x(k_vol, 1) - pot_body[0] / 2, "COM encoder hits the NAV pot");
assert(board_boss_z + boss_d / 2 <= dig_z - win_h / 2 - filter_over - fit, "Digit board bosses hit the filters");
assert(board_boss_z - pilot_d / 2 - 1.5 >= board_z0, "Digit board screws too close to its edge");
assert(dig_z + dig_mod.z / 2 <= board_z1 && dig_z + win_h / 2 + filter_over + fit + lip_w <= unit_h - wall, "Digits do not fit under the top wall");
assert(dig_char_h <= win_h - 2, "Window lower than the digits");
assert(enc_bush[1] - plate_t - face_t >= enc_nut[1] + 1, "Encoder bushing too short for the face and its nut");
assert(pot_bush[1] - plate_t - face_t >= pot_nut[1] + 1, "Pot bushing too short for the face and its nut");
assert(o_bore - o_bush_recess[1] >= 5, "Outer knob holds too little of its shaft");
assert(i_bore >= 5, "Inner knob holds too little of its shaft");
assert(v_bore - v_bush_recess[1] >= 5, "Volume knob holds too little of its shaft");
assert(knob_gap_in >= enc_push + 0.3, "Inner knob touches the outer one when pushed");
assert(o_skirt[0] / 2 - o_nut_recess[0] / 2 >= 1, "Outer knob skirt too thin around the nut");
assert(v_skirt[0] / 2 - v_nut_recess[0] / 2 >= 0.8, "Volume knob skirt too thin around the nut");
assert(i_d / 2 + 1 <= o_d / 2 - 2, "Inner knob not smaller than the outer one");
assert(flip_boss_dx - boss_d / 2 >= flip_flange.x / 2 + 0.5, "Flip bosses hit the cap flange");
assert(flip_boss_dx + pilot_d / 2 + 1.5 <= flip_board.x / 2, "Flip board screws too close to its edge");
assert(drv_span <= x_in1 - x_in0 - 1, "Driver boards do not fit side by side");
assert(drv_y0 >= plate_t + max(pot_body[1], enc_body.y + enc_pins, flip_board_y + board_t) + 3, "Driver boards too close to the parts on the face");
assert(wall + rail.y + drv_high <= board_z0 || drv_y0 >= board_y + board_t + 3, "Driver boards hit the digit boards");
assert(dig_mods * dig_n >= groups[0][1] && dig_mods * dig_n >= groups[2][1], "Not enough digits for a frequency");
assert(tie_x + tie_post.x <= x_in1 - 0.5, "Nano and tie post do not fit right of the driver boards");
assert(nano_y1 - nano_board.y / 2 - nano_rail_end >= flip_board_y + board_t + 0.5, "Nano runs into the NAV flip switch board");
assert(wall + nano_under + nano_t + 1.5 <= row_z - enc_body.z / 2 - 0.5
       || nano_y1 - nano_board.y / 2 - nano_rail_end >= plate_t + enc_body.y + enc_pins + 0.5, "Nano runs into the NAV encoder");
assert(nano_x - nano_rail_hw >= row_x(k_vol, 1) + pot_body[0] / 2 + 0.5
       || nano_y1 - nano_board.y / 2 - nano_rail_end >= plate_t + pot_body[1] + 0.5, "Nano runs into the NAV pot");
assert(len(nano_pins) == 19, "A pin per line: 17 digital, 2 analog");

// --- 2D shapes in x/z ---

module windows_2d(grow = 0) {
   for (i = [0 : 3])
      translate([win(i)[0] - grow, win(i)[1] - grow])
         square([win(i)[2] + 2 * grow, win(i)[3] + 2 * grow]);
}

module flip_slots_2d(grow) {
   for (h = [0, 1])
      translate([row_x(k_flip, h), flip_z])
         square([flip_btn.x + 2 * grow, flip_btn.y + 2 * grow], center = true);
}

// Bushing holes, d grown by grow
module bush_holes_2d(grow) {
   for (r = row)
      if (r[0] != k_flip)
         translate([r[1], row_z])
            circle(d = (r[0] == k_freq ? enc_bush[0] : pot_bush[0]) + grow);
}

module labels_2d() {
   for (i = [0 : 3])
      translate([vx(i) + vw(i) / 2, dig_z + win_h / 2 + 1.3])
         text(groups[i][0], size = label_size, font = font, halign = "center");
   for (h = [0, 1])
      translate([row_x(k_vol, h), 3])
         text(h == 0 ? "COMM" : "NAV", size = label_size, font = font, halign = "center");
   translate([(row_x(k_freq, 0) + row_x(k_vol, 1)) / 2, 3])
      text("KX 155", size = label_size, font = font, halign = "center");
}

// --- Printed parts ---

// The body: face plate, walls, filter frames, bosses, driver rails, tie post
module unit_body() {
   difference() {
      union() {
         ext_y(0, plate_t)
            unit_face_2d(unit_w);
         // Walls
         ext_y(0, unit_d)
            difference() {
               translate([flange_w, 0]) square([unit_w - 2 * flange_w, unit_h]);
               translate([x_in0, wall]) square([x_in1 - x_in0, unit_h - 2 * wall]);
            }
         // Filter frames
         ext_y(plate_t - 0.01, filter_t + 0.01)
            for (i = [0 : 3])
               let (f = filter_size(i), c = [vx(i) + vw(i) / 2, dig_z])
                  difference() {
                     translate(c) square([f.x + 2 * (fit + lip_w), f.y + 2 * (fit + lip_w)], center = true);
                     translate(c) square([f.x + 2 * fit, f.y + 2 * fit], center = true);
                  }
         // Digit board bosses
         for (x = board_boss_x)
            boss(x, board_boss_z, board_y);
         // Flip switch board bosses
         for (h = [0, 1], dx = [-flip_boss_dx, flip_boss_dx])
            boss(row_x(k_flip, h) + dx, flip_z, flip_board_y);
         // Driver board rails and their front stop
         for (i = [0 : drv_n])
            translate([drv_x0 + i * drv_pitch, drv_y0 - 2, wall - 0.01])
               cube([rail.x, unit_d - drv_y0 + 2, rail.y + 0.01]);
         translate([drv_x0, drv_y0 - 2, wall - 0.01])
            cube([drv_span, 2, rail.y + 0.01]);
         // The Nano's rails
         unit_nano_rails(nano_x, nano_y1);
         // Cable tie post, at the back right of the Nano
         translate([tie_x + tie_post.x / 2, unit_d - tie_post.y / 2, wall])
            tie_post();
      }
      // Windows, a bit bigger than the face's
      ext_y(-1, plate_t + 1.01)
         windows_2d(0.5);
      ext_y(-1, plate_t + 2)
         union() {
            bush_holes_2d(0.4);
            flip_slots_2d(flip_play);
            mount_holes_2d(unit_w);
         }
      // Grooves in the rails for the driver board edges
      for (i = [0 : drv_n])
         translate([drv_x0 + i * drv_pitch - drv_over - fit, drv_y0, wall + rail.y - 1.6 - board_t - fit])
            cube([rail.x + 2 * (drv_over + fit), unit_d, board_t + 2 * fit]);
      // Version on the back of the right flange
      gitrev_cut(unit_w - flange_w / 2, unit_h / 2);
   }
}

// The front face with the lettering standing out of it
module face() {
   ext_y(-face_t - label_raise, label_raise + 0.01)
      labels_2d();
   ext_y(-face_t, face_t)
      difference() {
         unit_face_2d(unit_w);
         windows_2d();
         bush_holes_2d(0.4);
         flip_slots_2d(flip_play);
         mount_holes_2d(unit_w);
      }
}

module knob_outer() {
   difference() {
      knob_body(o_d, o_len, o_ribs, o_skirt);
      recesses(o_nut_recess, o_bush_recess);
      crush_bore(enc_outer[0], 0, o_bore);
      // Inner shaft through the front
      translate([0, 0, -1]) cylinder(d = enc_inner[0] + 1.2, h = o_len + 2, $fn = 32);
   }
}

module knob_inner() {
   difference() {
      knob_body(i_d, i_len, i_ribs);
      translate([0, 0, -1])
         intersection() {
            cylinder(d = enc_inner[0] + 2 * bore_play, h = i_bore + 1, $fn = 32);
            translate([-enc_inner[0], -enc_inner[0] + enc_inner[1] - enc_inner[0] / 2 + bore_play, 0])
               cube([2 * enc_inner[0], enc_inner[0], i_bore + 1]);
         }
   }
}

module knob_vol() {
   difference() {
      knob_body(v_d, v_len, v_ribs, v_skirt);
      recesses(v_nut_recess, v_bush_recess);
      crush_bore(pot_shaft[0], 0, v_bore);
   }
}

// Flip-flop button, flange back at z=0, front to +z, the arrows on it
module flip_cap() {
   translate([-flip_flange.x / 2, -flip_flange.y / 2, 0])
      cube([flip_flange.x, flip_flange.y, flip_flange.z + 0.01]);
   translate([-flip_btn.x / 2, -flip_btn.y / 2, 0])
      cube([flip_btn.x, flip_btn.y, flip_flange.z + flip_cap_len]);
   translate([0, 0, flip_flange.z + flip_cap_len - 0.01])
      linear_extrude(label_raise)
         arrows_2d();
}

// Two arrows, the upper to the right, the lower to the left
module arrows_2d() {
   for (s = [1, -1])
      translate([0, s * 0.9])
         scale([s, 1]) {
            translate([-2.6, -0.3]) square([4, 0.6]);
            polygon([[1.2, -0.9], [2.8, 0], [1.2, 0.9]]);
         }
}

// --- View-only parts ---

// A frequency's digits, s without the point, the point after digit p
module frequency_2d(i, s, p) {
   n = groups[i][1];
   for (j = [0 : n - 1])
      translate([vx(i) + (j + 0.5) * dig_pitch, dig_z])
         digit_2d(s[j], j == p);
}

module digits_part(freqs) {
   for (i = [0 : 3], m = [0 : dig_mods - 1])
      translate([gx[i] + m * dig_mod.x, dig_y0, dig_z])
         digit_module_part();
   color(c_lit)
      ext_y(dig_y0 - 0.05, 0.06)
         for (i = [0 : 3])
            frequency_2d(i, freqs[i], 2);
}

module filters_part() {
   color(c_filter, 0.45)
      for (i = [0 : 3])
         let (f = filter_size(i))
            translate([vx(i) + vw(i) / 2 - f.x / 2, plate_t, dig_z - f.y / 2])
               cube([f.x, filter_t, f.y]);
}

module boards_part() {
   color(c_board) {
      for (b = board_x)
         translate([b[0], board_y, board_z0])
            cube([b[1] - b[0], board_t, board_z1 - board_z0]);
      for (h = [0, 1])
         translate([row_x(k_flip, h) - flip_board.x / 2, flip_board_y, flip_z - flip_board.y / 2])
            cube([flip_board.x, board_t, flip_board.y]);
   }
   for (h = [0, 1])
      translate([row_x(k_flip, h), flip_y1, flip_z])
         tact_part();
}

module drivers_part() {
   for (i = [0 : drv_n - 1])
      translate([drv_x0 + rail.x + fit + i * drv_pitch - drv_over, drv_y0, wall + rail.y - 1.6 - board_t])
         driver_board_part();
}

// Encoder and its nut, mounting face at y=plate_t
module encoder_part(x) {
   translate([x, 0, row_z]) {
      color(c_steel) {
         translate([-enc_body.x / 2, plate_t, -enc_body.z / 2]) cube(enc_body);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = enc_bush[0], h = enc_bush[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = enc_outer[0], h = enc_outer[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = enc_inner[0], h = enc_inner[1], $fn = 24);
         for (dx = [-2.5, 0, 2.5])
            translate([dx - 0.4, plate_t + enc_body.y, -enc_body.z / 2 + 1]) cube([0.8, enc_pins, 0.8]);
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(enc_nut[0]), h = enc_nut[1], $fn = 6);
   }
}

module pot_part(x) {
   translate([x, 0, row_z]) {
      color(c_steel) {
         rotate([-90, 0, 0]) translate([0, 0, plate_t]) cylinder(d = pot_body[0], h = pot_body[1], $fn = 48);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = pot_bush[0], h = pot_bush[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = pot_shaft[0], h = pot_shaft[1], $fn = 32);
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(pot_nut[0]), h = pot_nut[1], $fn = 6);
   }
}

// A knob in place: along -y, its back s in front of the plate
module place_knob(x, s) {
   translate([x, -s, row_z]) rotate([90, 0, 0]) children();
}

module knobs_part(e = 0) {
   color(c_knob)
      for (h = [0, 1]) {
         place_knob(row_x(k_freq, h), o_back + e) knob_outer();
         place_knob(row_x(k_freq, h), i_back + 2 * e) knob_inner();
         place_knob(row_x(k_vol, h), v_back + e) knob_vol();
         translate([row_x(k_flip, h), flip_y1 - 2 * e, flip_z]) rotate([90, 0, 0]) flip_cap();
      }
}

module face_part() {
   color(c_face) face();
   color(c_label)
      ext_y(-face_t - label_raise - 0.01, 0.02)
         labels_2d();
   for (p = unit_holes(unit_w))
      translate([p.x, -face_t, p.y]) mount_screw(plate_t + face_t + 8);
}

// Frequencies on the four windows: COM USE, COM STBY, NAV USE, NAV STBY
freqs1 = ["118005", "132855", "10850", "11330"];
freqs2 = ["121500", "119180", "11010", "10990"];

module parts_inside(freqs) {
   digits_part(freqs);
   filters_part();
   boards_part();
   drivers_part();
   unit_nano_part(nano_x, nano_y1);
   for (h = [0, 1]) {
      encoder_part(row_x(k_freq, h));
      pot_part(row_x(k_vol, h));
   }
}

module assembled_view(freqs = freqs1) {
   color(c_plate) unit_body();
   face_part();
   knobs_part();
   parts_inside(freqs);
}

module exploded_view(e = explode) {
   color(c_plate) unit_body();
   translate([0, -e, 0]) face_part();
   translate([0, -e, 0]) knobs_part(e);
   parts_inside(freqs1);
}

// Cut through the COM frequency knob's axis, seen from the left
module cut() {
   render()
      intersection() {
         children();
         translate([row_x(k_freq, 0), -60, -1]) cube([200, 200, unit_h + 2]);
      }
}

module section_view() {
   color(c_plate) cut() unit_body();
   color(c_face) cut() face();
   color(c_knob) cut() knobs_part();
   color(c_steel) cut() encoder_part(row_x(k_freq, 0));
   color(c_board) cut() boards_part();
   color(c_filter) cut() filters_part();
   color(c_part) cut() digits_part(freqs1);
}

// Two units as stacked in the sheet, COM1/NAV1 on top
module stack_view() {
   translate([0, 0, unit_h]) assembled_view(freqs1);
   assembled_view(freqs2);
}

module knobs_view() {
   color(c_knob) {
      knob_outer();
      translate([0, 0, o_len + knob_gap_in]) knob_inner();
      translate([30, 0, 0]) knob_vol();
      translate([50, 0, 0]) flip_cap();
   }
}

rotate([90, 0, 0]) unit_body(); // Make module body
rotate([-90, 0, 0]) face(); // Make module face
translate([0, 0, o_len]) rotate([180, 0, 0]) knob_outer(); // Make module knob_outer
translate([0, 0, i_len]) rotate([180, 0, 0]) knob_inner(); // Make module knob_inner
translate([0, 0, v_len]) rotate([180, 0, 0]) knob_vol(); // Make module knob_vol
flip_cap(); // Make module flip_cap

//assembled_view(); // Ignore module

//stack_view(); // Make view main 80,0,-25
//stack_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-35
//assembled_view(); // Make view back 60,0,150
//section_view(); // Make view section 90,0,-90
//knobs_view(); // Make view knobs 55,0,25
