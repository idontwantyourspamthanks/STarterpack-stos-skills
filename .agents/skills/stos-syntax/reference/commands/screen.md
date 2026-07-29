# STOS commands: screen

## BACK
`BACK` — Address of the background screen.

`BACK` is a reserved variable which holds the location of the screen used as the sprite background. STOS Basic holds two screens in memory at any one time: the Physical screen, which is actually displayed on your television set, and a separate Background screen which is used by the sprite commands. Normally the only difference between the two screens is the sprites, which are only drawn on the physical screen. STOS Basic uses this background to redraw any areas of the screen which are revealed underneath the sprites when they are moved.

### Example
```text
print back:rem Address of background is 983040 for 1040ST users
458752
```

**See also:** PHYSIC, LOGIC, AUTOBACK

## PHYSIC
`PHYSIC` — Address of the physical screen.

`PHYSIC` is a reserved variable which contains the location of the screen currently being displayed. If you load a different address into this variable, the screen will be immediately redrawn using the screen stored at the new address.

### Example
```text
print physic
491520 (or 1015808 on a 1040ST)
```
```stos
10 reserve as screen 5
20 physic=5
30 cls
```
The above example reserves a memory bank as a screen and then assigns the address of this bank to the physical screen. Notice how you are able to use the number of the bank instead of an address. When you run this program, the new screen will be cleared. If you now press the Undo key twice, the screen address will be returned to normal and the original picture will be restored. Incidentally, the ST's hardware will only let you display a screen stored at an address which is a multiple of 256 bytes. The RESERVE instruction automatically takes this into account when allocating memory for a screen.

**See also:** BACK, LOGIC, DEFAULT

## LOGIC
`LOGIC` — Address of the logical screen.

The Logical screen is the screen which is operated on by any of the text or graphics instructions. Normally this will be the same as the physical screen, but occasionally it's useful to use a separate screen to hold an image while it is being drawn. This allows you to draw one picture while displaying another, and then instantly switch between them using a special SCREEN SWAP instruction. A similar technique is used by games such as Starglider to generate impressive flicker free graphics.

### Example
```text
back=logic:rem Move the mouse around and see what happens.
print back
```

**See also:** SCREEN SWAP, BACK, PHYSIC

## SCREEN SWAP
`SCREEN SWAP` — Swaps the address of the logical and physical screens.

SCREEN SWAP swaps the addresses of the physical and logical screens. This enables you to instantaneously switch the display between the two screens.

### Example
```stos
10 cls
20 X1=50: Y1=50: X2=75: Y2=100: X3=25 : Y3=100
40 for I=0 to 244 step 8
50 ink 0
60 polygon X1+I-8,Y1 to X2+I-8,Y2 to X3+I-8,Y3 to X1+I-8,Y1
70 ink 1
80 polygon X1+I,Y1 to X2+I,Y2 to X3+I,Y3 to X1+I,Y1
100 next I
```
This program moves a triangle across the screen. As the triangle proceeds, it generates an intense and annoying flicker. You can solve this problem by displaying the triangle on the screen only after it has been completely redrawn. Add the following lines to the program above:
```stos
30 logic=back
90 screen swap : wait vbl
```
You should also change line 60 to take account of the fact that each screen is now used on alternate executions of the loop:
```stos
60 polygon X1+I-16,Y1 to X2+I-16,Y2 to X3+I-16,Y3 to X1+I-16,Y1
```
Line 30 places the address of the sprite background into the logical screen. The triangle is now drawn on this screen without affecting the current image. The SCREEN SWAP instruction at line 90 then swaps the logical and physical screens around. This causes the finished version of the triangle to appear on the screen immediately. The program now erases the old triangle from the invisible logical screen and redraws it at the next position. The whole process is subsequently repeated and the triangle apparently smoothly progresses from one side of the screen to the other. The reason for the change at line 60 incidentally, is simply to take into account the fact that each screen is used on alternate executions of the loop. This means that the triangle to be erased will be twice the distance from the current position as you would normally expect.

