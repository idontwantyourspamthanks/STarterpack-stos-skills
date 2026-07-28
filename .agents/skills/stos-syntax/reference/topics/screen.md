# Screens

STOS Basic keeps up to three screens in memory and exposes each as a reserved variable: [`PHYSIC`](../commands/screen.md) is the screen the monitor displays, [`LOGIC`](../commands/screen.md) is the screen that text and graphics commands draw onto, and [`BACK`](../commands/screen.md) is the sprite background used to repair holes left by moving sprites. Normally `PHYSIC` and `LOGIC` share one buffer; nearly every technique in this chapter — double-buffering, page-flipping, scrolling, fades — comes from prising them apart. Per-command detail lives in [Screen commands](../commands/screen.md); this guide covers the concepts.

## The three screens and their addresses

Assigning an address (or a bank number) to `PHYSIC` instantly switches the display to that screen. The ST's hardware requires a screen address to be a multiple of 256 bytes, but `RESERVE AS SCREEN` aligns its banks automatically, so a bank number can be passed wherever a screen address is expected.

```stos
10 reserve as screen 5
20 physic=5
30 cls
```

The [`DEFAULT`](../commands/screen.md) *function* recovers each original address after a program has shuffled the screens (`physic=default physic`, etc.; do not confuse it with the `DEFAULT` instruction).

## Double-buffering with SCREEN SWAP

Drawing straight onto the visible screen produces flicker — the viewer watches each line go down. The fix is to draw on a hidden screen and reveal the finished frame in one step. Point `LOGIC` at a second screen, do all the drawing there, then call [`SCREEN SWAP`](../commands/screen.md) followed by [`WAIT VBL`](../commands/screen.md) so the swap lands neatly on the next vertical blank. The manual's moving-triangle demo:

```stos
10 cls
20 X1=50:Y1=50:X2=75:Y2=100:X3=25:Y3=100:logic=back
40 for I=0 to 244 step 8
50 ink 0:polygon X1+I-16,Y1 to X2-I-16,Y2 to X3+I-16,Y3 to X1+I-16,Y1
60 ink 1:polygon X1+I,Y1 to X2+I,Y2 to X3+I,Y3 to X1+I,Y1
70 screen swap : wait vbl
80 next I
```

> [!NOTE] Unverified: the manual's line 60 (the `ink 0` erase step above) is reconstructed. The scan reads `polygon X1+I-16,Y1 to X2+16,Y2 to X3+16,Y3 to X1+I-16,Y1`, dropping `-I-` from the second and third corners. Restored to `X2-I-16`/`X3+I-16` from the pattern of the original line 60 and the manual's note that the erased triangle sits two steps back.

Because the background screen is borrowed as the drawing surface, sprites will interfere with the animation while it runs.

## Reserving and loading screens

[`RESERVE AS SCREEN`](../commands/screen.md) allocates a 32768-byte bank for temporary use (wiped on each run); [`RESERVE AS DATASCREEN`](../commands/screen.md) allocates a permanent bank that is saved with the program. [`LOAD`](../commands/screen.md) reads a picture into a bank or address and recognises the extensions `.NEO` (Neochrome) and `.PI1`/`.PI2`/`.PI3` (Degas). [`GET PALETTE`](../commands/screen.md) copies a bank's colour registers onto the live display:

```stos
10 reserve as screen 5
20 load "\stos\pic.pi1",5
30 physic=5:wait key
40 get palette(5):wait key
```

## Copying blocks with SCREEN COPY

[`SCREEN COPY`](../commands/screen.md) moves rectangles between screens. The whole-screen form is `screen copy scr1 to scr2`; the rectangle form is `screen copy scr1,x1,y1,x2,y2 to scr2,x3,y3`. Coordinates may be negative — anything off-screen is clipped, never crashed — and X coordinates are rounded down to a multiple of 16. Copy a title into both `LOGIC` and `BACK` so the mouse sprite cannot eat it away:

```stos
10 cls : mode 0
20 screen copy 10 to logic:screen copy 10 to back
30 wait key
```

## Capturing blocks as strings: SCREEN$

[`SCREEN$`](../commands/screen.md) has two forms. As a function, `screen$(scrn,x1,y1 to x2,y2)` grabs a rectangle into a string; as an instruction, `screen$(scrn,x,y)=a$` blits a previously grabbed string back onto a screen. The payoff is **tile-based maps**: grab each block once into an array of strings, then rebuild any screen from a compact list of indices — far cheaper than storing whole pictures. The manual ships a *Map Definer* accessory for designing them.

```stos
10 S$=screen$(physic,0,0 to 100,100)
20 for y=0 to 3:for x=0 to 6
30 screen$(physic,50*x,50*y)=S$
40 next x:next y
```

