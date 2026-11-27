// Flaps panel: wing flap lever and flap position indicator
//
// Right of the mixture, like in the 172N: WING FLAPS read down the left
// side, the scale UP, 10, 20, 30 (FULL), the indicator's pointer in a
// narrow slot beside it showing where the flaps are, and the white lever
// in a slot right of it, snapping into a detent at each position. Mounted
// in the cockpit frame (frame/) like the pedestal, with no housing: it is
// behind the sheet. Its front plate has a flange on the left, the right
// and the bottom (none at the top: the waist bars are behind the sheet
// there), screwed onto the sheet (M3, nuts behind it), the separate face
// in front of it; everything else hangs on the plate's back and goes
// through the cut-out in the lower right sheet. A foot along the plate's
// bottom stands on the frame's throttle bar, two M5 bolts through it into
// T-nuts in the bar's top slot.
//
// - Lever: the printed handle's stem goes through the lever slot into a
//   block sliding in a channel on the plate's back. A steel ball on a
//   spring in the block's side snaps into a notch in the channel's wall
//   at each position. A magnet in the block's back passes four A3144 hall
//   sensors on a strip screwed over the channel's back (it also keeps
//   the block in), one at each position, so MobiFlight sets the flap
//   handle exactly on each (D2..D5, active low).
// - Indicator: the pointer is on a carrier sliding in a channel of its
//   own beside the lever's, kept in by the same strip. A fin on its back
//   (through a slot in the strip) has a slot along y; a pin (an M3 screw) on the arm of an SG90 servo runs in
//   it (a scotch yoke): the pointer moves r sin(angle) up and down, no
//   gears. MobiFlight drives the servo (D9) from the flaps' actual
//   position through an interpolation table (indicator_table, echoed).
// - An Arduino Nano of its own (MobiFlight) in rails on the foot behind
//   the lever, its USB jack back, the cable tied onto a block behind the
//   plug (README.md, Connections).
//
// Coordinates, installed: x to the right (seen from the pilot), y
// backwards, z up; y = 0 is the face's front, z = 0 the foot's underside
// (the throttle bar's top, the cut-out's bottom), x = 0 the middle.
//
// Prints: the body on its face (front plate down), the face front side
// up (lettering for a paint pen), the handle on its back, the carrier on
// its front, the arm and the sensor strip flat.

$fn = 48;

include <nano.inc.scad>
include <usb.inc.scad>
include <stepper.inc.scad>   // sensor (A3144), magnet

// Preview
view_flaps = 0;              // 0 (UP) .. 1 (30, FULL): lever and indicator
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
foot_bolt_xs = [-18, -4];    // the foot's bolts (the frame's flaps_bolt_xs)
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;

// --- Positions ---
travel = 44;                 // UP to 30, lever and pointer (the 172N's, scaled off the X-Plane panel)
n_pos = 4;                   // UP, 10, 20, 30
z_mid = 39;                  // the travel's middle (and the servo's shaft)

// --- Lever ---
blk = [11, 12, 14];          // the block: across, deep, high
play = 0.3;
lever_wall = 3;              // the right channel wall, with the notches
stem = 6;                    // the handle's square stem
handle = [26, 10, 5];        // the blade: long (to the right), high, thick
handle_gap = 2;              // the blade in front of the face
ball_d = 4;                  // detent: steel ball, MEASURE
det_spring = [3.5, 8, 2];    // its spring: outer diameter, free length, preload, MEASURE
ball_out = 1.2;              // out of the block
notch_depth = 0.9;
strip_t = 3.5;               // the sensor strip
end_h = 6;                   // the channel's end blocks (the strip's screws)

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
car = [6, 12];               // the carrier: across, high (as deep as the lever's block)
car_wall = 1.5;
tab = [3, 3];                // the pointer: across, high
ind_slot_w = 4;
arm_r = 23;                  // shaft to pin
arm_t = 3;                   // = the spline's length
arm_w = 6;
pin_d = 3;                   // M3 screw
fin_t = 3;
rib_t = 3;                   // the servo's rib

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
pos_z = [for (k = [0 : n_pos - 1]) z_mid + travel / 2 - k * travel / (n_pos - 1)];   // UP at the top
function lever_z(f) = z_mid + travel / 2 - f * travel;    // f: 0 (UP) .. 1