### Gotchas
- The flicker in the example above was intentionally exaggerated to illustrate the screen switching technique. In practice it would be very easy to reduce this problem considerably even without the use of the SCREEN SWAP instruction.
- As the background screen is used for our own purposes here, any of the sprite commands will interfere with the animation. Try moving the mouse while the program runs to observe this effect.

**See also:** LOGIC, PHYSIC, WAIT VBL

## RESERVE AS SCREEN
`RESERVE AS SCREEN n` — Reserve a bank as a temporary screen.

- **n**: the bank number to reserve.

Reserves bank number *n* as a screen. The size of this bank is automatically set by RESERVE to 32768 bytes. After you have created a screen in this way, you can load it with data using either the LOAD instruction or SCREEN COPY. Note that this screen is only intended for temporary storage and is reinitialised every time your program is run.

### Example
```stos
10 reserve as screen 5
20 load "\stos\pic.pi1",5
```

**See also:** RESERVE, RESERVE AS DATASCREEN, LOAD, SCREEN COPY

## RESERVE AS DATASCREEN
`RESERVE AS DATASCREEN n` — Reserve a bank as a permanent screen.

- **n**: the bank number to reserve.

Identical to the RESERVE AS SCREEN instruction except for the fact that it is installed permanently into the ST's memory. Any screen you define as a DATASCREEN will be subsequently saved along with your program.

### Example
```text
reserve as datascreen 5
clear
listbank
```

**See also:** RESERVE, RESERVE AS SCREEN

## GET PALETTE
`GET PALETTE(n)` — Set the palette from a screen bank.

- **n**: the number of the bank holding the screen whose palette is to be loaded.

Loads the colour settings of a screen stored in bank *n*, and displays them on the present screen.

### Example
```stos
10 reserve as screen 5
20 load "\STOS\PIC.PI1",5
30 physic=5
40 wait key
50 get palette(5)
60 wait key
```

**See also:** PALETTE, PHYSIC

## ZOOM
`ZOOM scr1,x1,y1,x2,y2 TO [scr2,] x3,y3,x4,y4` — Magnify a section of the screen.

- **scr1**: source screen; either an address or the number of a memory bank.
- **x1,y1,x2,y2**: coordinates of the rectangular area to be enlarged; *x1,y1* denote the top left hand corner, *x2,y2* the diagonally opposite corner.
- **x3,y3,x4,y4**: dimensions of the destination rectangle into which the screen segment will be expanded.
- **scr2**: optional destination screen. If omitted, the enlarged image is first placed in the background and then copied into the physical screen.

Magnifies any rectangular section of the screen stored at *scr1*. ZOOM is best suited to enlarging pictures with relatively large expanses of a single colour. This is because each individual point in the picture is magnified independently, which produces a noticeable grain for large size increases. An especially useful application of this instruction is in the creation of large banners on the screen.

### Example
A first program enlarges a centred string a step at a time:
```stos
10 rem ZOOM1
20 rem Set screen attributes
30 cls : mode 0: pen 10: curs off
40 Z$="Zooming!"
50 rem Find position of text
60 locate 0,4 : centre Z$
70 Y1=ygraphic(4) : X2=xgraphic(xcurs) : X1=X2-8*len(Z$) : Y2=Y1+8
80 for I=1 to 7
90 rem Calculate Zoom coordinates
100 X3=X1-16*I : Y3=Y1-16*I : X4=X2+16*I : Y4=Y2+16*I
110 rem Enlarge Text
120 zoom physic,X1,Y1,X2,Y2 to X3,Y2,X4,Y4
130 next I
140 wait key : curs on
```
This repeatedly enlarges the centred text starting at coordinates 0,4. We've kept the routine as general as possible to allow you to incorporate parts of it into your own programs.

We'll now expand this program slightly to demonstrate the page flipping mentioned earlier. Add the following lines to the above program:
```stos
11 rem Reserve 6 screens
15 for I=5 to 11:reserve as screen I : cls I: next I
121 rem Enlarge text to screen no I
125 zoom physic, X1, Y1, X2, Y2 to I+5,X3,Y2,X4,Y4
140 rem Flip between all 6 screens
150 for I=6 to 11:physic=I:wait vbl : wait 5:next I
160 wait 30: goto 140
```
You should also alter line 80 to:
```stos
80 for I=1 to 6
```
Note that this program reserves six screens 32k each. It will work fine on a standard 520ST, providing you remove all STOS Basic accessories from memory using a line like:
```text
accnew
```
In addition, you may also need to load STOS Basic directly on startup, rather than executing it from within GEM, as this saves you over 32k of memory.

