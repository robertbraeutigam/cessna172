// Pins for holding the difference potentiometers

$fn = 50;

big_pot_stand_thickness = 5;
big_pot_full_width = 16;

module straight_pin() {
   difference() {
      cube([big_pot_stand_thickness*2+big_pot_full_width, big_pot_stand_thickness, 3]);
      translate([big_pot_stand_thickness/2,big_pot_stand_thickness/2,-1])
         cylinder(h=3+2, d=3.3);
      translate([big_pot_stand_thickness*2+big_pot_full_width-big_pot_stand_thickness/2,big_pot_stand_thickness/2,-1])
         cylinder(h=3+2, d=3.3);
   }
}

straight_pin(); // Make module straight
