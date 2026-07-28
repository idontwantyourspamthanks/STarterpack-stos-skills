# Missing Link commands: mapping

## WORLD
`WORLD x1,y1,x2,y2,0,1` — set the window size for a scrolling map.
`WORLD scr,gadr,madr,x,y,0` — draw a multi-directionally scrolling map.

- **x1,y1,x2,y2**: window the map is trapped in; X co-ordinates must be multiples of 16
- **scr**: screen address (`back`, `physic`, `logic`)
- **gadr**: address of the map blocks
- **madr**: address of the map data
- **x,y**: co-ordinates in the map data to scroll from

WORLD scrolls a map left, right, up and down in steps of less than 16 pixels — much easier than DEF SCROLL, and it coexists with bobs. Use it only for multi-directional scrolling, as its block data takes more memory than LANDSCAPE-style data. Requires world blocks (made with the MAKE utility) and world map data (saved from the EDDY map definer).

### Example
```stos
10 rem> Assuming the map-data is in banks 6 <
20 rem> and the blocks are in bank 5.       <
30 world 32,10,288,190,0,1
40 logic=back
50 X=0 : Y=0
60 repeat
70 world logic,start(5),start(6),X,Y,0
80 if jleft and X>0 then dec X
90 if jright and X<1500 then inc X
100 if jup and Y>0 then dec Y
110 if jdown and Y<2000 then inc Y
120 screen swap : wait vbl
130 until fire
```

