# Control commands: Zones

Megazones are the Control extension's replacement for STOS screen zones for mouse/joystick collision detection: where STOS offers 128 zones, megazones allow up to 65536. Zones live in memory you reserve yourself (a memory bank or a string). Source: CONTREG.DOC (V3.6b); CONTROL35.DOC (V3.5a) is identical for all of these commands.

## INIT MEGAZONE
`init megazone STARTZONE,NUMBEROFZONES` — set up replacement zones.

- **STARTZONE**: start address of the reserved zone memory.
- **NUMBEROFZONES**: how many zones to set up (up to 65536).

You must reserve space for your zones using either a memory bank or a string and put the start address into STARTZONE. The space needed is `space = 8 + NUMBEROFZONES * 8` bytes.

### Gotchas
- The doc body spells the command `init mega zone` (three words); the command listing uses `init megazone`. The listing form is the one shown above.

**See also:** SET MEGAZONE, TEST MEGAZONE, RANGE MEGAZONE

## SET MEGAZONE
`set megazone STARTZONE,ZOMENUMBER,X1,Y1,X2,Y2` — define a rectangular zone.

- **STARTZONE**: start address of the zone memory (as passed to INIT MEGAZONE).
- **ZOMENUMBER**: which zone to define (spelled ZONENUMBER in the doc body).
- **X1,Y1** to **X2,Y2**: corner coordinates of the rectangle.

Creates rectangular zone ZONENUMBER with coordinates X1,Y1 to X2,Y2.

### Gotchas
- The command listing spells the second parameter `ZOMENUMBER` — a typo for ZONENUMBER, which is how the doc body spells it.

**See also:** INIT MEGAZONE, TEST MEGAZONE

## RANGE MEGAZONE
`range megazone STARTZONE,LOWERRANGE,UPPERRANGE` — restrict TEST MEGAZONE to a subset of zones.

- **STARTZONE**: start address of the zone memory.
- **LOWERRANGE**, **UPPERRANGE**: first and last zone numbers to test (the doc body calls them ZONE_S and ZONE_E).

Limits subsequent TEST MEGAZONE calls to a subset of the total number of zones. This means you can create control panels with overlapping zones and just test the few you are interested in. To reset testing to the default range (all zones):

```text
range megazone START_ADDRESS,1,NUMBEROFZONES
```

**See also:** TEST MEGAZONE, SET MEGAZONE

## TEST MEGAZONE
`Z=test megazone (STARTZONE,X,Y)` — find the first zone containing the point X,Y.

- **STARTZONE**: start address of the zone memory.
- **X,Y**: coordinates to test (e.g. mouse position).
- **Z**: the first zone which contains coordinates X and Y (honouring the range set by RANGE MEGAZONE).

### Gotchas
- The doc body spells the command `test negazone` — a typo for `test megazone`. The command listing has it right.
- Only zones within the current RANGE MEGAZONE range are tested; reset with `range megazone STARTZONE,1,NUMBEROFZONES` to test all zones.

**See also:** RANGE MEGAZONE, SET MEGAZONE, INIT MEGAZONE
