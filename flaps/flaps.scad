// Flaps panel: wing flap lever and flap position indicator
//
// Right of the mixture, like in the 172N: WING FLAPS read down the left
// side, the scale 0, 10, 20, 30, 40 degrees (0 to 10 twice as long as
// the others, like the real placard), the indicator's pointer in a narrow
// slot beside it showing where the flaps are, and the white lever in a
// stepped slot right of it. The lever has no detents: it moves
// continuously and stays where it is left (the flaps follow it, like the
// 172N's preselect lever). The slot stops it: going down from 0 it rests
// on a step at 10, moved to the right it goes on down to a step at 20,
// moved to the right again it goes down to 40 (FULL). A spring holds it
// to the left, against the steps; going up it springs back left past
// them. Mounted in the cockpit frame (frame/) like the pedestal, with no
// housing: it is behind the sheet. Its front plate has a flange on the
// left, the right and the bottom (none at the top: the waist bars are
// behind the sheet there), screwed onto the sheet (M3, nuts behind it),
// the separate face in front of it; everything else hangs on the plate's
// back and goes through the cut-out in the lower right sheet. A foot along
// the plate's bottom stands on the frame's throttle bar, two M5 bolts
// through it into T-nuts in the bar's top slot.
//
// - Lever: the printed handle (a flat white paddle leaning down, the
//   172's) has a square stem through the lever slot into a slider. The
//   slider moves sideways in a pocket of a carriage, a spring in the
//   carriage's right wall pushes it to the left; the carriage slides up and
//   down in a channel on the plate's back. The stem rests against the
//   slot's edges, so the slot's steps are the stops, and the spring pressing
//   it on the edge gives the lever its friction.
// - A slide pot (60 mm, 45 mm travel) stands right of the channel, its ear
//   pointing at the plate through a slot in a tab on the carriage's right
//   side; its wiper (A0) gives MobiFlight the lever's position, which it
//   turns into the flap handle's ratio through a table (lever_table, echoed).
// - Indicator: the pointer is on a carrier sliding in a channel of its own
//   beside the lever's; a strip screwed over both channels' backs keeps the
//   carriage and the carrier in. A fin on the carrier's back (through a
//   slot in the strip) has a slot along y; a pin (an M3 screw) on the arm of
//   an SG90 servo runs in it (a scotch yoke): the pointer moves
//   r sin(angle) up and down, no gears. The servo is behind the strip, on a
//   rib standing on the foot. MobiFlight drives it (D9) from the flaps'
//   actual position through an interpolation table (indicator_table, echoed).
// - An Arduino Nano of its own (MobiFlight) in rails on the foot behind
//   the strip, at the left, its USB jack back, the cable tied onto a block
//   behind the plug (README.md, Connections).
//
// Coordinates, installed: x to the right (seen from the pilot), y
// backwards, z up; y = 0 is the face's front, z = 0 the foot's underside
// (the throttle bar's top, the cut-out's bottom), x = 0 the middle.
//
// Prints: the body on its face (front plate down), the face front side
// up (lettering for a paint pen), the handle on its paddle's end, the
// carriage on its front, the carrier on its left side, the slider on its back, the
// arm and the strip flat.

$fn = 48;

include <nano.inc.scad>
include <usb.inc.scad>

// Preview
view_deg = 25;               // flaps 0 .. 40: lever and indicator
explode = 30;

bed = [255, 255];

// --- Body, the frame's flaps_body, flaps_plate (frame/frame.inc.scad) ---
body = [60, 112, 78];        // what goes through the cut-out and behind the sheet: width, depth from the face's front, height
face_t = 2;                  // the separate face
plate_t = 3;                 // the front plate with the flange
flange_w = 9;                // left, right and bottom
face_r = 3;
mount_d = 3.3;
mount_inset = 4.5;
mount_nut_r = 3.2;
sheet_t = 3;
sheet_cut_clear = 0.5;       // the frame's flaps_play
bar_slot = 30;               // the throttle bar's top slot behind the sheet
m5_d = 5.3;
m5_head_d = 9.5;
foot_t = 3;
foot_bolt_xs = [10, 23];      // the foot's bolts (the frame's flaps_bolt_xs)
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;

// --- Scale ---
travel = 42;                 // 0 to 40 degrees, lever and pointer
degs = [0, 10, 20, 30, 40];
z_mid = 39;                  // the travel's middle (and the servo's shaft)
// the part of the travel from 0 to d degrees: 0 to 10 is 0.4 of it, each
// 10 after it 0.2 (the 172N placard)
function scale_at(d) = d <= 10 ? 0.04 * d : 0.2 + 0.02 * d;
function lever_z(d) = z_mid + travel / 2 - scale_at(d) * travel;

