# Blitter extension commands: Screen clear and copy

## blit cls
`BLIT CLS screen` — Clear a screen super-fast using the blitter.
`BLIT CLS screen,op` — Fill a screen with 0s or 1s.

- **screen**: a screen address, such as the physical screen or a memory bank reserved as a datascreen
- **op**: fill value — 0 fills the area of memory with 0s (the first colour, usually black); 1 fills it with 1s (the last colour of your palette)

**See also:** blit copy

## blit copy
`BLIT COPY source,destination` — Straight screen copy.
`BLIT COPY source,x1,y1,x2,y2,destination,x,y` — Copy a region.
`BLIT COPY source,x1,y1,x2,y2,destination,x,y,op` — Copy a region with a boolean operation.

- **source, destination**: screen addresses or memory banks
- **x1,y1,x2,y2**: source coordinates — copy from x1,y1 to x2,y2
- **x,y**: position on the destination to plonk it down at
- **op**: optional, 1 to 14; sets the type of copying to do (table below)

The blitter can throw areas of screen memory around rather like the SCREEN COPY command, but quicker — and it runs independent of the main CPU, so your program can get on with other work while it copies.

The op parameter is boolean algebra and enables weird and wonderful types of copying:

- 1 = source AND destination
- 2 = source AND NOT destination
- 3 = source (a straight copy)
- 4 = NOT source AND destination
- 5 = destination
- 6 = source XOR destination
- 7 = source OR destination
- 8 = NOT source AND NOT destination
- 9 = NOT source XOR destination
- 10 = NOT destination
- 11 = source OR NOT destination
- 12 = NOT source
- 13 = NOT source OR destination
- 14 = NOT source OR NOT destination

XOR does a transparent copy, rather like paste from a paint package. AND changes the colours about. Experiment — all sorts of swishy effects are possible.

### Gotchas
- As usual with STOS, the x1 and x2 coordinates get rounded to the nearest value of 16 — you can place the copy anywhere, though.

**See also:** blit cls, blit op, blit busy