Another common use of ZOOM is to magnify a specific part of an image for subsequent editing. The program below shows how this might be achieved in practice:
```stos
10 rem Zoom Example 2
20 mode 0
30 reserve as screen 5:rem Reserve a bank for the screen
50 F$=file select$("*.NEO"):rem Choose a neochrome picture
60 if F$="" then stop
80 flash off:rem Turn off flashing
90 rem Load screen into Bank 5
100 load F$,5 : get palette (5)
110 rem Copy screen into Physical screen and Background
130 screen copy 5 to physic : screen copy 5 to back
140 rem Draw an expanding Box
150 gr writing 3
160 rem Click on the mouse to position Box
170 repeat : until mouse key : X1=x mouse : Y1=y mouse : X2=X1 : Y2=Y1
190 wait 40:rem Wait for Mouse key to be released
200 repeat
210 box X1,Y1 to X2,Y2
220 X2=x mouse : Y2=y mouse
230 box X1,Y1 to X2,Y2: M=mouse key
250 until M<>0:rem click on a mouse button to exit
260 rem Make X1,Y1 into the top corner
270 if X1>X2 then swap X1,X2
280 if Y1>Y2 then swap Y1,Y2
290 rem If Right Mouse button pressed
300 rem Zoom Contents of Box to full
310 rem Screen.
320 if M=1 then zoom X1,Y1,X2,Y2 to 0,0,319,199 else box X1,Y1 to X2,Y2: M=0 : wait 40 : goto 170
330 wait key
340 goto 130
```
Much of this program should be self explanatory. Note the lines 140-250. These use the XOR writing mode to generate a simple expanding box. Feel free to use this routine in any of your own programs. After this box has been defined, the line at 320 uses the ZOOM command to expand its contents into the entire screen. Incidentally, the test for M=1 is merely to allow you to abort the current expansion by pressing the right mouse button.

**See also:** REDUCE, SCREEN COPY

## REDUCE
`REDUCE scr1 TO [scr2,]x1,y1,x2,y2` — The inverse of ZOOM.

- **scr1**: source screen; either an address or the number of a memory bank.
- **x1,y1,x2,y2**: coordinates of the destination box; *x1,y1* the top left corner, *x2,y2* the bottom right.
- **scr2**: optional destination screen. If omitted, the drawing is first placed in the background and then moved into the physical screen.

Compresses the entire screen stored at *scr1* into the box specified by the coordinates *x1,y1,x2,y2*. As with ZOOM, if the optional destination screen is omitted, the drawing is first placed in the background and then moved into the physical screen.

### Example
```stos
10 rem Reduce Example 1
20 F$=file select$("*.NEO")
30 rem Choose a picture
40 if F$="" then stop
50 mode 0: flash off: curs off
60 rem Reserve screen and load Picture
70 erase 5:reserve as screen 5
80 load F$,5 : get palette (5)
90 rem display 4 copies of picture
100 for Y=0 to 1
110 for X=0 to 1
120 reduce 5 to X*160,Y*95,(X+1)*159+1,(Y+1)*96
130 next X
140 next Y
150 wait key
160 goto 20
```
This loads a Neochrome screen into a memory bank and then generates four smaller copies of it using the REDUCE at line 120.

If you've got the second example of ZOOM handy, you can change it to use the REDUCE instruction instead, with the line:
```stos
320 if M=1 then reduce 5 to X1,Y1,X2,Y2 else box X1,Y1 to X2,Y2: M=0 : wait 40: goto 170
```

REDUCE has many possible uses. One idea would be to generate a list of large icons similar to those utilised in the game STAR TREK. These could be assigned to a screen zone using SET ZONE, and then selected with the ZONE command. By storing a full-sized version in a compacted format (see PACK), you could then effectively expand these pictures into the entire screen.

