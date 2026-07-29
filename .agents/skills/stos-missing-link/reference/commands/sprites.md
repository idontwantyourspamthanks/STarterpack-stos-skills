# Missing Link commands: sprites

## BOB
`BOB X1,Y1,X2,Y2,0,1` — set the bob clipping zone.
`BOB scr,gadr,img,x,y,0` — display a pre-shifted sprite (bob).

- **X1,Y1,X2,Y2**: clipping zone box (bobs vanish outside it)
- **scr**: screen address to draw on — `back`, `physic`, `logic` or any memory bank
- **gadr**: address of the bob data (pass `start(bank)` for a bank)
- **img**: image number, counting from 0
- **x,y**: screen co-ordinates (hot spot is the top-left corner)
- **0 / 1**: last parameter selects display (0) vs clip-set (1); the 0 before it is reserved

BOB is a replacement for SPRITE using pre-shifted sprites: much faster (about 25 16x16 bobs can be displayed in one VBL), with no 15-sprite limit, at the cost of more memory. Unlike SPRITE, a bob can be drawn on the back, physic or logic screen, or into a memory bank.

### Example
```stos
5 rem> BOB's in bank 5 <
10 logic=back
20 bob 16,16,304,184,0,1 : rem> Set clip 16,16 to 304,184 <
25 repeat
30 bob logic,start(5),0,x mouse,y mouse,0
40 screen swap : wait vbl
50 until mousekey=1
```

### Gotchas
- All addresses must be actual: pass `start(5)`, not `5`, for memory banks.
- Image numbers start from 0: when sprites are converted, sprite 1 becomes bob 0, sprite 2 becomes bob 1, etc.
- Bob banks are produced from a STOS sprite bank with the MAKE utility; the more pre-shifted images you ask for, the smoother the movement but the larger the bank (8 images moves smoothly at 2-pixel steps).
- Keep parameters simple: `bob logic,start(5),0,X,Y,0` works, but the inline form `bob logic,start(5),0,int(X)-8,int(Y)-8,0` fails with *Type mismatch* (verified in this project). Pre-compute coordinates into plain variables before calling BOB and other Missing Link commands.
- The duplicate `20` in the official doc's example is a typo (the `repeat` line); renumbered here.

**See also:** JOEY, B WIDTH, B HEIGHT, MANY BOB, make-utility.md

## JOEY
`JOEY X1,Y1,X2,Y2,0,0,1` — set the joey clipping zone.
`JOEY scr,gadr,img,x,y,colr,0` — display a single-colour pre-shifted sprite (joey).

- **colr**: palette colour number of the joey (the only parameter BOB does not have)
- all other parameters as for BOB

JOEY is the single-colour variant of BOB — especially useful for small bullet-type sprites or bonus-score sprites. Certain colours are faster than others; colour 15 is the fastest for technical reasons.

### Example
```stos
5 rem> JOEY's in bank 5 <
10 logic=back
20 joey 16,16,304,184,0,0,1
25 repeat
30 joey logic,start(5),0,x mouse,y mouse,15,0
40 screen swap : wait vbl
50 until mousekey=1
```

### Gotchas
- The LINK.DOC quick reference prints the display form as `JOEY scr,gadr,img,x,y,,COL,0` (double comma); the command-list form `JOEY scr,gadr,img,x,y,colr,0` is correct.
- As with BOB, image numbers start from 0 and bank addresses must be passed as `start(bank)`.
- Joeys are made with the MAKE utility; bullets usually only need about 2 pre-shifted images.

**See also:** BOB, MANY JOEY, make-utility.md

## B WIDTH
`w = B WIDTH (gadr,img)` — return the pixel width of a bob or joey image.

- **gadr**: address of the BOB/JOEY data
- **img**: image number to check (from 0)

Useful for restoring sprite backgrounds or for collision detection.

### Example
```stos
10 key off : curs off : hide : mode 0
20 load "bob.mbk",5
30 W=b width(start(5),0)
40 H=b height(start(5),0)
50 print "This bob is ";W;" pixels across"
60 print "This bob is ";H;" pixels down"
```

**See also:** B HEIGHT, BOB, JOEY

## B HEIGHT
`h = B HEIGHT (gadr,img)` — return the pixel height of a bob or joey image.

- **gadr**: address of the BOB/JOEY data
- **img**: image number to check (from 0)

Useful for restoring sprite backgrounds or for collision detection.

