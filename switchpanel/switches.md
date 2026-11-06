# Switch panel hardware

Hardware for `switches.scad`: the switch row with MASTER (ALT, BAT), the
toggle switches and AVIONICS (BUS 1, BUS 2). The ignition switch is a
separate panel; its parts are listed in the `ignition.scad` header, but it
is wired to the multiplexer on this panel.

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 7 | toggle switch, M12 neck, 18 mm lever | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
| 6 | M3 pan head screw + nut | mounting (`mount_count`) |
| 1 | CD74HC4067 16 channel mux breakout board | all inputs, see Multiplexer |
| 2 | M2 x 6 screw | mux onto its standoffs |
| 1 | 8 pin straight header + Dupont housing | cable to the Mega |
| - | wire, heat shrink | see Wiring |

## Double rocker switch

[Double Rocker Switch 6-Pin 250V 16A/AC Red Rocker Illuminated On/Off](https://www.amazon.de/-/en/Double-Rocker-Switch-6-Pin-Illuminated/dp/B0DLTMGKSS),
in red for MASTER and black for AVIONICS. Two independent rockers in one
housing, each side by side, tall and narrow like the real split switches.

Dimensions from the listing (in `rk_*`):

- panel cutout 22 x 28.5 mm (width x height)
- front lip 24.3 x 31.3 mm, 2 mm thick
- body 21.7 x 25.3 mm. In the height direction, ramps on the top and bottom
  end widen it to the cutout; they snap behind the panel. There are no
  mounting holes.
- 31.5 mm from the front to the end of the pins

**MEASURE when they arrive:** the gap between the lip and the ramps, i.e.
the panel thickness they snap onto (`rk_grip`, now 1.5 mm; the panel is
thinned to that at the top and bottom of the cutout). Also check the pin
positions.

The lamps are neon (250 V) and will not light on 5 V; leave the lamp pin
unconnected. Each rocker has 3 pins: find the two that close when the
rocker is ON with a multimeter.

## Toggle switches: M12

Standard size toggle switches, about the size of the real ones. From the
listing: body 30 x 15.5 x 15 mm, 12 mm neck (M12 thread), 18 mm lever.
Either a 2 pin ON-OFF or a 6 pin ON-ON (DPDT) switch works. Do not take an
ON-OFF-ON one (e.g. "-203"): its center stop is not on the real switch.

The toggles go in from the back, and a nut and washer on the front clamp
them. The body sits in a square pocket 1 mm deep in the back of the panel
so it cannot turn.

**MEASURE when they arrive** (`tg_*`, `toggle = "M12"`):

- The 30 mm is assumed to be from the top of the body to the end of the
  lugs, and 15.5 x 15 mm the body.
- The thread length (now 9.5 mm; the panel is 2 mm thick there, the
  washer and nut need about 4 mm of it).
- The nut across flats (now 14 mm). The switches are 19 mm apart, so a
  nut up to about 15 mm fits; the build checks this.
- The lever and the lug positions.

The mini MTS-202 (M6, 10 mm lever) still works too: set
`toggle = "MTS-202"`. amazon.de listings for it:
[ETOPARS, 10 pieces](https://www.amazon.de/ETOPARS-Kippschalter-Armaturenbrett-Wippschalter-L%C3%B6tanschluss/dp/B08Z7R4RB9),
[Taiss, 10 pieces](https://www.amazon.de/MTS-202-Terminals-Positionen-Kippschalter-wasserdichte/dp/B07JNV6SCJ).

## Multiplexer

All switches and the ignition go to one CD74HC4067 breakout board on the
back of this panel. It is SimVim's standard input extension: 16 inputs,
read through one Mega pin. So everything is soldered on the panels, and
only one 7 wire cable runs to the Mega.

(A SimVim "slave" board does not work here: the only slave for inputs is
the key matrix board, and it takes momentary buttons only, no toggle
switches.)

The board sits on two standoffs in the strip behind the group labels, on
the left (pilot side) half, where the ignition cable comes in. Its height
follows the rim; `assert`s check that it clears the switches and the
mount bosses. Mount it with the chip outwards, so the solder joints face
you.

**MEASURE when it arrives** (`mux_*`): the board is 40 x 18 mm in the
listings (one says 41 x 18.7 mm). The mounting holes (`mux_holes`, guessed
on the center line 17.5 mm from the middle) and the order of the control
pins (`mux_ctl_names`) are guesses. If the board turns out bigger, the
build fails; then increase `margin_top`. If it has no mounting holes, glue
it onto the standoffs.

### Inputs

| Mux | Input | Mux | Input |
|-----|-------|-----|-------|
| C0 | MASTER ALT | C8 | PITOT HEAT |
| C1 | MASTER BAT | C9 | AVIONICS BUS 1 |
| C2 | FUEL PUMP | C10 | AVIONICS BUS 2 |
| C3 | BEACON | C11 | ignition OFF |
| C4 | LAND | C12 | ignition R |
| C5 | TAXI | C13 | ignition L |
| C6 | NAV | C14 | ignition BOTH |
| C7 | STROBE | C15 | ignition START |

That is all 16. The switches are in label order (the `groups` order in
`switches.scad`), the ignition positions are consecutive, which suits a
SimVim multi-position switch (M, one input per position). In the SimVim
configurator, assign the toggles and rockers as toggle switches (S). Without
FUEL PUMP (172N) or the OFF hall sensor, one input stays free.

### Cable to the Mega

| Mux pin | Mega |
|---------|------|
| S0, S1, S2, S3 | pins 22, 23, 24, 25 (fixed by SimVim, shared by all muxes) |
| SIG | any free digital pin, select it in the SimVim configurator |
| VCC | 5 V |
| GND | GND |
| EN | not to the Mega: bridge it to GND on the board (enable is active low) |

Solder the header into the control row (short pin ends towards the panel)
and plug an 8 pin Dupont housing onto it, with the EN position left empty.
A second mux somewhere else in the cockpit shares S0..S3; it only needs its
own SIG pin.

The switches and the hall sensors have no pull-up resistors: this assumes
SimVim turns on the Mega's internal pull-up on the SIG pin, which its docs
do not say outright. **Test it on the bench first** with one switch on the
mux, before soldering all of them. If the input floats, add one 10k
resistor from SIG to 5 V.

## Wiring

Every input is wired like a switch to GND (active low, as SimVim expects):

- Toggle, 2 pin: one lug to GND, the other to its mux input. Mount it so
  it is ON with the lever up.
- Toggle, 6 pin: use one pole. Its middle lug (common) goes to GND, the
  lug at the bottom to the mux input: the lever up (ON) connects the
  common to the bottom lug. Check with a multimeter.
- Rocker: the two pins of each rocker that close when it is ON; one to
  GND, the other to the mux input.
- Ignition: the A3144 outputs go to C11..C15. The sensors also need 5 V
  and GND: take them from the mux VCC and GND.

So on this panel: one GND wire daisy chained over all 11 switches to the
mux GND, and one signal wire from each switch to its C pin, soldered
straight into the board. The ignition cable (5 signals, 5 V, GND) is best
plugged in with a 7 pin Dupont or JST connector, so the two panels can be
separated. GND and VCC get several wires (switch chain, EN bridge,
ignition, Mega cable): join the extra wires to one wire before the pin,
with solder and heat shrink.

Solder the wires to the rockers before snapping them in; they are hard to
get out again.

## Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock: ALT pushes BAT on, BAT pushes ALT off. X-Plane does not need
  it.
- The switch list in `switches.scad` (`groups`) follows the X-Plane 172 SP.
  For a 172N, remove FUEL PUMP; the layout adapts.
- The panel is 211.6 x 63.3 mm and is checked against `bed` (255 x 255 mm,
  Kobra 3 V2).