**See also:** ZOOM, SCREEN COPY, PACK

## SCREEN COPY
`SCREEN COPY scr1 TO scr2` — Copies *scr1* to *scr2*.

- **scr1**: source screen; either a screen address (such as LOGIC or PHYSIC) or the number of a memory bank.
- **scr2**: destination screen; same form as *scr1*.
- **x1,y1,x2,y2**: (second form) dimensions of the rectangular area to be copied.
- **x3,y3**: (second form) coordinates of the destination of this block.

Second form:

`SCREEN COPY scr1,x1,y1,x2,y2 TO scr2,x3,y3`

SCREEN COPY is undoubtedly one of the most powerful of all the STOS Basic instructions. This is because it allows you to copy large sections of a screen from one place to another. Note that the x coordinates used in this instruction are automatically rounded down to the nearest multiple of 16. Also the values taken by these numbers can be negative as well as positive. Look at the table below.

```text
Graphics Mode          X Range                Y Range

Low                    -320 to 320            -200 to 200
Medium                 -640 to 640            -200 to 200
High                   -640 to 640            -400 to 400
```

Any points in the destination outside the normal screen are simply not copied on the screen. This is in marked contrast with the BLIT statement supported by other versions of Basic which crash the ST completely if an illegal screen coordinate is used.

### Example
Before you can enter the examples you first need to do a little preparation. Start off by reserving a bank for the STOS Basic title screen with the line:
```text
reserve as datascreen 10
```
Now place the STOS system disc into your drive and type:
```text
load "\STOS\PIC.PI1",10 (for low resolution monitors)
```
or
```text
load "\stos\pic.pi3",10 (for high resolution monitors)
```
Since you will be using the SCREEN COPY instruction rather a lot in this section, you can save yourself some typing by assigning it to one of the function keys like this:
```text
KEY(10)="screen copy"
```
This allows you to abbreviate any SCREEN COPY statements in subsequent listings to just f10.

Now copy the title in bank 10 into the logical screen using the lines:
```text
cls: mode 0
screen copy 10 to logic
```
As you move the mouse around on the screen, you will find that the picture will be steadily eaten away. This can be avoided by loading the picture into sprite background as well.
```stos
10 cls : mode 0
20 screen copy 10 to logic
30 screen copy 10 to back
40 wait key
```
If you move the mouse when this program is being run, the screen will no longer be erased, because the sprite background now contains exactly the same picture as the logical screen. By loading a picture into the background alone you can produce another interesting effect. Try typing:
```text
cls
screen copy 10 to back
```
Now the title picture is steadily drawn as you move the mouse. Instant artwork! Now enter the lines:
```text
delete 10-40: rem Do not type in NEW as this will erase bank 10
load "sprdemo.mbk"
```
```stos
10 cls: hide
20 screen copy 10 to logic
30 sprite 1,130,0,1
40 move y 1,"(1,1,1)L"
50 move on
60 wait key
```
Now for some more complicated examples. Type in the following lines:
```text
screen copy 10,0,0,100,100 to logic,0,0
```
This copies the top left hand corner of the title on to the screen. You can also use the SCREEN COPY statement with negative coordinates.
```text
screen copy 10,0,0,100,100 to logic,-50,-50
```
As you can see, only the lower section of the block has been copied to the screen. Here's one final example of the SCREEN COPY command which enables you to move a large coloured grid around on the screen using the mouse.
```text
new
10 mode 0:I=14
15 rem Initialise screen and set square markers
20 cls physic : cls back:set mark 4,28
25 rem Draw a grid on the screen
30 for X=1 to 10 : for Y=1 to 9: ink rnd(I)+1: polymark X*28,Y*20
40 next Y: next X
45 rem Reserve a screen and copy the grid to it
50 reserve as screen 10: screen copy logic to 10
60 hide : curs off:rem Kill mouse and cursor
65 logic=back:rem Set Logical screen to sprite background
70 rem Move the grid
75 repeat
80 cls logic
85 rem Get mouse coords
90 X=320-x mouse*3 : Y=200-y mouse*3:rem Use different values for high res
95 rem Copy the grid to the current screen
100 screen copy 10,X,Y,X+320,Y+200 to logic,0,0
110 screen swap:rem Swap physical and logical screens
120 wait vbl:rem Synchronise screen
130 until mouse key
140 default:rem Reset Editor window
```