### Gotchas
- The DEANO tutorial's command summary mistypes this pair as `W=W HEIGHT (ADR,IMAGE)`; the real function is B WIDTH.

**See also:** B WIDTH, BOB, JOEY

## BULLET
`BULLET scr,x,y,col` — draw a 2x2 box, for quick bullets.

- **scr**: screen address
- **x,y**: co-ordinates of the bullet
- **col**: colour (0-15)

Like SPOT, except it draws a 2x2 box rather than a single pixel.

### Example
```stos
10 bullet logic,x mouse,y mouse,rnd(15)
```

### Gotchas
- **Registered version only.**

**See also:** SPOT, MANY BULLET, JOEY

## MANY ADD
`MANY ADD xadr,vadr,num,lval,uval` — add values to a whole array at once.

- **xadr**: address of the array to add values to (use `varptr(X(0))`)
- **vadr**: address of an array of values to add to the corresponding element of XADR, or an immediate value LESS THAN 32000
- **num**: number of elements in the array
- **lval,uval**: lower and upper limits the value may take (replaces `if X(0)>UVAL then X(0)=LVAL` style wrapping)

Speeds up almost any STOS program that updates many positions in a loop.

### Example
```stos
10 dim X(99),NUM(99)
20 many add varptr(X(0)),varptr(NUM(0)),99,0,319
30 many add varptr(X(0)),4,99,0,319
```

### Gotchas
- **Registered version only.**

**See also:** MANY INC, MANY DEC, MANY BOB

## MANY INC
`MANY INC xadr,num,lval,uval` — increment every element of an array by 1, with wrap limits.

Like MANY ADD but adds 1 only (like INC in STOS). Parameters correspond to MANY ADD, without VADR.

### Gotchas
- **Registered version only.**

**See also:** MANY ADD, MANY DEC

## MANY DEC
`MANY DEC xadr,num,lval,uval` — decrement every element of an array by 1, with wrap limits.

Like MANY ADD but subtracts 1 only (like DEC in STOS). Parameters correspond to MANY ADD, without VADR.

### Gotchas
- **Registered version only.**

**See also:** MANY ADD, MANY INC

## MANY BOB
`MANY BOB x1,y1,x2,y2,0,0,0,0,0,1` — set the clipping zone.
`MANY BOB scr,gadr,imgadr,xadr,yadr,statadr,xoff,yoff,num,0` — draw many bobs in one call.

- **scr**: screen address
- **gadr**: address of the bob data
- **imgadr**: pointer to an array of image numbers
- **xadr,yadr**: pointers to arrays of X and Y co-ordinates
- **statadr**: pointer to a status array — element not 0 draws the bob, 0 skips it ("killed" bobs)
- **xoff**: amount subtracted from each X co-ordinate displayed (for "virtual" co-ordinates)
- **yoff**: amount subtracted from each Y co-ordinate
- **num**: number of bobs to draw

Draws a whole series of bobs without a FOR..NEXT loop, giving a considerable speed increase over repeated BOB calls.

### Example
```stos
10 rem> assuming the bob-data is in bank 1 <
20 many bob 0,0,320,200,0,0,0,0,0,1
30 dim X(9),Y(9),IMG(9),FLAG(9)
40 for T=0 to 9
50 FLAG(T)=0
60 next T
70 many bob logic,start(1),varptr(IMG(0)),varptr(X(0)),varptr(Y(0)),varptr(FLAG(0)),0,0,9,0
```

### Gotchas
- **Registered version only.**
- Movement via XOFF/YOFF feels inverted: the offsets are subtracted, so decreasing XOFF moves the bobs right (tutorial: `if jright then X=X-4` moves bobs right).
- The UPDATE.DOC quick reference runs the last parameters together as `yoffnum`; it is two parameters, `yoff,num`.

**See also:** BOB, MANY JOEY, MANY OVERLAP, make-utility.md

## MANY JOEY
`MANY JOEY x1,y1,x2,y2,0,0,0,0,0,0,1` — set the clipping zone.
`MANY JOEY scr,gadr,imgadr,xadr,yadr,statadr,coladr,xoff,yoff,num,0` — draw many joeys in one call.

- **coladr**: pointer to an array holding the colour of each joey; passing 0-15 instead uses that colour for all joeys
- all other parameters as for MANY BOB

Like MANY BOB, but draws single-colour joeys.

