// Ignition key switch: OFF - R - L - BOTH - START
//
// The key turns clockwise (seen from the front of the panel). OFF, R, L and
// BOTH are detents, START is spring loaded and returns to BOTH on release.
//
// Built around a cheap mailbox / cabinet cam lock. It turns only 90
// degrees: a small tab on the plug just behind the face stops in the
// housing grooves. Take off the cam and its washer, pull the plug (key in,
// the detent ball is not needed) and file the tab flush; this assembly
// provides its own end stops for the whole OFF..START sweep and the rotor
// holds the plug in. The key can be pulled every 90 degrees, one of these
// has to be OFF (see lock_key_home), so it also comes out at BOTH.
//
// Mechanisms (inside the housing, closed by the cover):
// - Detents: a steel ball pushed by a spring (radial channel in the
//   housing) onto notches in the rotor rim. START has no notch.
// - End stops: a lug on the rotor rim moving in a pocket in the housing.
// - START return: an M3 screw through the cover is a pin in an arc slot in
//   the rotor. From OFF to BOTH it moves freely in the narrow part of the
//   slot. Past BOTH it pushes a printed shoe that compresses a spring in the
//   wide part, and the spring pushes the key back to BOTH.
// - Sensing: one magnet in the rotor lug, one unipolar (NOT latching)
//   digital hall sensor per position in the cover, e.g. A3144. The output is
//   open collector and pulls low over the magnet, so it wires to a MobiFlight
//   input like a switch to GND (needs 5V and GND too). Check which magnet
//   face triggers the sensor before gluing the magnet in.
//
// Coordinates: z is the key axis, z=0 is the back of the panel, +z points
// backwards. Positive rotation is clockwise seen from the front. All parts
// are modeled in their print orientation (front side down), except the
// face, which is printed front side up (see below).
//
// Parts to buy:
// - mailbox lock (file off its stop tab, see above), its M4 cam screw
// - 6 mm steel ball + spring (detent_spring_*)
// - spring for the START return (start_spring_*)
// - 5x5x5 mm cube magnet (magnet_*), 5x A3144 hall sensors (OFF is optional)
// - M3 screws: 4x for the cover, 4x panel to housing, 1x M3x8 as the
//   START pin, 4x to mount the panel
//
// The panel is printed as well. It has the same height, rim, mount holes and
// lettering as the switch panel (panel.inc.scad) and mounts to its left.
// Its front is a separate thin face (face_t) with the position labels
// standing out of it (label_raise), to be painted with a white paint pen.
// The face is printed front side up and the panel front side down, so
// neither needs supports. Together they are panel_t thick, like the switch
// panel. The face is clamped by the mount screws and the lock flange (glue
// or double sided tape it on as well if it bows).
//
// Assembly: lock through the panel and the housing, tighten its nut, mount
// the rotor with the lock's cam screw, insert ball + spring and shoe +
// spring, glue in magnet and sensors, screw on the cover, then the pin.

$fn = 60;

include <panel.inc.scad>

// Preview: shown key position (0=OFF .. 4=START), cover lift
view_pos = 3;
explode = 25;

// --- Panel (height, thickness, rim, mount holes, font: panel.inc.scad) ---
label_r = 20;                // position labels around the key
tick_r = 12;                 // tick marks, from here outwards
tick_len = 3;
tick_w = 0.6;
title = "MAGNETOS";          // above the position labels, "" for none
title_gap = 2;
panel_screw_head_d = 5.5;    // M3 socket head, the face has holes around them

