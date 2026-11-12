// Primer: push-pull plunger with a twist lock
//
// A small panel of its own, above the left end of the switch panels (the
// ignition side), with its own cut-out in the cockpit sheet (frame/). It
// does not touch the ignition panel. The knob pulls out (stroke), pushes
// back in and, only when it is fully in, turns a quarter turn clockwise
// (seen from the front) to lock, like the real one.
//
// Mechanism, the same idea as the throttle quadrant (throttle/):
// - The knob's stem slides in a tube on the back of the panel (the front
//   bearing). A lug on the stem's end runs in a keyway along the tube, so
//   the knob cannot turn while it is out and always comes back in lined
//   up. At the back of the tube the keyway opens into a quarter turn
//   pocket: fully in, the lug turns into it and the keyway's end holds it
//   (locked). Pulled out, the lug stops on the back of the panel plate.
// - A 6 mm rod is screwed into the knob (M3 set screw) and runs back
//   through a bracket: its front wall (screwed onto the end of the tube) and
//   rear wall are the other two bearings.
// - In the bracket the 75 mm linear pot left over from the carb heat sits
//   on stands, held down by two straps, its slider ear pointing at the rod.
//   A carrier on the rod has a slot over the ear; two rod collars (the
//   throttle's plain clamp) hold it on the rod. The rod turns in the carrier
//   (twist lock), the carrier itself is guided between the bracket's ribs.
// - The pot goes to the switch panel's mux board: 5 V, GND, and the
//   wiper on the Cat5 cable's spare AUX wire (hub port 3, Mega A3).
//
// Coordinates: z is the rod axis, z=0 is the back of the panel plate, +z
// points backwards. x is to the pilot's left, y up (seen from the front,
// positive rotation is clockwise). The panel is printed front side down,
// its face front side up (panel.inc.scad), the bracket on its spine, the
// knob on the end of its stem, the carrier on its end.
//
// Parts to buy:
// - 75 mm linear pot (small_pot_*, the carb heat one), 6 mm rod (rod_len)
// - M3 screws: 4x M3x12 bracket onto the tube, 4x M3x10 pot straps, 1x
//   M3x6 knob set screw, 4x M3x10 + nuts to mount the panel
// - 2x throttle/clamp.scad "plain" (clamp_plain.stl) as rod collars
//
// Assembly: panel and face through the sheet, screw the flange on. From
// behind: knob stem into the tube (lug in the keyway), bracket onto the
// tube (hex key through the holes in the rear wall), pot onto its stands
// with the straps. Push the rod in from the back, through the rear
// wall, a collar, the carrier (slot over the pot ear), a collar, the front
// wall and into the knob; tighten the set screw. With the knob pulled
// out, set the carrier so the ear is stroke / 2 before the pot's middle and
// tighten the collars against it.

$fn = 60;

include <panel.inc.scad>

// Preview: knob pushed in by this much (0 = out, stroke = in), locked
view_in = 0;
view_locked = false;
explode = 25;

// --- Linear pot, MEASURE (the carb heat pot, throttle/throttle_box.scad) ---
small_pot_stand_distance = 60;
small_pot_stand_thickness = 5;
small_pot_stand_height = 7;
small_pot_full_width = 10;
small_pot_module_height = 6;
small_pot_full_length = 75;
pot_travel = 60;             // slider ear travel, measured
pot_ear = [1, 5, 16];        // slider ear: thickness, length along the pot, height above the pot
pot_leg0 = 6;                // first stand from the pot's front end (as in the throttle box)

// --- Rod and collars ---
rod_d = 6;
rod_hole = 6.2;              // bearings
rod_loose = 6.6;             // in the carrier, the rod turns in it
collar_w = 8;                // throttle/clamp.scad clamp(8)
collar_sweep = 9.5;          // its screw lug, from the rod axis

// --- Knob and twist lock ---
stroke = 40;                 // pull out, at most pot_travel
lock_turn = 90;              // clockwise to lock
key_angle = 90;              // keyway direction (up)
knob_d = 22;
knob_len = 14;
knob_ribs = 18;
knob_collar_d = 14;          // the head's back, stops on the face
stem_d = 10;
stem_play = 0.2;             // radial, in the tube and the panel
lug_w = 3;
lug_h = 2;                   // beyond the stem
lug_len = 5;
set_screw_pilot = 2.8;       // M3 set screw into the knob