## Magnifying and shrinking: ZOOM and REDUCE

[`ZOOM`](../commands/screen.md) enlarges a source rectangle into a larger destination; [`REDUCE`](../commands/screen.md) compresses a whole screen into a small box. Both default to drawing through `BACK` so the mouse and sprites are undisturbed, and both accept an optional explicit destination screen. Given a picture in bank 5, this loop tiles four shrunken copies across the screen:

```stos
10 for Y=0 to 1
20 for X=0 to 1
30 reduce 5 to X*160,Y*95,(X+1)*159+1,(Y+1)*96
40 next X
50 next Y
```

**Page-flipping animation.** Pre-render each frame into its own reserved screen, then cycle `PHYSIC` through the banks — one bank per vertical blank. The viewer reads the sequence as smooth motion:

```stos
10 for i=6 to 11
20 physic=i
30 wait vbl:wait 5
40 next i
```

## Scrolling with DEF SCROLL and SCROLL

[`DEF SCROLL`](../commands/screen.md) defines up to 16 scrolling zones: `def scroll n,x1,y1 to x2,y2,dx,dy`. [`SCROLL`](../commands/screen.md) then executes zone *n* once. Positive `dx`/`dy` scroll right/down, negative left/up. Because `SCREEN COPY` rounds X to multiples of 16, horizontal scrolls usually step by 16.

```stos
10 def scroll 1,0,0 to 320,200,1,0
20 scroll 1:goto 20
```

Stacking several zones with different `dy` values produces parallax — the manual's demo runs seven horizontal bands at -1 to -6 pixels per step. To make a scroll wrap, use `SCREEN COPY` to copy the strip that is about to leave the zone back to the opposite edge before each `SCROLL`.

## Synchronising with the display: WAIT VBL and SYNCHRO

The ST refreshes the screen every 1/50 s (1/70 in mono), and sprite movement and `PHYSIC` changes only take effect at that vertical blank (the **VBL**). [`WAIT VBL`](../commands/screen.md) blocks until the next blank, so it belongs after every `SCREEN SWAP` or sprite update — if a screen-using program misbehaves, a missing `WAIT VBL` is the usual culprit.

When a sprite must track a scrolling background, the automatic 50 Hz sprite interrupt drifts out of step with the scroll. [`SYNCHRO OFF`](../commands/screen.md) disables the auto-interrupt; a bare `SYNCHRO` runs exactly one movement step on demand; `SYNCHRO ON` restores normal service. The scroll loop then moves the sprite in lockstep with the background:

```stos
90 synchro off:move on:def scroll 1,80,0 to 240,200,0,-2
140 for Y=0 to 199 step 2
150 screen copy back,80,Y,240,Y+2 to logic,80,198
160 scroll 1:wait vbl:synchro
170 next Y
```

## Packing and unpacking screens

The *Compact* accessory (loaded with `accload "compact.acb"`) compresses Neochrome or Degas screens to a fraction of their size by trying several strategies and keeping the smallest. [`UNPACK`](../commands/screen.md) expands a packed bank back into a screen (`unpack 5,back` restores bank 5 into the sprite background); the [`PACK`](../commands/screen.md) *function* compresses programmatically and returns the packed length:

```stos
10 reserve as screen 5
20 reserve as screen 6
30 load "\stos\pic.pi1",5
40 L=pack(5,6)
50 reserve as data 7,L
60 copy start(6),start(6)+L to start(7)
70 save "title.mbk"
```

## Fades and appearances: APPEAR and FADE

[`APPEAR`](../commands/screen.md) fades a picture from bank/address *x* into the current screen; the optional *y* (1-79) picks the transition, where 1-72 end in an exact copy and 73-79 leave a slightly altered image.

```stos
20 reserve as screen 15
40 if mode=0 then load "\stos\pic.pi1",15 else load "\stos\pic.pi3",15
60 input "screen effect";X
90 get palette(15)
100 appear 15,X
```

[`FADE`](../commands/screen.md) blends colours during interrupt, so follow it with a `WAIT` (roughly seven times the fade speed) before touching the palette again. `FADE speed` fades to black; `FADE speed TO sbank` blends to another screen's palette; `FADE speed,col0,col1,...` sets individual colours, with an empty slot leaving that colour unchanged:

```stos
10 mode 0:print "bye bye...":fade 3:wait 7*3
20 cls:print "here I am again!":fade 3,,$777,$700
```

## The function-key window: KEY ON / KEY OFF

[`KEY ON`](../commands/screen.md) displays the function-key window at the top of the low-resolution screen; [`KEY OFF`](../commands/screen.md) removes it and frees the space. The function keys themselves keep working when the window is hidden.