// --- Mailbox lock (measured) ---
lock_thread_d = 18;          // threaded body diameter
lock_flat_w = 16;            // body width across the two flats
lock_body_len = 17;          // flange underside to the cam seat
lock_flange_d = 22;          // preview only
lock_nut_d = 25;             // nut across corners
lock_nut_t = 4;
lock_spindle_d = 9.9;        // cam spindle, round diameter (square: across corners)
lock_spindle_flat = 7;       // cam spindle, width across flats
lock_spindle_square = true;  // true: 4 flats, false: double-D
lock_spindle_len = 2;        // spindle length that drives the cam
lock_spindle_angle = 0;      // spindle flats vs. body flats at home (OFF)
lock_key_home = 90;          // key vs. body flats where it comes out (every 90 degrees: 0 or 90)
key_off_angle = 30;          // where the key points at OFF (home), from +x; the lock body is turned to match
lock_screw_d = 4;            // cam screw, M4
lock_screw_hole = 5;         // its hole in the rotor, loose: the spindle centres the rotor
lock_screw_len = 5;          // thread length
lock_screw_head_d = 12;
lock_screw_head_h = 2;
rotor_clamp_t = 2.5;         // rotor between spindle end and screw head, the rest of the screw goes into the spindle

// --- Positions (VERIFY against the real switch) ---
pitch = 30;                  // OFF->R, R->L, L->BOTH
start_pitch = 30;            // BOTH->START
position_names = ["OFF", "R", "L", "BOTH", "START"];
function pos_angle(i) = i < 4 ? i * pitch : 3 * pitch + start_pitch;
sweep = pos_angle(4);

// --- Housing ---
front_t = 3;                 // clamped between panel and lock nut
wall = 3;
corner_r = 5;
pilot_d = 2.8;               // M3 self tapping into plastic
clear_d = 3.3;               // M3 clearance
gap = 0.5;                   // axial gap rotor <-> cover

// --- Rotor ---
rotor_r = 20;
rotor_t = 8;
lug_r = 25;
lug_w = 18;                  // degrees
stop_slack = 1;              // degrees of room at OFF, the detent decides OFF
lug_angle = 180 - sweep / 2; // stop pocket centered opposite the detent

// --- Detent (channel along +x) ---
ball_d = 6;
notch_depth = 1.5;
detent_spring_len = 10;      // free length, OD must be < ball_d
detent_spring_preload = 2;

// --- START return ---
start_pin_angle = 90;
start_pin_r = 14;
start_pin_d = 3;             // M3 screw
start_pin_len = 8;           // screw length
start_spring_od = 5;
start_spring_len = 15;       // free length
start_spring_solid = 5.5;    // fully compressed length
start_spring_preload = 1.5;
start_shoe_len = 3;
start_slot_depth = 5;

// --- Sensing ---
magnet_w = 5;                // cube magnet, side
magnet_h = 5;                // height (along the key axis)
magnet_r = rotor_r + 1;
sensor_w = 4.0;              // A3144 TO-92S body
sensor_h = 3.0;
sensor_t = 1.5;
cover_t = 3;

// --- Derived ---
function arc_deg(len, r) = len / r * 180 / PI;

z_cam = lock_body_len - panel_t;
// The flats of the lock body (cutouts in panel, face and housing) are
// turned so the key points at OFF where it comes out
body_angle = key_off_angle - lock_key_home - 90;
screw_seat = lock_spindle_len + rotor_clamp_t;  // head underside, in the rotor
z_back = z_cam + rotor_t + gap;
bore_r = rotor_r + 0.4;

ball_ch = ball_d + 0.3;
ball_ch_z = z_cam + (rotor_t - ball_ch) / 2;
notch_c = rotor_r + ball_d / 2 - notch_depth;
detent_end = notch_c + ball_d / 2 + detent_spring_len - detent_spring_preload;

half = max(lug_r + 0.5, detent_end) + wall;
screw_xy = half - corner_r;

slot_narrow_w = start_pin_d + 0.6;
slot_wide_w = start_spring_od + 0.6;
shoe_w = slot_wide_w - 0.4;
start_spring_inst = start_spring_len - start_spring_preload;
start_travel = start_pitch * PI / 180 * start_pin_r;
// Slot angles are in the rotor frame, the pin moves to lower angles
slot_step = start_pin_angle - pos_angle(3) - arc_deg(start_pin_d / 2, start_pin_r);
slot_narrow_end = start_pin_angle + arc_deg(start_pin_d / 2 + 0.5, start_pin_r) + 3;
slot_wide_end = slot_step - arc_deg(start_shoe_len + start_spring_inst, start_pin_r);
pin_protrusion = start_pin_len - cover_t - gap;

