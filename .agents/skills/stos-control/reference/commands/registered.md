# Control commands: registered

The 20 commands below are listed in CONTREG.DOC (V3.6b) under "New Commands for registered users". The V3.5a shareware manual already documents most of them (TURBOCOPY through MAP ADDRESS) but states they are "only available in their interpreted form — you must register to receive the compiler equivalents and example programs of their use"; ENABLE BLIT, MADD and DAC PLACE are new in V3.6b. MANY IMAGE is not in the doc's command listing but is fully documented in its body.

## MANY IMAGE
`many image SCREEN_ADDRESS,BANK_ADDRESS,FIRST_XCOORD_ADDRESS,FIRST_YCOORD_ADDRESS,FIRST_IMAGE_NUMBER_ADDRESS,NUMBER_TO_PLOT` — plot many images in one call.

- **SCREEN_ADDRESS**: destination screen.
- **BANK_ADDRESS**: image bank (built with MAKER).
- **FIRST_XCOORD_ADDRESS**, **FIRST_YCOORD_ADDRESS**, **FIRST_IMAGE_NUMBER_ADDRESS**: addresses of arrays holding each image's X, Y and image number.
- **NUMBER_TO_PLOT**: how many images to draw.

All images are plotted in transparent mode. If bit 31 of an image number is set, that image is flipped vertically when plotted. An image number of 0 (excluding bit 31) skips that image.

### Example
```stos
10 mode 0:key off:curs off:hide:flash off
15 dim x(10),y(10),i(10)
20 load "font.mbk",10:st=start(10)
30 for loop=1 to 10
40 x(loop)=loop*32:y(loop)=0:i(loop)=loop
50 next loop
60 many image logic,st,varptr(x(1)),varptr(y(1)),varptr(i(1)),10
```

### Gotchas
- **Registered version only.**
- Not in the doc's command listing; documented in the body.
- X coordinates are rounded to the nearest multiple of 16.

**See also:** IMAGE PUT, IMAGE MCOLLIDE, make-utility.md

## TURBOCOPY
`turbocopy SOURCE_SCREEN,DEST_SCREEN` — copy a normal 32K screen to another screen at very high speed.

- **SOURCE_SCREEN**: address of the screen to copy from
- **DEST_SCREEN**: address of the screen to copy to

Faster than any other available extension command at the time of writing — over 51 screens a second. If the blitter has been switched on with ENABLE BLIT, TURBOCOPY uses it automatically.

### Gotchas
- **Registered version only.**
- Normal 32K screens only.

**See also:** BIGCOPY, BIGCLS, ENABLE BLIT

## BIGCLS
`bigcls SOURCE_SCREEN,X1,Y1,X2,Y2` — clear an area of the screen, including large STE scrollable screens.

- **SOURCE_SCREEN**: screen address
- **X1, Y1, X2, Y2**: area to clear

### Gotchas
- **Registered version only.**
- You cannot clear an area wider than 320 pixels in one go — unless the blitter has been turned on with ENABLE BLIT, in which case you can clear areas as wide as you like.
- All X coordinates are clipped to the nearest multiple of 16.

**See also:** BIGCOPY, TURBOCOPY, ENABLE BLIT, SCREENSIZE

## BIGCOPY
`bigcopy SOURCE_SCREEN,X1,Y1,X2,Y2,DEST_SCREEN,XDEST,YDEST` — copy an area from one large screen to another in replace mode.
`bigcopy SOURCE_SCREEN,X1,Y1,X2,Y2,DEST_SCREEN,XDEST,YDEST,MODE` — as above, with an explicit copy mode.

- **SOURCE_SCREEN / DEST_SCREEN**: screen addresses
- **X1, Y1, X2, Y2**: source area
- **XDEST, YDEST**: destination coordinates
- **MODE**: 0 = replace, 1 = merge (V3.6b form only)

### Gotchas
- **Registered version only.**
- You cannot copy an area wider than 320 pixels in one go — unless the blitter has been turned on with ENABLE BLIT, in which case you can copy areas as wide as you like.
- All X coordinates are clipped to the nearest multiple of 16.
- Replace mode is the only version that utilises the blitter.
- The MODE form is documented only in V3.6b; the V3.5a shareware manual describes the replace-only form.

**See also:** BIGCLS, TURBOCOPY, ENABLE BLIT

## INSIDE
`INTEGER=inside(X,Y,X1,Y1,X2,Y2)` — test whether a point is inside a rectangle, and if not, which edge it is off.