### Example
```stos
10 rem> assuming the joey-data is in bank 1 <
20 many joey 0,0,320,200,0,0,0,0,0,0,1
30 dim X(9),Y(9),IMG(9),FLAG(9),CL(9)
40 for T=0 to 9
50 FLAG(T)=0 : CL(T)=rnd(14)+1
60 next T
70 many joey logic,start(1),varptr(IMG(0)),varptr(X(0)),varptr(Y(0)),varptr(FLAG(0)),varptr(CL(0)),0,0,9,0
```

### Gotchas
- **Registered version only.**
- The UPDATE.DOC command list prints the clip form with only ten parameters (`x1,y1,x2,y2,0,0,0,0,1`); the quick reference and the MANYJOEY.BAS example confirm eleven parameters (shown above).

**See also:** JOEY, MANY BOB, make-utility.md

## MANY BULLET
`MANY BULLET scr,xadr,yadr,statadr,coladr,xoff,yoff,num` — draw many 2x2 bullets in one call.

Parameters as for MANY JOEY, except IMGADR is not used.

### Example
```stos
10 dim X(9),Y(9),FLAG(9),CL(9)
20 for T=0 to 9
30 FLAG(T)=1 : CL(T)=rnd(14)+1
40 next T
50 many bullet logic,varptr(X(0)),varptr(Y(0)),varptr(FLAG(0)),varptr(CL(0)),0,0,9
```

### Gotchas
- **Registered version only.**
- UPDATE.DOC spells the third parameter `yady` (typo for `yadr`) and its example wrongly includes `start(1)` and a trailing `,0` copied from MANY JOEY; the MANY1.BAS example program confirms the 8-parameter form shown above.

**See also:** BULLET, MANY SPOT, MANY JOEY

## MANY SPOT
`MANY SPOT scr,xadr,yadr,statadr,coladr,xoff,yoff,num` — plot many pixels in one call.

The MANY version of SPOT. Parameters are the same as for MANY BULLET.

### Example
```stos
10 dim X(9),Y(9),FLAG(9),CL(9)
20 for T=0 to 9
30 FLAG(T)=1 : CL(T)=rnd(14)+1
40 next T
50 many spot logic,varptr(X(0)),varptr(Y(0)),varptr(FLAG(0)),varptr(CL(0)),0,0,9
```

### Gotchas
- **Registered version only.**
- UPDATE.DOC spells the third parameter `yady` (typo for `yadr`) and its example wrongly includes `start(1)` and a trailing `,0`; the MANYSPOT.BAS example program confirms the 8-parameter form shown above.

**See also:** SPOT, MANY BULLET

## MANY OVERLAP
`r = MANY OVERLAP (x1,y1,xadr,yadr,wid1,hig1,wid2,hig2,statadr,imgadr,stval,imgval,num)` — check one rectangle against many, at very high speed.

- **x1,y1**: top-left corner of the object to check everything else against
- **xadr,yadr**: pointers to the X and Y co-ordinate arrays of the other objects
- **wid1,hig1**: width and height of the first object
- **wid2,hig2**: width and height of all the other objects
- **statadr**: pointer to the status array — an element must hold 1 for its collision to be checked; anything else skips that element
- **imgadr**: pointer to the array of image numbers
- **stval**: value placed in STATADR if a collision takes place
- **imgval**: value placed in IMGADR if a collision occurs
- **num**: number of collisions to check
- **r**: returned as the number of collisions that actually occurred

A multiple-collision version of OVERLAP with a very high speed increase. Typical status convention (from the docs): 0 = off screen, 1 = on screen and checked, 2 = exploding/dead.

### Example
```stos
10 dim X(99),Y(99),STAT(99),IMG(99)
20 for T=0 to 99
30 X(T)=rnd(800)-400
40 Y(T)=rnd(800)-400
50 IMG(T)=1
60 if X(T)<0 or X(T)>319 or Y(T)<0 or Y(T)>199 then STAT(T)=0 else STAT(T)=1
70 next T
80 rem
90 XM=x mouse : YM=y mouse
100 R=many overlap(XM,YM,varptr(X(0)),varptr(Y(0)),16,16,32,24,varptr(STAT(0)),varptr(IMG(0)),2,5,99)
110 if R>0 then boom
120 goto 90
```

### Gotchas
- **Registered version only.**

**See also:** OVERLAP, MANY BOB