// Panel back, centered on the key, as wide as the housing needs inside
// the rim. Its pilot's right side (-x) meets the switch panel; the flange
// is on the other three sides.
panel_w = 2 * (half + rim_w + 0.5);
face_w = panel_w + flange_w;
mount_holes = panel_corner_holes(-panel_w / 2, panel_w / 2, -panel_h / 2, round0 = false);
function label_pos(i) = label_r * [cos(key_off_angle + pos_angle(i)), sin(key_off_angle + pos_angle(i))];
title_y = max([for (i = [0 : 4]) label_pos(i).y]) + label_size / 2 + title_gap;

echo(panel_size = [panel_w, panel_h], face_size = [face_w, face_h]);

// --- Sanity checks ---
assert(z_cam >= front_t + lock_nut_t + 1, "Lock body too short for panel + front plate + nut");
assert(bore_r > lock_nut_d / 2 + 1, "Lock nut does not fit in the bore");
assert(rotor_clamp_t - 0.2 >= 1.5, "Too little material under the cam screw head");
assert(lock_screw_hole > lock_screw_d && lock_screw_hole <= lock_screw_head_d - 4, "Cam screw hole does not fit under its head");
assert(screw_seat + lock_screw_head_h <= rotor_t, "Cam screw head sticks out of the rotor");
assert(lock_screw_len - rotor_clamp_t >= 2, "Cam screw too short to reach into the spindle");
assert(lug_angle - lug_w / 2 > arc_deg(ball_d, rotor_r)
       && lug_angle + lug_w / 2 < 360 - sweep - arc_deg(ball_d, rotor_r),
       "Rotor lug runs into the detent notches");
assert(lug_angle - lug_w / 2 - stop_slack > arc_deg(ball_ch / 2 + 1, bore_r)
       && lug_angle + lug_w / 2 + sweep < 360 - arc_deg(ball_ch / 2 + 1, bore_r),
       "Stop pocket runs into the detent channel");
assert(start_spring_inst - start_travel >= start_spring_solid, "START spring goes solid before START");
assert(shoe_w >= slot_narrow_w + 1, "Shoe can slip into the narrow part of the slot");
assert(start_pin_r + slot_wide_w / 2 + 1 <= rotor_r - notch_depth, "START slot runs into the detent notches");
assert(start_pin_r - slot_wide_w / 2 - 1 >= lock_screw_head_d / 2 + 0.3, "START slot runs into the cam screw head");
assert(rotor_t - start_slot_depth >= 1.2, "START slot floor too thin");
assert(pin_protrusion >= 1.5 && pin_protrusion <= start_slot_depth - 0.3, "START pin screw length does not fit the slot");
// The lug sides start at the rotor rim, so the pocket must be inside them from there out
assert(atan((magnet_w / 2 + 0.1 + 0.5) / rotor_r) <= lug_w / 2, "Magnet does not fit in the lug");
assert(magnet_r + magnet_w / 2 + 0.1 + 1 <= lug_r, "Magnet pocket breaks through the lug rim");
assert(rotor_t - magnet_h - 0.2 >= 1.2, "Magnet pocket floor too thin");
assert(magnet_r * min(pitch, start_pitch) * PI / 180 >= sensor_w + 4, "Hall sensors too close to each other");
assert(half + 0.5 <= panel_h / 2 - rim_w, "Housing does not fit between the panel rims, make panel_h higher");
assert(title == "" || title_y + group_label_size <= panel_h / 2 - 3, "Title too close to the top edge");
assert(tick_r >= lock_flange_d / 2 + 0.5 && tick_r + tick_len <= label_r - label_size, "Ticks run into the lock or the labels");