// --- Tube and bracket ---
wall = 4;                    // bracket walls
spine_t = 3;
rib_t = 2.5;
tube_half = 11;              // square tube on the panel back
tube_screw = 7.5;            // bracket screws, x and y from the axis
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;
screw_head = [5.5, 3];       // M3 socket head
key_hole = 6;                // hex key through the rear wall
strap_t = 3;
strap_nub = 1.2;             // presses the pot down
strap_len = 7;

// --- Calculated ---
pot_w = small_pot_full_width;
pot_h = small_pot_module_height;
pot_l = small_pot_full_length;
stand_h = small_pot_stand_height;
post_y = [pot_w / 2, pot_w / 2 + 5];          // stand posts, |y|
post_len = 20;
post_h = 2 * stand_h;
pot_legs = [pot_leg0, pot_leg0 + small_pot_stand_distance + 2];

stem_r = stem_d / 2;
bore = stem_d + 2 * stem_play;
key_r = stem_r + lug_h + 0.3;
function arc_deg(len, r) = len / r * 180 / PI;
lug_arc = arc_deg(lug_w + 0.4, key_r);
tube_len = stroke + lug_len + 0.5;
stem_len = panel_t + stroke + lug_len;

// The panel's back: the tube, inside the rim
back_w = 2 * (tube_half + rim_w);
back_x0 = -back_w / 2;
back_y0 = -back_w / 2;
face_w = back_w + 2 * flange_w;
mount_holes = panel_corner_holes(back_x0, -back_x0, back_y0, h = back_w);
title = "PRIMER";
title_y = knob_d / 2 + 2;

// Bracket, in the -x half (towards the pilot's right): the pot on its
// spine, slider ear up to ear_top, just under the rod
ear_top = -(rod_loose / 2 + 2.8);
spine_x = -(stand_h + pot_h + pot_ear.z - ear_top);    // spine inside
pot_top = spine_x + stand_h + pot_h;
br_h = 2 * (post_y[1] + 0.5 + rib_t);
carrier_l = 10;
carrier_w = br_h - 2 * rib_t - 0.6;
carrier_x = [-16, rod_loose / 2 + 2];
strap_top = spine_x + post_h + strap_t;
z_front = tube_len;                         // bracket front wall
// carrier front at view_in = 0: behind the bracket screw heads and the
// collar, and the pot stand behind the front wall
z_carrier = max(z_front + wall + screw_head[1] + 1 + collar_w,
                z_front + wall + (post_len / 2 - pot_legs[0]) + pot_l / 2 - carrier_l / 2 - stroke / 2);
pot_z0 = z_carrier + carrier_l / 2 + stroke / 2 - pot_l / 2;   // ear in the middle at stroke / 2
z_rear = max(z_carrier + carrier_l + collar_w + stroke + 1,    // rear collar, knob in
             pot_z0 + pot_legs[1] + post_len / 2,
             pot_z0 + pot_l + 5);                              // solder tabs and wires
z_end = z_rear + wall;
rod_z0 = -panel_t - stroke - knob_len + 2;                     // rod front, knob out
rod_len = ceil(z_end + 2 - rod_z0);

echo(primer_back = back_w, primer_face = face_w, bracket_len = z_end - z_front,
     behind_panel = z_end + stroke + 2, rod_len = rod_len);

// --- Checks ---
assert(stroke <= pot_travel - 4, "Stroke longer than the pot travel");
assert(key_r + 2.5 <= tube_half, "Tube wall around the keyway too thin");
assert(norm([tube_screw, tube_screw]) - pilot_d / 2 >= key_r + 1.2,
       "Bracket screws run into the lock pocket");
assert(tube_half - tube_screw - pilot_d / 2 >= 1.5, "Bracket screws too close to the tube edge");
assert(knob_collar_d / 2 >= bore / 2 + 1.5, "Knob does not stop on the face");
assert(ear_top + 0.5 <= -rod_loose / 2 - 1.5, "Carrier too thin over the pot ear");
assert(collar_sweep + 0.5 <= br_h / 2 - rib_t, "Rod collars hit the bracket ribs");
assert(carrier_x[0] >= strap_top + 1, "Carrier runs into the pot straps");
assert(carrier_x[0] <= pot_top + pot_ear.z - 8, "Carrier slot holds too little of the pot ear");
// ear in its travel and clear of the straps over the end caps
assert(abs(pot_z0 + pot_l / 2 - (z_carrier + carrier_l / 2 + stroke / 2)) < 0.01);
assert(pot_z0 + pot_legs[0] + strap_len / 2 + 1 <= z_carrier + carrier_l / 2 - pot_ear.y / 2,
       "Pot ear runs into the front strap");
