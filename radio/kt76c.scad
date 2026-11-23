// KT 76C transponder
//
// A home cockpit copy of the Bendix/King KT 76C transponder, the bottom
// unit of the radio stack (radio.inc.scad), under the two KX155s and as
// wide as them; its height is the real 1.65". The face copies the real
// one: the IDT button at the top left, the display window, the 0..7 code
// buttons, CLR and VFR along the bottom and the function selector knob
// (OFF, SBY, TST, ON, ALT) at the right.
//
// The display shows like the real one the flight level (pressure altitude
// in hundreds of feet, X-Plane's sim/flightmodel2/position/pressure_altitude)
// on the left, marked FL, the squawk code on the right and the annunciators
// R (reply), ALT, ON, GND and SBY between them. The digits are red 0.28"
// 7 segment LEDs like the KX155's: the flight level is one 3 digit module,
// the code two (the second one's last two digits are behind the face),
// all driven by one MAX7219. The annunciators are words cut through a
// printed black mask behind the red filter (stencil letters: thin bridges
// hold the islands of A, O, D, B, R), each in its own cell with a 3 mm red
// LED behind it on its own Nano pin.
//
// Inside: one front perfboard (cut L shaped, its lower strip runs under the
// selector switch) carries the digit modules, the annunciator LEDs and the
// 11 tactile switches under the button caps; it is screwed onto three
// bosses on the plate back and clamps the display mask against the filter.
// The selector is a 1 pole 12 way rotary switch with its stop washer set to
// 5 positions, nutted onto the face. The MAX7219 is the 8x8 matrix kit
// board without the matrix, in rails on the floor like the KX155's.
// Everything goes to an Arduino Nano of its own running MobiFlight, on a
// logic board in rails on the floor like the KMA 26's: 16 buttons and
// selector positions through a CD74HC4067 mux (more inputs than the Nano
// has pins), the MAX7219 and the 6 annunciator LEDs on pins of their own
// (nano_pins, mux_inputs; the README has the tables). Its USB cable to the
// powered USB hub runs out of the open back, tied onto tie_block.
//
// Coordinates: radio.inc.scad (installed: x right, y backwards, z up).
// Printed: the body front side down, the face front side up, the display
// mask front side down (black), the button caps (cream or white, their
// engraved labels filled with black paint) and the knob on their front.
//
// Parts to buy:
// - 1 rotary switch, 1 pole 12 way, 6 mm shaft, with stop washer (rot_*)
// - 11 tactile switches 6 x 6 mm, 5 mm high (tact)
// - 3 7 segment modules, 0.28", 3 digits, common cathode, red (dig_*)
// - 1 MAX7219 8x8 matrix kit board (drv_board), leave the matrix off
// - 1 Arduino Nano (ATmega328P, 5 V, nano_*) with female headers, a mini
//   USB cable, a cable tie; 1 CD74HC4067 mux breakout (mux_board);
//   perfboard for the logic board (lg_board)
// - 6 red LEDs, 3 mm, with a 1 kOhm resistor each
// - 1 red transparent acrylic piece, filter_t thick (filter_size)
// - perfboard, 10 x 22 cm (board_size)
// - M3: 4x M3x10 pan head + nuts (face onto the sheet), 3x M3x8 self
//   tapping (board onto the bosses)
//
// Assembly: filter into its frame on the plate back, button caps in from
// the back, display mask onto the filter. Solder the digit modules, LEDs
// and tactile switches onto the board (digit fronts and LED tips level
// with the mask's back, see the asserts), screw it onto the bosses (the
// digits go into the mask's openings and the LEDs into its cells). Face
// onto the plate, rotary switch through both from the back, nut on the
// front. Driver board and logic board into their rails, wiring, the USB
// cable plugged in and tied onto the tie block. Knob on last, pointing at OFF with the switch turned fully left.
// Into the sheet under the KX155s, the 4 screws through the end flanges.

$fn = 64;

include <radio.inc.scad>

explode = 30;

// --- Unit ---
xp_h = 41.9;                 // KT 76C face height, 1.65" (the KT 76A's, which it replaces)

