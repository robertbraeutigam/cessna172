// Trim wheel and its servo driven indicator
//
// The elevator trim wheel and its indicator on the pedestal under the
// throttle (frame/, the apron's pedestal). Remodelled from the STLs of
// "Trim Wheel" by FlightSimMaker (Thingiverse thing 4290141, CC BY-NC-SA;
// see the README), the sizes measured off its meshes; every part prints as
// the original's, in the same orientation.
//
// - The face plate (75 x 150, 5 thick) closes the front of the case. The
//   wheel stands up through a slot in it, its axis 17 mm behind the
//   plate's back (y_ax), so about a third of it shows in front, between
//   the two halves of a hood (a cylinder segment, hood_r, round the
//   wheel's axis, a little in front of it: hood_ax). Left of the wheel the
//   indicator's window (win_*), a raised rim on both sides of it (rim_*),
//   and NOSE DOWN / NOSE UP standing out of the face for a paint pen.
// - The wheel (24 balls on a round rim) sits on the spacer's stub (glued),
//   the spacer turns in a bushing in the encoder bracket and is pushed onto
//   the rotary encoder's shaft (bore 6 mm): the wheel turns the encoder
//   directly. The bracket's base lies in a pocket in the face plate's back
//   (glued), the encoder is held by its nut in the bracket's front plate.
// - The smoother, a disc with grooves, rubs on the wheel's right face, on
//   its axis; its keel is glued into the slot's back chamfer, so the wheel
//   runs steady and with a little friction.
// - The indicator: a 60 mm arm on a 9 g servo (SG90) swings in the plane
//   of the window, its tip moving along the window. The servo hangs in
//   the servo bracket (screwed on its ears, sv_hole_d pilots), which
//   stands on the face plate's back in an L pocket (glued).
// - The case: a box with 2 mm walls, open at the front, four bosses in its
//   front corners with holes for heat set inserts (boss_hole_d); the face
//   plate's screws go through counterbored holes. The cables go out
//   through a hole in the top (cable_d).
// - The wiring and the board that reads the encoder and drives the servo
//   are not part of this design.
//
// Coordinates of the parts: their print orientation, the original STLs'.
// The views put them together in installed coordinates: x right, y back
// (y = 0 the face plate's back), z up, the face plate's lower left corner
// at the origin.

$fn = 64;

// --- Face plate ---
face_w = 75;
face_h = 150;
face_t = 5;
screw_in = 6;                // screw holes from the edges
screw_d = 5.1;
screw_head_d = 9.5;          // counterbore in the front
screw_head_h = 1.5;
slot_x = [53, 65];           // the wheel's slot
slot_z = [7.5, 142.5];
slot_chamfer = 3;            // 45 degrees round the slot on the back
hood_r = 44.5;               // the hood: a cylinder round the x axis
hood_ax = 14.5;              // its axis behind the plate's back
hood_x = [[33, 53], [65, 75]];   // left and right halves, beside the slot
hood_round = 5;              // their outer edges
hood_fillet = 3;             // the left half's foot
win_x = [12, 17];            // indicator window
win_z = [75, 125];
rim_w = 2;                   // the rim beside the window, both sides
rim_r = 80.2;                // its top, an arc round the x axis
rim_ax = 71.2;               // behind the plate's back, at the window's middle
pocket = [26.8, 62.4, 25.2, 25.2, 3.5];   // the bracket's base [x, z, w, h, depth]
sb_pocket = [[22, 94, 4.2, 15.2], [26.2, 106, 6, 3.2]];   // the servo bracket's L [x, z, w, h]
sb_pocket_d = 2;
font = "Liberation Sans:style=Bold";
label_size = 3.6;            // 3.5 mm capitals
label_stretch = 0.9;         // narrower, like the original's
label_h = 1.5;               // standing out of the face
label_x = 39.7;
labels = [["NOSE", 133.53], ["DOWN", 126.83], ["NOSE", 19.62], ["UP", 12.92]];   // baselines

