// Yoke: hollow Cessna 172 control wheel
//
// The Cessna control wheel: a trapezoid hub in the middle that the control
// tube goes into, a bar under it with a flat top and a bottom that sags in
// a curve, and an arm ("horn") at each end, flared at its root and leaning
// 25 degrees inwards, going on into a head at about its width, square on
// its end (its top sloping down towards the middle) and standing out
// towards the pilot: a flat top pad with the PTT, a 45 degree pad for the
// thumb between it and the pilot face (the trim rocker on the left one)
// and a thumb rest (a separate print, screwed on) on its inner side:
// a shelf square to the side, tilted 30 degrees so its top faces the
// pilot, its top a concave round from the side into the shelf, its
// underside angled back into the side; all of it on the head's side.
// Everything is hollow: the wires run from the heads down the arms and
// along the bar to a CD74HC4067 mux in the hub, and the Cat5 cable from
// there through the hollow control tube to hub port 1 (mux port: SIG D22,
// AUX A11; README "Ports").
//
// Printing: 378 mm wide, so the wheel is cut into six shells, all printed
// outer face down (both faces are flat, the edges rounded), no supports:
// - the shape is cut in its middle plane (y=0) into a front half (towards
//   the panel, fwd) and a back half (towards the pilot, aft);
// - each half is cut across the bar into a center piece and two horn
//   pieces, at a different place for the front and the back half
//   (xs_fwd, xs_aft), so the pieces overlap like bricks: the front center
//   piece reaches over the joints of the back half and holds the back horn
//   pieces, the front horn pieces sit on the back horn pieces.
// - M3 screws from the front (the side the pilot does not see) go through
//   bosses in the front pieces into bosses in the back pieces. A lip
//   around the back pieces' rim goes into the front pieces and lines them up.
// - The heads are separate prints (top face down): a spigot under each goes
//   into the arm's open end, one M3 from the front holds it. They stand
//   out towards the pilot (head_bulge), which the flat shells can not.
// - The control tube (bought aluminium tube) goes into a collar, a separate
//   print that is bolted onto the front of the hub with 4 M4 (nuts inside)
//   and holds the tube with two M4 cross bolts; the tube's end stands on
//   the hub's front, the cable goes through a hole there.
//
// Inside: the mux on standoffs on the back center piece under the tube's
// hole, a block for the cable tie between them (strain relief, like the
// switch panel). Inputs: C0 left PTT, C1 trim nose down, C2 trim nose up,
// C3 right PTT, all to GND (active low); C4..C15 and AUX are free.
//
// Coordinates: x to the pilot's right, y forward (along the control tube,
// towards the panel), z up, z=0 the lowest point of the bar; the tube's
// axis is at x=0, z=z_shaft, the middle plane y=0.
//
// Parts to buy:
// - aluminium round tube tube_od x tube_wall (the control tube; the yoke
//   base it goes into is not part of this design)
// - 2x 12 mm momentary push button (ptt_*, MEASURE)
// - 1x momentary (ON)-OFF-(ON) mini rocker (trim_*, MEASURE)
// - CD74HC4067 breakout board, 2x M3x6 self tapping screws
// - stranded copper Cat5 patch cable, a cable tie
// - 22x M3x12 socket head screws (shells), 2x M3x10 (heads), 4x M3x8
//   socket head (thumb rests),
//   4x M4x20 + nuts + washers (collar onto the hub),
//   2x M4x40 + nuts (cross bolts through the tube)
//
// Assembly: screw the thumb rests onto the heads,
// put the buttons and the rocker into the heads (nuts inside),
// solder a wire pair to each. Screw the mux onto its standoffs. Push the
// Cat5 cable through the tube; bolt the collar onto the front center piece
// (nuts inside), push the tube into the collar up to the hub, drill it
// through the cross bolt holes and bolt it. Lay the back pieces face down
// side by side, push the head wires down the arms and along the bar,
// solder them and the cable to the mux (README "Cable to the hub"), tie the
// cable onto its block. Put the front pieces on (lips in) and screw them
// on, then the heads (spigots into the arms), one screw each.

$fn = 48;

bed = [255, 255];
explode = 40;

// --- Shape, in the wheel plane (proportions from photos, not measured) ---
yoke_d = 40;                 // depth along the tube, both faces flat
edge_r = 8;                  // rounding of the face edges
edge_steps = 4;              // the rounding is printed in steps, per edge
wall = 2.5;
fillet = 15;                 // inner corners (hub base, arm roots)
round = 8;                   // outer corners
bar_sag = 21;                // bar bottom: up this much at bar_x from the middle
bar_x = 175;
bar_top = [[56, 57], [150, 50]];  // bar top (x, z): at the hub, at the arm
hub_top = [40, 157];         // hub top: half width, height
z_shaft = 110;               // control tube axis
// Right arm: it leans inwards, the head sits square on its end
arm_end = [122, 165];        // center of its end
arm_tilt = 25;               // inwards from vertical
arm_w = 34;                  // across, at the end
// below the end: outer edge from the root up, inner edge from the end down
arm_outer = [[184, 27], [189, 37], [187, 52], [180, 72], [169, 102], [154, 136]];
arm_inner = [[123.5, 121.6], [136, 94.4], [147, 71.7], [153, 55]];

// --- Heads ---
// The arm goes on into the head at about its width: a flat top pad (the
// PTT) and a 45 degree pad towards the pilot (thumb, the trim rocker)
head = [36, 44];             // width, height (along the arm)
head_bulge = 14;             // stands out towards the pilot beyond the shells
head_chamfer = 22;           // the 45 degree pad between the top and the pilot face
head_r = 4;