- **X, Y**: point to test
- **X1, Y1, X2, Y2**: rectangle

Returns true if X,Y is inside the rectangle X1,Y1 to X2,Y2; otherwise 1 if off the left margin, 2 if off the top, 3 if off the right margin and 4 if off the bottom. Particularly useful for checking when objects have moved off the screen.

### Gotchas
- **Registered version only.**
- Note the asymmetry: "inside" returns true (not 0), while the four outside cases return 1–4 — test carefully rather than assuming a plain 0/1 result.

**See also:** IMAGE COLLIDE, IMAGE MCOLLIDE

## IMAGE COLLIDE
`INTEGER=image collide(X1,Y1,BANK1_ADDRESS,IMAGE1_NUMBER,X2,Y2,BANK2_ADDRESS,IMAGE2_NUMBER)` — pixel-perfect collision check between two banked images.

- **X1, Y1**: coordinates of 1st image
- **BANK1_ADDRESS**: address of bank which holds image 1
- **IMAGE1_NUMBER**: which image number to check
- **X2, Y2**: coordinates of 2nd image
- **BANK2_ADDRESS**: address of bank which holds image 2
- **IMAGE2_NUMBER**: which image number to check

Returns 1 if the images collide, 0 if they don't. Much more accurate than the intersection-of-rectangles method used by STOS' own `collide` command.

### Gotchas
- **Registered version only.**
- If bit 31 of an image number is set, that image is taken to be vertically flipped (as in MANY IMAGE).
- Bank parameters take actual addresses via `start(bank)`; the banks are MAKER-utility image banks.

**See also:** IMAGE MCOLLIDE, IMAGE PUT, make-utility.md

## IMAGE MCOLLIDE
`INTEGER=image mcollide(X1,Y1,BANK1_ADDRESS,ADDRESS_X0,ADDRESS_Y0,BANK2_ADDRESS,ADDRESS_I0,NUMBER)` — quick collision check of one image against many others.
`INTEGER=image mcollide(X1,Y1,BANK1_ADDRESS,IMAGE1_NUMBER,X2,Y2,STRING)` — collision check between an image and a string in `screen$` format.

- **X1, Y1**: coordinates of 1st image
- **BANK1_ADDRESS**: address of bank which holds the 1st image
- **ADDRESS_X0**: address of the 1st x coordinate of the next image to check
- **ADDRESS_Y0**: address of the 1st y coordinate of the next image to check
- **BANK2_ADDRESS**: address of the images to check
- **ADDRESS_I0**: address of the 1st image number to check
- **NUMBER**: the number of images to check (1-32)

The multi-image form performs a quick check by intersecting rectangles and returns a bit pattern indicating which images a collision occurred with; follow up with IMAGE COLLIDE for an exact (pixel-perfect) result. The bank addresses are only needed to get the width and height of the images concerned. If any image number is 0 (excluding bit 31) that image is skipped — so dead "spaceships" are easily ignored.

The string form checks an image against a `screen$`-format string — very useful for games whose backgrounds are not built out of blocks (pinball games, single-screen racing games); colour 0 is always taken as transparent.

### Example
```stos
10 v=image mcollide(X,Y,start(10),varptr(ax(0)),varptr(ay(0)),start(11),varptr(ai(0)),10)
```
(player at X,Y with image in bank 10; 10 aliens with x/y locations in `ax()`/`ay()` and image numbers in `ai()`, images in bank 11 — if the returned value is `%1001` a collision occurred between the player and aliens 0 and 3.)

### Gotchas
- **Registered version only.**
- The multi-image check is rectangle-intersection only — confirm hits with IMAGE COLLIDE.
- Maximum 32 images per call.

**See also:** IMAGE COLLIDE, MADD, make-utility.md

## JAGJOY
`INTEGER=jagjoy(0-1)` — read an Atari Jaguar joypad connected (via adaptor) to an STE or Falcon.

- **0-1**: pad number

The returned value is a bit pattern with the appropriate bit set for each action being performed:

```text
Action  bit number
up      0
down    1
left    2
right   3
A       4
B       5
C       6
pause   7
option  8
0       9
8       10
5       11
2       12
#       13
9       14
6       15
3       16
*       17
7       18
4       19
1       20
```

(Routine thanks to Anthony Jaques.)

### Gotchas
- **Registered version only.**
- STE or Falcon hardware only.
- The shareware manual opens with a warning that the author is not responsible for any damage to your ST resulting from using the extension, and that the parallel-port instructions must be read VERY carefully — treat hardware-adaptor commands like this one with the same care.