// lever, from the right
lw_r = [side - lever_wall, side];                     // right wall (notches)
bx = [lw_r[0] - play - blk.x, lw_r[0] - play];        // the block
lever_x = (bx[0] + bx[1]) / 2;
by = [y_in + play, y_in + play + blk.y];
strip_y = [by[1] + play, by[1] + play + strip_t];
lw_l = [bx[0] - play - 1.7, bx[0] - play];            // left wall
chan_z = [z_mid - travel / 2 - max(blk.z, car.y) / 2 - 1, z_mid + travel / 2 + max(blk.z, car.y) / 2 + 1];
end_z = [[foot_t, chan_z[0]], [chan_z[1], chan_z[1] + end_h]];
// indicator, left of the lever
cw_r = [lw_l[0] - car_wall, lw_l[0]];
cx = [cw_r[0] - play - car.x, cw_r[0] - play];
ind_x = (cx[0] + cx[1]) / 2;
cw_l = [cx[0] - play - car_wall, cx[0] - play];
cy = by;
fin_x = [cx[0] + 0.6, cx[0] + 0.6 + fin_t];
// servo: shaft along +x, its body to the left, long side along y
arm_x = [fin_x[0] - 0.5 - sv_screw[2] - 0.5 - arm_t, fin_x[0] - 0.5 - sv_screw[2] - 0.5];
sv_top = arm_x[0] - sv_boss[1];                       // the servo's top (x)
a_max = asin(travel / 2 / arm_r);
sv_ys = strip_y[1] + 1 + pin_d / 2 - arm_r * cos(a_max);   // the shaft's y: the pin stays behind the strip
sv_y = [sv_ys - sv_shaft_dx, sv_ys - sv_shaft_dx + sv_body[0]];   // its body
sv_bc = (sv_y[0] + sv_y[1]) / 2;
sv_holes = [for (s = [-1, 1]) sv_bc + s * sv_tab_hole / 2];      // y, at z_mid
rib_x = [sv_top - sv_tab[2] + 0.01, sv_top - sv_tab[2] + rib_t];
rib_y = [y_in, sv_bc + sv_tab[0] / 2 + 2];
rib_z = [z_mid - sv_body[1] / 2 - 5, z_mid + sv_body[1] / 2 + 5];
fin_slot = [sv_ys + arm_r * cos(a_max) - pin_d / 2 - 0.5, sv_ys + arm_r + pin_d / 2 + 0.5];
fin_y = [cy[1] - 0.01, fin_slot[1] + 2];
fin_h = pin_d + 0.3 + 5;
function arm_a(f) = asin((lever_z(f) - z_mid) / arm_r);  // the arm's angle for the pointer at f, from +y, up positive
// Nano on the foot behind the lever, the jack back
nano_c = [side - nano_rail_hw - 0.5, strip_y[1] + 1 + nano_rail_end];
usb_z = foot_t + nano_top_h + nano_usb.y / 2;
nano_jack_y = nano_c.y + nano_board.y / 2 + nano_usb_out;
tie_y = nano_jack_y + usb_plug.z + tie_gap + tie_block.x / 2;

mount_holes = [for (s = [-1, 1], z = [-flange_w / 2, body.z - 5]) [s * (face_w / 2 - mount_inset), z]];

// the servo's angle (MobiFlight, 90 = arm straight back) for the flaps at
// f, and the table for its interpolation
indicator_table = [for (f = [0 : 0.25 : 1]) [f, round(10 * (90 + arm_a(f))) / 10]];
echo(indicator_table = indicator_table, detents_z = pos_z, lever_x = lever_x, ind_x = ind_x);

