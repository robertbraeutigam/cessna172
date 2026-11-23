// Cockpit frame
//
// Two parts of 2020 extrusion: the front part (vertical, in front of the
// desk edge: from the bottom bar under the lower panel, which hangs below
// the desk top, up to the top bars, the left one low over the yoke
// column, the right one over the radios; the apron hanging under the
// throttle) and the desk part (a ladder on the desk, cut at the yoke, which
// stands on the desk with its own clamps), bolted together and braced at
// 45 degrees; three ACM sheets over the front (left, lower right, upper
// right) with a cut-out for every component, laid out like the X-Plane
// 172N panel. Values, layout and checks are in frame.inc.scad; this file
// has the views and the cut list (echo). It has no printed parts.
//
// Bought parts (lengths: see the echo of the build, or the README):
// - 2020 extrusion, front part (cut to length): bottom bar, 4 uprights
//   (left end, split, step, right end; the left end one as high as the right part), 2 waist bars, top bar left and
//   right, throttle bar, 2 apron hangers, lower bar
// - 2020 extrusion, desk part (stock lengths): front rail left and right,
//   rear rail, 3 crossbars, 3 braces (cut square)
// - 6 45 degree connectors for 2020, one at each brace end
// - corner brackets, M5 screws and T-nuts (6 mm slot)
// - 3 mm ACM sheet: the left (L shaped), lower right, upper right and apron sheets
// - 2 screw clamps with rubber jaws, at least ext + desk.z opening
//   (clamp_open, clamp_reach), to clamp the rail ends onto the desk
// - felt pads on the uprights' and waist bars' backs, against the desk edge
//
// Assembly:
// 1. Front part, flat on the floor: the bottom bar, the left end, split
//    and right end uprights on it, the waist bars on the split upright
//    against the right end one, the step upright on them, the top bars
//    (the left one between the left end and the step upright, the right
//    one on the step and right end uprights), the throttle
//    bar on the split and right end uprights' backs, the hangers under the
//    bottom bar and the lower bar between their ends, all with corner
//    brackets.
// 2. Cut the sheets (sheet_* and cuts, col_cut (round), sheet_screws,
//    apron_screws in the echo, the "sheet" view), drill their screw
//    holes, and screw them onto the front slots with T-nuts.
// 3. Desk part: the front rail halves, the rear rail and the crossbars.
// 4. Put the desk part on the desk, stand the front part in front of the
//    desk edge, the uprights' and waist bars' backs against the edge (felt
//    pads), the lower panel hanging below the desk top, and bolt it on: a
//    corner bracket from the left end, step and right end uprights' backs
//    to the front rail, the braces from them to the crossbars with a 45
//    degree connector on each end, in the obtuse angle. Clamp each rail end
//    (ear) onto the desk with a screw clamp.
// 5. Put the yoke on the desk between the front rail halves, its front on
//    the desk edge and its shaft through the column hole, and clamp it on
//    the desk edge with its own clamps (behind the sheet).
// 6. Push the throttle box through its cut-out onto the throttle bar until
//    its face is on the sheet, bolt its floor into the bar
//    (throttle_bolts), drill the sheet through its flange holes and screw
//    the flange on (M3, nuts behind the sheet). The flaps panel goes
//    through its cut-out right of it onto the bar, its plate screwed onto
//    the sheet; the pedestal goes in like the throttle box onto the lower
//    bar, the parking brake onto the bottom bar, when they exist.
// 7. Bolt the compass stand into T-nuts in the right top bar's top slot
//    (compass_bolts).
//
// Stage 2 (physical instruments): the left top bar moved up to the right
// one's height, a full height left sheet with the instrument holes
// (inst_c, outlined in the "sheet" view); see the README.

include <frame.inc.scad>

$fn = 40;

// --- View colors ---
c_alu = "#c3c9d0";
c_sheet = "#4a4f57";
c_desk = "#c8a77a";
c_device = "#2b2e33";
c_display = "#c0392b";
c_box = "#5b6f8a";
c_switch = "#3a3d42";

echo(frame = [frame_w, frame_d], left_top = sheet_h, right_top = sheet_h_r, bottom = sheet_bottom);
echo(front_part_2020_cut = [["bottom bar", frame_w], ["uprights", [for (u = uprights) u[2] - u[1]]],
                            ["2 waist bars", frame_w - ext - x_a], ["top bar left", x_r - ext], ["top bar right", frame_w - x_r],
                            ["throttle bar", throttle_bar[1] - throttle_bar[0]],
                            ["2 hangers", hanger_len], ["lower bar", apron_bar_len]]);
