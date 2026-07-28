# Missing Link commands: Joystick

The P * commands are patched, faster versions of the STOS joystick functions (JOY, JUP, JDOWN, JLEFT, JRIGHT, FIRE) with two extras: they can be switched on and off under program control (P ON / P STOP), and they can read **both** ports — port 0 is the mouse port, port 1 is the normal joystick port. All addresses/format notes from LINK.DOC apply: these commands use interrupts, so if the program crashes while they are active, changing program area (HELP, then a different program) stops the interrupt.

## P ON
`P ON` — initialise the twin-joystick driver.

Must be called before any of the other P * commands are used. Pair it with P STOP when joystick input is no longer needed.

### Example
```stos
10 p on
20 print "press RIGHT on the joystick"
30 repeat
40 until p right(1)
50 p stop
```

**See also:** P STOP, P JOY

## P STOP
`P STOP` — turn off the twin-joystick driver.

Turns the joystick ports off. Instead of guarding every joystick check with an "enabled" variable, you can simply P STOP the driver (e.g. for a pause mode) and P ON it again later.

**See also:** P ON

## P JOY
`d = P JOY (n)` — read the joystick in port N.

- **n**: port to read (0 = mouse port, 1 = joystick port)
- **d**: returned in much the same format as the STOS command `JOY` (a direction/fire bitmask)

### Gotchas
- The community tutorial claims D is simply 1 when the stick has moved and 0 when it hasn't; the official doc says the format matches JOY. The official doc wins — see errata.md.
- Reading port 0 means the mouse can't be used at the same time.

**See also:** P UP, P DOWN, P LEFT, P RIGHT, P FIRE

## P UP
`d = P UP (n)` — check joystick-up on port N.

- **n**: port to check (0 or 1)
- **d**: true if pushed up, false otherwise

The patched equivalent of STOS `JUP`, with an extra port parameter.

### Example
```stos
10 p on : rem FIRST TURN THE PORTS ON
20 repeat
30 if p up(1) then y1=y1-4
40 if p up(0) then y0=y0-4
50 until inkey$=" "
60 p stop
```

**See also:** P DOWN, P JOY

## P DOWN
`d = P DOWN (n)` — check joystick-down on port N.

- **n**: port to check (0 or 1)
- **d**: true if pulled down, false otherwise

The patched equivalent of STOS `JDOWN`.

**See also:** P UP, P JOY

## P LEFT
`d = P LEFT (n)` — check joystick-left on port N.

- **n**: port to check (0 or 1)
- **d**: true if pushed left, false otherwise

The patched equivalent of STOS `JLEFT`.

**See also:** P RIGHT, P JOY

## P RIGHT
`d = P RIGHT (n)` — check joystick-right on port N.

- **n**: port to check (0 or 1)
- **d**: true if pushed right, false otherwise

The patched equivalent of STOS `JRIGHT`. See the P ON example.

**See also:** P LEFT, P JOY

## P FIRE
`d = P FIRE (n)` — check the fire button on port N.

- **n**: port to check (0 or 1)
- **d**: true if the fire button is pressed, false otherwise

The patched equivalent of STOS `FIRE`.

### Example
```stos
10 repeat
20 if p up(1)=true then y=y-2
30 if J=1 then p stop else p on
40 until p fire(1)
```

**See also:** P JOY, P ON