// --- Lever ---
stem = 6;                    // the handle's square stem
stem_clear = 0.3;            // to the slot's edges
jog = [5, 3.5];              // the slot's steps to the right at 10 and 20
handle_gap = 3;              // the paddle in front of the face
paddle = [8, 24, 6];         // the paddle: width at the stem, at its end, thick
paddle_out = 30;             // its end from the face's front
paddle_tilt = 25;            // leaning down
paddle_r = 1.5;              // its edges
play = 0.3;
sl = [stem + 3.2, 6, stem + 3.2];   // the slider: across, deep, high
sl_sock = 4;                 // the stem's socket in the slider
sl_gap = 1;                  // the slider at its right stop to the pocket's end
blk_wall = 2;                // the carriage's walls round the pocket (left, top, bottom)
blk_back = 3;                // its back wall (the slider screw's head in a slot in it)
screw_head = [5.6, 2];       // the M3 pan head screw through the slider into the stem
lev_spring = [4, 16, 4];     // the slider's spring: outer diameter, free length, solid length, MEASURE
spring_bore = 4;             // its bore in the carriage's right wall
lever_wall = 1.7;            // the channel's left wall
right_wall = 2.5;            // the channel's right wall (the pot's inner wall)
fork_t = 5;                  // the tab on the carriage's right side, over the pot's ear
fork_wall = 1.5;             // round the ear in the tab
strip_t = 3.5;               // the strip over the channels
end_h = 6;                   // the channels' end blocks (the strip's screws)

// --- Slide pot, MEASURE (a 60 mm one, 45 mm travel, 10k linear) ---
pot_l = 60;                  // long, without its solder tabs
pot_w = 9;                   // wide
pot_h = 7;                   // thick, its back to its top (the ear's face)
pot_travel = 45;
pot_ear = [1.2, 4, 15];      // the slider's ear: thick, long (along the pot), high over the pot's top
pot_cap = 6;                 // its end caps (no ear over them)
pot_tabs = 5;                // the solder tabs out of its bottom end
pot_lip = 0.6;               // the snap lips over its back's edges

// --- SG90 servo, MEASURE (the NAV indicator's, instruments/cdi.scad) ---
sv_body = [22.8, 12.2, 22.7];   // length, width, height (its top to its bottom)
sv_shaft_dx = 5.9;           // the shaft from the body's near end
sv_boss = [11.8, 4];         // the round boss on its top round the shaft: diameter, height
sv_spline = [4.8, 3];        // the output spline: diameter, length
sv_spline_fit = 4.6;         // the arm's hole, pressed on (and its screw)
sv_tab = [32.3, 2.5, 4.5];   // the mounting tabs: length over both, thickness, the body's top to their top
sv_tab_hole = 27.8;          // their holes apart
sv_pilot = 1.8;              // the servo's own 2 mm screws
sv_screw = [2.2, 4.5, 1.6];  // its horn screw: clearance, head diameter, head height

// --- Indicator ---
car = [6, 12];               // the carrier: across, high (as deep as the carriage)
car_wall = 1.5;
tab = [3, 3];                // the pointer: across, high
ind_slot_w = 4;
arm_r = 23;                  // shaft to pin
arm_t = 3;                   // = the spline's length
arm_w = 6;
pin_d = 3;                   // M3 screw
pin_head = [5.5, 2];
fin_t = 3;
rib_t = 3;                   // the servo's rib
gusset = [3, 6, 20];         // the rib's gussets: thick, out, high

// --- Lettering ---
label_raise = 0.8;
font = "Liberation Sans:style=Bold";
label_size = 3.2;

