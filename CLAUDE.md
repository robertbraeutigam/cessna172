# Cessna 172 Home Cockpit

Hardware project to build a Cessna 172 cockpit for the X-Plane flight simulator.
Parts are designed in OpenSCAD and 3D printed. Each cockpit component lives in
its own top-level directory; new components should follow the same layout.

## Projects

- `throttle/` — throttle quadrant: throttle, mixture and carb heat controls.
  - `throttle_box.scad` — the main box. Linear potentiometers sit on stands
    inside, 6 mm rods (one per control) exit the front. The pots are read
    by MobiFlight on an Arduino Nano of its own in rails on the floor (A0
    throttle, A1 mixture, A2 carb heat), its USB jack behind a window in
    the back wall (`usb_plug`), the cable plugged in from outside. It is printed in one piece and has no lid: it goes
    through a cut-out in the frame's sheet (below the desk top), its front wall is the face with
    a flange (top and sides, `flange_w`) screwed onto the sheet, and two M5
    bolts through the floor go into the frame's throttle bar; `frame/frame.inc.scad`
    repeats these sizes.
    Its views show the pots, rods with knobs, clamps, pins, Nano, cable and wiring
    as view-only parts; the knob, clamp and pin shapes there are copies of
    the other files, keep them in sync.
  - `carb_heat_knob.scad`, `clamp.scad`, `pin.scad` — small parts (knob,
    rod clamps, pot hold-down pins).
