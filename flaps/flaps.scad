// Flaps panel: wing flap lever and flap position indicator
//
// Right of the mixture, like in the 172N: WING FLAPS read down the left
// side, the scale 0, 10, 20, 30, 40 degrees (0 to 10 twice as long as
// the others, like the real placard), the indicator's pointer in a narrow
// slot beside it showing where the flaps are, and the white lever in a
// stepped slot right of it. The lever is an arm swinging on a rod behind
// the plate, like the real one (its cam and switches turn on a pivot):
// the paddle is level at 0 and leans down as the lever goes down. It has
// no detents: it moves continuously and stays where it is left (the flaps
// follow it, like the 172N's preselect lever). The slot stops it: going
// down from 0 it rests on a step at 10, moved to the right it goes on down
// to a step at 20, moved to the right again it goes down to 40 (FULL). A
// spring holds it to the left, against the steps; going up it springs back
// left past them. Mounted in the cockpit frame (frame/) like the pedestal,
// with no housing: it is behind the sheet. Its front plate has a flange on
// the left, the right and the bottom (none at the top: the waist bars are
// behind the sheet there), screwed onto the sheet (M3, nuts behind it), the
// separate face in front of it; everything else hangs on the plate's back
// and goes through the cut-out in the lower right sheet. A foot along the
// plate's bottom stands on the frame's throttle bar, two M5 bolts through
// it into T-nuts in the bar's top slot.
//
// - Lever: one print, a hub turning and sliding on a fixed 6 mm steel rod
//   (along x, between two walls on the foot), the arm forward from it, a
//   square stem on its end through the lever slot, a gear sector under the
//   hub. The paddle (the 172's flat white handle) is a print of its own,
//   pushed onto the stem in front of the face and screwed across. A spring
//   on the rod between the hub and the right wall pushes the lever to the
//   left: the stem rests on the slot's edges (the steps are the stops), and
//   the spring pressing it on the edge and on the hub gives the lever its
//   friction.
// - The sector turns a wide pinion (the lever slides along it) on a 16 mm
//   rotary pot in the left wall, 5:1, so the lever's 26 degrees turn the pot
//   131 degrees; its wiper (A0) gives MobiFlight the lever's position, which
//   it turns into the flap handle's ratio through a table (lever_table,
//   echoed).
// - Indicator: the pointer is on a carrier sliding in a channel left of the
//   lever's slot, a strip screwed over the channel keeps it in. Behind the
//   strip a yoke plate is screwed onto the carrier's post: a pin (an M3
//   screw) on the arm of an SG90 servo runs in its horizontal slot (a
//   scotch yoke), so the pointer moves r sin(angle) up and down, no gears.
//   The servo (its shaft along y) is on a rib off the left wall. MobiFlight
//   drives it (D9) from the flaps' actual position through an interpolation
//   table (indicator_table, echoed).
// - An Arduino Nano of its own (MobiFlight) in rails on the foot at the
//   left, its USB jack back, the cable tied onto a block behind the plug
//   (README.md, Connections).
//
// Coordinates, installed: x to the right (seen from the pilot), y
// backwards, z up; y = 0 is the face's front, z = 0 the foot's underside
// (the throttle bar's top, the cut-out's bottom), x = 0 the middle.
//
// Prints: the body on its face (front plate down), the face front side
// up (lettering for a paint pen), the lever on its left side, the paddle
// on its underside, the pinion on its end, the carrier on its left side,
// the yoke, the strip and the servo arm flat.

$fn = 48;

include <nano.inc.scad>
include <usb.inc.scad>

// Preview
view_deg = 25;               // flaps 0 .. 40: lever and indicator
explode = 30;

bed = [255, 255];

// --- Body, the frame's flaps_body, flaps_plate (frame/frame.inc.scad) ---
body = [68, 112, 78];        // what goes through the cut-out and behind the sheet: width, depth from the face's front, height
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
foot_bolt_xs = [5, 22];      // the foot's bolts (the frame's flaps_bolt_xs)
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;

// --- Scale ---
travel = 42;                 // 0 to 40 degrees, where the lever's stem and the pointer cross the face's front
degs = [0, 10, 20, 30, 40];
z_mid = 39;                  // the travel's middle (and the servo's shaft)
// the part of the travel from 0 to d degrees: 0 to 10 is 0.4 of it, each
// 10 after it 0.2 (the 172N placard)
function scale_at(d) = d <= 10 ? 0.04 * d : 0.2 + 0.02 * d;
function lever_z(d) = z_mid + travel / 2 - scale_at(d) * travel;