// --- Case ---
case_d = 87;                 // depth, outside
wall = 2;
case_round = 2;              // outside edges (not the front's)
case_in_round = 3;
boss = 10;                   // square, in each front corner
boss_set = 3;                // behind the case's front edge (as the original)
boss_len = 9;
boss_taper = 10;             // the gusset behind it
boss_hole_d = 4.5;           // heat set insert
boss_hole_l = 12;
cable_d = 10;                // in the top
cable_y = 15;                // from the back

// --- Wheel ---
wheel_r = 57.5;              // the disc
wheel_t = 5;
rim_tube_r = 3.5;            // the round rim
rim_tube_at = 60;
ball_d = 10;
ball_at = 62;
balls = 24;
hub_d = 8.2;                 // the spacer's stub
wheel_d = 2 * (ball_at + ball_d / 2);

// --- Spacer, bushing ---
sp_stub = [8, 5];            // [d, length]: into the wheel
sp_flange = [20, 3];
sp_step = [12, 1];
sp_shaft = [8, 14];          // through the bushing
sp_bore = [6, 7];            // the encoder's shaft
bush_d = 22;
bush_t = 7;
bush_bore = 8.2;
bush_chamfer = 0.5;

// --- Encoder bracket ---
br_w = 25;                   // the base, square
br_base_t = 3;               // in the face plate's pocket (3.5 deep)
br_ax = [20.5, 13.5];        // the axis over the base's bottom [y, z]
br_plate_t = 3;              // the encoder's plate
br_upright_x = 16;           // the bearing's upright
br_upright_t = 9;
br_upright_r = 13.5;
br_bore = [22.3, 7];         // the bushing
br_lip_d = 18;
br_tongue_w = 15;            // the encoder plate round the encoder
br_fillet = 6.5;            // base to the uprights
br_plate_fillet = 5;         // the tongue to the base's strip
br_rib = [11, 2, 1];         // under the shaft: [height, width, its fillets]
enc_hole_d = 7.2;            // M7 bushing, MEASURE
enc_tab_d = 2.5;             // its anti-rotation tab, MEASURE
enc_tab_at = 6;              // over the axis
enc_tab_h = 1.5;             // blind, from the encoder's side
// Bracket_large: for an encoder with a longer bushing
brl_plate_t = 5;
brl_overhang = 4;            // the plate in front of the base
brl_upright_x = 20;

// --- Servo bracket, arm, smoother ---
sb = [15, 60, 10];           // [x, y (from the face plate), z]
sb_plate_t = 4;
sb_wall_t = 3;
sb_cut = [12, 32, 23];       // the servo's hole [w, from, length]
sv_hole_d = 1.5;             // pilots for the servo's ear screws
sv_holes = [29.5, 57.5];
arm_len = 60;
arm_t = 4;
arm_r = [4, 1];              // pivot and tip
arm_tip_y = 3.1;
arm_hole_d = 2.7;
arm_head_d = 4.8;
arm_head_h = 1;
sm_d = 60;
sm_t = 3;
sm_grooves = [11.23, 18.73, 26.23];
sm_groove_r = 1.3;
sm_keel = [7, 47, 22.28, 24.81];   // [thickness, top, the V's sharp tip, its rounded bottom] (z, the disc's middle at sm_d / 2)

// --- Bought parts, view only, MEASURE ---
sg90 = [22.5, 12.2, 22.7];   // body [length, width, height]
sg90_ear = [32.5, 2.5, 4.3]; // [length, thickness, ear top to body top]
sg90_shaft = 5.35;           // from the body's middle
ec11 = [12, 6.5];            // body [square, depth]
enc_bush_l = 7;
enc_shaft_l = 18;            // from the mounting face, MEASURE

// --- Installed places ---
wheel_x = (slot_x[0] + slot_x[1]) / 2;
y_ax = br_ax[0] - pocket[4];     // the wheel's axis behind the plate's back
z_ax = pocket[1] + pocket[3] / 2;
br_x = pocket[0] + (pocket[2] - br_w) / 2;
sv_y = 41.5;                 // the servo's middle, behind the plate (the ear holes)
sv_x = sb_pocket[0][0] + sb_plate_t - sg90_ear[2];   // its body's top: the ears behind the bracket's plate
arm_x = 12.5;                // on the horn, in the window

