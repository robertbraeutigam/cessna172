// Throttle box with carb heat, throttle, mixture
//
// Mounted in the cockpit frame (frame/): the box goes through a cut-out in
// the panel sheet, under the desk top, and stands on the throttle bar.
// Its front wall is the face,
// with a flange on the top and the two sides that is screwed onto the sheet
// (M3, nuts behind the sheet; drill the sheet through the flange's holes
// with the box in place). Two M5 bolts through the floor go into T-nuts in
// the throttle bar's top slot. The box is behind the sheet, so it needs no
// lid; its top stays open.
//
// Read by MobiFlight on an Arduino Nano of its own, in rails on the floor
// between the carb heat and the throttle pot, its USB jack at the back
// wall: the USB cable to the powered USB hub plugs in through a window in
// it (README.md, Connections). Wires, soldered to the Nano's pins:
// - 5 V and GND to the carb heat pot's end tabs, then on with two short
//   wires to the same tabs of the throttle and the mixture pot (the same
//   end of each pot to 5 V, so all read the same way)
// - A0: throttle wiper, A1: mixture wiper, A2: carb heat wiper

$fn = 30;

// Box dimensions
height = 50;
depth = 170;
roundness = 10;
control_gap = 55;
end_gap = 10;
wall_thickness = 3;

// Printer bed
bed = [255, 255];

// Face flange, the same as the switch panels (switchpanel/panel.inc.scad)
face_t = wall_thickness;     // the front wall, in front of the sheet
flange_w = 10;               // face beyond the box: top and sides, none at the bottom (rail)
face_corner_r = 4;
mount_d = 3.3;               // M3
mount_inset = 4.5;           // mount hole center to the face edge
mount_nut_r = 3.2;           // M3 nut, across the corners / 2, behind the sheet
mount_low_z = 8;             // the lower holes in the side flanges
sheet_cut_clear = 1;         // sheet cut-out beyond the box (frame/ throttle_play)

// Floor bolts into the throttle bar (frame/): M5, the bar (a 2020 behind
// the frame's front part) has its top slot 30 mm behind the sheet, and the
// sheet and face_t are in front of y = 6
sheet_t = 3;
rail_slot_y = 30;
m5_d = 5.3;
floor_bolt_y = face_t + sheet_t + rail_slot_y;

// Calculated
width = 2 * control_gap + 2 * end_gap;
full_width = width + 2*roundness;
face_w = full_width + 2 * flange_w;
face_h = height + flange_w;
assert(face_w <= bed.x && depth + 2*roundness <= bed.y,
       "box underside does not fit the printer bed");
assert(mount_inset + mount_nut_r + 0.3 <= flange_w - sheet_cut_clear,
       "Mount nuts do not sit on the sheet, make flange_w wider");
assert(mount_low_z >= mount_nut_r + 1, "Lower mount holes too close to the face bottom");

// Big linear pot dimensions
big_pot_stand_distance = 115;
big_pot_stand_thickness = 5;
big_pot_stand_height = 7;
big_pot_full_width = 16;
big_pot_module_height = 6;
big_pot_full_length = 130;

// Arduino Nano, MEASURE (instruments/instrument.inc.scad has the same values)
nano_board = [18, 45];       // width, length; the mini USB jack at one end
nano_t = 1.6;
nano_under = 2.5;            // parts and solder stubs under the board
nano_usb = [8, 4];           // jack: width, height over the board
usb_plug = [12, 9];          // MEASURE: the USB cable's plug body (width, height), through the back wall
rail_w = 1.5;                // the Nano's rails on the floor
nano_x = 46;                 // its middle, between the carb heat pot's legs and the throttle pot's

// Small linear pot dimensions
small_pot_stand_distance = 60;
small_pot_stand_thickness = 5;
small_pot_stand_height = 7;
small_pot_full_width = 10;
small_pot_module_height = 6;
small_pot_full_length = 75;

