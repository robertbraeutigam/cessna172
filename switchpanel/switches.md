# Switch panel hardware

Hardware for `switches.scad`: the switch row with MASTER (ALT, BAT), the
toggle switches and AVIONICS (BUS 1, BUS 2). The ignition switch is a
separate panel; its parts are listed in the `ignition.scad` header.

| Qty | Part | Use |
|-----|------|-----|
| 1 | double rocker switch, 6 pin, red | MASTER: ALT, BAT |
| 1 | double rocker switch, 6 pin, black (there is no white one) | AVIONICS: BUS 1, BUS 2 |
| 7 | toggle switch, M12 neck, 18 mm lever | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
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

## Wiring

Every switch is wired like a switch to GND, which is what SimVim inputs
expect (active low):

- Toggle, 2 pin: one lug to GND, the other to the SimVim input. Mount it
  so it is ON with the lever up.
- Toggle, 6 pin: use one pole. Its middle lug (common) goes to GND, the
  lug at the bottom to the SimVim input: the lever up (ON) connects the
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
- The panel is 211.6 x 63.3 mm and is checked against `bed` (255 x 255 mm,
  Kobra 3 V2).