// --- Lever ---
y_p = 85;                    // the pivot (the rod) behind the face's front
stem = 6;                    // the square stem, and the arm's thickness
stem_clear = 0.3;            // to the slot's edges
x0 = 4;                      // the stem from 0 to 10 (then jog to the right)
jog = [5, 3.5];              // the slot's steps to the right at 10 and 20
arm_h = 12;                  // the arm's height at the hub (the stem's at the plate)
hub = [14, 10];              // the hub: diameter, long (from the arm's left face to the right)
rod_d = 6;
rod_hole = 6.2;              // in the walls
hub_bore = 6.5;              // turns and slides on the rod
wall_t = 3;                  // the rod's walls (the left one is the pot's plate)
wall_y0 = 28.5;              // the walls' front end (behind the servo's arm)
lev_spring = [9, 20, 6];     // on the rod: outer diameter, free length, solid length, MEASURE
spring_min = 8;              // its length with the lever at its right stop
paddle = [14, 24, 9];        // the paddle: width at the stem, at its end, thick (round the stem)
paddle_l = 30;
paddle_r = 2;
paddle_sock = 8;             // the stem in the paddle
paddle_clear = 1.5;          // the paddle to the face at 40 (it swings back towards it)

// --- Gears: the lever's sector, the pot's pinion ---
gear_m = 1;
gear_play = 0.15;
pin_z = 14;                  // pinion teeth
ratio = 5;                   // sector : pinion
pin_a = -130;                // the pinion's centre from the pivot, angle in the (y, z) plane (180 = forward, -90 = down)
pin_w_extra = 0.5;           // the pinion wider than the sector's sweep along x

