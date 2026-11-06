# Switch panel hardware

Hardware for `switches.scad`: the switch row with MASTER (ALT, BAT), the
single switches and AVIONICS (BUS 1, BUS 2). The ignition switch is a
separate panel; its parts are listed in the `ignition.scad` header.

## Rocker switches: KCD1-101

The cheapest usable part is the common **KCD1-101** snap-in rocker switch:

- 2 pin, SPST, ON-OFF, latching ("rastend"); no LED needed
- bezel 21 x 15 mm, panel cutout 19 x 13 mm
- snaps into a thin panel from the front. The printed panel is 3 mm thick,
  but it is thinned to `sw_grip` (1.5 mm) behind each switch
- one tab to GND, the other to a SimVim input. SimVim inputs are active low,
  so this works like any other switch to GND. The current is tiny, so the
  6 A / 250 V rating does not matter

| Qty | Colour | Use |
|-----|--------|-----|
| 2 | red | MASTER: ALT, BAT |
| 7 | black | FUEL PUMP, BEACON, LAND, TAXI, NAV, STROBE, PITOT HEAT |
| 2 | white | AVIONICS: BUS 1, BUS 2 |

### Listings found on amazon.de

Amazon blocked automated page access, so I could not check the prices,
the delivery times or which variant pictures belong to which listing.
These packs usually cost a few euros. Check the listing before ordering.

- **Red, black or white, one listing:**
  [Mini-Wippschalter KCD1, 2-polig, 15 x 21 mm, rot / schwarz / weiß, keine LED (1 or 5 pieces)](https://www.amazon.de/elektronischer-Wippschalter-Mini-Wippschalter-elektrische-Ausr%C3%BCstung/dp/B0CRDNDPMG).
  It is the best match: all three colours come from the same seller, so
  the bezels should be identical. Five red and five white cover the pairs,
  with spares. A similar listing:
  [B0CQFPC59K](https://www.amazon.de/Wippschalter-Mini-Wippschalter-elektrische-Ausr%C3%BCstung-industrieller/dp/B0CQFPC59K).
- **Black, 10 pieces with wires already attached:**
  [HUAREW Mini Rocker Switch T85 KCD1-101, 2 pin SPST, with wiring](https://www.amazon.de/HUAREW-Wippschalter-2-poliger-SPST-Kippschalter-Verdrahtung/dp/B0BD39FPRQ).
  It saves soldering the 7 middle switches. A similar listing:
  [YIZWINS 10 pcs KCD1 with wiring](https://www.amazon.de/YIZWINS-Wippschalter-SPST-Kippschalter-Kippschalter-KCD1-Schalter/dp/B0D5QQFW4M).
- **Red, 10 pieces:**
  [10 Stück rot KCD1-101 19 x 13 mm 2 pin ON-OFF](https://www.amazon.de/st%C3%BCcke-rot-KCD1-101-perforiert-19x13mm/dp/B0FZT1CMZK).
  Also [Oiyagai KCD1-101 red, pack of 30](https://www.amazon.de/Oiyagai-St%C3%BCck-KCD1-101-2-polig-Wippschalter/dp/B078JC6BH5).
- **White, 10 pieces:**
  [BADIKA KCD1-101 19 x 13 mm, 2 pin, colour "Black and White"](https://www.amazon.de/BADIKA-Wippschalter-KCD1-101-perforieren-19x13mm/dp/B0DFGH8H3D).
  This should be a white rocker in a black bezel, but check the picture.
- **Mixed pack of 5:**
  [KCD1-101 2 pin 21 x 15 mm, black / red / white](https://www.amazon.de/Wippschalter-KCD1-101-2-polig-21x15MM-Schwarz/dp/B0CTPT3CBX).

Avoid these look-alikes:

- KCD11 (10 x 15 mm): too small
- KCD1-105: round
- 3 pin, 4 pin or LED versions: they work, but are bigger and cost more
- anything sold as a push button or momentary switch ("Taster")

Prefer plain rockers without an "O / I" print, if the listing shows it.
Mount them with "I" (ON) up, the Cessna switches are ON when up.

**MEASURE when they arrive:** KCD1 clones differ a little between sellers.
Measure the bezel, the body (cutout), the clip position, the body depth and
the tab positions, and update the `sw_*` parameters in `switches.scad`.
Ideally buy all switches from the same seller.

## Mounting and wiring

| Qty | Part | Note |
|-----|------|------|
| 6 | M3 pan head screw + nut | through the panel and its 8 mm bosses into the cockpit frame, so 3 + 8 mm + the frame thickness long (`mount_count`) |
| 1 | thin hookup wire, black | GND, daisy chained over one tab of every switch |
| 11 | thin hookup wire / ribbon cable | one signal wire per switch to the SimVim board |
| - | heat shrink, Dupont or JST connectors | so the panel can be unplugged |

Solder the wires before snapping the switches into the panel. A switch is
hard to pull out again without breaking its clips.

## Notes

- ALT and BAT are two independent switches. The real split master has an
  interlock: ALT pushes BAT on, BAT pushes ALT off. X-Plane does not need
  it, but it could be added later as a printed bridge between the paddles.
- The switch list in `switches.scad` (`groups`) follows the X-Plane 172 SP.
  For a 172N, remove FUEL PUMP; the layout adapts.
- The panel is 217 x 53 mm and is checked against `bed` (220 x 220 mm).
  Set `bed` to the real printer bed.