// --- Checks ---
assert(face_w <= bed.x && face_z[1] - face_z[0] <= bed.y, "Face does not fit the printer bed");
assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear, "Mount nuts do not sit on the sheet, make flange_w wider");
assert(chan_z[0] >= foot_t + 3 && end_z[1][1] <= body.z - 0.5, "The lever's channel off the body's height");
assert(cw_l[0] >= arm_x[1] + 0.2, "The carrier's channel runs into the servo's arm");
assert(arm_x[1] + sv_screw[2] + 0.5 <= fin_x[0], "The arm's screw runs into the fin");
assert(sv_top - sv_body[2] >= -side, "The servo out of the cut-out");
assert(rib_y[0] <= sv_bc - sv_tab[0] / 2 && sv_holes[0] - sv_pilot / 2 >= y_in + 0.5, "The servo's tabs off its rib");
assert(travel / 2 < arm_r * 0.97, "The arm too short for the travel");
assert(sv_y[0] >= y_in + 0.5 && sv_bc - sv_tab[0] / 2 >= y_in + 0.5, "The servo runs into the front plate");
assert(z_mid - arm_r - arm_w / 2 >= foot_t + nano_top_h + nano_usb.y + 1 || nano_c.x - nano_rail_hw >= fin_x[1] + 1, "The arm runs into the Nano");
assert(lever_z(1) - fin_h / 2 >= foot_t + nano_top_h + nano_usb.y + 0.5 || nano_c.x - nano_rail_hw >= fin_x[1] + 1, "The fin runs into the Nano");
assert(nano_c.y - nano_rail_end >= strip_y[1] + 0.5, "The Nano runs into the sensor strip");
assert(tie_y + tie_block.x / 2 <= body.y, "The USB tie block off the foot");
for (b = foot_bolt_xs) {
   assert(b - m5_head_d / 2 >= -side && b + m5_head_d / 2 <= nano_c.x - nano_rail_hw - 0.5, "A foot bolt's head runs into the Nano or out of the foot");
}
assert(ball_d / 2 + det_spring[1] - det_spring[2] + ball_d / 2 - ball_out <= blk.x - 1, "The detent's pocket deeper than the block");
assert(det_spring[0] < ball_d, "The detent spring wider than the ball");
assert(magnet[1] + 0.3 <= magnet_gap_max + sensor.y, "The sensors too far from the magnet");
assert(travel / (n_pos - 1) >= blk.z / 2 + sensor.z, "Detents too close for the hall sensors");
assert(ind_x - ind_slot_w / 2 - 12 >= -face_w / 2 + flange_w, "No room for the scale left of the indicator");

// --- Helpers ---
module along_y(y0, y1) {
   translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}
module along_x(x0, x1) {
   translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children();
}
module stadium(c, w, hl) {
   hull() for (s = [-1, 1]) translate([c.x, c.y + s * (hl - w / 2)]) circle(d = w);
}

// --- Front: outline, holes, slots ---
module front_outline() {
   hull() {
      translate([-face_w / 2, face_z[0]]) square([face_w, 1]);
      for (s = [-1, 1]) translate([s * (face_w / 2 - face_r), face_z[0] + face_r]) circle(r = face_r);
      translate([-face_w / 2, face_z[1] - 1]) square([face_w, 1]);
   }
}
lever_hl = travel / 2 + stem / 2 + (stem + 0.6) / 2 + 0.3;   // the square stem clear of the round ends
ind_hl = travel / 2 + tab[1] / 2 + 1;
module front_holes() {
   for (h = mount_holes) translate(h) circle(d = mount_d);
   stadium([lever_x, z_mid], stem + 0.6, lever_hl);
   stadium([ind_x, z_mid], ind_slot_w, ind_hl);
}