// --- Thumb rest: a separate print screwed onto the head's inner side ---
// Only on the head's flat side, nothing below it. Its profile, square to
// the side: the top a concave round (thumb_round) from tangent with the
// side into a shelf at 90 degrees to it, a rounded tip, and the underside
// straight from the tip back into the side, as steep as the height allows.
// The profile runs along a line on the side tilted thumb_angle (pilot end
// lower), so the shelf's top faces the pilot. Two M3 through counterbores
// in the underside, into pads inside the head wall. Printed on its back.
thumb_angle = 30;            // the line along the side, up towards the front
thumb_pos = [-6, 20];        // middle of its back on the head's side (y, z)
thumb = [16, 26, 20];        // out of the side, along the line, back height
thumb_round = 9;             // concave round on the top
thumb_t = 3.5;               // shelf thickness at its tip
thumb_r = 6;                 // corners at the tip's ends
thumb_screw = [7, 5];        // along the line from the middle, up from the back's bottom
thumb_seat = 3;              // material under the screw heads
thumb_pad = [8, 5];          // pads inside the head wall: diameter, length
head_wall = 2.5;
spigot_h = 12;               // into the arm
spigot_wall = 2;
spigot_clear = 0.3;
head_screw_z = 6;            // below the arm end, M3 from the front into the spigot
head_screw_pad = 4;

// --- Cuts into printable pieces ---
xs_fwd = 115;                // front center piece |x| <= xs_fwd
xs_aft = 70;                 // back center piece |x| <= xs_aft
lip_w = 1.6;                 // lip on the back pieces' rim, into the front pieces
lip_h = 2.5;
lip_clear = 0.2;

// --- Shell screws: M3 from the front into the back pieces ---
boss_d = 10;
screw_len = 12;
screw_seat = 4;              // head seat in front of the middle plane
clear_d = 3.3;
pilot_d = 2.8;               // M3 self tapping
head_bore = 6.2;             // M3 socket head

// --- Control tube and collar, MEASURE the tube ---
tube_od = 25;                // aluminium tube, about the real 1"
tube_wall = 2;
tube_view_len = 160;         // view only
tube_clear = 0.3;
cable_hole = tube_od - 2 * tube_wall;  // through the hub front
collar_flange = [64, 6];     // diameter, thickness
collar_len = 45;             // from the hub front
collar_wall = 6;
collar_bolt_r = 25.5;        // 4x M4 onto the hub
collar_pad = 3;              // hub front wall thickened inside for them
m4_clear = 4.3;
m4_head = [7.5, 4];
m4_nut = [7, 3.2];           // across flats, thickness
cross_bolt_y = [16, 37];     // from the hub front: along x, along z

// --- PTT, MEASURE: 12 mm momentary push button ---
ptt = [true, true];          // left, right head
ptt_hole = 12.2;
ptt_d = 12;
ptt_head = [14, 3];          // bezel diameter, height above the head
ptt_body_len = 22;           // below the head's top, with the solder tabs
ptt_nut_af = 16;
ptt_pos = [0, 7];            // on the top pad, in front of the rocker

// --- Trim rocker, MEASURE: momentary (ON)-OFF-(ON) mini rocker ---
trim = [true, false];        // left, right head
trim_cut = [13, 19];         // panel cut-out, across x along the 45 degree pad
trim_depth = 20;             // body behind the face
trim_bezel = [15, 21, 2];    // view only

// --- Input multiplexer, CD74HC4067 breakout (as in switchpanel/switches.scad) ---
mux_board = [41, 18];        // measured
mux_board_t = 1.6;
mux_holes = [[-17.5, 0], [17.5, 0]];  // MEASURE: guess, from the board center
mux_hole_min = 3.1;          // MEASURE: the board's holes must take an M3 (drill them out if not)
mux_hole_d = mux_hole_min;
mux_pin_inset = 1.3;
mux_channels = 16;
mux_ctl_names = ["SIG", "S3", "S2", "S1", "S0", "EN", "VCC", "GND"];  // MEASURE: order on the board
mux_standoff_d = 6.5;
mux_standoff_h = 5;          // back wall to the board, room for the pin ends
mux_screw_hole = 2.8;        // M3 self tapping
mux_z = 58;                  // board center: in the hub, under the tube, control row up

// --- Cable to the hub: tied down between the tube and the mux ---
cable_d = 6;                 // Cat5 patch cable (measured)
tie = [3.6, 1.3];            // cable tie, width x thickness
tie_clear = 0.6;
tie_block = [10, 13, 6];     // along the cable (z) x across (x) x height off the wall
tie_groove = 1.5;
tie_z = 82;

gitrev_depth = 0.6;

// --- Calculated ---
function lerp(a, b, t) = a + (b - a) * t;
function bar_bottom(x) = bar_sag * pow(abs(x) / bar_x, 2);
function bar_top_z(x) = lerp(bar_top[0].y, bar_top[1].y, (abs(x) - bar_top[0].x) / (bar_top[1].x - bar_top[0].x));
function bar_mid(x) = (bar_bottom(x) + bar_top_z(x)) / 2;
arm_a = [-sin(arm_tilt), cos(arm_tilt)];     // along the right arm, up
arm_n = [cos(arm_tilt), sin(arm_tilt)];      // across it, outboard
// on the right arm: s along it from its end (negative: down), off outboard
function arm_pt(s, off) = arm_end + s * arm_a + off * arm_n;
arm_top_out = arm_pt(0, arm_w / 2);
arm_top_in = arm_pt(0, -arm_w / 2);
// Right half of the outline, from the bottom middle round to the hub's top
// middle; the arms run on beyond their ends so the cut there is open
right = concat(
   [for (x = [0 : 25 : 150]) [x, bar_bottom(x)]], [[170, bar_bottom(170)]],
   arm_outer,
   [arm_top_out, arm_top_out + 20 * arm_a, arm_top_in + 20 * arm_a, arm_top_in],
   arm_inner,
   [for (x = [bar_top[1].x, 120, 90]) [x, bar_top_z(x)]],
   [bar_top[0], hub_top, [0, hub_top.y]]);