// --- Calculated ---
y_pl = face_t;
y_in = face_t + plate_t;
side = body.x / 2 - 0.5;             // everything behind the sheet within the cut-out, |x|
face_w = body.x + 2 * flange_w;
face_z = [-flange_w, body.z + sheet_cut_clear];
bolt_y = y_in + sheet_t + bar_slot;
J = jog[0] + jog[1];
blk_h = sl.z + 2 * play + 2 * blk_wall;
// x, from the right: the pot, the channel's right wall, the carriage, its left wall
px = [side - fork_wall - 0.3 - pot_w, side - fork_wall - 0.3];     // the pot (its outer wall is fork_wall thick)
pot_x = (px[0] + px[1]) / 2;                                      // and its ear
ow = [px[1] + 0.3, side];                                         // its outer wall
lw_r = [px[0] - 0.3 - right_wall, px[0] - 0.3];
bx = [lw_r[0] - play - (blk_wall + 0.5 + sl.x + J + sl_gap + spring_bore + 1.6), lw_r[0] - play];   // the carriage
pocket_x = [bx[0] + blk_wall, bx[1] - spring_bore - 1.6];
lever_xs = [pocket_x[0] + 0.5 + sl.x / 2, pocket_x[0] + 0.5 + sl.x / 2 + jog[0], pocket_x[0] + 0.5 + sl.x / 2 + J];   // the stem at 0..10, 10..20, 20..40
function lever_x(d) = d < 10 ? lever_xs[0] : d < 20 ? lever_xs[1] : lever_xs[2];
lw_l = [bx[0] - play - lever_wall, bx[0] - play];
// y
by = [y_in + play, y_in + play + sl.y + play + blk_back];
strip_y = [by[1] + play, by[1] + play + strip_t];
pot_y = [by[0] + 1 + pot_ear.z, by[0] + 1 + pot_ear.z + pot_h];  // its top (the ear's face), its back
pot_z = [z_mid - pot_l / 2, z_mid + pot_l / 2];                   // the ear in the pot's middle at the travel's middle
fork_x = [bx[1] - 0.01, pot_x + pot_ear.x / 2 + 0.3 + fork_wall];
fork_h = pot_ear.y + 0.3 + 2 * fork_wall;
wall_gap = [lever_z(40) - fork_h / 2 - 0.5, lever_z(0) + fork_h / 2 + 0.5];   // the right wall open in front of the tab, z
notch = [z_mid - fork_h / 2 - 0.5, z_mid + fork_h / 2 + 0.5];  // and all through at the middle, to put the carriage in
wall_back = pot_y[1] + 2.5;                           // the pot's walls, over its back for the lips
chan_z = [lever_z(40) - blk_h / 2 - 1, lever_z(0) + blk_h / 2 + 1];
end_z = [[foot_t, chan_z[0]], [chan_z[1], chan_z[1] + end_h]];
// indicator, left of the lever
cw_r = [lw_l[0] - car_wall, lw_l[0]];
cx = [cw_r[0] - play - car.x, cw_r[0] - play];
ind_x = (cx[0] + cx[1]) / 2;
cw_l = [cx[0] - play - car_wall, cx[0] - play];
cy = by;
fin_x = [cx[1] - 0.6 - fin_t, cx[1] - 0.6];
// servo behind the strip: shaft along -x, its body to the right, long side along y, the arm pointing forward
arm_x = [fin_x[1] + 0.5 + sv_screw[2] + 0.5, fin_x[1] + 0.5 + sv_screw[2] + 0.5 + arm_t];
sv_top = arm_x[1] + sv_boss[1];                       // the servo's top (x)
a_max = asin(travel / 2 / arm_r);
sv_ys = strip_y[1] + 0.5 + arm_w / 2 + arm_r;         // the shaft's y: the arm's end stays behind the strip
sv_y = [sv_ys - sv_shaft_dx, sv_ys - sv_shaft_dx + sv_body[0]];   // its body
sv_bc = (sv_y[0] + sv_y[1]) / 2;
sv_holes = [for (s = [-1, 1]) sv_bc + s * sv_tab_hole / 2];      // y, at z_mid
rib_x = [sv_top + sv_tab[2] - rib_t, sv_top + sv_tab[2] - 0.01];
rib_y = [sv_bc - sv_tab[0] / 2 - gusset.x, sv_bc + sv_tab[0] / 2 + gusset.x];
rib_z = [foot_t - 0.01, z_mid + sv_body[1] / 2 + 5];
fin_slot = [sv_ys - arm_r - pin_d / 2 - 0.5, sv_ys - arm_r * cos(a_max) + pin_d / 2 + 0.5];
fin_y = [cy[1] - 0.01, fin_slot[1] + 2];
fin_h = pin_d + 0.3 + 5;
function arm_a(d) = asin((lever_z(d) - z_mid) / arm_r);  // the arm's angle for the pointer at d, from -y, up positive
// Nano on the foot behind the strip at the left, the jack back
nano_c = [-side + nano_rail_hw + 0.5, strip_y[1] + 1 + nano_rail_end];
usb_z = foot_t + nano_top_h + nano_usb.y / 2;
nano_jack_y = nano_c.y + nano_board.y / 2 + nano_usb_out;
tie_y = nano_jack_y + usb_plug.z + tie_gap + tie_block.x / 2;

mount_holes = [for (s = [-1, 1], z = [-flange_w / 2, body.z - 5]) [s * (face_w / 2 - mount_inset), z]];

// the servo's angle (MobiFlight, 90 = arm straight forward) for the flaps'
// ratio (0 .. 1 = 0 .. 40 degrees), the table for its interpolation
indicator_table = [for (r = [0 : 0.125 : 1]) [r, round(10 * (90 + arm_a(40 * r))) / 10]];
// the pot's reading (0 .. 1023, 0 at its bottom end) at each mark, to the flap handle's ratio
function pot_raw(d) = round(1023 * (0.5 + (lever_z(d) - z_mid) / pot_travel));
lever_table = [for (d = degs) [pot_raw(d), d / 40]];
echo(indicator_table = indicator_table, lever_table = lever_table, marks_z = [for (d = degs) lever_z(d)],
     lever_xs = lever_xs, ind_x = ind_x);