// --- Function selector ---
modes = ["OFF", "SBY", "TST", "ON", "ALT"];
mode_a0 = -135;              // OFF, degrees clockwise from up
knob_x = 198;                // = the VFR button's x
knob_z = 25;
mode_r = 12.5;               // labels' inner end from the knob axis

// --- Buttons ---
btn = [15, 7];               // cap at the face: x, z
btn_out = 2.5;               // in front of the face
btn_flange = [18, 10, 1.2];  // behind the plate: x, z, thickness
btn_play = 0.2;
btn_r = 1.2;                 // cap corners
btn_text = 3.4;
btn_z = 8;                   // code button row
btn_x0 = 21;                 // button 0
btn_pitch = 19;              // 0..7, and CLR to VFR
btn_gap = 25;                // 7 to CLR, a board screw between them
idt_z = 25;                  // IDT, over button 0

// --- Display ---
win_x = [34, 168];           // window, left and right
dig_z = 26;                  // digit center height
win_h = 14;
win_margin = 1.5;            // window beyond the code's last digit
filter_over = 1.5;           // filter beyond the window
lip_w = 1;
code_shown = 4;              // code digits shown; the others are behind the face
ann_size = 2.6;              // annunciator lettering
ann_cell_h = 4.4;            // cell inside height (the width comes from the word)
ann_wall = 0.8;
mask_t = 0.8;                // the mask's front, the words cut through it
bridge_w = 0.5;              // stencil bridges
// Annunciator columns, [top, bottom] word; column 0 is left of the flight
// level, 1 and 2 between it and the code
ann_cols = [["R", "FL"], ["ALT", "GND"], ["ON", "SBY"]];

// --- Body ---
board_dz = 0.5;              // board edge beyond the tactile switches
board_gap = 0.5;             // board to the walls and the rotary switch
lg_board = [72, 50];         // logic board (perfboard) in its rails: x, y; the Nano at its back right, the mux at its front left
lg_high = 14;                // the parts on it, above the board
// --- Nano pins and mux inputs, in the order of the README's tables ---
nano_pins = [["D2", "mux S0"], ["D3", "mux S1"], ["D4", "mux S2"], ["D5", "mux S3"], ["D6", "mux SIG"],
             ["D7", "MAX7219 DIN"], ["D8", "MAX7219 CS"], ["D9", "MAX7219 CLK"],
             ["D10", "R"], ["D11", "FL"], ["D12", "ALT"], ["A0", "ON"], ["A1", "GND"], ["A2", "SBY"]];
mux_inputs = ["0", "1", "2", "3", "4", "5", "6", "7", "CLR", "VFR", "IDT", "OFF", "SBY", "TST", "ON", "ALT"];

// --- Calculated ---
x_in0 = flange_w + wall;
x_in1 = unit_w - flange_w - wall;
btn_xs = [for (i = [0 : 7]) btn_x0 + i * btn_pitch];
clr_x = btn_xs[7] + btn_gap;
vfr_x = clr_x + btn_pitch;
// Buttons: [label, x, z]
buttons = concat([for (i = [0 : 7]) [str(i), btn_xs[i], btn_z]],
                 [["CLR", clr_x, btn_z], ["VFR", vfr_x, btn_z], ["IDT", btn_x0, idt_z]]);

dig_y0 = plate_t + filter_t;                 // digit and mask fronts
board_y = dig_y0 + dig_mod.y;                // front board's front
btn_y1 = plate_t + btn_flange.z;             // flange back
btn_stem = board_y - tact.y - tact.z - btn_y1;   // post behind the flange onto the switch
btn_len = face_t + btn_out + plate_t;        // the part through the face

