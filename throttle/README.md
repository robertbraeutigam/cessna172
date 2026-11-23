# Throttle quadrant

[Cessna 172 home cockpit](../README.md) / `throttle/`

Throttle, mixture and carb heat in one box.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

Each control is a 6 mm rod that comes out of the front of the box and moves
the slider of a linear potentiometer inside: long pots (130 mm) for the
throttle and mixture, a short one (75 mm) for the carb heat. The pots sit on
stands and are held down by printed pins. A printed clamp on each rod has a
slot that takes the pot's slider ear, so pulling the knob moves the slider.
MobiFlight on the [hub](../hub/README.md) reads them: one Cat5 cable to direct port 6,
soldered straight to the pots, with no board in the box.

The box mounts in the [cockpit frame](../frame/README.md) and has no lid: it
goes through a cut-out in the panel sheet, under the desk top, and stands on the frame's throttle bar. Its
front wall is the face, with a 10 mm flange on the top and the two sides
(none at the bottom, where the box sits on the bar) that is screwed onto
the sheet with M3 screws, nuts behind the sheet. Two M5 bolts through the
floor, at the front between the rod supports, go into T-nuts in the
throttle bar's top slot, so pulling a knob does not load the sheet alone.

| File | Parts |
|------|-------|
| `throttle_box.scad` | the box with its face flange (printed in one piece), pot holder, cable cradle top |
| `carb_heat_knob.scad` | carb heat knob and button |
| `clamp.scad` | rod clamps for the pot sliders |
| `pin.scad` | pot hold-down pins |

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | linear potentiometer, 130 mm | throttle, mixture |
| 1 | linear potentiometer, 75 mm | carb heat |
| 3 | 6 mm rod, with nuts | one per control |
| 1 | Cat5 patch cable, stranded, pure copper (see [Cables](../hub/README.md#cables)) | to hub port 6 |
| - | M3 screws | pot hold-downs, cable cradle, one in each rod clamp (M3 x 10) |
| 2 | throttle and mixture knob, printed from other sources (not in this repo; the views only show them) | on the throttle and mixture rods |
| 5 | M3 x 10 pan head screw + nut | face flange onto the cockpit sheet |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the throttle bar (counted in the frame) |

## Cable to hub port 6

The Cat5 cable to [hub port 6](../hub/README.md#ports) comes in through the hole at the
left of the back wall and is clamped in the cable cradle (its printed top
screwed onto the block on the floor, `cable_d` is the jacket, measure it),
so pulling the cable does not pull the solder joints. Behind the box it
runs through the gap to the hub's right wall. Colors are T568B (see
[Port pinout](../hub/README.md#port-pinout)):

| Wire | Signal | To |
|------|--------|----|
| blue | 5 V | carb heat pot, end tab |
| white-blue | GND | carb heat pot, other end tab |
| white-green | line A (A2) | throttle pot wiper |
| green | line B (A5) | mixture pot wiper |
| white-brown | line C (A6) | carb heat pot wiper |
| white-orange, orange, brown | - | cut short, insulate |

Two short wires take 5 V and GND on from the carb heat pot to the same end
tabs of the throttle and the mixture pot, the same end of every pot to
5 V, so all three read the same way. If a control reads backwards, swap
its pot's two end tabs (or invert it in the Connector).
