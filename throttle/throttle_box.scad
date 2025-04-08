// Throttle box with carb heat, throttle, mixture

$fn = 30;

// Box dimensions
height = 50;
depth = 170;
roundness = 10;
control_gap = 55;
end_gap = 10;
wall_thickness = 3;

// Calculated
width = 2 * control_gap + 2 * end_gap;
full_width = width + 2*roundness;

// Big linear pot dimensions
big_pot_stand_distance = 110;
big_pot_stand_thickness = 5;
big_pot_stand_height = 7;
big_pot_full_width = 16;
big_pot_module_height = 6;
big_pot_full_length = 120;

// Small linear pot dimensions
small_pot_stand_distance = 60;
small_pot_stand_thickness = 5;
small_pot_stand_height = 7;
small_pot_full_width = 10;
small_pot_module_height = 6;
small_pot_full_length = 75;

// Clamp
clamp_depth = 35;

// Connector columns
top_screw_d = roundness;

module rounded_box(local_width, local_depth) {
   hull() {
      cylinder(h = height, r=roundness);
      translate([local_width, 0 , 0])
         cylinder(h = height, r=roundness);
      translate([local_width, local_depth , 0])
         cylinder(h = height, r=roundness);
      translate([0, local_depth , 0])
         cylinder(h = height, r=roundness);
   }
}

