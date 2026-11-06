// Ignition key switch: OFF - R - L - BOTH - START
//
// The key turns clockwise (seen from the front of the panel). OFF, R, L and
// BOTH are detents, START is spring loaded and returns to BOTH on release.
//
// Built around a cheap mailbox / cabinet cam lock. Its cam AND stop washer
// are removed: these locks usually turn only 90 degrees, so this assembly
// provides its own end stops for the whole OFF..START sweep. The key can
// only be pulled at the lock's home position, which has to be OFF (see
// lock_spindle_angle).
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
//   open collector and pulls low over the magnet, so it wires to a SimVim
//   input like a switch to GND (needs 5V and GND too). Check which magnet
//   face triggers the sensor before gluing the magnet in.
//
// Coordinates: z is the key axis, z=0 is the back of the panel, +z points
// backwards. Positive rotation is clockwise seen from the front. All parts
// are modeled in their print orientation (front side down).
//
// Parts to buy:
// - mailbox lock (MEASURE it and update the lock_* parameters)
// - 6 mm steel ball + spring (detent_spring_*)
// - spring for the START return (start_spring_*)
// - magnet (magnet_*), 5x A3144 hall sensors (OFF is optional)
// - M3 screws: 4x for the cover, 1x M3x8 as the START pin, panel mounting
//
// Assembly: lock through the panel and the housing, tighten its nut, mount
// the rotor with the lock's cam screw, insert ball + spring and shoe +
// spring, glue in magnet and sensors, screw on the cover, then the pin.

$fn = 60;

// Preview: shown key position (0=OFF .. 4=START), cover lift
view_pos = 3;
explode = 25;

// --- Panel ---
panel_t = 3;

// --- Mailbox lock (MEASURE: guesses until the lock arrives) ---
lock_thread_d = 18;          // threaded body diameter
lock_flat_w = 16;            // body width across the two flats
lock_body_len = 16;          // flange underside to the cam seat
lock_flange_d = 22;          // preview only
lock_nut_d = 25;             // nut across corners
lock_nut_t = 3;
lock_spindle_d = 7;          // cam spindle, round diameter
lock_spindle_flat = 5;       // cam spindle, width across flats
lock_spindle_square = false; // true: 4 flats, false: double-D
lock_spindle_len = 2.5;      // spindle length that drives the cam
lock_spindle_angle = 0;      // spindle flats vs. body flats at home (OFF)
lock_screw_d = 4;            // cam screw
lock_screw_head_d = 8;
lock_screw_head_h = 3;

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
magnet_d = 5;
magnet_h = 2;
magnet_r = rotor_r + 1;
sensor_w = 4.0;              // A3144 TO-92S body
sensor_h = 3.0;
sensor_t = 1.5;
cover_t = 3;

// --- Derived ---
function arc_deg(len, r) = len / r * 180 / PI;

z_cam = lock_body_len - panel_t;
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

// --- Sanity checks ---
assert(z_cam >= front_t + lock_nut_t + 1, "Lock body too short for panel + front plate + nut");
assert(bore_r > lock_nut_d / 2 + 1, "Lock nut does not fit in the bore");
assert(rotor_t - lock_spindle_len - lock_screw_head_h >= 1.5, "Too little material under the cam screw head");
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
assert(arc_deg(magnet_d / 2 + 0.5, magnet_r) <= lug_w / 2, "Magnet does not fit in the lug");
assert(magnet_r * min(pitch, start_pitch) * PI / 180 >= sensor_w + 4, "Hall sensors too close to each other");

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
   intersection() {
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
         rotate([0, 0, lock_spindle_angle])
            linear_extrude(lock_spindle_len + 1.2)
               spindle_profile(0.1);
      // Cam screw and its head
      translate([0, 0, -1])
         cylinder(d = lock_screw_d + 0.4, h = rotor_t + 2);
      translate([0, 0, rotor_t - lock_screw_head_h - 0.2])
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
         translate([magnet_r, 0, rotor_t - magnet_h - 0.2])
            cylinder(d = magnet_d + 0.2, h = rotor_t);
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

// Bought parts, for checking the fit in the preview
module reference_parts(theta) {
   // Panel and lock
   translate([0, 0, -panel_t])
      difference() {
         translate([-half, -half, 0])
            cube([2 * half, 2 * half, panel_t]);
         translate([0, 0, -1])
            linear_extrude(panel_t + 2)
               lock_body_profile(0.2);
      }
   translate([0, 0, -panel_t - 2])
      cylinder(d = lock_flange_d, h = 2);
   translate([0, 0, -panel_t])
      linear_extrude(lock_body_len)
         lock_body_profile(0);
   translate([0, 0, front_t])
      cylinder(d = lock_nut_d, h = lock_nut_t, $fn = 6);
   // Detent ball
   in_detent = theta <= pos_angle(3) + 0.01 && abs(theta / pitch - round(theta / pitch)) < 0.01;
   translate([in_detent ? notch_c : rotor_r + ball_d / 2, 0, z_cam + rotor_t / 2])
      sphere(d = ball_d);
   // Magnet
   rotate([0, 0, lug_angle + theta])
      translate([magnet_r, 0, z_cam + rotor_t - magnet_h - 0.2])
         cylinder(d = magnet_d, h = magnet_h);
   translate([0, 0, explode]) {
      // Hall sensors
      for (i = [0 : 4])
         rotate([0, 0, lug_angle + pos_angle(i)])
            translate([magnet_r - sensor_h / 2, -sensor_w / 2, z_back])
               cube([sensor_h, sensor_w, sensor_t]);
      // START pin
      rotate([0, 0, start_pin_angle])
         translate([start_pin_r, 0, z_back + cover_t - start_pin_len])
            cylinder(d = start_pin_d, h = start_pin_len);
   }
}

housing(); // Make module housing
translate([0, 0, z_cam]) rotate([0, 0, pos_angle(view_pos)]) rotor(); // Make module rotor
shoe_in_place(pos_angle(view_pos)); // Make module shoe
translate([0, 0, explode]) cover(); // Make module cover

//#reference_parts(pos_angle(view_pos)); // Ignore module