outline = concat(right, [for (i = [len(right) - 2 : -1 : 1]) [-right[i].x, right[i].y]]);

hub_z0 = bar_top[0].y;
function hub_hw(z) = lerp(bar_top[0].x, hub_top.x, (z - hub_z0) / (hub_top.y - hub_z0));

y_fwd = yoke_d / 2;
y_aft = -yoke_d / 2;
y_in_aft = y_aft + wall;
y_in_fwd = y_fwd - wall;
x_max = max([for (p = arm_outer) p.x]);
z_arm = arm_top_out.y;

// Head: on the arm end, its front flush with the shells' front
head_y = [y_aft - head_bulge, y_fwd];
head_pad = [head_y[0] + head_chamfer / 2, head.y - head_chamfer / 2];  // 45 degree pad center (y, z)
head_top_y0 = head_y[0] + head_chamfer;      // top pad from here to the front
spigot = [arm_w - 2 * wall - 2 * spigot_clear, yoke_d - 2 * wall - 2 * spigot_clear];
spigot_r = edge_r - wall + 1.5;

// Screw bosses (x, z), right half, mirrored for the left: hub; overlap of
// the front center and back horn pieces; horn pieces (bar, arm root, arm)
horn_bar_x = 128;
boss_dz = (bar_top_z(horn_bar_x) - bar_bottom(horn_bar_x)) / 2 - wall - boss_d / 2 + 0.5;
function bar_boss(x, s) = [x, bar_mid(x) + s * boss_dz];
arm_boss_s = [spigot_h + boss_d / 2 + 3, 58];   // from the arm end
arm_boss_off = arm_w / 2 - wall - boss_d / 2 + 0.5;
bosses_right = concat(
   [[hub_top.x - 7, hub_top.y - 13], [bar_top[0].x - 10, hub_z0 + 15]],
   [for (x = [xs_aft + boss_d, xs_fwd - boss_d], s = [-1, 1]) bar_boss(x, s)],
   [bar_boss(horn_bar_x, -1), bar_boss(horn_bar_x, 1), [166, bar_bottom(166) + wall + boss_d / 2 + 2]],
   [for (s = arm_boss_s) arm_pt(-s, arm_boss_off)]);
bosses = concat(bosses_right, [for (b = bosses_right) [-b.x, b.y]]);
screw_tip = screw_seat - screw_len;

mux_y = y_in_aft + mux_standoff_h;           // board's back
tie_slot = tie + [tie_clear, tie_clear];

collar_bore = tube_od + tube_clear;
collar_od = tube_od + 2 * collar_wall;
collar_bolts = [for (a = [45 : 90 : 315]) [0, z_shaft] + collar_bolt_r * [cos(a), sin(a)]];

center_fwd_size = [2 * xs_fwd, hub_top.y];
horn_aft_size = [x_max - xs_aft, z_arm];

echo(yoke_size = [2 * x_max, yoke_d + head_bulge, arm_pt(head.y, arm_w / 2).y], center_fwd = center_fwd_size,
     horn_aft = horn_aft_size, screws = len(bosses));

// --- Checks ---
assert(edge_r - wall >= 2 && edge_r <= round, "Edge radius does not fit the shape");
assert(center_fwd_size.x <= bed.x && center_fwd_size.y <= bed.y, "Front center piece does not fit the bed");
assert(horn_aft_size.x <= bed.x && horn_aft_size.y <= bed.y, "Back horn piece does not fit the bed");
assert(head.x <= bed.x && yoke_d + head_bulge <= bed.y, "Head does not fit the bed");
assert(bar_top[0].x + 5 <= xs_aft, "Back center cut runs into the hub");
assert(xs_fwd - xs_aft >= 2 * boss_d + 10, "Front and back cuts too close for the overlap screws");
assert(xs_fwd + 2 <= horn_bar_x - boss_d, "Horn piece bosses too close to the cut");
assert(boss_dz - boss_d / 2 >= cable_d / 2, "Bar bosses leave no room for the wires");
assert(screw_tip >= y_aft + 2.5, "Shell screws come out of the back");
assert(boss_d >= head_bore + 3, "Boss wall around the screw heads too thin");
// heads: flat bottom over the arm end, buttons inside
assert(head.x - 2 * head_r >= arm_w - 2 * edge_r, "Head narrower than the arm end");
assert(arm_boss_s[0] - boss_d / 2 >= spigot_h + 1, "Head spigot runs into the top arm boss");
assert(arm_boss_off - boss_d / 2 >= cable_d / 2 - arm_w / 2 + wall + 4, "Arm bosses leave no room for the wires");
assert(abs(ptt_pos.x) + ptt_nut_af / cos(30) / 2 <= head.x / 2 - head_wall &&
       ptt_pos.y - ptt_nut_af / cos(30) / 2 >= head_top_y0 &&
       ptt_pos.y + ptt_nut_af / cos(30) / 2 <= head_y[1] - head_wall, "PTT nut does not fit under the top pad");
assert(ptt_pos.y - ptt_head.x / 2 >= head_top_y0 + head_r && ptt_pos.y + ptt_head.x / 2 <= head_y[1] - head_r,
       "PTT does not fit the flat top pad");