// --- Helpers ---
module sector(r_in, r_out, a0, a1, h) {
   rotate([0, 0, a0])
      rotate_extrude(angle = a1 - a0, $fn = 180)
         translate([r_in, 0])
            square([r_out - r_in, h]);
}

module outline() {
   offset(r = corner_r)
      square(2 * (half - corner_r), center = true);
}

module lock_body_profile(clearance) {
   rotate(body_angle) intersection() {
      circle(d = lock_thread_d + 2 * clearance);
      square([lock_flat_w + 2 * clearance, lock_thread_d + 2], center = true);
   }
}

module spindle_profile(clearance) {
   intersection() {
      circle(d = lock_spindle_d + 2 * clearance);
      if (lock_spindle_square)
         square(lock_spindle_flat + 2 * clearance, center = true);
      else
         square([lock_spindle_flat + 2 * clearance, lock_spindle_d + 2], center = true);
   }
}

module corner_holes(d, h) {
   for (x = [-1, 1], y = [-1, 1])
      translate([x * screw_xy, y * screw_xy, -1])
         cylinder(d = d, h = h + 2);
}

// --- Parts ---
module housing() {
   difference() {
      linear_extrude(z_back)
         outline();
      // Lock body through the front plate
      translate([0, 0, -1])
         linear_extrude(front_t + 2)
            lock_body_profile(0.2);
      // Room for the lock nut and the rotor
      translate([0, 0, front_t])
         cylinder(r = bore_r, h = z_back, $fn = 120);
      // Stop pocket for the rotor lug, its ends are the OFF and START stops
      translate([0, 0, z_cam - 0.5])
         sector(0, lug_r + 0.5, lug_angle - lug_w / 2 - stop_slack, lug_angle + lug_w / 2 + sweep, z_back);
      // Detent ball + spring channel, open to the back
      translate([0, -ball_ch / 2, ball_ch_z])
         cube([detent_end, ball_ch, z_back]);
      corner_holes(pilot_d, z_back);
   }
}

module rotor() {
   difference() {
      union() {
         cylinder(r = rotor_r, h = rotor_t, $fn = 120);
         sector(rotor_r - 1, lug_r, lug_angle - lug_w / 2, lug_angle + lug_w / 2, rotor_t);
      }
      // Lock spindle
      translate([0, 0, -1])
         rotate([0, 0, body_angle + lock_spindle_angle])
            linear_extrude(lock_spindle_len + 1.2)
               spindle_profile(0.1);
      // Cam screw and its head
      translate([0, 0, -1])
         cylinder(d = lock_screw_hole, h = rotor_t + 2);
      translate([0, 0, screw_seat])
         cylinder(d = lock_screw_head_d + 0.6, h = rotor_t);
      // Detent notches for OFF, R, L, BOTH (the ball is at world angle 0)
      for (i = [0 : 3])
         rotate([0, 0, -pos_angle(i)])
            translate([notch_c, 0, -1])
               cylinder(d = ball_d + 0.2, h = rotor_t + 2);
      // START return slot: narrow part for the pin, wide part for shoe + spring
      translate([0, 0, rotor_t - start_slot_depth]) {
         sector(start_pin_r - slot_narrow_w / 2, start_pin_r + slot_narrow_w / 2, slot_step - 1, slot_narrow_end, rotor_t);
         sector(start_pin_r - slot_wide_w / 2, start_pin_r + slot_wide_w / 2, slot_wide_end, slot_step, rotor_t);
      }
      // Magnet
      rotate([0, 0, lug_angle])
         translate([magnet_r - magnet_w / 2 - 0.1, -magnet_w / 2 - 0.1, rotor_t - magnet_h - 0.2])
            cube([magnet_w + 0.2, magnet_w + 0.2, rotor_t]);
   }
}

module shoe() {
   sector(start_pin_r - shoe_w / 2, start_pin_r + shoe_w / 2, -arc_deg(start_shoe_len, start_pin_r), 0, start_slot_depth - 0.5);
}