wheel_l = wheel_x - wheel_t / 2;     // the wheel's left face
sp_end = wheel_l + sp_stub[1] - (sp_stub[1] + sp_flange[1] + sp_step[1] + sp_shaft[1]);
enc_end = br_x + enc_shaft_l;
assert(enc_end <= sp_end + sp_bore[1] && enc_end >= sp_end + sp_bore[1] - 3, "Encoder shaft does not fit the spacer's bore");
assert(z_ax == face_h / 2, "Wheel not in the middle");
assert(arm_x >= win_x[0] && arm_x + arm_t <= win_x[1], "Arm not in the window");
assert(arm_x + arm_t <= sv_x - 4, "Arm on the servo's shaft, not its body");
assert(sv_y - sg90.x / 2 >= sb_cut[1] - sb_pocket_d && sv_y + sg90.x / 2 <= sb_cut[1] + sb_cut[2] - sb_pocket_d, "Servo not in its hole");
assert(wheel_l - sp_flange[1] - sp_step[1] > br_x + br_w, "Spacer rubs on the bracket");
assert(2 * sqrt((wheel_d / 2) ^ 2 - (y_ax + face_t) ^ 2) < slot_z[1] - slot_z[0], "Wheel too big for its slot");

// ---------------------------------------------------------------- face

module hood_half(x0, x1, round_left) {
   len = x1 - x0;
   translate([x0, face_h / 2, -hood_ax]) rotate([0, 90, 0]) rotate_extrude($fn = 128)
      hull() {
         square([0.01, len]);
         // rotate([0, 90, 0]) turns z into x and r into -z
         if (round_left) {
            translate([hood_r - hood_round, hood_round]) circle(hood_round);
            translate([hood_r - 0.01, len - 0.01]) square(0.01);
         } else {
            translate([hood_r - hood_round, len - hood_round]) circle(hood_round);
            translate([hood_r - 0.01, 0]) square(0.01);
         }
      }
}

module hood() {
   intersection() {
      union() {
         hood_half(hood_x[0][0], hood_x[0][1], true);
         hood_half(hood_x[1][0], hood_x[1][1], false);
      }
      translate([0, 0, 0]) cube([face_w, face_h, hood_r]);
   }
   // the left half's foot
   intersection() {
      difference() {
         translate([hood_x[0][0] - hood_fillet, 0, face_t]) cube([hood_fillet, face_h, hood_fillet]);
         translate([hood_x[0][0] - hood_fillet, 0, face_t + hood_fillet]) rotate([-90, 0, 0]) cylinder(r = hood_fillet, h = face_h);
      }
      translate([0, face_h / 2, -hood_ax]) rotate([0, 90, 0]) cylinder(r = hood_r, h = face_w, $fn = 128);
   }
}

module window_rims() {
   for (x = [win_x[0] - rim_w, win_x[1]])
      intersection() {
         translate([x, 0, 0]) cube([rim_w, face_h, rim_r]);
         translate([0, (win_z[0] + win_z[1]) / 2, -rim_ax]) rotate([0, 90, 0]) cylinder(r = rim_r, h = face_w, $fn = 256);
      }
}

module face_labels() {
   for (l = labels)
      translate([label_x, l[1], face_t]) scale([label_stretch, 1, 1]) linear_extrude(label_h)
         text(l[0], size = label_size, font = font, halign = "center");
}