echo(desk_part_2020 = [["front rail left", rails[0][1] - rails[0][0]], ["front rail right", rails[1][1] - rails[1][0]],
                       ["rear rail", frame_w], [str(len(crossbar_xs), " crossbars"), crossbar_len],
                       [str(len(brace_xs), " braces, cut square"), brace_len]]);
echo(sheet_left_L = sheet_left, sheet_lower_right = sheet_lower_right, sheet_upper_right = sheet_upper_right,
     screws = len(sheet_screws));
echo(switch_z = switch_z, switch_ign_rise = switch_ign_rise, throttle_z = throttle_z, col = [col_x, col_z]);
echo(ign_cut = ign_cut, switch_cut = switch_cut, primer_cut = primer_cut, park_cut = park_cut,
     col_cut_round = [col_x, col_z, yoke_hole_d], throttle_cut = throttle_cut, flaps_cut = flaps_cut,
     radio_cut = radio_cut, stack_cut_reserved = stack_cut);
echo(stage2_instruments = [for (i = [0 : len(inst_c) - 1]) [inst_names[i], inst_c[i]]], inst_cut_d = inst_cut_d,
     stage2_left_sheet = [x_r, sheet_h_r - sheet_bottom]);
echo(sheet_screws = sheet_screws, throttle_bolts = throttle_bolts);
echo(apron_sheet = [apron[2] - apron[0], apron[3] - apron[1]], apron_screws = len(apron_screws));
echo(pedestal_cut = pedestal_cut, pedestal_bolts = pedestal_bolts);
echo(compass_bolts = compass_bolts);
echo(m5 = len(sheet_screws) + len(apron_screws) + 2 + 2 + 2 + len(compass_bolts), desk_clamps = len(clamp_xs), clamp_y = clamp_y);

// --- Frame ---

module bar(p0, size) {
   color(c_alu) translate(p0) cube(size);
}

// 45 degree brace behind the upright at x, cut square: its inner edge
// from the upright's back at brace_top down to the crossbar top, and a 45
// degree connector in the obtuse angle at each end (drawn on its +x side)
module brace(x) {
   a = [ext, brace_top];
   d = [1, -1] / sqrt(2);       // along the brace (y, z)
   o = [1, 1] / sqrt(2);        // away from the corner
   multmatrix([[1, 0, 0, x], [0, d.x, o.x, a.x], [0, d.y, o.y, a.y], [0, 0, 0, 1]])
      color(c_alu) cube([ext, brace_len, ext]);
   // connectors (view only): one leg on the brace, one on the upright / crossbar
   color("#5a6068") translate([x + ext, 0, 0]) rotate([0, 90, 0]) linear_extrude(3)
      for (e = [[a, [0, 1], d], [a + brace_len * d, [1, 0], -d]])
         hull() {
            translate([-(e[0].y + 2), e[0].x + 2]) square(1);
            translate([-(e[0].y + 2 + 30 * e[1].y), e[0].x + 2 + 30 * e[1].x]) square(1);
            translate([-(e[0].y + 2 + 30 * e[2].y), e[0].x + 2 + 30 * e[2].x]) square(1);
         }
}

module front_part() {
   for (b = front_bars)
      bar([b[0], 0, b[2]], [b[1] - b[0], ext, ext]);
   for (u = uprights)
      bar([u[0], 0, u[1]], [ext, ext, u[2] - u[1]]);
   bar([throttle_bar[0], ext, throttle_bar[2]], [throttle_bar[1] - throttle_bar[0], ext, ext]);
   // apron
   for (x = hangers)
      bar([x, 0, apron_bar_z], [ext, ext, sheet_bottom - apron_bar_z]);
   bar([apron_bar[0], 0, apron_bar_z - ext], [apron_bar_len, ext, ext]);
}

module desk_frame_part() {
   for (r = rails)
      bar([r[0], ext, 0], [r[1] - r[0], ext, ext]);
   bar([0, rear_y, 0], [frame_w, ext, ext]);
   for (x = crossbar_xs)
      bar([x, 2 * ext, 0], [ext, crossbar_len, ext]);
   for (x = brace_xs)
      brace(x);
}

module frame_part() {
   front_part();
   desk_frame_part();
}

