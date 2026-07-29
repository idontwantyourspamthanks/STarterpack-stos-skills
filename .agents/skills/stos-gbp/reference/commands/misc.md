# GBP extension commands: misc

## LIGHTS ON
`LIGHTS ON` — turn on the drive lights for disk drives A and B.

Allows demo-style effects where the drive lights pulse to music (as seen at the start of Crack Art).

**See also:** LIGHTS OFF

## LIGHTS OFF
`LIGHTS OFF` — turn off the drive lights for disk drives A and B.

The opposite of LIGHTS ON. Used together they can pulse the drive lights in time with music.

### Example
Pulse the drive lights to a MAD MAX music file loaded in bank 10:
```stos
10 dreg(0)=1 : call 10 : rem * Call music Init
20 loke $4d2,start(10)+8 : rem * Install on VBL
30 if psg(8)>12 then lights on : else lights off
40 wait vbl : goto 30
50 :
60 loke $4d2,0 : bell : rem * Turn music off
```
With normal STOS music instead, replace line 10 with `music 1`.

### Gotchas
- The example uses `dreg`/`call`/`loke` and installs the music on the VBL at `$4d2`; it needs a MAD MAX music file in bank 10 to work as listed.

**See also:** LIGHTS ON

## PREADY
`X=PREADY` — report whether the printer on the parallel port is on-line.

- **X**: TRUE (-1) if the printer is on-line and ready to receive data, FALSE (0) otherwise.

### Example
```stos
10 X=pready
20 if X then bell
30 goto 10
```
Sounds the bell repeatedly while the printer is on-line.

## EVEN
`X=EVEN(NUM)` — test whether a number is even.

- **NUM**: value to test.
- **X**: TRUE (-1) if NUM is even, FALSE (0) if NUM is odd.

### Example
```stos
10 input A
20 if even(A) then bell : else boom
```

## SETPRT
`X=SETPRT(VAR)` — set (or read) the printer configuration.

- **VAR**: bit vector of printer options; pass -1 to read the current settings.
- **X**: the doc shows the result assigned to a variable.

Bit meanings (bit 0 is the far right of the binary value):

- **Bit 0**: 0 = Dot Matrix, 1 = Daisy Wheel
- **Bit 1**: 0 = Monochrome, 1 = Colour
- **Bit 2**: 0 = Atari Printer, 1 = Epson or Compatible
- **Bit 3**: 0 = Test Mode (DRAFT), 1 = Print Mode (NLQ/LQ)
- **Bit 4**: 0 = Centronics Port, 1 = RS-232 Port
- **Bit 5**: 0 = Continuous Sheet, 1 = Single Sheet
- **Bits 6-14**: reserved
- **Bit 15**: always 0

### Example
Set printer to dot matrix, monochrome, Epson-compatible, draft, Centronics, continuous sheet:
```text
X=setprt(%000100)
```
The binary value can be replaced by its decimal equivalent, so `X=setprt(4)` is identical.

### Gotchas
- Doc/source mismatch: the manual documents SETPRT as a function returning a value (`X=SETPRT(VAR)`, readable by passing -1), but the COMPILER.S parameter table defines `setprt` as a procedure with no return value. See errata.

## SPECIAL KEY
`X=SPECIAL KEY(I)` — set or read the status of the special keys (Shifts, Alt, Ctrl, Caps).

- **I**: positive integer to set the status; -1 to read it.
- **X**: 8-bit status value; a set bit means the button is active.

Bit meanings:

- **Bit 0**: Right Shift key
- **Bit 1**: Left Shift key
- **Bit 2**: Control (CTRL) key
- **Bit 3**: Alternate (ALT) key
- **Bit 4**: Caps lock
- **Bit 5**: Right mouse button (CLR/HOME)
- **Bit 6**: Left mouse button (INSERT)
- **Bit 7**: unused

### Example
```stos
10 print "Current Status :";special key(-1)
```

## HCOPY
`HCOPY X` — enable or disable the system hardcopy (ALT & HELP).

- **X**: 1 turns the ALT & HELP hardcopy on, 0 turns it off.

Stops players interrupting games/demos with the system hardcopy screen dump.

### Example
```stos
10 hcopy 0 : rem Turn HARDCOPY off
20 wait key
30 hcopy 1 : rem Turn HARDCOPY on
```

## PERCENT
`X=PERCENT(NUM,TOTAL)` — (inferred) return NUM as a percentage of TOTAL.

> [!NOTE] Unverified: present in the binary's token table but not described in any doc.

- **NUM**: part value (inferred).
- **TOTAL**: whole value (inferred).
- **X**: percentage (inferred).

(Inferred from the COMPILER.S source: it takes two integer parameters and computes how many times TOTAL fits into 100*NUM, rounding up — i.e. a percentage-of-total function. Syntax and behaviour are not confirmed by any documentation.)