assert(ptt_body_len <= head.y - head_wall - 2, "PTT body runs out of the head's bottom");
assert(trim_cut.y + 4 <= head_chamfer * sqrt(2) - 2 * head_r && trim_cut.x + 4 <= head.x - 2 * head_r,
       "Trim rocker does not fit the 45 degree pad");
// the rocker body goes in square to the pad: its far end inside the head,
// its upper far corner behind the PTT body
assert(head_pad.y - (trim_depth + trim_cut.y / 2) / sqrt(2) >= head_wall + 1 &&
       head_pad.x + (trim_depth - trim_cut.y / 2) / sqrt(2) <= head_y[1] - head_wall - 1, "Trim rocker body too deep for the head");
assert(head_pad.x + (trim_depth + trim_cut.y / 2) / sqrt(2) <= ptt_pos.y - ptt_d / 2 - 1 ||
       head_pad.y - (trim_depth - trim_cut.y / 2) / sqrt(2) >= head.y - ptt_body_len + 1,
       "PTT body runs into the trim rocker");
// thumb rest: its back on the side's flat part (inside the rounded edges)
for (v = [-1, 1], w = [-1, 1]) let(p = thumb_side(v * thumb.y / 2, w * thumb.z / 2))
   assert(p.y >= head_r && p.x >= head_y[0] + head_r && p.x <= head_y[1] - head_r &&
          (p.y - (head.y - head_chamfer) - (p.x - head_y[0])) / sqrt(2) <= -head_r,
          "Thumb rest runs off the head's flat side");
assert(thumb_round + 2 <= thumb.x && thumb_t + thumb_round + 3 <= thumb.z, "Thumb rest round does not fit");
assert(thumb_depth(thumb_screw.y - head_bore / 2) >= thumb_seat + 0.5, "Thumb rest screw heads do not seat");
assert(-head.x / 2 + head_wall + thumb_pad.y <= -trim_cut.x / 2 - 1, "Thumb rest screw pads run into the trim rocker");
for (p = thumb_screws())
   assert(p.y - thumb_pad.x / 2 >= head_wall + 1, "Thumb rest screw pads run into the head's bottom");
// hub: collar, cable, tie, mux
assert(z_shaft + collar_flange.x / 2 <= hub_top.y - round - 2 &&
       collar_flange.x / 2 + wall <= hub_hw(z_shaft + collar_flange.x / 2), "Collar flange does not fit the hub");
assert(collar_bolt_r - m4_head.x / 2 >= collar_od / 2 + 1.5 && collar_bolt_r + m4_head.x / 2 <= collar_flange.x / 2,
       "Collar bolts do not fit the flange");
assert(min([for (b = bosses, c = collar_bolts) norm(b - c)]) >= boss_d / 2 + m4_nut.x, "Collar nuts run into the bosses");
assert(cable_hole < tube_od - 1, "The tube does not stand on the hub front");
assert(tie_z + tie_block.x / 2 <= z_shaft - cable_hole / 2 - 2, "Cable tie block runs into the hole");
assert(mux_z + mux_board.y / 2 + 3 <= tie_z - tie_block.x / 2, "Mux too close to the tie block");
assert(mux_board.x / 2 + 2 <= hub_hw(mux_z + mux_board.y / 2) - wall - edge_r &&
       mux_z - mux_board.y / 2 >= wall + edge_r, "Mux does not fit the hub");
assert(min([for (b = bosses, h = mux_holes) norm(b - [h.x, mux_z + h.y])]) >= boss_d / 2 + mux_board.y / 2,
       "Mux runs into a boss");

// --- Shape ---

// Beyond the arm ends
module arm_cut_2d() {
   for (m = [0, 1])
      mirror([m, 0])
         translate(arm_end)
            rotate(arm_tilt)
               translate([-arm_w, 0]) square([2 * arm_w, 100]);
}

// The outline with its corners rounded, offset inwards by o; open beyond
// the arm ends unless closed
module outline_2d(o = 0, closed = true) {
   difference() {
      offset(delta = -o)
         offset(r = round) offset(delta = -round)
            offset(r = -fillet) offset(delta = fillet)
               polygon(outline);
      if (closed)
         arm_cut_2d();
   }
}

// The right (s=1) or left arm's end: z along the arm, x outboard
module arm_frame(s) {
   mirror([s > 0 ? 0 : 1, 0, 0])
      translate([arm_end.x, 0, arm_end.y])
         rotate([0, -arm_tilt, 0])
            children();
}

// Along y from y0 to y1
module y_extrude(y0, y1) {
   translate([0, y1, 0])
      rotate([90, 0, 0])
         linear_extrude(y1 - y0)
            children();
}

// The shell's outer shape (o=0) or its cavity (o=wall): the outline
// extruded over the depth, its face edges rounded in steps
module body(o = 0) {
   re = edge_r - o;
   core = yoke_d / 2 - edge_r;
   y_extrude(-core, core)
      outline_2d(o, o == 0);
   for (s = [-1, 1], i = [1 : edge_steps]) {
      t = re * (i - 0.5) / edge_steps;
      ya = core + re * (i - 1) / edge_steps;
      yb = core + re * i / edge_steps;
      y_extrude(s > 0 ? ya - 0.01 : -yb, s > 0 ? yb : -ya + 0.01)
         outline_2d(o + re - sqrt(re * re - t * t), o == 0);
   }
}

// Along y at (x, z)
module y_cyl(p, d, y0, y1) {
   translate([p.x, y0, p.y])
      rotate([-90, 0, 0])
         cylinder(d = d, h = y1 - y0);
}