// Bought screw clamp, view only: the fixed jaw on the rail end, the spine
// in front of the rail, the screw jaw on the desk underside
module desk_clamp_part(x) {
   bar_w = 12;                                // the clamp's bars, across (x) and thick
   spine_y = clamp_y - clamp_reach;           // spine inner face
   top = ext + 3;                             // over the rubber jaw
   low = ext + 3 - clamp_open - 12;        // bottom bar top, the opening left as screw travel
   translate([x, 0, 0]) {
      color("#5a6068") {
         translate([-bar_w / 2, spine_y - bar_w, low - bar_w]) cube([bar_w, bar_w, top + bar_w - low + bar_w]);
         translate([-bar_w / 2, spine_y - bar_w, top]) cube([bar_w, clamp_reach + bar_w + clamp_pad_d / 2, bar_w]);
         translate([-bar_w / 2, spine_y - bar_w, low - bar_w]) cube([bar_w, clamp_reach + bar_w + 8, bar_w]);
      }
      color("#b9c0c8") translate([0, clamp_y, low - bar_w - 25]) {
         cylinder(d = 8, h = -desk.z - 6 - (low - bar_w - 25));
         translate([0, 0, 6]) rotate([0, 90, 0]) cylinder(d = 7, h = clamp_w + 15, center = true);
         translate([0, 0, -desk.z - 6 - (low - bar_w - 25)]) cylinder(d = clamp_pad_d, h = 3);
      }
      color("#222") translate([0, clamp_y, 0]) {
         translate([0, 0, ext]) cylinder(d = clamp_pad_d, h = 3);
         translate([0, 0, -desk.z - 3]) cylinder(d = clamp_pad_d, h = 3);
      }
   }
}

module clamps_part() {
   for (x = clamp_xs) desk_clamp_part(x);
}

// --- Sheet, x / z on the sheet ---

module rect(r) {
   translate([r[0], r[1]]) square([r[2] - r[0], r[3] - r[1]]);
}

// the left (L shaped), lower right and upper right sheet (a hairline apart in the views)
module sheet_2d() {
   gap = 0.25;
   difference() {
      union() {
         rect(sheet_left[0] - [0, 0, gap, 0]);
         rect(sheet_left[1] - [0, 0, gap, 0]);
         rect(sheet_lower_right + [gap, 0, 0, -gap]);
         rect(sheet_upper_right + [gap, gap, 0, 0]);
      }
      for (c = cuts) rect(c);
      translate([col_x, col_z]) circle(d = yoke_hole_d);
      for (p = sheet_screws)
         translate(p) circle(d = m5_d);
   }
}

// apron sheet, x / z on the sheet (z < 0)
module apron_2d() {
   difference() {
      rect(apron - [0, 0, 0, 0.25]);
      rect(pedestal_cut);
      for (p = apron_screws)
         translate(p) circle(d = m5_d);
   }
}

module sheet_part() {
   color(c_sheet)
      rotate([90, 0, 0])
         linear_extrude(sheet_t) {
            sheet_2d();
            apron_2d();
         }
}

// --- Components, view only ---

module desk_part() {
   color(c_desk)
      translate([-100, frame_overhang, -desk.z])
         cube([frame_w + 200, desk.y, desk.z]);
}

// Yoke on its stand, the shaft in, through the column hole
module yoke_part() {
   wy = yoke_front_y - yoke_reach + yoke_wheel_t / 2;   // wheel middle
   color(c_device) {
      translate([yoke_x[0], yoke_front_y, 0])
         cube(yoke_housing);
      translate([col_x, yoke_front_y + 1, col_z])
         rotate([90, 0, 0]) cylinder(d = yoke_shaft_d, h = yoke_front_y + 1 - wy);
      translate([col_x, wy, col_z]) {
         cube([yoke_wheel_w - 80, 24, 26], center = true);
         for (s = [-1, 1])
            translate([s * (yoke_wheel_w / 2 - 20), 0, 0])
               rotate([0, s * 15, 0]) cylinder(d = 32, h = 110, center = true);
      }
   }
   // its clamps on the desk edge
   color("#444")
      for (c = yoke_clamp_x)
         translate([c[0], yoke_front_y - yoke_clamp_t, desk_low - yoke_clamp_low])
            difference() {
               cube([c[1] - c[0], yoke_clamp_t + 40, yoke_clamp_low - desk_low + 5]);
               translate([-1, yoke_clamp_t, yoke_clamp_low - 8]) cube([c[1] - c[0] + 2, 41, -desk_low + 8]);
            }
   // the force feedback yoke's housing (stage 2, outline)
   %translate([yoke_x[0], ffb_front_y, 0]) cube([yoke_housing.x, yoke_housing.y, ffb_h]);
}