// Shoe in the rotor slot with the key at angle theta
module shoe_in_place(theta) {
   face = min(slot_step, start_pin_angle - theta - arc_deg(start_pin_d / 2, start_pin_r));
   translate([0, 0, z_cam + rotor_t - start_slot_depth])
      rotate([0, 0, face + theta])
         shoe();
}

module cover() {
   translate([0, 0, z_back])
      difference() {
         linear_extrude(cover_t)
            outline();
         corner_holes(clear_d, cover_t);
         // START pin, M3 screw self tapping into the cover
         rotate([0, 0, start_pin_angle])
            translate([start_pin_r, 0, -1])
               cylinder(d = pilot_d, h = cover_t + 2);
         for (i = [0 : 4])
            rotate([0, 0, lug_angle + pos_angle(i)]) {
               // Hall sensor, flat face towards the magnet
               translate([magnet_r - sensor_h / 2 - 0.1, -sensor_w / 2 - 0.15, -1])
                  cube([sensor_h + 0.2, sensor_w + 0.3, sensor_t + 1.1]);
               // Leads bent backwards through the cover
               translate([magnet_r + sensor_h / 2 - 0.1, -sensor_w / 2 - 0.15, -1])
                  cube([1.2, sensor_w + 0.3, cover_t + 2]);
               // Position label on the back
               translate([magnet_r + 7, 0, cover_t - 0.4])
                  rotate([0, 0, -lug_angle - pos_angle(i)])
                     linear_extrude(1)
                        text(position_names[i], size = 3, halign = "center", valign = "center");
            }
         translate([half / 2, -half + 6, cover_t - 0.4])
            linear_extrude(1)
               text("{{gitrev}}", size = 3, halign = "center", valign = "center");
      }
}

// Position labels and ticks, mirrored so they read from the front
module labels_2d() {
   for (i = [0 : 4]) {
      translate(label_pos(i))
         mirror([1, 0])
            text(position_names[i], size = label_size, font = font, halign = "center", valign = "center");
      rotate(key_off_angle + pos_angle(i))
         translate([tick_r, -tick_w / 2])
            square([tick_len, tick_w]);
   }
   if (title != "")
      translate([0, title_y])
         mirror([1, 0])
            text(title, size = group_label_size, font = font, halign = "center");
}

// Front at z=-panel_t + face_t (the face is in front of it), the housing
// on its back at z=0
module panel() {
   difference() {
      // Square corners on the right (-x), where the switch panel is
      translate([0, 0, -panel_t])
         panel_blank(-panel_w / 2, panel_w / 2, -panel_h / 2, mount_holes, round0 = false);
      // Lock body, its flats keep the lock and the housing from turning
      translate([0, 0, -panel_t - 1])
         linear_extrude(panel_t + 2)
            lock_body_profile(0.2);
      translate([0, 0, -panel_t])
         corner_holes(clear_d, panel_t);
      // Room for the face
      translate([0, 0, -panel_t - 1])
         linear_extrude(face_t + 1)
            offset(delta = 1)
               panel_face_2d(-panel_w / 2, panel_w / 2, -panel_h / 2, round0 = false);
      // Version on the back of the flange
      translate([panel_w / 2 + flange_w / 2, 0, -gitrev_depth])
         linear_extrude(gitrev_depth + 1)
            rotate([0, 0, 90])
               text("{{gitrev}}", size = 3, halign = "center", valign = "center");
   }
}

// Front face from z=-panel_t to the panel, with the labels standing out in
// front of it
module face() {
   translate([0, 0, -panel_t - label_raise])
      linear_extrude(label_raise + 0.01)
         labels_2d();
   translate([0, 0, -panel_t])
      linear_extrude(face_t)
         difference() {
            panel_face_2d(-panel_w / 2, panel_w / 2, -panel_h / 2, round0 = false);
            lock_body_profile(0.2);
            for (h = mount_holes)
               translate(h)
                  circle(d = mount_d);
            for (x = [-1, 1], y = [-1, 1])
               translate([x * screw_xy, y * screw_xy])
                  circle(d = panel_screw_head_d + 0.7);
         }
}

