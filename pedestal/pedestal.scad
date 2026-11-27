// Pedestal: elevator trim wheel and trim indicator
//
// The top of the 172's pedestal, under the throttle: the trim wheel's rim
// stands out of a tall slot in the face, NOSE DOWN at its top, NOSE UP at
// its bottom, and left of it the trim indicator, a pointer moving up and
// down in a narrow slot past the TAKE OFF mark. Mounted in the cockpit
// frame (frame/) like the throttle box: the body goes through a cut-out in
// the apron sheet and stands on the apron's lower bar, its front plate's
// flange (top and sides) is screwed onto the sheet (M3, nuts behind the
// sheet), and two M5 bolts through the floor go into T-nuts in the lower
// bar's top slot. The back is open (it is under the desk); everything goes
// in from there.
//
// - The wheel is glued onto a 6 mm rod that turns in two cheeks on the
//   front plate's back, one each side of the wheel, which frame the wheel
//   slot. The cheeks' bearings are slots open to the back (the wheel goes
//   in from behind with its rod); a printed keeper screwed onto each
//   cheek's back closes it, its tongue on the rod.
// - The rod's right end is glued into a printed coupler, which turns in
//   the right cheek's bearing and takes the D shaft of an EC11 rotary
//   encoder (with detents) in its other end. The encoder's bushing sits in
//   a slot in a plate right of the cheek, open to the back like the
//   bearings, clamped by its nut, so the wheel, the rod, the coupler and
//   the encoder go in from behind as one. MobiFlight sends X-Plane's
//   pitch trim up/down command for every click (D2, D3), so the wheel and
//   the yoke's trim rocker both trim. Resistance: a felt (or rubber) pad
//   in a keeper's tongue presses on the rod or the coupler.
// - The indicator: a rack slides up and down in a channel on the front
//   plate's back, its pointer through the indicator slot. An SG90 servo
//   on a bracket behind it turns the pinion (sv_sweep for the full
//   travel); MobiFlight drives it from X-Plane's elevator trim.
// - An Arduino Nano of its own (MobiFlight) in rails on the floor under
//   the servo, its USB jack to the back, the cable tied onto a block
//   behind the plug (README.md, Connections).
//
// Coordinates, installed: x to the right (seen from the pilot), y
// backwards, z up; y = 0 is the face's front, z = 0 the floor's underside
// (the lower bar's top), x = 0 the body's middle.
//
// Prints: the body on its face (front plate down, everything else stands
// on it), the face front side up (lettering for a paint pen), the wheel
// on its web, the rack on its side, the bracket on its front, the pinion,
// the keepers flat, the coupler on its collar.
//
// Parts to buy (README.md): 6 mm rod (rod_len), EC11 rotary encoder,
// SG90 servo, Arduino Nano, felt pad, M3 screws (face, bracket, keepers),
// 2 M5 bolts + T-nuts (frame).

$fn = 60;

include <nano.inc.scad>
include <usb.inc.scad>

// Preview
view_trim = 0.12;            // -1 (nose down) .. 1 (nose up)
explode = 40;

bed = [255, 255];

// --- Body, the frame's pedestal_size and under_* (frame/frame.inc.scad) ---
body = [110, 120, 150];      // width, depth from the face's front, height
wall = 3;
face_t = 2;                  // the separate face, in front of the front plate
plate_t = 3;                 // the body's front plate with the flange
flange_w = 10;               // top and sides (none at the bottom: the bar)
face_r = 4;                  // the face's top corners
mount_d = 3.3;               // M3
mount_inset = 4.5;
mount_nut_r = 3.2;           // M3 nut behind the sheet
sheet_t = 3;
sheet_cut_clear = 1;         // the frame's under_play
bar_slot = 10;               // the lower bar's top slot behind the sheet (ext / 2)
m5_d = 5.3;
m5_head_d = 9.5;
pilot_d = 2.8;               // M3 self tapping
clear_d = 3.3;

// --- Trim wheel ---
wheel_d = 120;
wheel_w = 12;                // the rim, across
wheel_x = -2;                // its middle, from the body's middle (the encoder needs the room on the right)
wheel_out = 12;              // the rim out of the face's front
rim_t = 5;
web_t = 3;                   // the web on the wheel's left side
hub_d = 16;
rib_n = 40;                  // grooves across the rim
rib_d = 2.4;
rib_depth = 0.8;
wheel_gap = 0.5;             // the wheel to the cheeks, the rim to the slot's sides
slot_clear = 1;              // the rim to the slot's ends