module radio_part() {
   translate([radio_x, -sheet_t, radio_front_z0]) {
      color(c_device) {
         translate([-radio_front.x / 2, -radio_front_t, 0])
            cube([radio_front.x, radio_front_t, radio_front.y]);
         translate([-radio_body.x / 2, 0, (radio_front.y - radio_body.y) / 2])
            cube([radio_body.x, radio_depth, radio_body.y]);
      }
      color(c_display)
         for (sx = [-1, 1], z = [0.3, 0.7])
            translate([sx * radio_front.x / 4 - 45, -radio_front_t - 0.5, z * radio_front.y - 6])
               cube([90, 1, 12]);
   }
}

module switch_panel_part() {
   f = switch_flange;
   y_face = -sheet_t - 3;           // panel_t, the face on the sheet
   z_ign = ign_z + f;               // backs' bottoms
   z_sw = switch_z + f;
   // [back x0, back z0, back width] of the ignition and the switches
   backs = [[x_sw0 + f, z_ign, switch_ign_w], [x_s0, z_sw, switch_back.x]];
   color(c_sheet)
      for (p = backs) {
         translate([p[0] - f, y_face, p[1] - f]) cube([p[2] + 2 * f, 3, switch_back.y + 2 * f]);
         // rim, through the sheet
         difference() {
            translate([p[0], y_face + 3, p[1]]) cube([p[2], 8, switch_back.y]);
            translate([p[0] + 2.5, y_face, p[1] + 2.5]) cube([p[2] - 5, 20, switch_back.y - 5]);
         }
      }
   color(c_switch)
      for (p = backs)
         translate([p[0] + 4, 5, p[1] + 4]) cube([p[2] - 8, switch_depth, switch_back.y - 8]);
   // key, rockers and toggles on the face
   color("#b9c0c8") translate([x_sw0 + f + 38.5, y_face, z_ign + 40]) rotate([90, 0, 0]) cylinder(d = 24, h = 4);
   color("#c0392b") translate([x_s0 + 11, y_face - 4, z_sw + 23]) cube([24, 4, 31]);
   color("#222") translate([x_sw1 - f - 35, y_face - 4, z_sw + 23]) cube([24, 4, 31]);
   for (i = [0 : 5])
      color("#d0d4da") translate([x_s0 + 51 + i * 19, y_face, z_sw + 27])
         rotate([90, 0, 0]) cylinder(d = 4, h = 18);
}

// Primer: face, tube through the sheet, bracket behind it, knob
module primer_part() {
   y_face = -sheet_t - 3;           // panel_t
   color(c_sheet)
      translate([primer_face_r[0], y_face, primer_face_r[1]]) cube([primer_face, 3, primer_face]);
   color("#3d7bd9") {
      translate([primer_x - 11, y_face + 3, primer_z - 11]) cube([22, primer_tube, 22]);
      translate([primer_x - 11, y_face + 3 + primer_tube, primer_z - primer_bracket.y / 2])
         cube([11 + primer_bracket.x, primer_bracket.z, primer_bracket.y]);
   }
   color("#b9c0c8")
      translate([primer_x, y_face + 3 + primer_tube, primer_z]) rotate([-90, 0, 0]) cylinder(d = 6, h = primer_depth - primer_tube);
   color("#1d1f22")
      translate([primer_x, y_face, primer_z]) rotate([90, 0, 0]) cylinder(d = 22, h = 14);
}

module throttle_part() {
   r = 10;
   f = throttle_flange;
   translate([throttle_x0, throttle_y0, throttle_z]) {
      color(c_box) {
         difference() {
            hull()
               for (x = [r, throttle_size.x - r], y = [r, throttle_size.y - r])
                  translate([x, y, 0]) cylinder(r = r, h = throttle_size.z);
            translate([3, 3, 3]) cube(throttle_size - [6, 6, 0]);
         }
         translate([-f, 0, 0]) cube([throttle_size.x + 2 * f, throttle_face_t, throttle_size.z + f]);
      }
      color("#b9c0c8")
         for (x = throttle_bolt_xs)
            translate([x, throttle_bolt_y, 3]) cylinder(d = m5_head_d, h = 3);
      for (i = [0 : 2])
         translate([throttle_rod_xs[i], 0, throttle_rod_z]) {
            color("#b9c0c8") rotate([90, 0, 0]) cylinder(d = 6, h = 60);
            color(["#222", "#9aa0a8", "#c0392b"][i])
               translate([0, -60, 0]) rotate([90, 0, 0]) cylinder(d = 26, h = 14);
         }
   }
}

