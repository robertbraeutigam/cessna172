// Frame clamp foot
//
// Screwed onto the side of a frame hanger in front of the desk edge (two M5
// into T-nuts in the hanger's side slot), its arm reaches back under the
// desk top. An M6 nut sits in the pocket on top of the arm; an M6 x 40
// thumb screw from below goes through it and presses up against the desk
// underside, so the frame is clamped onto the desk edge. Four of them, one
// per hanger. The shape and its values are in frame.inc.scad.
//
// Print on its side (flat x face on the bed), so the layers run along the
// arm.

include <frame.inc.scad>

$fn = 40;

rotate([0, -90, 0]) translate([0, 0, -foot_z0]) clamp_foot(); // Make module foot