// --- Rod and cheeks ---
rod_d = 6;
rod_hole = 6.2;              // the cheeks' bearings
rod_glue = 6.1;              // the wheel's and the coupler's bores, glued
cheek_t = 6;
cheek_h = 14;                // the cheeks over and under the axle
keeper = [cheek_t, 2 * 12, 3];   // its plate: across, high, thick
keeper_screw = 9;            // its screws over and under the axle
pad = [4, 4, 1.5];           // felt or rubber pad in a keeper's tongue: across, along z, thick (MEASURE)
pad_pocket = 1;              // its pocket in the tongue
pad_squeeze = 0.4;           // pressed onto the rod or the coupler (more: stiffer wheel)

// --- EC11 rotary encoder with detents, MEASURE (bare EC11, the heading indicator's, instruments/hi.scad) ---
enc_body = [12.5, 6.5, 5];   // square body: side, depth, pins behind it
enc_bush = [7, 7];           // threaded bushing M7: diameter, length
enc_nut = [9.5, 2];          // its nut: across flats, height
enc_shaft = [6, 4.5, 20];    // D shaft: diameter, across the flat, length from the mounting face
enc_wires = 3;               // behind its pins for the soldered wires
enc_in = 7;                  // the shaft in the coupler
enc_plate = 2.5;             // the plate its bushing is clamped in
// --- Coupler: the rod to the encoder's shaft ---
coupler_d = 10;              // in the right cheek's bearing
coupler_hole = 10.4;
collar_d = 14;               // outside the right cheek, keeps the wheel from sliding
rod_in = 6;                  // the rod in the coupler

// --- SG90 servo, MEASURE (the NAV indicator's flag servo, instruments/cdi.scad) ---
sv_body = [22.8, 12.2, 22.7];   // length, width, height (its top to its bottom)
sv_shaft_dx = 5.9;           // the shaft from the body's near end
sv_boss = [11.8, 4];         // the round boss on its top round the shaft: diameter, height
sv_bump = [6, 8];            // the small bump beside it: diameter, from the shaft
sv_spline = [4.8, 3];        // the output spline: diameter, length
sv_spline_fit = 4.6;         // the pinion's hole, pressed on (and its screw)
sv_tab = [32.3, 2.5, 4.5];   // the mounting tabs: length over both, thickness, the body's top to their top
sv_tab_hole = 27.8;          // their holes apart
sv_pilot = 1.8;              // the servo's own 2 mm screws
sv_screw = [2.2, 4.5, 1.6];  // its horn screw: clearance, head diameter, head height
sv_sweep = 160;              // degrees for the full travel (set in MobiFlight)

// --- Indicator ---
gear_m = 1;
gear_play = 0.15;
pin_z = 24;                  // pinion teeth
pin_w = 6;
ind_z = 62;                  // the travel's middle over the floor
rack_w = 5;                  // behind the teeth's root
rack_play = 0.3;
chan_wall = 1.5;
tab = [3, 3];                // the pointer: across, high
ind_slot_w = 4;
to_trim = 0.12;              // TAKE OFF mark at this trim (-1 nose down, at the top .. 1 nose up)

// --- Lettering ---
label_raise = 0.8;
font = "Liberation Sans:style=Bold";
label_size = 3.2;

// --- Calculated ---
y_pl = face_t;                       // the front plate's front
y_in = face_t + plate_t;             // its back, the inside
wall_in = body.x / 2 - wall;         // the side walls' inside, |x|
top_in = body.z - wall;
face_w = body.x + 2 * flange_w;
face_h = body.z + flange_w;
floor_bolt_y = y_in + sheet_t + bar_slot;
floor_bolts = [for (s = [-1, 1]) [s * body.x / 4, floor_bolt_y]];

wheel_r = wheel_d / 2;
y_ax = wheel_r - wheel_out;          // the axle behind the face's front
z_ax = top_in - 2 - wheel_r;         // under the top wall
wx = [wheel_x - wheel_w / 2, wheel_x + wheel_w / 2];   // the rim, x
slot_x = [wx[0] - wheel_gap, wx[1] + wheel_gap];
slot_hl = sqrt(wheel_r * wheel_r - (y_ax - y_in) * (y_ax - y_in)) + slot_clear + (slot_x[1] - slot_x[0]) / 2;   // half its length, the round ends beyond the rim
ch_l = [slot_x[0] - cheek_t, slot_x[0]];               // left cheek, x
ch_r = [slot_x[1], slot_x[1] + cheek_t];               // right cheek, x
cp_x = [wx[1], wx[1] + rod_in + 0.5 + enc_in];        // the coupler, from the hub
collar_x0 = ch_r[1] + 0.3;
enc_mount = cp_x[0] + rod_in + 0.5 + enc_shaft[2];      // the encoder's mounting face (x)
enc_pl = [enc_mount - enc_plate, enc_mount];           // its plate
rod_x = [ch_l[0], cp_x[0] + rod_in];
rod_len = rod_x[1] - rod_x[0];
cheek_back = y_ax + 8;

