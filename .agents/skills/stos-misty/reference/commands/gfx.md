# Misty commands: Gfx

## COL
`COL (Screen,X,Y)` — Return the colour on Screen at co-ordinates X,Y.

- **Screen**: actual screen address, e.g. `start(14)`
- **X,Y**: pixel co-ordinates

This is a new version of the POINT command with three main advantages: it is twice as fast; it can test the point of a screen at any address; and it will not crash if you test a pixel outside of the screen — you could test a pixel at 400,900 and it would NOT crash your program. This means it is not clipped, so be careful (not so much with this one, but watch what you are doing with DOT).

Like all Misty graphics commands it assumes low res. The address passed must be an actual address — use `start(bank)`, never a bare bank number. Real-number parameters are not accepted.

### Example
```text
print col(start(14),100,85)
```

### Gotchas
- Unclipped: off-screen co-ordinates do not crash but read whatever is at the computed address.
- Low res only; no real-number parameters.

**See also:** DOT, POINT

## DOT
`DOT Scr,X,Y,C` — Plot a pixel on screen at address Scr, co-ordinates X,Y in colour C.

- **Scr**: actual screen address, e.g. `logic` or `start(bank)`
- **X,Y**: pixel co-ordinates
- **C**: colour

This is a new version of PLOT, with the same advantages as COL has over POINT (faster, works on a screen at any address, and does not crash on off-screen pixels because it is unclipped). Assumes low res; addresses must be actual addresses; no real-number parameters.

### Example
```stos
10 for T=1 to 100
20 dot logic,rnd(319),rnd(199),rnd(15)
30 next t
```

### Gotchas
- Unclipped: unlike COL (which only reads), a careless DOT writes outside the screen — watch what you are doing.

**See also:** COL, PLOT

## FASTCOPY
`FASTCOPY Screen1,Screen2` — Copy Screen1 to Screen2.

- **Screen1**: actual source screen address
- **Screen2**: actual destination screen address

This is a new version of SCREEN COPY X TO Y. It is much faster than screen copy — it can copy the whole screen in under 1 vbl! It also doesn't care about the address of the screen, so you can enter `fastcopy back+160,logic`, which would crash the equivalent screen copy version. Assumes low res; addresses must be actual addresses.

### Example
```text
fastcopy start(14),logic
```

**See also:** SKOPY, KOPY, SCREEN COPY

## SKOPY
`SKOPY N,Scr1,X1,Y1,X2,Y2,Scr2,X3,X4` — Copies the screen-data from Scr1 to Scr2. X co-ordinates only on 16 boundary!

- **N**: number of bitplanes to copy — 1 to 4 uses the clipped routine, 11 to 14 uses the unclipped routine
- **Scr1**: actual source screen address
- **X1,Y1**: top-left of source block
- **X2,Y2**: bottom-right of source block
- **Scr2**: actual destination screen address
- **X3,X4**: destination co-ordinates (as named in the manual; the examples pass destination X,Y — see note below)

> [!NOTE] Unverified: the syntax line's last parameter is printed as `X4`, but every example passes a destination X and Y (e.g. `physic,160,100`), so it is almost certainly a typo for `Y3`.

This is a new version of screen copy. It has much the same advantages as FASTCOPY over screen copy, plus the ability to copy different bitplanes. Passing the bitplanes as 1 to 4 uses the clipped routine; passing them as 11 to 14 makes it unclipped. Assumes low res; addresses must be actual addresses; no real-number parameters.

### Example
```text
skopy 4,logic,0,0,32,15,physic,160,100
```

### Bitplanes
SCREEN COPY always copies 4 planes, which is slow; SKOPY exists so you can do a 1, 2 or 3 plane screen copy. Beyond speed, this lets you do separate graphics functions on separate bitplanes — e.g. draw all your sprites on plane 4 and your background on plane 1 so they won't erase each other or flicker, and you don't need a buffer to hold sprite backgrounds.

The ST's (low-res) screen is made up of four bitplanes stored as a series of 2-byte (1 word) chunks, each word controlling 16 pixels on its plane. To address any one plane of the screen, use an offset of 2 bytes from the screen's address per plane. The manual's examples:

```text
skopy 1,logic,0,0,160,100,logic+2,0,0
```
copies a 160x100 chunk of bitplane 1 to bitplane 2.

```text
skopy 1,logic,0,0,16,20,logic+4,144,100
```
copies a 16x20 chunk of bitplane 1 to bitplane 3.

```text
skopy 1,logic,0,0,160,100,logic+6,0,0
```
copies a 160x100 chunk of bitplane 1 to bitplane 4.

```text
skopy 2,logic,0,0,320,200,logic+4,0,0
```
copies the whole of bitplanes 1+2 to planes 3+4.

### Gotchas
- Documented bug (unfixed in v1.7): SKOPYing from a negative co-ordinate to the same negative co-ordinate in the X-axis copies nothing — e.g. `skopy 1,logic,-32,0,64,32,physic,-32,0` does nothing. The authors say it will be corrected in the next update.
- X co-ordinates must be on a 16-pixel boundary.
- Copying single planes between planes combines colours: a colour-1 image copied onto plane 2 shows as colour 3 where the images meet. You have to engineer your palette around this (make the combined colour match one of the parts) — or exploit it for "transparent" sprites/scrollers where overlapping colours become brighter versions of the background.

**See also:** FASTCOPY, KOPY, SCREEN COPY

## Speed benchmarks
The authors' own timings from the manual (v1.7), in VBLs:

| COMMAND | TEST | BASIC (VBL) | COMPILED (VBL) |
|---|---|---|---|
| COL | 1000 times | 28 | 5 |
| POINT | | 25 | 8 |
| DOT | 1000 times | 28 | 5 |
| PLOT | | 27 | 9 |
| FASTCOPY | 50 times | 48 | 46 |
| SCREEN COPY | | 54 | 54 |
| SKOPY 4 | 100 (160x99 block) | 31 | 27 |
| SCREEN COPY | | 41 | 37 |
| SKOPY 1 | " | 21 | 16 |
| SKOPY 2 | " | 25 | 21 |
| SKOPY 3 | " | 39 | 34 |

> [!NOTE] Unverified: SKOPY 3 is shown slower (39/34) than SKOPY 4 (31/27), which is counter-intuitive; transcribed as printed in the manual.
