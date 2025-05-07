// Pins for holding the difference potentiometers

$fn = 50;

module clamp(width) {
   difference() {
      union() {
         cylinder(h=width, d=9);
         translate([0, -3, 0])
            cube([9, 4+2, width]);
      }
      translate([0, 0, -1])
         cylinder(h=width+2, d=6.2);
      translate([1, -1, -1])
         cube([width+2, 2, width+2]);
      translate([6, 5, width/2])
         rotate([90, 0, 0])
            cylinder(h=width+2, d=3.3);
   }
}

module clamp_slider() {
   clamp(10);
   translate([-15, -2, 0]) {
      difference() {
         cube([12, 4, 10]);
         translate([-1, 1.25, 2.5])
            cube([15, 1.5, 5]);
      }
   }
}

// clamp(8); // Make module plain

clamp_slider(); // Make module slider
