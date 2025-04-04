// Throttle box with carb heat, throttle, mixture

$fn = 30;

// Box dimensions
height = 50;
depth = 150;
roundness = 10;
control_gap = 55;
end_gap = 40;
wall_thickness = 3;

// Calculated
width = 2 * control_gap + 2 * end_gap;
full_width = width + 2*roundness;

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

box_underside();