- `flaps/` — `flaps.scad`: the flaps panel right of the throttle box,
  like the X-Plane 172N's (WING FLAPS, scale UP/10/20/30 FULL, indicator
  slot, lever slot). No housing, like the pedestal: front plate with a
  flange left, right and bottom (none at the top: the waist bars), a
  separate face with raised lettering, a foot on the throttle bar (two
  M5, `foot_bolt_xs`), everything else on the plate's back within `body`;
  `frame/frame.inc.scad` repeats `flaps_plate`, `flaps_body`,
  `flaps_face_t`, `flaps_bolt_xs`. Lever: the handle's stem into a
  block sliding in a channel, a ball detent (notches in the right wall)
  at each of the `n_pos` positions, a magnet in the block over an A3144
  per position on a screwed `strip` (also keeps the block and the
  carrier in); D2..D5 set `flap_ratio`. Indicator: a carrier in its own
  channel, its fin's slot driven by a pin on an SG90's arm (scotch yoke,
  D9, `arm_r`), the servo on a rib (window, tabs screwed along x); the
  servo's interpolation table is echoed (`indicator_table`) and in the
  README. Nano in rails on the foot behind the lever, jack back,
  `tie_block`. `sv_*` MEASURE (the NAV indicator's), `sensor`/`magnet`
  from `lib/stepper.inc.scad`.
- `pedestal/` — `pedestal.scad`: the top of the pedestal under the
  throttle, the elevator trim wheel and the trim indicator, mounted like
  the throttle box but with no housing (it is behind the sheet): a front
  plate with a flange screwed onto the sheet, a separate face (`face_t`)
  with raised lettering in front of it, a foot (`foot_d`) along its
  bottom on the apron's lower bar with two M5 (`floor_bolt_dx`), and
  everything else on the plate's back, through the apron sheet's
  cut-out (within `body`); `frame/frame.inc.scad` repeats its sizes:
  `pedestal_size`, `pedestal_foot`, `pedestal_bolt_dx`, `under_face_t`,
  `pedestal_wheel`, `pedestal_ind`. Printed on its face. The wheel (rim out of the face's slot)
  is glued on a 6 mm rod turning in the left cheek; a printed `coupler`
  on its right end turns in the right cheek and takes the D shaft of an
  EC11 encoder with detents (D2, D3; MobiFlight sends the pitch trim
  up/down commands, so the yoke's rocker still trims), its bushing
  clamped in a plate right of the cheek. The bearings and the plate's
  slot are open to the back (wheel, rod, coupler and encoder go in as
  one), closed by screwed keepers (`keeper_left`, `keeper_right`) whose
  tongues press a felt pad (`pad_*`) for resistance. The indicator: a
  rack in a channel on the front plate's back, its pointer through the
  slot, driven by an SG90 (D9) on a `bracket` through a pinion
  (`sv_sweep` for the travel). The Nano in rails on the plate's back
  right of the encoder, its jack up, the cable tied onto a `tie_block`
  above the plug. The `enc_*`
  (the heading indicator's) and `sv_*` (the NAV indicator's) values are
  MEASURE; `gear_2d` is a
  copy of `instruments/instrument.inc.scad`'s, keep them the same.
- `switchpanel/` — the Cessna 172N lower-left switch panel (master, light
  switches, ...; the ignition key is its own component, `ignition/`).
  Similar in function to the Saitek Switch Panel, but it should look as close to the real 172N panel as possible, and every
  switch position is a raw output wire for MobiFlight (active low, like a switch
  to GND). It is two panels printed separately and mounted side by side,
  ignition (`ignition/`) on the left, a little raised (the frame's
  `switch_ign_rise`, computed) with the primer under its key; each has its own hole
  in the sheet and a flange all round. All of it hangs below the desk top
  in the frame's lower panel.
  - `panel.inc.scad` — included by both (`ignition/` has an identical
    copy, keep them the same): back height (`panel_h`, the same
    for both), thickness, rim, face flange (`flange_w`) with the mount
    holes, lettering, the separate front face (`face_t`, printed front
    side up, labels standing out of it for a paint pen) and the
    `panel_blank` plate (flange all round; `round0`/`round1` = false
    would leave it off an end). The back goes through a hole in the
    frame's sheet, the flange is screwed onto it; `frame/frame.inc.scad`
    repeats these sizes.
  - `primer.scad` — the primer: a small panel of its own under the
    ignition key, beside the switch row and a little lower (own cut-out in the sheet, the
    ignition panel is not changed), a push-pull knob with a twist lock (lug in a keyway
    in a tube on the panel back, quarter turn pocket at its end) and a
    bracket behind it with the 75 mm linear pot (the carb heat type),
    driven like the throttle's (rod, carrier over the slider ear, the
    throttle's plain clamps as collars) and a spring on the rod that pops the
    knob out when it is unlocked. The pot's wiper is on the switch
    panel Nano's A7. `panel.inc.scad` takes the back's height (`h`) for it.
  - `switches.scad` — a separate panel with the switch row: a red double
    rocker for MASTER (ALT, BAT), M12 toggles in the middle (PITOT HEAT
    and the LIGHTS group) and a black double rocker for
    AVIONICS (BUS 1, BUS 2), with the labels on its face; printed caps
    glued onto the rocker paddles (`rk_cap_*`, red and white, a V top
    with ribs) give them the Carling
    look, the paddle values (`rk_paddle_*`, `rk_top_r`, `rk_pivot_d`)
    are guesses; the layout
    copies the X-Plane 172N panel (rockers raised half way to the breakers,
    OFF under the toggles, ON beside the rockers). Above the
    toggles is a row of printed dummy circuit breakers (`breakers`, for
    show only, glued into hex holes in the face). An Arduino Nano reads
    all switches (`switch_pins`, D2..), the ignition (`ignition_pins`,
    A0..A4) and the primer (A7), each on a pin of its own; its USB cable
    is tied onto `tie_block` behind the plug. The Nano (slid into shallow rails from the left, held by the tied cable) and the
    tie block are on a separate printed carrier (`nano_carrier`) screwed
    onto two bosses on the panel back, so it can be wired and tested
    before the panel exists. The switch list
    (`groups`) drives the layout. The `rk_*` values come from the rocker
    listing; `tg_*` are guesses until the switches are measured.

- `ignition/` — the left half of the switch panel, a component of its own.
  - `panel.inc.scad` — a copy of `switchpanel/panel.inc.scad`, keep them
    identical.
  - `ignition.scad` — its panel and face and the
    OFF/R/L/BOTH/START key switch built around a cheap
    mailbox cam lock (its 90° stop removed). It has a ball detent, end stops
    on a rotor lug, a spring-return START (pin + shoe + spring in an arc slot),
    and one magnet with a digital hall sensor per position; the wires are
    soldered to small prototype board pieces on the sensor legs, held on a
    printed arc (`holder`) under the cap. The header comment
    has the parts list and assembly order. The `lock_*` values are measured
    (the lock's stop tab is filed off, so it turns past 90°).
  - `ignition.lua` — FlyWithLua script for X-Plane that holds the starter
    while START is pressed (MobiFlight writes its dataref; it cannot hold
    a command itself).

- `yoke/` — `yoke.scad`: the hollow Cessna control wheel (trapezoid hub,
  bar with a sagging bottom, arms leaning inwards with block heads square
  on their ends; `arm_frame` places things on an arm end), its outline a
  point list rounded with offsets and extruded with stepped rounded edges
  (`body`). A 2.5 mm shell cut in its middle plane into front (`fwd`,
  panel side) and back (`aft`, pilot side) halves, and each half across
  the bar into a center and two horn pieces, at different places
  (`xs_fwd`, `xs_aft`) so the pieces overlap like bricks; M3 screws from
  the front into bosses in the back pieces, a lip on the back pieces' rim.
  The heads are separate prints on spigots (they stand out towards the
  pilot): top pad with the PTT, a 45 degree pad (left: trim rocker); a
  separate thumb rest (only on the head's side: a shelf tilted 30 degrees
  towards the pilot, concave round top, angled underside) is screwed onto
  each head's inner side. A printed collar bolted
  onto the hub front holds the bought aluminium control tube (cross
  bolts); the USB cable runs through the tube. Inside: an Arduino Nano
  in a pocket in the hub (D2..D5), its jack up, and a cable tie block
  over the plug. Only
  the wheel and the tube end, not the base the tube goes into.

- `radio/` — the radio stack: the KMA 26 audio panel, two KX155 NAV/COMs
  and the KT 76C transponder (top to bottom) stacked without gaps in one
  cut-out of the sheet; every unit has its own Arduino Nano running
  MobiFlight (USB out of its open back, tied onto `tie_post`).
  `radio.inc.scad` places the Nano in its floor rails (`unit_nano_rails`,
  the shared ones of `lib/`) and has the mux board's size.
  - `radio.inc.scad` — the stack's standard, included by every unit:
    unit width (`unit_w`, the KX155's, which checks it; every unit is as
    wide), the KX155's height (`unit_h`, 2.00"; each unit has its real
    height), front face (`face_t`, separate, lettering for a paint pen)
    and plate, flanges on the left and right ends only with two M3 mount
    holes each, the 7 segment digit sizes (`dig_*`, MEASURE), and the
    parts and shapes the units share (tactile switch, MAX7219 board,
    rotary switch `rot_*`, 3 mm LED `led`, bosses, knob body, crush bore, 7 segment drawing). Installed
    coordinates (x right, y back, z up).
  - `kx155.scad` — the KX155: COM USE/STBY with 6 digits (8.33 kHz,
    three decimals), NAV with 5, red 0.28" digits (two 3 digit modules per
    frequency, a MAX7219 kit board each, 4 chained), so it is wider than
    the real one; dual concentric frequency knobs (outer MHz, inner kHz,
    printed outer, inner and volume knobs), volume pots with switch,
    flip buttons on tactile switches. `groups` drives the display layout,
    `row` the bottom row. Its Nano lies in floor rails right of the
    driver boards (at the left wall), every line on a pin of its own
    (`nano_pins`: 17 digital, the pots on A6/A7). The `enc_*`, `pot_*`,
    `tact`, `drv_*` values are MEASURE.
  - `kt76c.scad` — the KT 76C transponder, 1.65" high: IDT, display
    (flight level from X-Plane's pressure altitude, 3 digits; code, 4
    digits of two 3 digit modules; one MAX7219), annunciators R, FL, ALT,
    ON, GND, SBY as stencil words cut through a printed black display
    mask with a 3 mm LED cell each, code buttons 0..7, CLR, VFR (printed
    caps on tactile switches), function selector on a 12 way rotary switch
    limited to 5 positions. One L shaped front board carries the digits,
    LEDs and switches. A logic board in floor rails (like the KMA 26's)
    carries its Nano and a CD74HC4067 mux for the 16 buttons and selector
    positions (`nano_pins`, `mux_inputs`). The `rot_*` values are MEASURE
    (guesses).
  - `kma26.scad` — the KMA 26 audio panel, 1.30" high (`ap_h`): marker
    lamps O, M, I (printed lenses, a 3 mm LED in a cell each), MKR MUTE,
    two mini toggles (HI SENS/LO SENS/TEST, PILOT/CREW/ALL), INTERCOM
    volume pot, 10 audio select buttons in two rows (printed caps on
    tactile switches, the annunciator bar a slot lit by a 2 x 5 mm LED in
    a channel in the cap), MIC selector on the KT 76C's rotary switch (5
    positions); the concentric knob pairs are one stepped knob each.
    Marker board and button board on bosses; a logic board in floor rails
    with an Arduino Nano running MobiFlight, a CD74HC4067 mux
    (inputs) and two 74HC595 (lamps), USB out the back. `labels` drives
    the face lettering (asserts keep it off everything else). The `tg_*`,
    `vol_*`, `bar_led`, `nano_high` values are MEASURE (guesses).
    The frame still has the Saitek radio panel, but its right part is
    already as high as the whole stack needs (`stack_units_h` in
    `frame/frame.inc.scad`).

- `compass/` — `compass.scad`: the 172's magnetic compass (Airpath C2300
  size), standing over the panel on a printed stand bolted into the frame's
  right top bar (`frame/frame.inc.scad` repeats its sizes). The card is a
  drum (inverted cup) pressed onto a 28BYJ-48 stepper's shaft, over the
  motor, printed in black, its ticks and numbers standing out of the band
  (`mark_h`, painted white), numbers falling to the right like the real
  card. A magnet in the drum and an A3144 hall sensor on a post home it;
  an offset in MobiFlight's transform puts N under the lubber line. The
  case is printed (it was made for a paper card): its sizes stay
  (`bz_back`), the band fits inside them. Two colours: the white parts
  (drum marks, bezel lettering, lubber line) are `*_white` modules in the
  same print place, filling pockets in the black parts. MobiFlight on an
  Arduino Nano of its own (USB to the powered USB hub) drives the ULN2003 board;
  the base alone holds the Nano (the shell only clears it): its jack end
  under hooks on the jack stops, its far end under a printed keeper
  (`keeper_*`) screwed onto the base. The coils stay on, so the floor (under the drum) and the
  shell's top have vent slots; a wall under the drum's front half (the
  wire shield, the sensor post in it) hides the wires from the window. Parts: base (everything is
  mounted on it), shell, bezel (window, dummy compensator screws, the
  glass in a pocket in its back), bezel back (holds the glass, lubber
  line), drum, stand. The motor, ULN2003, sensor and magnet values are
  `lib/stepper.inc.scad`'s (MEASURE).

- `instruments/` — the analogue instruments (stage 2 holes in the frame's
  left sheet, `inst_c`).
  - `instrument.inc.scad` — the standard instrument, included by each:
    a 3 1/8" case put into the sheet's hole from behind (four screws from
    the front on the diagonals, like the real panel), lip, glass, dial (a
    cup holding the glass, the face glued in), needle on a 3 mm steel
    axle, a 1:1 pair of printed gears to a 28BYJ-48, a magnet in the motor gear over an
    A3144 hall sensor for homing, and a carrier with the ULN2003 board
    and an Arduino Nano of its own (MobiFlight, USB to the powered USB
    hub). The face is a colour `Make print`: drawn in `ink(colour)`,
    `print_page()` adds the glass template and the registration dots.
    The motor, board, sensor and magnet values are `lib/stepper.inc.scad`'s
    (MEASURE), the compass's too; `frame/frame.inc.scad` repeats the case's sizes and depth.
    Small gears, the motor behind the case over the axis, the carrier
    on posts behind it, all within the case's outline, 54 mm deep
    (`inst_depth` in the frame, which sets the force feedback yoke back
    for it). It also holds what the instruments with their own
    mechanisms share (gear radii, motor placement and clearance
    functions `m_body`, `m_ears`, `clear_cover`, `cover_pts`,
    `motor_at`, `along_xz`, `ring_gear_2d`, `sensor_pocket`; do not copy
    them into a file), and the carriers' places side by side
    (`carrier_slots`, x from each axis, by `inst_rows` and
    `inst_col_x`, the frame's layout): neighbours' places are checked
    against each other, each instrument checks its carrier is in its
    place (`carrier_in_slot`); a new instrument gets a place there.
  - `twin_drive.inc.scad` — the two motor drive of `hi.scad` and
    `tc.scad`, included after the instrument defines `y_bd` (the disc's
    paper), `y_ax` (the axle), `twin_nano_x` and `twin_posts`: motor A to
    the axle 1:1 (the standard's gears), a disc on the dial's hub turned
    by motor B's pinion in its internal ring gear (5:1), homed by a magnet
    in the disc over a sensor in the dial's front; the dial
    (`twin_dial`), the back plate with both motors slanted side by side,
    the carrier (two ULN2003s, the Nano, USB up), their checks and view
    parts (`twin_drive_parts`). The instrument draws its case, the axle's
    part and the papers.
  - `rpm.scad` — the RPM indicator (tachometer): 0-35 hundred RPM over
    240 degrees, the 172N's stepped green arc and red line at 2700, a
    dummy hour meter.
  - `asi.scad` — the airspeed indicator (the six-pack's top left):
    KNOTS 40-200 on a non-linear scale (`asi_cal`, also the MobiFlight
    interpolation table in the README), MPH inside, the 172N's white,
    green and yellow arcs and red line at 160.
  - `vsi.scad` — the vertical speed indicator (the six-pack's bottom
    right, under the altimeter): 0 at 9 o'clock, UP over the top and DOWN
    under it to 2000 ft/min, the 20s either side of 3 o'clock, on a
    non-linear scale (`vsi_cal`, also the MobiFlight interpolation table
    in the README); white on black. The standard, 54 mm deep.
  - `ai.scad` — the attitude indicator (the six-pack's top middle,
    modelled on the RC Allen 172 instrument: its dial and bowl markings,
    the yellow airplane on a pedestal, the index): the standard's case front, then its
    own mechanism. A roll frame (a thin roll dial ring ending at the long
    bank marks, two arms, a back disc with the roll gear) turns in a
    printed sleeve (front ring with the bank index, a triangle hanging
    from the top with a slit for the dial's zero line, and the glued-in
    airplane on its pedestal with the bottom mask; legs to the back
    plate). A square front bezel (`bezel`, the frame's `ai_bezel`) in
    front of the sheet, the case's 4 screws through its corners, a dummy
    knob on its bottom edge. The horizon is a bowl (part of a
    sphere, `bowl_r`, two halves in sky and ground filament glued at the
    horizon, raised ribs painted white) on pivot pins in the arms, 1:1
    with the pitch, ±`pitch_max`. The pitch motor rides on the roll frame
    inside the bowl (bracket on the back disc, rack-cut pinion to a gear
    sector on the bowl's hex hub, 3:1), homed by a magnet in the bowl's
    side over a sensor in the right arm (`home_pitch`); its 7 wires cross
    the roll axis through an MSM-12-08A capsule slip ring (`sr_*`, the
    hole circle MEASURE) screwed onto the back plate. The roll motor is
    alone on the back plate, its body beside its shaft, 1:1 to the roll
    gear; two ULN2003s and a Nano on a carrier behind it. Print `face`
    (roll dial). 131 mm deep (`ai_depth` in the frame: it stays over the
    force feedback yoke's housing).
  - `alt.scad` — the altimeter (the six-pack's top right): the standard's
    case front with three screws (the lower left place is the knob's),
    then its own mechanism. Two needles on concentric shafts (100 ft on
    the 3 mm axle, 1000 ft on a 4 mm brass tube, `tube` MEASURE; no
    10000 ft needle, the airplane stays under 10000 ft), each with a
    28BYJ-48 of its own and its own home: motor C on a rear plate drives
    the axle directly (a coupler with the magnet), motor B on the back
    plate turns the tube's gear (layer `y_l2`) through 28:14 gears, so
    the motor's one home a turn is the needle's (the magnet in the motor
    gear). The Kollsman windows: a disc
    behind the dial (a printed paper ring: inHg 28.1-31.0 inside, shown
    at 3 o'clock, hPa 952-1049 outside, shown at 9 o'clock) turned by the
    knob through an idler and an internal ring gear (`z_k`, its gears in
    layer `y_l1`), a 10 turn
    pot on the knob's shaft (`pot_*`, MEASURE) gives MobiFlight the
    setting absolutely (A7). The keeper holds the disc on the dial's hub
    and its legs press and key the dial. Boards on a carrier behind
    motor C. Print `face` (face and Kollsman ring). 114 mm deep
    (`alt_depth` in the frame: top row, over the housing).
  - `hi.scad` — the heading indicator (the six-pack's bottom middle):
    the standard's case front with two screws (top diagonals), the lower
    corners are the knobs': EC11 rotary encoders with push switches in
    brackets of the case (`enc_*`, MEASURE; left: gyro set, right: bug),
    nut behind the sheet. A white printed airplane glued on the glass,
    the mask (fixed ring: index, 45 degree marks) behind it, the card
    (on the 3 mm axle, 1:1 to motor A like the standard's needle) in the
    mask's opening, the bug disc behind the card (its edge shows the
    orange bug) turning on the dial's hub, an internal ring gear on its
    back turned by motor B's pinion (5:1), its magnet in the disc and the
    sensor in the dial's front. The motors side by side on the back
    plate, slanted so their covers pass; the carrier (two ULN2003s, the
    Nano, USB up) behind them, facing back (the drive is
    `twin_drive.inc.scad`). 77 mm deep (`hi_depth`) only
    above `hi_deep_z`, 19 mm under it (`hi_low_depth`): the frame checks
    both against the housing. Print `face` (card, bug ring, fixed ring).
  - `tc.scad` — the turn coordinator (the six-pack's bottom left): the
    standard's case front with four screws, no knob, and the heading
    indicator's two motor drive. The white airplane on the 3 mm axle in
    front of the face (1:1 to motor A, the standard's), the face plate
    (a cup holding the glass, the face glued on) with the inclinometer's
    tube as a slot round the axis under it (`ball_r`, ±`slot_a`) and two
    bridges for the wires; behind it the ball disc (the black ball on a
    paper ring) on the dial's hub, an internal ring gear turned by motor
    B's pinion (5:1), its magnet in the disc, the sensor in the dial's
    front. The carrier behind the motors, shifted left of the HI's
    (`carrier_slots`). 80 mm deep (`tc_depth`) only above `tc_deep_z`,
    22 mm under it (`tc_low_depth`), checked by the frame. Print `face`
    (face and ball ring).
  - `cdi.scad` — the NAV indicators (NAV 1 and NAV 2 are the same print,
    a Nano each): a VOR course deviation indicator, no glideslope. The
    standard's case front with three screws, the OBS knob at the lower
    left. The azimuth card is a ring in front of the needle (toothed
    band behind it, riding on a guide ring glued on the dial), turned
    mechanically by the knob's pinion (`z_card` / `z_kp`, 3.33 knob
    turns a card turn); a gear pair on the knob's shaft behind the dial
    turns a sensor gear 1:1 with the card (`z_sg` / `z_kg` must equal
    it), its diametric magnet over an AS5600 board (`as_*`, MEASURE)
    whose analog output (A7) gives X-Plane the OBS absolutely, endless.
    The needle hangs from a pivot at the top (`pivot`, behind the card),
    5 dots each side; a gear sector on its axle is turned 4:1 by a
    28BYJ-48's pinion, homed by a magnet in the sector. The TO/OFF/FROM
    flag is a printed sector on an SG90 servo (`sv_*`, MEASURE) behind a
    window in the face, OFF in the middle. Layers: card, needle, dial,
    layer 1 (flag, knob gear, sensor gear), layer 2 (sector, pinion,
    AS5600), back plate (motor, servo), carrier (ULN2003, Nano). 81 mm
    deep (`nav_depth`) only right of `nav_deep_x` (the force feedback
    housing ends just right of NAV 1's left edge), 20 mm left of it
    (`nav_low_depth`), checked by the frame. Print `face` (card, face,
    flag fields; black, red, white).

- `lib/` — not a component (no Makefile, no README): bought parts that
  every component uses, as `*.inc.scad` files the Makefiles copy into each
  component's `target/` (a component's own include must not take one of
  their names).
  - `nano.inc.scad` — the Arduino Nano: its sizes (`nano_*`, MEASURE),
    pinout (`nano_digital_row`, `nano_analog_row`, `nano_pin(name, row)`),
    a view model (`nano_part`) and the shallow rails it slides into
    (`nano_rails`: walls with a groove whose ledge and lip reach only
    `nano_rail_reach` over the board, clear of the pin rows' solder;
    `far_stop`, `jack_stop`, `lips = false` to drop it in from above),
    fitted to a real board in the switch panel's carrier. In its own
    coordinates (middle at the origin, on z=0, component side up, the
    jack at +y); each component places it with a proper rotation (a
    mirror swaps the pin rows). Every component with a Nano includes it:
    throttle, yoke, switch panel, compass, radio, instruments, pedestal, flaps. Its names
    are global: do not reuse them in a component.
  - `stepper.inc.scad` — the stepper drive of the compass and the
    instruments: the 28BYJ-48 (`motor_*`, `shaft_*`, view model
    `motor_local`: flange top at z=0, shaft up, body towards +y), the
    ULN2003 board (`uln_*`, its standoffs `uln_standoff`,
    `uln_standoff_d`, its holes `uln_hole_xy` from its middle, the room in
    front of it for the female Dupont plugs on its pins `uln_plug_room`,
    which every board's clearance and depth counts, view model
    `uln_part` on a plate at z=0), the A3144 (`sensor`) and the magnet
    (`magnet`; the flaps panel's lever sensors use them too), all MEASURE. The holders (motor posts and plates,
    carriers, sensor pockets) stay in the components.
  - `usb.inc.scad` — the USB cable: plug (`usb_plug`), cable (`cable_d`)
    and tie (`tie`, `tie_slot`) sizes (MEASURE), and what it is tied onto:
    `tie_block` (in line behind the plug, the cable in a groove on its
    top at `tie_cable_h`, the tie through a slot at its foot; switch
    panel, yoke, pedestal, flaps), `tie_post` (beside the cable with a tunnel along it;
    the radio units), a view of the tie (`tie_part`). Both in their own
    coordinates (foot on z=0, middle over the origin, cable along x).
    The throttle and the compass take `usb_plug` for their back wall
    windows; the instruments do not include it (their `usb_plug` is a
    length).

- `frame/` — the aluminium extrusion frame on the desk and the ACM panel
  sheets over it, all 2020 profile. `frame.inc.scad` holds the
  extrusion/sheet standard, the
  sizes of the components it carries (copies of the other components'
  values and MEASURE values for the bought Saitek yoke and radio panel,
  keep them in sync), the layout and its checks; `frame.scad` has the
  views and the cut list (echo), no printed parts. Every
  component brings its own front face and is screwed onto a cut-out in the
  sheet; heavy or pulled ones also stand on the frame. The layout follows
  the X-Plane 172N panel (`n172_*`) around the yoke column: the Saitek
  yoke stands on the desk, clamped on its edge, its shaft through a round
  hole in the sheet; above it the reserved instruments (`inst_c`: six-pack,
  NAV 1 and 2 right of it, RPM beside the column), right of them the radio
  stack; below the desk top the lower panel (ignition with the primer,
  switch row, throttle box and flaps (`flaps/`) on the throttle bar, parking brake),
  its backs under the desk's underside and the yoke's clamps, its bottom
  over the pilot's knees (`knee_z`, the chair lowered). Stage 2 also
  brings a DIY force feedback yoke, its housing set back (`ffb_back`) so
  the instruments' deep cases fit in front of it. Stage 1 (now): the
  left part above the desk is only as high as the yoke column needs, the
  monitor shows the instruments; stage 2 (physical instruments) moves the
  left top bar up to the right one's height and cuts a full height left
  sheet, nothing else moves. The width is computed (`frame_w`). The frame
  is two parts bolted together: the vertical front part in front of the
  desk edge (bottom bar, four uprights: left end, split, step, right end;
  two waist bars just under the desk top right of the yoke's clamps, a low
  left and a high right top bar, the throttle bar behind, the apron with
  the pedestal (`pedestal/`) hanging under the throttle; bars cut to length;
  three sheets: an L shaped left one, lower right and upper right), and the
  desk part (a ladder on the desk, stock lengths, its front rail cut at the
  yoke), with 45 degree braces between them (stock bars cut square,
  bought 45 degree connectors). The front rail runs past the sheet at both
  ends (`ear_len`), where two bought screw clamps clamp it onto the desk
  (no printed parts in the load path: they creep under constant load).
  The powered USB hub stands on the desk right of the yoke (not bolted
  down); the crossbars are as long as the yoke needs.

## Documentation

Every component has one `README.md` in its directory: it describes that
component (working principle, hardware with shop links, wiring, assembly)
and embeds its montage images. The top-level `README.md` is the overview:
building, and a short description, the montage and a link per component.
Its `Connections` section is how the components connect: every
MobiFlight component has its own Arduino Nano (each radio unit too) with
one USB cable to a powered USB hub on the desk right of the yoke, so each
one stands and is tested on its own; switches go to GND on the Nano's
internal pull-ups. It has the MobiFlight setup, the USB hub's spec (port
count, the homing peak) and power; the other READMEs link there
(`../README.md#connections`) instead of repeating it. What a component
takes from the hub (ports, current, its peculiarities) is in its own
README, in a *USB* paragraph. Links between READMEs are relative. Keep
them in sync when a design, part list or wiring changes: the component's
README (its *USB* paragraph too when its board or its current changes),
and the top-level overview when a component is added, its summary
changes or the hub's totals change. (The old hub, a Mega with RJ45 ports
and Cat5 cables, is retired; its `hub/` directory is in the git history.) A new
component gets its own README and an entry in the top-level one; do not add
other docs files. The scad header comments stay as the in-source summary.

The README images are not committed. The `Build` workflow
(`.github/workflows/build.yml`) runs `make` in every component on each push
and, on `master`, deploys the STLs, PNGs and PDFs to GitHub Pages at
`https://robertbraeutigam.github.io/cessna172/<component>/<file>`; the
READMEs link there. It caches each component's `target/` together with
`target/.sources.sha256` (hashes of the sources it was made from), so only
changed `.scad` files are rendered again; a changed Makefile or include
(the component's own or `lib/`'s) re-renders the whole component. Unchanged parts therefore keep the `{{gitrev}}` and montage
date of the build that last rendered them.

## Building

Run `make` inside a component directory (e.g. `throttle/`). The OpenSCAD binary
comes from the `OPENSCAD` environment variable (set in the user's environment
to an OpenSCAD development snapshot AppImage, the one pinned in
`.github/workflows/build.yml` (`OPENSCAD_APPIMAGE`), for the Manifold backend;
the Makefile does not define it):

```sh
cd throttle
make                       # render every .scad that changed (STLs + views)
make models                # only the STLs
make views                 # only the PNG views
make target/throttle_box   # render a single file
make clean                 # remove target/
```

All projects share the same Makefile; keep the copies identical.

`*.inc.scad` files hold values and modules shared by the files of a
component, which `include <name.inc.scad>` them. They are not rendered, the
Makefile copies them into `target/` (models are rendered from there) and
every model depends on them, and the build workflow renders the whole
component again when one changes. The shared ones in `lib/` are copied
the same way (included as `<nano.inc.scad>`), and a change to one renders
every component again. Do not assign a variable again that the
include already defines: OpenSCAD silently takes the last value.

Output goes to `target/` (not committed). `target/<file>` and
`target/<file>.views` are empty markers used by make to skip up-to-date files;
the STLs and PNGs sit next to them. Old STLs are not
removed when a module is renamed or deleted, so `make clean` if in doubt.

### Modules: one scad file, several printable STLs

A "module" here means one unit of 3D printing, not an OpenSCAD `module`. A file
declares them with marker comments on the line that instantiates the geometry:

```openscad
box_lid(); // Make module lid
//#big_pots(); // Ignore module
```

- `// Make module <name>` — the Makefile renders a separate
  `target/<file>_<name>.stl` containing only that line. It first comments out
  every marker line, then uncomments one at a time. **A leading `//` on a Make
  module line does not disable it in the build**; it only hides it from the
  OpenSCAD GUI preview. To stop building a module, remove the marker.
- `// Ignore module` — never rendered. Used for reference geometry (pots, rods)
  that is shown with `#` in the preview while designing.
- `// Make print <name>` — a 2D statement exported to
  `target/<file>_<name>.pdf`, 1:1 on an A4 page, filled black (paper
  parts; the PDFs are deployed with the STLs). Prints are
  made with the models, also from files with modules.
  `// Make print <name> <colour>,<colour>,...` (no spaces in the list) is
  a colour print: the statement is rendered once per colour with
  `print_color` set to it, the file drawing only that colour's shapes
  (`ink()` in `instruments/instrument.inc.scad`), each layer filled with
  its colour, and `qpdf` overlays them in the list's order (later covers
  earlier; white covers, it is the paper). The PDF export centers every
  layer on its own outline, so the file must draw the same registration
  marks in every layer.
- Files without any `Make module` marker are rendered whole to
  `target/<file>.stl`, unless they have `Make view` markers: then they
  only make views (their asserts are still checked), like `frame.scad`.

Marker format is strict: the name is a single word, separated by single
spaces, and it must be the last thing on the line (trailing spaces are OK).
The whole statement must fit on that one line, e.g.
`translate([0, 0, z]) rotor(); // Make module rotor`, because the Makefile
comments out and uncomments whole lines.

### Views: PNG pictures of the design

```openscad
//exploded_view(pos = 0); // Make view main 62,0,32
```

`// Make view <name> <rx>,<ry>,<rz>` renders that line alone to
`target/<file>_<name>.png`, with the camera rotated as given (`0,0,0` looks
from +z) and automatically framed. Views use the colored OpenSCAD preview
renderer (OpenCSG), so they need a display, and they are rendered at twice
the size and then trimmed, scaled and padded with ImageMagick (`convert`) if it
is installed. With ImageMagick, `target/<file>_montage.png` combines them: a
title (the first comment line of the scad file), the `main` view (or the first
view if there is no `main`) and the other views as captioned thumbnails.
View lines are usually commented out in the source so the GUI
preview shows the parts; as with modules, that does not stop them from being
built. Keep view-only geometry and colors (bought parts, labels, exploded
layouts) in `*_view` / `*_part` modules so they never end up in an STL.

The Makefile also replaces `{{gitrev}}` in the source with the short git hash,
so a version can be embossed into a part. Files are rendered from the copy in
`target/`, so any `use`/`include` paths would resolve relative to `target/`.

## Design conventions

- Units are millimetres. `$fn` is set at the top of each file.
- Dimensions go in named variables at the top of the file, with derived values
  computed from them; reuse the same names across files (e.g. `pin.scad`
  repeats the `big_pot_*` values from `throttle_box.scad`).
- Hole clearances used so far: 3.2–3.3 mm for M3 screws, 2.8 mm for M3 self
  tapping pilot holes, 2.1 mm for M2 pilot holes (only the ignition, built;
  use M3 for new parts; M2 does not go through the Nano's 1.8 mm
  mounting holes, it goes in rails), 4.2 mm for M4 / the USB cable, 5.3 mm for M5 (frame), 6.2 mm for the 6 mm rods, 11.2 mm for
  the rod nuts.
- The printer is an Anycubic Kobra 3 V2 with a 255 x 255 mm bed. Pieces must
  fit it; files with big parts check it with a `bed = [255, 255]` parameter.
- Values that depend on bought parts are grouped as parameters marked
  MEASURE, and `assert()`s check that derived geometry still fits, so a
  wrong measurement fails the build instead of printing a bad part.

## Verifying changes

After editing a `.scad` file, run `make` (or the single-file target) in the
component directory and check it finishes without OpenSCAD errors/warnings.

## Git

Commit messages are short imperative summaries, e.g. `Add reverse pin`,
`Modify slider clamp`.