// --- Rotary pot, MEASURE (16 mm, 10k linear, M7 bushing, 6 mm D shaft) ---
pot_body = [17, 10];         // diameter, depth behind its mounting face (with the lugs bent back)
pot_bush = [7, 7];           // threaded bushing: diameter, length
pot_nut = [9.5, 2];          // its nut: across flats, thick
pot_shaft = [6, 4.5, 20];    // D shaft: diameter, across the flat, length from the mounting face
pot_tab = [7.8, 1.2, 3];     // its anti-rotation tab: from the axis, thick, wide
pot_angle = 300;             // electrical angle

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
ind_x = -9;                  // the pointer's slot
car = [6, 12];               // the carrier: across, high
car_wall = 1.5;
car_d = 9.3;                 // deep
tab = [3, 3];                // the pointer: across, high
ind_slot_w = 4;
post_h = 8;                  // the carrier's post through the strip
yoke_t = 3;
arm_r = 23;                  // the servo's shaft to its pin
arm_t = 3;                   // = the spline's length
arm_w = 6;
pin_d = 3;                   // M3 screw
pin_head = [5.5, 2];
rib_t = 3;                   // the servo's rib
strip_t = 3.5;
end_h = 6;                   // the channel's end blocks (the strip's screws)
play = 0.3;

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
// lever
z_p = lever_z(0);                    // the pivot: the arm level at 0
function theta(d) = atan((z_p - lever_z(d)) / y_p);   // the lever's angle down, the stem crossing the face's front at lever_z(d)
t_max = theta(40);
lever_xs = [x0, x0 + jog[0], x0 + J];   // the stem at 0..10, 10..20, 20..40
function lever_x(d) = d < 10 ? lever_xs[0] : d < 20 ? lever_xs[1] : lever_xs[2];
r_pb = (y_p + paddle_clear + paddle.z / 2 * sin(t_max)) / cos(t_max);
y_pb = y_p - r_pb;                   // the paddle's back, at 0
y_a0 = y_p - (y_p - y_in) + 3;       // the arm grows from the stem behind this (lever frame)
hub_x = [-stem / 2, -stem / 2 + hub[1]];          // from the stem's middle
sec_x = [-stem / 2, 0];                           // the sector, flush with the arm's left face
r_sec = gear_m * pin_z * ratio / 2;
r_pin = gear_m * pin_z / 2;
cd = r_sec + r_pin;
pin_c = [y_p + cd * cos(pin_a), z_p + cd * sin(pin_a)];   // the pinion's (and pot's) axis, (y, z)
sec_a = [pin_a - t_max - 11, pin_a + 11];         // the sector's teeth, lever frame
// walls, pinion, pot
pin_x = [lever_xs[0] + sec_x[0] - pin_w_extra / 2, lever_xs[2] + sec_x[1] + pin_w_extra / 2];
lw = [pin_x[0] - (pot_bush[1] - wall_t) - 0.5 - wall_t, pin_x[0] - (pot_bush[1] - wall_t) - 0.5];   // the left wall, the pot's plate
pot_face = lw[0];                    // the pot's mounting face (x)
rw = [lever_xs[2] + hub_x[1] + spring_min, lever_xs[2] + hub_x[1] + spring_min + wall_t];
wall_z = [foot_t - 0.01, z_p + hub[0] / 2 + 2];
wall_y = [wall_y0, y_p + hub[0] / 2 + 3];
rod_x = [lw[0], rw[0] + wall_t - 1];
// indicator: channel, strip, yoke, servo arm, servo
cx = [ind_x - car.x / 2, ind_x + car.x / 2];
cw_l = [cx[0] - play - car_wall, cx[0] - play];
cw_r = [cx[1] + play, cx[1] + play + car_wall];
cy = [y_in + play, y_in + play + car_d];
strip_y = [cy[1] + play, cy[1] + play + strip_t];
chan_z = [lever_z(40) - car.y / 2 - 1, lever_z(0) + car.y / 2 + 1];
end_z = [[foot_t, chan_z[0]], [chan_z[1], chan_z[1] + end_h]];
yk_y = [strip_y[1] + 0.5, strip_y[1] + 0.5 + yoke_t];
a_max = asin(travel / 2 / arm_r);
x_s = -side + 0.5 + sv_body[1] / 2;  // the servo's shaft, its arm pointing right
yk_slot = [x_s + arm_r * cos(a_max) - pin_d / 2 - 0.5, x_s + arm_r + pin_d / 2 + 0.5];
yk_x = [yk_slot[0] - 2, yk_slot[1] + 2];
yk_h = pin_d + 0.3 + 5;
arm_y = [yk_y[1] + 0.5, yk_y[1] + 0.5 + arm_t];
sv_ty = arm_y[1] + sv_boss[1];       // the servo's top (y)
sv_z = [z_mid - sv_shaft_dx, z_mid - sv_shaft_dx + sv_body[0]];   // its body, long side up
sv_bc = (sv_z[0] + sv_z[1]) / 2;
sv_holes = [for (s = [-1, 1]) sv_bc + s * sv_tab_hole / 2];      // z, at x_s
rib_y = [sv_ty + sv_tab[2] - rib_t, sv_ty + sv_tab[2]];
rib_z = [sv_bc - sv_tab[0] / 2 - 2, sv_bc + sv_tab[0] / 2 + 2];
function arm_a(d) = asin((lever_z(d) - z_mid) / arm_r);  // the servo arm's angle for the pointer at d, from +x, up positive
// Nano on the foot at the left, the jack back
nano_c = [-side + nano_rail_hw + 0.5, strip_y[1] + 1 + nano_rail_end];
usb_z = foot_t + nano_top_h + nano_usb.y / 2;
nano_jack_y = nano_c.y + nano_board.y / 2 + nano_usb_out;
tie_y = nano_jack_y + usb_plug.z + tie_gap + tie_block.x / 2;

mount_holes = [for (s = [-1, 1], z = [-flange_w / 2, body.z - 5]) [s * (face_w / 2 - mount_inset), z]];

// the servo's angle (MobiFlight, 90 = arm pointing right) for the flaps'
// ratio (0 .. 1 = 0 .. 40 degrees), the table for its interpolation
indicator_table = [for (r = [0 : 0.125 : 1]) [r, round(10 * (90 + arm_a(40 * r))) / 10]];
// the pot's reading at each mark (0 .. 1023, the lever's middle at the
// pot's middle, rising as the lever goes down) to the flap handle's ratio
function pot_raw(d) = round(1023 * (0.5 + ratio * (theta(d) - t_max / 2) / pot_angle));
lever_table = [for (d = degs) [pot_raw(d), d / 40]];
echo(indicator_table = indicator_table, lever_table = lever_table, lever_deg = [for (d = degs) round(10 * theta(d)) / 10],
     pot_turn = ratio * t_max, marks_z = [for (d = degs) lever_z(d)]);