**See also:** SCREEN OFFSET

## SCREEN OFFSET
`screen offset SCREEN_ADDRESS,X,Y,0-1` — switch the STE's hardware scrolling on/off and set the scroll offset, enabling smooth scrolling.

- **SCREEN_ADDRESS**: screen address, as normal
- **X, Y**: offset values
- **0-1**: STATUS — 0 turns hardware scrolling off, 1 turns it on

This command exists because there is a bug in the STE extension which causes the screen to jerk at X offsets of 1.

### Gotchas
- **Registered version only.**
- If you are using the Ninja Tracker extension you must turn hardware scrolling on *before* using the `track play` command.

**See also:** SCREENSIZE, HSCROLL, IMAGE PUT

## SET MAP
`set map X,Y,NUMBER_OF_TILES_X,NUMBER_OF_TILES_Y,MODE` — initialise the map generator used by IMAGE MAP.

- **X, Y**: coordinates on the screen where the map is to be drawn
- **NUMBER_OF_TILES_X**: number of tiles to be drawn horizontally on the screen
- **NUMBER_OF_TILES_Y**: number of tiles to be drawn vertically
- **MODE**: 0 = replace, 1 = transparent

If bit 2 of MODE is set the map section is drawn without checks for clipping; this makes a big impact when using small blocks and can squeeze an extra 2 or 3 screens per second out of the routine. (The same bit can be set on the MODE of QUICK SCREEN$ and IMAGE PUT, but it only really makes a speed difference on IMAGE MAP.)

### Gotchas
- **Registered version only.**
- The no-clipping bit (bit 2) and the performance notes are documented only in V3.6b; V3.5a documents MODE as plain 0/1.

**See also:** IMAGE MAP, MAP READ, MAP WRITE, MAP W, MAP H, MAP ADDRESS

## IMAGE MAP
`image map SCREEN_ADDRESS,IMAGE_BANK_ADDRESS,MAP_ADDRESS,X,Y` — draw a segment of a map on the screen.
`image map SCREEN_ADDRESS,IMAGE_BANK_ADDRESS,MAP_ADDRESS,X,Y,VALUE` — as above, adding VALUE to every tile value read from the map.

- **SCREEN_ADDRESS, IMAGE_BANK_ADDRESS**: as normal (pass `start(bank)` for the image bank)
- **MAP_ADDRESS**: start location of the map data in memory
- **X, Y**: coordinates within the map to start drawing from — NOT screen coordinates; the top left-hand corner of the map has coordinates 1,1
- **VALUE**: value added to all values read from the map; primarily used to draw scenery maps (see mapper.doc)

Map banks are made with the STOS Mapper tool (see MAPPER.DOC). If the value 0 is read from any map location, no tile is drawn there. Set up the drawing area and mode first with SET MAP.

### Gotchas
- **Registered version only.**
- V3.5a documents the syntax with a MODE parameter (`image map SCREEN_ADDRESS,IMAGE_BANK_ADDRESS,MAP_ADDRESS,X,Y,MODE`, 0 = replace / 1 = transparent); V3.6b moves the mode to SET MAP and replaces the parameter with the optional VALUE. The KB follows V3.6b.

**See also:** SET MAP, MAP READ, MAP WRITE, MAP W, MAP H, MAP ADDRESS, IMAGE PUT, make-utility.md

## MAP READ
`INTEGER=map read (MAP_ADDRESS,X,Y)` — get the value of a tile within a map.

- **MAP_ADDRESS**: start address of the map data
- **X, Y**: coordinates within the map

### Gotchas
- **Registered version only.**

**See also:** MAP WRITE, IMAGE MAP, SET MAP

## MAP WRITE
`map write MAP_ADDRESS,X,Y,VALUE` — write a tile value into a map.

- **MAP_ADDRESS**: start address of the map data
- **X, Y**: coordinates within the map
- **VALUE**: tile value to write

### Gotchas
- **Registered version only.**

**See also:** MAP READ, IMAGE MAP, SET MAP

## IMAGE OFFSET
`image offset X,Y` — add an X,Y offset to all images when using the MANY IMAGE command.

- **X, Y**: offset values

### Gotchas
- **Registered version only.**

**See also:** IMAGE PUT

## CYLINDER
`cylinder SOURCE_SCREEN,Y_SOURCE,DEST_SCREEN,Y_DEST,SIZE` — map part of a screen onto a horizontal cylinder which you can scroll up the screen.

