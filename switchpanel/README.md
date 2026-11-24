# Switch panel

[Cessna 172 home cockpit](../README.md) / `switchpanel/`

The lower left switch panel of the 172N.
Similar in function to the Saitek Switch Panel, but it should look as close
to the real panel as possible. Every switch position is a raw input for
MobiFlight, active low, like a switch to GND.

It is two panels, printed separately and mounted side by side: the
[ignition](../ignition/README.md) on the left, a component of its own
([`ignition/`](../ignition/README.md)), and the switch row, which also carries the
input multiplexer for both. Their basics are in `panel.inc.scad`, which is
in both directories (keep the copies identical): both are 3 mm thick,
with the same rim, flange, mount holes and lettering. The back of each
panel is 80 mm high (`panel_h`), closed by an 8 mm rim, and goes through a
hole in the cockpit sheet ([frame](../frame/README.md)); a 10 mm face flange
(`flange_w`) all round sits on the sheet and is screwed to it with M3
screws, nuts behind the sheet; the face is 3 mm in front of the sheet.

The whole switch panel hangs below the desk top, in the frame's lower
panel (see [Cockpit frame](../frame/README.md)). The ignition sits 20 mm
higher than the switch row (the frame's `switch_ign_rise`, as much as its
back clears the desk's underside), with the [primer](#primer) under its
key, like in the X-Plane 172N: a third, small panel of its own
(`primer.scad`) with its own hole in the sheet. So the two panels are
separate, each with its own hole and its flange all round, their faces
2 mm apart (20 mm of sheet between the holes). `panel.inc.scad`
takes the height of the back as a parameter for it.

## Primer

[![Primer](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/primer_montage.png)

`primer.scad`: the push-pull primer with its twist lock, read by a linear
pot. It is a separate 47 x 47 mm panel under the ignition, centered
under its key like in the X-Plane 172N, left of the switch row and a
little lower, in its own cut-out in the sheet (20 mm of sheet under the
ignition's), so the ignition panel stays as it is. The knob pulls out 45 mm (`stroke`,
about the 1¾" of a panel plunger primer) and pushes back in; fully in, it
turns a quarter turn clockwise to lock, and only then. Turned back
(counterclockwise), a spring pops it 5 mm out (`pop`), like the real one.

### How it works

The same idea as the [throttle quadrant](../throttle/README.md): a 6 mm rod
moves the slider of a linear pot, through a clamp-like carrier with a slot
over the pot's slider ear. The pot is the 75 mm one used for the carb heat.

- **Knob and twist lock:** the knob's 10 mm stem slides in a square tube on
  the back of the panel, the front bearing. A lug on the end of the stem
  runs in a keyway along the tube, so the knob cannot turn while it is out
  and always comes back lined up. At the back of the tube the keyway opens
  into a quarter turn pocket: fully in, the lug turns into it and the end of
  the keyway holds it (locked). Pulled out, the lug stops on the back of
  the panel plate.
- **Knob:** two parts, since the stem's lug does not go through the face:
  the stem goes into the tube from behind, the knob head is pushed onto
  its front end from the front. A flat on the stem's end lines the two up.
- **Rod:** a short M3 screw from the side of the knob head, through the
  stem, its head sunk in a counterbore, holds the rod and the head on the
  stem. The rod runs
  back through the bracket, whose front wall (screwed onto the end of the
  tube) and rear wall are two more bearings.
- **Pot:** in the bracket the pot sits on two stands, held down by two
  printed straps, with its slider ear pointing at the rod. The carrier on
  the rod is held between two rod collars (the throttle's plain clamp). The
  rod turns in it for the twist lock; the carrier itself slides between the
  bracket's two ribs, so it cannot turn.
- **Pop out:** a compression spring on the rod, between the rear collar and
  the rear wall. The collar only reaches it in the last 5 mm before the knob
  is in, so the locked lug holds it compressed, and unlocking pops the knob
  out that far; the rest of the stroke is free.

The bracket is beside the rod towards the pilot's right, about 49 x 26 mm
across (it reaches about 38 mm to the side of the rod, its walls 11 mm to
the other side over the tube), and with the knob in, the rod ends about 193 mm behind the panel,
under the ignition and clear of the frame's upright and brace. The
bracket is wider than the cut-out, so it goes on from behind the sheet.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | linear potentiometer, 75 mm (like the carb heat one) | primer position |
| 1 | 6 mm rod, 208 mm (`rod_len`) | knob to the pot carrier |
| 1 | compression spring, about 9 mm OD, 6.8 mm ID, 15 mm long (`pop_spring_*`) | pops the knob out when unlocked |
| 2 | `throttle/clamp.scad` plain clamp (`clamp_plain.stl`), with an M3 screw + nut | rod collars on both sides of the carrier |
| 4 | M3 x 12 socket head screw | bracket onto the tube |
| 4 | M3 x 10 screw | pot straps onto the stands |
| 1 | M3 x 4 socket head screw (`knob_screw`; an M3 x 5 needs a head under 2.5 mm) | knob onto the rod |
| 4 | M3 x 10 pan head screw + nut | face flange onto the sheet |
| - | 3 wires | pot to the switch panel's Nano |

Printed: `primer_panel.stl` (front side down), `primer_face.stl` (front
side up), `primer_knob.stl` (the head, front down), `primer_stem.stl`
(on its lug end), `primer_bracket.stl`
(on its spine), `primer_strap.stl` (2x), `primer_carrier.stl`.

The pot's travel (`pot_travel`) is measured: 60 mm, so the 45 mm stroke
uses the middle three quarters of it (the build fails if the stroke comes
within 4 mm of the travel). **MEASURE:** the pot's slider ear (`pot_ear`)
and the spring you pick (`pop_spring_od`, `_id`, `_len`, `_solid`): it
has to fit over the rod and on the collar, and it must not go solid
before the knob is in; the bracket gets longer for a longer spring. A
stiffer spring pops harder, the pot slider's friction works against it.

### Assembly

1. Paint the label, put the face on the panel, push the panel through its
   cut-out and screw the flange onto the sheet.
2. From behind: put the knob's stem into the tube, the lug in the keyway,
   and push it in until its front end comes out of the face. Push the
   knob head onto it from the front, the flats lined up (the screw holes
   then line up too).
3. Screw the bracket onto the end of the tube (hex key through the holes
   in its rear wall).
4. Solder three wires to the pot, put it onto its stands and screw the
   straps on.
5. Push the rod in from the back: through the rear wall, the spring, a collar, the
   carrier (its slot over the pot's ear), the other collar, the front wall
   and into the stem up to the head's front wall, and screw the knob screw
   through the head and the stem onto the rod.
6. With the knob out, slide the carrier to where the ear is 22.5 mm
   (`stroke / 2`) in front of the pot's middle, and tighten the collars
   against it so the rod still turns.

### Wiring and X-Plane

The pot connects to the switch panel's [Nano](#nano): its ends to 5 V
and GND there, the wiper to A7 (an analog input). Which end goes to 5 V
decides the direction; swap them, or invert the range in the MobiFlight
Connector.

In the MobiFlight Connector it is an analog input on A7 that writes the
primer's dataref. **VERIFY** which dataref the X-Plane 172 uses for the
primer with DataRefTool while working the primer in the virtual cockpit.

## Switches

[![Switch panel](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)](https://robertbraeutigam.github.io/cessna172/switchpanel/switches_montage.png)

`switches.scad`: the switch row, laid out like the panel of the X-Plane
172N (which differs from a real one, e.g. in the split AVIONICS). The
red split MASTER (ALT, BAT) on the left, toggle switches in the middle
(PITOT HEAT, then the LIGHTS group: BCN, LAND, TAXI, NAV, STRB) and the
black split AVIONICS (BUS 1, BUS 2, with white caps) on the right; the panel ends there.
Up is ON, like in the airplane: every toggle has OFF under it, the rockers
ON beside their top half, towards the toggles. The rockers have their name
above and the two switch names below them, and sit higher than the
toggles, about half way up to the breakers (`rk_raise`). Above the toggles
is a row of circuit breakers, as in the X-Plane panel; they are for show
only.

The switch list (`groups` in the source) drives the layout. The
panel is 216.6 x 100 mm (the back 196.6 x 80 mm). Like the ignition, its
front is a separate 1 mm face with the labels standing 0.8 mm out of it,
for a white paint pen; the face is printed front side up
(`switches_face.stl`), the panel front side down, so neither needs
supports, and together they are 3 mm thick. The toggle nuts, the rocker
lips and the mount screws clamp the face on. The switches and labels need about 61 mm of the back's height, the
rest is split between above and below them. The rim on the back stiffens
it.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one; printed white caps) | AVIONICS: BUS 1, BUS 2 |
| 6 | toggle switch, M12 neck, 18 mm lever | PITOT HEAT, BCN, LAND, TAXI, NAV, STRB |
| 6 | M3 x 10 pan head screw + nut | panel onto the cockpit sheet (`mount_count`) |
| 1 | Arduino Nano (ATmega328P, 5 V, mini USB) | all inputs, see [Nano](#nano) |
| 2 | M3 x 8 self tapping screw | carrier (`switches_carrier.stl`) onto the panel |
| 4 | printed rocker cap (`switches_cap.stl`, 2 in red, 2 in white) + CA glue or epoxy | the Cessna look, see [Rocker caps](#rocker-caps) |
| 6 | printed dummy breaker (`switches_breakers.stl`) + glue | circuit breakers, see [Circuit breakers](#circuit-breakers) |
| 1 | mini USB cable, long enough to the powered USB hub | the Nano to the PC |
| 1 | cable tie, up to 3.6 mm wide | the USB cable onto its block (`tie`) |
| 1 | 7 pin Dupont or JST connector (optional) | ignition cable, so the panels can be separated, see [Wiring](#wiring) |
| - | wire, heat shrink | see [Wiring](#wiring) |

### Double rocker switches

[Double Rocker Switch 6-Pin 250V 16A/AC Red Rocker Illuminated On/Off](https://www.amazon.de/-/en/Double-Rocker-Switch-6-Pin-Illuminated/dp/B0DLTMGKSS),
in red for MASTER and black for AVIONICS. Two independent rockers side by
side in one housing, tall and narrow like the real split switches.

They snap into a cutout from the front: ramps on their top and bottom end
catch behind the face and the panel, which is thinned there by a pocket
in the back, to 0.5 mm behind the 1 mm face.
Dimensions from the listing (`rk_*`):

- panel cutout 22 x 28.5 mm (width x height)
- front lip 24.3 x 31.3 mm, 2 mm thick
- body 21.7 x 25.3 mm, no mounting holes
- 31.5 mm from the front to the end of the pins

**MEASURE when they arrive:** the gap between the lip and the ramps, i.e.
the panel thickness they snap onto (`rk_grip`, now 1.5 mm). Also check the
pin positions.

The lamps are neon (250 V) and will not light on 5 V; leave the lamp pin
unconnected. Each rocker has 3 pins: find the two that close when the
rocker is ON with a multimeter.

### Rocker caps

The bought switches have lit, curved paddles with O and I on them and
come only in red and black. Printed caps glued onto the paddles give
them the look of the real Carling split switches: each cap's top is a V
(two faces rising 12° from a crease across the middle, `rk_cap_v`), so
the pressed half lies almost flat and the other sticks out with a sharp
end, with ribs across it. The two caps of a switch reach over the bar
between the paddles to a 0.6 mm split (`rk_cap_gap`), so it looks like
one switch cut in two. MASTER gets red caps, AVIONICS white ones on the
black switch, whose black lip then matches the real frame. The caps
cover the paddles' lamps.

The caps' underside is the paddle's concave top, so they seat in one
place; glue them on with CA glue or epoxy. They
are printed on their side, the profile on the bed (`switches_cap.stl`, all four the same,
no supports).

**MEASURE when the switches arrive (`rk_*` paddle values, now guesses
from photos):** the paddle's width and length (`rk_paddle_clear` to the
lip's window), how far its top stands in front of the lip at its middle
(`rk_paddle_h`), the curve of its top (`rk_top_r`), the throw
(`rk_rocker_tilt`) and the pivot depth (`rk_pivot_d`; from the height of
the two ends when ON and OFF). An assert checks that a cap clears the lip
when its end is pressed in.

### Toggle switches

Standard M12 toggle switches, about the size of the real ones. From the
listing: body 30 x 15.5 x 15 mm, 12 mm neck (M12 thread), 18 mm lever.
Either a 2 pin ON-OFF or a 6 pin ON-ON (DPDT) switch works. Do not take an
ON-OFF-ON one (e.g. "-203"): the real switch has no center position.

The toggles go in from the back, and a nut and washer on the front clamp
them. The body sits in a 1 mm deep square pocket in the back of the panel,
so it cannot turn.

**MEASURE when they arrive** (`tg_*`, `toggle = "M12"`):

- The 30 mm is assumed to be from the top of the body to the end of the
  lugs, and 15.5 x 15 mm the body.
- The thread length (now 9.5 mm; the panel is 2 mm thick there, the washer
  and nut need about 4 mm of it).
- The nut across flats (now 14 mm). The switches are 19 mm apart, so a nut
  up to about 15 mm fits; the build checks this.
- The lever and the lug positions.

The mini MTS-202 (M6, 10 mm lever) works too: set `toggle = "MTS-202"`.
amazon.de listings:
[ETOPARS, 10 pieces](https://www.amazon.de/ETOPARS-Kippschalter-Armaturenbrett-Wippschalter-L%C3%B6tanschluss/dp/B08Z7R4RB9),
[Taiss, 10 pieces](https://www.amazon.de/MTS-202-Terminals-Positionen-Kippschalter-wasserdichte/dp/B07JNV6SCJ).

### Circuit breakers

The real 172N has a row of push-to-reset circuit breakers above the
switches, each with its name on the panel above it and its rating (A) on
the button. Here they are non-functional dummies: a hex nut with a button
on top and the rating engraved into the button, all printed as one part
(`switches_breakers.stl`, nut side down). They are glued into hex holes in
the 1 mm face, onto the panel behind it, which locate them and keep them
straight; nothing goes through the panel. Print them in black and paint the
nut silver and the rating white, or print the nut and the button in
different colors.

They are the ones of the X-Plane 172N's row over the toggles: FLAP 10,
INST 5, AVN BUS 1 15, AVN BUS 2 15, TURN COORD 5, INST LTS 5 (its ALT
FLD and WARN breakers right of AVIONICS are left out, the panel ends at
the AVIONICS switch). The list (`breakers` in the source, name lines and
rating) is placed over the toggles, one above each, from the left; the build checks that the row
still fits the panel height, and the top middle mount screw moves between
two breakers. Real breakers
(e.g. Klixon push-to-reset) would need a bigger hole and room behind the
panel, so making them functional later means a hole through the panel
as well.

### Nano

All switches, the ignition and the primer go to one Arduino Nano running
MobiFlight on the back of the switch panel, each on a pin of its own
(the Nano has enough of them: 15 inputs and the primer's analog pin). One
USB cable runs from it to the powered USB hub (see
[Connections](../README.md#connections)), so the switch panel with
the ignition and the primer can be tested on its own with nothing but
that cable.

**USB**: one port on the powered USB hub for the switch panel, the
ignition and the primer: the Nano about 50 mA, the ignition's five hall
sensors a few mA each, under 100 mA in all.

The Nano lies in rails on a small printed carrier plate
(`switches_carrier.stl`, printed plate down), component side out, its USB
jack to the right, without screws (M2 screws do not go through its
1.8 mm holes, and there is no room to drill them out). A wall along each
long edge holds the board's edge in a shallow groove: the ledge under it
and the lip over it reach only 0.35 mm over the board (`nano_rail_reach`),
short of the pin rows' pads, so the solder joints pass them. The rails are
open at the left end: the Nano slides in from there, USB end first, wires
and all, up to the two stops beside the plug. It cannot come out of the
rails up or sideways, and once the cable is plugged in and tied onto its
block it cannot slide back out either; to take it off, cut the tie. The
groove is tight on purpose (`nano_rail_clear`, 0.15 mm a side): measure
your Nano's width (`nano_board`), clones differ. The rails are the shared
ones of [`lib/nano.inc.scad`](../lib/nano.inc.scad). Right of the plug is the block for the
cable tie: the tie goes through the slot at the plate and around the
cable in the groove on top, so pulling the cable does not lever the jack.
The carrier is a part of its own, so the ignition and the primer can be
wired up before the switch panel is printed; it is then screwed with two
M3 x 8 self tapping screws onto two bosses on the panel back, in the
strip behind the breaker labels, on the left (pilot side) half, where the
ignition cable comes in. `assert`s check that the carrier clears the
switches, fits inside the rim and holds the cable at the jack's height.

**MEASURE**: the USB plug (`usb_plug`: width, height and length with its
strain relief, the tie block sits behind it) and the cable (`cable_d`,
4 mm); the tie (`tie`, 3.6 x 1.3 mm). They and the tie block are the
shared ones of [`lib/usb.inc.scad`](../lib/usb.inc.scad). The Nano's values, pinout and rails
are in [`lib/nano.inc.scad`](../lib/nano.inc.scad) (`nano_*`), shared by
every component; its mounting holes (`nano_holes`, `nano_hole_d`)
are the official Nano's (1.8 mm, 40.64 x 15.24 mm, in line with the pin
rows), only drawn in the views.

#### Inputs

| Pin | Input | Pin | Input |
|-----|-------|-----|-------|
| D2 | MASTER ALT | D10 | AVIONICS BUS 1 |
| D3 | MASTER BAT | D11 | AVIONICS BUS 2 |
| D4 | PITOT HEAT | D12 | free |
| D5 | BCN | A0 | ignition OFF |
| D6 | LAND | A1 | ignition R |
| D7 | TAXI | A2 | ignition L |
| D8 | NAV | A3 | ignition BOTH |
| D9 | STRB | A4 | ignition START |
| | | A7 | primer pot (analog) |

The switches are in label order (the `groups` order, `switch_pins`), the
ignition positions on A0-A4 (`ignition_pins`, used as digital pins); D13
is not used (its LED pulls an input down), A5 and A6 are free. In the
MobiFlight Connector every switch and ignition position is a *Button*
with the Nano's internal pull-up (the wires stay on the panels, they are
short): a toggle or rocker sets its dataref to 1 on press and to 0 on
release, an ignition position sets the key position on press, and START
holds the starter while it is pressed through a FlyWithLua script (see
[In X-Plane](../ignition/README.md#in-x-plane)). The OFF hall sensor is
needed: a position is only set on press, so without it the key would
stay on R in the sim when it is turned to OFF. Test it on the bench with
one switch on the Nano before soldering all of them.

### Wiring

Every input is wired like a switch to GND (active low, as MobiFlight expects):

- **Toggle, 2 pin:** one lug to GND, the other to its Nano pin. Mount it so
  it is ON with the lever up.
- **Toggle, 6 pin:** use one pole. Its middle lug (common) goes to GND, the
  bottom lug to the Nano pin: lever up (ON) connects the common to the
  bottom lug. Check with a multimeter.
- **Rocker:** the two pins of each rocker that close when it is ON; one to
  GND, the other to the Nano pin.
- **Ignition:** the A3144 outputs go to A0..A4. The sensors also need 5 V
  and GND: take them from the Nano's 5V and GND.
- **Primer:** the pot's ends to the Nano's 5V and GND, its wiper to A7.

So on the switch panel: one GND wire daisy chained over all 10 switches to
a GND pin of the Nano (it has two), and one signal wire from each switch
to its pin, soldered straight into the board. The ignition cable (5
signals, 5 V, GND) is soldered to the Nano too; to be able to separate the
two panels later, put a 7 pin Dupont or JST connector into it. GND and 5V
get several wires (switch chain, ignition, primer): join the extra wires
into one before the pin, with solder and heat shrink.

### Assembly

1. Slide the Nano into its rails on the carrier from the left end, USB
   end first, up to the stops; plug the cable in and tie it onto its
   block, which keeps the Nano in. The ignition cable (or
   its connector) and the primer can be soldered on now; the carrier does
   not need the panel yet, and it can be tested on the bench over USB.
2. Solder the wires to the switches; the rockers are hard to get out
   again once snapped in. Glue the caps onto the rocker paddles.
3. Lay the face on the front, put the toggles in from the back and
   tighten their nuts.
4. Snap the rockers in from the front.
5. Screw the carrier onto its bosses on the panel back and solder the
   switch wires to the Nano. Plug the USB cable in and tie it onto its
   block.
6. Glue the dummy breakers into their pockets.
7. Mount the panel.

### Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock (ALT pushes BAT on, BAT pushes ALT off); X-Plane does not need
  it.