pin_r = gear_m * pin_z / 2;
ind_travel = pin_r * sv_sweep * PI / 180;
rack_xr = ch_l[0] - chan_wall - rack_play;             // the rack's right side
rack_root = rack_xr - rack_w;
rack_pitch = rack_root - 1.25 * gear_m;
rack_tip = rack_pitch - gear_m;
pin_c = [rack_pitch - pin_r, ind_z];                   // [x, z]
pin_ra = pin_r + gear_m;
pin_y = [y_in + 1, y_in + 1 + pin_w];
rack_y = [y_in + rack_play, pin_y[1] + 0.8];
rack_len = ceil(ind_travel + 2 * 0.8 * pin_r);
chan_z = [ind_z - rack_len / 2 - ind_travel / 2 - 1, ind_z + rack_len / 2 + ind_travel / 2 + 1];
ind_x = (rack_root + rack_xr) / 2;                     // the pointer and its slot
ind_hl = ind_travel / 2 + tab[1] / 2 + 1;              // the slot, half its length
function trim_z(t) = ind_z - t * ind_travel / 2;       // the pointer at trim t
to_z = trim_z(to_trim);

sv_top = pin_y[1] + sv_boss[1];                        // the servo's top (y)
y_br = [rack_y[1] + 0.3, sv_top + sv_tab[2]];          // the bracket: front, back (the tabs on it)
sv_dir = -1;                                           // the servo's body from its shaft, along z
sv_bc = pin_c.y + sv_dir * (sv_body[0] / 2 - sv_shaft_dx);   // its body's middle, z
sv_holes = [for (s = [-1, 1]) [pin_c.x, sv_bc + s * sv_tab_hole / 2]];
br_x = [-wall_in + 0.5, ch_l[0] - 0.1];
br_z = [chan_z[0], chan_z[1]];
br_posts = [for (x = [-wall_in + 6, pin_c.x + 4], z = [br_z[0] + 6, br_z[1] - 6]) [x, z]];

nano_c = [-33, 52];                                    // its middle on the floor, the jack at +y
usb_z = wall + nano_top_h + nano_usb.y / 2;            // the jack's middle
nano_jack_y = nano_c.y + nano_board.y / 2 + nano_usb_out;
tie_y = nano_jack_y + usb_plug.z + tie_gap + tie_block.x / 2;

mount_holes = [for (z = [mount_inset + 4, body.z / 2], s = [-1, 1]) [s * (face_w / 2 - mount_inset), z],
               for (x = [-face_w / 2 + mount_inset, 0, face_w / 2 - mount_inset]) [x, face_h - mount_inset]];

echo(rod_len = rod_len, ind_travel = ind_travel, wheel_axle = [wheel_x, y_ax, z_ax], wheel_slot = [slot_x, z_ax - slot_hl, z_ax + slot_hl],
     ind_slot = [ind_x, ind_z, 2 * ind_hl]);

