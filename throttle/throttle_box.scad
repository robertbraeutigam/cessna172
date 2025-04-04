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
big_pot_stand_width = 15;
big_pot_stand_bridge = 6;

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
   // Throttle pot stand
   translate([roundness+end_gap+control_gap, 55, 0])
      big_pot_stand();
   translate([roundness+end_gap+2*control_gap, 55, 0])
      big_pot_stand();
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
      cube([big_pot_stand_width+3, big_pot_stand_thickness, big_pot_stand_height], center=true);
   translate([-big_pot_stand_width/2-6/2, 0, 0])
      difference() {
         cylinder(d=6, h=big_pot_stand_height+big_pot_stand_bridge);
         cylinder(d=3.2, h=big_pot_stand_height+big_pot_stand_bridge);
      }
   translate([+big_pot_stand_width/2+6/2, 0, 0])
      difference() {
         cylinder(d=6, h=big_pot_stand_height+big_pot_stand_bridge);
         cylinder(d=3.2, h=big_pot_stand_height+big_pot_stand_bridge);
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

box_underside(); // Make module underside