**See also:** SCREEN SWAP, WAIT VBL, LOGIC, PHYSIC, BACK

## SCREEN$
`s$=SCREEN$(scrn,x1,y1 TO x2,y2)` — Load an area of a screen into a string.

- **scrn**: the address of a screen or the number of a memory bank.
- **x1,y1**: coordinates of the top left corner of the rectangle to load.
- **x2,y2**: coordinates of the diagonally opposite corner.
- **s$**: the destination string.

There are two different forms of this statement. The SCREEN$ function loads an area of the screen bounded by the rectangle *x1,y1,x2,y2* into the string *s$*. Just as with the SCREEN COPY instruction, the X coordinates are automatically rounded down to the nearest multiple of 16.

Instruction form:

`SCREEN$(scrn,x,y)=a$`

This instruction copies a screen area from the string *a$* to the screen *scrn*, starting at the coordinates *x,y*. As usual *scrn* can refer to either a screen address or a bank number. Also note that the x coordinates used by SCREEN$ are always rounded down to the nearest multiple of 16.

### Gotchas
- The `SCREEN$(scrn,x,y)=a$` instruction will only work with strings which have been previously loaded by the SCREEN$ function.

### Example
```text
A$=screen$(physic,0,0 to 319,199):rem Assigns the entire screen to a$

S$=screen$(back,50,50 to 100,100):rem A$=area from 50,50 to 100,100

reserve as screen 10
screen copy physic to 10
b$=screen$(10,0,0 to 160,100):rem Loads B$ with top of screen in bank 10
```
The following example fills the screen with copies of the top corner of the display:
```stos
10 S$=screen$(physic,0,0 to 100,100)
20 for y=0 to 3:for x=0 to 6
30 screen$(physic,50*x,50*y)=S$
40 next x:next y
```
The classic application of SCREEN$ is in the creation of complex backgrounds for your games. By building your picture out of a number of previously defined blocks, you can combine these into a wide range of different screens. Furthermore, after you have stored your blocks into memory, you can hold each screen as a simple list of numbers. In practice this simple technique can save you an immense amount of space.
```stos
5 rem SCREEN$ example
6 rem Requires Disc containing complete \STOS\ folder in order to run.
10 dim P$(10,6)
15 rem Use extension PI3 for MONO MODE.
20 mode 0 : curs off: hide :load "\STOS\PIC.PI1",back
30 for X=0 to 9
40 for Y=0 to 5
45 rem Copy screen segments into array
50 P$(X,Y)=screen$(back,X*32,Y*32 to (X+1)*32,(Y+1)*32)
60 next Y
70 next X
80 for X=0 to 9
90 for Y=0 to 5
100 X1=rnd(9):Y1=rnd(5)
105 rem Copy segments back onto screen
110 screen$(physic,X*32,Y*32)=P$(X1,Y1)
120 next Y
130 next X
140 wait key
150 goto 80
```

In order to make it as easy as possible to draw one of these screens we have provided you with a special MAP DEFINER program.

**See also:** SCREEN COPY, SET PATTERN

## DEF SCROLL
`DEF SCROLL n,x1,y1 to x2,y2,dx,dy` — Define a scrolling zone.

- **n**: the number of the zone; ranges from 1-16.
- **x1,y1**: coordinates of the top left hand corner of the area to be scrolled.
- **x2,y2**: coordinates of the diagonally opposite corner.
- **dx**: the number of pixels the zone will be shifted to the right in each operation. Negative numbers indicate scrolling from right to left, positive from left to right.
- **dy**: the number of points the zone will be advanced up or down during the scroll. Negative values indicate an upward movement, positive values a downward one.

DEF SCROLL allows you to define up to 16 different scrolling zones. Each of these is associated with a specific scrolling operation determined by the variables *dx* and *dy*.

**See also:** SCROLL