// Annunciator cells: column widths, the word box + 1.2
function word_w(s) = len(s) * ann_size;      // Liberation Sans Bold capitals, about
col_w = [for (c = ann_cols) max(word_w(c[0]), word_w(c[1])) + 1.2];
row_dz = (ann_cell_h + ann_wall) / 2;
// Layout along the window: col 0, flight level module, gap, col 1, col 2,
// gap, code; the gaps take what is left
code_x = win_x[1] - win_margin - code_shown * dig_pitch;   // code's first module
c0_x = win_x[0] + win_margin + col_w[0] / 2;
fl_x = c0_x + col_w[0] / 2 + 2;                            // flight level module
ann_w = col_w[1] + ann_wall + col_w[2];
gap_a = (code_x - (fl_x + dig_mod.x) - ann_w) / 2;
c1_x = fl_x + dig_mod.x + gap_a + col_w[1] / 2;
c2_x = c1_x + col_w[1] / 2 + ann_wall + col_w[2] / 2;
col_x = [c0_x, c1_x, c2_x];
code_mods = ceil(code_shown / dig_n);
mod_xs = concat([fl_x], [for (m = [0 : code_mods - 1]) code_x + m * dig_mod.x]);
code_end = code_x + code_mods * dig_mod.x;
filter_size = [win_x[1] - win_x[0] + 2 * filter_over, win_h + 2 * filter_over];
frame_x = [win_x[0] - filter_over - fit - lip_w, win_x[1] + filter_over + fit + lip_w];
frame_z = [dig_z - win_h / 2 - filter_over - fit - lip_w, dig_z + win_h / 2 + filter_over + fit + lip_w];
mask_x = [win_x[0] - filter_over, win_x[1] + filter_over];
mask_z = [dig_z - filter_size.y / 2, dig_z + filter_size.y / 2];

// Front board: upper part left of the rotary switch, lower strip under it
rot_x0 = knob_x - rot_body[0] / 2;
rot_z0 = knob_z - rot_body[0] / 2;
board_x = [x_in0 + board_gap, rot_x0 - board_gap, x_in1 - board_gap];
board_z = [wall + board_gap, btn_z + tact.x / 2 + board_dz, xp_h - wall - board_gap];
board_size = [board_x[2] - board_x[0], board_z[2] - board_z[0]];
// Board screws: left between IDT and 0, bottom between 7 and CLR, right
// over the hidden code digits
bosses = [[btn_x0, (btn_z + btn_flange.y / 2 + idt_z - btn_flange.y / 2) / 2],
          [(btn_xs[7] + clr_x) / 2, btn_z],
          [frame_x[1] + boss_d / 2 + 1, dig_z + dig_mod.z / 2 + boss_d / 2 + 0.5]];

// Knob, distances in front of the plate (s = -y)
m_d = 21;
m_ribs = 30;
m_front = 1.5;
m_back = face_t + 0.5;
m_tip = rot_shaft[1] - plate_t;
m_bore = m_tip - m_back;
m_len = m_bore + m_front;
m_nut_recess = [corners(rot_nut[0]) + 0.9, face_t + rot_nut[1] + 0.5 - m_back];
m_bush_recess = [rot_bush[0] + 0.6, rot_bush[1] - plate_t + 0.5 - m_back];

drv_y0 = max(board_y + board_t, plate_t + rot_body[1]) + 3;   // the driver and logic boards from here back
lg_pitch = lg_board.x - 2 * drv_over + 2 * fit + rail.x;    // logic board: rail to rail
lg_x = x_in0 + 1;                                          // its left rail, at the left wall
lg_board_x0 = lg_x + rail.x + fit - drv_over;
lg_board_z = wall + rail.y - 1.6 - board_t;
drv_pitch = drv_board.x - 2 * drv_over + 2 * fit + rail.x;
drv_x = lg_x + lg_pitch + rail.x + 2;                      // driver board's left rail, right of it
tie_x = drv_x + drv_pitch + rail.x + 3;
unit_d = drv_y0 + max(drv_board.y, lg_board.y) + 4;

bed = [255, 255];

// Label boxes on the face: [x0, z0, x1, z1]
function mode_pos(i) = [knob_x + mode_r * sin(mode_a0 + i * rot_step), knob_z + mode_r * cos(mode_a0 + i * rot_step)];
function mode_box(i) =
   let (p = mode_pos(i), w = word_w(modes[i]), h = label_size, a = mode_a0 + i * rot_step)
      a < -20 ? [p.x - w, p.y - h / 2, p.x, p.y + h / 2] : [p.x - w / 2, p.y - h / 2, p.x + w / 2, p.y + h / 2];
