# Control commands: Parallel port

Read joystick adaptors that plug into the ST's parallel (printer) port, as used by games like Gauntlet II for 4-player play. Requires the hardware adaptor. Because one chip in the ST controls the printer, sound chip and disc drive, reading the parallel port deactivates the floppy disc drive (hard drives are unaffected) — bracket reads with PARA ON / PARA OFF. Source: CONTREG.DOC (V3.6b); CONTROL35.DOC (V3.5a) is identical for all of these commands (the 3.5a doc adds: "Read the parallel instrucion VERY carefully").

## PARALLEL
`INTEGER=parallel(PORTNUMBER)` — read the parallel-port joystick as a bitmask.

- **PORTNUMBER**: adaptor port to read (0-1; doc body writes `J=parallel(0-1)`).

Returns the joystick state with the following bits set to 1 when that action is being performed:

- bit 0: Up
- bit 1: Down
- bit 2: Left
- bit 3: Right
- bit 4: Fire

### Example
```stos
10 para on : rem save sound chip register
1000 p=parallel(0) : rem this will deactivate discdrive
2000 para off : rem we can now use the floppy drive again
```

### Gotchas
- Using this command deactivates the floppy disc drive, because a single chip controls printer, sound chip and disc drive. Hard drives are unaffected. PARA ON saves the sound chip register state before the read turns the drive off; PARA OFF restores it.
- Use PARA OFF whenever you want the floppy drive again. If all else fails, the doc says typing `boom` or `shoot` also reinitialises the disc drive.
- The disc drive state is deliberately not saved/restored inside PARALLEL itself, as that would further slow down an already slow process.
- With STOS Maestro samples: turn the keyboard click off and use `sound init` first, e.g. `10 click off:sound init:para on`.

**See also:** PARA ON, PARA OFF, PARA FIRE

## PARA ON
`para on` — initialise the parallel port adaptor.

Stores the current state of the sound chip register (i.e. before the disc drive is turned off by the PARALLEL command) so PARA OFF can restore it later.

**See also:** PARA OFF, PARALLEL

## PARA OFF
`para off` — deactivate the parallel port adaptor.

Restores the sound chip register to the value saved by PARA ON, thus restoring the floppy disc drive.

**See also:** PARA ON, PARALLEL

## PARA LEFT
`INTEGER=para left(PORTNUMBER)` — true if the parallel-port joystick is being moved left.

- **PORTNUMBER**: adaptor port to check (0-1).

**See also:** PARA RIGHT, PARA UP, PARA DOWN, PARALLEL

## PARA RIGHT
`INTEGER=para right(PORTNUMBER)` — true if the parallel-port joystick is being moved right.

- **PORTNUMBER**: adaptor port to check (0-1).

**See also:** PARA LEFT, PARA UP, PARA DOWN, PARALLEL

## PARA UP
`INTEGER=para up(PORTNUMBER)` — true if the parallel-port joystick is being moved up.

- **PORTNUMBER**: adaptor port to check (0-1).

**See also:** PARA DOWN, PARA LEFT, PARA RIGHT, PARALLEL

## PARA DOWN
`INTEGER=para down(PORTNUMBER)` — true if the parallel-port joystick is being moved down.

- **PORTNUMBER**: adaptor port to check (0-1).

**See also:** PARA UP, PARA LEFT, PARA RIGHT, PARALLEL

## PARA FIRE
`INTEGER=para fire(PORTNUMBER)` — true if the parallel-port joystick fire button is currently pressed.

- **PORTNUMBER**: adaptor port to check (0-1).

**See also:** PARALLEL, PARA UP, PARA DOWN