// --- Body: front plate, foot, the lever's channel, the carrier's channel, the servo's rib, the Nano's rails ---
module body() {
   difference() {
      union() {
         along_y(y_pl, y_in) front_outline();
         translate([-body.x / 2, y_pl, 0]) cube([body.x, body.y - y_pl, foot_t]);
         // the lever's channel: walls, end blocks (the strip's screws)
         for (w = [lw_l, lw_r]) translate([w[0], y_in - 0.01, chan_z[0]]) cube([w[1] - w[0], strip_y[0] - y_in + 0.01, chan_z[1] - chan_z[0]]);
         for (e = end_z) translate([lw_l[0], y_in - 0.01, e[0]]) cube([lw_r[1] - lw_l[0], strip_y[0] - y_in + 0.01, e[1] - e[0]]);
         // the carrier's channel
         for (w = [cw_l, cw_r]) translate([w[0], y_in - 0.01, chan_z[0]]) cube([w[1] - w[0], strip_y[0] - y_in + 0.01, chan_z[1] - chan_z[0]]);
         // the servo's rib, a window for its body
         difference() {
            translate([rib_x[0], y_in - 0.01, rib_z[0]]) cube([rib_x[1] - rib_x[0], rib_y[1] - y_in, rib_z[1] - rib_z[0]]);
            translate([rib_x[0] - 1, sv_y[0] - play, z_mid - sv_body[1] / 2 - play]) cube([rib_t + 2, sv_body[0] + 2 * play, sv_body[1] + 2 * play]);
         }
         // the Nano's rails and the USB cable's tie block
         translate([nano_c.x, nano_c.y, foot_t]) nano_rails(far_stop = true);
         translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_block();
         if (usb_z - tie_cable_h > foot_t)
            translate([nano_c.x - tie_block.y / 2, tie_y - tie_block.x / 2, foot_t - 0.01]) cube([tie_block.y, tie_block.x, usb_z - tie_cable_h - foot_t + 0.02]);
      }
      translate([0, y_pl - 1, 0]) along_y(0, plate_t + 2) front_holes();
      // detent notches in the right wall
      for (z = pos_z) translate([lw_r[0] - 0.01, y_in - 1, z]) rotate([-90, 0, 0])
         linear_extrude(blk.y + 2) polygon([[0, -notch_depth * 1.2], [notch_depth, 0], [0, notch_depth * 1.2]]);
      // the strip's screws
      for (e = end_z) translate([(lw_l[0] + lw_r[1]) / 2, strip_y[0] + 1, (e[0] + e[1]) / 2]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 9);
      // the servo's screws
      for (y = sv_holes) translate([rib_x[1] + 1, y, z_mid]) rotate([0, -90, 0]) cylinder(d = sv_pilot, h = rib_t + 2);
      // the foot's bolts
      for (x = foot_bolt_xs) translate([x, bolt_y, -1]) cylinder(d = m5_d, h = foot_t + 2);
   }
}

