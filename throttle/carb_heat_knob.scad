// Carb heat knob

$fn = 50;

module carb_heat_knob() {
   carb_heat_stem();
   // Head
   hull() {
      translate([0, 0, 15])
         cylinder(d=12, h=1);
      translate([0, 0, 20])
         rotate([180, 0 ,0])
            carb_heat_head();
   }
   // Pattern
   translate([0, 0, 23]) {
      difference() {
         cube([25, 25, 2], center=true);
         translate([0, 0, -1])
            cube([23, 23, 4], center=true);
      }
   }
   translate([0, 0, 22]) {
      difference() {
         cylinder(d=20, h=2);
         translate([0, 0, -1])
            cylinder(d=18, h=4);
      }
   }
}

module carb_heat_stem() {
   difference() {
      cylinder(d=12, h=15);
      translate([0, 0, -1])
         cylinder(d=6.2, h=15+2);
   }
}

module carb_heat_head() {
   intersection() {
      cube([25, 25, 5], center=true);
      translate([0, 25/2, -25+5/2])
         rotate([90, 0, 0])
            cylinder(d=50, h=25);
   }
   intersection() {
      cube([25, 25, 5], center=true);
      translate([-25/2, 0, -25+5/2])
         rotate([90, 0, 90])
            cylinder(d=50, h=25);
   }
}

carb_heat_knob(); // Module carb_heat_knob