- **SOURCE_SCREEN**: screen to take the graphics from
- **Y_SOURCE**: starting y coordinate on the source screen
- **DEST_SCREEN**: screen to draw the cylinder on
- **Y_DEST**: starting y coordinate on the destination screen
- **SIZE**: the height of the cylinder is SIZE*SIZE

### Gotchas
- **Registered version only.**
- The V3.5a listing mistypes the first parameter as `SOURCE_SCRN`.

**See also:** HSCROLL, SCREEN OFFSET

## MAP W
`=map w (MAP_ADDRESS)` — return the width of a given map in tiles.

- **MAP_ADDRESS**: start address of the map data

### Gotchas
- **Registered version only.**
- V3.5a names this command `map width`; V3.6b renames it `map w`.

**See also:** MAP H, MAP ADDRESS, IMAGE MAP

## MAP H
`=map h (MAP_ADDRESS)` — return the height of a given map in tiles.

- **MAP_ADDRESS**: start address of the map data

### Gotchas
- **Registered version only.**
- V3.5a names this command `map height`; V3.6b renames it `map h`.

**See also:** MAP W, MAP ADDRESS, IMAGE MAP

## MAP ADDRESS
`=map address (MAP_ADDRESS,NUMBER)` — give the address of any given layer within a map.

- **MAP_ADDRESS**: start address of the map data
- **NUMBER**: layer number — 1 = data layer, 2 = scenery layer, 3 = info layer (see mapper.doc for details)

### Gotchas
- **Registered version only.**

**See also:** MAP W, MAP H, IMAGE MAP, MAP READ, MAP WRITE

## ENABLE BLIT
`=enable blit(0-1)` — tell the extension to use or ignore the STE blitter; returns the blitter status.

- **0-1**: 1 = utilise the blitter, 0 = ignore the blitter (default)

Returns 0 (off) or 1 (on); if your computer has no blitter the returned value is always 0. When the blitter is activated, BIGCOPY automatically uses it, as do BIGCLS and TURBOCOPY; QUICK SCREEN$, IMAGE PUT and IMAGE MAP use it only in replace mode.

### Gotchas
- **Registered version only.** (New in V3.6b; absent from the V3.5a manual entirely.)
- The blitter is utilised in hog mode, which means any interrupt routines will probably misbehave — experimentation is the order of the day.

**See also:** BIGCOPY, BIGCLS, TURBOCOPY

## MADD
`=madd(ADDRESS_XO,ADDRESS_XA0,LEFT_BOUND,RIGHT_BOUND,ADDRESS_I0,NUMBER)` — multiple version of the ADD command: add values to a whole array of coordinates and report which objects went out of bounds.

- **ADDRESS_XO**: address of the first coordinate in the array to which values are to be added, e.g. `varptr(x(0))`
- **ADDRESS_XA0**: address of the first value to add, e.g. `varptr(xa(0))`; if you pass a value <= 32768 here it is added to *all* values in the x array instead
- **LEFT_BOUND**: if any coordinate becomes less than this, that object's number is set in the return value
- **RIGHT_BOUND**: if any coordinate becomes greater than this, that object's number is set in the return value
- **ADDRESS_I0**: address of the first value in an array saying whether the objects are alive; if it is 0 (excluding bit 31) that object is ignored
- **NUMBER**: number of objects to process — must be less than 33

Unlike ADD, out-of-bounds values are not clipped; instead the appropriate bit is set in the returned bit pattern, telling you which aliens/bullets have moved off the screen so you can deal with them as you like.

### Example
```stos
10 dim x(10),y(10),xa(10),i(10)
```

### Gotchas
- **Registered version only.** (New in V3.6b; absent from the V3.5a manual entirely.)
- The return value is a bit map of offending objects: 0 = none out of bounds, `%10` = object 2, `%11` = objects 1 and 2. Only 32 objects can be checked at a time this way.
- The listing spells the first parameter `ADDRESS_XO` (letter O); the description writes `ADDRESS_X0` (zero).

**See also:** IMAGE MCOLLIDE, INSIDE

## DAC PLACE
`INTEGER=dac place` — read the address of the sample currently playing.

Reads the value of the DMA sound register which holds the address of the sample currently playing. Use it to wait until a sample has stopped playing.

### Example
```stos
10 p=0
20 op=p:p=dac place:wait vbl
30 if p<>op then 20
```

### Gotchas
- **Registered version only.** (New in V3.6b; absent from the V3.5a manual entirely.)

**See also:** MADD