xpdr_pos = [knob_x - 22, mode_pos(4).y];
model_pos = [btn_x0, idt_z + btn.y / 2 + 4];

// --- Checks ---
assert(unit_w <= bed.x && unit_d <= bed.y, "Body does not fit the bed");
assert(btn_x0 - btn_flange.x / 2 >= x_in0 + 0.5, "Button 0 hits the left wall");
assert(vfr_x + btn_flange.x / 2 <= x_in1 - 0.5, "VFR button hits the right wall");
assert(btn_pitch >= btn_flange.x + 0.8, "Button flanges touch");
assert(btn_gap >= btn_flange.x + boss_d + 1, "No room for the board screw between 7 and CLR");
assert(abs(vfr_x - knob_x) < 0.01, "VFR is not under the knob");
assert(btn_z - btn_flange.y / 2 >= wall + 0.5, "Buttons hit the floor");
assert(bosses[0][1] - boss_d / 2 >= btn_z + btn_flange.y / 2 + 0.4 && bosses[0][1] + boss_d / 2 <= idt_z - btn_flange.y / 2 - 0.4, "Left board screw hits IDT or 0");
assert(idt_z + btn_flange.y / 2 <= xp_h - wall - 0.5, "IDT hits the top wall");
assert(btn_x0 + btn_flange.x / 2 + 0.5 <= frame_x[0], "IDT hits the filter frame");
assert(frame_z[0] >= btn_z + btn_flange.y / 2 + 0.5, "Filter frame hits the button flanges");
assert(frame_z[1] <= xp_h - wall, "Filter frame does not fit under the top wall");
assert(dig_char_h <= win_h - 4 && 2 * ann_cell_h + 3 * ann_wall <= win_h + 2 * filter_over, "Window too low");
assert(ann_cell_h >= led[1] + 0.4, "LED does not fit its cell");
assert(led[2] <= dig_mod.y - mask_t, "LED too high for its cell");
assert(gap_a >= 3, "Display too crowded, widen the window");
assert(c0_x - col_w[0] / 2 >= mask_x[0] + ann_wall, "Column 0 runs off the mask");
assert(code_end <= rot_x0 - board_gap, "Hidden code digits hit the rotary switch");
assert(bosses[2][0] - boss_d / 2 >= frame_x[1] + 0.5 && bosses[2][0] + boss_d / 2 <= board_x[1] - 1, "Right board screw does not fit");
assert(bosses[2][1] + pilot_d / 2 + 1.5 <= board_z[2] && bosses[2][1] + boss_d / 2 <= xp_h - wall, "Right board screw too high");
assert(bosses[1][0] + boss_d / 2 <= rot_x0 - 0.5 || bosses[1][1] + boss_d / 2 <= rot_z0 - 0.5, "Bottom board screw hits the rotary switch");
assert(board_z[1] <= rot_z0 - board_gap, "Board strip hits the rotary switch");
assert(knob_z + rot_body[0] / 2 <= xp_h - wall - 0.5, "Rotary switch hits the top wall");
assert(knob_x + rot_body[0] / 2 <= x_in1 - 0.5, "Rotary switch hits the right wall");
assert(knob_x + m_d / 2 <= unit_w - flange_w, "Knob runs onto the flange");
assert(knob_z - m_d / 2 >= btn_z + btn.y / 2 + 1.5, "Knob too close to VFR");
assert(m_bore - m_bush_recess[1] >= 5, "Knob holds too little of its shaft");
assert(m_d / 2 - m_nut_recess[0] / 2 >= 1, "Knob too thin around the nut");
assert(rot_bush[1] - plate_t - face_t >= rot_nut[1] + 1, "Rotary switch bushing too short for the face and its nut");
assert(mode_r >= m_d / 2 + 1.5, "Selector labels under the knob");
for (i = [0 : len(modes) - 1]) {
   assert(mode_box(i)[0] >= win_x[1] + 2, str(modes[i], " runs into the window"));
   assert(mode_box(i)[3] <= xp_h - 1.5, str(modes[i], " runs off the face"));
   assert(mode_box(i)[1] >= btn_z + btn.y / 2 + 1 || mode_box(i)[2] <= clr_x - btn.x / 2 - 1, str(modes[i], " runs into CLR"));
}
for (i = [0 : len(modes) - 2])
   assert(mode_box(i)[3] + 0.5 <= mode_box(i + 1)[1] || mode_box(i)[2] + 0.5 <= mode_box(i + 1)[0], str(modes[i], " and ", modes[i + 1], " overlap"));