assert(pot_z0 + pot_legs[1] - strap_len / 2 - 1 >= z_carrier + carrier_l / 2 + stroke + pot_ear.y / 2,
       "Pot ear runs into the rear strap");
assert(norm([tube_screw, tube_screw]) - key_hole / 2 >= rod_hole / 2 + 2, "Key holes too close to the rod hole");
assert(title_y + label_size <= back_w / 2 + flange_w - 1, "Title runs off the face");

// --- Helpers ---
module sector(r_in, r_out, a0, a1, h) {
   rotate([0, 0, a0])
      rotate_extrude(angle = a1 - a0, $fn = 120)
         translate([r_in, 0])
            square([r_out - r_in, h]);
}

module tube_screw_holes(d, z0, h) {
   for (x = [-1, 1], y = [-1, 1])
      translate([x * tube_screw, y * tube_screw, z0])
         cylinder(d = d, h = h);
}

// Lug profile around the axis at angle a
module lug_2d(a, w, r_out) {
   rotate(a)
      translate([0, -w / 2])
         square([r_out, w]);
}

// --- Parts ---

// Panel with the tube on its back, front at z=-panel_t + face_t (the face
// is in front of it)
module panel() {
   difference() {
      union() {
         translate([0, 0, -panel_t])
            panel_blank(back_x0, -back_x0, back_y0, mount_holes, h = back_w);
         translate([-tube_half, -tube_half, -0.01])
            cube([2 * tube_half, 2 * tube_half, tube_len + 0.01]);
      }
      // Stem
      translate([0, 0, -panel_t - 1])
         cylinder(d = bore, h = panel_t + tube_len + 2);
      // Keyway, from the plate (the pull out stop) to the back
      translate([0, 0, 0])
         linear_extrude(tube_len + 1)
            lug_2d(key_angle, lug_w + 0.4, key_r);
      // Lock pocket: a quarter turn at the back, the lug turns in when fully in
      translate([0, 0, stroke - 0.3])
         sector(0, key_r, key_angle - lug_arc / 2, key_angle + lock_turn + lug_arc / 2, tube_len);
      // Bracket screws
      tube_screw_holes(pilot_d, tube_len - 12, 13);
      // Room for the face
      translate([0, 0, -panel_t - 1])
         linear_extrude(face_t + 1)
            offset(delta = 1)
               panel_face_2d(back_x0, -back_x0, back_y0, h = back_w);
      // Version on the back of the flange
      translate([-back_x0 + flange_w / 2, 0, -gitrev_depth])
         linear_extrude(gitrev_depth + 1)
            rotate([0, 0, 90])
               text("{{gitrev}}", size = 3, halign = "center", valign = "center");
   }
}

module labels_2d() {
   translate([0, title_y])
      mirror([1, 0])
         text(title, size = label_size, font = font, halign = "center");
}

// Front face from z=-panel_t to the panel, the label standing out of it
module face() {
   translate([0, 0, -panel_t - label_raise])
      linear_extrude(label_raise + 0.01)
         labels_2d();
   translate([0, 0, -panel_t])
      linear_extrude(face_t)
         difference() {
            panel_face_2d(back_x0, -back_x0, back_y0, h = back_w);
            circle(d = bore);
            for (h = mount_holes)
               translate(h)
                  circle(d = mount_d);
         }
}

// Knob, the back of its head at z=0, the stem to +z, the lug at angle 0
// (turned into place by the caller)
module knob() {
   difference() {
      union() {
         // Head: a ribbed round knob, its back a 45 degree cone (prints
         // without supports, stem down) down to the collar that stops on the face
         rotate_extrude($fn = 90)
            polygon([[0, 0], [knob_collar_d / 2, 0], [knob_d / 2, -(knob_d - knob_collar_d) / 2],
                     [knob_d / 2, -knob_len + 2], [knob_d / 2 - 2, -knob_len], [0, -knob_len]]);
         cylinder(d = stem_d, h = stem_len);
         translate([0, 0, stem_len - lug_len])
            linear_extrude(lug_len)
               lug_2d(0, lug_w, stem_r + lug_h);
      }
      for (i = [0 : knob_ribs - 1])
         rotate([0, 0, i * 360 / knob_ribs])
            translate([knob_d / 2 + 0.3, 0, -knob_len - 1])
               cylinder(d = 2.2, h = knob_len - (knob_d - knob_collar_d) / 2 + 1, $fn = 16);
      // Rod, up to 2 mm before the front
      translate([0, 0, -knob_len + 2])
         cylinder(d = rod_hole, h = knob_len + stem_len);
      // Set screw, from the side of the head
      translate([0, 0, -knob_len / 2])
         rotate([0, 90, 0])
            cylinder(d = set_screw_pilot, h = knob_d);
   }
}