## SCROLL
`SCROLL n` — Scroll the screen.

- **n**: the number of the zone you wish to scroll.

The SCROLL command scrolls the screen in the direction you have previously specified with the DEF SCROLL instruction.

### Gotchas
- Do NOT confuse with the SCROLL instruction used by the window commands.

### Example
```stos
10 def scroll 1,0,0 to 320,200,1,0
20 scroll 1:goto 20
```
Now for a larger example — a vertical scroll:
```stos
5 rem Vertical Scrolls
10 input "Step Size?";S:rem Choose scroll increment
11 rem Initialise screen and load background from system disc
20 mode 0 : curs off: hide : load "\STOS\PIC.PI1",back
30 def scroll 1,80,0 to 240,200,0,-S:rem Define scrolling zone 1
40 for Y=0 to 199 step S:rem Scroll section of the screen
45 rem copy top of screen to bottom
50 screen copy back,80,Y,240,Y+S to logic,80,200-S
60 scroll 1:rem scroll zone 1
70 next Y
80 goto 40
```
This loads an image from the STOS system disc and rotates it around on the screen. The variable *S* holds the number of points the picture will be moved when each SCROLL instruction is executed. The larger the value of *S*, the faster and jerkier the scrolling. Note line 50. This copies the top section of the screen into the bottom before it disappears.

Here is another example which demonstrates how horizontal scrolling can be achieved.
```stos
5 input "Speed";S
7 rem Initialise screen and load background from system disc
10 mode 0: curs off: hide: load "\STOS\PIC.PI1",back
20 def scroll 1,0,80 to 320,120,-16,0:rem Define scrolling zone 1
30 for Y=0 to 319 step 16:rem Scroll section of the screen
35 rem Copy left section of the screen back to the right
40 screen copy back,Y,80,Y+16,120 to logic,320-16,80: for W=1 to S: next W: scroll 1
50 next Y
60 goto 30
```
This uses a very similar technique to the last example except for the fact that SCREEN COPY rounds all X coordinates down to the nearest multiple of 16. The example is therefore forced to scroll in units of 16. Despite this the scrolling is still reasonably smooth, especially at the slower speeds.

Now for a final example which combines a complex series of scrolling zones to produce a fascinating effect on the screen.
```stos
1 rem Screen Scrolling demo
5 rem Needs Stos system disc in drive
10 mode 0: curs off: hide : load "\stos\pic.pi1",back
15 rem Define scrolls
20 def scroll 1,0,171 to 320,200,0,-6
30 def scroll 2,0,146 to 320,175,0,-4
40 def scroll 3,0,122 to 320,150,0,-2
50 def scroll 4,0,72 to 320,125,0,-1
60 def scroll 5,0,46 to 320,75,0,-2
70 def scroll 6,0,21 to 320,50,0,-4
80 def scroll 7,0,0 to 320,25,0,-4
90 rem scroll screen
100 for Y=0 to 199
110 screen copy back,0,Y,320,Y+6 to logic,0,194
130 scroll 1: scroll 2: scroll 3: scroll 4: scroll 5: scroll 6: scroll 7
140 next Y
150 goto 100
```

**See also:** DEF SCROLL, SCREEN COPY

## WAIT VBL
`WAIT VBL` — Wait for a vertical blank.

The Atari ST uses a memory-mapped display which is updated by the hardware every 50th of a second (70th in Monochrome mode). Once a screen has been drawn the electron beam turns off and returns to the top left of the screen; this process is called the vertical blank or VBL for short. At the same time, STOS Basic performs a number of important tasks, such as moving the sprites and switching the physical screen address if it has changed. The actions of instructions such as PUT SPRITE, or SCREEN SWAP will therefore only be fully completed when the screen is next drawn.

The WAIT VBL instruction halts the ST until the next vertical blank is performed. It is commonly used after either a PUT SPRITE instruction, or a SCREEN SWAP.

### Gotchas
- As a general rule, if your program uses sprites or screens and it only works intermittently, it's always worth checking to see whether you have omitted the WAIT VBL.

**See also:** SCREEN SWAP, SYNCHRO, PUT SPRITE