// Cable tie block on the back wall, the cable along z on it
module tie_block() {
   translate([0, y_in_aft - 0.01, tie_z])
      rotate([-90, 0, 0])
         rotate([0, 0, 90])
            difference() {
               translate([-tie_block.x / 2, -tie_block.y / 2, 0])
                  cube(tie_block + [0, 0, 0.01]);
               translate([-tie_slot.x / 2, -tie_block.y / 2 - 1, -1])
                  cube([tie_slot.x, tie_block.y + 2, tie_slot.y + 1]);
               translate([-tie_block.x / 2 - 1, 0, tie_block.z + cable_d / 2 - tie_groove])
                  rotate([0, 90, 0]) cylinder(d = cable_d, h = tie_block.x + 2);
            }
}

// Solid additions inside the shell
module inner_parts() {
   intersection() {
      body(0);
      union() {
         for (b = bosses)
            y_cyl(b, boss_d, y_aft, y_fwd);
         // hub front, thicker under the collar bolts
         y_cyl([0, z_shaft], collar_flange.x, y_in_fwd - collar_pad, y_in_fwd + 0.01);
      }
   }
   for (h = mux_holes)
      y_cyl([h.x, mux_z + h.y], mux_standoff_d, y_in_aft - 0.01, mux_y);
   tie_block();
}

module holes() {
   for (b = bosses) {
      y_cyl(b, pilot_d, screw_tip - 1, 0.01);
      y_cyl(b, clear_d, 0, screw_seat + 0.01);
      y_cyl(b, head_bore, screw_seat, y_fwd + 1);
   }
   y_cyl([0, z_shaft], cable_hole, 0, y_fwd + 1);
   for (b = collar_bolts)
      y_cyl(b, m4_clear, 0, y_fwd + 1);
   // head screws, through the front arm wall
   for (s = [-1, 1])
      arm_frame(s)
         y_cyl([0, -head_screw_z], clear_d, 0, y_fwd + 1);
   for (h = mux_holes)
      y_cyl([h.x, mux_z + h.y], mux_screw_hole, y_in_aft + 1, mux_y + 1);
}

// Version on the front of the bar, readable from the front
module gitrev(x) {
   translate([x, y_fwd + 0.01, bar_mid(x)])
      multmatrix([[-1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0]])
         translate([0, 0, -gitrev_depth])
            linear_extrude(gitrev_depth + 1)
               text("{{gitrev}}", size = 4, halign = "center", valign = "center");
}

// The whole shell with everything that is cut and added
module yoke() {
   difference() {
      union() {
         difference() {
            body(0);
            body(wall);
         }
         inner_parts();
      }
      holes();
      for (x = [-(xs_aft + xs_fwd) / 2, (xs_aft + xs_fwd) / 2, -144, 144])
         gitrev(x);
   }
}

// Lip around the back pieces' rim, standing into the front pieces (not
// at the arm ends, where the head spigots go in)
module lip() {
   difference() {
      union() {
         y_extrude(-1, 0.01)
            difference() {
               outline_2d(wall - 0.01, false);
               outline_2d(wall + lip_w, false);
            }
         y_extrude(0, lip_h)
            difference() {
               outline_2d(wall + lip_clear, false);
               outline_2d(wall + lip_w, false);
            }
      }
      for (b = bosses)
         y_cyl(b, boss_d + 2 * lip_clear + 1, -2, lip_h + 1);
      for (s = [-1, 1])
         arm_frame(s)
            translate([-arm_w, -5, -spigot_h - 1]) cube([2 * arm_w, 10, 100]);
   }
}

// --- Pieces ---

// side 1: front (y >= 0), -1: back (y <= 0); x from x0 to x1
module piece(x0, x1, side) render() {
   intersection() {
      yoke();
      translate([x0, side > 0 ? 0 : -50, -50])
         cube([x1 - x0, 50, 400]);
   }
   if (side < 0)
      intersection() {
         difference() {
            lip();
            holes();
         }
         translate([x0 + 0.01, -50, -50]) cube([x1 - x0 - 0.02, 100, 400]);
      }
}

module center_fwd() piece(-xs_fwd, xs_fwd, 1);
module center_aft() piece(-xs_aft, xs_aft, -1);
module horn_fwd(s) if (s > 0) piece(xs_fwd, x_max + 1, 1); else piece(-x_max - 1, -xs_fwd, 1);
module horn_aft(s) if (s > 0) piece(xs_aft, x_max + 1, -1); else piece(-x_max - 1, -xs_aft, -1);

module rrect(size, r) {
   offset(r = r) square(size - 2 * [r, r], center = true);
}

// Along x from x0 to x1, a 2D shape in (y, z)
module x_extrude(x0, x1) {
   translate([x0, 0, 0])
      rotate([90, 0, 90])
         linear_extrude(x1 - x0)
            children();
}

// Head side profile (y, z), offset inwards by o: front, top pad, 45 degree pad, pilot face
module head_profile_2d(o) {
   c = head_chamfer - o * (2 - sqrt(2));
   y0 = head_y[0] + o;
   y1 = head_y[1] - o;
   h = head.y - o;
   polygon([[y1, o], [y1, h], [y0 + c, h], [y0, h - c], [y0, o]]);
}

// The head block offset inwards by o, its edges rounded (in steps across x)
module head_block(o) {
   r = max(head_r - o, 0.5);
   hull()
      for (t = [0, 30, 60, 90]) {
         w = head.x / 2 - o - r + r * sin(t);
         x_extrude(-w, w)
            offset(delta = -r * (1 - cos(t)))
               offset(r = r) offset(delta = -r)
                  head_profile_2d(o);
      }
}