// --- Views (rendered to PNG by "make views") ---

// Display only
lock_flange_t = 2;
spring_wire = 0.6;

c_housing = "#3d7bd9";
c_rotor = "#f5a030";
c_shoe = "#e8433a";
c_cover = "#eceff2";
c_steel = "#b9c0c8";
c_chrome = "#e2e6ea";
c_brass = "#d9b24a";
c_key = "#26282b";
c_sensor = "#1d1f22";
c_spring = "#9aa3ad";
c_line = "#8fd0ff";

function in_detent(theta) = theta <= pos_angle(3) + 0.01 && abs(theta / pitch - round(theta / pitch)) < 0.01;
function shoe_face(theta) = min(slot_step, start_pin_angle - theta - arc_deg(start_pin_d / 2, start_pin_r));

// Straight coil spring along +z
module coil(od, len, turns) {
   linear_extrude(height = len, twist = 360 * turns, slices = ceil(turns * 24), convexity = 10)
      translate([(od - spring_wire) / 2, 0])
         circle(d = spring_wire, $fn = 10);
}

// Coil spring bent along an arc around the z axis
module arc_coil(r, a0, a1, od, turns) {
   n = ceil(turns * 14);
   rc = (od - spring_wire) / 2;
   for (i = [0 : n - 1])
      hull()
         for (j = [i, i + 1]) {
            a = a0 + (a1 - a0) * j / n;
            ph = 360 * turns * j / n;
            translate([(r + rc * cos(ph)) * cos(a), (r + rc * cos(ph)) * sin(a), rc * sin(ph)])
               sphere(d = spring_wire, $fn = 8);
         }
}

// Socket head screw, head on top at z=0, shank pointing down
module screw(d, len, head_d, head_h) {
   color(c_steel) {
      difference() {
         cylinder(d = head_d, h = head_h);
         translate([0, 0, head_h * 0.4])
            cylinder(d = head_d * 0.45, h = head_h, $fn = 6);
      }
      translate([0, 0, -len])
         cylinder(d = d, h = len);
   }
}

module m3_screw(len) {
   screw(3, len, 5.5, 3);
}

module dashed_line(from_z, to_z, d = 0.5) {
   color(c_line, 0.6)
      for (z = [from_z : 6 : to_z - 3])
         translate([0, 0, z])
            cylinder(d = d, h = 3, $fn = 8);
}

module lock_part(theta) {
   key_dir = key_off_angle + theta;
   translate([0, 0, -panel_t - lock_flange_t])
      difference() {
         union() {
            color(c_chrome)
               cylinder(d = lock_flange_d, h = lock_flange_t);
            color(c_brass)
               translate([0, 0, -0.01])
                  cylinder(d = lock_flange_d * 0.55, h = 0.3);
         }
         // Keyway
         rotate([0, 0, key_dir])
            translate([-lock_flange_d * 0.2, -0.7, -1])
               cube([lock_flange_d * 0.4, 1.4, 3]);
      }
   color(c_chrome)
      translate([0, 0, -panel_t])
         linear_extrude(lock_body_len)
            lock_body_profile(0);
   color(c_steel)
      translate([0, 0, z_cam])
         rotate([0, 0, theta + body_angle + lock_spindle_angle])
            linear_extrude(lock_spindle_len)
               spindle_profile(0);
}

module key_part(theta) {
   z0 = -panel_t - lock_flange_t - 0.5;
   rotate([0, 0, key_off_angle + theta]) {
      // Bow
      color(c_key)
         translate([0, 0, z0])
            rotate([90, 0, 0])
               linear_extrude(3, center = true)
                  difference() {
                     translate([0, -14])
                        offset(r = 4)
                           square([14, 20], center = true);
                     translate([0, -19])
                        circle(d = 5);
                  }
      // Blade
      color(c_chrome)
         translate([-3.5, -1, z0])
            cube([7, 2, lock_body_len]);
   }
}