module face_plate() {
   difference() {
      union() {
         cube([face_w, face_h, face_t]);
         hood();
         window_rims();
         face_labels();
      }
      // wheel slot, chamfered on the back
      translate([slot_x[0], slot_z[0], -1]) cube([slot_x[1] - slot_x[0], slot_z[1] - slot_z[0], 40]);
      hull() {
         translate([slot_x[0], slot_z[0], slot_chamfer]) cube([slot_x[1] - slot_x[0], slot_z[1] - slot_z[0], 0.01]);
         translate([slot_x[0] - slot_chamfer, slot_z[0] - slot_chamfer, -0.01])
            cube([slot_x[1] - slot_x[0] + 2 * slot_chamfer, slot_z[1] - slot_z[0] + 2 * slot_chamfer, 0.01]);
      }
      translate([win_x[0], win_z[0], -1]) cube([win_x[1] - win_x[0], win_z[1] - win_z[0], 20]);
      for (x = [screw_in, face_w - screw_in], z = [screw_in, face_h - screw_in]) {
         translate([x, z, -1]) cylinder(d = screw_d, h = face_t + 2);
         translate([x, z, face_t - screw_head_h]) cylinder(d = screw_head_d, h = face_t);
      }
      translate([pocket[0], pocket[1], -0.01]) cube([pocket[2], pocket[3], pocket[4] + 0.01]);
      for (p = sb_pocket) translate([p[0], p[1], -0.01]) cube([p[2], p[3], sb_pocket_d + 0.01]);
   }
}

// ---------------------------------------------------------------- case

module rounded_box(lo, hi, r) {
   // edges along y round, the back's too, the front (+y) open and square
   hull() for (x = [lo.x + r, hi.x - r], z = [lo.z + r, hi.z - r]) {
      translate([x, lo.y + r, z]) sphere(r);
      translate([x, lo.y + r, z]) rotate([-90, 0, 0]) cylinder(r = r, h = hi.y - lo.y - r);
   }
}

module case() {
   difference() {
      union() {
         difference() {
            rounded_box([0, 0, 0], [face_w, case_d, face_h], case_round);
            rounded_box([wall, wall, wall], [face_w - wall, case_d + 1, face_h - wall], case_in_round);
         }
         for (sx = [0, 1], sz = [0, 1])
            translate([sx * face_w, 0, sz * face_h]) scale([1 - 2 * sx, 1, 1 - 2 * sz])
               hull() {
                  translate([wall, case_d - boss_set - boss_len, wall]) cube([boss, boss_len, boss]);
                  translate([wall, case_d - boss_set - boss_len - boss_taper, wall]) cube([0.01, 0.01, 0.01]);
               }
      }
      for (x = [screw_in, face_w - screw_in], z = [screw_in, face_h - screw_in])
         translate([x, case_d - boss_set - boss_hole_l, z]) rotate([-90, 0, 0]) cylinder(d = boss_hole_d, h = boss_hole_l + 1);
      translate([face_w / 2, cable_y, face_h - wall - 1]) cylinder(d = cable_d, h = wall + 2);
   }
}

// ---------------------------------------------------------------- wheel

module wheel() {
   translate([wheel_d / 2, wheel_d / 2, ball_d / 2]) difference() {
      union() {
         cylinder(r = wheel_r, h = wheel_t, center = true, $fn = 180);
         rotate_extrude($fn = 180) translate([rim_tube_at, 0]) circle(rim_tube_r, $fn = 32);
         for (i = [0 : balls - 1]) rotate(i * 360 / balls) translate([ball_at, 0, 0]) sphere(d = ball_d, $fn = 32);
      }
      cylinder(d = hub_d, h = 2 * ball_d, center = true);
   }
}

// ---------------------------------------------------------------- spacer, bushing

module spacer() {
   translate([sp_flange[0] / 2, 0, sp_flange[0] / 2]) rotate([-90, 0, 0]) difference() {
      union() {
         cylinder(d = sp_stub[0], h = sp_stub[1]);
         translate([0, 0, sp_stub[1]]) cylinder(d = sp_flange[0], h = sp_flange[1]);
         translate([0, 0, sp_stub[1] + sp_flange[1]]) cylinder(d = sp_step[0], h = sp_step[1]);
         translate([0, 0, sp_stub[1] + sp_flange[1] + sp_step[1]]) cylinder(d = sp_shaft[0], h = sp_shaft[1]);
      }
      len = sp_stub[1] + sp_flange[1] + sp_step[1] + sp_shaft[1];
      translate([0, 0, len - sp_bore[1]]) cylinder(d = sp_bore[0], h = sp_bore[1] + 1);
   }
}