// Knob in place, pushed in by u, turned by t
module knob_in_place(u, t) {
   translate([0, 0, -panel_t - (stroke - u)])
      rotate([0, 0, key_angle + t])
         knob();
}

module stand(z) {
   translate([spine_x - 0.01, 0, z]) {
      // under the pot
      translate([0, -(pot_w + 3) / 2, -small_pot_stand_thickness / 2])
         cube([stand_h + 0.01, pot_w + 3, small_pot_stand_thickness]);
      // posts beside it, the strap screws into them
      for (s = [-1, 1])
         difference() {
            translate([0, s > 0 ? post_y[0] : -post_y[1], -post_len / 2])
               cube([post_h + 0.01, post_y[1] - post_y[0], post_len]);
            translate([post_h - 12, s * (post_y[0] + post_y[1]) / 2, 0])
               rotate([0, 90, 0])
                  cylinder(d = pilot_d, h = 13);
         }
   }
}

// Bracket: front wall (onto the tube), spine with the pot stands, ribs
// along its edges that guide the carrier, rear wall
module bracket() {
   x0 = spine_x - spine_t;
   difference() {
      union() {
         // front wall, over the tube
         translate([x0, -br_h / 2, z_front])
            cube([tube_half - x0, br_h, wall]);
         // spine
         translate([x0, -br_h / 2, z_front])
            cube([spine_t, br_h, z_end - z_front]);
         // ribs
         for (s = [-1, 1])
            translate([x0, s > 0 ? br_h / 2 - rib_t : -br_h / 2, z_front])
               cube([-x0, rib_t, z_end - z_front]);
         // rear wall
         translate([x0, -br_h / 2, z_rear])
            cube([tube_half - x0, br_h, wall]);
         for (l = pot_legs)
            stand(pot_z0 + l);
      }
      // rod
      for (z = [z_front, z_rear])
         translate([0, 0, z - 1])
            cylinder(d = rod_hole, h = wall + 2);
      tube_screw_holes(clear_d, z_front - 1, wall + 2);
      tube_screw_holes(key_hole, z_rear - 1, wall + 2);
      // version on the spine's outside
      translate([x0 - 1 + gitrev_depth, 0, (z_front + z_end) / 2])
         rotate([0, -90, 0])
            rotate([0, 0, 90])
               linear_extrude(gitrev_depth + 1)
                  text("{{gitrev}}", size = 3, halign = "center", valign = "center");
   }
}

// Strap over the pot's end cap, screwed onto the two posts of a stand
module strap() {
   difference() {
      union() {
         translate([0, -post_y[1], -strap_len / 2])
            cube([strap_t, 2 * post_y[1], strap_len]);
         translate([-strap_nub, -(pot_w - 1) / 2, -strap_len / 2])
            cube([strap_nub + 0.01, pot_w - 1, strap_len]);
      }
      for (s = [-1, 1])
         translate([-1, s * (post_y[0] + post_y[1]) / 2, 0])
            rotate([0, 90, 0])
               cylinder(d = clear_d, h = strap_t + 2);
   }
}

module strap_in_place(i) {
   translate([spine_x + post_h, 0, pot_z0 + pot_legs[i]])
      strap();
}

// Carrier on the rod, its front at z=0: guided between the ribs, the slot
// over the pot ear
module carrier() {
   difference() {
      translate([carrier_x[0], -carrier_w / 2, 0])
         cube([carrier_x[1] - carrier_x[0], carrier_w, carrier_l]);
      translate([0, 0, -1])
         cylinder(d = rod_loose, h = carrier_l + 2);
      translate([carrier_x[0] - 1, -0.8, (carrier_l - pot_ear.y) / 2 - 0.15])
         cube([ear_top + 0.5 - carrier_x[0] + 1, 1.6, pot_ear.y + 0.3]);
   }
}

// --- Views (rendered to PNG by "make views") ---

c_tube = "#3d7bd9";
c_bracket = "#3d7bd9";
c_carrier = "#f5a030";
c_clamp = "#e8433a";
c_knob = "#1d1f22";
c_pot = "#2a2b2e";
c_steel = "#b9c0c8";
c_gold = "#d9b24a";

function ear_z(u) = z_carrier + carrier_l / 2 + u;