// Thumb rest for the head's inner side (-x) in the head's frame. Local
// frame: u out of the side, v along the tilted line, w square to it in
// the side (up the back, from its middle)
function thumb_side(v, w) = thumb_pos + v * [cos(thumb_angle), sin(thumb_angle)]
                                      + w * [-sin(thumb_angle), cos(thumb_angle)];
function thumb_shelf() = thumb.z - thumb_round;      // shelf top, w from the back's bottom
// its depth (u) at w from the back's bottom, below the shelf
function thumb_depth(w) = thumb.x * w / (thumb_shelf() - thumb_t);
function thumb_screws() = [for (v = [-1, 1]) thumb_side(v * thumb_screw.x, thumb_screw.y - thumb.z / 2)];
module thumb_profile_2d() {   // (u, w), w from the back's bottom
   s = thumb_shelf();
   rt = thumb_t / 2;
   hull() {
      polygon([[0, 0], [0, s], [thumb.x - rt, s], [thumb.x - rt, s - thumb_t]]);
      translate([thumb.x - rt, s - rt]) circle(r = rt);
   }
   difference() {
      translate([0, s - 0.01]) square([thumb_round, thumb_round + 0.01]);
      translate([thumb_round, s + thumb_round]) circle(r = thumb_round, $fn = 96);
   }
}
module thumb_frame() {
   translate([-head.x / 2, thumb_pos.x, thumb_pos.y])
      mirror([1, 0, 0])
         rotate([thumb_angle, 0, 0])
            children();
}
module thumb_rest() render() {
   thumb_frame()
      difference() {
         intersection() {
            rotate([90, 0, 0])
               translate([0, -thumb.z / 2, 0])
                  linear_extrude(thumb.y, center = true)
                     thumb_profile_2d();
            translate([0, 0, -thumb.z])
               linear_extrude(2 * thumb.z)
                  offset(r = thumb_r) offset(delta = -thumb_r)
                     translate([-thumb_r, -thumb.y / 2]) square([thumb.x + thumb_r, thumb.y]);
         }
         for (v = [-1, 1])
            translate([0, v * thumb_screw.x, thumb_screw.y - thumb.z / 2])
               rotate([0, 90, 0]) {
                  translate([0, 0, -1]) cylinder(d = clear_d, h = thumb.x + 2);
                  translate([0, 0, thumb_seat]) cylinder(d = head_bore, h = thumb.x);
               }
      }
}

module thumb_in_place(s) arm_frame(s) thumb_rest();

// On the 45 degree pad: z out of it, y up along it
module pad_frame() {
   translate([0, head_pad.x, head_pad.y])
      rotate([45, 0, 0])
         children();
}

// Head on the right arm (s=1) or the left one (s=-1), in place: its
// bottom on the arm end, a spigot down into the arm
module head(s) render() {
   i = s > 0 ? 1 : 0;
   arm_frame(s)
         difference() {
            union() {
               difference() {
                  head_block(0);
                  head_block(head_wall);
               }
               // pads for the thumb rest screws, inside the inner side
               for (p = thumb_screws())
                  translate([-head.x / 2 + 0.5, p.x, p.y])
                     rotate([0, 90, 0])
                        cylinder(d = thumb_pad.x, h = head_wall - 0.5 + thumb_pad.y);
               // spigot, with a pad for the screw from the front
               translate([0, 0, -spigot_h])
                  linear_extrude(spigot_h + head_wall)
                     difference() {
                        rrect(spigot, spigot_r);
                        rrect(spigot - 2 * [spigot_wall, spigot_wall], spigot_r - spigot_wall);
                     }
               intersection() {
                  translate([0, 0, -spigot_h]) linear_extrude(spigot_h) rrect(spigot, spigot_r);
                  y_cyl([0, -head_screw_z], 8, spigot.y / 2 - spigot_wall - head_screw_pad, spigot.y / 2);
               }
            }
            // open into the arm
            translate([0, 0, -spigot_h - 1])
               linear_extrude(spigot_h + head_wall + 2)
                  rrect(spigot - 2 * [spigot_wall, spigot_wall], spigot_r - spigot_wall);
            y_cyl([0, -head_screw_z], pilot_d, 0, spigot.y);
            // pilot holes for the thumb rest's screws
            for (p = thumb_screws())
               translate([-head.x / 2 - 1, p.x, p.y])
                  rotate([0, 90, 0])
                     cylinder(d = pilot_d, h = head_wall + thumb_pad.y);
            if (ptt[i])
               translate([ptt_pos.x, ptt_pos.y, head.y - head_wall - 1])
                  cylinder(d = ptt_hole, h = head_wall + 2);
            if (trim[i])
               pad_frame()
                  translate([0, 0, -head_wall - 1])
                     linear_extrude(head_wall + 2)
                        square([trim_cut.x, trim_cut.y], center = true);
            // version inside the front wall
            translate([0, head_y[1] - head_wall + 0.01, head.y - 14])
               rotate([90, 0, 0])
                  linear_extrude(gitrev_depth + 0.01)
                     text("{{gitrev}}", size = 3, halign = "center", valign = "center");
         }
}