// Under-desk component on its lower bar: box, face with flange, floor bolts
module under_box(x, size) {
   f = under_flange;
   translate([x - size.x / 2, under_y0, apron_bar_z]) {
      color(c_box) {
         difference() {
            cube(size);
            translate([3, 3, 3]) cube(size - [6, 6, 0]);
         }
         translate([-f, 0, 0]) cube([size.x + 2 * f, under_face_t, size.z + f]);
      }
      color("#b9c0c8")
         for (s = [-1, 1])
            translate([size.x / 2 + s * size.x / 4, under_bolt_y, 3]) cylinder(d = m5_head_d, h = 3);
   }
}

module pedestal_part() {
   under_box(pedestal_x, pedestal_size);
   // trim wheel rim out of a slot in the face, trim indicator slot below it
   z = apron_bar_z + pedestal_size.z;
   color("#222")
      translate([pedestal_x - 6, under_y0 + 40, z - 55])
         rotate([0, 90, 0]) cylinder(d = 100, h = 12);
   color("#ddd")
      translate([pedestal_x - 4, under_y0 - 0.5, apron_bar_z + 12]) cube([8, 1, 28]);
}

// DIY flaps panel (placeholder): front plate on the sheet right of the
// throttle box, body behind it on the front rail, lever and indicator on the plate
module flaps_part() {
   y = -sheet_t;
   color(c_device) {
      translate([flaps_face[0], y - 3, flaps_face[1]])
         cube([flaps_plate.x, 3, flaps_plate.y]);
      translate([flaps_x - flaps_body.x / 2, 0, flaps_z - flaps_body.y / 2])
         cube([flaps_body.x, flaps_body.z - sheet_t, flaps_body.y]);
   }
   color("#ddd") translate([flaps_x - 18, y - 3.5, flaps_z - 20]) cube([2, 1, 40]);
   color("#eee") translate([flaps_x + 4, y - 15, flaps_z + 8]) cube([16, 12, 6]);
}

// Parking brake: body on the bottom bar behind the sheet, the T-handle
// through the sheet, released (sideways, almost flush) or set (pulled out,
// pointing down)
module park_part(set = false) {
   z = park_z + park_size.z / 2;
   pull = set ? park_pull : 0;
   color(c_box)
      translate([park_x - park_size.x / 2, 0, park_z]) cube(park_size);
   color("#b9c0c8") {
      for (s = [-1, 1])
         translate([park_x + s * park_bolt_dx, ext / 2, park_z]) cylinder(d = 5, h = 1);
      translate([park_x, 1, z]) rotate([90, 0, 0]) cylinder(d = 6, h = 6 + sheet_t + pull);
   }
   color("#c0392b")
      translate([park_x, -sheet_t - 10 - pull, z])
         rotate([0, set ? 0 : 90, 0])
            translate([0, 0, set ? -park_handle + 8 : 0])
               cylinder(d = 10, h = park_handle, center = !set);
}

// Compass over the panel on the right top bar: the stand, the body with
// its bezel and the card behind the window
module compass_part() {
   translate([compass_x, ext / 2, z_tr + ext]) {
      color(c_box) {
         translate([-compass_foot.x / 2, -compass_foot.y / 2, 0]) cube(compass_foot);
         translate([-compass_neck.x / 2, -compass_neck.y / 2, 0]) cube([compass_neck.x, compass_neck.y, compass_rise]);
      }
      translate([0, -compass_stand_dy, compass_rise]) {
         color(c_device) translate([-compass_body.x / 2, compass_face_dy, 0]) cube(compass_body);
         color("#e8e8e8") translate([-24, compass_face_dy - 0.5, compass_body.z / 2 - 13]) cube([48, 1, 26]);
      }
      color("#b9c0c8") for (s = [-1, 1]) translate([s * compass_bolt_dx, 0, compass_foot.z]) cylinder(d = m5_head_d, h = 3);
   }
}

