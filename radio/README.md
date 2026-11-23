# Radio stack

[Cessna 172 home cockpit](../README.md) / `radio/`

The KMA 26 audio panel at the top, two KX155 NAV/COM
radios (COM1/NAV1, then COM2/NAV2) and the KT 76C transponder at the
bottom, stacked in one cut-out of the panel sheet like the real stack.
The KX155s and the KT 76C are read and driven by a second Arduino Mega of
their own, the audio panel by its own Arduino Nano (see
[KMA 26](#kma-26)). All units are 224 mm wide (`unit_w`, the KX155's
width), each has its real height: the stack is 33 + 2 x 50.8 + 41.9 =
176.5 mm high.

[![KMA 26](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kma26_montage.png)

[![KX155](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kx155_montage.png)

[![KT 76C](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)](https://robertbraeutigam.github.io/cessna172/radio/kt76c_montage.png)

| File | Parts |
|------|-------|
| `radio.inc.scad` | the stack's standard: unit width, KX155 height, face, end flanges and mount holes, the 7 segment digit sizes, lettering; the parts the units share (tactile switch, MAX7219 board, rotary switch, 3 mm LED, bosses, knob shapes) |
| `kma26.scad` | the KMA 26: body (printed in one piece), front face, the 10 button caps (one print), MKR MUTE cap, marker lamp lenses, volume and mic knobs |
| `kx155.scad` | the KX155: body (printed in one piece), front face, outer and inner frequency knob, volume knob, flip-flop button |
| `kt76c.scad` | the KT 76C: body (printed in one piece), front face, display mask, the 11 button caps (one print), function selector knob |

## KMA 26

The face copies the KMA 26, spread out to the stack's width: at the left
the marker beacon lamps O (blue), M (amber) and I (white), the photocell
(a dummy hole) and the MKR MUTE button; the marker sensitivity toggle
(HI SENS, LO SENS, TEST) and the intercom toggle (PILOT, CREW, ALL); the
INTERCOM knob; the 10 audio select buttons COM1 COM2 COM3 NAV1 NAV2 / MKR
DME ADF AUX MONI, each with its annunciator bar; at the right the MIC
selector (EMG, C1, C2, C3, PA). The model name is lettered, not the
maker's logo.

- **Buttons**: printed gray caps (labels engraved, filled with white
  paint) through the face, held behind the plate by their flange; a post
  presses a 6 x 6 mm tactile switch. The annunciator bar is a slot through
  the cap: a 2 x 5 mm rectangular LED on the board reaches into a channel
  in the cap's back and lights it, so the bar shows which audio is on.
- **Marker lamps**: printed lenses in natural (translucent) filament, the
  letter engraved into their front (fill it with black paint; tint the
  lens with glass paint if you like). Their ears sit in a pocket in the
  plate front, clamped by the face, 1 mm behind the face front like a
  bezel. Behind each is a 3 mm LED of its color in its own cell.
- **Knobs**: the real ones are dual concentric (VOL and CREW/PASS; the mic
  selector and PUSH SPKR). X-Plane has no use for the second knob, so
  each is one printed stepped knob shaped like the pair: the INTERCOM knob
  on a 10 kOhm pot (the radio volume), the MIC knob on the KT 76C's 1 pole
  12 way rotary switch, set to 5 positions, every position on its own pin.
- **Toggles**: mini toggle switches with a 6 mm bushing, nutted onto the
  face: ON-OFF-(ON) for HI/LO/TEST (TEST springs back), ON-OFF-ON for
  PILOT/CREW/ALL. The middle position is the one with no contact.
- **Inside**: two front perfboards on bosses on the plate back: the
  marker board (the lamp LEDs, the MUTE switch) and the button board (10
  switches, 10 LEDs), each LED with its resistor beside it. Behind them,
  in rails on the floor like the KX155's driver boards, the logic board.
- **Its own board**: the KX155s and the KT 76C leave only 5 pins of the
  stack's Mega, and the audio panel needs 20 inputs, 13 lamps and a pot.
  So it runs MobiFlight on an Arduino Nano on the logic board, with a
  CD74HC4067 mux for 15 of the inputs and two chained 74HC595 shift
  registers for the lamps; its USB cable leaves through the open back,
  tied onto the tie block, to the powered USB hub. The Connector shows it
  as a board of its own.
- **Size**: 224 x 33 mm (the real 1.30"), 75 mm deep; mounted like the
  KX155s with two M3 screws in each end flange, on top of the stack.

The toggle, pot, rectangular LED and Nano sizes (`tg_*`, `vol_*`,
`bar_led`, `nano_*`) are MEASURE values (guesses until bought), the rotary
switch is the KT 76C's (`rot_*` in `radio.inc.scad`). The `assert`s check
that the lettering stays off the buttons, knobs, nuts and screws, and that
the buttons, lamp cells, boards, switches and knobs do not collide.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | Arduino Nano (ATmega328P, 5 V), female headers, USB cable | MobiFlight board of the audio panel |
| 1 | CD74HC4067 16 channel mux breakout | inputs |
| 2 | 74HC595 + DIP 16 socket | lamp outputs |
| 1 | rotary switch, 1 pole 12 way, 6 mm shaft, with stop washer (Lorlin CK type) | MIC selector |
| 1 | pot 10 kOhm linear, 6 mm shaft | INTERCOM volume |
| 1 | mini toggle switch ON-OFF-(ON), 6 mm bushing | HI SENS / LO SENS / TEST |
| 1 | mini toggle switch ON-OFF-ON, 6 mm bushing | PILOT / CREW / ALL |
| 11 | tactile switch, 6 x 6 mm, 5 mm high | 10 buttons, MKR MUTE |
| 10 | rectangular LED 2 x 5 mm, white | annunciator bars |
| 3 | LED 3 mm: blue, amber, white | marker lamps O, M, I |
| 13 | resistor 1 kOhm | one per LED |
| - | perfboard | marker board, button board, logic board |
| 4 | M3 x 10 pan head screw + nut | face flanges onto the sheet |
| 4 | M3 x 8 self tapping screw | front boards onto the bosses |

Print the caps in gray, the MUTE cap in white, the lenses in natural
filament front side down, the knobs on their front.

### Assembly

Lenses into their pockets in the plate front, then the face on (it
clamps them). Button caps and the MUTE cap in from the back. Solder the
switches, LEDs (standing on the board) and resistors onto the front
boards and screw them onto their bosses. Toggles, pot and rotary switch
through plate and face from the back, nuts on the front. Logic board into
its rails, wiring, USB cable tied onto the tie block. Turn the rotary
switch fully left (EMG) and press the MIC knob on pointing at EMG, then
the INTERCOM knob. Into the sheet over the KX155s.

### Wiring

Everything goes to the Nano on the logic board; switches to GND
when active, like everywhere in the cockpit:

| Signal | Nano pin | MobiFlight device |
|--------|---------------|-------------------|
| mux S0..S3 | D2, D3, D4, D5 | *Multiplexer* |
| mux SIG | D6 | (its data pin) |
| MIC EMG, C1, C2, C3, PA (the rotary switch's common to GND) | D7, D8, D9, D10, D11 | 5 *Buttons* |
| 74HC595 DATA, CLOCK, LATCH | D12, D13, A0 | *Shift Register*, 2 chained |
| INTERCOM pot wiper (pot between 5 V and GND) | A7 (analog only) | *Analog input* |

Mux channels: C0..C9 the buttons COM1, COM2, COM3, NAV1, NAV2, MKR, DME,
ADF, AUX, MONI; C10 MKR MUTE; C11 HI SENS, C12 TEST; C13 PILOT, C14 ALL
(LO SENS and CREW are the middle positions, no contact); C15 free. Shift
register outputs: the first chip's Q0..Q7 are the bars of COM1..ADF, the
second's Q0..Q4 the bars of AUX and MONI and the lamps O, M, I; Q5..Q7
are free. Each LED's anode goes through its 1 kOhm resistor to its 595
output, the cathode to GND. White and blue LEDs are dim on 1 kOhm: go
down to 470 Ohm, not lower (a 595 gives about 70 mA in all).

D0 and D1 are the Nano's USB serial, A1..A6 are free (A6 and A7 are
analog only; the Connector numbers A0..A7 as 14..21). D13 also drives the
Nano's own LED, which flickers with the shift register clock. In the
Connector, flash the Nano with the MobiFlight firmware like the Megas (it
tries both bootloader speeds, so old bootloader clones work too). The
Nano firmware takes up to 18 buttons, 6 multiplexers, 6 shift registers
and 8 analog inputs, but has little memory for the configuration: keep
the device names short (EMG, C1, VOL, LAMPS, MUX); the panel then uses
about a third of it.

### In X-Plane

Check the names in DataRefTool; the audio panel datarefs are among
`sim/cockpit2/radios/actuators/`:

| Control | Dataref / command |
|---------|-------------------|
| COM1, COM2, NAV1, NAV2, ADF, DME, MKR buttons | `sim/audio_panel/monitor_audio_com1`, `_com2`, `_nav1`, `_nav2`, `_adf1`, `_dme`, `_mkr` (toggle) |
| Their bars | `audio_selection_com1`, `_com2`, `_nav1`, `_nav2`, `_adf1`, `audio_dme_enabled`, `audio_marker_enabled` |
| MIC EMG, C1 / C2 | `audio_com_selection` = 6 (COM1) / 7 (COM2); EMG is COM1 like in the real one |
| Lamps O, M, I | `sim/cockpit2/radios/indicators/outer_marker_lit`, `middle_marker_lit`, `inner_marker_lit`, or the TEST input pressed |
| HI / LO SENS | X-Plane's marker sensitivity, if your version has it |
| INTERCOM VOL | `sim/operation/sound/radio_volume_ratio`, transform `$/1023` |
| COM3, AUX, MONI, MKR MUTE, PILOT/CREW/ALL, C3, PA | nothing in the 172; COM3, AUX and MONI can toggle a MobiFlight variable that lights their bar |

For TEST, the button sets a MobiFlight variable while it is held, and
each lamp's output shows the lit dataref or that variable (a config
reference). Blank the bars and lamps while the avionics are off
(`sim/cockpit2/switches/avionics_power_on`, a precondition).

## KX155

The face copies the KX155: the four frequency windows along the top (COM
USE and STBY, NAV USE and STBY, labeled above), and along the bottom, for
COM and then for NAV, the volume knob, the flip-flop button (USE <->
STBY) and the dual concentric frequency knob: the big outer knob sets the
MHz, the small inner one the kHz. Turning a volume knob fully left
switches that radio off (a pot with a switch).

- **European frequencies**: COM shows 6 digits with three decimals, so
  the 8.33 kHz channels fit (118.005); NAV shows 5 (108.00).
- **Digits**: red 0.28" 7 segment LEDs (3 digit modules, two per
  frequency; NAV leaves the first digit off, behind the face) behind a
  red acrylic filter in each window. Each frequency has its own MAX7219
  driver. These digits are 7.5 mm apart, wider than the real ones, so
  the unit is 224 mm wide instead of the real 159 mm (6.25"). The height
  (50.8 mm, 2.00") and the layout are the real ones.
- **Mounting**: the body goes through the sheet's radio cut-out; the face
  has a 9 mm flange at its left and right ends only, with two M3 screws in
  each (nuts behind the sheet). There is none at the top and bottom, so
  the units stack without a gap and the cut-out is as high as the stack.
- **Inside**: the digits are soldered on two perfboards (COM, NAV),
  screwed onto bosses on the back of the face plate, pressing the digits
  against the filters. The encoders and pots are nutted through the face
  (the nuts sit under the knob skirts). Each flip button presses a 6 x 6
  mm tactile switch on a small perfboard on two bosses behind it. The four
  MAX7219s are the cheap 8x8 matrix kit boards with the matrix left off,
  slid into rails on the floor from the open back and wired to the digit
  boards with jumpers from their matrix sockets. The cable leaves through
  the open back, tied onto the tie block.
- **Knobs**: printed, ribbed like the real ones, pressed on: the outer and
  volume knobs onto round shafts (crush ribs in the bore), the inner knob
  onto the D shaft. Print them on their front.

The encoder, pot, tactile switch, digit and driver board sizes are
MEASURE values in `kx155.scad` (the encoder bushing is a guess). The
`assert`s check that the knobs, buttons and parts behind the face do not
collide and that the knobs hold enough of their shafts.

The frame (`frame/`) still has the Saitek radio panel's cut-out, but its
right part is already as high as the stack with the audio panel on top
needs (`stack_units_h`); when the stack replaces the Saitek panel, the
right sheet is cut again (the Saitek's cut-out is wider than the stack's
faces).

### Hardware

Per KX155:

| Qty | Part | Use |
|-----|------|-----|
| 2 | dual concentric encoder with push switch, 6 mm outer / 3.5 mm D inner shaft (Alps EC11EBB24C03 type) | COM and NAV frequency |
| 2 | 10 kOhm linear pot with switch, 6 mm shaft | COM and NAV volume, on/off |
| 2 | tactile switch, 6 x 6 mm, 5 mm high | flip-flop buttons |
| 8 | 7 segment module, 0.28", 3 digits, common cathode, red (e.g. Lumex LDT-N2804RI) | the four frequencies |
| 4 | MAX7219 8x8 dot matrix kit board (without the matrix) | digit drivers |
| 4 | red transparent acrylic, 2 mm, cut to the window plus 1.5 mm all round | display filters |
| - | perfboard | 2 digit boards, 2 flip switch boards |
| 4 | M3 x 10 pan head screw + nut | face flanges onto the sheet |
| 8 | M3 x 8 self tapping screw | boards onto the bosses |

For the stack: 1 Arduino Mega (the radio stack's MobiFlight board) and a
USB cable to the powered USB hub.

### Wiring

Every unit has its own cable to the stack's Mega (its box and the cable
type are still open, they come with the frame's stack cut-out). Per
unit, all inputs go to GND when active, like everywhere in the cockpit:

| Signal | Wires | MobiFlight device |
|--------|-------|-------------------|
| 5 V, GND | 2 | |
| MAX7219 DIN, CLK, CS | 3 | *LED Module*, 4 modules in the chain |
| COM encoder outer A, B; inner A, B | 4 | 2 *Encoders* |
| NAV encoder outer A, B; inner A, B | 4 | 2 *Encoders* |
| COM and NAV encoder push | 2 | 2 *Buttons* |
| COM and NAV flip button | 2 | 2 *Buttons* |
| COM and NAV pot switch | 2 | 2 *Buttons* |
| COM and NAV pot wiper | 2 | 2 *Analog inputs* (analog Mega pins) |

That is 21 wires, 19 Mega pins per unit. With the KT 76C's 25 (see its
Wiring section) the stack takes 63 of the Mega's 68 free
pins (54 digital and 16 analog, without 0 and 1, the USB serial); the
KMA 26 has its own board. The four
MAX7219s are chained DOUT to DIN, in the order COM USE, COM STBY, NAV USE,
NAV STBY. On each digit board, wire digit 0 of a MAX7219 to the leftmost
digit of its frequency. The pots go between 5 V and GND, the wiper to the
Mega.

The MAX7219s take their current from the Mega's USB 5 V: keep the
brightness low in the Connector (the real displays are not bright
either). If the Mega resets, feed the digits from a separate 5 V supply,
its GND joined to the Mega's.

### In X-Plane

The Connector configs for COM1/NAV1 (the second unit: `com2`, `nav2`).
Check the names in DataRefTool, and that the aircraft's radios use 8.33
kHz spacing:

| Control | Dataref / command |
|---------|-------------------|
| COM USE, STBY (6 digits, point after the 3rd) | `sim/cockpit2/radios/actuators/com1_frequency_hz_833`, `com1_standby_frequency_hz_833` (kHz) |
| NAV USE, STBY (5 digits, point after the 3rd, on the last 5 of the 6) | `sim/cockpit2/radios/actuators/nav1_frequency_hz`, `nav1_standby_frequency_hz` (10 kHz) |
| COM outer knob | `sim/radios/stby_com1_coarse_up` / `_down` |
| COM inner knob | `sim/radios/stby_com1_fine_up_833` / `_down_833` |
| NAV outer knob | `sim/radios/stby_nav1_coarse_up` / `_down` |
| NAV inner knob | `sim/radios/stby_nav1_fine_up` / `_down` |
| COM, NAV flip | `sim/radios/com1_standy_flip`, `sim/radios/nav1_standy_flip` |
| COM, NAV volume | `sim/cockpit2/radios/actuators/audio_volume_com1`, `audio_volume_nav1` |
| COM, NAV on/off (pot switch) | `sim/cockpit2/radios/actuators/com1_power`, `nav1_power` |

Set the encoder type in the Connector so one detent is one step, and the
displays blank while the radio's power is off.

## KT 76C

The face copies the KT 76C: the IDT button at the top left, the display
window, along the bottom the code buttons 0..7, CLR and VFR, and at the
right the function selector knob: OFF, SBY, TST, ON, ALT.

- **Display**: like the real one, the flight level on the left, marked
  FL (pressure altitude in hundreds of feet: FL 045 is 4500 ft at 1013
  hPa), the squawk code on the right and the annunciators between them:
  R (reply) over FL at the left end, ALT, ON, GND and SBY in the middle.
  X-Plane has the pressure altitude as a dataref
  (`sim/flightmodel2/position/pressure_altitude`, feet, read only), so
  MobiFlight can show it (see In X-Plane below).
- **Digits**: the KX155's red 0.28" 7 segment modules: the flight level
  is one 3 digit module, the code two (the second module's last two
  digits are behind the face), 7 digits on one MAX7219.
- **Annunciators**: the words are cut through a printed black display
  mask behind the red filter, as stencil letters (thin bridges hold the
  middles of A, O, D, B and R). Each word has its own cell in the mask
  with a 3 mm red LED behind it, on its own Mega pin. The mask also has
  the openings the digit modules sit in, and it is clamped between the
  filter and the front board.
- **Buttons**: printed caps (cream or white, the engraved labels filled
  with black paint) through the face, held behind the plate by their
  flange, a post on their back presses a 6 x 6 mm tactile switch.
- **Function selector**: a 1 pole 12 way rotary switch with its stop
  washer set to 5 positions (30 degrees apart), nutted onto the face,
  every position on its own Mega pin, so the sim always follows the
  knob. The printed knob has a pointer line engraved for white paint.
- **Inside**: one front perfboard, cut L shaped (its lower strip runs
  under the rotary switch to CLR and VFR), carries the digit modules, the
  LEDs and all 11 tactile switches; it is screwed onto three bosses on
  the plate back. The MAX7219 is the matrix kit board without the matrix
  in rails on the floor, like the KX155's. The cable leaves through the
  open back, tied onto the tie block.
- **Size**: 224 x 41.9 mm (the real height, 1.65"), 57 mm deep; mounted
  like the KX155s with two M3 screws in each end flange.

The rotary switch (`rot_*`) and LED sizes are MEASURE values (the rotary
switch is a guess until it is bought). The `assert`s check that the
buttons, the display, the board screws, the rotary switch and the knob
labels do not collide.

### Hardware

| Qty | Part | Use |
|-----|------|-----|
| 1 | rotary switch, 1 pole 12 way, 6 mm shaft, with stop washer (Lorlin CK type) | function selector |
| 11 | tactile switch, 6 x 6 mm, 5 mm high | IDT, 0..7, CLR, VFR |
| 3 | 7 segment module, 0.28", 3 digits, common cathode, red (e.g. Lumex LDT-N2804RI) | flight level, code |
| 1 | MAX7219 8x8 dot matrix kit board (without the matrix) | digit driver |
| 6 | red LED, 3 mm, and a 1 kOhm resistor each | annunciators |
| 1 | red transparent acrylic, 2 mm, 137 x 17 mm | display filter |
| 1 | perfboard, 10 x 22 cm, cut to the front board | everything on the face |
| 4 | M3 x 10 pan head screw + nut | face flanges onto the sheet |
| 3 | M3 x 8 self tapping screw | front board onto the bosses |

Print the display mask in black (light must not shine through it), front
side down, so the stencil bridges are in the first layers.

### Assembly

Filter into its frame on the plate back, button caps in from the back,
display mask onto the filter. Solder the digit modules, LEDs and tactile
switches onto the front board, the LEDs sitting on the board, and screw
it onto the bosses: the digits go into the mask's openings and the LEDs
into its cells. Face onto the plate, rotary switch through both from the
back, nut on the front. Driver board into its rails, wiring, cable tied
onto the tie block. Turn the switch fully left (OFF) and press the knob
on pointing at OFF. Into the sheet under the KX155s.

### Wiring

| Signal | Wires | MobiFlight device |
|--------|-------|-------------------|
| 5 V, GND | 2 | |
| MAX7219 DIN, CLK, CS | 3 | *LED Module*, 1 module (7 of its 8 digits) |
| IDT, 0..7, CLR, VFR | 11 | 11 *Buttons* |
| OFF, SBY, TST, ON, ALT | 5 | 5 *Buttons* (the rotary switch's common to GND) |
| R, FL, ALT, ON, GND, SBY annunciators | 6 | 6 *Outputs* (LED anode through its resistor, cathode to GND) |

That is 27 wires, 25 Mega pins. On the MAX7219, digits 0..2 are the
flight level (left to right) and 3..6 the code; leave the two hidden
digits of the last module unwired.

### In X-Plane

| Control | Dataref / command |
|---------|-------------------|
| Code (4 digits, leading zeros) | `sim/cockpit2/radios/actuators/transponder_code` |
| Flight level (3 digits, leading zeros) | `sim/flightmodel2/position/pressure_altitude`, transform `Round($/100,0)`; only while the mode is ALT, blank below 0 |
| Mode, for the annunciators | `sim/cockpit2/radios/actuators/transponder_mode`: 0 OFF, 1 SBY (SBY lit), 2 ON (ON), 3 ALT (ALT and FL), 4 TST (everything lit, 888 / 8888) |
| GND annunciator | ON or ALT and `sim/flightmodel/failures/onground_any` = 1 |
| R annunciator | `sim/cockpit/radios/transponder_light` (reply, and on for the ident) |
| 0..7 | `sim/transponder/transponder_digit_0` .. `_7` (enter the code from the left, like the KT 76C) |
| CLR | `sim/transponder/transponder_CLR` |
| IDT | `sim/transponder/transponder_ident` |
| VFR | set `sim/cockpit2/radios/actuators/transponder_code` to 7000 (1200 in the US) |
| OFF, SBY, TST, ON, ALT | `sim/transponder/transponder_off`, `_standby`, `_test`, `_on`, `_alt` |

The display and annunciators are blank while the mode is OFF (use
preconditions on the mode). Check the names in DataRefTool; the real KT
76C shows dashes or nothing when the encoder's altitude is invalid,
X-Plane's pressure altitude is always valid.
