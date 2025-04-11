// Carb heat knob

$fn = 50;

module carb_heat_knob() {
   carb_heat_stem();
   difference() {
      // Head
      hull() {
         translate([0, 0, 15])
            cylinder(d=12, h=1);
         translate([0, 0, 20])
            rotate([180, 0 ,0])
               carb_heat_head();
      }
      translate([-8, -8, 20])
         cylinder(d=3.2, h=2);
      translate([8, 8, 20])
         cylinder(d=3.2, h=2);
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
      translate([0, 0, 1])
         cube([25, 25, 5], center=true);
      translate([0, 25/2, -25+5/2])
         rotate([90, 0, 0])
         cylinder(d=50, h=25);
   }
   intersection() {
      translate([0, 0, 1])
         cube([25, 25, 5], center=true);
      translate([-25/2, 0, -25+5/2])
         rotate([90, 0, 90])
         cylinder(d=50, h=25);
   }
}

module knob_top() {
   translate([0, 0, 30]) {
      cube([25, 25, 1], center=true);
      /*
      translate([8,8,-1.2])
         cylinder(d=3, h=1);
      translate([-8,-8,-1.2])
         cylinder(d=3, h=1);
      */
      translate([0,0,0.5])
         rotate_extrude(convexity = 10)
            translate([10, 0, 0])
               circle(r = 0.8, $fn = 100);
   }
}

carb_heat_knob(); // Module carb_heat_knob

knob_top(); // Module knob_top