### Gotchas
- Window X co-ordinates must be multiples of 16 (the tutorial attributes this to a quirk of the ST's hardware registers).
- Bank addresses must be actual: `start(5)`, not `5`.
- Although the EDDY manual says it loads both world and landscape blocks, it can in fact only load world blocks (see LANDSCAPE for the workaround).

**See also:** LANDSCAPE, X LIMIT, Y LIMIT, MAP TOGGLE, make-utility.md

## LANDSCAPE
`LANDSCAPE x1,y1,x2,y2,0,1` — set the window size for a map.
`LANDSCAPE scr,gadr,madr,x,y,0` — draw a vertically scrolling map.

Parameters as for WORLD, except that in the draw form the X co-ordinate is always rounded down to the nearest 16 pixels.

Used for vertically scrolling maps; also suitable for quickly drawing single-screen (flick-screen) maps, in the style of games like "CJ's Elephant Antics". In a loop only Y is scrolled; X just sets the horizontal starting point of the map.

### Example
```stos
10 rem> Assuming the map-data is in banks 6 <
20 rem> and the blocks are in bank 5.       <
30 landscape 32,10,288,190,0,1
40 logic=back
50 Y=0
60 repeat
70 landscape logic,start(5),start(6),0,Y,0
80 if jup and Y>0 then dec Y
90 if jdown and Y<2000 then inc Y
100 screen swap : wait vbl
110 until fire
```

### Gotchas
- Window X co-ordinates must be multiples of 16, as for WORLD.
- EDDY bug (tutorial): EDDY can only load world blocks, so to build a landscape map you must first convert sprites to world blocks, load those into EDDY to design the map, save as landscape data, then use landscape blocks in your program.
- Keep the map within 304 X / 320 X bounds when designing landscape maps.

**See also:** WORLD, MAP TOGGLE, WHICH BLOCK, make-utility.md

## WHICHBLOCK
`r = WHICH BLOCK (madr,x,y)` — return the block number at map co-ordinates X,Y.

- **madr**: address of the map data
- **x,y**: co-ordinates to check
- **r**: returned as the block number

Extremely useful for collision detection: draw collectable static items (diamonds etc.) into the background and test for them with WHICH BLOCK instead of using sprites. Block numbers count from 0, like bob images.

### Example
```stos
10 rem> Assuming the map-data is in banks 6 <
20 rem> and the blocks are in bank 5.       <
30 landscape 32,10,288,190,0,1
40 logic=back
50 Y=0
60 repeat
70 landscape logic,start(5),start(6),0,Y,0
80 if jup and Y>0 then dec Y
90 if jdown and Y<2000 then inc Y
95 if which block(start(6),160,Y+100)=1 then bell
100 screen swap : wait vbl
110 until fire
```

### Gotchas
- The LINK.DOC quick reference spells the command `WHICHBLOCK`; the command list writes it as `WHICH BLOCK`.

**See also:** SET BLOCK, BLOCK AMOUNT, XY BLOCK, LANDSCAPE

## SETBLOCK
`SET BLOCK madr,x,y,blk` — set the block at map co-ordinates X,Y.

- **madr**: address of the map data
- **x,y**: co-ordinates to change
- **blk**: new block number

Use with WHICH BLOCK to erase background blocks that have been picked up or destroyed (set them to block 0).

### Example
```stos
10 rem> Assuming the map-data is in banks 6 <
20 rem> and the blocks are in bank 5.       <
30 landscape 32,10,288,190,0,1
40 logic=back
50 Y=0
60 repeat
70 landscape logic,start(5),start(6),0,Y,0
80 if jup and Y>0 then dec Y
90 if jdown and Y<2000 then inc Y
95 if which block(start(6),160,Y+100)=1 then set block start(6),160,Y+100,0 : bell
100 screen swap : wait vbl
110 until fire
```

### Gotchas
- The LINK.DOC quick reference spells the command `SETBLOCK`; the command list writes it as `SET BLOCK`.

**See also:** WHICH BLOCK, REPLACE BLOCKS, LANDSCAPE

## REPLACE BLOCKS
`REPLACE BLOCKS madr,blk1,blk2` — replace every occurrence of one block with another.

- **madr**: address of the map data
- **blk1**: block to search for
- **blk2**: block to replace it with

Useful for changing all blocks of one kind at once — e.g. turning all diamonds on a map into money bags.

### Example
```stos
10 rem> assuming map-data in bank 6 <
20 replace blocks start(6),5,20
```

**See also:** REPLACE RANGE, WIN REPLACE BLOCKS, SET BLOCK

## BLOCK AMOUNT
`r = BLOCK AMOUNT(madr,blk)` — count how many times a block occurs in the map.

- **madr**: address of the map data
- **blk**: block to search for
- **r**: returned as the number of occurrences

Handy for checking whether all collectable items have gone (e.g. count the diamonds, then test for 0 after each SET BLOCK removal).

### Example
```stos
10 rem> assuming the map data is in bank 6 <
20 A=block amount(start(6),4)
30 print "Block 4 occurs";A;" times!"
```

**See also:** XY BLOCK, WHICH BLOCK, WIN BLOCK AMOUNT

## XY BLOCK
`XY BLOCK madr,xadr,yadr,blk,num` — store all co-ordinates of a given block into two arrays.

- **madr**: address of the map data
- **xadr**: pointer to the start of the X array (use `varptr(X(0))`)
- **yadr**: pointer to the start of the Y array
- **blk**: block to search for
- **num**: number of blocks to check for

Speeds up working out the co-ordinates of important map blocks such as baddie starting positions or exits. STOS arrays are a series of longwords (32-bit values); if you use a memory bank instead of arrays, reserve it as 4*NUM bytes.

### Example
```stos
10 rem> assuming the map data is in bank 6 <
20 A=block amount(start(6),4)
30 dim X(A+1),Y(A+1)
40 xy block start(6),varptr(X(0)),varptr(Y(0)),4,A
```

**See also:** BLOCK AMOUNT, WHICH BLOCK, WIN XY BLOCK

## X LIMIT
`x = X LIMIT(madr,x1,x2)` — return the maximum X co-ordinate of a map for a given window width.

- **madr**: address of the map data
- **x1,x2**: the window X range you set up with WORLD or LANDSCAPE
- **x**: returned as the maximum X co-ordinate

Use to work out how far sprites may move before hitting the map edge.

### Example
```stos
10 rem> assuming map data in bank 6 <
15 world 0,0,256,160,1
20 MX=x limit(start(6),0,256)
30 MY=y limit(start(6),0,160)
40 print "Max X is";MX
50 print "Max Y is";MY
```

### Gotchas
- The official example above calls the clip form of WORLD with five parameters (`world 0,0,256,160,1`); the documented clip syntax has six (`world x1,y1,x2,y2,0,1`). Example reproduced verbatim from LINK.DOC.

**See also:** Y LIMIT, WORLD, LANDSCAPE

## Y LIMIT
`y = Y LIMIT(madr,y1,y2)` — return the maximum Y co-ordinate of a map for a given window height.

- **madr**: address of the map data
- **y1,y2**: the window Y range you set up with WORLD or LANDSCAPE
- **y**: returned as the maximum Y co-ordinate

### Example
```stos
10 rem> assuming map data in bank 6 <
15 world 0,0,256,160,1
20 MX=x limit(start(6),0,256)
30 MY=y limit(start(6),0,160)
40 print "Max X is";MX
50 print "Max Y is";MY
```

**See also:** X LIMIT, WORLD, LANDSCAPE

## MAP TOGGLE
`n = MAP TOGGLE(madr)` — convert landscape map data to world map data and vice versa.

- **madr**: address of the map data

Ignore the value returned. Useful when some game levels use LANDSCAPE and others use WORLD with the same map.

### Example
```stos
10 load "map.mbk",6 : rem World data
20 N=map toggle(start(6))
30 print "The world data is now landscape data"
40 N=map toggle(start(6))
50 print "The landscape data is now back to world data"
```

**See also:** WORLD, LANDSCAPE

## REPLACE RANGE
`REPLACE RANGE madr,min,max,blk` — replace all blocks within a range of block numbers with one block.

- **madr**: address of the map data
- **min,max**: lower and upper block numbers to replace
- **blk**: block to replace them all with

Like REPLACE BLOCKS but covers a whole range — extremely useful for erasing groups of blocks that are no longer needed, such as starting positions.

### Example
```stos
10 rem> assuming map-data in bank 10 <
20 replace range start(10),5,10,0
```

(replaces blocks 5,6,7,8,9 and 10 with block 0)

### Gotchas
- **Registered version only.**

**See also:** REPLACE BLOCKS, WIN REPLACE RANGE

## WIN BLOCK AMOUNT
`r = WIN BLOCK AMOUNT (madr,x1,y1,x2,y2,blk)` — count a block's occurrences within a window of the map.

- **x1,y1,x2,y2**: top-left and bottom-right of the window to search
- all other parameters as for BLOCK AMOUNT

The WIN commands are windowed versions of the original mapping commands: they only affect blocks inside the given window, making effects like animating backgrounds easy, as well as localised collision detection.

### Example
```stos
10 rem> assuming map-data is in bank 10 <
20 R=win block amount(start(10),0,0,320,200,5)
```

### Gotchas
- **Registered version only.**

**See also:** BLOCK AMOUNT, WIN XY BLOCK, WIN REPLACE BLOCKS, WIN REPLACE RANGE

## WIN XY BLOCK
`WIN XY BLOCK madr,x1,y1,x2,y2,xadr,yadr,blk,num` — store co-ordinates of a block found within a window of the map.

- **x1,y1,x2,y2**: top-left and bottom-right of the window to search
- all other parameters as for XY BLOCK

### Example
```stos
10 rem> assuming map-data is in bank 10 <
20 R=win block amount(start(10),0,0,320,200,5)
30 dim X(R),Y(R)
40 win xy block start(10),0,0,320,200,varptr(X(0)),varptr(Y(0)),5,R
```

### Gotchas
- **Registered version only.**

**See also:** XY BLOCK, WIN BLOCK AMOUNT

## WIN REPLACE BLOCKS
`WIN REPLACE BLOCKS madr,x1,y1,x2,y2,blk1,blk2` — replace one block with another within a window of the map.

- **x1,y1,x2,y2**: top-left and bottom-right of the window
- all other parameters as for REPLACE BLOCKS

### Example
```stos
10 rem> assuming map-data is in bank 10 <
50 win replace blocks start(10),0,0,320,200,5,0
```

### Gotchas
- **Registered version only.**

**See also:** REPLACE BLOCKS, WIN REPLACE RANGE

## WIN REPLACE RANGE
`WIN REPLACE RANGE madr,x1,y1,x2,y2,min,max,blk` — replace a range of blocks within a window of the map.

- **x1,y1,x2,y2**: top-left and bottom-right of the window
- all other parameters as for REPLACE RANGE

### Example
```stos
10 rem> assuming map-data is in bank 10 <
60 win replace range start(10),0,0,320,200,7,10,5
```

### Gotchas
- **Registered version only.**

**See also:** REPLACE RANGE, WIN REPLACE BLOCKS