module nut_part() {
   color(c_chrome)
      translate([0, 0, front_t])
         difference() {
            cylinder(d = lock_nut_d, h = lock_nut_t, $fn = 6);
            translate([0, 0, -1])
               cylinder(d = lock_thread_d, h = lock_nut_t + 2);
         }
}

// Panel and face
module panel_part() {
   color(c_panel)
      panel();
   face_part();
}

// Face with the raised labels painted
module face_part() {
   color(c_panel)
      face();
   color(c_label)
      translate([0, 0, -panel_t - label_raise - 0.01])
         linear_extrude(0.02)
            labels_2d();
}

module mount_screws() {
   for (h = mount_holes)
      translate([h.x, h.y, -panel_t])
         mount_screw(panel_t + 7, c_steel);  // face, sheet, nut
}

module panel_screws() {
   for (x = [-1, 1], y = [-1, 1])
      translate([x * screw_xy, y * screw_xy, -panel_t + face_t])
         rotate([180, 0, 0])
            m3_screw(10);
}

module detent_parts(theta) {
   ball_x = in_detent(theta) ? notch_c : rotor_r + ball_d / 2;
   translate([0, 0, z_cam + rotor_t / 2]) {
      color(c_chrome)
         translate([ball_x, 0, 0])
            sphere(d = ball_d, $fn = 40);
      color(c_spring)
         translate([ball_x + ball_d / 2, 0, 0])
            rotate([0, 90, 0])
               coil(detent_spring_od(), detent_end - ball_x - ball_d / 2, 6);
   }
}
function detent_spring_od() = ball_d - 1;

module start_parts(theta) {
   face = shoe_face(theta);
   color(c_shoe)
      shoe_in_place(theta);
   color(c_spring)
      translate([0, 0, z_cam + rotor_t - start_slot_depth / 2])
         rotate([0, 0, theta])
            arc_coil(start_pin_r, slot_wide_end, face - arc_deg(start_shoe_len, start_pin_r), start_spring_od, 8);
}

module magnet_part(theta) {
   rotate([0, 0, lug_angle + theta])
      translate([magnet_r - magnet_w / 2, -magnet_w / 2, z_cam + rotor_t - magnet_h - 0.2]) {
         color("#d64541")
            cube([magnet_w, magnet_w, magnet_h / 2]);
         color("#3f6fd6")
            translate([0, 0, magnet_h / 2])
               cube([magnet_w, magnet_w, magnet_h / 2]);
      }
}

module cam_screw_part() {
   translate([0, 0, z_cam + screw_seat])
      screw(lock_screw_d, lock_screw_len, lock_screw_head_d, lock_screw_head_h);
}

module sensor_parts() {
   for (i = [0 : 4])
      rotate([0, 0, lug_angle + pos_angle(i)]) {
         color(c_sensor)
            translate([magnet_r - sensor_h / 2, -sensor_w / 2, z_back])
               cube([sensor_h, sensor_w, sensor_t]);
         color(c_chrome)
            for (y = [-1.27, 0, 1.27])
               translate([magnet_r + sensor_h / 2 + 0.5, y, z_back + sensor_t / 2])
                  cylinder(d = 0.45, h = cover_t + 8, $fn = 8);
      }
}

// Cover with the engraved labels filled in
module cover_part(alpha = 1) {
   color(c_cover, alpha)
      cover();
   color(c_shoe, alpha)
      translate([0, 0, z_back + cover_t - 0.39])
         linear_extrude(0.38)
            for (i = [0 : 4])
               rotate([0, 0, lug_angle + pos_angle(i)])
                  translate([magnet_r + 7, 0])
                     rotate([0, 0, -lug_angle - pos_angle(i)])
                        text(position_names[i], size = 3, halign = "center", valign = "center");
}

module cover_screws() {
   for (x = [-1, 1], y = [-1, 1])
      translate([x * screw_xy, y * screw_xy, z_back + cover_t])
         m3_screw(10);
   rotate([0, 0, start_pin_angle])
      translate([start_pin_r, 0, z_back + cover_t])
         m3_screw(start_pin_len);
}