module components() {
   compass_part();
   yoke_part();
   radio_part();
   switch_panel_part();
   primer_part();
   throttle_part();
   pedestal_part();
   flaps_part();
   park_part();
   clamps_part();
}

module cockpit_view() {
   desk_part();
   frame_part();
   sheet_part();
   components();
}

// The DIY radio stack's faces, reserved on the right sheet (outline, view only)
module stack_outline() {
   color("#e0b030")
      translate([0, -sheet_t - 0.5, 0]) rotate([90, 0, 0]) linear_extrude(0.5)
         for (i = [0 : len(stack_units_h) - 1])
            let(z1 = stack_face[3] - (i == 0 ? 0 : stack_units_h[0] + (i > 1 ? stack_units_h[1] : 0) + (i > 2 ? stack_units_h[2] : 0)))
               difference() {
                  translate([stack_face[0], z1 - stack_units_h[i]]) square([stack_w, stack_units_h[i]]);
                  translate([stack_face[0] + 1.5, z1 - stack_units_h[i] + 1.5]) square([stack_w - 3, stack_units_h[i] - 3]);
               }
}

// Stage 2: the instruments' holes and the full height left sheet (outlines, view only)
module inst_outline() {
   color("#e0b030")
      translate([0, -sheet_t - 0.5, 0]) rotate([90, 0, 0]) linear_extrude(0.5) {
         for (c = inst_c)
            translate(c) difference() { circle(d = inst_cut_d); circle(d = inst_cut_d - 3); }
         difference() {
            rect([0, -ext, x_r, sheet_h_r]);
            rect([1.5, -ext + 1.5, x_r - 1.5, sheet_h_r - 1.5]);
         }
      }
}

// Sheet cutting view: the sheets with the frame behind them, the DIY
// stack's and the instruments' (stage 2) places outlined
module sheet_view() {
   frame_part();
   sheet_part();
   stack_outline();
   inst_outline();
}

// The yoke on the desk, its clamp and the lower panel under it, cut through its right clamp (seen from the right)
module yoke_view() {
   intersection() {
      union() {
         desk_part();
         frame_part();
         sheet_part();
         yoke_part();
         switch_panel_part();
         park_part();
      }
      translate([(yoke_clamp_x[1][0] + yoke_clamp_x[1][1]) / 2 - 300, -200, sheet_bottom - 10]) cube([300, 600, 400]);
   }
}

// Below the desk top: the lower panel, the apron and the under-desk components
module under_view() {
   intersection() {
      union() {
         desk_part();
         frame_part();
         sheet_part();
         pedestal_part();
         park_part(set = true);
         clamps_part();
         throttle_part();
         flaps_part();
         switch_panel_part();
         primer_part();
         yoke_part();
      }
      translate([-110, -200, apron[1] - 1]) cube([frame_w + 220, 600, -apron[1] + 1]);
   }
}

// Close-up of the left desk clamp, the desk and the frame around it cut off
module clamp_view() {
   x0 = rails[0][0] - 40;
   x1 = 60;
   color(c_desk) translate([x0, frame_overhang, -desk.z]) cube([x1 - x0, 110, desk.z]);
   color(c_alu) {
      translate([rails[0][0], ext, 0]) cube([x1 - rails[0][0], ext, ext]);
      translate([0, 0, -60]) cube([ext, ext, 130]);
      translate([0, 2 * ext, 0]) cube([ext, 90, ext]);
   }
   color(c_sheet) translate([0, -sheet_t, -60]) cube([x1, sheet_t, 130]);
   desk_clamp_part(clamp_xs[0]);
}

module throttle_view() {
   intersection() {
      union() {
         desk_part();
         frame_part();
         sheet_part();
         throttle_part();
         flaps_part();
      }
      translate([throttle_x0 - 40, -100, throttle_z - ext - 10]) cube([flaps_face[2] - throttle_x0 + 80, 400, -throttle_z + ext + 40]);
   }
}

//cockpit_view(); // Make view main 62,0,-35
//cockpit_view(); // Make view front 90,0,0
//cockpit_view(); // Make view back 55,0,150
//frame_part(); // Make view frame 55,0,-35
//sheet_view(); // Make view sheet 90,0,0
//throttle_view(); // Make view throttle 55,0,150
//yoke_view(); // Make view yoke 90,0,90
//under_view(); // Make view under 80,0,-20
//clamp_view(); // Make view clamp 75,0,-50
