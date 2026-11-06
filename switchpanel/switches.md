# Switch panel hardware

Hardware for `switches.scad`: the switch row with MASTER (ALT, BAT), the
toggle switches and AVIONICS (BUS 1, BUS 2). The ignition switch is a
separate panel; its parts are listed in the `ignition.scad` header.

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 7 | MTS-202 mini toggle switch, ON-ON | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
| 6 | M3 pan head screw + nut | mounting (`mount_count`) |
| - | wire, heat shrink, connectors | see Wiring |

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

## Toggle switches: MTS-202

MTS-202 is a mini toggle, DPDT, ON-ON, 6 solder lugs, M6 thread. Use
the ON-ON MTS-202, not the MTS-203: that one is ON-OFF-ON, with a center
stop the real switch does not have. The MTS-1xx and -2xx are all the same
size; the number only says how many poles and positions.

Listings found on amazon.de (prices not checked, Amazon blocks automated
access):

- [ETOPARS mini toggle switch ON-ON, 6 pin DPDT, pack of 10](https://www.amazon.de/ETOPARS-Kippschalter-Armaturenbrett-Wippschalter-L%C3%B6tanschluss/dp/B08Z7R4RB9)
- [Taiss 10 pcs MTS-202 ON-ON (with waterproof caps, not needed)](https://www.amazon.de/MTS-202-Terminals-Positionen-Kippschalter-wasserdichte/dp/B07JNV6SCJ)
- [MTS-202 / MTS-203 mini toggle, choose the ON-ON variant](https://www.amazon.de/MTS-202-DPDT-Schalter-6-Pin-Mini-Kippschalter-MTS-203/dp/B0CPDP58KQ)
- [Miniatur Kippschalter 2x EIN/EIN, 6 pin, Gewinde Ø 6 mm](https://www.amazon.de/Miniatur-Kippschalter-L%C3%B6t%C3%B6sen-6-Pin-Gewinde/dp/B00P2EZ9T6)

Listings give a 6 mm hole, M6 x 0.75 thread about 9 mm long, a body of
about 12.8 x 11.4 mm and 31.7 mm overall height. A reviewer broke a thread
by over-tightening, so tighten the nut gently.

The toggles go in from the back, the nut and washer on the front clamp
them. The body sits in a square pocket 1 mm deep in the back of the panel
so it cannot turn.

**MEASURE when they arrive:** the body (`tg_body`), the thread length, the
nut, the lever and the pin positions.

The real airplane's toggles are bigger (about 12 mm thread, 20 mm lever).
Standard size toggles (KN3C-202 style, M12) would be closer. Set
`toggle = "KN3C-202"` in `switches.scad` to try them; their values are
rough guesses. The panel then gets wider than a 220 mm bed (the build
fails on the `bed` check) and would need to be split.

## Wiring

Every switch is wired like a switch to GND, which is what SimVim inputs
expect (active low):

- Toggle: use one pole. Its middle lug (common) goes to GND. The lug at
  the bottom goes to the SimVim input: the lever up (ON) connects the
  common to the bottom lug. Check with a multimeter.
- Rocker: the two pins of each rocker that close when it is ON; one to
  GND, the other to the input.

So: one GND wire daisy chained over all 11 switches, and 11 signal wires
(ribbon cable works) to the SimVim board, best with a connector (Dupont or
JST) so the panel can be unplugged. Solder before snapping the rockers in;
they are hard to get out again.

## Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock: ALT pushes BAT on, BAT pushes ALT off. X-Plane does not need
  it.
- The switch list in `switches.scad` (`groups`) follows the X-Plane 172 SP.
  For a 172N, remove FUEL PUMP; the layout adapts.
- The panel is 211.6 x 63.3 mm and is checked against `bed` (220 x 220 mm).
  Set `bed` to the real printer bed.