module bushing() {
   translate([bush_d / 2, 0, bush_d / 2]) rotate([-90, 0, 0]) difference() {
      union() {
         cylinder(d1 = bush_d - 2 * bush_chamfer, d2 = bush_d, h = bush_chamfer);
         translate([0, 0, bush_chamfer]) cylinder(d = bush_d, h = bush_t - 2 * bush_chamfer);
         translate([0, 0, bush_t - bush_chamfer]) cylinder(d1 = bush_d, d2 = bush_d - 2 * bush_chamfer, h = bush_chamfer);
      }
      translate([0, 0, -1]) cylinder(d = bush_bore, h = bush_t + 2);
   }
}

// ---------------------------------------------------------------- encoder bracket

// The base lies on y = 0 (in the face plate's pocket), x along the axis:
// the encoder's plate at x = 0, the bearing's upright at upright_x.
module bracket(plate_t = br_plate_t, upright_x = br_upright_x, overhang = 0, tab_h = enc_tab_h) {
   ax = br_ax;
   cx0 = upright_x - 2 * br_fillet;  // the round cradle between the fillets
   end = upright_x + br_upright_t;
   z0 = ax[1] - br_w / 2;            // the base's edges
   difference() {
      union() {
         translate([overhang, 0, z0]) cube([end - overhang, br_base_t, br_w]);
         // the encoder's plate: the base's strip and a tongue round the encoder
         difference() {
            rotate([90, 0, 90]) linear_extrude(plate_t) union() {
               translate([0, z0]) square([br_base_t, br_w]);
               hull() {
                  translate([0, ax[1] - br_tongue_w / 2]) square([0.01, br_tongue_w]);
                  translate([ax[0], ax[1]]) circle(d = br_tongue_w);
               }
               for (s = [-1, 1])
                  difference() {
                     translate([0, ax[1] + s * br_tongue_w / 2 - (s < 0 ? br_plate_fillet : 0)]) square([br_base_t + br_plate_fillet, br_plate_fillet]);
                     translate([br_base_t + br_plate_fillet, ax[1] + s * (br_tongue_w / 2 + br_plate_fillet)]) circle(br_plate_fillet);
                  }
            }
            if (overhang > 0)   // the plate's part in front of the base, chamfered under
               translate([0, 0, -1]) linear_extrude(br_w + 10)
                  polygon([[-1, -1], [overhang, -1], [overhang, 8.92 - overhang], [-1, 9.92]]);
         }
         // the bearing's upright
         translate([upright_x, 0, 0]) rotate([90, 0, 90]) linear_extrude(br_upright_t)
            union() {
               translate([0, z0]) square([ax[0], br_w]);
               translate([ax[0], ax[1]]) circle(br_upright_r);
            }
         // fillets: base to upright (full width), base to the encoder's plate (the tongue's width)
         // a wider gap: a block on the plate's side, chamfered on top
         if (cx0 > plate_t)
            translate([0, 0, ax[1] - br_tongue_w / 2]) linear_extrude(br_tongue_w)
               polygon([[plate_t, 0], [cx0, 0], [cx0, br_rib[0]], [plate_t, br_rib[0] + cx0 - plate_t]]);
         for (f = [[upright_x - br_fillet, z0, br_w, 1], [cx0, ax[1] - br_tongue_w / 2, br_tongue_w, 0]])
            translate([f[0], br_base_t, f[1]]) difference() {
               cube([br_fillet, br_fillet, f[2]]);
               translate([f[3] == 1 ? 0 : br_fillet, br_fillet, -1]) cylinder(r = br_fillet, h = f[2] + 2);
            }
         // a rib under the shaft, between the plate and the upright
         translate([plate_t, 0, ax[1]]) rotate([90, 0, 90]) linear_extrude(upright_x - plate_t) {
            // 2D: [y, z - the axis]
            translate([0, -br_rib[1] / 2]) square([br_rib[0], br_rib[1]]);
            for (s = [-1, 1]) difference() {
               translate([br_base_t, s < 0 ? -br_rib[1] / 2 - br_rib[2] : br_rib[1] / 2]) square([br_rib[2], br_rib[2]]);
               translate([br_base_t + br_rib[2], s * (br_rib[1] / 2 + br_rib[2])]) circle(br_rib[2], $fn = 16);
            }
         }
      }
      // encoder and its tab
      translate([-1, ax[0], ax[1]]) rotate([0, 90, 0]) cylinder(d = enc_hole_d, h = plate_t + 2);
      translate([-1, ax[0] + enc_tab_at, ax[1]]) rotate([0, 90, 0]) cylinder(d = enc_tab_d, h = tab_h + 1, $fn = 24);
      // the bushing's bore and the lip behind it
      translate([upright_x + br_upright_t - br_bore[1], ax[0], ax[1]]) rotate([0, 90, 0]) cylinder(d = br_bore[0], h = br_bore[1] + 1);
      translate([upright_x - 1, ax[0], ax[1]]) rotate([0, 90, 0]) cylinder(d = br_lip_d, h = br_upright_t);
   }
}

