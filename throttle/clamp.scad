// Pins for holding the difference potentiometers

$fn = 50;

module clamp() {
   difference() {
      union() {
         cylinder(h=8, d=9);
         translate([0, -3, 0])
            cube([9, 4+2, 8]);
      }
      translate([0, 0, -1])
         cylinder(h=10, d=6);
      translate([1, -1, -1])
         cube([10, 2, 10]);
      translate([6, 5, 4])
         rotate([90, 0, 0])
            cylinder(h=10, d=3.3);
   }
}

clamp(); // Make module plain