module pot_part(u) {
   translate([spine_x + stand_h, 0, pot_z0]) {
      color(c_pot)
         difference() {
            translate([0, -pot_w / 2, 0]) cube([pot_h, pot_w, pot_l]);
            translate([pot_h - 0.6, -0.75, 8]) cube([1, 1.5, pot_l - 16]);
         }
      color(c_gold)
         for (dy = [-pot_w / 4, 0, pot_w / 4])
            translate([1, dy - 0.5, pot_l - 1]) cube([0.4, 1, 4]);
   }
   color(c_steel)
      translate([pot_top + pot_ear.z / 2, 0, ear_z(u)])
         cube([pot_ear.z, pot_ear.x, pot_ear.y], center = true);
}

// throttle/clamp.scad clamp(8), the rod along z from z
module collar_part(z) {
   color(c_clamp)
      translate([0, 0, z])
         difference() {
            union() {
               cylinder(h = collar_w, d = 9);
               translate([0, -3, 0]) cube([9, 6, collar_w]);
            }
            translate([0, 0, -1]) cylinder(h = collar_w + 2, d = rod_hole);
            translate([1, -1, -1]) cube([collar_w + 2, 2, collar_w + 2]);
         }
}

module rod_parts(u, t) {
   color(c_steel)
      translate([0, 0, rod_z0 + u])
         cylinder(d = rod_d, h = rod_len);
   translate([0, 0, z_carrier + u]) color(c_carrier) carrier();
   rotate([0, 0, 90 + t]) {
      collar_part(z_carrier + u - collar_w - 0.2);
      collar_part(z_carrier + u + carrier_l + 0.2);
   }
}

module panel_part() {
   color(c_tube) panel();
   color(c_panel) face();
   color(c_label)
      translate([0, 0, -panel_t - label_raise - 0.01])
         linear_extrude(0.02)
            labels_2d();
}

module bracket_parts() {
   color(c_bracket) bracket();
   color(c_carrier) for (i = [0, 1]) strap_in_place(i);
}

// Everything in place, knob pushed in by u, locked or not
module assembled_view(u = 0, locked = false) {
   t = locked ? lock_turn : 0;
   panel_part();
   color(c_knob) knob_in_place(u, t);
   bracket_parts();
   pot_part(u);
   rod_parts(u, t);
}

// Cut along the rod: the keyway, the lug in the lock pocket, the carrier on the ear
module cut() {
   render()
      intersection() {
         children();
         translate([-100, -100, -100]) cube([200, 100, 400]);
      }
}

module section_view(u = stroke, locked = true) {
   t = locked ? lock_turn : 0;
   color(c_tube) cut() panel();
   color(c_panel) cut() face();
   color(c_knob) cut() knob_in_place(u, t);
   color(c_bracket) cut() bracket();
   color(c_carrier) cut() for (i = [0, 1]) strap_in_place(i);
   color(c_carrier) cut() translate([0, 0, z_carrier + u]) carrier();
   pot_part(u);
   color(c_steel) translate([0, 0, rod_z0 + u]) cylinder(d = rod_d, h = rod_len);
}

module exploded_view(e = explode) {
   color(c_panel) translate([0, 0, -2 * e]) face();
   color(c_tube) panel();
   color(c_knob) translate([0, 0, e]) knob_in_place(stroke, 0);
   translate([0, 0, 2 * e]) {
      color(c_bracket) bracket();
      translate([0, 0, 0]) pot_part(0);
      for (i = [0, 1]) translate([e, 0, 0]) color(c_carrier) strap_in_place(i);
      translate([0, 0, e]) rod_parts(0, 0);
   }
}

// As mounted in the frame: x to the pilot's right, y backwards, z up
module installed() {
   multmatrix([[-1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0]])
      children();
}

translate([0, 0, -explode]) panel(); // Make module panel
translate([0, 0, -2 * explode]) rotate([0, 180, 0]) face(); // Make module face
translate([0, 0, stem_len]) rotate([180, 0, 0]) knob(); // Make module knob
translate([0, 0, -spine_x + spine_t]) rotate([0, -90, 0]) bracket(); // Make module bracket
translate([0, 0, strap_t]) rotate([0, 90, 0]) strap(); // Make module strap
carrier(); // Make module carrier

//assembled_view(u = view_in, locked = view_locked); // Ignore module

//installed() exploded_view(); // Make view main 62,0,-125
//installed() assembled_view(u = 0); // Make view out 62,0,-125
//installed() assembled_view(u = stroke, locked = true); // Make view in 62,0,-125
//installed() section_view(u = stroke, locked = true); // Make view section 0,0,0
//installed() assembled_view(u = stroke, locked = true); // Make view front 90,0,0