assert(xpdr_pos.x + word_w("XPDR") / 2 + 1 <= mode_box(4)[0] && xpdr_pos.x - word_w("XPDR") / 2 >= win_x[1] + 1 || xpdr_pos.y - label_size / 2 >= dig_z + win_h / 2 + 1, "XPDR label does not fit");
assert(xpdr_pos.y - label_size / 2 >= mode_box(3)[3] + 0.5 || xpdr_pos.x + word_w("XPDR") / 2 <= mode_box(3)[0] - 0.5, "XPDR runs into ON");
assert(model_pos.y + label_size <= xp_h - 1.5, "Model label runs off the face");
assert(btn_stem >= 0.5, "Front board too close to the plate for the tactile switches");
assert(drv_x >= x_in0 + 0.5 && drv_x + 2 * rail.x + drv_board.x <= x_in1 - 0.5, "Driver board does not fit");
assert(board_size.x <= 220 && board_size.y <= 100, "Front board does not fit a 10 x 22 cm perfboard");
assert(len(mod_xs) * dig_n - (dig_n * code_mods - code_shown) <= 8, "More than 8 digits for one MAX7219");
assert(tie_x + tie_block.x <= x_in1 - 0.5, "Logic board, driver board and tie block do not fit side by side");
assert(lg_board_z + board_t + max(lg_high, nano_high) <= xp_h - wall - 0.5, "Parts on the logic board hit the top");
assert(nano_board.x + mux_board.x + 6 <= lg_board.x && nano_board.y + 4 <= lg_board.y, "Nano and mux do not fit the logic board");
assert(len(mux_inputs) == 16 && len(nano_pins) <= 18, "16 mux inputs, at most 18 Nano pins");

// --- 2D shapes in x/z ---

module window_2d(grow = 0) {
   translate([win_x[0] - grow, dig_z - win_h / 2 - grow])
      square([win_x[1] - win_x[0] + 2 * grow, win_h + 2 * grow]);
}

module button_slots_2d(grow) {
   for (b = buttons)
      translate([b[1], b[2]])
         offset(r = btn_r + grow) offset(delta = -btn_r)
            square([btn.x, btn.y], center = true);
}

module labels_2d() {
   for (i = [0 : len(modes) - 1])
      let (p = mode_pos(i), a = mode_a0 + i * rot_step)
         translate(p)
            text(modes[i], size = label_size, font = font, halign = a < -20 ? "right" : "center", valign = "center");
   translate(xpdr_pos)
      text("XPDR", size = label_size, font = font, halign = "center", valign = "center");
   translate(model_pos)
      text("KT 76C", size = label_size, font = font, halign = "center");
}

// A word as stencil letters, centered on the origin: each letter on its
// own, with a bridge through the middle of those with islands
module stencil_2d(s) {
   n = len(s);
   for (i = [0 : n - 1])
      translate([(i - (n - 1) / 2) * ann_size, 0])
         difference() {
            text(s[i], size = ann_size, font = font, halign = "center", valign = "center");
            if (search(s[i], "ABDOPQR") != [])
               square([bridge_w, 2 * ann_size], center = true);
         }
}

// Annunciator cells: [word, x, z, column width]
cells = [for (c = [0 : len(ann_cols) - 1], r = [0, 1])
            [ann_cols[c][r], col_x[c], dig_z + (r == 0 ? row_dz : -row_dz), col_w[c]]];

// --- Printed parts ---