module bracket_large() {
   bracket(brl_plate_t, brl_upright_x, brl_overhang, brl_plate_t + 1);
}

// ---------------------------------------------------------------- servo bracket, arm, smoother

// x across (the wall at +x), y away from the face plate, z: the plate on top
module servo_bracket() {
   difference() {
      translate([0, 0, sb.z - sb_plate_t]) cube([sb.x, sb.y, sb_plate_t]);
      translate([-1, sb_cut[1], 0]) cube([sb_cut[0] + 1, sb_cut[2], sb.z + 1]);
      for (y = sv_holes) translate([sb_cut[0] / 2, y, 0]) cylinder(d = sv_hole_d, h = sb.z + 1, $fn = 16);
   }
   translate([sb.x - sb_wall_t, 0, 0]) cube([sb_wall_t, sb.y, sb.z]);
}

module arm() {
   difference() {
      hull() {
         translate([arm_r[0], arm_r[0], 0]) cylinder(r = arm_r[0], h = arm_t);
         translate([arm_len - arm_r[1], arm_tip_y, 0]) cylinder(r = arm_r[1], h = arm_t, $fn = 24);
      }
      translate([arm_r[0], arm_r[0], -1]) cylinder(d = arm_hole_d, h = arm_t + 2, $fn = 24);
      translate([arm_r[0], arm_r[0], arm_t - arm_head_h]) cylinder(d = arm_head_d, h = arm_t, $fn = 24);
   }
}

// The disc on y = 0..sm_t (the grooved face at y = 0), the keel behind it,
// its top against the face plate's back, its edge in the slot's chamfer.
module smoother() {
   c = sm_d / 2;
   translate([c, 0, c]) rotate([-90, 0, 0]) rotate_extrude($fn = 128) difference() {
      polygon([[0, 0], [c - 1, 0], [c, 1], [c, sm_t], [0, sm_t]]);
      for (r = sm_grooves) translate([r, -0.3]) circle(sm_groove_r, $fn = 24);
      intersection() {
         hull() {
            translate([-1, -1]) square([1, 2]);
            translate([sm_grooves[0] - 7.5 - 1.3, -0.3]) circle(sm_groove_r, $fn = 24);
         }
         translate([0, -1]) square([c, 2]);
      }
   }
   // keel: a V under the top, its tip rounded; on the disc's side 3 mm
   // more, chamfered at 45 degrees (into the slot's chamfer)
   top = sm_keel[1];
   tip_r = (sm_keel[3] - sm_keel[2]) / (sqrt(2) - 1);
   half = top - sm_keel[2];
   module v(t) {   // the V's section in xz, top at z = t
      hull() {
         translate([c - half, top - 0.01]) square([2 * half, 0.01]);
         translate([c, sm_keel[2] + tip_r * sqrt(2)]) circle(tip_r);
         if (t > top) translate([c - half + 2, top]) square([2 * half - 4, t - top]);
      }
   }
   hull() {
      translate([0, sm_t, 0]) rotate([-90, 0, 0]) mirror([0, 1, 0]) linear_extrude(0.01) v(top + slot_chamfer);
      translate([0, sm_t + slot_chamfer, 0]) rotate([-90, 0, 0]) mirror([0, 1, 0]) linear_extrude(sm_keel[0] - slot_chamfer) v(top);
   }
}

// ---------------------------------------------------------------- bought parts, view only

