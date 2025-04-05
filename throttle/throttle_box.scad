// Throttle box with carb heat, throttle, mixture

$fn = 30;

// Box dimensions
height = 50;
depth = 170;
roundness = 10;
control_gap = 55;
end_gap = 40;
wall_thickness = 3;

// Calculated
width = 2 * control_gap + 2 * end_gap;
full_width = width + 2*roundness;

// Big linear pot dimensions
big_pot_stand_distance = 110;
big_pot_stand_thickness = 5;
big_pot_stand_height = 7;
big_pot_full_width = 15;
big_pot_module_height = 6;
big_pot_full_length = 120;

// Small linear pot dimensions
small_pot_stand_distance = 60;
small_pot_stand_thickness = 5;
small_pot_stand_height = 7;
small_pot_full_width = 7;
small_pot_module_height = 6;
small_pot_full_length = 75;

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
            cube([20+wall_thickness*2, 30, 20+wall_thickness*2]);
         translate([roundness+width-20-wall_thickness*2, 0, 0])
            cube([20+wall_thickness*2, 30, 20+wall_thickness*2]);
         // Rod supports
         rod_supports();
         // Top screw columns
         translate([roundness, roundness, 0])
            top_screw_column();
         translate([roundness, depth+roundness, 0])
            top_screw_column();
         translate([width+roundness, roundness, 0])
            top_screw_column();
         translate([width+roundness, depth+roundness, 0])
            top_screw_column();
         // CPU pedestal
         cpu_pedestal();
         // Cable cradle
         cable_cradle();
      }
      // Remove clamp space
      translate([roundness+wall_thickness, -wall_thickness, wall_thickness])
         cube([20, 30, 20]);
      translate([roundness+width-20-wall_thickness, -wall_thickness, wall_thickness])
         cube([20, 30, 20]);
      // Rod & rod nut holes
      throttle_rods();
      translate([roundness+end_gap+control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      translate([roundness+end_gap+2*control_gap, wall_thickness*2, wall_thickness+big_pot_stand_height+big_pot_module_height+15+7])
         rotate([90, 0, 0])
            cylinder(d=11.2, h=wall_thickness*2);
      // USB power cable hole
      translate([roundness+end_gap+control_gap/2, wall_thickness+depth+roundness*2, height/2])
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
}

module cable_cradle() {
   translate([roundness+end_gap+control_gap/2-20/2, depth, wall_thickness]) {
      difference() {
         cube([20, 20, height/2-wall_thickness]);
         translate([4, 10, 10])
            cylinder(d=3.2, h=12);
         translate([16, 10, 10])
            cylinder(d=3.2, h=12);
      }
   }
}

module cpu_pedestal() {
   translate([roundness+5, depth-35, wall_thickness]) {
      translate([1.75, 1.75, 0])
         difference() {
            cylinder(d=5, h=8);
            cylinder(d=2.1, h=8);
         }
      translate([55-1.75, 1.75, 0])
         difference() {
            cylinder(d=5, h=8);
            cylinder(d=2.1, h=8);
         }
      translate([1.75, 27-1.75, 0])
         difference() {
            cylinder(d=5, h=8);
            cylinder(d=2.1, h=8);
         }
      translate([55-1.75, 27-1.75, 0])
         difference() {
            cylinder(d=5, h=8);
            cylinder(d=2.1, h=8);
         }
   }
}

module top_screw_column() {
   difference() {
      cylinder(d=8, h=height);
      translate([0, 0, height-16])
         cylinder(d=3.2, h=16);
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
   translate([-small_pot_full_width/2-6/2, 0, 0])
      difference() {
         cylinder(d=6, h=small_pot_stand_height+small_pot_module_height);
         cylinder(d=3.2, h=small_pot_stand_height+small_pot_module_height);
      }
   translate([+small_pot_full_width/2+6/2, 0, 0])
      difference() {
         cylinder(d=6, h=small_pot_stand_height+small_pot_module_height);
         cylinder(d=3.2, h=small_pot_stand_height+small_pot_module_height);
      }
}

module rod_supports() {
   translate([0, 40, 0])
      cube([full_width, wall_thickness, height]);
   for(i=[0:1:2]) {
      translate([roundness+end_gap+i*control_gap-15-wall_thickness/2, 0, 0])
         cube([wall_thickness, 40, height]);
      translate([roundness+end_gap+i*control_gap+15-wall_thickness/2, 0, 0])
         cube([wall_thickness, 40, height]);
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
   translate([roundness+5, depth-35, wall_thickness+8])
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

box_underside(); // Make module underside

#big_pots(); // Ignore module

#small_pot(); // Ignore module

#throttle_rods(); // Ignore module

#esp32(); // Ignore module