module unit_body() {
   difference() {
      union() {
         ext_y(0, plate_t)
            unit_face_2d(unit_w, xp_h);
         // Walls
         ext_y(0, unit_d)
            difference() {
               translate([flange_w, 0]) square([unit_w - 2 * flange_w, xp_h]);
               translate([x_in0, wall]) square([x_in1 - x_in0, xp_h - 2 * wall]);
            }
         // Filter frame
         ext_y(plate_t - 0.01, filter_t + 0.01)
            difference() {
               translate([frame_x[0], frame_z[0]]) square([frame_x[1] - frame_x[0], frame_z[1] - frame_z[0]]);
               translate([frame_x[0] + lip_w, frame_z[0] + lip_w]) square([frame_x[1] - frame_x[0] - 2 * lip_w, frame_z[1] - frame_z[0] - 2 * lip_w]);
            }
         // Board bosses
         for (b = bosses)
            boss(b[0], b[1], board_y);
         // Driver and logic board rails and their front stops
         for (r = [[drv_x, drv_pitch], [lg_x, lg_pitch]]) {
            for (i = [0, 1])
               translate([r[0] + i * r[1], drv_y0 - 2, wall - 0.01])
                  cube([rail.x, unit_d - drv_y0 + 2, rail.y + 0.01]);
            translate([r[0], drv_y0 - 2, wall - 0.01])
               cube([r[1] + rail.x, 2, rail.y + 0.01]);
         }
         // Cable tie block, at the back
         translate([tie_x, unit_d - tie_block.y, wall - 0.01])
            cube(tie_block + [0, 0, 0.01]);
      }
      // Window, a bit bigger than the face's
      ext_y(-1, plate_t + 1.01)
         window_2d(0.5);
      ext_y(-1, plate_t + 2)
         union() {
            button_slots_2d(btn_play);
            translate([knob_x, knob_z]) circle(d = rot_bush[0] + 0.4);
            mount_holes_2d(unit_w, xp_h);
         }
      // Grooves in the rails for the board edges
      for (r = [[drv_x, drv_pitch], [lg_x, lg_pitch]], i = [0, 1])
         translate([r[0] + i * r[1] - drv_over - fit, drv_y0, wall + rail.y - 1.6 - board_t - fit])
            cube([rail.x + 2 * (drv_over + fit), unit_d, board_t + 2 * fit]);
      // Tunnel for the cable tie
      translate([tie_x - 1, unit_d - tie_block.y / 2 - 2, wall + 1.5])
         cube([tie_block.x + 2, 4, 2]);
      gitrev_cut(unit_w - flange_w / 2, xp_h / 2);
   }
}

// The front face with the lettering standing out of it
module face() {
   ext_y(-face_t - label_raise, label_raise + 0.01)
      labels_2d();
   ext_y(-face_t, face_t)
      difference() {
         unit_face_2d(unit_w, xp_h);
         window_2d();
         button_slots_2d(btn_play);
         translate([knob_x, knob_z]) circle(d = rot_bush[0] + 0.4);
         mount_holes_2d(unit_w, xp_h);
      }
}

// The display mask behind the filter, y from dig_y0 to board_y: openings
// for the digit modules, a cell for each annunciator LED, the words cut
// through its front
module display_mask() {
   difference() {
      translate([mask_x[0], dig_y0, mask_z[0]])
         cube([mask_x[1] - mask_x[0], dig_mod.y, mask_z[1] - mask_z[0]]);
      for (x = mod_xs)
         translate([x - fit, dig_y0 - 1, dig_z - dig_mod.z / 2 - fit])
            cube([dig_mod.x + 2 * fit, dig_mod.y + 2, dig_mod.z + 2 * fit]);
      for (c = cells) {
         translate([c[1] - c[3] / 2, dig_y0 + mask_t, c[2] - ann_cell_h / 2])
            cube([c[3], dig_mod.y, ann_cell_h]);
         ext_y(dig_y0 - 1, mask_t + 2)
            translate([c[1], c[2]])
               stencil_2d(c[0]);
      }
   }
}

