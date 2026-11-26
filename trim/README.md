# Trim wheel

[Cessna 172 home cockpit](../README.md) / `trim/`

[![Trim wheel](https://robertbraeutigam.github.io/cessna172/trim/trim_montage.png)](https://robertbraeutigam.github.io/cessna172/trim/trim_montage.png)

The elevator trim wheel with its position indicator, for the pedestal under
the throttle (see [Cockpit frame](../frame/README.md)). The wheel turns a
rotary encoder directly. A 9 g servo swings a pointer behind a window
beside the wheel, between NOSE DOWN and NOSE UP.

This is an OpenSCAD remake of
[Trim Wheel by FlightSimMaker](https://www.thingiverse.com/thing:4290141)
(Thingiverse 4290141), licensed under Creative Commons Attribution -
Non-Commercial - Share Alike. The sizes were measured off the original
STLs. Each part prints in the original's orientation and is within a few
percent of its volume. Like the original, this remake may only be shared
under the same licence and not used commercially.

| File | Parts |
|------|-------|
| `trim.scad` | face plate, case, wheel, spacer, bushing, encoder bracket (`bracket`, and `bracket_large` for an encoder with a longer bushing), servo bracket, arm (the pointer), smoother |

## How it works

- **Wheel**: a 5 mm disc with a round rim and 24 balls (10 mm) on it,
  134 mm across. Its axis lies 17 mm behind the face plate (`y_ax`), so
  about a third of it stands out of the slot in the plate (12 mm wide).
  The wheel sits on the spacer's stub (glued). The spacer's shaft turns
  in a printed bushing in the encoder bracket, and its end is pushed onto
  the encoder's shaft (6 mm bore).
- **Hood**: two halves of a cylinder round the wheel's axis stand on the
  face either side of the slot, so the wheel looks like it turns in a
  housing.
- **Smoother**: a 60 mm disc with grooves in its face that rubs on the
  wheel's right face, on the axis. Its keel is glued against the face
  plate's back, its edge in the slot's back chamfer. It steadies the
  wheel and adds a little friction over the encoder's detents. Where it
  goes is not in the original's files: its keel fits the slot's chamfer
  and puts its middle exactly on the wheel's axis, so this is very likely
  its place.
- **Indicator**: the 60 mm arm is screwed onto the servo's shaft (its own
  2.7 mm hole, the horn screw). It swings in the plane of the window
  (5 x 50 mm), its tip passing just behind the curved rims on both sides
  of it. The servo hangs by its ears in the servo bracket, which stands
  on the face plate's back in an L shaped pocket. The servo's depth is
  set by the bracket's ear holes. The arm's place along the shaft
  (`arm_x`) is a guess, the asserts keep it in the window.
- **Case**: a box with 2 mm walls, open at the front. It has bosses with
  4.5 mm holes for heat set inserts in the four front corners, and a 10 mm
  hole in the top for the cables. The face plate is screwed onto it
  through counterbored holes. The bosses stop 3 mm behind the case's front
  edge, as in the original.

## Hardware

- Rotary encoder with a 6 mm shaft and an M7 bushing (EC11 size), held by
  its nut in the bracket's front plate, its anti-rotation tab in a blind
  hole. The shaft must reach 15 to 18 mm past the mounting face
  (`enc_shaft_l`, MEASURE): it goes 4 to 7 mm into the spacer.
- 9 g servo (SG90 size), two small self tapping screws through its ears.
- 4 heat set inserts and 4 screws for the face plate.
- Glue (CA or epoxy) for the brackets, the smoother and the wheel on the
  spacer.

## Assembly

1. Glue the encoder bracket's base into the pocket on the face plate's
   back (the bearing's upright towards the slot) and the servo bracket
   into the L pocket (its plate towards the window).
2. Press the bushing into the bracket's bore, push the spacer through it
   from the slot's side and the encoder's shaft into the spacer from the
   other side; tighten the encoder's nut.
3. Glue the wheel onto the spacer's stub and the smoother onto the plate,
   against the wheel's right face.
4. Screw the servo into its bracket and the arm onto the servo's shaft,
   centred in the window with the servo centred.
5. Press the inserts into the case's bosses, lead the cables out through
   the top and screw the face plate on.

The board that reads the encoder and drives the servo is not part of this
design yet. In this cockpit that would be an Arduino Nano with MobiFlight,
an encoder input and a servo output for the elevator trim (see
[Connections](../README.md#connections)).