// --- Face: printed front side up, the lettering standing out of it ---
module labels_2d() {
   // the scale: ticks to the indicator's slot, the degrees left of them
   for (k = [0 : n_pos - 1]) {
      translate([ind_x - ind_slot_w / 2 - 4, pos_z[k] - 0.4]) square([3.4, 0.8]);
      translate([ind_x - ind_slot_w / 2 - 5, pos_z[k]])
         text(k == 0 ? "UP" : str(k * 10, "°"), size = label_size, font = font, halign = "right", valign = "center");
   }
   translate([ind_x - ind_slot_w / 2 - 5, pos_z[n_pos - 1] - 6]) text("FULL", size = label_size, font = font, halign = "right", valign = "center");
   // WING FLAPS read downwards at the left
   for (l = [["WING", 1], ["FLAPS", 0]])
      translate([-face_w / 2 + flange_w + 3 + l[1] * 5, z_mid]) rotate(-90) text(l[0], size = label_size, font = font, halign = "center", valign = "center");
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

// --- Lever block: the stem's socket at its front, the ball's pocket in its right side, the magnet in its back ---
module block() {
   difference() {
      translate([bx[0], by[0], -blk.z / 2]) cube([blk.x, blk.y, blk.z]);
      translate([lever_x - stem / 2 - 0.15, by[0] - 1, -stem / 2 - 0.15]) cube([stem + 0.3, 6 + 1, stem + 0.3]);
      translate([lever_x, by[0] + 6, 0]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = 4);
      translate([bx[1] + 1, (by[0] + by[1]) / 2 - 1, 0]) rotate([0, -90, 0])
         cylinder(d = ball_d + 0.3, h = 1 + ball_d / 2 + det_spring[1] - det_spring[2] + ball_d / 2 - ball_out);
      translate([lever_x, by[1] - magnet[1], 0]) rotate([-90, 0, 0]) cylinder(d = magnet[0] + 0.2, h = magnet[1] + 1);
   }
}
module block_in_place(f = view_flaps) {
   translate([0, 0, lever_z(f)]) block();
}

// --- Handle: the stem through the slot into the block, the white blade to the right; an M3 screw through both ---
module handle() {
   y0 = -handle_gap - handle.z;
   difference() {
      union() {
         translate([lever_x - stem / 2, y0, -stem / 2]) cube([stem, by[0] + 6 - y0 - 0.3, stem]);
         hull() {
            translate([lever_x - stem / 2, y0, -handle.y / 2]) cube([1, handle.z, handle.y]);
            translate([lever_x + handle.x - handle.y / 2, y0, 0]) rotate([-90, 0, 0]) cylinder(d = handle.y, h = handle.z);
         }
      }
      translate([lever_x, y0 - 1, 0]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = 30);
      translate([lever_x, y0 - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d1 = 6.2, d2 = clear_d, h = 1.5);
   }
}
module handle_in_place(f = view_flaps) {
   translate([0, 0, lever_z(f)]) handle();
}

// --- Sensor strip over both channels' backs (it keeps the block and the
// carrier in): an A3144 at each position, flat face to the magnet; a slot
// for the carrier's fin ---
module strip() {
   difference() {
      translate([cw_l[0], strip_y[0], end_z[0][0]]) cube([lw_r[1] - cw_l[0], strip_t, end_z[1][1] - end_z[0][0]]);
      translate([fin_x[0] - 0.4, strip_y[0] - 1, z_mid - travel / 2 - fin_h / 2 - 0.5]) cube([fin_t + 0.8, strip_t + 2, travel + fin_h + 1]);
      for (z = pos_z) {
         translate([lever_x - sensor.x / 2 - 0.15, strip_y[0] - 0.01, z - sensor.z / 2 - 0.15]) cube([sensor.x + 0.3, sensor.y + 0.11, sensor.z + 0.3]);
         translate([lever_x - sensor_legs_w / 2, strip_y[0] - 0.01, z - sensor.z / 2 - 2.5]) cube([sensor_legs_w, strip_t + 1, 2.5]);
      }
      for (e = end_z) translate([(lw_l[0] + lw_r[1]) / 2, strip_y[0] - 1, (e[0] + e[1]) / 2]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = strip_t + 2);
   }
}

// --- Indicator carrier: the pointer on its front, dovetailed, the slotted fin on its back ---
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
module carrier_in_place(f = view_flaps) {
   translate([0, 0, lever_z(f)]) carrier();
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
// in place: in the x plane, pointing back (+y) turned up by a
module arm_in_place(f = view_flaps) {
   translate([arm_x[0], sv_ys, z_mid]) rotate([arm_a(f), 0, 0]) rotate([0, 90, 0]) rotate(90) arm();
}

// --- View-only parts ---
c_body = "#4a4a4a";
c_face = "#2e2e2e";
c_label = "#f4f4f4";
c_print = "#d8d8d8";
c_steel = "#b9c0c8";

module servo_part() {
   color("#1f5fbf") {
      translate([sv_top - sv_body[2], sv_y[0], z_mid - sv_body[1] / 2]) cube([sv_body[2], sv_body[0], sv_body[1]]);
      translate([sv_top - sv_tab[2] - sv_tab[1], sv_bc - sv_tab[0] / 2, z_mid - sv_body[1] / 2]) cube([sv_tab[1], sv_tab[0], sv_body[1]]);
      translate([sv_top, sv_ys, z_mid]) rotate([0, 90, 0]) cylinder(d = sv_boss[0], h = sv_boss[1]);
   }
}
module pin_part(f = view_flaps) {
   color(c_steel) translate([arm_x[0], sv_ys, z_mid]) rotate([arm_a(f), 0, 0]) translate([-2, arm_r, 0]) rotate([0, 90, 0]) {
      cylinder(d = pin_d, h = fin_x[1] - arm_x[0] + 3);
      cylinder(d = 5.5, h = 2);
   }
}
module sensors_part() {
   color("#222") for (z = pos_z) translate([lever_x - sensor.x / 2, strip_y[0], z - sensor.z / 2]) cube(sensor);
   color("#888") translate([lever_x, by[1] - magnet[1], lever_z(view_flaps)]) rotate([-90, 0, 0]) cylinder(d = magnet[0], h = magnet[1]);
   color(c_steel) translate([bx[1] + ball_d / 2 - ball_out, (by[0] + by[1]) / 2 - 1, lever_z(view_flaps)]) sphere(d = ball_d);
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

module assembled(f = view_flaps, sheet = true) {
   color(c_body) body();
   color(c_face) face_in_place();
   color(c_label) labels_in_place();
   color(c_print) block_in_place(f);
   color("#f0f0f0") handle_in_place(f);
   color(c_print) strip();
   color("#eeeeee") carrier_in_place(f);
   color(c_print) arm_in_place(f);
   pin_part(f);
   servo_part();
   sensors_part();
   nano_view();
   bolts_part();
   if (sheet) sheet_part();
}

module exploded_view(e = explode) {
   color(c_body) body();
   color(c_face) translate([0, -e, 0]) face_in_place();
   color(c_label) translate([0, -e, 0]) labels_in_place();
   color("#f0f0f0") translate([0, -2 * e, 0]) handle_in_place(0);
   color(c_print) translate([0, e, 0]) block_in_place(0);
   color(c_print) translate([0, 2 * e, 0]) strip();
   color("#eeeeee") translate([0, 0, 1.5 * e + travel]) carrier_in_place(0);
   translate([-e, 0, 0]) { color(c_print) arm_in_place(0); pin_part(0); }
   translate([-2 * e, 0, 0]) servo_part();
   translate([0, e, 0]) nano_view();
}

// from behind, the strip and the face off: lever, carrier, arm
module mechanism_view(f = view_flaps) {
   color(c_body) body();
   color(c_print) block_in_place(f);
   color("#eeeeee") carrier_in_place(f);
   color(c_print) arm_in_place(f);
   pin_part(f);
   servo_part();
   sensors_part();
}

// Print places
translate([0, 0, -y_pl]) rotate([90, 0, 0]) body(); // Make module body
face(); // Make module face
translate([0, 0, handle_gap + handle.z]) rotate([-90, 0, 0]) handle(); // Make module handle
translate([0, 0, blk.z / 2]) block(); // Make module block
translate([0, 0, strip_y[1]]) rotate([-90, 0, 0]) strip(); // Make module strip
translate([0, 0, -cy[0]]) rotate([90, 0, 0]) carrier(); // Make module carrier
arm(); // Make module arm

//assembled(); // Make view main 70,0,-35
//assembled(); // Make view front 90,0,0
//assembled(0.5, sheet = false); // Make view back 60,0,150
//mechanism_view(1); // Make view mechanism 90,0,180
//exploded_view(); // Make view exploded 65,0,150