module rounded_box(local_width, local_depth, local_height) {
   hull() {
      cylinder(h = local_height, r=roundness);
      translate([local_width, 0 , 0])
         cylinder(h = local_height, r=roundness);
      translate([local_width, local_depth , 0])
         cylinder(h = local_height, r=roundness);
      translate([0, local_depth , 0])
         cylinder(h = local_height, r=roundness);
   }
}

module box_underside() {
   difference() {
      union() {
         // The main box area
         translate([roundness, roundness, 0])
            difference() {
               rounded_box(width, depth, height);
               // Box inside
               translate([wall_thickness, wall_thickness, wall_thickness])
                  rounded_box(width-wall_thickness*2, depth-wall_thickness*2, height);
            }
         // Face with the flange
         face();
         // Rod supports
         rod_supports();
         // The Nano's rails
         nano_rails();
      }
      // Face mount holes
      for (h = mount_holes)
         translate([h.x, -1, h.y])
            rotate([-90, 0, 0])
               cylinder(d=mount_d, h=face_t+2);
      // Floor bolts into the throttle bar
      for (x = floor_bolt_xs)
         translate([x, floor_bolt_y, -1])
            cylinder(d=m5_d, h=wall_thickness+2);
      // Rod & rod nut holes
      throttle_rods();
      translate([roundness+end_gap+control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      translate([roundness+end_gap+2*control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      // Window for the USB plug, in front of the Nano's jack
      translate([nano_x - usb_plug.x / 2, back_in - 1, usb_z - usb_plug.y / 2])
         cube([usb_plug.x, wall_thickness + 2, usb_plug.y]);
   }
   // Linear pot stands
   translate([roundness+end_gap+control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap+2*control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap, 55, 0])
      small_pot_stand();
}

// Mount holes in the flange, [x, z]: the top row and low on the sides
mount_holes = [
   [-flange_w + mount_inset, face_h - mount_inset],
   [full_width / 2, face_h - mount_inset],
   [full_width + flange_w - mount_inset, face_h - mount_inset],
   [-flange_w + mount_inset, mount_low_z],
   [full_width + flange_w - mount_inset, mount_low_z]];

// Floor bolts between the rod support walls, clear of the rods above
floor_bolt_xs = [(rod_support_x(0) + rod_support_x(1)) / 2 + wall_thickness / 2,
                 (rod_support_x(2) + rod_support_x(3)) / 2 + wall_thickness / 2];

// The front wall widened to the face, top corners rounded
module face() {
   r = face_corner_r;
   translate([0, face_t, 0])
      rotate([90, 0, 0])
         linear_extrude(face_t)
            hull() {
               translate([-flange_w, 0]) square([face_w, 1]);
               for (x = [-flange_w + r, full_width + flange_w - r])
                  translate([x, face_h - r]) circle(r = r);
            }
}

// The Nano: component side up, its USB jack against the back wall's
// inside. It slides in from the front between two rails (a ledge under
// each long edge, a lip over it); a dab of hot glue at its front end
// keeps it there when the plug goes in.
back_in = depth + 2 * roundness - wall_thickness;   // the back wall's inside
nano_y0 = back_in - 0.3 - nano_board.y;
nano_z = wall_thickness + nano_under;               // the board's underside
usb_z = nano_z + nano_t + nano_usb.y / 2;           // the jack's middle

module nano_rails() {
   for (s = [-1, 1]) {
      xo = nano_x + s * (nano_board.x / 2 + 0.1);
      translate([s > 0 ? xo : xo - rail_w, nano_y0, wall_thickness - 0.01])
         cube([rail_w, nano_board.y, nano_under + nano_t + 0.8 + 0.01]);
      translate([s > 0 ? xo - 1.2 : xo, nano_y0, wall_thickness - 0.01])
         cube([1.2, nano_board.y, nano_under + 0.01]);
      translate([s > 0 ? xo - 0.8 : xo, nano_y0, nano_z + nano_t + 0.1])
         cube([0.8 + 0.01, nano_board.y, 0.7]);
   }
}

// Between the carb heat pot's legs and the throttle pot's (with its legs)
nano_rail_x = [nano_x - nano_board.x / 2 - 0.1 - rail_w, nano_x + nano_board.x / 2 + 0.1 + rail_w];
assert(nano_rail_x[0] >= roundness + end_gap + small_pot_full_width + 1, "Nano runs into the carb heat pot's legs");
assert(nano_rail_x[1] <= roundness + end_gap + control_gap - big_pot_full_width + 3 - 1, "Nano runs into the throttle pot's legs");
assert(nano_y0 >= 55 + small_pot_stand_distance + 2 + 10 + 1, "Nano runs into the carb heat pot's back legs");
assert(usb_z - usb_plug.y / 2 >= wall_thickness + 1 && usb_z + usb_plug.y / 2 <= height - 3, "USB window off the back wall");
assert(nano_x - usb_plug.x / 2 >= roundness + 1, "USB window in the back wall's rounded corner");


module big_pot_stand() {
   translate([0, 0, wall_thickness]) {
      big_pot_leg();
      translate([0, big_pot_stand_distance+2, 0])
         big_pot_leg();
   }
}

module big_pot_leg() {
   translate([0, 0, big_pot_stand_height/2])
      cube([big_pot_full_width+3, big_pot_stand_thickness, big_pot_stand_height], center=true);
   translate([-big_pot_full_width+3, -10, 0])
      difference() {
         cube([5, 20, big_pot_stand_height+big_pot_stand_height]);
         translate([5/2,20/2,1])
            cylinder(d=3.2, h=big_pot_stand_height+big_pot_module_height+1);
      }
   translate([+big_pot_full_width-5-3, -10, 0])
      difference() {
         cube([5, 20, big_pot_stand_height+big_pot_stand_height]);
         translate([5/2,20/2,1])
            cylinder(d=3.2, h=big_pot_stand_height+big_pot_module_height+1);
      }
}

module small_pot_stand() {
   translate([0, 0, wall_thickness]) {
      small_pot_leg();
      translate([0, small_pot_stand_distance+2, 0])
         small_pot_leg();
   }
}

module small_pot_leg() {
   translate([0, 0, small_pot_stand_height/2])
      cube([small_pot_full_width+3, small_pot_stand_thickness, small_pot_stand_height], center=true);
   translate([-small_pot_full_width, -10, 0])
      difference() {
         cube([5, 20, small_pot_stand_height+small_pot_stand_height]);
         translate([5/2,20/2,1])
            cylinder(d=3.2, h=small_pot_stand_height+small_pot_module_height+1);
      }
   translate([+5, -10, 0])
      difference() {
         cube([5, 20, small_pot_stand_height+small_pot_stand_height]);
         translate([5/2,20/2,1])
            cylinder(d=3.2, h=small_pot_stand_height+small_pot_module_height+1);
      }
}

// Left side of rod support wall i, left to right
function rod_support_x(i) = roundness + end_gap - wall_thickness/2 + [15, control_gap-15, control_gap+15, 2*control_gap-15][i];

module rod_supports() {
   translate([0, 40, 0])
      cube([full_width, wall_thickness, height]);
   for (i = [0 : 3])
      translate([rod_support_x(i), 0, 0])
         rod_support_support();
}

rod_support_support_thickness = 7;

module rod_support_support() {
   difference() {
      cube([wall_thickness, 40, height]);
      translate([0, rod_support_support_thickness+wall_thickness/2, rod_support_support_thickness+wall_thickness/2])
         cube([wall_thickness, 40-rod_support_support_thickness*2, height-rod_support_support_thickness*2]);
   }
}

module big_pots() {
   big_pot();
   translate([control_gap, 0, 0])
      big_pot();
}

module big_pot() {
   translate([roundness+end_gap+control_gap, 51+big_pot_full_length/2, big_pot_stand_height/2+wall_thickness+big_pot_stand_height]) {
      difference() {
         cube([big_pot_full_width, big_pot_full_length, big_pot_module_height], center=true);
         // Mounting holes
         translate([0, -big_pot_full_length/2+3.5, 0])
            cylinder(d=3, h=big_pot_module_height);
         translate([0, +big_pot_full_length/2-3.5, 0])
            cylinder(d=3, h=big_pot_module_height);
      }
      // Ear
      translate([0, 0, 16/2+big_pot_module_height/2])
         cube([1, 5, 16], center=true);
   }
}

module small_pot() {
   translate([roundness+end_gap, 49+small_pot_full_length/2, small_pot_stand_height/2+wall_thickness+small_pot_stand_height]) {
      difference() {
         cube([small_pot_full_width, small_pot_full_length, small_pot_module_height], center=true);
         // Mounting holes
         translate([0, -small_pot_full_length/2+1.5, 0])
            cylinder(d=2, h=small_pot_module_height);
         translate([0, +small_pot_full_length/2-1.5, 0])
            cylinder(d=2, h=small_pot_module_height);
      }
      // Ear
      translate([0, 0, 16/2+small_pot_module_height/2])
         cube([1, 5, 16], center=true);
   }
}

module throttle_rods() {
   throttle_rod();
   translate([control_gap, 0, 0])
      throttle_rod();
   translate([2*control_gap, 0, 0])
      throttle_rod();
}

module throttle_rod() {
   translate([roundness+end_gap, depth+roundness, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
      rotate([90, 0, 0])
         cylinder(d=6.2, h=depth+roundness*2+10);
}

module small_pot_holder() {
   translate([roundness+end_gap, 55, 20]) {
      translate([-small_pot_full_width, -10, 0])
         difference() {
            cube([5, 20, 3]);
            translate([5/2,20/2,-1])
               cylinder(d=3.5, h=5);
         }
      translate([+small_pot_full_width-5, -10, 0])
         difference() {
            cube([5, 20, 3]);
            translate([5/2,20/2,-1])
               cylinder(d=3.5, h=5);
         }
      translate([-small_pot_full_width, -10, 0])
         cube([small_pot_full_width*2, 7, 3]);
      translate([-small_pot_full_width+5+0.5, -10, -3])
         cube([small_pot_full_width-1, 5, 6]);
   }
}

// ---------------------------------------------------------------------------
// Views: bought parts and the assembly, for the PNG views only. Nothing
// below ends up in an STL.

// Shown slider positions [carb heat, throttle, mixture]: how far each rod is
// pulled out from the middle of its pot, in mm
view_travel = [10, -25, 15];

// Rod axis height and x of control i (0 = carb heat, 1 = throttle, 2 = mixture)
rod_z = wall_thickness + big_pot_stand_height + big_pot_module_height + 15 + 7;
function rod_x(i) = roundness + end_gap + i * control_gap;
// Middle of the pot of control i, where its slider ear is at travel 0
function pot_mid_y(i) = i == 0 ? 49 + small_pot_full_length / 2 : 51 + big_pot_full_length / 2;
function ear_y(i) = pot_mid_y(i) - view_travel[i];

rod_front = 45;       // rod length in front of the box at travel 0
rod_tail = 15;        // rod length behind the clamp
wire_d = 1.2;

c_box = "#3d7bd9";
c_sheet = "#4a4f57";
c_print = "#f5a030";  // small printed parts: pins, holders
c_clamp = "#e8433a";
c_pot = "#2a2b2e";
c_pot_rail = "#b9c0c8";
c_steel = "#b9c0c8";
c_chrome = "#e2e6ea";
c_knob = "#1d1f22";
c_mixture = "#c62828";
c_pcb = "#1d1f22";
c_gold = "#d9b24a";
c_cable = "#26282b";
c_nano = "#1d4fa0";
wire_colors = ["#e8433a", "#1d1f22"]; // 5 V, GND
wiper_colors = ["#f1c40f", "#2e8b3a", "#e67e22"]; // wipers of carb heat, throttle, mixture

module wire(points, c, d = wire_d) {
   color(c)
      for (i = [1 : len(points) - 1])
         hull() {
            translate(points[i - 1]) sphere(d = d, $fn = 10);
            translate(points[i]) sphere(d = d, $fn = 10);
         }
}

// Pot with its slider ear moved to y = ear (absolute)
module pot_part(big, x, ear) {
   len = big ? big_pot_full_length : small_pot_full_length;
   w = big ? big_pot_full_width : small_pot_full_width;
   h = big ? big_pot_module_height : small_pot_module_height;
   y0 = big ? 51 : 49;
   z0 = wall_thickness + (big ? big_pot_stand_height : small_pot_stand_height) * 1.5 - h / 2;
   translate([x, y0, z0]) {
      color(c_pot)
         difference() {
            translate([-w / 2, 0, 0]) cube([w, len, h]);
            for (y = [big ? 3.5 : 1.5, len - (big ? 3.5 : 1.5)])
               translate([0, y, -1]) cylinder(d = big ? 3 : 2, h = h + 2);
            // Slot for the ear
            translate([-0.75, 8, h - 0.6]) cube([1.5, len - 16, 1]);
         }
      // End caps
      color(c_pot_rail)
         for (y = [6, len - 8])
            translate([-w / 2 + 0.3, y, h - 0.01]) cube([w - 0.6, 2, 0.4]);
      // Solder tabs at the back end
      color(c_gold)
         for (dx = [-w / 4, 0, w / 4])
            translate([dx - 0.5, len - 1, 1]) cube([1, 4, 0.4]);
   }
   // Slider ear
   color(c_pot_rail)
      translate([x, ear, z0 + h + 8])
         cube([1, 5, 16], center = true);
}

module pots_part() {
   pot_part(false, rod_x(0), ear_y(0));
   pot_part(true, rod_x(1), ear_y(1));
   pot_part(true, rod_x(2), ear_y(2));
}

// clamp_slider() from clamp.scad, rod axis along z
module clamp_shape() {
   w = 10;
   difference() {
      union() {
         cylinder(h = w, d = 9);
         translate([0, -3, 0]) cube([9, 6, w]);
      }
      translate([0, 0, -1]) cylinder(h = w + 2, d = 6.2);
      translate([1, -1, -1]) cube([w + 2, 2, w + 2]);
      translate([6, 5, w / 2]) rotate([90, 0, 0]) cylinder(h = w + 2, d = 3.3);
   }
   translate([-15, -2, 0])
      difference() {
         cube([12, 4, w]);
         translate([-1, 1.25, 2.5]) cube([15, 1.5, 5]);
      }
}

// The clamp on rod i, its slot over the pot ear: clamp x -> up, y -> x,
// z -> along the rod
module clamp_part(i) {
   translate([rod_x(i), ear_y(i) - 5, rod_z])
      multmatrix([[0, 1, 0, 0], [0, 0, 1, 0], [1, 0, 0, 0]]) {
         color(c_clamp) clamp_shape();
         // Clamp screw
         color(c_steel)
            translate([6, 5, 5]) rotate([90, 0, 0]) {
               cylinder(d = 3, h = 10);
               cylinder(d = 5.5, h = 2.5);
            }
      }
}

// Knob of control i, pointing at -y from y = 0
module knob_part(i) {
   rotate([90, 0, 0])
      if (i == 0) {
         // carb_heat_knob.scad
         color(c_knob) {
            cylinder(d = 12, h = 15);
            hull() {
               translate([0, 0, 15]) cylinder(d = 12, h = 1);
               translate([0, 0, 18])
                  linear_extrude(3)
                     offset(r = 3) square(19, center = true);
            }
         }
         color("#3a3d42")
            translate([0, 0, 21]) cylinder(d = 16, h = 2);
      } else if (i == 1) {
         // Throttle: big black push-pull knob
         color(c_knob) {
            cylinder(d = 10, h = 12);
            translate([0, 0, 10])
               rotate_extrude($fn = 60)
                  hull() {
                     square([1, 22]);
                     translate([14, 4]) circle(r = 4, $fn = 24);
                     translate([14, 18]) circle(r = 4, $fn = 24);
                  }
         }
      } else {
         // Mixture: red with a ribbed rim
         color(c_mixture)
            difference() {
               union() {
                  cylinder(d = 10, h = 12);
                  translate([0, 0, 10]) cylinder(d = 28, h = 16, $fn = 60);
               }
               for (a = [0 : 15 : 359])
                  rotate([0, 0, a]) translate([14.6, 0, 9]) cylinder(d = 2.4, h = 18, $fn = 12);
               translate([0, 0, 25]) cylinder(d = 20, h = 2, $fn = 60);
            }
      }
}

// Rod i with its knob, clamp not included
module rod_part(i) {
   y0 = -rod_front - view_travel[i];
   color(c_chrome)
      translate([rod_x(i), ear_y(i) + 5 + rod_tail, rod_z])
         rotate([90, 0, 0])
            cylinder(d = 6, h = ear_y(i) + 5 + rod_tail - y0);
   translate([rod_x(i), y0, rod_z])
      knob_part(i);
}

module controls_part() {
   for (i = [0 : 2]) {
      rod_part(i);
      clamp_part(i);
   }
}

// wide_pin_inv() from pin.scad
module pin_shape() {
   t = big_pot_stand_thickness;
   w = big_pot_full_width;
   for (x = [0, w + t + 2])
      translate([x, 0, 0])
         difference() {
            cube([t, 20, 3]);
            translate([t / 2, 10, -1]) cylinder(h = 5, d = 3.3);
         }
   cube([t * 2 + w + 2, 7, 3]);
   translate([t, 0, -3]) cube([1, 7, 6]);
   translate([t + w + 1, 0, -3]) cube([1, 7, 6]);
   translate([t, 0, -3]) cube([w + 2, 1, 6]);
}

// The hold-down pins on the big pot legs, the bar over the pot ends
module pins_part(lift = 0) {
   z = wall_thickness + 2 * big_pot_stand_height + lift;
   color(c_print)
      for (i = [1, 2]) {
         translate([rod_x(i) - 14, 45, z]) pin_shape();
         translate([rod_x(i) - 14, 55 + big_pot_stand_distance + 2 + 10, z]) mirror([0, 1, 0]) pin_shape();
      }
}

module holders_part(lift = 0) {
   color(c_print)
      translate([0, 0, lift]) {
         small_pot_holder();
      }
}


// Solder tab j of pot i (0 = 5 V, 1 = GND, 2 = wiper)
function pot_tab(i, j) =
   let(big = i > 0, w = big ? big_pot_full_width : small_pot_full_width)
   [rod_x(i) + (j - 1) * w / 4,
    (big ? 51 + big_pot_full_length : 49 + small_pot_full_length) + 3,
    wall_thickness + 2 * big_pot_stand_height - 4];

// A wire from a up to height zr, across and down to b
module route(a, b, zr, c) {
   wire([a, [a.x, a.y, zr], [b.x, b.y, zr], b], c);
}

// The Nano's pins along its left edge (USB jack back, seen from above):
// A0..A7, then 5 V and GND; k-th of [5 V, GND, A0, A1, A2] from the back
function nano_pin(k) = [nano_x - nano_board.x / 2 + 1.3, back_in - 12 - 2.54 * k, nano_z + nano_t + 0.5];

module nano_part() {
   translate([nano_x - nano_board.x / 2, nano_y0, nano_z]) {
      color(c_nano) cube([nano_board.x, nano_board.y, nano_t]);
      color("#202020") translate([nano_board.x / 2 - 3.5, 18, nano_t]) cube([7, 7, 1.2]);
      color(c_steel) translate([nano_board.x / 2 - nano_usb.x / 2, nano_board.y - 8, nano_t]) cube([nano_usb.x, 9, nano_usb.y]);
   }
}

module wires_part() {
   // 5 V and GND to the carb heat pot, each wiper to its pot
   route(nano_pin(0), pot_tab(0, 0), 24, wire_colors[0]);
   route(nano_pin(1), pot_tab(0, 1), 25.5, wire_colors[1]);
   for (i = [0 : 2])
      route(nano_pin(2 + [2, 0, 1][i]), pot_tab(i, 2), 27 + 1.5 * i, wiper_colors[i]);
   // 5 V and GND on from pot to pot
   for (i = [0 : 1], j = [0 : 1])
      route(pot_tab(i, j), pot_tab(i + 1, j), 32 + 1.5 * j, wire_colors[j]);
   nano_part();
   // The USB cable, plugged in through the back wall
   color(c_cable) {
      translate([nano_x - usb_plug.x / 2 + 1, back_in - 1, usb_z - usb_plug.y / 2 + 1])
         cube([usb_plug.x - 2, 18, usb_plug.y - 2]);
      translate([nano_x, back_in + 16, usb_z]) rotate([-90, 0, 0]) cylinder(d = 4, h = 40);
   }
}

module underside_part() {
   color(c_box) render() box_underside();
}

// A piece of the cockpit sheet with the box's cut-out, behind the face,
// the frame's front part and the throttle bar under it (frame/)
module sheet_part() {
   m = 40;
   c = sheet_cut_clear;
   color(c_sheet, 0.85)
      translate([0, face_t + sheet_t, 0])
         rotate([90, 0, 0])
            linear_extrude(sheet_t)
               difference() {
                  translate([-flange_w - m, -20]) square([face_w + 2 * m, face_h + 20 + m]);
                  translate([-c, -1]) square([full_width + 2 * c, height + c + 1]);
               }
   color("#c3c9d0")
      translate([-flange_w - m, face_t + sheet_t + 20, -20]) cube([face_w + 2 * m, 20, 20]);
   // Mount screws and floor bolts
   color(c_steel) {
      for (h = mount_holes)
         translate([h.x, 0, h.y]) rotate([90, 0, 0]) cylinder(d = 5.5, h = 2);
      for (x = floor_bolt_xs)
         translate([x, floor_bolt_y, wall_thickness]) cylinder(d = 9.5, h = 3);
   }
}

module inside_parts() {
   pots_part();
   controls_part();
   pins_part();
   holders_part();
   wires_part();
}

// Mounted on the cockpit sheet and the throttle bar
module mounted_view() {
   underside_part();
   sheet_part();
   inside_parts();
}

// The box with everything in it
module inside_view() {
   underside_part();
   inside_parts();
}

// Everything lifted out of the underside
module exploded_view(e = 35) {
   underside_part();
   for (i = [0 : 2]) {
      translate([0, 0, e])
         pot_part(i > 0, rod_x(i), ear_y(i));
      translate([0, -1.5 * e, 0]) {
         rod_part(i);
         translate([0, 0, 0.6 * e]) clamp_part(i);
      }
   }
   translate([0, 0, 2 * e]) pins_part();
   translate([0, 0, 2 * e]) small_pot_holder_part();
   translate([0, 0, e]) nano_part();
}

module small_pot_holder_part() {
   color(c_print) small_pot_holder();
}

box_underside(); // Make module underside

//small_pot_holder(); // Make module holder_small_pot

//#big_pots(); // Ignore module

//#small_pot(); // Ignore module

//#throttle_rods(); // Ignore module

//inside_view(); // Make view main 55,0,-35
//mounted_view(); // Make view mounted 60,0,-30
//exploded_view(); // Make view exploded 55,0,-35
//inside_view(); // Make view top 0,0,-90
//inside_view(); // Make view back 60,0,150
