# USB hub and connections

[Cessna 172 home cockpit](../README.md) / `hub/`

How the components connect to the PC. There is no central box: every
component has a board of its own running MobiFlight (an Arduino Nano;
each radio unit too), with one USB cable to a powered USB hub on the
desk, and one cable from there to the PC. This page is the overview
(boards, MobiFlight, the USB hub and power); each component's README has
its pins and wiring.

## Connections

- **One board per component.** Everything inside a component is
  soldered to its own Nano, and its USB cable is the only connection to
  the rest of the cockpit. So each component is tested on the bench with
  nothing but that cable, and swapped without touching the others. A
  Nano is about 4 EUR; a shared board would save no money (it needs
  ports, cables and a wiring board of its own) and gives that up.
- **Plenty for each component.** MobiFlight's limits for a Nano
  (`arduino_nano.board.json` in its firmware): 18 buttons, 8 analog
  inputs, 9 encoders, 8 servos, 4 steppers, 6 multiplexers. Its pins: D2
  to D12 and A0 to A5 for buttons, encoders, servos and stepper wires
  (D13 has the LED: not for inputs), A6 and A7 only analog. Short wires
  inside a component need no resistors: switches go to GND and use the
  Nano's internal pull-ups.
- **Names, not ports.** The Connector names each board when it flashes
  it and stores that with a serial on the board, so identical Nanos are
  told apart whichever COM port Windows gives them. The configuration
  (one file for the whole cockpit) refers to them by that name.
- **The USB cable** plugs into the Nano at the component (no connector of
  our own), with a cable tie next to the plug where the cable could pull
  on it. USB 2.0 is good for 5 m, plenty from the panel to the desk.

| Component | Board | What is on it |
|-----------|-------|---------------|
| [yoke](../yoke/README.md) | Nano in the wheel's hub, the cable through the control tube | PTT left and right, trim rocker |
| [switch panel](../switchpanel/README.md#nano) with the [ignition](../ignition/README.md) and the primer | Nano on a carrier on the panel back | 10 switches, 5 ignition positions, the primer pot |
| [throttle quadrant](../throttle/README.md) | Nano on the box floor | throttle, mixture, carb heat pots |
| pedestal (not designed yet) | Nano | trim wheel encoder, trim indicator servo, parking brake switch |
| flaps (not designed yet) | Nano | lever pot, indicator servo |
| [compass](../compass/README.md) | Nano | card stepper, home sensor |
| [instruments](../instruments/README.md) | a Nano each, on its board carrier | needle stepper(s), home sensor(s), the NAV indicators' OBS encoder |
| [radio stack](../radio/README.md) | a Nano per unit: KMA 26, the two KX155s, KT 76C (the KMA 26 and the KT 76C with a mux) | encoders, displays, buttons, lamps |
| Saitek yoke, Saitek radio panel | their own USB | |

The `hub/` directory once held a box with a Mega and RJ45 ports that
every component was cabled to; it is not used any more (the Mega is a
spare).

### MobiFlight

[MobiFlight](https://www.mobiflight.com/) is free and open source (MIT,
[GitHub](https://github.com/MobiFlight/MobiFlight-Connector)). The
MobiFlight Connector runs on the PC (**Windows only**) and talks to X-Plane
11/12 directly through its datarefs and commands (X-Plane's UDP interface,
no plugin). It also flashes the MobiFlight firmware onto the boards over
USB; give each one the component's name then.

In the Connector, each board gets one device per thing on it: a *Button*,
an *Encoder*, an *Analog input*, a *Servo* or a *Stepper* on its pins.
Each input then sets a dataref or sends a command on press and on
release, each output follows a dataref. The configuration is a file: keep
it with the cockpit.

MobiFlight sends an X-Plane command only once; it cannot hold one while a
button is pressed (still open:
[MobiFlight-Connector#2405](https://github.com/MobiFlight/MobiFlight-Connector/issues/2405)).
Where a command has to be held, like the ignition START, a small
FlyWithLua (NG) plugin
script in X-Plane does it (see [In X-Plane](../ignition/README.md#in-x-plane)).

### Powered USB hub

Every board has its own USB cable, and the Saitek yoke and radio panel
too: with the whole six-pack, the NAV indicators, the RPM and the four
radio units about 22.
USB takes up to 127 devices, and hubs can be chained, so the count is no
problem: a 16 port hub, or two hubs, one into the other, and one cable
from the first to the PC. It stands on the desk right of the yoke (see
[Cockpit frame](../frame/README.md)).

The current is the limit: the steppers (28BYJ-48) and the servos take
their power from USB too.

- **Steppers**: one draws about 0.25 A while its coils are on, so an
  instrument with one stepper about 0.3 A with its Nano and one with two
  about 0.55 A, at the 500 mA a USB 2.0 port is meant to give. Every
  stepper has *Disable stepper when at target position* ticked in the
  Connector (see the
  [instruments' MobiFlight setup](../instruments/README.md#mobiflight)):
  its coils are on only while it steps, about 2.5 ms a step, so even a
  needle that twitches all through the flight takes some 10-20 mA on
  average, and the whole panel a few hundred mA. The peak is at start,
  when every needle homes at once for a few seconds: with the compass and
  about 13 steppers in the instruments 3.5-4 A.
- **Servos** (the pedestal's trim indicator, the flaps indicator): a 9 g
  servo draws about 0.15-0.3 A when it moves and up to 0.7 A stalled. On a
  Nano of its own each one has its own USB port. Put a 470 uF capacitor
  across its supply at the servo; if its Nano resets when it moves, feed
  it from the USB 5 V before the Nano's diode (the 5V pin is behind it).
- **Displays**: the radio units' MAX7219 digits, at low brightness some
  tens to a hundred mA per unit, each on its own port.
- **The rest**: about 50 mA per Nano, a few hundred mA for the Saitek
  devices.

That is more than many cheap "powered" hubs give (their supply often has
2-3 A, shared by all ports; too little shows as boards resetting and
needles losing their home). So the hub:

- has a supply for the peak: 5 V / 4 A or more, or a 12 V supply (the
  hub's own converter; 12 V / 3 A, 36 W, gives about 6 A at 5 V);
- gives each port at least 500 mA (in its specs: BC 1.2 charging ports, or
  "x A per port"), so a two stepper instrument is not cut off;
- has every board's cable short and of a decent gauge (the cheap thin ones
  drop voltage).

X27.168 gauge steppers would cut even the peak (about 20 mA, no driver
board), but they have an end stop inside: only for needles that do not
turn round, like the ASI, VSI and RPM.

### Power (later)

USB only for now. With lighting or the FFB yoke comes one 24 V PSU with
fused branches, a DC-DC converter to a 5 V bus, a separate cut-off switch
on the FFB motor power and one star ground at the PSU. Bigger loads
(backlighting, several servos in one component) then get their current
from the 5 V bus with a 2 pin plug per component (e.g. JST-VH or a
5.08 mm screw terminal), their GND joined to the Nano's GND there, not
over USB. Leave room for that plug in components with loads.