// --- Checks ---
assert(face_w <= bed.x && face_z[1] - face_z[0] <= bed.y, "Face does not fit the printer bed");
assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear, "Mount nuts do not sit on the sheet, make flange_w wider");
assert(chan_z[0] >= foot_t + 3 && end_z[1][1] <= body.z - 0.5, "The channels off the body's height");
assert(travel <= pot_travel - 2, "The lever's travel longer than the pot's");
assert(pot_z[0] - pot_tabs >= foot_t + 0.5 && pot_z[1] + 2.5 <= body.z - 0.5, "The pot off the body's height");
assert(wall_gap[0] >= pot_z[0] + pot_cap / 2 + 1 && wall_gap[1] <= pot_z[1] - pot_cap / 2 - 1, "The carriage's tab runs into the pot's ledges");
assert(z_mid - travel / 2 - pot_ear.y / 2 >= pot_z[0] + pot_cap && z_mid + travel / 2 + pot_ear.y / 2 <= pot_z[1] - pot_cap, "The pot's ear over its end caps");
assert(pot_y[0] - pot_ear.z >= y_in + 0.5 && pot_y[0] - pot_ear.z <= by[0] + fork_t - 2.5, "The pot's ear not in the carriage's tab");
assert(wall_back >= strip_y[1], "The channel's right wall shorter than the strip");
assert(lev_spring[1] - 1 >= spring_bore + sl_gap + J, "The slider's spring too short (no preload at the left)");
assert(spring_bore + sl_gap >= lev_spring[2] + 0.5, "The slider's spring solid before the slider's right stop");
assert(lev_spring[0] + 0.4 <= sl.z, "The slider's spring wider than the slider");
assert(blk_back >= screw_head[1] + play, "The slider screw's head deeper than the carriage's back");
assert(cw_l[0] >= -side, "The carrier's channel out of the cut-out");
assert(ind_x - ind_slot_w / 2 - 12 >= -face_w / 2 + 6, "No room for the scale left of the indicator");
assert(sv_y[0] >= strip_y[1] + 0.5, "The servo runs into the strip");
assert(sv_top + sv_body[2] <= ow[1] && (sv_top + sv_body[2] <= lw_r[0] - 0.5 || sv_y[0] >= wall_back + 0.5), "The servo runs into the pot's walls");
assert(travel / 2 < arm_r * 0.97, "The arm too short for the travel");
assert(arm_x[1] + pin_head[1] <= sv_top, "The pin's head runs into the servo");
assert(arm_r * cos(a_max) - pin_head[0] / 2 >= sv_shaft_dx + 0.5, "The pin's head runs into the servo's body");
assert(z_mid - arm_r * sin(a_max) - arm_w / 2 - 1 >= foot_t + nano_top_h + nano_usb.y + 0.5, "The arm runs into the Nano");
assert(lever_z(40) - fin_h / 2 >= foot_t + nano_top_h + nano_usb.y + 0.5, "The fin runs into the Nano");
assert(nano_c.x + nano_rail_hw <= rib_x[0] - 0.5, "The Nano runs into the servo's rib");
assert(nano_c.y - nano_rail_end >= strip_y[1] + 0.5, "The Nano runs into the strip");
assert(tie_y + tie_block.x / 2 <= body.y, "The USB tie block off the foot");
for (b = foot_bolt_xs) {
   assert(b - m5_head_d / 2 >= rib_x[1] + gusset.y + 0.5 && b + m5_head_d / 2 <= side, "A foot bolt's head runs into the rib or out of the foot");
}
assert(bolt_y - m5_head_d / 2 >= wall_back + 0.5, "The foot bolts run into the pot's walls");
assert(sv_ys - arm_r - max(arm_w, pin_head[0]) / 2 >= strip_y[1] + 0.5, "The arm or the pin runs into the strip");

// --- Helpers ---
module along_y(y0, y1) {
   translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}
module stadium(c, w, hl) {
   hull() for (s = [-1, 1]) translate([c.x, c.y + s * (hl - w / 2)]) circle(d = w);
}
module box(x, y, z) {
   translate([x[0], y[0], z[0]]) cube([x[1] - x[0], y[1] - y[0], z[1] - z[0]]);
}

