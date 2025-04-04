// Throttle box with carb heat, throttle, mixture

$fn = 30;

// Box dimensions
height = 50;
depth = 180;
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
      }
      // Remove clamp space
      translate([roundness+wall_thickness, 0, wall_thickness])
         cube([20, 30, 20]);
      translate([roundness+width-20-wall_thickness, 0, wall_thickness])
         cube([20, 30, 20]);
   }
   // Rod supports
   rod_supports();
   // Linear pot stands
   translate([roundness+end_gap+control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap+2*control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap, 55, 0])
      small_pot_stand();
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
      cube([big_pot_full_width, big_pot_full_length, big_pot_module_height], center=true);
      // Ear
      translate([0, 0, 16/2+big_pot_module_height/2])
         cube([1, 5, 16], center=true);
   }
}

module small_pot() {
   translate([roundness+end_gap, 49+small_pot_full_length/2, small_pot_stand_height/2+wall_thickness+small_pot_stand_height]) {
      cube([small_pot_full_width, small_pot_full_length, small_pot_module_height], center=true);
      // Ear
      translate([0, 0, 16/2+small_pot_module_height/2])
         cube([1, 5, 16], center=true);
   }
}

box_underside(); // Make module underside

#big_pots(); // Ignore module

#small_pot(); // Ignore module