module sg90_part() {
   // installed: length along y, width along z, the shaft towards -x
   color("RoyalBlue") {
      translate([0, -sg90.x / 2, -sg90.y / 2]) cube([sg90.z, sg90.x, sg90.y]);
      translate([sg90_ear[2], -sg90_ear[0] / 2, -sg90.y / 2]) cube([sg90_ear[1], sg90_ear[0], sg90.y]);
      translate([0, sg90_shaft, 0]) rotate([0, -90, 0]) cylinder(d = 4.8, h = 4, $fn = 24);
   }
}

module encoder_part() {
   // installed: the mounting face at x = 0, the shaft towards +x
   color("Silver") {
      translate([-ec11[1], -ec11[0] / 2, -ec11[0] / 2]) cube([ec11[1], ec11[0], ec11[0]]);
      rotate([0, 90, 0]) cylinder(d = enc_hole_d - 0.2, h = enc_bush_l);
      rotate([0, 90, 0]) cylinder(d = 6, h = enc_shaft_l);
      translate([br_plate_t, 0, 0]) rotate([0, 90, 0]) cylinder(d = 10, h = 2, $fn = 6);
   }
}

// ---------------------------------------------------------------- installed

module trim_parts(explode = 0, with_case = true) {
   color("DimGray") translate([0, -explode, 0]) rotate([90, 0, 0]) face_plate();
   if (with_case)
      color("DimGray", 0.5) translate([face_w, case_d + explode, 0]) rotate([0, 0, 180]) case();
   e = explode / 2;
   color("#303030") translate([wheel_x + e, y_ax, z_ax]) rotate([0, 90, 0]) translate([-wheel_d / 2, -wheel_d / 2, -ball_d / 2]) wheel();
   color("White") translate([wheel_l + sp_stub[1], y_ax, z_ax]) rotate([0, 0, 90]) translate([-sp_flange[0] / 2, 0, -sp_flange[0] / 2]) spacer();
   color("White") translate([br_x + br_w, y_ax, z_ax]) rotate([0, 0, 90]) translate([-bush_d / 2, 0, -bush_d / 2]) bushing();
   color("WhiteSmoke") translate([br_x, -pocket[4], z_ax - br_ax[1]]) bracket();
   translate([br_x - e, y_ax, z_ax]) encoder_part();
   color("#404040") translate([wheel_x + wheel_t / 2 + 2 * e, y_ax, z_ax])
      multmatrix([[0, 1, 0, 0], [0, 0, -1, sm_d / 2], [-1, 0, 0, sm_d / 2], [0, 0, 0, 1]]) smoother();
   // servo bracket: its x along z, y along y, z along -x
   color("WhiteSmoke") multmatrix([[0, 0, -1, sb_pocket[0][0] + sb.z], [0, 1, 0, -sb_pocket_d], [1, 0, 0, sb_pocket[0][1]], [0, 0, 0, 1]]) servo_bracket();
   translate([sv_x, sv_y, (win_z[0] + win_z[1]) / 2]) sg90_part();
   // the arm from the servo's shaft towards the window
   color("White") multmatrix([[0, 0, 1, arm_x], [-1, 0, 0, sv_y + sg90_shaft + arm_r[0]], [0, -1, 0, (win_z[0] + win_z[1]) / 2 + arm_r[0]], [0, 0, 0, 1]]) arm();
}

module assembled_view() { trim_parts(); }
module inside_view() { trim_parts(with_case = false); }
module exploded_view() { trim_parts(explode = 60); }

// --- Printable parts, in print orientation (the original's) ---
face_plate(); // Make module face
case(); // Make module case
wheel(); // Make module wheel
spacer(); // Make module spacer
bushing(); // Make module bushing
bracket(); // Make module bracket
bracket_large(); // Make module bracket_large
servo_bracket(); // Make module servo_bracket
arm(); // Make module arm
smoother(); // Make module smoother

//assembled_view(); // Make view main 70,0,-35
//assembled_view(); // Make view front 90,0,0
//inside_view(); // Make view inside 60,0,215
//exploded_view(); // Make view exploded 65,0,-40