// --- Front: outline, holes, slots ---
module front_outline() {
   hull() {
      translate([-face_w / 2, face_z[0]]) square([face_w, 1]);
      for (s = [-1, 1]) translate([s * (face_w / 2 - face_r), face_z[0] + face_r]) circle(r = face_r);
      translate([-face_w / 2, face_z[1] - 1]) square([face_w, 1]);
   }
}
// the lever's slot: wide from 0 to 10, a step at 10, narrower to 20, a step at 20, the stem's width to 40
sw = stem + 2 * stem_clear;
function slot_bottom(d) = lever_z(d) - stem / 2 - stem_clear;
module lever_slot() {
   top = lever_z(0) + stem / 2 + stem_clear;
   translate([lever_xs[0] - sw / 2, slot_bottom(10)]) square([lever_xs[2] - lever_xs[0] + sw, top - slot_bottom(10)]);
   translate([lever_xs[1] - sw / 2, slot_bottom(20)]) square([lever_xs[2] - lever_xs[1] + sw, top - slot_bottom(20)]);
   translate([lever_xs[2] - sw / 2, slot_bottom(40)]) square([sw, top - slot_bottom(40)]);
}
ind_hl = travel / 2 + tab[1] / 2 + 1;
module front_holes() {
   for (h = mount_holes) translate(h) circle(d = mount_d);
   lever_slot();
   stadium([ind_x, z_mid], ind_slot_w, ind_hl);
}

// --- Body: front plate, foot, the channels, the pot's pocket, the servo's rib, the Nano's rails ---
module body() {
   pz = [pot_z[0] - 0.5, pot_z[1] + 2.5];
   difference() {
      union() {
         along_y(y_pl, y_in) front_outline();
         translate([-body.x / 2, y_pl, 0]) cube([body.x, body.y - y_pl, foot_t]);
         // the lever's channel: left wall, end blocks (the strip's screws)
         box(lw_l, [y_in - 0.01, strip_y[0]], chan_z);
         for (e = end_z) box([cw_l[0], lw_r[0] + 0.01], [y_in - 0.01, strip_y[0]], e);
         // the carrier's channel
         for (w = [cw_l, cw_r]) box(w, [y_in - 0.01, strip_y[0]], chan_z);
         // the channel's right wall and the pot's outer wall, the pot's top end wall
         box(lw_r, [y_in - 0.01, wall_back], [min(chan_z[0], pz[0]), max(chan_z[1], pz[1])]);
         box(ow, [y_in - 0.01, wall_back], pz);
         box([lw_r[0], ow[1]], [y_in - 0.01, pot_y[1]], [pot_z[1] + 0.3, pz[1]]);
         // the pot's bottom stop (its solder tabs behind it) and the ledges under its end caps
         box([lw_r[1] - 0.01, ow[0] + 0.01], [y_in - 0.01, pot_y[0] + 1.5], [pot_z[0] - 2.3, pot_z[0] - 0.3]);
         for (z = [[pot_z[0] - 0.01, pot_z[0] + pot_cap / 2], [pot_z[1] - pot_cap / 2, pot_z[1] + 0.31]])
            box([lw_r[1] - 0.01, ow[0] + 0.01], [y_in - 0.01, pot_y[0]], z);
         // the snap lips over the pot's back at its end caps
         for (z = [pot_z[0], pot_z[1] - pot_cap], s = [0, 1]) {
            xs = s == 0 ? [lw_r[1] - 0.01, lw_r[1] + pot_lip + 0.3] : [ow[0] - pot_lip - 0.3, ow[0] + 0.01];
            translate([0, 0, z]) hull() {
               box(xs, [pot_y[1] + 0.2, pot_y[1] + 0.8], [0, pot_cap]);
               box(s == 0 ? [xs[0], xs[0] + 0.01] : [xs[1] - 0.01, xs[1]], [pot_y[1] + 0.2, wall_back], [0, pot_cap]);
            }
         }
         // the servo's rib on the foot, a window for its body, gussets at its ends
         difference() {
            box(rib_x, rib_y, rib_z);
            box([rib_x[0] - 1, rib_x[1] + 1], [sv_y[0] - play, sv_y[1] + play], [z_mid - sv_body[1] / 2 - play, z_mid + sv_body[1] / 2 + play]);
         }
         for (y = [rib_y[0], rib_y[1] - gusset.x]) translate([rib_x[1] - 0.01, y + gusset.x, foot_t - 0.01]) rotate([90, 0, 0])
            linear_extrude(gusset.x) polygon([[0, 0], [gusset.y, 0], [0, gusset.z]]);
         // the Nano's rails and the USB cable's tie block
         translate([nano_c.x, nano_c.y, foot_t]) nano_rails(far_stop = true);
         translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_block();
         if (usb_z - tie_cable_h > foot_t)
            translate([nano_c.x - tie_block.y / 2, tie_y - tie_block.x / 2, foot_t - 0.01]) cube([tie_block.y, tie_block.x, usb_z - tie_cable_h - foot_t + 0.02]);
      }
      translate([0, y_pl - 1, 0]) along_y(0, plate_t + 2) front_holes();
      // the right wall: open in front of the carriage's tab, and at the middle to put the carriage in
      box([lw_r[0] - 1, lw_r[1] + 1], [y_in - 1, by[0] + fork_t + play], wall_gap);
      box([lw_r[0] - 1, lw_r[1] + 1], [y_in - 1, wall_back + 1], notch);
      // the strip's screws
      for (e = end_z) translate([(cw_l[0] + lw_r[0]) / 2, strip_y[0] + 1, (e[0] + e[1]) / 2]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 9);
      // the servo's screws
      for (y = sv_holes) translate([rib_x[0] - 1, y, z_mid]) rotate([0, 90, 0]) cylinder(d = sv_pilot, h = rib_t + 2);
      // the foot's bolts
      for (x = foot_bolt_xs) translate([x, bolt_y, -1]) cylinder(d = m5_d, h = foot_t + 2);
   }
}