## SYNCHRO
`SYNCHRO` — Synchronise scrolling with sprites.

STOS Basic performs all sprite movements every 50th of a second. This generally works fine, but occasionally it leads to an irritating synchronisation problem. Supposing you want to place a sprite at a fixed point on a scrolling background. Whenever this background moves, the sprite will move along with it. It would be easy enough to produce a set of MOVE X and MOVE Y instructions which precisely followed the movement of the background. Unfortunately, this wouldn't quite work as the SCROLL instructions would not be executing at the same time as the sprite movements. The sprite would therefore tend to drift jerkily around on the screen.

There are three forms of this instruction:

- `SYNCHRO OFF` — Turns off the normal sprite interrupt which moves the sprites every 50th of a second.
- `SYNCHRO` — Executes all the sprite movements exactly once.
- `SYNCHRO ON` — Reverts the sprite movements to normal. The sprites will now be moved in the normal way every 50th of a second.

SYNCHRO allows you to move all the sprites on the screen at the exact moment you require, and so effortlessly synchronise the sprites with a scrolling background.

### Example
First you need to load some sprites into your micro. Place the accessory disc into the drive and type:
```text
load "sprdemo.mbk"
```
You can now type in the program itself:
```text
new
10 rem Demonstration of SYNCHRO
20 mode 0: curs off: hide : key off
30 rem Load picture from disc
40 load "\STOS\PIC.PI1",back : screen copy back to logic
50 rem Place sprite on the screen
60 rem Start it moving up.
70 sprite 1,144,199,1: move y 1,"(1,-2,1)L"
80 rem Turn off sprite interrupt
90 synchro off: move on
100 rem Define Scrolls
110 def scroll 1,80,0 to 240,200,0,-2
120 rem Scroll section of the screen
130 wait 100: rem Wait for drive to stop
140 for Y=0 to 199 step 2
150 screen copy back,80,Y,240,Y+2 to logic,80,198
160 scroll 1: wait vbl: synchro
170 next Y
180 rem Restart from bottom of screen
190 sprite 1,144,199,1 : move y 1,"(1,-2,1)L"
200 synchro off: move on
210 goto 140
```
Notice line 160 which moves the sprite up one unit and then scrolls the screen along with it. The WAIT VBL instruction is essential as it completes the synchronization process. Try removing it and see what happens. The chosen sprite also illustrates an interesting side effect: as the sprite is moved, the sprite background peeps through it, rather like a window. You could use this technique to produce a range of useful special effects.

**See also:** WAIT VBL, SCROLL, PUT SPRITE, MOVE X, MOVE Y

## UNPACK
`UNPACK bnk,scr` — Unpack a screen compacted with the accessory.

- **bnk**: the bank number holding the compacted screen.
- **scr**: the destination screen; either a bank defined as a SCREEN or DATASCREEN, or a screen address.

STOS Basic comes complete with a useful accessory which allows you to compact any screen files stored in either Neochrome or Degas format into just a fraction of their normal size. You can load this program from the accessory disc using the line:
```text
accnew:accload "compact.acb"
```
The UNPACK command restores a compacted screen stored in bank number *bnk* into the screen *scr*.

### Example
```text
load "backgrnd.mbk":rem Load a compressed screen saved in bank 5

unpack 5,back:rem Unpack bank five and load into sprite background
physic=back:rem Set physical screen to sprite background
```

**See also:** PACK

### Gotchas
- The SCREEN COMPACTOR accessory (COMPACT.ACB) is menu-driven: it loads NEO/PI1/PI2/PI3 pictures, can pack a whole picture or a portion of it (with an optional erase-after-pack toggle), and saves the result as a MEMORY BANK (.MBK). Pack whole screens within programs with PACK; load and unpack banks with UNPACK.
- The same two commands also ship as a standalone "Picture Compactor" extension (COMPACT.EXA / COMPACT.ECA; its boot banner is bilingual, "PICTURE COMPACTOR extension / Extension COMPACTEUR D'IMAGES") — loading it simply provides the vanilla PACK/UNPACK as an installable extension, so programs using them work identically either way.
- Not to be confused with the unrelated SQUASHER extension by J.B.Briscombe (`squash`/`unsquash` on any bank, with its own SQUASH.ACB/UNSQUASH.ACB accessories).

