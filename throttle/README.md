# Throttle quadrant

[Cessna 172 home cockpit](../README.md) / `throttle/`

Throttle, mixture and carb heat in one box.

[![Throttle quadrant](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)](https://robertbraeutigam.github.io/cessna172/throttle/throttle_box_montage.png)

Each control is a 6 mm rod that comes out of the front of the box and moves
the slider of a linear potentiometer inside: long pots (130 mm) for the
throttle and mixture, a short one (75 mm) for the carb heat. The pots sit on
stands and are held down by printed pins. A printed clamp on each rod has a
slot that takes the pot's slider ear, so pulling the knob moves the slider.
An Arduino Nano running MobiFlight, on the box's floor, reads them: one USB
cable out of the back wall to the powered USB hub (see
[Connections](../hub/README.md#connections)), so the box can be tested on
its own with nothing but that cable.

The box mounts in the [cockpit frame](../frame/README.md) and has no lid: it
goes through a cut-out in the panel sheet, under the desk top, and stands on the frame's throttle bar. Its
front wall is the face, with a 10 mm flange on the top and the two sides
(none at the bottom, where the box sits on the bar) that is screwed onto
the sheet with M3 screws, nuts behind the sheet. Two M5 bolts through the
floor, at the front between the rod supports, go into T-nuts in the
throttle bar's top slot, so pulling a knob does not load the sheet alone.

| File | Parts |
|------|-------|
| `throttle_box.scad` | the box with its face flange and the Nano's rails (printed in one piece), pot holder |
| `carb_heat_knob.scad` | carb heat knob and button |
| `clamp.scad` | rod clamps for the pot sliders |
| `pin.scad` | pot hold-down pins |

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 2 | linear potentiometer, 130 mm | throttle, mixture |
| 1 | linear potentiometer, 75 mm | carb heat |
| 3 | 6 mm rod, with nuts | one per control |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | MobiFlight board of the box |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| - | hookup wire, stranded | Nano to the pots |
| - | M3 screws | pot hold-downs, one in each rod clamp (M3 x 10) |
| 2 | throttle and mixture knob, printed from other sources (not in this repo; the views only show them) | on the throttle and mixture rods |
| 5 | M3 x 10 pan head screw + nut | face flange onto the cockpit sheet |
| 2 | M5 x 10 button head screw + washer + T-nut | floor into the throttle bar (counted in the frame) |

## Wiring

The Nano lies in two rails on the floor between the carb heat pot and the
throttle pot, component side up, its USB jack against the back wall. It
slides in from the front; a dab of hot glue at its front end keeps it
there when the plug goes in. The USB cable plugs in from behind, through
a window in the back wall (`usb_plug` is the plug's body, measure it), so
the box has no cable of its own: pulling the cable only unplugs it. The
pots are wired straight to the Nano's pins:

| Nano pin | To |
|----------|----|
| 5V | carb heat pot, end tab |
| GND | carb heat pot, other end tab |
| A0 | throttle pot wiper |
| A1 | mixture pot wiper |
| A2 | carb heat pot wiper |

Two short wires take 5 V and GND on from the carb heat pot to the same end
tabs of the throttle and the mixture pot, the same end of every pot to
5 V, so all three read the same way. If a control reads backwards, swap
its pot's two end tabs (or invert it in the Connector).

## MobiFlight

Flash the Nano with the MobiFlight firmware in the Connector and give it a
name (*Throttle*). Add an *Analog input* on A0, A1 and A2 and let each set
its dataref, e.g. `sim/cockpit2/engine/actuators/throttle_ratio_all`,
`sim/cockpit2/engine/actuators/mixture_ratio_all` and
`sim/cockpit2/engine/actuators/carb_heat_ratio` (index 0), scaled from the
pot's 0-1023 to 0-1 in the transform. Check the names against the
Connector's dialog and X-Plane's dataref list, as they change between
versions.