// --- Face: printed front side up, the lettering standing out of it ---
module labels_2d() {
   // the degrees left of the indicator's slot
   for (d = degs)
      translate([ind_x - ind_slot_w / 2 - 2, lever_z(d)])
         text(str(d, "°"), size = label_size, font = font, halign = "right", valign = "center");
   // WING FLAPS down the left side, a letter under the other
   letters = "WING FLAPS";
   step = (lever_z(0) - lever_z(40) + 4) / (len(letters) - 1);
   for (i = [0 : len(letters) - 1])
      translate([-face_w / 2 + 6, lever_z(0) + 2 - i * step])
         text(letters[i], size = label_size, font = font, halign = "center", valign = "center");
   // under the slots
   for (l = [["AVOID SLIPS WITH", 0], ["FLAPS EXTENDED", 1]])
      translate([0, -2.6 - l[1] * 3.6]) text(l[0], size = 2.3, font = font, halign = "center", valign = "center");
}
module face() {
   linear_extrude(face_t) difference() { front_outline(); front_holes(); }
   translate([0, 0, face_t - 0.01]) linear_extrude(label_raise + 0.01) labels_2d();
}
module face_in_place() {
   translate([0, face_t, 0]) rotate([90, 0, 0]) face();
}
module labels_in_place() {
   translate([0, face_t, 0]) rotate([90, 0, 0]) translate([0, 0, face_t - 0.01]) linear_extrude(label_raise + 0.01) labels_2d();
}

// --- Carriage: the slider's pocket open to the front, the spring's bore in
// its right wall, a slot in its back for the slider screw's head, the tab
// over the pot's ear on its right side ---
module carriage() {
   difference() {
      union() {
         box(bx, by, [-blk_h / 2, blk_h / 2]);
         box(fork_x, [by[0], by[0] + fork_t], [-fork_h / 2, fork_h / 2]);
      }
      box([pocket_x[0], pocket_x[1]], [by[0] - 1, by[0] + sl.y + play], [-sl.z / 2 - play, sl.z / 2 + play]);
      translate([pocket_x[1] - 0.01, by[0] + sl.y / 2, 0]) rotate([0, 90, 0]) cylinder(d = lev_spring[0] + 0.4, h = spring_bore + 0.01);
      box([lever_xs[0] - screw_head[0] / 2 - play, lever_xs[2] + screw_head[0] / 2 + play], [by[0] + sl.y, by[1] + 1], [-screw_head[0] / 2 - play, screw_head[0] / 2 + play]);
      box([pot_x - pot_ear.x / 2 - 0.3, pot_x + pot_ear.x / 2 + 0.3], [by[0] - 1, by[0] + fork_t + 1], [-pot_ear.y / 2 - 0.15, pot_ear.y / 2 + 0.15]);
   }
}
module carriage_in_place(d = view_deg) {
   translate([0, 0, lever_z(d)]) carriage();
}

