# Yoke

[Cessna 172 home cockpit](../README.md) / `yoke/`

The Cessna control wheel, hollow, with a PTT button on
each horn, an electric trim rocker on the left one, an Arduino Nano inside
and its USB cable out through the control tube.

[![Yoke](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)](https://robertbraeutigam.github.io/cessna172/yoke/yoke_montage.png)

The shape is the Cessna wheel's (proportions from photos, not measured): a
trapezoid hub in the middle that the control tube goes into, a bar under
it with a flat top and a bottom that sags in one curve from end to end,
and an arm ("horn") at each end, flared at its root, 34 mm wide and
leaning 25 degrees inwards (`arm_tilt`). Each arm goes on into a head at
about its width, square on its end (so its top slopes down towards the
middle) and standing out towards the pilot: a flat top pad, a 45 degree
pad between it and the pilot face for the thumb, and a thumb rest on the
head's inner side: a shelf square to the side, tilted 30 degrees so its
top faces the pilot, its top curving smoothly out of the side into the
shelf, its underside angled back into the side, so the thumb lies on it. It is 378 mm wide,
212 mm high (with the heads) and
40 mm deep, 54 mm at the heads,
with flat front and back faces and 8 mm rounded edges. The yoke ends at
the control tube: the base the tube goes into (the future force feedback
yoke, or any bearing that takes the tube) is not part of it.

`yoke.scad` holds everything. The outline is a list of points at the top
(`bar_*`, `hub_top`, `arm_end`, `arm_outer`, `arm_inner`), rounded with
`fillet` and `round`; `assert`s check that the pieces fit the bed and that the
buttons, the Nano and the cable fit inside.

## How it is built

The wheel is a 2.5 mm shell, hollow from one head to the other:

- **Pieces:** it is cut in its middle plane into a front half (towards the
  panel) and a back half (towards the pilot), and each half across the bar
  into a center piece and two horn pieces. The front half is cut further
  out (`xs_fwd`, 115 mm from the middle) than the back half (`xs_aft`,
  70 mm), so the pieces overlap like bricks: the front center piece (230 x
  157 mm) reaches over both joints of the back half and holds the back
  horn pieces, the front horn pieces sit on the back horn pieces. All six
  print outer face down, without supports (the rounded edges are printed
  in 4 steps, `edge_steps`); a back horn piece is 119 x 172 mm.
- **Screws:** 22 M3 x 12 socket head screws from the front, the side the
  pilot does not see, through bosses in the front pieces into bosses in
  the back pieces (self tapping). The bosses in the bar are above and below
  its middle, so the wires pass between them; in the arms they are on the
  outer side. A lip around the rim of the back pieces goes into the front
  pieces and lines them up.
- **Heads:** separate prints, top face down (the 45 degree pad prints
  without supports), 36 mm wide and 44 mm high (`head`, `head_chamfer`). They stand out 14 mm
  towards the pilot (`head_bulge`), which the flat shells could not. A spigot under each goes into the arm's
  open end, one M3 x 10 through the front of the arm holds it.
- **Thumb rests:** separate prints, back face down (no supports), only on
  the head's flat inner side, nothing below it. Profile: a concave 9 mm
  round from the side into a shelf at 90 degrees, 16 mm out of the side,
  a rounded tip and the underside straight back into the side (`thumb`,
  `thumb_round`); it runs 26 mm along a line tilted 30 degrees, pilot end
  lower (`thumb_angle`, `thumb_pos`). Two M3 x 8 socket head screws in
  counterbores in the underside go into pads inside the head wall (glue as
  well if you like).
- **Control tube:** a 25 x 2 mm aluminium round tube (about the real 1",
  `tube_od`), 110 mm above the bar's bottom (`z_shaft`). Its end stands on
  the hub's front; a printed collar holds it, bolted onto the hub's front
  with 4 M4 (nuts inside, on a thickened wall) and through the tube with
  two M4 cross bolts at right angles (nut traps in the collar). The hub
  front has a 21 mm hole inside the tube for the cable.

## Inside

- **Buttons:** a 12 mm momentary push button with a red cap on the top
  pad of each head; on the left head's 45 degree pad, under the thumb, a
  momentary (ON)-OFF-(ON) mini rocker for the electric trim, as on the
  real wheel (the right pad is blank, room for one more button). Their nuts are inside the heads; the wires run down the inner
  side of the arms and along the bar into the hub.
- **Nano:** an Arduino Nano running MobiFlight stands in a pocket on the
  back center piece's inside, under the tube's hole, its USB jack up (the
  shared rails of [`lib/nano.inc.scad`](../lib/nano.inc.scad) without
  their lips: a shallow ledge under each long edge, clear of the pin rows'
  solder, a wall beside it, and a stop under it; it goes in from the front
  and a dab of hot glue holds it). Inputs, all to
  GND (active low, the Nano's internal pull-ups): D2 left PTT, D3 trim
  nose down, D4 trim nose up, D5 right PTT. The other pins are free (an
  analog one, e.g. A0, could take a map light dimmer pot). So the yoke is
  tested on its own with nothing but its USB cable.
- **Cable:** the USB cable comes out of the tube, is tied onto the block
  between the hole and the plug with a cable tie (strain relief, so a pull
  does not lever the jack) and plugs into the Nano. It runs through the
  tube to the powered USB hub (see
  [Connections](../README.md#connections)); the plug fits through the
  tube (21 mm inside). In a base that turns and slides the tube, leave
  the cable slack behind the tube's end for the full travel.
- **USB:** one port on the powered USB hub; the Nano and the buttons take
  about 50 mA.

| File | Parts |
|------|-------|
| `yoke.scad` | `center_fwd`, `center_aft`, `horn_fwd_left/right`, `horn_aft_left/right` (shells), `head_left/right`, `thumb_left/right`, `collar` |

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | aluminium round tube, 25 x 2 mm | control tube, the length the base needs |
| 2 | 12 mm momentary push button | PTT, left and right |
| 1 | momentary (ON)-OFF-(ON) mini rocker, 13 x 19 mm cut-out | electric trim |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB), hot glue | MobiFlight board of the yoke |
| 1 | mini USB cable, long enough through the tube to the powered USB hub; cable tie | to the PC |
| 22 | M3 x 12 socket head screw | shell pieces |
| 2 | M3 x 10 screw | heads |
| 4 | M3 x 8 socket head screw | thumb rests |
| 4 | M4 x 20 socket head screw, nut, washer | collar onto the hub |
| 2 | M4 x 40 screw, nut | cross bolts through collar and tube |

**MEASURE:** the tube (`tube_od`, `tube_wall`), the buttons (`ptt_*`:
hole, body length, nut size; the head's 2.5 mm top must be within their
panel range), the rocker (`trim_*`: cut-out and body depth), the USB
plug and cable (`usb_plug`, `cable_d`; the plug sits between the Nano and
the tie block); the Nano's values are in
[`lib/nano.inc.scad`](../lib/nano.inc.scad) (`nano_*`).

## Assembly

1. Put the buttons and the rocker into the heads (nuts inside) and solder
   a long wire to each contact; GND is one wire chained over the left
   head's contacts and one from the right head.
2. Flash the Nano with MobiFlight (step 7), so it can be tested on the bench.
3. Push the USB cable through the tube. Bolt the collar onto the front
   center piece (nuts inside), push the tube into the collar up to the
   hub, drill it through the cross bolt holes and bolt it.
4. Lay the back pieces face down side by side. Push the head wires down
   the arms and along the bar, solder them to D2..D5 and GND of the Nano,
   put it into its pocket (hot glue), plug the cable in and tie it onto
   its block.
5. Put the front pieces on, the lips into them, and screw them on from the
   front: the center piece first, then the horn pieces.
6. Screw the thumb rests onto the heads. Put the
   heads on (spigots into the arms, wires pulled through) and screw them
   on.
7. In the MobiFlight Connector (the Nano flashed and named *Yoke*), D2
   and D5 are buttons for the PTT, D3 and D4 for the trim.