module box_underside() {
   difference() {
      union() {
         // The main box area
         translate([roundness, roundness, 0])
            difference() {
               rounded_box(width, depth);
               // Box inside
               translate([wall_thickness, wall_thickness, wall_thickness])
                  rounded_box(width-wall_thickness*2, depth-wall_thickness*2);
               // Clamp holes
            }
         // Clamp housings
         translate([roundness, 0, 0])
            cube([20+wall_thickness*2, clamp_depth, 20+wall_thickness*2]);
         translate([roundness+width-20-wall_thickness*2, 0, 0])
            cube([20+wall_thickness*2, clamp_depth, 20+wall_thickness*2]);
         // Rod supports
         rod_supports();
         // Top screw columns
         translate([roundness/2+wall_thickness, roundness/2+wall_thickness, 0])
            top_screw_column();
         translate([roundness/2+wall_thickness, depth+roundness+wall_thickness-1, 0])
            top_screw_column();
         translate([width+roundness+wall_thickness-1, roundness/2+wall_thickness, 0])
            top_screw_column();
         translate([width+roundness+wall_thickness-1, depth+roundness+wall_thickness-1, 0])
            top_screw_column();
         // CPU pedestal
         cpu_pedestal();
         // Cable cradle
         cable_cradle();
      }
      // Remove clamp space
      translate([roundness+wall_thickness, -wall_thickness, wall_thickness])
         cube([20, clamp_depth, 20]);
      translate([roundness+width-20-wall_thickness, -wall_thickness, wall_thickness])
         cube([20, clamp_depth, 20]);
      // Rod & rod nut holes
      throttle_rods();
      translate([roundness+end_gap+control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      translate([roundness+end_gap+2*control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      // USB power cable hole
      translate([roundness+end_gap+10, wall_thickness+depth+roundness*2, 15])
         rotate([90, 0, 0])
            cylinder(d=4.2, h=50);
   }
   // Linear pot stands
   translate([roundness+end_gap+control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap+2*control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap, 55, 0])
      small_pot_stand();
   // Seams
   translate([roundness+end_gap-wall_thickness+control_gap/2, 40, 0])
      seam();
   translate([roundness+end_gap-wall_thickness+3*control_gap/2, 40, 0])
      seam();
}

module seam() {
   difference() {
      cube([wall_thickness*2, depth+roundness*2-40, height]);
      translate([-1, 10, 10])
         cube([wall_thickness*2+2, depth+roundness*2-20-40, height]);
      for (i = [0:1:4]) {
         for (o= [0:1:14]) {
            translate([-wall_thickness/2, 6+o*9.8, 7+i*9.5])
               rotate([0, 90, 0])
                  cylinder(d=3.3, h=wall_thickness*3);
         }
      }
   }
}

module cable_cradle() {
   translate([roundness+end_gap-20/2+10, depth, wall_thickness]) {
      difference() {
         cube([20, 20, 15-wall_thickness]);
         translate([4, 10, 0])
            cylinder(d=3.2, h=12);
         translate([16, 10, 0])
            cylinder(d=3.2, h=12);
      }
   }
}

cpu_pedestal_height = 18;

module cpu_pedestal() {
   translate([wall_thickness+5, depth-40, wall_thickness]) {
      translate([1.75, 1.75, 0])
         difference() {
            cylinder(d=5, h=cpu_pedestal_height);
            cylinder(d=2.1, h=cpu_pedestal_height);
         }
      translate([55-1.75, 1.75, 0])
         difference() {
            cylinder(d=5, h=cpu_pedestal_height);
            cylinder(d=2.1, h=cpu_pedestal_height);
         }
      translate([1.75, 27-1.75, 0])
         difference() {
            cylinder(d=5, h=cpu_pedestal_height);
            cylinder(d=2.1, h=cpu_pedestal_height);
         }
      translate([55-1.75, 27-1.75, 0])
         difference() {
            cylinder(d=5, h=cpu_pedestal_height);
            cylinder(d=2.1, h=cpu_pedestal_height);
         }
   }
}

module top_screw_column() {
   difference() {
      cylinder(d=top_screw_d, h=height);
      translate([0, 0, height-16])
         cylinder(d=4.2, h=17);
   }
}

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
   translate([-big_pot_full_width/2-6/2, 0, 0])
      difference() {
         cylinder(d=6, h=big_pot_stand_height+big_pot_module_height);
         cylinder(d=3.2, h=big_pot_stand_height+big_pot_module_height);
      }
   translate([+big_pot_full_width/2+6/2, 0, 0])
      difference() {
         cylinder(d=6, h=big_pot_stand_height+big_pot_module_height);
         cylinder(d=3.2, h=big_pot_stand_height+big_pot_module_height);
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

module rod_supports() {
   translate([0, 40, 0])
      cube([full_width, wall_thickness, height]);
   translate([roundness+end_gap+control_gap-15-wall_thickness/2, 0, 0])
      rod_support_support();
   translate([roundness+end_gap+control_gap+15-wall_thickness/2, 0, 0])
      rod_support_support();
   translate([roundness+end_gap+15-wall_thickness/2, 0, 0])
      rod_support_support();
   translate([roundness+end_gap+2*control_gap-15-wall_thickness/2, 0, 0])
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

module esp32() {
   translate([wall_thickness+5, depth-40, wall_thickness+cpu_pedestal_height])
      difference() {
         cube([55, 27, 5]);
         translate([1.75, 1.75, 0])
            cylinder(d=2, h=6);
         translate([55-1.75, 1.75, 0])
            cylinder(d=2, h=6);
         translate([1.75, 27-1.75, 0])
            cylinder(d=2, h=6);
         translate([55-1.75, 27-1.75, 0])
            cylinder(d=2, h=6);
      }
}

module box_underside_slice3() {
   difference() {
      box_underside();
      cube([roundness+end_gap+2*control_gap-control_gap/2, depth+2*roundness, height]);
   }
}

module box_underside_slice2() {
   difference() {
      box_underside();
      cube([roundness+end_gap+1*control_gap-control_gap/2, depth+2*roundness, height]);
      translate([roundness+end_gap+2*control_gap-control_gap/2, 0, 0])
         cube([roundness+end_gap+1*control_gap-control_gap/2, depth+2*roundness, height]);
   }
}

module box_underside_slice1() {
   difference() {
      box_underside();
      translate([roundness+end_gap+control_gap/2, 0, 0])
         cube([roundness+end_gap+2*control_gap-control_gap/2, depth+2*roundness, height]);
   }
}

box_underside_slice1(); // Make module underside1
box_underside_slice2(); // Make module underside2
box_underside_slice3(); // Make module underside3

#big_pots(); // Ignore module

#small_pot(); // Ignore module

#throttle_rods(); // Ignore module

#esp32(); // Ignore module