// --- Checks ---
assert(face_w <= bed.x && face_z[1] - face_z[0] <= bed.y, "Face does not fit the printer bed");
assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear, "Mount nuts do not sit on the sheet, make flange_w wider");
assert(chan_z[0] >= foot_t + 3 && end_z[1][1] <= body.z - 0.5, "The carrier's channel off the body's height");
assert(wall_z[1] <= body.z - 0.5 && wall_y[1] <= body.y, "The rod's walls out of the body");
assert(ratio * t_max <= pot_angle - 30, "The pot turns too far");
assert(pot_face - pot_body[1] >= -side, "The pot out of the cut-out");
assert(pot_face + pot_shaft[2] >= pin_x[1], "The pot's shaft too short for the pinion");
assert(lw[1] + pot_nut[1] <= pin_x[0] - 0.4 && lw[1] <= lever_xs[0] + hub_x[0] - 0.5, "The left wall's nut runs into the pinion or the lever");
assert(rw[1] <= side, "The right wall out of the cut-out");
assert(lev_spring[1] - 1 >= spring_min + J, "The lever's spring too short (no preload at the left)");
assert(spring_min >= lev_spring[2] + 1, "The lever's spring solid at the right");
assert(pin_c[1] - r_pin - 1 >= foot_t + 1 && pin_c[1] - pot_body[0] / 2 >= foot_t + 0.5, "The pinion or the pot runs into the foot");
assert(pin_c[0] - pot_body[0] / 2 >= wall_y[0] + 2 && pin_c[0] + pot_body[0] / 2 <= wall_y[1], "The pot off the left wall");
// the arm's lower edge at 40 over the pinion
arm_low_at_pin = z_p - (y_p - pin_c[0]) * tan(t_max) - (stem / 2 + (arm_h - stem) / 2 * (pin_c[0] - y_a0) / (y_p - y_a0)) / cos(t_max);
assert(arm_low_at_pin >= pin_c[1] + r_pin + gear_m + 1, "The lever's arm runs into the pinion at 40");
assert(y_p + paddle_l <= 255 && r_pb + paddle_sock <= 200, "The lever too long");
assert(x_s - sv_body[1] / 2 >= -side, "The servo out of the cut-out");
assert(x_s + arm_r + arm_w / 2 + 0.5 <= lever_xs[0] - stem / 2, "The servo's arm runs into the lever");
assert(x_s + sv_body[1] / 2 + 0.5 <= pot_face - pot_body[1] || sv_ty + sv_body[2] <= pin_c[0] - pot_body[0] / 2, "The servo runs into the pot");
assert(yk_x[1] + 0.5 <= lever_xs[0] - stem / 2 - stem_clear, "The yoke runs into the lever");
assert(ind_x >= yk_x[0] + 3 && ind_x <= yk_x[1] - 3, "The carrier's post off the yoke");
assert(arm_y[1] + pin_head[1] + 0.5 <= wall_y0, "The servo arm's pin runs into the walls");
assert(rib_z[0] >= foot_t + nano_top_h + nano_usb.y + 1, "The servo's rib runs into the Nano");
assert(travel / 2 < arm_r * 0.97, "The servo arm too short for the travel");
assert(z_mid - arm_r * sin(a_max) - arm_w / 2 - 1 >= foot_t + nano_top_h + nano_usb.y + 0.5, "The servo arm runs into the Nano");
assert(lever_z(40) - yk_h / 2 >= foot_t + nano_top_h + nano_usb.y + 0.5, "The yoke runs into the Nano");
assert(nano_c.x + nano_rail_hw <= lw[0] - 0.5, "The Nano runs into the left wall");
assert(nano_c.x + usb_plug.x / 2 + 0.5 <= pot_face - pot_body[1] || usb_z + usb_plug.y / 2 + 0.5 <= pin_c[1] - pot_body[0] / 2, "The USB plug runs into the pot");
assert(nano_c.y - nano_rail_end >= strip_y[1] + 0.5, "The Nano runs into the strip");
assert(tie_y + tie_block.x / 2 <= body.y, "The USB tie block off the foot");
for (b = foot_bolt_xs) {
   assert(b - m5_head_d / 2 >= lw[1] + 0.5 && b + m5_head_d / 2 <= rw[0] - 0.5, "A foot bolt's head runs into the walls");
}
assert(ind_x - ind_slot_w / 2 - 12 >= -face_w / 2 + 6, "No room for the scale left of the indicator");

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
module box(x, y, z) {
   translate([x[0], y[0], z[0]]) cube([x[1] - x[0], y[1] - y[0], z[1] - z[0]]);
}