// Button cap, flange back at z=0, front to +z, the label engraved into
// its front (fill it with black paint); the post behind the flange (to -z)
// presses the switch
module button_cap(label) {
   translate([0, 0, -btn_stem])
      cylinder(d = 3.5, h = btn_stem + 0.01, $fn = 24);
   translate([-btn_flange.x / 2, -btn_flange.y / 2, 0])
      cube([btn_flange.x, btn_flange.y, btn_flange.z + 0.01]);
   difference() {
      linear_extrude(btn_flange.z + btn_len)
         offset(r = btn_r) offset(delta = -btn_r)
            square([btn.x, btn.y], center = true);
      translate([0, 0, btn_flange.z + btn_len - label_raise])
         linear_extrude(label_raise + 0.01)
            text(label, size = btn_text, font = font, halign = "center", valign = "center");
   }
}

// All 11 caps for one print, on their front
module button_caps() {
   for (i = [0 : len(buttons) - 1])
      translate([(i % 4) * (btn_flange.x + 3), floor(i / 4) * (btn_flange.y + 3), btn_flange.z + btn_len])
         rotate([180, 0, 0])
            button_cap(buttons[i][0]);
}

// Function selector knob, a pointer line engraved into its front at +y
// (fill it with white paint)
module knob_mode() {
   difference() {
      knob_body(m_d, m_len, m_ribs);
      recesses(m_nut_recess, m_bush_recess);
      crush_bore(rot_shaft[0], 0, m_bore);
      translate([-0.6, m_d / 2 - 1.5 - 5, m_len - label_raise])
         cube([1.2, 5, label_raise + 1]);
   }
}

// --- View-only parts ---

module digits_part(fl, code) {
   for (x = mod_xs)
      translate([x, dig_y0, dig_z])
         digit_module_part();
   color(c_lit)
      ext_y(dig_y0 - 0.05, 0.06) {
         for (j = [0 : 2])
            translate([fl_x + (j + 0.5) * dig_pitch, dig_z]) digit_2d(fl[j]);
         for (j = [0 : code_shown - 1])
            translate([code_x + (j + 0.5) * dig_pitch, dig_z]) digit_2d(code[j]);
      }
}

// The annunciator words, as seen in the mask's front; lit: the words that are on
module annunciators_part(lit) {
   for (c = cells)
      color(len([for (w = lit) if (w == c[0]) 1]) > 0 ? c_lit : "#3a0a0a")
         ext_y(dig_y0 - 0.05, 0.06)
            translate([c[1], c[2]])
               stencil_2d(c[0]);
}

module filter_part() {
   color(c_filter, 0.45)
      translate([win_x[0] - filter_over, plate_t, dig_z - filter_size.y / 2])
         cube([filter_size.x, filter_t, filter_size.y]);
}

module board_part() {
   color(c_board)
      translate([0, board_y + board_t, 0])
         rotate([90, 0, 0])
            linear_extrude(board_t)
               difference() {
                  union() {
                     translate([board_x[0], board_z[0]]) square([board_x[1] - board_x[0], board_z[2] - board_z[0]]);
                     translate([board_x[0], board_z[0]]) square([board_x[2] - board_x[0], board_z[1] - board_z[0]]);
                  }
                  for (b = bosses) translate(b) circle(d = 3.3, $fn = 16);
               }
   for (b = buttons)
      translate([b[1], board_y - tact.y - tact.z, b[2]])
         tact_part();
   for (c = cells)
      translate([c[1], board_y, c[2]])
         rotate([90, 0, 0])
            color("#c01010", 0.8) {
               cylinder(d = led[1], h = 1, $fn = 24);
               cylinder(d = led[0], h = led[2] - led[0] / 2, $fn = 24);
               translate([0, 0, led[2] - led[0] / 2]) sphere(d = led[0], $fn = 24);
            }
}

module driver_part() {
   translate([drv_x + rail.x + fit - drv_over, drv_y0, wall + rail.y - 1.6 - board_t])
      driver_board_part();
}

// Logic board: the Nano at the back right (USB jack at the back edge), the
// mux at the front left (like the KMA 26's)
module logic_part() {
   translate([lg_board_x0, drv_y0, lg_board_z]) {
      color("#3a6b3a") cube([lg_board.x, lg_board.y, board_t]);
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
      }
   }
}