## PACK
`l=PACK(scr,bnk)` — Function to pack a screen.

- **scr**: the source screen; either a screen address or a bank number containing a screen to be compressed.
- **bnk**: the destination bank.
- **l**: returns the length of the compressed screen.

This is just the reverse of the UNPACK command. It's normally easier to use the SCREEN COMPACTOR accessory, but if you do need to compact a screen within a program, you can use the PACK function. After the PACK function has been executed, *l* is loaded with the length of the compressed screen.

### Example
```text
reserve as screen 5:rem Reserve space for source
reserve as screen 6:rem Reserve space for destination
load "\stos\pic.pi1",5:rem Load Title screen from system disc in 5
L=pack(5,6):rem Pack screen
reserve as data 7,L:rem Reserve space for new screen
copy start(6),start(6)+L to start(7)
save "title.mbk":rem Save compacted screen
```

**See also:** UNPACK, RESERVE

## APPEAR
`APPEAR x [,y]` — Fade between two pictures.

- **x**: the address or bank number of a picture stored in memory.
- **y**: optional type of fade; ranges from 1 to 79.

The APPEAR command enables you to produce fancy fades between a picture stored at address *x* or in bank *x*, and the current screen. The *y* value is optional and refers to the type of fade you wish to use. *y* can range from 1 to 79. Fades between 1-72 always result in a COMPLETE image being copied from *x* to the screen. Fades from 73-79 leave the final screen slightly different from the original in bank *x*.

### Example
```stos
10 hide
20 reserve as screen 15
30 if mode=1 then mode=0
40 if mode=0 then load "\stos\pic.pi1",15 else load "\stos\pic.pi3",15
50 cls
60 input "screen effect";X
70 curs off
80 if X=0 then default: end
90 get palette (15)
100 appear 15,X
110 wait key
120 curs on
130 goto 50
```

**See also:** FADE, GET PALETTE

## FADE
`FADE speed` — Blend one or more colours to new colour values.

This function allows you to produce stunning effects in one simple command. There are three formats of the FADE command:

- `FADE speed` — Fade all colours to black. This version of FADE reduces each colour's RGB values by 1 until they reach zero. *speed* is the amount of vertical blanks that must occur before another change to the palette is made.
- `FADE speed TO sbank` — Fade the present colours to those of the specified screen. The current colours are blended into the palette of the screen stored in bank *sbank*.
- `FADE speed,col1,col2,...` — FADE separate colours to a new value. This is the most powerful of the three formats and allows any colour to be blended into another.

### Example
```stos
10 mode 0:print "bye bye...":fade 3:wait 7*3
```
The WAIT command is used after the FADE because the fading changes are done during interrupt. Thus the program carries on. Because our next line will reset the colours, it's best to wait until the original fade has been completed. The pause value for the WAIT command can be calculated by the formula:
```text
wait value = fade speed * 7
```
Once the above line has been run, the screen is left in total darkness. To bring back some colour you would enter a line like:
```stos
20 cls:print "here I am again!":fade 3,,$777,$700
```
Notice that there are two commas after the speed parameter. This tells STOS Basic that you don't wish to change the value of colour 0 and this can be applied to any colour in the palette. Colours 1 and 2 are now faded up to reveal the new message.

Fade adds flair to your programs and gives them a professional touch similar to credit screens from films.

More examples:
```text
fade 3:rem press undo twice to see again
```
```text
reserve as datascreen 15
load "\STOS\PIC.PI1",15
fade 10 to 15
```
```text
fade 5,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777,$777
```

**See also:** APPEAR, GET PALETTE, PALETTE

## KEY ON/OFF
`KEY ON / KEY OFF` — Set or clear the function key window.

- `KEY ON` — Turns on the function key window allowing you to select the various options with the mouse pointer.
- `KEY OFF` — This removes the function key window and frees the space for further use.

You can still select the functions when the window is off by pressing the function keys.

**See also:** KEY

