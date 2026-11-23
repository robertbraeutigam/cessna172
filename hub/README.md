# Hub

[Cessna 172 home cockpit](../README.md) / `hub/`

The box with the MobiFlight Mega and the Cat5 ports. How every component
connects to it (ports, pinout, cables, the port list) is in
[Connections](#connections) below.

[![Hub](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_montage.png)

`hub.scad` prints the box (`hub_box.stl`, floor down) and the lid
(`hub_lid.stl`, top down). The box is 172 x 135 x 53 mm with the lid
(6 ports on two walls, `port_front` and `port_side`); the build checks that
it fits the printer bed.

- **Ports**: 6 RJ45 breakout boards, their jacks behind cut-outs in the
  walls, the numbers beside the jacks. The mux ports 1-3 are along the
  front wall, numbered from the left; the direct ports 4-6 along the right
  wall, numbered from the front (see [Port pinout](#port-pinout)), so the
  two kinds can not be mixed up. The boards are screwed onto bosses on the
  floor with M3 self tapping screws from above. Their angled 8 pin headers
  point into the box, each with a strip for the jumper plugs behind it.
- **Mega**: behind the front ports, left of the right ports' jumpers, on
  6 standoffs, its USB jack through the left wall (flush with the outside,
  so any USB-B plug fits), with a cut-out in front of the power jack.
- **Shield**: a 90 x 70 mm perfboard plugged onto the Mega's analog
  headers and its double header, and screwed down at its 4 corner holes
  onto posts on the floor in front of and behind the Mega (M3 self
  tapping), so pulling a jumper off does not lift it. Every RJ45 pin is
  plugged onto it, it carries every resistor of the hub, and it is wired
  on the bench (see [Wiring](#wiring)). It only uses the
  analog headers and the double header: they are on one 2.54 mm grid,
  the digital header is not (pins 8-13 are 1.5 mm off).
- The build checks that every Mega pin the shield takes lands on a hole
  of its grid, that nothing is soldered above the Mega's ICSP header in
  the middle (measured, `mega_icsp`), that the shield's wiring is sound
  (no hole on two lines, every line in one piece from its port pins
  through its resistor to its Mega pin, bridges only between neighbouring
  used holes and on top only where that side is free), that the posts stand beside the Mega and behind the front
  ports' jumpers, and the room for a plugged jumper (20 mm: a 14 mm
  Dupont housing and the bent wire) behind the RJ45 pins and above the
  shield.
- The lid has a locating lip and is screwed onto four corner posts. Four
  ears on the floor (5.3 mm holes, M5 + T-nut) bolt the box onto the
  frame's desk part right of the yoke (see [Cockpit
  frame](../frame/README.md)): two on the left wall into the step upright's
  crossbar, one on the front and one on the back wall into the hub
  crossbar right of it. Their spacing (`ear_slot_dx`) is the frame's, and
  `frame.inc.scad` checks it.

Nothing in the box is soldered: each port is one 8 wire ribbon of
female-female jumpers from its RJ45 pins to its header on the shield, in
the same order (some of them to loose pins beside what they go to), and no
wire goes to the Mega. The shield comes off the
Mega (4 screws), so the Mega can be reused. The MobiFlight firmware is
flashed from the Connector through the Mega's USB jack in the left wall,
with the lid on.

## Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | Arduino Mega 2560 | MobiFlight board |
| 6 | RJ45 breakout board, 34 x 28 mm, angled 9 pin header (1-8 and SH) | the ports |
| 24 | M3 x 6 self tapping screw | RJ45 boards, 4 each |
| 6 | M3 x 6 self tapping screw | Mega |
| 4 | M3 x 8 self tapping screw | shield, through its 3 mm corner holes |
| 4 | M3 x 10 self tapping screw | lid |
| 1 | perfboard, 90 x 70 mm, 2.54 mm grid (31 x 26 holes), double sided, plated through holes | shield |
| 1 | male pin header, 2 x 18, straight | shield onto the Mega's double header |
| 2 | male pin header, 1 x 8, straight | shield onto the Mega's analog headers |
| 8 | male pin header, 1 x 8, straight | the headers of ports 1-3 and 6, the strip of pins with a pull-up, three cut into the other loose pins |
| 6 | 330 Ohm resistor | in series with S0-S3 and the 2 servo signals |
| 1 | resistor network, 4.7 kOhm x 8, bussed, SIP 9 (marked A09-472, e.g. Bourns 4609X-101-472LF) | pull-ups: 3 mux SIG lines, 5 direct-port switch/encoder lines |
| - | a bit of tinned copper wire | bridges between neighbouring pins |
| 48 | female-female jumper wire, 15 cm, as 8 wire ribbons | RJ45 pins to the shield, 8 per port |

Per port used: a stranded copper Cat5 patch cable, soldered at the
component end (see [Cables](#cables)).

The RJ45 boards (`rj_*`) are measured: 34 x 28 x 1.4 mm, 4 corner holes
28 x 11 mm apart (the front ones 4.5-5 mm from the jack edge), the jack
16 mm wide and 15 mm high in the middle, flush with the board edge, and
one row of 9 angled pins (1-8 and SH; the header 7 mm from the edge on
the pin 1 side, 4 mm from the other) 2 mm before the back edge, reaching
4 mm past it. Which side pin 1 is on does not change the printed box. If
one of their holes is smaller than about 3.1 mm, drill it out, keeping
clear of the traces around it.

The perfboard (`sh`) is measured too: 90 x 70 mm, 31 x 26 holes, 4 corner
holes of 3 mm, 3 mm from both edges. The Mega values, its header
positions included (`mega_analog`, `mega_double`), are from the Arduino
drawing.

## Wiring

**The shield** is built on the bench as in the drawing (`shield` view of
`hub.scad`, which also draws it in the box from the same lists,
`sh_*`): the component side, the wiring of its back drawn through it,
the front edge (ports 1-3) at the bottom. The board has to be double
sided with plated through holes (the usual green 9 x 7 cm prototype
boards are): a hole joins its pads on both sides.

[![Shield](https://robertbraeutigam.github.io/cessna172/hub/hub_shield.png)](https://robertbraeutigam.github.io/cessna172/hub/hub_shield.png)

Every line that goes to the double header has a row of its own: its 330
Ohm resistor's lead, or its pin of the pull-up network, is in the hole
beside the Mega pin, and a solder bridge on top joins that hole to the
pin. The Mega pins' pads on the back are under their header's plastic, so
they can only be soldered on top, and nothing else is joined to them. An
analog line goes from its port pin on the back to the hole behind the
analog pin, a bridge on top onto it. The rows of the double header's
inner (even) column are the lines; its outer column has no free hole
beside it and only gives the servo power (its 5 V and GND pins, at the
ends). Apart from these, a solder bridge joins two neighbouring pins
that belong together; the pins are placed so that this is every
connection, and the shield has no wires.

- **Mega side**: the 2 x 18 header under the double header and the two
  1 x 8 headers under the analog headers, pushed in from below (their
  plastic under the board, resting on the Mega's sockets) and soldered on
  top. Solder all their pins, used or not: together they hold the shield.
  Keep each of their joints on its own pad, apart from the bridges (yellow
  in the drawing).
- **Port headers**: 1 x 8 headers in RJ45 pin order for ports 1-3 and 6
  (pin 1 dark red in the drawing; plug each ribbon on the same way round
  as on its RJ45 board). The other pins are loose (blue in the drawing,
  marked port.pin), each pulled out of its port's header (pliers on the
  pin, the plastic held) and set beside what it goes to, bridged to it
  (each a line of its own, or 5 V, GND or servo power, which are joined
  anyway):
  the 8 pins with a pull-up (SIG of the mux ports, A, B, D of port 4, B,
  D of port 5) as one more 1 x 8 strip next to the pull-up network, each
  beside its network pin; the servo signals beside their 330 Ohm; port
  5's pot two holes behind A10; the servo power of ports 4 and 5 beside
  the double header's outer 5 V and GND; the 5 V pins (pin 4) of all six
  ports in a row of neighbours onto the Mega's 5 V, the GND pins (pin 5)
  the same onto its GND. Ports 4 and 5 have no header left: mark their
  jumpers. The mux ports P1-P3 stand side by side over the analog header,
  pin 8 (AUX) at the front: their pins 1-6 are neighbours, bridged into
  the mux bus (S0-S3, 5 V and GND), and each AUX pin is two holes behind
  its analog pin; port 3's S0-S3 pins are next to their 330 Ohm
  resistors, bridged to them. Port 6 lies along the analog header the
  same way.
- **Resistors**: each 330 Ohm resistor stands in its row, the body on the
  marked hole, the lead bent down into the hole beside the Mega pin;
  S0-S3 stand a hole further left, next to port 3's pins, the lead over
  the free hole between (the bodies of neighbouring rows touch, which
  does no harm). The pull-ups
  are one bussed network (a row of 8 resistors with one common pin),
  standing across the 8 pull-up rows two holes before the Mega pins, each
  pin bridged to the hole beside its Mega pin, its common pin 1 (the dot)
  in the 5 V row above them: each pull-up line has its own resistor to
  the one 5 V pin.
- **Back**: the bridges between neighbouring pins (a blob, or a short
  piece of tinned wire); there are no wires. Keep the joints flat: the shield sits 2.5 mm above the Mega's
  digital header and its 2 x 3 ICSP header in the middle. Nothing is
  soldered above the ICSP header (the red frame in the drawing: the build
  checks it); run the wires around it or flat over it.

Every line on the shield:

| Line | From (port.pin) | Through | To the Mega |
|------|-----------------|---------|-------------|
| S0, S1, S2, S3 | P1.1-P2.1-P3.1, .2, .3, .6 (bridged) | 330 Ohm | D38, D40, D42, D48 |
| SIG | P1.7, P2.7, P3.7 | 4.7 kOhm to 5 V | D22, D24, D28 |
| AUX | P1.8, P2.8, P3.8 | - | A11, A12, A13 |
| port 4 | A P4.3, B P4.6, D P4.8 | 4.7 kOhm to 5 V | D26, D32, D36 |
| port 4 servo | C P4.7 | 330 Ohm | D44 |
| port 5 | A P5.3 (pot) | - | A10 |
| port 5 | B P5.6, D P5.8 | 4.7 kOhm to 5 V | D34, D30 |
| port 5 servo | C P5.7 | 330 Ohm | D46 |
| port 6 | E P6.1, F P6.2, A P6.3, B P6.6, C P6.7, D P6.8 | - | A0, A1, A2, A5, A6, A7 |
| 5 V | P6.4, P1.4-P2.4-P3.4, P4.4-P5.4, the network's pin 1 | - | 5V (the double header's inner pin) |
| GND | P6.5, P1.5-P2.5-P3.5, P4.5-P5.5 | - | GND (inner pin) |
| servo power | P4.1-P5.1 and P4.2-P5.2 | - | the other 5V and GND (outer pins) |

D50 and D52 are free rows, and A3, A4, A8, A9, A14 and A15 are free analog pins
(each has a free hole behind it).

Check every line with a multimeter before the shield goes on: each port
pin to its Mega pin (through its resistor), and no line to its neighbour,
5 V or GND. The servo power has its own wires to the Mega's second 5 V
and GND pins (the same nets on the Mega board), so the servos' current
peaks do not move the 5 V and GND wires the pots read against.

**Ribbons**: peel 8 wires off a ribbon of jumper wires per port and keep
them together, so the colors are in the same order at both ends; peel
the wires of the loose pins off the ribbon to their pins (ports 4 and 5:
all of them). Tie each
Cat5 cable to the box so a pull on it does not reach the jumpers; once
everything works, a dab of hot glue across the plugs keeps them in (it
peels off).

Add a Servo device on D44 and D46 in the Connector.

## Assembly

1. Push a few loose header strips into the Mega's double header and
   analog headers and lay the perfboard on them: it must drop onto all
   the pins at once. Then build the shield on the bench (see
   [Wiring](#wiring)), the Mega side headers soldered while plugged into
   the Mega so they stay straight, and check it with a multimeter.
2. Screw the RJ45 boards onto their bosses (M3 x 6) and the Mega onto its
   standoffs.
3. Plug the shield onto the Mega and screw it onto its posts (M3 x 8).
4. Plug each port's ribbon from its RJ45 board onto its header on the
   shield.
5. Screw the lid on.

## Connections

- The **hub** holds the Arduino Mega with the MobiFlight
  firmware and 6 RJ45 ports. A powered USB hub next to it takes the USB
  cables (Mega, Saitek yoke, Saitek radio panel, later the
  FFB yoke, the radio stack's Mega, the audio panel's Nano, the
  compass's Nano and a Nano per instrument; see [Powered USB hub](#powered-usb-hub)), so
  one USB cable runs to the PC.
- Every MobiFlight component connects to its own hub port with one
  straight Cat5 patch cable, soldered straight to the component (see
  [Cables](#cables)): everything inside a component is soldered, the plug
  at the hub is the only separation point.
- There are two kinds of port (see [Port pinout](#port-pinout)): a **mux
  port** for a component with many switches (one CD74HC4067 mux), and a
  **direct port**, whose signal wires each go to their own Mega pin
  (four lines and the servo power on ports 4 and 5, six lines on port 6),
  for servos, encoders, pots and a few switches. Only 5 V and GND are the
  same on both, so one cable carries everything a component like the
  pedestal or the flaps needs.
- The **radio stack** (see [Radio stack](../radio/README.md)) does not use the
  hub: its encoders, displays and buttons need more pins than the ports
  have, so it has a second Mega of its own, on its own USB cable to the
  powered USB hub. Its audio panel did not fit on that Mega any more and
  has an Arduino Nano of its own, on a third USB cable.
- The **compass** (see [Compass](../compass/README.md)) does not use the
  hub either: its stepper needs four outputs and a home input, and all
  three direct ports are taken. It runs MobiFlight on an Arduino Nano of
  its own, on a USB cable to the powered USB hub.
- The **instruments** (see [Instruments](../instruments/README.md)) are
  the same: every instrument has a Nano of its own on its board carrier,
  with one USB cable out to the powered USB hub. The Nano drives the
  instrument's stepper (or two: MobiFlight takes up to 4 steppers on a
  Nano, `MaxSteppers` in its board file) with its home input, and an
  encoder if the instrument has one (the NAV indicators' OBS). Sharing a
  Mega would save no money (a Nano is about 4 EUR, a Mega about 20, and
  a shared Mega needs RJ45 boards, a shield and a box) and would cost the
  simplicity: each instrument is tested on the bench with nothing but a
  USB cable, and swapped without touching the others. The Connector tells
  the Nanos apart by the name and serial it stores on each, whichever COM
  port Windows gives them. Their motor current comes over USB too, see
  [Powered USB hub](#powered-usb-hub).

### MobiFlight

[MobiFlight](https://www.mobiflight.com/) is free and open source (MIT,
[GitHub](https://github.com/MobiFlight/MobiFlight-Connector)). The
MobiFlight Connector runs on the PC (**Windows only**) and talks to X-Plane
11/12 directly through its datarefs and commands (X-Plane's UDP interface,
no plugin). It also flashes the MobiFlight firmware onto the Mega over USB.

In the Connector, the Mega gets one device per thing on a port: a
*Multiplexer* per mux (its SIG pin as the data pin; S0-S3 are set once, on
the first mux, and shared by all), and a *Servo*, an *Encoder*, an *Analog
input* or a *Button* on a Mega pin. Each input (a mux channel is a button)
then sets a dataref or sends a command on press and on release, each output
(servo) follows a dataref. The configuration is a file: keep it with the
cockpit.

MobiFlight sends an X-Plane command only once; it cannot hold one while a
button is pressed (still open:
[MobiFlight-Connector#2405](https://github.com/MobiFlight/MobiFlight-Connector/issues/2405)).
Where a command has to be held, like the ignition START, a small
FlyWithLua (NG) plugin
script in X-Plane does it (see [In X-Plane](../ignition/README.md#in-x-plane)).

MobiFlight reads encoders only on their own pins, not through a mux, and
drives servos straight from Mega pins, without a second board: that is
what the direct ports are for.

### Port pinout

At the hub it is the RJ45 pin, at the component the wire color (the cable
is soldered there). Pins 4 and 5 (the blue pair) are 5 V and GND on every
port; at the hub they are joined on the shield (see
[Hub wiring](#wiring)) for all 6 ports.

**Mux ports (1-3):**

| Pin | T568B color | Signal | At the hub |
|-----|-------------|--------|------------|
| 1 | white-orange | S0 | mux bus, Mega pin D38 |
| 2 | orange | S1 | mux bus, Mega pin D40 |
| 3 | white-green | S2 | mux bus, Mega pin D42 |
| 4 | blue | 5 V | all ports, Mega 5 V |
| 5 | white-blue | GND | all ports, Mega GND |
| 6 | green | S3 | mux bus, Mega pin D48 |
| 7 | white-brown | SIG | the port's own Mega pin (the mux output) |
| 8 | brown | AUX | the port's own analog Mega pin (A11-A13): one analog input |

S0-S3 are shared by every mux (MobiFlight takes them once per board); at
the hub pins 1, 2, 3 and 6 of ports 1-3 are joined on the shield (the
mux bus). Every SIG line gets a 4.7 kOhm pull-up resistor to
5 V there (one of the 8 in the shield's resistor network). MobiFlight turns on the Mega's internal pull-up, but that is
weak (20-50 kOhm): on a long cable the line rises slowly after an open
switch (the cable's capacitance) and picks up the S0-S3 edges next to it,
so the mux could read a ghost input. MobiFlight's docs recommend an extra
one for long wires. It does not matter at which end of the cable it sits,
so it is on the hub's shield and the components have no resistors.

AUX goes straight to its analog pin, with no resistor on the shield: it is
meant for a pot. A button on it would need a 4.7 kOhm pull-up and a servo
a 330 Ohm in series (and power, which a mux port does not have) added on
the shield first.

**Direct ports (4-6):**

| Pin | T568B color | Signal | At the hub |
|-----|-------------|--------|------------|
| 1 | white-orange | servo 5 V (ports 4, 5), or line E (port 6) | the servo rail (the double header's other 5 V pin), or its own Mega pin |
| 2 | orange | servo GND (ports 4, 5), or line F (port 6) | the servo rail (the double header's other GND pin), or its own Mega pin |
| 3 | white-green | line A | its own Mega pin |
| 4 | blue | 5 V | all ports, Mega 5 V |
| 5 | white-blue | GND | all ports, Mega GND |
| 6 | green | line B | its own Mega pin |
| 7 | white-brown | line C | its own Mega pin (on ports 4 and 5 a servo signal through 330 Ohm) |
| 8 | brown | line D | its own Mega pin |

Each line is whatever the component needs: a pot wiper (analog Mega
pin), an encoder contact, a switch (any digital pin) or a servo signal.
The rules:

- **A servo** takes its power on the orange pair (pin 1 5 V, pin 2 GND) and
  its signal on pin 7. At the hub they go to the double header's second
  5 V and GND pins, wired on their own (see [Hub wiring](#wiring)), not to
  the blue pair. These are the same nets as the first pins on the Mega
  board, but the servo's current peaks then flow in their own wires and do
  not move the GND and 5 V of the blue pair that the pots and the logic on
  the same cable use. On ports 4 and 5 pins 1 and 2 are always the servo
  power (bridged on the shield); only on port 6 they are two more lines (E
  and F).
- **Pots** go between 5 V and GND of the blue pair, the wiper on a line.
- **Switches and encoders** go to GND (pin 5) like on a mux, active low,
  with a 4.7 kOhm pull-up to 5 V on the hub's shield on each
  line (the same reason as the mux SIG pull-up). Pots get none: it would
  pull the wiper reading.

**A wrong port does not damage the Mega**: every Mega output that goes
into a cable has a 330 Ohm resistor in series at the hub (S0-S3 and each
servo signal, on the shield), so a component in the wrong kind of port can
not short a Mega output against a switch to GND or a pot at its end stop;
mostly it only mixes up the inputs in the sim until the cable is in its own
port again (they are numbered). It is not impossible to short the supply,
though: pins 1 and 2 of ports 4 and 5 are the servo 5 V and GND, without a
resistor. A component that uses pins 1 and 2 as lines (only possible on
port 6), plugged into port 4 or 5, can join them to its other wires, e.g.
a pot wiper on pin 1 at its GND end stop shorts 5 V to GND through the
wiper. The direct ports are on the hub's right wall, the mux ports on its
front, so they are hard to mix up.

### Cables

At the hub every cable has its RJ45 plug; at the component it is soldered
straight to the mux or to the parts, without a connector. Cut a patch
cable to length, or in half for two components:

- **Stranded** patch cable, not solid installation cable: solid wire breaks
  next to a solder joint after a few bends.
- **Pure copper** ("CU"), not CCA (copper clad aluminium, common in cheap
  cables): CCA hardly takes solder and breaks easily.
- **Check the colors** against the [Port pinout](#port-pinout) before
  soldering, with a multimeter or a cable tester: most patch cables are
  T568B, a few are T568A (orange and green pairs swapped).
- **Strain relief**: tie the jacket down on the component right before the
  wires fan out (the switch panel's mux carrier has a block for a cable
  tie next to the mux), so pulling the cable never pulls a solder joint. Tin the strands
  first and put heat shrink over every joint; cut unused wires short and
  insulate them.
- Measure the run to the hub and leave some slack: the length is fixed
  once it is soldered.

### Ports

**Mux ports**:

| Port | Component | SIG | AUX |
|------|-----------|-----|-----|
| 1 | [yoke](../yoke/README.md): PTT left and right, trim rocker | D22 | A11 (free) |
| 2 | free | D24 | A12 |
| 3 | switch panel | D28 | A13, primer |

**Direct ports** (pin 4 5 V and pin 5 GND on all of them):

| Port | Component | Pin 3 (A) | Pin 6 (B) | Pin 7 (C) | Pin 8 (D) | Pins 1, 2 |
|------|-----------|-----------|-----------|-----------|-----------|-----------|
| 4 | pedestal: trim wheel, trim indicator, parking brake | D26, encoder A | D32, encoder B | D44, trim servo | D36, parking brake | servo power |
| 5 | flaps: lever and indicator | A10, lever pot | D34 (free) | D46, flaps servo | D30 (free) | servo power |
| 6 | [throttle quadrant](../throttle/README.md) | A2, throttle | A5, mixture | A6, carb heat | A7 (free) | A0, A1 (free) |

The pins are where the shield wires them (see [Hub wiring](#wiring)):
MobiFlight takes any pin for a button, encoder or servo, pots need analog
ones. The shield only reaches the analog headers and the double header
(D22-D53, of which it wires the even ones), not the digital header
(D0-D21), whose pins 8-13 are off the 2.54 mm grid. A component that needs more than a port
gives gets a second port of the kind it needs.

The direct ports leave room: a Mega has 16 analog and 54 digital pins, and
MobiFlight takes at most 6 multiplexers on one (`MaxInputMultiplexer` in its
board file); this hub has 3 mux ports, 2 of them used. More components than the 6 ports get
a second hub with its own Mega, on its own USB cable to the powered USB
hub; the Connector shows it as a second board. Two Megas can not drive the
same S0-S3 bus.

- **Pedestal**: one cable for everything on it. The trim wheel encoder
  (EC11 type, 20 detents) on lines A and B, its common on GND; set the
  encoder type in the Connector to match the encoder (steps per detent) and
  test that a fast spin does not lose steps. The trim indicator servo (9 g)
  on pin 7 and the orange pair.
- **Parking brake**: one switch, on line D of the pedestal port: two wires
  from the pedestal along the bottom bar to the brake under the yoke. A
  *Button* on D36 in the Connector.
- **Flaps** (DIY, on the sheet right of the throttle box): the lever pot on
  line A, the indicator servo (9 g) on pin 7 and the orange pair. Two lines
  are left (e.g. a switch at the flap detents, if the lever gets one).
- **Throttle quadrant**: its three pots on lines A-C, between the blue
  pair (see [Cable to hub port 6](../throttle/README.md#cable-to-hub-port-6)); an *Analog input* per
  pot in the Connector. Line D and pins 1 and 2 are free (e.g. a pot for a
  fourth control; see the wrong port warning in
  [Port pinout](#port-pinout) before using pins 1 and 2).
- **Likely later**: panel light dimmers (pots, on free lines), small
  gauges (servos on a direct port; stepper gauges are instruments with a
  Nano of their own, see [Connections](#connections)),
  outputs (annunciator lights, avionics displays): MobiFlight drives them
  through 74HC595 shift registers or MAX7219 drivers with three lines each
  (data, clock, latch), which fit a direct port once their lines get a
  330 Ohm in series on the shield like the other Mega outputs.

**Logic only** on the blue pair: the muxes, pots, encoders and hall
sensors draw some tens of mA in all (the ignition's five hall sensors
the most). The servos take their current on their own orange
pair from the Mega 5 V for now (see [Power](#power-later)); put a 470 uF capacitor across the supply
at each servo. A 9 g servo draws about 0.15-0.3 A when it moves and up to
0.7 A stalled, about 0.2 V drop on 2 m of the 24 AWG pair. Two of them on
the Mega's USB 5 V is the limit: if the Mega resets when both move at
once, feed the servos from a 5 V supply. GND has to stay in the cable
with the signals, and the logic 5 V has to come from the Mega, so a
component is never powered while its inputs are not (or the other way
round).

### Why not a serial bus

A serial bus (I2C, UART, RS485, CAN) would need 2 signal wires instead of
the mux's 5 lines, but it does not save a cable: every component gets one
Cat5 cable either way, with 8 wires, and the S0-S3 lines are shared, so
each extra mux costs only one Mega pin. The options:

- **74HC165 input shift registers**: MobiFlight reads them (*Input Shift
  Register*, 8 inputs per chip, chained). Three lines (data, clock, latch)
  instead of the mux's five, but they also have to go to every component,
  and 8 pull-up resistors per chip: no gain over the mux.
- **I2C port expanders** (MCP23017, PCF8574): not in the standard
  MobiFlight firmware for inputs (it uses I2C only for LCD displays), and
  I2C is made for a circuit board, not for 2 m cables.
- **UART, RS485, CAN**: these need a microcontroller in every component
  and our own firmware at both ends; MobiFlight does not speak them. The
  MobiFlight way to do that is a small board per component that runs
  MobiFlight itself (e.g. an Arduino Pro Micro, on its own USB cable to the
  powered USB hub): fine for one or two
  components, but each is one more board to flash and one more USB device.

### Powered USB hub

Every board that is not the hub's Mega has its own USB cable: the Saitek
yoke and radio panel, the radio stack's Mega, the audio panel's Nano, the
compass's Nano and a Nano per instrument, about 15 with the whole
six-pack, NAV indicators and RPM. USB takes up to 127 devices, and hubs
can be chained, so the count is no problem: a 10 or 16 port hub, or two
7 port hubs, one into the other, and one cable from the first to the PC.

The current is the limit: the steppers (28BYJ-48) take their power from USB too.
One draws about 0.25 A while its coils are on, so an instrument with one
stepper about 0.3 A with its Nano and one with two about 0.55 A, at the
500 mA a USB 2.0 port is meant to give. With the compass and about 13
steppers in the instruments that is 3.5-4 A in all, more than many cheap
"powered" hubs give (their supply often has 2-3 A, shared by all ports;
too little shows as boards resetting and needles losing their home).
So the hub:

- has a supply for the whole load: 5 V / 4 A or more, or better a 12 V
  supply (the hub's own converter);
- gives each port at least 500 mA (in its specs: BC 1.2 charging ports, or
  "x A per port"), so a two stepper instrument is not cut off;
- stands on the desk next to the [hub](#connections), every board's cable
  short and of a decent gauge (the cheap thin ones drop voltage).

Two things would cut the current a lot and are worth checking before
more instruments are built: whether MobiFlight can switch a stepper's
coils off when the needle stands still (the 28BYJ-48's gearbox holds it
without power), and X27.168 gauge steppers (about 20 mA, no driver
board, but an end stop inside: only for needles that do not turn round,
like the ASI, VSI and RPM).

### Power (later)

USB only for now (the instruments' steppers on the
[powered USB hub](#powered-usb-hub)). With lighting, gauges or the FFB yoke comes one 24 V PSU
with fused branches, a DC-DC converter to a 5 V bus, a separate cut-off
switch on the FFB motor power and one star ground at the PSU. That is not
in the hub. The servos then keep their orange pair in the Cat5, but the
shield's servo rail is fed from the 5 V bus (a 2 wire lead into the hub,
its GND joined to the Mega GND there) instead of the Mega's second 5 V
pin. Bigger loads (backlighting, more servos in one component) get their
current from the 5 V bus with a 2 pin plug per component (e.g. JST-VH or
a 5.08 mm screw terminal), not from the Cat5. Leave room for that plug in
components with loads.