// --- Slider: the stem's square socket in its front, the screw through its back ---
module slider() {
   difference() {
      box([-sl.x / 2, sl.x / 2], [by[0], by[0] + sl.y], [-sl.z / 2, sl.z / 2]);
      box([-stem / 2 - 0.15, stem / 2 + 0.15], [by[0] - 1, by[0] + sl_sock], [-stem / 2 - 0.15, stem / 2 + 0.15]);
      translate([0, by[0] + sl_sock - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = sl.y);
   }
}
module slider_in_place(d = view_deg) {
   translate([lever_x(d), 0, lever_z(d)]) slider();
}

// --- Handle: the stem, a flat paddle leaning down from it, its end cut square (it prints on it) ---
module paddle_shape() {
   t = paddle.z / 2 - paddle_r;
   pl = paddle_out * 1.4;
   hull() for (u = [0, pl], s = [-1, 1], w = [-t, t]) {
      hw = (u == 0 ? paddle.x : paddle.y) / 2 - paddle_r;
      translate([s * hw, -u, w]) sphere(r = paddle_r, $fn = 16);
   }
}
module handle() {
   y0 = -handle_gap;
   difference() {
      union() {
         box([-stem / 2, stem / 2], [y0 - 1, by[0] + sl_sock - 0.3], [-stem / 2, stem / 2]);
         intersection() {
            translate([0, y0, 0]) rotate([paddle_tilt, 0, 0]) paddle_shape();
            box([-paddle.y, paddle.y], [-paddle_out, y0 + 1], [-paddle_out, paddle_out]);
         }
      }
      translate([0, by[0] + sl_sock - 0.3 + 0.01, 0]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 8);
   }
}
module handle_in_place(d = view_deg) {
   translate([lever_x(d), 0, lever_z(d)]) handle();
}
assert(-handle_gap + (paddle.z / 2) * sin(paddle_tilt) <= -0.5, "The paddle runs into the face");

// --- Strip over both channels' backs (it keeps the carriage and the carrier in); a slot for the carrier's fin ---
module strip() {
   difference() {
      box([cw_l[0], lw_r[0] - 0.2], strip_y, [end_z[0][0], end_z[1][1]]);
      box([fin_x[0] - 0.4, fin_x[1] + 0.4], [strip_y[0] - 1, strip_y[1] + 1], [z_mid - travel / 2 - fin_h / 2 - 0.5, z_mid + travel / 2 + fin_h / 2 + 0.5]);
      for (e = end_z) translate([(cw_l[0] + lw_r[0]) / 2, strip_y[0] - 1, (e[0] + e[1]) / 2]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = strip_t + 2);
   }
}

// --- Indicator carrier: the pointer on its front, the slotted fin on its back ---
module carrier() {
   difference() {
      union() {
         translate([cx[0], cy[0], -car.y / 2]) cube([car.x, cy[1] - cy[0], car.y]);
         translate([ind_x - tab[0] / 2, 0.4, -tab[1] / 2]) cube([tab[0], cy[0] - 0.4 + 0.01, tab[1]]);
         translate([fin_x[0], fin_y[0], -fin_h / 2]) cube([fin_t, fin_y[1] - fin_y[0], fin_h]);
      }
      hull() for (y = [fin_slot[0] + pin_d / 2, fin_slot[1] - pin_d / 2])
         translate([fin_x[0] - 1, y, 0]) rotate([0, 90, 0]) cylinder(d = pin_d + 0.3, h = fin_t + 2);
   }
}
module carrier_in_place(d = view_deg) {
   translate([0, 0, lever_z(d)]) carrier();
}

// --- Servo arm: pressed on the spline, the pin (an M3 screw) at its end ---
module arm() {
   difference() {
      hull() {
         cylinder(d = 8, h = arm_t);
         translate([arm_r, 0, 0]) cylinder(d = arm_w, h = arm_t);
      }
      translate([0, 0, -1]) cylinder(d = sv_spline_fit, h = arm_t + 2);
      translate([arm_r, 0, -1]) cylinder(d = pilot_d, h = arm_t + 2);
   }
}
// in place: in the x plane, pointing forward (-y) turned up by a
module arm_in_place(d = view_deg) {
   translate([arm_x[0], sv_ys, z_mid]) rotate([-arm_a(d), 0, 0]) rotate([0, 90, 0]) rotate(-90) arm();
}

// --- View-only parts ---
c_body = "#4a4a4a";
c_face = "#2e2e2e";
c_label = "#f4f4f4";
c_print = "#d8d8d8";
c_steel = "#b9c0c8";
c_mech = "#3a3a3a";            // the carriage and the slider, printed black (seen through the slot)

module servo_part() {
   color("#1f5fbf") {
      translate([sv_top, sv_y[0], z_mid - sv_body[1] / 2]) cube([sv_body[2], sv_body[0], sv_body[1]]);
      translate([sv_top + sv_tab[2], sv_bc - sv_tab[0] / 2, z_mid - sv_body[1] / 2]) cube([sv_tab[1], sv_tab[0], sv_body[1]]);
      translate([sv_top, sv_ys, z_mid]) rotate([0, -90, 0]) cylinder(d = sv_boss[0], h = sv_boss[1]);
   }
}
module pin_part(d = view_deg) {
   color(c_steel) translate([0, sv_ys, z_mid]) rotate([-arm_a(d), 0, 0]) translate([0, -arm_r, 0]) {
      translate([fin_x[0] - 1, 0, 0]) rotate([0, 90, 0]) cylinder(d = pin_d, h = arm_x[1] - fin_x[0] + 1);
      translate([arm_x[1], 0, 0]) rotate([0, 90, 0]) cylinder(d = pin_head[0], h = pin_head[1]);
   }
}
module pot_part(d = view_deg) {
   color("#2a2a2a") box(px, pot_y, pot_z);
   color("#bbb") translate([pot_x - 2, pot_y[1], pot_z[0] - pot_tabs]) cube([4, 0.5, pot_tabs]);
   color("#ddd") box([pot_x - pot_ear.x / 2, pot_x + pot_ear.x / 2], [pot_y[0] - pot_ear.z, pot_y[0]], [lever_z(d) - pot_ear.y / 2, lever_z(d) + pot_ear.y / 2]);
}
module spring_part(d = view_deg) {
   x0 = lever_x(d) + sl.x / 2;
   x1 = pocket_x[1] + spring_bore;
   color(c_steel) translate([x0, by[0] + sl.y / 2, lever_z(d)]) rotate([0, 90, 0])
      difference() { cylinder(d = lev_spring[0], h = x1 - x0); translate([0, 0, -1]) cylinder(d = lev_spring[0] - 1, h = x1 - x0 + 2); }
}
module nano_view() {
   translate([nano_c.x, nano_c.y, foot_t]) nano_part();
   color("#333") {
      translate([nano_c.x - usb_plug.x / 2, nano_jack_y, usb_z - usb_plug.y / 2]) cube([usb_plug.x, usb_plug.z, usb_plug.y]);
      translate([nano_c.x, nano_jack_y + usb_plug.z, usb_z]) rotate([-90, 0, 0]) cylinder(d = cable_d, h = body.y - nano_jack_y - usb_plug.z + 30);
   }
   translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_part();
}
module bolts_part() {
   color(c_steel) for (x = foot_bolt_xs) translate([x, bolt_y, foot_t]) cylinder(d = m5_head_d, h = 3);
}
module sheet_part() {
   color("#9aa4ad", 0.5) along_y(y_in, y_in + sheet_t) difference() {
      translate([-face_w / 2 - 20, face_z[0] - 20]) square([face_w + 40, face_z[1] - face_z[0] + 40]);
      translate([-body.x / 2 - sheet_cut_clear, -0.01]) square([body.x + 2 * sheet_cut_clear, body.z + sheet_cut_clear]);
   }
}

module assembled(d = view_deg, sheet = true) {
   color(c_body) body();
   color(c_face) face_in_place();
   color(c_label) labels_in_place();
   color(c_mech) carriage_in_place(d);
   color(c_mech) slider_in_place(d);
   spring_part(d);
   color("#f0f0f0") handle_in_place(d);
   color(c_print) strip();
   color("#eeeeee") carrier_in_place(d);
   color(c_print) arm_in_place(d);
   pin_part(d);
   pot_part(d);
   servo_part();
   nano_view();
   bolts_part();
   if (sheet) sheet_part();
}

module exploded_view(e = explode) {
   color(c_body) body();
   color(c_face) translate([0, -e, 0]) face_in_place();
   color(c_label) translate([0, -e, 0]) labels_in_place();
   color("#f0f0f0") translate([0, -2 * e, 0]) handle_in_place(0);
   color(c_print) translate([0, e, 0]) carriage_in_place(0);
   color(c_print) translate([0, 0.5 * e, 0]) slider_in_place(0);
   translate([0, 1.5 * e, 0]) pot_part(0);
   color(c_print) translate([0, 2 * e, 0]) strip();
   color("#eeeeee") translate([0, 0, 1.5 * e + travel]) carrier_in_place(0);
   translate([0, e, 0]) { color(c_print) arm_in_place(0); pin_part(0); }
   translate([e, e, 0]) servo_part();
   translate([-e, e, 0]) nano_view();
}

// from behind, the strip and the face off: carriage, slider, pot, carrier, arm
module mechanism_view(d = view_deg) {
   color(c_body) body();
   color(c_mech) carriage_in_place(d);
   color(c_mech) slider_in_place(d);
   spring_part(d);
   color("#eeeeee") carrier_in_place(d);
   color(c_print) arm_in_place(d);
   pin_part(d);
   pot_part(d);
   servo_part();
}

// Print places
translate([0, 0, -y_pl]) rotate([90, 0, 0]) body(); // Make module body
face(); // Make module face
translate([0, 0, paddle_out]) rotate([90, 0, 0]) handle(); // Make module handle
translate([0, 0, -by[0]]) rotate([90, 0, 0]) carriage(); // Make module carriage
translate([0, 0, by[0] + sl.y]) rotate([-90, 0, 0]) slider(); // Make module slider
translate([0, 0, strip_y[1]]) rotate([-90, 0, 0]) strip(); // Make module strip
translate([0, 0, -cx[0]]) rotate([0, -90, 0]) carrier(); // Make module carrier
arm(); // Make module arm

//assembled(); // Make view main 70,0,-35
//assembled(); // Make view front 90,0,0
//assembled(sheet = false); // Make view back 60,0,150
//mechanism_view(15); // Make view mechanism 90,0,180
//exploded_view(); // Make view exploded 65,0,150
