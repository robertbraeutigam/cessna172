// Pins for holding the difference potentiometers

$fn = 50;

big_pot_stand_thickness = 5;
big_pot_full_width = 16;
big_pot_stand_length = 20;

module straight_pin() {
   difference() {
      cube([big_pot_stand_thickness*2+big_pot_full_width, big_pot_stand_thickness, 3]);
      translate([big_pot_stand_thickness/2,big_pot_stand_thickness/2,-1])
         cylinder(h=3+2, d=3.3);
      translate([big_pot_stand_thickness*2+big_pot_full_width-big_pot_stand_thickness/2,big_pot_stand_thickness/2,-1])
         cylinder(h=3+2, d=3.3);
   }
}

module u_pin() {
   difference() {
      cube([big_pot_stand_thickness, big_pot_stand_length, 3]);
      translate([big_pot_stand_thickness/2,big_pot_stand_length/2,-1])
         cylinder(h=3+2, d=3.3);
   }
   translate([big_pot_full_width+big_pot_stand_thickness, 0]) {
      difference() {
         cube([big_pot_stand_thickness, big_pot_stand_length, 3]);
         translate([big_pot_stand_thickness/2,big_pot_stand_length/2,-1])
            cylinder(h=3+2, d=3.3);
      }
   }
   cube([big_pot_stand_thickness*2+big_pot_full_width, big_pot_stand_thickness, 3]);
}

// straight_pin(); // Make module straight

u_pin(); // Make module u
