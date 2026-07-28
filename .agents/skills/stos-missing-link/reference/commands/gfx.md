# Missing Link commands: gfx

## WIPE
`WIPE scr` — extremely fast CLS for a whole screen.

- **scr**: address of the screen to clear (`back`, `physic`, `logic` or a bank)

Clears the whole screen in under half the time taken by CLS. Can also be used as a quick way of clearing memory banks in multiples of 32k.

### Example
```stos
10 wipe logic
```

**See also:** WASH, CLS

## TILE
`TILE scr,gadr,img,x,y` — fill the whole screen with 16x16 tiles.

- **scr**: screen address
- **gadr**: address of the tile data
- **img**: tile image number (from 0)
- **x,y**: "virtual" co-ordinates to draw from

Fills the whole screen in about half a VBL (SCREEN COPY takes almost 2 VBLs). Scrolling the virtual co-ordinates produces the sinus-tile walls seen in many demos. Tiles are converted sprites made with the MAKE utility and must be 16x16.

### Example
```stos
10 rem> assuming the tile-data is in bank 9 <
20 logic=back
30 repeat
40 tile logic,start(9),0,x mouse,y mouse
50 screen swap : wait vbl
60 until mouse key=1
```

### Gotchas
- Image numbers start from 0: sprite 1 becomes tile 0 when converted.

**See also:** MOZAIC, make-utility.md

## MOZAIC
`MOZAIC scr,gadr,img,x1,y1,x2,y2,x,y` — fill any window of the screen with 16x16 tiles.

- **scr**: screen address
- **gadr**: address of the tile data
- **img**: tile image number (from 0)
- **x1,y1**: top-left of the window
- **x2,y2**: bottom-right of the window
- **x,y**: "virtual" co-ordinates

Like TILE but limited to a window (like LIMIT SPRITE). More general-purpose and somewhat slower than TILE, but still much faster than SCREEN COPY and SCREEN$.

### Example
```stos
10 rem> assuming the tile-data is in bank 9 <
20 logic=back
30 repeat
40 mozaic logic,start(9),0,32,16,288,176,x mouse,y mouse
50 screen swap : wait vbl
60 until mouse key=1
```

### Gotchas
- LINK.DOC describes X2,Y2 as "the bottom left" of the window; the tutorial and the parameter order confirm it is the bottom right.

**See also:** TILE, make-utility.md

## SPOT
`SPOT scr,x,y,colr` — fast replacement for PLOT.

- **scr**: screen address (any screen or memory bank)
- **x,y**: co-ordinates
- **colr**: colour to plot in (0-15 of the current palette)

### Example
```stos
10 repeat
20 spot logic,x mouse,y mouse,1
30 until mouse key=1
```

**See also:** BULLET, MANY SPOT, PLOT

## REFLECT
`REFLECT scr1,y1,y2,scr2,y3` — produce a mirror / rippling-water reflection of part of a screen.

- **scr1**: source screen address (or bank holding a picture)
- **y1**: pixel line to start the reflection at
- **y2**: pixel line to stop reflecting at
- **scr2**: destination address
- **y3**: pixel line to start drawing the reflection at

Uses only Y co-ordinates (whole pixel lines): the part of the source between lines Y1 and Y2 is mirrored upside down onto the destination from line Y3. Looping it with SCREEN SWAP gives the rippling-water effect seen in games and demos.

### Example
```stos
10 show on : limit mouse 0,0 to 303,83
20 logic=back
30 repeat
40 reflect logic,0,83,logic,84
50 screen swap : wait vbl
60 until mouse key=1
```

### Gotchas
- Make sure there are enough pixel lines at the destination for the whole captured part, or the command squashes it to fit (tutorial).

**See also:** BLIT

## WASH
`WASH scr,x1,y1,x2,y2` — very fast CLS of part of a screen.

- **scr**: screen address
- **x1,y1**: top-left of the area to clear
- **x2,y2**: bottom-right of the area to clear

The only difference from WIPE is that it clears just the given window.

### Example
```stos
10 wash logic,0,0,320,200
```

### Gotchas
- All X co-ordinates should be rounded to the nearest 16 pixels.

**See also:** WIPE, CLS

## BLIT
`BLIT scr1,x1,y1,x2,y2,scr2,x3,y3` — fast block copy, a new version of SCREEN COPY.

- **scr1**: source address
- **x1,y1,x2,y2**: top-left/bottom-right of the block to copy
- **scr2**: destination address
- **x3,y3**: destination co-ordinates

Main use is saving and restoring sprite backgrounds, but it serves for any screen copying. Much improved from its previous incarnation as SKOPY 4 in the Misty extension — existing Misty programs can convert with `change "skopy 4" to "blit"`. Like SCREEN COPY it copies a solid rectangle, so the captured block's background shows when placed over a picture (use M BLIT to merge instead).

### Example
```stos
10 blit logic,0,0,320,200,back,0,0
```

### Gotchas
- All X co-ordinates should be multiples of 16.

**See also:** M BLIT, SCREEN COPY, B WIDTH

## M BLIT
`M BLIT scr1,x1,y1,x2,y2,scr2,x3,y3` — merging block copy.

Parameters exactly the same as for BLIT, except the source image is merged onto the destination screen rather than overwriting it. Works like SCREEN$ but without storing the captured block in a variable first, and is quite a bit faster than the equivalent `screen$ (logic,0,0)=screen$ (5,0,0 to 160,100)`. Useful for placing part of a picture over another.

### Example
```stos
10 m blit logic,0,0,320,200,back,0,0
```

### Gotchas
- All X co-ordinates should be multiples of 16.
- The LINK.DOC quick-reference box prints the syntax truncated as `M BLIT scr1,x1,y1,x2,y2,scr2,x3,y` (missing the final `3`); the full form above comes from the command list.

**See also:** BLIT

## DISPLAY PC1
`DISPLAY PC1 adr,scr` — display a Degas low-resolution (.PC1) picture held in a memory bank.

- **adr**: address of the PC1 file
- **scr**: address of the destination screen

### Example
```stos
10 F$=file select$("*.PC1","Load a PC1 file",)
15 if F$="" then default : end
20 open in #1,F$ : L=lof(1) : close #1
30 erase 5 : reserve as work 5,L
40 bload F$,5
50 reserve as screen 6
60 display PC1 start(5),physic
70 display PC1 start(5),start(6)
80 wait key
90 goto 10
```

### Gotchas
- The command exists in the original v1.0 extension and is listed in the LINK.DOC quick reference, but Top Notch forgot to include its full documentation there ("an administrative oversight"); the full write-up only appears in UPDATE.DOC. It is NOT a registration-only command.

**See also:** BLIT, DLOAD