// --- Checks ---
assert(face_w <= bed.x && face_h <= bed.y && body.x <= bed.x && body.z <= bed.y, "Body or face does not fit the printer bed");
assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear, "Mount nuts do not sit on the sheet, make flange_w wider");
assert(z_ax - wheel_r >= wall + 2, "The wheel runs into the floor");
assert(z_ax + slot_hl <= top_in, "The wheel slot runs into the top wall");
assert(ch_l[0] - chan_wall - 0.1 > rack_xr, "Rack channel runs into the left cheek");
assert(enc_mount + enc_body[1] + enc_body[2] + enc_wires <= wall_in, "The encoder's wires run into the right wall");
assert(cp_x[1] - collar_x0 >= 2, "The coupler's collar too short");
assert(enc_pl[0] - enc_nut[1] >= cp_x[1] + 0.5, "The encoder's nut runs into the coupler");
assert(enc_bush[1] >= enc_plate + enc_nut[1], "The encoder's bushing too short for its plate and nut");
assert(keeper_screw - pilot_d / 2 >= coupler_hole / 2 + 1, "Keeper screws in the coupler's bearing");
assert(pin_c.x - pin_ra >= -wall_in + 1, "The pinion runs into the left wall");
assert(pin_c.x - sv_body[1] / 2 >= -wall_in + 0.5, "The servo runs into the left wall");
assert(sv_bc - sv_tab[0] / 2 >= br_z[0] && sv_bc + sv_tab[0] / 2 <= br_z[1], "The servo's tabs off the bracket");
assert(chan_z[0] >= wall + 1 && chan_z[1] <= top_in - 1, "The rack channel runs into the floor or the top");
assert(ind_x - ind_slot_w / 2 >= -face_w / 2 + flange_w, "Indicator slot off the body");
assert(ind_x + ind_slot_w / 2 + 3.5 <= slot_x[0] - 1, "No room for the TAKE OFF mark between the slots");
for (p = br_posts) {
   assert(norm(p - pin_c) >= pin_ra + 3.5 + 0.5, "A bracket post runs into the pinion");
   assert(p.x + 3.5 <= rack_tip - chan_wall - 0.5, "A bracket post runs into the rack's channel");
   assert(abs(p.y - sv_bc) >= sv_tab[0] / 2 + 3.5 || abs(p.x - pin_c.x) >= sv_body[1] / 2 + 3.5, "A bracket post runs into the servo");
}
assert(nano_c.x - nano_rail_hw >= -wall_in + 1 && nano_c.x + nano_rail_hw <= ch_l[0] - 1, "The Nano's rails run into a wall or a cheek");
assert(nano_c.y - nano_rail_end >= floor_bolts[0].y + m5_head_d / 2 + 0.5, "The Nano runs into the left floor bolt");
assert(wall + nano_top_h + nano_usb.y <= sv_bc - sv_body[0] / 2 - 2 || nano_c.y - nano_board.y / 2 >= y_br[1] + sv_body[2], "The Nano runs into the servo");
assert(usb_z + usb_plug.y / 2 <= z_ax - wheel_r || nano_c.x + usb_plug.x / 2 <= wx[0] - 1, "The USB plug runs into the wheel");
assert(tie_y + tie_block.x / 2 <= body.y, "The USB tie block off the floor");
assert(abs(floor_bolts[0].x) + m5_head_d / 2 <= wall_in && floor_bolt_y - m5_head_d / 2 >= y_in, "Floor bolts off the floor");

// --- Helpers ---
// along y from y0 to y1, a 2D shape in x (right) and z (up)
module along_y(y0, y1) {
   translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}