// Everything in place, explode lifts the cover off
module bought_parts(theta, explode = 0) {
   key_part(theta);
   lock_part(theta);
   nut_part();
   detent_parts(theta);
   start_parts(theta);
   magnet_part(theta);
   cam_screw_part();
   translate([0, 0, explode]) {
      sensor_parts();
      cover_screws();
   }
}

module exploded_view(pos = 0, e = 16) {
   theta = pos_angle(pos);
   // Assembly lines
   dashed_line(-4.2 * e, 6 * e);
   for (x = [-1, 1], y = [-1, 1])
      translate([x * screw_xy, y * screw_xy, 0])
         dashed_line(-2.4 * e, 5.6 * e, 0.35);

   translate([0, 0, -4.2 * e]) key_part(theta);
   translate([0, 0, -3 * e]) lock_part(theta);
   for (h = mount_holes)
      translate([h.x, h.y, 0])
         dashed_line(-2 * e, 0, 0.35);
   translate([0, 0, -2 * e]) panel_screws();
   translate([0, 0, -2 * e]) mount_screws();
   translate([0, 0, -1.6 * e]) face_part();
   translate([0, 0, -1.2 * e]) color(c_panel) panel();
   color(c_housing) housing();
   translate([0, 0, 1 * e]) nut_part();
   translate([0, 0, 1 * e]) detent_parts(theta);
   translate([0, 0, 2 * e + z_cam]) rotate([0, 0, theta]) color(c_rotor) rotor();
   translate([0, 0, 2.8 * e]) start_parts(theta);
   translate([0, 0, 2.8 * e]) magnet_part(theta);
   translate([0, 0, 3.3 * e]) cam_screw_part();
   translate([0, 0, 3.9 * e]) sensor_parts();
   translate([0, 0, 4.6 * e]) cover_part();
   translate([0, 0, 5.6 * e]) cover_screws();
}

module assembled_view(pos = 3) {
   theta = pos_angle(pos);
   panel_part();
   panel_screws();
   mount_screws();
   color(c_housing) housing();
   translate([0, 0, z_cam]) rotate([0, 0, theta]) color(c_rotor) rotor();
   bought_parts(theta);
   cover_part(0.35);
}

// Back view without the cover, to see the mechanism work
module inside_view(pos = 0) {
   theta = pos_angle(pos);
   color(c_housing) housing();
   translate([0, 0, z_cam]) rotate([0, 0, theta]) color(c_rotor) rotor();
   detent_parts(theta);
   start_parts(theta);
   magnet_part(theta);
   cam_screw_part();
   // START pin, the cover would hold it
   color(c_steel)
      rotate([0, 0, start_pin_angle])
         translate([start_pin_r, 0, z_back - pin_protrusion])
            cylinder(d = start_pin_d, h = pin_protrusion + 2);
   color(c_sensor, 0.5)
      sensor_parts();
}

// The pilot's view
module front_view(pos = 0) {
   theta = pos_angle(pos);
   panel_part();
   panel_screws();
   mount_screws();
   key_part(theta);
   lock_part(theta);
   color(c_housing) housing();
}

housing(); // Make module housing
translate([0, 0, -explode]) panel(); // Make module panel
translate([0, 0, -2 * explode]) rotate([0, 180, 0]) face(); // Make module face
translate([0, 0, z_cam]) rotate([0, 0, pos_angle(view_pos)]) rotor(); // Make module rotor
shoe_in_place(pos_angle(view_pos)); // Make module shoe
translate([0, 0, explode]) cover(); // Make module cover

//bought_parts(pos_angle(view_pos), explode); // Ignore module

//exploded_view(pos = 0); // Make view main 62,0,32
//assembled_view(pos = 3); // Make view assembled 50,0,35
//inside_view(pos = 0); // Make view inside_off 0,0,0
//inside_view(pos = 4); // Make view inside_start 0,0,0
//front_view(pos = 3); // Make view front 160,0,180