module rotary_part() {
   translate([knob_x, 0, knob_z]) {
      color(c_steel) {
         rotate([-90, 0, 0]) translate([0, 0, plate_t]) cylinder(d = rot_body[0], h = rot_body[1], $fn = 48);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = rot_bush[0], h = rot_bush[1], $fn = 32);
         rotate([90, 0, 0]) translate([0, 0, -plate_t]) cylinder(d = rot_shaft[0], h = rot_shaft[1], $fn = 32);
      }
      color("#d0d0d0") translate([0, -face_t, 0]) rotate([90, 0, 0]) cylinder(d = corners(rot_nut[0]), h = rot_nut[1], $fn = 6);
   }
}

// The knob in place, turned to mode i
module knob_part(i, e = 0) {
   color(c_knob)
      translate([knob_x, -m_back - e, knob_z])
         rotate([90, 0, 0])
            rotate([0, 0, -(mode_a0 + i * rot_step)])
               knob_mode();
}

module caps_part(e = 0) {
   color("#efe6c8")
      for (b = buttons)
         translate([b[1], btn_y1 - 2 * e, b[2]])
            rotate([90, 0, 0])
               button_cap(b[0]);
   color("#1a1a1a")
      for (b = buttons)
         translate([b[1], -face_t - btn_out + label_raise / 2 - 2 * e, b[2]])
            rotate([90, 0, 0])
               linear_extrude(0.02)
                  text(b[0], size = btn_text, font = font, halign = "center", valign = "center");
}

module face_part() {
   color(c_face) face();
   color(c_label)
      ext_y(-face_t - label_raise - 0.01, 0.02)
         labels_2d();
   for (p = unit_holes(unit_w, xp_h))
      translate([p.x, -face_t, p.y]) mount_screw(plate_t + face_t + 8);
}

module parts_inside() {
   digits_part("045", "7000");
   annunciators_part(["R", "FL", "ALT"]);
   color("#151515") display_mask();
   filter_part();
   board_part();
   driver_part();
   logic_part();
   rotary_part();
}

module assembled_view() {
   color(c_plate) unit_body();
   face_part();
   caps_part();
   knob_part(4);
   parts_inside();
}

module exploded_view(e = explode) {
   color(c_plate) unit_body();
   translate([0, -e, 0]) face_part();
   caps_part(e);
   knob_part(4, e);
   parts_inside();
}

// Cut through button 2 and the flight level digits, seen from the left
module cut() {
   render()
      intersection() {
         children();
         translate([btn_xs[2], -60, -1]) cube([200, 200, xp_h + 2]);
      }
}

module section_view() {
   color(c_plate) cut() unit_body();
   color(c_face) cut() face();
   color("#efe6c8") cut() caps_part();
   color("#151515") cut() display_mask();
   color(c_filter) cut() filter_part();
   color(c_board) cut() board_part();
   color(c_part) cut() digits_part("045", "7000");
}

module parts_view() {
   color("#efe6c8")
      for (i = [0 : len(buttons) - 1])
         translate([(i % 4) * (btn_flange.x + 3), floor(i / 4) * (btn_flange.y + 3), btn_stem])
            button_cap(buttons[i][0]);
   color(c_knob) translate([-30, 10, 0]) knob_mode();
   color("#151515") translate([0, 70, 0]) rotate([90, 0, 0]) translate([-mask_x[0], -dig_y0, -mask_z[0]]) display_mask();
}

rotate([90, 0, 0]) unit_body(); // Make module body
rotate([-90, 0, 0]) face(); // Make module face
rotate([90, 0, 0]) translate([0, -dig_y0, 0]) display_mask(); // Make module mask
button_caps(); // Make module buttons
translate([0, 0, m_len]) rotate([180, 0, 0]) knob_mode(); // Make module knob

//assembled_view(); // Ignore module

//assembled_view(); // Make view main 80,0,-25
//assembled_view(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 70,0,-35
//assembled_view(); // Make view back 60,0,150
//section_view(); // Make view section 90,0,-90
//parts_view(); // Make view parts 40,0,20