// Collar on the hub front: the flange at y_fwd, the socket forward
module collar() render() {
   translate([0, y_fwd, z_shaft])
      rotate([-90, 0, 0])
         difference() {
            union() {
               cylinder(d = collar_flange.x, h = collar_flange.y, $fn = 96);
               cylinder(d = collar_od, h = collar_len, $fn = 96);
               translate([0, 0, collar_flange.y - 0.01])
                  cylinder(d1 = collar_od + 10, d2 = collar_od, h = 6, $fn = 96);
            }
            translate([0, 0, -1])
               cylinder(d = collar_bore, h = collar_len + 2, $fn = 96);
            for (a = [45 : 90 : 315])
               rotate([0, 0, a])
                  translate([collar_bolt_r, 0, -1])
                     cylinder(d = m4_clear, h = collar_flange.y + 10);
            // cross bolts with a nut trap at one end
            for (i = [0, 1])
               translate([0, 0, cross_bolt_y[i]])
                  rotate([0, 0, i * 90])
                     rotate([0, 90, 0]) {
                        translate([0, 0, -collar_od])
                           cylinder(d = m4_clear, h = 2 * collar_od);
                        translate([0, 0, collar_od / 2 - 3.5])
                           cylinder(d = m4_nut.x / cos(30) + 0.4, h = 10, $fn = 6);
                     }
            translate([0, collar_flange.x / 2 - 4, -0.01])
               mirror([1, 0, 0])
                  linear_extrude(gitrev_depth + 0.01)
                     text("{{gitrev}}", size = 3, halign = "center", valign = "center");
         }
}

// --- Print placement: outer faces down ---
module print_fwd() translate([0, 0, y_fwd]) rotate([-90, 0, 0]) children();
module print_aft() translate([0, 0, -y_aft]) rotate([90, 0, 0]) children();
// Thumb rest on the flange's back: the head's side on the bed
module print_thumb() translate([0, 0, -head.x / 2]) rotate([0, 90, 0]) children();

module print_head(s) translate([0, 0, head.y]) rotate([180, 0, 0]) rotate([0, arm_tilt, 0])
   translate([-arm_end.x, 0, -arm_end.y]) mirror([s > 0 ? 0 : 1, 0, 0]) children();

// --- Views (rendered to PNG by "make views") ---

c_shell = "#2b2d31";
c_shell2 = "#3a3d42";
c_collar = "#3d7bd9";
c_steel = "#b9c0c8";
c_pcb = "#1f7a3a";
c_body = "#1d1f22";
c_cable = "#3d7bd9";
c_red = "#e8433a";
c_wire = ["#f2a33a", "#e8e8e8", "#f2a33a", "#e8e8e8", "#3d7bd9", "#e8e8e8", "#7a4a2a", "#e8e8e8"];

module tube_part() {
   color(c_steel)
      y_cyl([0, z_shaft], tube_od, y_fwd, y_fwd + tube_view_len);
}

// Buttons and the rocker in the heads
module controls_part(sides = [-1, 1]) {
   for (s = sides) {
      i = s > 0 ? 1 : 0;
      arm_frame(s) {
            if (ptt[i])
               translate([ptt_pos.x, ptt_pos.y, head.y]) {
                  color(c_steel) cylinder(d = ptt_head.x, h = ptt_head.y - 1.5);
                  color(c_red) cylinder(d = ptt_d - 4, h = ptt_head.y + 2);
                  color(c_body) translate([0, 0, -ptt_body_len]) cylinder(d = ptt_d, h = ptt_body_len);
                  color(c_steel)
                     translate([0, 0, -head_wall - 2.5])
                        cylinder(d = ptt_nut_af / cos(30), h = 2.5, $fn = 6);
               }
            if (trim[i])
               pad_frame()
                  color(c_body) {
                     translate([0, 0, trim_bezel.z / 2]) cube([trim_bezel.x, trim_bezel.y, trim_bezel.z], center = true);
                     translate([0, 0, trim_bezel.z]) rotate([0, 90, 0]) cylinder(d = 10, h = trim_cut.x - 3, center = true);
                     translate([0, 0, -trim_depth / 2]) cube([trim_cut.x, trim_cut.y, trim_depth], center = true);
                  }
         }
   }
}

function mux_ch_pin(i) = [(7.5 - i) * 2.54, mux_z - mux_board.y / 2 + mux_pin_inset];
function mux_ctl_pin(name) = [(3.5 - search([name], mux_ctl_names)[0]) * 2.54,
                              mux_z + mux_board.y / 2 - mux_pin_inset];

// Board with the control row at the top, the channel row at the bottom
module mux_part() {
   color(c_pcb)
      difference() {
         translate([0, mux_y + mux_board_t / 2, mux_z])
            cube([mux_board.x, mux_board_t, mux_board.y], center = true);
         for (h = mux_holes)
            y_cyl([h.x, mux_z + h.y], mux_hole_d, mux_y - 1, mux_y + 3);
      }
   color(c_body)
      translate([0, mux_y + mux_board_t + 0.75, mux_z])
         cube([10, 1.5, 5.3], center = true);
   color(c_steel)
      for (p = concat([for (i = [0 : mux_channels - 1]) mux_ch_pin(i)],
                      [for (n = mux_ctl_names) mux_ctl_pin(n)]))
         y_cyl(p, 0.8, mux_y + mux_board_t, mux_y + mux_board_t + 2);
}

module wire(path, d = 1.4) {
   for (i = [0 : len(path) - 2])
      hull() {
         translate(path[i]) sphere(d = d, $fn = 8);
         translate(path[i + 1]) sphere(d = d, $fn = 8);
      }
}