// Involute spur gear, 20 degree pressure angle; play thins the teeth (a
// copy of instruments/instrument.inc.scad's gear_2d, keep them the same)
module gear_2d(z, m = gear_m, play = gear_play) {
   rp = m * z / 2;
   rb = rp * cos(20);
   ra = rp + m;
   rf = rp - 1.25 * m;
   tmax = sqrt(ra * ra / (rb * rb) - 1);
   hb = 90 / z + (tan(20) - 20 * PI / 180) * 180 / PI - play / 2 / rp * 180 / PI;   // half tooth on the base circle
   flank = [for (i = [0 : 12]) let(t = tmax * i / 12) [rb * sqrt(1 + t * t), hb - (t - atan(t) * PI / 180) * 180 / PI]];
   circle(r = max(rf, rb - 0.01), $fn = 4 * z);
   for (k = [0 : z - 1]) rotate(k * 360 / z)
      polygon(concat([[0, 0]],
                     [for (p = flank) p[0] * [cos(-p[1]), sin(-p[1])]],
                     [for (i = [len(flank) - 1 : -1 : 0]) flank[i][0] * [cos(flank[i][1]), sin(flank[i][1])]]));
}
// a wedge from the origin between two angles
module wedge_2d(a0, a1, r) {
   polygon(concat([[0, 0]], [for (i = [0 : 16]) let(a = a0 + (a1 - a0) * i / 16) r * [cos(a), sin(a)]]));
}

// --- Front: outline, holes, slots ---
module front_outline() {
   hull() {
      translate([-face_w / 2, face_z[0]]) square([face_w, 1]);
      for (s = [-1, 1]) translate([s * (face_w / 2 - face_r), face_z[0] + face_r]) circle(r = face_r);
      translate([-face_w / 2, face_z[1] - 1]) square([face_w, 1]);
   }
}
// the lever's slot: wide from 0 to 10, a step at 10, narrower to 20, a
// step at 20, the stem's width to 40. The stem crosses it slanting, its
// lowest edge at the face's front.
sw = stem + 2 * stem_clear;
function slot_bottom(d) = lever_z(d) - stem / 2 / cos(theta(d)) - stem_clear;
module lever_slot() {
   top = z_p + stem / 2 + stem_clear;
   translate([lever_xs[0] - sw / 2, slot_bottom(10)]) square([J + sw, top - slot_bottom(10)]);
   translate([lever_xs[1] - sw / 2, slot_bottom(20)]) square([jog[1] + sw, top - slot_bottom(20)]);
   translate([lever_xs[2] - sw / 2, slot_bottom(40)]) square([sw, top - slot_bottom(40)]);
}
ind_hl = travel / 2 + tab[1] / 2 + 1;
module front_holes() {
   for (h = mount_holes) translate(h) circle(d = mount_d);
   lever_slot();
   stadium([ind_x, z_mid], ind_slot_w, ind_hl);
}