// along x from x0 to x1, a 2D shape in y (back) and z (up)
module along_x(x0, x1) {
   translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children();
}
module stadium(c, w, hl) {
   hull() for (s = [-1, 1]) translate([c.x, c.y + s * (hl - w / 2)]) circle(d = w);
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

// A rack along y, its pitch line on x = 0, the teeth towards -x, the base
// back to x = base (beyond the root), from y = 0 to len
module rack_2d(len, base, m = gear_m, play = gear_play) {
   p = PI * m;
   s = p / 2 - play;                     // the tooth on the pitch line
   t = tan(20);
   translate([1.25 * m, 0]) square([base, len]);
   for (k = [0 : floor(len / p)]) let(c = k * p + p / 2) if (c - p / 2 >= 0 && c + p / 2 <= len)
      polygon([[1.25 * m + 0.01, c - s / 2 - 1.25 * m * t], [-m, c - s / 2 + m * t],
               [-m, c + s / 2 - m * t], [1.25 * m + 0.01, c + s / 2 + 1.25 * m * t]]);
}

// --- The front: outline, holes, slots ---
module front_outline() {
   hull() {
      translate([-face_w / 2, 0]) square([face_w, 1]);
      for (s = [-1, 1]) translate([s * (face_w / 2 - face_r), face_h - face_r]) circle(r = face_r);
   }
}
module front_holes() {
   for (h = mount_holes) translate(h) circle(d = mount_d);
   stadium([(slot_x[0] + slot_x[1]) / 2, z_ax], slot_x[1] - slot_x[0], slot_hl);
   stadium([ind_x, ind_z], ind_slot_w, ind_hl);
}

// --- Body ---
// cheek outline in [y, z]: a block round the axle, braced down to the floor at the front
module cheek_2d(h) {
   polygon([[y_pl, wall - 0.01], [y_pl + 22, wall - 0.01], [cheek_back, z_ax - h - 10],
            [cheek_back, z_ax + h], [y_pl, z_ax + h]]);
}
// a bearing slot open to the back, [y, z]
module back_slot_2d(d) {
   hull() {
      translate([y_ax, z_ax]) circle(d = d);
      translate([cheek_back + 1, z_ax - d / 2]) square([0.1, d]);
   }
}

module body() {
   difference() {
      union() {
         // front plate with the flange
         along_y(y_pl, y_in) front_outline();
         // walls: sides, top, floor; the back is open
         difference() {
            translate([-body.x / 2, y_pl, 0]) cube([body.x, body.y - y_pl, body.z]);
            translate([-wall_in, y_in - 0.01, wall]) cube([2 * wall_in, body.y, top_in - wall]);
         }
         // cheeks: the left one (the rod), the right one (the coupler), the encoder's plate
         along_x(ch_l[0], ch_l[1]) cheek_2d(cheek_h);
         along_x(ch_r[0], ch_r[1]) cheek_2d(cheek_h);
         along_x(enc_pl[0], enc_pl[1]) cheek_2d(cheek_h);
         // the rack's channel: the right wall on the left cheek, the left one above and below the pinion
         translate([rack_xr + rack_play, y_in - 0.01, chan_z[0]]) cube([ch_l[0] - rack_xr - rack_play + 0.01, y_br[0] - y_in, chan_z[1] - chan_z[0]]);
         for (z = [[chan_z[0], pin_c.y - pin_ra - 1], [pin_c.y + pin_ra + 1, chan_z[1]]])
            translate([rack_tip - rack_play - chan_wall, y_in - 0.01, z[0]]) cube([chan_wall, rack_y[1] - y_in + 0.01, z[1] - z[0]]);
         // the bracket's posts
         for (p = br_posts) along_y(y_in - 0.01, y_br[0]) translate(p) circle(d = 7);
         // the Nano's rails and the USB cable's tie block
         translate([nano_c.x, nano_c.y, wall]) nano_rails(far_stop = true);
         translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_block();
         if (usb_z - tie_cable_h > wall)
            translate([nano_c.x - tie_block.y / 2, tie_y - tie_block.x / 2, wall - 0.01]) cube([tie_block.y, tie_block.x, usb_z - tie_cable_h - wall + 0.02]);
      }
      // through the front
      translate([0, y_pl - 1, 0]) along_y(0, y_in - y_pl + 2) front_holes();
      // the wheel's room between the cheeks
      translate([slot_x[0], y_in - 1, z_ax - wheel_r - 2]) cube([slot_x[1] - slot_x[0], body.y, wheel_d + 4]);
      // bearings: the rod in the left cheek, the coupler in the right one, the encoder's bushing in its plate
      along_x(ch_l[0] - 1, ch_l[1] + 0.01) back_slot_2d(rod_hole);
      along_x(ch_r[0] - 0.01, ch_r[1] + 1) back_slot_2d(coupler_hole);
      along_x(enc_pl[0] - 1, enc_pl[1] + 1) back_slot_2d(enc_bush[0] + 0.4);
      // keeper screws
      for (x = [(ch_l[0] + ch_l[1]) / 2, (ch_r[0] + ch_r[1]) / 2], s = [-1, 1])
         translate([x, cheek_back + 1, z_ax + s * keeper_screw]) rotate([90, 0, 0]) cylinder(d = pilot_d, h = 9);
      // the bracket's screws
      for (p = br_posts) translate([p.x, y_in + 1, p.y]) rotate([-90, 0, 0]) cylinder(d = pilot_d, h = 20);
      // floor bolts
      for (b = floor_bolts) translate([b.x, b.y, -1]) cylinder(d = m5_d, h = wall + 2);
   }
}

// --- Face: printed front side up, the lettering standing out of it ---
module labels_2d() {
   lx = (-face_w / 2 + flange_w + ind_x - ind_slot_w / 2) / 2;   // between the face's side and the indicator
   for (l = [["NOSE", z_ax + slot_hl - 6], ["DOWN", z_ax + slot_hl - 6 - 1.6 * label_size],
             ["NOSE", z_ax - slot_hl + 1.6 * label_size], ["UP", z_ax - slot_hl]])
      translate([lx, l[1]]) text(l[0], size = label_size, font = font, halign = "center");
   // TAKE OFF, read downwards, a triangle at the mark pointing at the slot and a line beyond it
   tx = ind_x - ind_slot_w / 2 - 3.5;
   translate([tx + label_size / 2, to_z + 3]) rotate(-90) text("TAKE", size = 0.8 * label_size, font = font, halign = "right", valign = "center");
   translate([tx + label_size / 2, to_z - 3]) rotate(-90) text("OFF", size = 0.8 * label_size, font = font, halign = "left", valign = "center");
   translate([ind_x - ind_slot_w / 2 - 0.6, to_z]) polygon([[0, 0], [-2.6, 1.6], [-2.6, -1.6]]);
   translate([ind_x + ind_slot_w / 2 + 0.6, to_z - 0.5]) square([3, 1]);
}

module face() {
   linear_extrude(face_t) difference() { front_outline(); front_holes(); }
   translate([0, 0, face_t - 0.01]) linear_extrude(label_raise + 0.01) labels_2d();
}
// the face in place, its front at y = 0
module face_in_place() {
   translate([0, face_t, 0]) rotate([90, 0, 0]) face();
}

// --- Wheel: printed on its web (x = wx[0]) ---
module wheel() {
   difference() {
      union() {
         difference() {
            cylinder(r = wheel_r, h = wheel_w, $fn = 180);
            translate([0, 0, web_t]) cylinder(r = wheel_r - rim_t, h = wheel_w, $fn = 120);
            // grooves across the rim
            for (k = [0 : rib_n - 1]) rotate(k * 360 / rib_n)
               translate([wheel_r + rib_d / 2 - rib_depth, 0, -1]) cylinder(d = rib_d, h = wheel_w + 2, $fn = 16);
            // the rim's edges rounded off
            for (z = [0, wheel_w]) translate([0, 0, z]) rotate_extrude($fn = 180)
               translate([wheel_r, 0]) rotate(45) square(1.6, center = true);
            // lightening holes in the web
            for (k = [0 : 5]) rotate(k * 60) translate([(hub_d / 2 + wheel_r - rim_t) / 2, 0, -1]) cylinder(d = 26, h = web_t + 2);
         }
         cylinder(d = hub_d, h = wheel_w);
      }
      translate([0, 0, -1]) cylinder(d = rod_glue, h = wheel_w + 2);
   }
}
module wheel_in_place(a = 0) {
   translate([wx[0], y_ax, z_ax]) rotate([a, 0, 0]) rotate([0, 90, 0]) wheel();
}

// --- Coupler: the rod in one end, the encoder's D shaft in the other;
// printed on its collar ---
module coupler() {
   l = cp_x[1] - cp_x[0];
   difference() {
      union() {
         cylinder(d = coupler_d, h = l);
         translate([0, 0, collar_x0 - cp_x[0]]) cylinder(d = collar_d, h = cp_x[1] - collar_x0);
      }
      translate([0, 0, -1]) cylinder(d = rod_glue, h = rod_in + 1);
      translate([0, 0, l - enc_in]) intersection() {
         cylinder(d = enc_shaft[0] + 0.15, h = enc_in + 1);
         translate([-enc_shaft[0], -(enc_shaft[1] + 0.1) / 2, 0]) cube([2 * enc_shaft[0], enc_shaft[1] + 0.1, enc_in + 1]);
      }
   }
}
module coupler_in_place() {
   translate([cp_x[0], y_ax, z_ax]) rotate([0, 90, 0]) coupler();
}

// --- Keeper: closes a cheek's bearing (w wide: the rod's, the coupler's),
// its tongue pressing a pad onto what turns in it (r: its radius) ---
function tongue(r) = cheek_back - (y_ax + r + pad[2] - pad_pocket - pad_squeeze);
module keeper(w, r) {
   t = tongue(r);
   difference() {
      union() {
         translate([-keeper.x / 2, -keeper.y / 2, 0]) cube(keeper);
         translate([-keeper.x / 2, -(w - 0.3) / 2, 0]) cube([keeper.x, w - 0.3, keeper.z + t]);
      }
      for (s = [-1, 1]) translate([0, s * keeper_screw, -1]) cylinder(d = clear_d, h = keeper.z + 2);
      translate([-(pad.x + 0.3) / 2, -(pad.y + 0.3) / 2, keeper.z + t - pad_pocket]) cube([pad.x + 0.3, pad.y + 0.3, pad_pocket + 1]);
   }
}
// printed on its plate; in place its plate on the cheek's back, the tongue forward
module keeper_in_place(xc, w, r) {
   translate([xc, cheek_back + keeper.z, z_ax]) rotate([90, 0, 0]) keeper(w, r);
}
module keepers_in_place() {
   keeper_in_place((ch_l[0] + ch_l[1]) / 2, rod_hole, rod_d / 2);
   keeper_in_place((ch_r[0] + ch_r[1]) / 2, coupler_hole, coupler_d / 2);
}

// --- Rack: the pointer tab on its front, printed on its side ---
module rack() {
   along_y(rack_y[0], rack_y[1]) translate([rack_pitch, ind_z - rack_len / 2]) rack_2d(rack_len, rack_xr - rack_root);
   translate([ind_x - tab[0] / 2, 0.4, ind_z - tab[1] / 2]) cube([tab[0], rack_y[0] - 0.4 + 0.01, tab[1]]);
}
module rack_in_place(t = 0) {
   translate([0, 0, trim_z(t) - ind_z]) rack();
}

// --- Pinion on the servo's spline ---
module pinion() {
   difference() {
      linear_extrude(pin_w) gear_2d(pin_z);
      translate([0, 0, pin_w - sv_spline[1]]) cylinder(d = sv_spline_fit, h = sv_spline[1] + 1);
      translate([0, 0, -1]) cylinder(d = sv_screw[0], h = pin_w + 2);
      translate([0, 0, -1]) cylinder(d = sv_screw[1] + 0.4, h = sv_screw[2] + 1.2);
   }
}
module pinion_in_place(t = 0) {
   translate([pin_c.x, pin_y[0], pin_c.y]) rotate([-90, 0, 0]) rotate(t * sv_sweep / 2) pinion();
}

// --- Servo bracket: the rack's back, the servo's tabs on its back ---
module bracket() {
   difference() {
      translate([br_x[0], 0, br_z[0]]) cube([br_x[1] - br_x[0], y_br[1] - y_br[0], br_z[1] - br_z[0]]);
      // the servo's boss and bump through, its body's top in a pocket
      translate([pin_c.x, -1, pin_c.y]) rotate([-90, 0, 0]) cylinder(d = sv_boss[0] + 0.6, h = 20);
      translate([pin_c.x, -1, pin_c.y + sv_dir * sv_bump[1]]) rotate([-90, 0, 0]) cylinder(d = sv_bump[0] + 0.6, h = 20);
      translate([pin_c.x - sv_body[1] / 2 - 0.3, sv_top - y_br[0], sv_bc - sv_body[0] / 2 - 0.3]) cube([sv_body[1] + 0.6, 20, sv_body[0] + 0.6]);
      for (h = sv_holes) translate([h.x, y_br[1] - y_br[0] - 6, h.y]) rotate([-90, 0, 0]) cylinder(d = sv_pilot, h = 7);
      // its screws into the posts, heads behind
      for (p = br_posts) translate([p.x, -1, p.y]) rotate([-90, 0, 0]) cylinder(d = clear_d, h = 20);
   }
}
module bracket_in_place() {
   translate([0, y_br[0], 0]) bracket();
}

// --- View-only parts ---
c_body = "#4a4a4a";
c_face = "#2e2e2e";
c_label = "#f4f4f4";
c_wheel = "#1c1c1c";
c_print = "#d8d8d8";
c_steel = "#b9c0c8";

module servo_part(t = 0) {
   color("#1f5fbf") {
      translate([pin_c.x - sv_body[1] / 2, sv_top, sv_bc - sv_body[0] / 2]) cube([sv_body[1], sv_body[2], sv_body[0]]);
      translate([pin_c.x - sv_body[1] / 2, sv_top + sv_tab[2], sv_bc - sv_tab[0] / 2]) cube([sv_body[1], sv_tab[1], sv_tab[0]]);
      translate([pin_c.x, pin_y[1], pin_c.y]) rotate([-90, 0, 0]) cylinder(d = sv_boss[0], h = sv_boss[1]);
   }
}
module enc_part() {
   translate([enc_mount, y_ax, z_ax]) {
      color("#b9c0c8") {
         rotate([0, -90, 0]) cylinder(d = enc_bush[0], h = enc_bush[1]);
         translate([-enc_plate, 0, 0]) rotate([0, -90, 0]) cylinder(d = enc_nut[0] / cos(30), h = enc_nut[1], $fn = 6);
         rotate([0, -90, 0]) cylinder(d = enc_shaft[0], h = enc_shaft[2]);
      }
      color("#2a2a2a") translate([0, -enc_body[0] / 2, -enc_body[0] / 2]) cube([enc_body[1], enc_body[0], enc_body[0]]);
      color("#b9c0c8") for (k = [-1 : 1]) translate([enc_body[1], k * 5 - 0.4, -enc_body[0] / 2 + 1]) cube([enc_body[2], 0.8, 0.4]);
   }
}
module rod_part() {
   color(c_steel) translate([rod_x[0], y_ax, z_ax]) rotate([0, 90, 0]) cylinder(d = rod_d, h = rod_len);
}
module nano_view() {
   translate([nano_c.x, nano_c.y, wall]) nano_part();
   color("#333") {
      translate([nano_c.x - usb_plug.x / 2, nano_jack_y, usb_z - usb_plug.y / 2]) cube([usb_plug.x, usb_plug.z, usb_plug.y]);
      translate([nano_c.x, nano_jack_y + usb_plug.z, usb_z]) rotate([-90, 0, 0]) cylinder(d = cable_d, h = body.y - nano_jack_y - usb_plug.z + 40);
   }
   translate([nano_c.x, tie_y, usb_z - tie_cable_h]) rotate(90) tie_part();
}
module bolts_part() {
   color(c_steel) for (b = floor_bolts) translate([b.x, b.y, wall]) cylinder(d = m5_head_d, h = 3);
}
// the sheet round it, for the views
module sheet_part() {
   color("#9aa4ad", 0.5) along_y(y_in, y_in + sheet_t) difference() {
      translate([-face_w / 2 - 25, 0]) square([face_w + 50, face_h + 25]);
      translate([-body.x / 2 - sheet_cut_clear, -1]) square([body.x + 2 * sheet_cut_clear, body.z + sheet_cut_clear + 1]);
   }
}

module assembled(t = view_trim, sheet = true) {
   color(c_body) body();
   color(c_face) face_in_place();
   color(c_label) translate([0, face_t, 0]) rotate([90, 0, 0]) translate([0, 0, face_t - 0.01]) linear_extrude(label_raise + 0.01) labels_2d();
   color(c_wheel) wheel_in_place();
   color(c_print) coupler_in_place();
   color(c_print) keepers_in_place();
   color("#eeeeee") rack_in_place(t);
   color(c_print) pinion_in_place(t);
   color("#555") bracket_in_place();
   rod_part();
   servo_part();
   enc_part();
   nano_view();
   bolts_part();
   if (sheet) sheet_part();
}

module exploded_view(e = explode) {
   color(c_body) body();
   color(c_face) translate([0, -e, 0]) face_in_place();
   color(c_label) translate([0, face_t - e, 0]) rotate([90, 0, 0]) translate([0, 0, face_t - 0.01]) linear_extrude(label_raise + 0.01) labels_2d();
   translate([0, 2 * e, 0]) {
      color(c_wheel) wheel_in_place();
      rod_part();
      color(c_print) coupler_in_place();
      enc_part();
   }
   translate([0, 3 * e, 0]) color(c_print) keepers_in_place();
   translate([0, 1.2 * e, 0]) color("#eeeeee") rack_in_place(0);
   translate([0, 2.2 * e, 0]) {
      color(c_print) pinion_in_place(0);
      color("#555") bracket_in_place();
      servo_part();
   }
   translate([0, 1.5 * e, 0]) nano_view();
}

// cut in the wheel's middle plane, seen from the right
module section_view(x = wheel_x) {
   intersection() {
      assembled(sheet = false);
      translate([x - 200, -50, -50]) cube([200, 300, 300]);
   }
}

// the top wall cut off, seen from behind
module inside_view() {
   intersection() {
      assembled(sheet = false);
      translate([-150, -50, -50]) cube([300, 300, top_in + 49.5]);
   }
}

// the indicator seen from behind, cut in front of the bracket: rack, pinion, channel
module indicator_view(t = view_trim) {
   intersection() {
      assembled(t, sheet = false);
      translate([-wall_in - 0.5, -50, -50]) cube([wall_in + ch_r[0], 50 + y_br[0] - 0.05, 300]);
   }
}

// Print places
translate([0, 0, -y_pl]) rotate([90, 0, 0]) body(); // Make module body
translate([0, face_h + 10, 0]) face(); // Make module face
wheel(); // Make module wheel
translate([0, 0, cp_x[1] - cp_x[0]]) rotate([180, 0, 0]) coupler(); // Make module coupler
keeper(rod_hole, rod_d / 2); // Make module keeper_left
keeper(coupler_hole, coupler_d / 2); // Make module keeper_right
translate([0, 0, rack_xr]) rotate([0, 90, 0]) rack(); // Make module rack
rotate([90, 0, 0]) bracket(); // Make module bracket
pinion(); // Make module pinion

//assembled(); // Make view main 70,0,-35
//assembled(); // Make view front 90,0,0
//exploded_view(); // Make view exploded 65,0,150
//inside_view(); // Make view inside 35,0,200
//indicator_view(); // Make view indicator 90,0,180
//section_view(); // Make view section 90,0,90