// Cat5 out of the tube, tied onto the block, the wires to the control row;
// a wire from each button down the arm and along the bar to the channel row
module wiring_part() {
   yt = y_in_aft + tie_block.z - tie_groove + cable_d / 2;   // cable axis on the block
   z_end = tie_z - tie_block.x / 2 - 1;                     // jacket end
   color(c_cable)
      wire([[0, y_fwd + 40, z_shaft], [0, y_in_fwd - 2, z_shaft], [0, yt + 8, z_shaft - 2],
            [0, yt + 1, tie_z + tie_block.x / 2 + 3], [0, yt, z_end]], cable_d);
   color("#f0f0f0")
      translate([0, yt, tie_z])
         difference() {
            cylinder(d = cable_d + 2 * tie.y, h = tie.x, center = true);
            cylinder(d = cable_d, h = tie.x + 1, center = true);
         }
   for (j = [0 : len(mux_ctl_names) - 1]) {
      p = mux_ctl_pin(mux_ctl_names[j]);
      if (mux_ctl_names[j] != "EN")
         color(c_wire[j])
            wire([[(j - 3.5) * 0.8, yt, z_end], [p.x * 0.6, yt - 1, z_end - 3],
                  [p.x, mux_y + mux_board_t + 2, p.y + 1]], 1);
   }
   // C0 left PTT, C1/C2 trim, C3 right PTT, down the inner side of the arm
   function arm_path(s, off) = [for (q = [arm_pt(10, off), arm_pt(-10, off), arm_pt(-50, off - 2),
                                         arm_pt(-85, off), arm_pt(-108, off + 8), [150, 30 + off / 3]])
                                [s * q.x, q.y]];
   runs = [[-1, 0, c_red], [-1, 1, "#f2c23a"], [-1, 2, "#3dbf5a"], [1, 3, c_red]];
   for (k = [0 : len(runs) - 1]) {
      r = runs[k];
      s = r[0];
      p = mux_ch_pin(r[1]);
      dy = -6 + k * 1.6;
      color(r[2])
         wire(concat([for (q = arm_path(s, -6)) [q.x, dy, q.y]],
                     [[s * 130, dy, bar_mid(130) + 2], [s * 48, dy, bar_mid(60) + 2],
                      [p.x, dy, p.y - 6], [p.x, mux_y + mux_board_t + 2, p.y]]));
   }
   // the GND wire, daisy chained over the left buttons
   gnd = mux_ctl_pin("GND");
   color("#222222")
      wire(concat([for (q = arm_path(-1, -9)) [q.x, -3, q.y]],
                  [[-130, -3, bar_mid(130) - 2], [-48, -3, bar_mid(60) - 2],
                   [-mux_board.x / 2 - 4, -3, mux_z + mux_board.y / 2 + 3], [gnd.x, mux_y + mux_board_t + 2, gnd.y]]));
}

module collar_bolts_part() {
   color(c_steel) {
      for (b = collar_bolts) {
         y_cyl(b, m4_head.x, y_fwd + collar_flange.y, y_fwd + collar_flange.y + m4_head.y);
         translate([b.x, y_in_fwd - collar_pad - m4_nut.y, b.y])
            rotate([-90, 0, 0]) cylinder(d = m4_nut.x / cos(30), h = m4_nut.y, $fn = 6);
      }
      for (i = [0, 1])
         translate([0, y_fwd + cross_bolt_y[i], z_shaft])
            rotate([0, i * 90, 0])
               rotate([0, 90, 0])
                  cylinder(d = 4, h = 40, center = true);
   }
}

module fwd_parts() {
   color(c_shell) center_fwd();
   color(c_shell2) for (s = [-1, 1]) horn_fwd(s);
}

module aft_parts() {
   color(c_shell2) center_aft();
   color(c_shell) for (s = [-1, 1]) horn_aft(s);
}

module heads_part() {
   color(c_shell) for (s = [-1, 1]) head(s);
   color(c_shell2) for (s = [-1, 1]) thumb_in_place(s);
   controls_part();
}

module assembled_view() {
   fwd_parts();
   aft_parts();
   heads_part();
   color(c_collar) collar();
   collar_bolts_part();
   tube_part();
}

// The back pieces with everything in them, seen from the front
module inside_view() {
   aft_parts();
   mux_part();
   wiring_part();
   controls_part();
}

module exploded_view(e = explode) {
   for (s = [-1, 1]) {
      translate([s * e, 2 * e, 0]) color(c_shell2) horn_fwd(s);
      translate([s * e, 0, 0]) color(c_shell) horn_aft(s);
      translate([s * e, 0, 1.5 * e]) color(c_shell) head(s);
      translate([s * e, 0, 1.5 * e]) controls_part([s]);
      translate([s * 2 * e, 0, 1.5 * e]) color(c_shell2) thumb_in_place(s);
   }
   translate([0, 2 * e, 0]) color(c_shell) center_fwd();
   color(c_shell2) center_aft();
   mux_part();
   translate([0, 3 * e, 0]) {
      color(c_collar) collar();
      translate([0, e, 0]) tube_part();
   }
}

print_fwd() center_fwd(); // Make module center_fwd
print_aft() center_aft(); // Make module center_aft
print_fwd() horn_fwd(-1); // Make module horn_fwd_left
print_fwd() horn_fwd(1); // Make module horn_fwd_right
print_aft() horn_aft(-1); // Make module horn_aft_left
print_aft() horn_aft(1); // Make module horn_aft_right
print_head(-1) head(-1); // Make module head_left
print_head(1) head(1); // Make module head_right
mirror([1, 0, 0]) print_thumb() thumb_rest(); // Make module thumb_left
print_thumb() thumb_rest(); // Make module thumb_right
translate([0, 0, -y_fwd]) rotate([90, 0, 0]) translate([0, 0, -z_shaft]) collar(); // Make module collar

//assembled_view(); // Make view main 70,0,-25
//assembled_view(); // Make view pilot 90,0,0
//assembled_view(); // Make view front 80,0,160
//inside_view(); // Make view inside 90,0,180
//exploded_view(); // Make view exploded 65,0,-35