// --- Body: front plate, foot, the carrier's channel, the rod's walls (the left one the pot's plate), the servo's rib, the Nano's rails ---
module body() {
   difference() {
      union() {
         along_y(y_pl, y_in) front_outline();
         translate([-body.x / 2, y_pl, 0]) cube([body.x, body.y - y_pl, foot_t]);
         // the carrier's channel and its end blocks (the strip's screws)
         for (w = [cw_l, cw_r]) box(w, [y_in - 0.01, strip_y[0]], chan_z);
         for (e = end_z) box([cw_l[0], cw_r[1]], [y_in - 0.01, strip_y[0]], e);
         // the rod's walls
         for (w = [lw, rw]) box(w, wall_y, wall_z);
         // the servo's rib off the left wall, a window for its body
         difference() {
            box([-side, lw[0] + 0.01], rib_y, rib_z);
            box([x_s - sv_body[1] / 2 - play, x_s + sv_body[1] / 2 + play], [rib_y[0] - 1, rib_y[1] + 1], [sv_z[0] - play, sv_z[1] + play]);
         }
         // the Nano's rails and the USB cable's tie block
         translate([nano_c.x, nano_c.y, foot_t]) nano_rails(far_stop = true);
         translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_block();
         if (usb_z - tie_cable_h > foot_t)
            translate([nano_c.x - tie_block.y / 2, tie_y - tie_block.x / 2, foot_t - 0.01]) cube([tie_block.y, tie_block.x, usb_z - tie_cable_h - foot_t + 0.02]);
      }
      translate([0, y_pl - 1, 0]) along_y(0, plate_t + 2) front_holes();
      // the rod: through the left wall, blind in the right one
      translate([lw[0] - 1, y_p, z_p]) rotate([0, 90, 0]) cylinder(d = rod_hole, h = rw[0] + wall_t - 1 - lw[0] + 1);
      // the pot's bushing and its tab
      translate([lw[0] - 1, pin_c[0], pin_c[1]]) rotate([0, 90, 0]) cylinder(d = pot_bush[0] + 0.3, h = wall_t + 2);
      translate([lw[0] - 1, pin_c[0] - pot_tab[2] / 2 - 0.2, pin_c[1] + pot_tab[0] - pot_tab[1] / 2 - 0.2]) cube([1 + 1.2, pot_tab[2] + 0.4, pot_tab[1] + 0.4]);
      // the strip's screws
      for (e = end_z) translate([ind_x, strip_y[0] + 1, (e[0] + e[1]) / 2]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 9);
      // the servo's screws
      for (z = sv_holes) translate([x_s, rib_y[1] + 1, z]) rotate([90, 0, 0]) cylinder(d = sv_pilot, h = rib_t + 2);
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
      translate([ind_x - ind_slot_w / 2 - 17, lever_z(0) + 2 - i * step])
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

// --- Lever, at 0 (level), x from the stem's middle: hub, arm, stem, sector ---
module lever() {
   difference() {
      union() {
         // the hub
         translate([hub_x[0], y_p, z_p]) rotate([0, 90, 0]) cylinder(d = hub[0], h = hub[1]);
         // the arm, from the stem's height behind the plate to arm_h at the hub
         along_x(-stem / 2, stem / 2) hull() {
            translate([y_a0, z_p - stem / 2]) square([0.01, stem]);
            translate([y_p - hub[0] / 2, z_p - arm_h / 2]) square([0.01, arm_h]);
         }
         // the stem through the slot into the paddle
         box([-stem / 2, stem / 2], [y_pb - paddle_sock + 0.3, y_a0 + 0.01], [z_p - stem / 2, z_p + stem / 2]);
         // the sector
         along_x(sec_x[0], sec_x[1]) translate([y_p, z_p]) intersection() {
            gear_2d(pin_z * ratio);
            wedge_2d(sec_a[0], sec_a[1], r_sec + 2 * gear_m);
         }
         along_x(sec_x[0], sec_x[1]) translate([y_p, z_p]) wedge_2d(sec_a[0], sec_a[1], r_sec - 1.25 * gear_m);
      }
      translate([hub_x[0] - 1, y_p, z_p]) rotate([0, 90, 0]) cylinder(d = hub_bore, h = hub[1] + 2);
      // the paddle's screw, across
      translate([-stem / 2 - 1, y_pb - paddle_sock / 2, z_p]) rotate([0, 90, 0]) cylinder(d = pilot_d, h = stem + 2);
   }
}
module paddle() {
   t = paddle.z;
   module outline(o) offset(r = paddle_r - o) offset(delta = -paddle_r)
      polygon([[-paddle.x / 2, y_pb], [paddle.x / 2, y_pb], [paddle.y / 2, y_pb - paddle_l], [-paddle.y / 2, y_pb - paddle_l]]);
   difference() {
      hull() {
         translate([0, 0, z_p - t / 2]) linear_extrude(t - 1.2) outline(0);
         translate([0, 0, z_p - t / 2]) linear_extrude(t) outline(1.2);
      }
      box([-stem / 2 - 0.15, stem / 2 + 0.15], [y_pb - paddle_sock, y_pb + 1], [z_p - stem / 2 - 0.15, z_p + stem / 2 + 0.15]);
      translate([-paddle.x, y_pb - paddle_sock / 2, z_p]) rotate([0, 90, 0]) cylinder(d = clear_d, h = 2 * paddle.x);
   }
}
module at_lever(d) {
   translate([lever_x(d), 0, 0]) translate([0, y_p, z_p]) rotate([theta(d), 0, 0]) translate([0, -y_p, -z_p]) children();
}
assert(y_pb + paddle.z / 2 * sin(0) <= -paddle_clear, "The paddle runs into the face at 0");

// --- Pinion on the pot's D shaft, as wide as the sector's sweep ---
module pinion() {
   difference() {
      linear_extrude(pin_x[1] - pin_x[0]) gear_2d(pin_z);
      translate([0, 0, -1]) linear_extrude(pin_x[1] - pin_x[0] + 2) intersection() {
         circle(d = pot_shaft[0] + 0.2);
         translate([-pot_shaft[0], -pot_shaft[0] / 2 - 0.1]) square([2 * pot_shaft[0], pot_shaft[1] + 0.2]);
      }
   }
}
module pinion_in_place(d = view_deg) {
   translate([pin_x[0], pin_c[0], pin_c[1]]) rotate([0, 90, 0]) rotate(ratio * theta(d)) pinion();
}

// --- Strip over the carrier's channel (it keeps the carrier in), a slot for its post ---
module strip() {
   difference() {
      box([cw_l[0], cw_r[1]], strip_y, [end_z[0][0], end_z[1][1]]);
      box([cx[0] - 0.4, cx[1] + 0.4], [strip_y[0] - 1, strip_y[1] + 1], [z_mid - travel / 2 - post_h / 2 - 0.5, z_mid + travel / 2 + post_h / 2 + 0.5]);
      for (e = end_z) translate([ind_x, strip_y[0] - 1, (e[0] + e[1]) / 2]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = strip_t + 2);
   }
}

// --- Indicator carrier: the pointer on its front, the post on its back (the yoke's screw) ---
module carrier() {
   difference() {
      union() {
         box(cx, cy, [-car.y / 2, car.y / 2]);
         box([ind_x - tab[0] / 2, ind_x + tab[0] / 2], [0.4, cy[0] + 0.01], [-tab[1] / 2, tab[1] / 2]);
         box(cx, [cy[1] - 0.01, yk_y[0]], [-post_h / 2, post_h / 2]);
      }
      translate([ind_x, yk_y[0] + 0.01, 0]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 10);
   }
}
module carrier_in_place(d = view_deg) {
   translate([0, 0, lever_z(d)]) carrier();
}

// --- Yoke: screwed onto the carrier's post (countersunk), the pin's slot along x ---
module yoke() {
   difference() {
      box(yk_x, yk_y, [-yk_h / 2, yk_h / 2]);
      hull() for (x = [yk_slot[0] + pin_d / 2, yk_slot[1] - pin_d / 2])
         translate([x, yk_y[0] - 1, 0]) rotate([-90, 0, 0]) cylinder(d = pin_d + 0.3, h = yoke_t + 2);
      translate([ind_x, yk_y[0] - 1, 0]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = yoke_t + 2);
      translate([ind_x, yk_y[1] + 0.01, 0]) rotate([90, 0, 0]) cylinder(d1 = 6.2, d2 = clear_d - 0.01, h = 1.5);
   }
}
module yoke_in_place(d = view_deg) {
   translate([0, 0, lever_z(d)]) yoke();
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
// in place: in the y plane, pointing right turned up by a
module arm_in_place(d = view_deg) {
   translate([x_s, arm_y[1], z_mid]) rotate([90, 0, 0]) rotate(arm_a(d)) arm();
}

// --- View-only parts ---
c_body = "#4a4a4a";
c_face = "#2e2e2e";
c_label = "#f4f4f4";
c_print = "#d8d8d8";
c_steel = "#b9c0c8";
c_mech = "#3a3a3a";            // the lever, printed black (seen through the slot)

module servo_part() {
   color("#1f5fbf") {
      box([x_s - sv_body[1] / 2, x_s + sv_body[1] / 2], [sv_ty, sv_ty + sv_body[2]], sv_z);
      box([x_s - sv_body[1] / 2, x_s + sv_body[1] / 2], [sv_ty + sv_tab[2], sv_ty + sv_tab[2] + sv_tab[1]], [sv_bc - sv_tab[0] / 2, sv_bc + sv_tab[0] / 2]);
      translate([x_s, sv_ty, z_mid]) rotate([90, 0, 0]) cylinder(d = sv_boss[0], h = sv_boss[1]);
   }
}
module pin_part(d = view_deg) {
   color(c_steel) translate([x_s, 0, z_mid]) rotate([0, -arm_a(d), 0]) translate([arm_r, 0, 0]) {
      translate([0, yk_y[0] - 1, 0]) rotate([-90, 0, 0]) cylinder(d = pin_d, h = arm_y[1] - yk_y[0] + 1);
      translate([0, arm_y[1], 0]) rotate([-90, 0, 0]) cylinder(d = pin_head[0], h = pin_head[1]);
   }
}
module pot_part() {
   color("#2a2a2a") translate([pot_face, pin_c[0], pin_c[1]]) rotate([0, -90, 0]) cylinder(d = pot_body[0], h = pot_body[1]);
   color(c_steel) {
      translate([pot_face - 0.01, pin_c[0], pin_c[1]]) rotate([0, 90, 0]) cylinder(d = pot_bush[0], h = pot_bush[1]);
      translate([lw[1], pin_c[0], pin_c[1]]) rotate([0, 90, 0]) cylinder(d = pot_nut[0], h = pot_nut[1], $fn = 6);
      translate([pot_face, pin_c[0], pin_c[1]]) rotate([0, 90, 0]) cylinder(d = pot_shaft[0], h = pot_shaft[2]);
   }
}
module rod_part(d = view_deg) {
   color(c_steel) translate([rod_x[0], y_p, z_p]) rotate([0, 90, 0]) cylinder(d = rod_d, h = rod_x[1] - rod_x[0]);
   x1 = lever_x(d) + hub_x[1];
   color(c_steel) translate([x1, y_p, z_p]) rotate([0, 90, 0])
      difference() { cylinder(d = lev_spring[0], h = rw[0] - x1); translate([0, 0, -1]) cylinder(d = lev_spring[0] - 1.6, h = rw[0] - x1 + 2); }
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

module lever_parts(d = view_deg) {
   color(c_mech) at_lever(d) lever();
   color("#f0f0f0") at_lever(d) paddle();
   color(c_print) pinion_in_place(d);
   rod_part(d);
   pot_part();
}
module indicator_parts(d = view_deg) {
   color("#eeeeee") carrier_in_place(d);
   color(c_print) yoke_in_place(d);
   color(c_print) arm_in_place(d);
   pin_part(d);
   servo_part();
}

module assembled(d = view_deg, sheet = true) {
   color(c_body) body();
   color(c_face) face_in_place();
   color(c_label) labels_in_place();
   lever_parts(d);
   color(c_print) strip();
   indicator_parts(d);
   nano_view();
   bolts_part();
   if (sheet) sheet_part();
}

module exploded_view(e = explode) {
   color(c_body) body();
   color(c_face) translate([0, -e, 0]) face_in_place();
   color(c_label) translate([0, -e, 0]) labels_in_place();
   color("#f0f0f0") translate([0, -2 * e, 0]) at_lever(0) paddle();
   color(c_mech) translate([0, 0, e]) at_lever(0) lever();
   translate([e, 0, e]) rod_part(0);
   color(c_print) translate([e, 0, 0]) pinion_in_place(0);
   translate([-e, 0, 0]) pot_part();
   color("#eeeeee") translate([0, 0, 1.5 * e + travel]) carrier_in_place(0);
   color(c_print) translate([0, 1.5 * e, 0]) strip();
   color(c_print) translate([0, 2 * e, 0]) yoke_in_place(0);
   translate([0, 2.5 * e, 0]) { color(c_print) arm_in_place(0); pin_part(0); }
   translate([0, 3 * e, 0]) servo_part();
   translate([-e, e, 0]) nano_view();
}

// from the right, the right wall cut away: the lever at 0 and 40, the sector and the pinion
module side_view() {
   color(c_body) difference() { body(); box([rw[0] - 1, side + 1], [-1, body.y + 1], [-1, body.z + 1]); }
   color(c_face) face_in_place();
   for (d = [0, 40]) {
      color(d == 0 ? c_mech : "#6a6a6a") at_lever(d) lever();
      color("#f0f0f0") at_lever(d) paddle();
   }
   color(c_print) pinion_in_place(0);
   pot_part();
}

// Print places
translate([0, 0, -y_pl]) rotate([90, 0, 0]) body(); // Make module body
face(); // Make module face
translate([0, 0, stem / 2]) rotate([0, -90, 0]) translate([0, -y_p, -z_p]) lever(); // Make module lever
translate([0, 0, paddle.z / 2 - z_p]) paddle(); // Make module paddle
pinion(); // Make module pinion
translate([0, 0, -cx[0]]) rotate([0, -90, 0]) carrier(); // Make module carrier
translate([0, 0, yk_y[1]]) rotate([-90, 0, 0]) yoke(); // Make module yoke
translate([0, 0, strip_y[1]]) rotate([-90, 0, 0]) strip(); // Make module strip
arm(); // Make module arm

//assembled(); // Make view main 70,0,-35
//assembled(); // Make view front 90,0,0
//assembled(sheet = false); // Make view back 60,0,150
//side_view(); // Make view side 90,0,90
//exploded_view(); // Make view exploded 65,0,150
