# STOS commands: graphics

## CLS
`CLS` — Clear the whole screen.

This instruction clears the entire screen at high speed. It is usually used to initialise the screen at the start of a program. CLS has a number of useful extensions which enable you to erase all or part of a screen stored anywhere in the ST's memory. A full explanation of these options can be found in Chapter 7.

## INK
`INK index` — Set colour of graphic drawing operations.

- **index**: the number of the colour to be used for all subsequent drawing operations.

Note that index number 2 is slightly unusual, in that it flashes on and off several times a second. You can produce a similar effect using the FLASH instruction covered in section 6.7.

## COLOUR
`COLOUR index,$RGB` — Assign a colour to an index.

- **index**: the number of the colour to be changed.
- **$RGB**: usually a hexadecimal expression which determines the exact shade of the new colour. This expression consists of three digits ranging from 0 to 7, each of which sets the strength of one of the primary colours, RED (R), GREEN (G) or BLUE (B) in the final result.

There is also a function form: `c=COLOUR(index)` returns the colour value which has been assigned to *index*. *c* is any variable and *index* is the colour number whose shade you want to determine.

Here are a few examples of this notation:

```text
Components            Hexadecimal form             Final Colour

R=0 G=0 B=0           $000                         BLACK
R=7 G=0 B=0           $700                         BRIGHT RED
R=7 G=7 B=0           $770                         YELLOW
R=0 G=7 B=0           $070                         GREEN
R=4 G=0 B=7           $407                         VIOLET
R=7 G=7 B=7           $777                         WHITE
R=3 G=3 B=3           $333                         GREY
```

So if you want to make colour number 5 yellow, you would type:

```text
colour 5,$770
```

When this statement is executed, any graphics displayed on the screen which already use colour number 5 will be immediately changed to the new colour (yellow).

You can use the function form to produce a list of the current colour settings of your ST, like this:

```text
new
10 mcol=16:rem set mcol to 4 in medium res
20 for I=0 to mcol-1
30 print HEX$(colour(I),3)
40 next I
```

## PALETTE
`PALETTE list of colours` — Set the current screen colours.

The PALETTE instruction is really just a rather more powerful version of COLOUR. Instead of loading the colour values one at a time, the PALETTE command allows you to install a whole new palette of colours in a single line. This list can contain anything up to the maximum number of colours available in the current graphics mode.

### Example
To see PALETTE in action, type one of the lines below.

Invert the screen in high res:
```text
palette $777,$000
```
Use this line for medium res:
```text
palette $000,$700,$746,$534
```
Use this line for low res:
```text
palette $000,$700,$070,$007,$770,$077,$707,$777,$300,$030,$003,$330,$033,$303,$333,$345
```

## PLOT
`PLOT x,y [,index]` — Plot a single point.

- **x,y**: the coordinates of the point.
- **index**: optional colour index for the point. If the value of *index* isn't included, then PLOT will use the colour which was chosen using INK.

The simplest of the drawing functions provided by STOS Basic, PLOT sets any point on the screen to a specific colour.

### Example
In order to test this function on a colour monitor type:
```text
new
10 mode 0
20 plot rnd(319),rnd(199),rnd(15)
30 goto 20
```

### Gotchas
- PLOT fails with *Illegal function call* if either coordinate is off screen. Drawing commands do not clip: clamp coordinates to 0-319 / 0-199 (low res) before plotting points of a shape that extends past an edge (a wrapped rock whose centre is on screen but whose vertices are not).

## POINT
`c=POINT(x1,y1)` — Get the colour of a point.

- **x1,y1**: the coordinates of the point.
- **c**: returns the colour of the point at the coordinates *x1,y1*.

As with COLOUR, there is also a function to perform the reverse of PLOT. POINT returns the colour of the point at the coordinates *x1,y1* in the variable *c*.

## DRAW
`DRAW x1,y1 TO x2,y2` — Draw a line.

There are two forms of the DRAW statement:

- `DRAW x1,y1 TO x2,y2` — Draws a line between the coordinates *x1,y1* and *x2,y2*.
- `DRAW TO x3,y3` — Draws a line from the last line drawn, to *x3,y3*.

DRAW is another very basic instruction which allows you to draw a straight line on the ST's screen.

### Example
```text
new
5 colour 3,$707:ink 3
10 draw 0,50 to 200,50
20 draw to 100,100
30 draw to 0,50
```

### Gotchas
- In order to make DRAW operate at the maximum possible speed, this instruction has been restricted to a single line type. Because of this, any attempt to alter the line style using SET LINE will have no effect whatsoever.

**See also:** POLYLINE, INK

## BOX
`BOX x1,y1 TO x2,y2` — Draw a hollow rectangle on the screen.

- **x1,y1**: the coordinates of the top left hand corner of the box.
- **x2,y2**: the coordinates of the point diagonally opposite.

### Example
```text
box 10,10 to 200,100
```

**See also:** SET LINE, INK, BAR

## RBOX
`RBOX x1,y1 TO x2,y2` — Draw a rounded hollow box.

This is almost identical to BOX, except that the edges of the rectangle are rounded.

- **x1,y1**: the top right corner of the box.
- **x2,y2**: the bottom left corner.

RBOX is very useful for producing Macintosh-like borders around a piece of text.

### Example
```text
new
5 colour 3,$7:ink 3
10 rbox 156,100 to 245,130
20 locate 20,10: print "testing..."
```

**See also:** SET LINE, INK, RBAR

## POLYLINE
`POLYLINE x1,y1 TO x2,y2 TO x3,y3 ...` — Multiple line drawing.

- **x1,y1**: coordinates of point 1.
- **x2,y2**: coordinates of point 2.
- **x3,y3**: coordinates of point 3.

POLYLINE is a very powerful instruction indeed as it enables you to generate complex hollow polygons using just a single line of code. POLYLINE first draws a line from point 1 to point 2, and then another line from point 2 to point 3. It then repeats this procedure, and draws a line between each successive pair of points until it reaches the end of the list. This means that POLYLINE is roughly equivalent to:
```text
draw x1,y1 to x2,y2
draw to x3,y3
```

### Example
Now type in the following line, which draws a triangle on the ST's screen:
```text
polyline 0,20 to 200,20 to 100,100 to 0,20
```
Notice how four pairs of coordinates are been used to draw three lines. As a general rule, in order to create a closed polygon, the last group of coordinates should always be the same as the first.

**See also:** SET LINE, INK, POLYGON

## ARC
`ARC x1,y1,r,startangle,endangle` — Draw a circular arc.

- **x1,y1**: the coordinates of the centre of the circle.
- **r**: the radius.
- **startangle**: the angle the arc should be started from.
- **endangle**: the angle at which it should finish.

ARC draws a segment of a circle on the screen. Angles are measured in units of a tenth of a degree, and can therefore range from 0 to 3600. Think of a clockface — an angle of 0 would correspond to the direction pointed at by the short hand at three o'clock. Also, since STOS measures all the angles in an anti-clockwise direction, an angle of 900 would be represented by a time of twelve o'clock, and the maximum angle (3599) would be at approximately 3:01.

### Example
```text
new
10 draw 100,120 to 190,120
20 for a=0 to 3600 step 10
30 arc 100,120,90,0,a
40 next a
```
Notice that this function is also able to produce an unfilled circle:
```text
arc x1,y1,r,0,3600
```
Try:
```text
arc 100,100,100,0,3600
```

**See also:** SET LINE, INK, PIE, CIRCLE

## EARC
`EARC x1,y1,r1,r2,startangle,endangle` — Draw an elliptical arc.

- **x1,y1**: the coordinates of the centre of the arc.
- **r1, r2**: specify the size of the two radii of the ellipse.
- **startangle, endangle**: the angles of the start and the end of the arc.

The EARC instruction is very similar to ARC, but produces an elliptical arc rather than a circular one. If you're not mathematically minded, it may help to consider *r2* to be the vertical part of the radius, and *r1* the horizontal. When *r1* and *r2* are the same, the ellipse will be almost identical to a circle. If *r2* is much greater than *r1* then the ellipse will be tall and thin, and if the reverse is true, it will be short and wide.

You can use this function to draw a complete ellipse using:
```text
earc x1,y1,r1,r2,0,3600
```

### Example
```text
earc 100,100,30,50,0,3600
```
```text
new
10 cls:colour 1,$47:ink 1
20 draw 120,119 to 160,119
30 for R1=40 to 80 step 40
40 for R2=40 to 80 step 40
50 for A=0 to 3600 step 200
60 earc 120,119,R1,R2,0,A
70 next A
80 next R2
90 next R1
```

## SET LINE
`SET LINE mask,thickness,startpoint,endpoint` — Set the line styles.

- **mask**: the bitmap for the line; a 16-bit binary number which holds a so-called bitmap of the line. Points to be displayed in the ink colour are represented by the binary digit 1, and points to be set to the background colour are represented by a zero. Range 0 to 65535.
- **thickness**: ranges from 1 (very thin) to 40 (extremely wide).
- **startpoint, endpoint**: one of three styles to be used at the beginning and the end of every line: 0=SQUARED, 1=ARROWED, 2=ROUNDED.

So a normal line is denoted by the binary number `%1111111111111111` and a dotted line is produced by a mask of `%1111000011110000`. By setting the line mask to numbers between 0 and 65535 it is possible to generate an almost infinite variety of different line types.

### Example
```text
new
10 cls: colour 3,$770 : ink 3
20 set line %1111111111111111,10,0,1
25 rem A large arrow
30 arc 100,199,90,0,1800
35 rem A dotted diagonal line
40 set line %1111000011110000,1,0,0
50 polyline 200,60 to 300,100
55 rem A single large point
60 set line %1111111111111111,20,0,0
70 polyline 100,150 to 100,160
```
Notice how POLYLINE has been used instead of DRAW and POINT. This is because neither of these instructions are capable of using the line styles installed by SET LINE.

**See also:** INK, POLYLINE, BOX, RBOX, ARC, EARC

## PAINT
`PAINT x1,y1` — Contour fill.

- **x1,y1**: the coordinates of a point inside the object to be filled.

The PAINT command allows you to fill any existing hollow surfaces on the ST's screen with colour. As you might expect, this colour can be set with the INK instruction. In addition, you can also use SET PAINT to specify one of a number of different fill patterns.

### Example
```text
new
10 colour 3,$604:ink 3
20 box 0,10 to 100,100
30 box 50,60 to 150,150
40 ink 1
50 paint 70,70
```
PAINT will happily fill any surface you like providing it is completely enclosed by lines. If however, there is a gap in one of these lines, the fill colour will leak out into the rest of the screen. The effect of this can be seen by adding line 15 to the above example:
```text
15 set line %1111000011110000,1,0,0
```

### Gotchas
- PAINT corresponds directly to the FILL instruction found in other versions of Basic. Take care not to confuse the two as the STOS Basic FILL command has a very different effect!

## BAR
`BAR x1,y1 TO x2,y2` — Draw a filled rectangle.

- **x1,y1**: the coordinates of the top left corner of the bar.
- **x2,y2**: the coordinates of the corner diagonally opposite.

This draws a filled bar using the current ink colour.

### Example
```text
new
10 mode 0
20 X1=rnd(200):Y1=rnd(100):W=rnd(100):H=rnd(80)
30 ink rnd(15)
40 bar X1,Y1 to X1+W,Y1+H
50 goto 20
```

**See also:** RBAR, BOX, SET PAINT, INK

## RBAR
`RBAR x1,y1 TO x2,y2` — Draw a filled rounded rectangle.

- **x1,y1**: the starting corner of the bar.
- **x2,y2**: the coordinates of the corner diagonally opposite.

RBAR draws a filled and rounded rectangle on the screen.

### Example
If you've already typed the BAR example above, you can see how this works by changing line 40 to:
```stos
40 rbar X1,Y1 to X1+W,Y1+H
```

**See also:** BAR, BOX, SET PAINT, INK
## POLYGON
`POLYGON x1,y1 TO x2,y2 TO x3,y3 ...` — Draw a filled polygon.

- **x1,y1**: coordinates of point 1.
- **x2,y2**: coordinates of point 2.
- **x3,y3**: coordinates of point 3.

The POLYGON instruction is identical to POLYLINE except for the fact that it generates a filled shape rather than a hollow one. As usual the fill colour is set using INK, and the fill pattern with SET PAINT.

### Example
```text
polygon 0,20 to 200,20 to 100,100 to 0,20
```
Now type in lines 10 to 50:
```text
new
10 mode 0
20 ink rnd(15)
30 X1=rnd(200):Y1=rnd(100):H=rnd(100):W=rnd(90)
40 polygon X1,Y1 to X1+W,Y1 to X1+W/2,Y1+H to X1,Y1
50 goto 20
```
This program fills the screen with pretty coloured triangles.

**See also:** POLYLINE, INK, SET PAINT

## CIRCLE
`CIRCLE x1,y1,r` — Draw a filled circle.

- **x1,y1**: the centre of the circle.
- **r**: its radius.

### Example
```stos
10 mode 0
20 ink rnd(15)
30 X=rnd(200):Y=rnd(100):R=rnd(90)
40 circle X,Y,R
50 goto 20
```

**See also:** ARC, INK, SET PAINT

## PIE
`PIE x1,y1,r,startangle,endangle` — Produce a pie chart.

- **x1,y1**: the coordinates of the centre of the chart.
- **r**: its radius.
- **startangle, endangle**: range from 0 to 3600, where 0 is 3 o'clock, and angles increase in an anticlockwise direction.

PIE is used to draw a segment of a circle in the current fill colour. In practice it can be considered to be a solid version of ARC. Like ARC it needs two angles, which denote the starting and the ending points of the pie chart respectively.

### Example
```stos
10 rem Get free space on single density disc
20 rem Divide by 100 to convert into the range 0-3600 (approx)
30 rem Change to 200 for double sided drives
40 cls : colour 1,$700 : ink 1 : colour 3,$70
50 D=dfree
60 D=D/100
70 pen 3: locate 20,2: print "% Disk space free"
80 pen 1: locate 20,3: print "% Disk space used"
90 ink 3
100 pie 100,110,60,0,D
110 ink 1
120 pie 100,110,60,D,3600
```
This program displays the free space on the disc as a pie chart.

**See also:** ARC, INK, SET PAINT

## ELLIPSE
`ELLIPSE x1,y1,r1,r2` — Draw a filled ellipse.

- **x1,y1**: the coordinates of the centre of the ellipse.
- **r1, r2**: the two radii.

The ELLIPSE instruction is used to draw a filled ellipse in much the same way that CIRCLE produces a filled circle.

### Example
```text
new
10 mode 0
20 ink rnd(15)
30 X1=rnd(200):Y1=rnd(100):R1=rnd(90):R2=rnd(90)
40 ellipse X1,Y1,R1,R2
50 goto 20
```

**See also:** EARC, EPIE, INK, SET PAINT

## EPIE
`EPIE x1,y1,r1,r2,startangle,endangle` — Draw an elliptical pie.

- **x1,y1**: the coordinates of the centre of the segment.
- **r1, r2**: its two radii.
- **startangle, endangle**: range from 0 to 3600, and rotate in an anticlockwise direction.

This function corresponds directly to the EARC instruction and draws a solid elliptical pie chart. If the very idea of an elliptical pie chart seems ridiculous, we've included a couple of simple examples which may make you change your mind.

### Example
```text
epie 100,100,100,20,0,2225
epie 110,110,100,20,2225,3600
```
As you can see, the use of ellipses lends useful impression of depth to any pie chart.

If you've already typed in the pie chart example, try adding the following lines:
```stos
100 epie 200,110,90,10,0,D
120 epie 200,110,90,10,D,3600
```

## SET PAINT
`SET PAINT type, pattern, border` — Select fill pattern.

- **type**: can range from 0 to 4.
- **pattern**: a number which can range between 1 and 24 or 1 and 12 depending on whether DOTTED or LINED type has been selected. If neither of these types have been chosen, pattern should be set to 1.
- **border**: has just two possible values: 0 and 1. A border of 1 is used to indicate that the filled surface should be enclosed in a line of the current INK colour.

The effect of the various types can be found by inspecting the table below.

```text
Fill Type     Effect
0             Surface is not filled at all
1             Surface is filled with the current INK colour (solid)
2             Surface is filled with one of 24 dotted patterns
3             Surface is filled with one of 12 lined patterns
4             Surface is filled with a user-defined line pattern (See SET PATTERN)
```

The following program prints out the fill types associated with each of the different styles:
```text
new
10 rem Print out a list of dotted patterns
15 mode 0
20 for TYPE=2 to 3
30 if TYPE=2 then LIM=24 else LIM=12
40 for STYLE=1 to LIM
50 rem Set fill pattern with style number style and a border of 1
60 set paint TYPE,STYLE,1
70 rbar 0,0 to 310,180
80 locate 0,4:centre "Type "+str$(TYPE)+" Style " + str$(STYLE)
90 locate 0,6:centre "Press any key to continue"
100 wait key
110 next STYLE
120 next TYPE
```

### Gotchas
 - Do not confuse SET PAINT with SET PATTERN!

**See also:** CIRCLE, ELLIPSE, BAR, RBAR, PIE, EPIE, POLYGON

## SET PATTERN
`SET PATTERN address of pattern` — Set a user-defined fill pattern.

- **address of pattern**: the address in the ST's memory where the new pattern is to be found.

SET PATTERN is used to install the user-defined fill pattern specified with the instruction SET PAINT. Patterns can be stored in either a memory bank, a string or an array of integers. If you decide to store your pattern in a variable array, then you must always use the VARPTR instruction to calculate the address of this data, before you call SET PATTERN. So if the pattern was held in the string P$, you would use the instruction `SET PATTERN VARPTR(P$)`.

Each pattern is 16 points high by 16 points wide and takes up 16 two byte words of memory for each colour plane.

But how do you create this pattern in the first place? One particularly easy solution is to treat your fill pattern as just a 16 by 16 sprite. This allows you to draw any of your patterns using the sprite definer, and then load this sprite data into your program in the normal way.

```text
LOAD "PATTERN.MBK"
```
(Pattern can be any set of 16x16 sprites.)

Then all you need to do is work out the address of this data for use by SET PATTERN. This can be done with the following program:
```stos
10 rem Work out size of data
20 if mode=0 then PLANES=4
30 if mode=1 then PLANES=2
40 if mode=2 then PLANES=1
50 rem Get start of sprite information block
60 S=1 : rem Use image number 1. S can be any number up to the current number of sprites
70 rem Get start of sprite parameter block for image 1
90 SP=leek(start(1)+4*(mode+1))+start(1)+4
100 rem Get start of sprite parameter block for image S
110 SPB=SP+(S-1)*8
120 rem Get location of sprite image
130 POS=leek(SPB)+SP+32*PLANES
140 rem Choose user-defined fill pattern
150 set paint 4,1,1
160 rem Set user pattern to image in pos
170 set pattern POS
180 rem Test new fill pattern
190 circle 100,100,100
```

If you want to know how all this actually works, please refer to the technical reference section in Chapter 12.

## FLASH
`FLASH index,"(colour, delay)(colour, delay)(colour, delay)..."` — Set a flashing colour sequence.

- **index**: the number of the colour which is to be animated.
- **delay**: set in units of a 50th of second.
- **colour**: stored in the standard RGB format (See COLOUR for more details).

This command gives you the ability to periodically change the colour assigned to any colour index. It does this with an interrupt similar to that used by the sprite and the music instructions. The action of FLASH is to take each new colour from the list in turn, and then load it into the index for a length of time specified by the delay. When the end of this list is reached, the entire sequence of colours is repeated from the start.

### Gotchas
 - You are only allowed to use a maximum of 16 colour changes in any one FLASH instruction.

### Example
```text
flash 1,"(007,10)(000,10)"
```
This alternates colour number 1 between blue and black every 10/50 (1/5th) of a second.

Now for something more complex:
```text
flash 0,"(111,2)(333,2)(555,2)(777,2)(555,4)(333,4)"
```
If this gives you a headache, you will be glad to learn that you can turn the flashing off using the instruction:
```text
flash off
```

### Gotchas
 - On startup, colour number 2 is a flashing colour. It's therefore a good idea to turn this off before loading any pictures from the disc.

**See also:** SHIFT, INK

## SHIFT
`SHIFT Delay [,Start]` — Colour rotation.

- **Delay**: the delay between each rotation in 50ths of a second.
- **Start**: enables you to change only the colours with indeces greater than an initial value. If a starting value is not included in the instruction, then the rotation will begin from colour number 1.

SHIFT allows you to produce startling effects such as the famous Neochrome waterfall. It does this by rotating the entire palette of 512 colours into the 16 colour indeces using interrupts.

### Example
```text
shift 10
```

**See also:** FLASH, PALETTE, COLOUR

## GR WRITING
`GR WRITING mode` — Choose the graphics drawing mode.

- **mode**: can take the values from 1 to 4.

Whenever you draw some graphics on the ST's screen, you normally assume that anything underneath it will be overwritten. Sometimes this can be inconvenient, and in this case it's useful to have the ability to choose a slightly different method of drawing. STOS Basic provides a special instruction called GR WRITING for just this purpose.

 - **Replacement mode (mode=1)** — This is the default condition. Any existing graphics on the screen will be completely replaced by anything you draw over them.
 - **Transparent mode (mode=2)** — Transparent mode informs STOS that only the parts of the drawing which are actually set to a specific colour are to be plotted. This means that any points in the new drawing which have a colour of zero, are assumed to be transparent and are therefore omitted.
 - **XOR mode (mode=3)** — XOR combines your new graphics with those already on the screen, using a logical operation known as exclusive OR. The net result of this mode is to change the colour of the areas of a drawing which overlap an existing picture. One interesting side effect of XOR mode is that you can erase any object from the screen by simply setting XOR mode and drawing your object again at exactly the same place. This technique can be used to wipe complex polygons from the screen amazingly quickly.
 - **Inverse transparent (mode=4)** — As you might expect, this mode has the opposite effect of transparent mode, and only plots points with a colour of zero. All other points in the new picture are completely ignored.

### Example
```text
circle 100,100,100
gr writing 3
circle 100,100,100
```
Now type in the following small example:
```stos
5 mode 0
10 for I=1 to 4
20 cls
30 centre "Mode number "+str$(I)
40 gr writing I
50 set paint 1,1,1
60 bar 100,50 to 200,150
70 set paint 3,6,1
80 circle 150,100,50
90 locate 0,4:centre "Press Return to continue"
100 wait key
110 next I
```
This demonstrates the action of all four writing modes. Incidentally, the reason for the GR part of the instruction is to distinguish it from a similiar procedure called WRITING, which is used for the text operations.

### Gotchas
 - Do not confuse GR WRITING with the WRITING instruction used for text operations.

**See also:** AUTOBACK, WRITING

## POLYMARK
`POLYMARK x1,y1;x2,y2;x3,y3;...` — Plot a list of polymarkers.

- **x1,y1; x2,y2; x3,y3**: the coordinates of a list of markers to be printed on the screen.

Polymarkers are useful facilities normally provided by the Gem VDI, which enable you to plot lists of objects such as crosses, diamonds and squares as easily as a single point. Note that all polymarkers are drawn in the current INK colour. The marker type is assumed to be a "." by default, and can be changed using SET MARK.

### Example
```text
polymark 100,100;300,120
```
This draws two markers at 100,100 and 300,120.

**See also:** SET MARK, INK

## SET MARK
`SET MARK type, size` — Set the marker used by polymark.

- **type**: chooses the marker used by POLYMARK from a selection of six different marker types (see table).
- **size**: each polymarker can be drawn in eight sizes, ranging in 11 point increments from 6 to 83 pixels wide.

Here is a table which illustrates the various possibilities:

```text
Type Number     Marker Used
1               Point "."  Note this marker is only available in one size.
2               Plus sign "+"
3               Star "*"
4               Square
5               Diagonal cross
6               Diamond
```

### Example
```text
set mark 4,83
polymark 100,100;200,100;300,100
```
This produces three squares on the screen.

Here is a much larger example which generates all the possible marker types in each of the eight sizes.
```stos
10 rem Displays all six polymarkers
20 rem in each of their sizes
40 mode 0
50 rem Opens a window
60 windopen 5,0,0,40,12,2,3
70 centre "POLYMARKS" : locate 0,1: centre "Press a key"
80 rem Turn off cursor and mouse pointer
90 curs off: hide
100 for I=0 to 7
110 restore 240
120 for J=1 to 6
130 rem Change marker sizes in 11 point increments
140 set mark J,I*11+6
150 rem Get coordinates of mark
160 read X,Y
170 rem Draw a marker at X,Y
180 polymark X,Y
190 next J
200 wait key
210 next I
220 wait key
230 curs on : show
240 data 50,80,160,80,270,80
250 data 50,145,160,145,270,145
```
The square polymarkers are especially useful as they allow you to quickly create large grids on the ST's screen with just a few lines of code.

**See also:** POLYMARK, INK

## MODE
`MODE n` — Change the graphics mode.

- **n**: can be either 0 or 1.

In order to write programs capable of working in all three of the ST's graphics modes it's essential to be able to determine precisely which mode the ST is running in at any one time. Also, since some programs need to use a screen with the maximum possible size, it would be useful to have the ability to change between low and medium resolution when required. This feature is impossible using GEM, but in STOS Basic it's easy. To change from a low resolution screen to medium resolution you simply type `mode 1`. You are now in medium resolution. This instruction can also be placed in a STOS Basic program.

Note that since mode 2 requires a special high resolution screen, a value of 2 simply doesn't make sense.

### Gotchas
 - MODE will generate an error message if you try to use it on a monochrome monitor.

### Example
```stos
10 mode 1
```

There is also a MODE function which can be used to read the current graphics mode at any time.

### Example
```stos
10 if mode=2 then stop : rem This program will not work in high resolution
20 if mode=0 then mode=1 : rem Enter medium resolution
30 centre "Medium Resolution"
40 locate 0,4:centre "Press a key"
50 wait key
60 locate 0,4:centre "Press a key"
70 centre "Low resolution"
80 wait key
```

## DIVX
`DIVX` — Reserved variable holding the current display width as a fraction of the mono mode width.

Supposing you want to write a single program capable of working in all three resolutions. There are two problems you will encounter in this situation: the different number of available colours and the incompatible screen sizes. It's easy enough to solve the first difficulty just by limiting the number of colours to 2. But how do you beat the second problem? STOS Basic provides you with an answer in the variables DIVX and DIVY which hold two numbers denoting the current width and height of the display area, expressed as a fraction of those used in mono mode. Here is a small table showing the values these variables will take in all three graphics modes.

```text
MODE     Resolution     DIVX     DIVY
0        Low            2        2
1        Medium         1        2
2        High           1        1
```

To draw graphics which look equally good in any resolution, all you now need to do is to assume the screen is 640 by 400, and divide all your X coordinates by DIVX and your Y coordinates by DIVY.

### Example
```text
rbox 0,0 to 639/divx,399/divy
```
This fills the screen with a rounded box whatever graphics mode your ST is running under.

Now for a rather larger example:
```stos
1 rem Simple graphics demo
10 cls
20 COLS=15: rem Assume low res at the start
30 rem Now test for medium res
40 if mode=1 then COLS=3
50 rem And for high res
55 if mode=2 then COLS=1
60 X1=rnd(319):Y1=rnd(199):W=rnd(319):H=rnd(199):C=rnd(COLS):TYPE=rnd(2)
70 ink C
80 if TYPE=1 then X2=X1+W:Y2=Y1+H:box X1/divx,Y1/divy to X2/divx,Y2/divy
90 if TYPE=2 then X2=X1+W:Y2=Y1+H:rbox X1/divx,Y1/divy to X2/divx,Y2/divy
100 goto 60
```

**See also:** DIVY, MODE

## DIVY
`DIVY` — Reserved variable holding the current display height as a fraction of the mono mode height.

DIVY holds the vertical counterpart to DIVX. Together DIVX and DIVY allow a single program to size its graphics correctly in any of the three ST graphics modes; divide your Y coordinates by DIVY to scale them to the current mode. See the DIVX entry for the full table of values per mode and a worked example.

**See also:** DIVX, MODE

## CLIP
`CLIP x1,y1 TO x2,y2` — Restrict all graphics to part of the screen.

- **x1,y1**: the top left hand corner of the rectangle.
- **x2,y2**: the coordinates of the corner diagonally opposite this point.

The CLIP instruction is used to restrict the actions of all the graphics commands to a rectangular region of the screen. If you attempt to draw anything outside this area, your object will be clipped to fit in this rectangle.

### Example
```text
new
10 cls
20 clip 50,50 to 150,150
30 box 50,50 to 150,150
40 circle 100,100,100
```
As you can see, any parts of the circle outside the clipping rectangle haven't been drawn.

This instruction is often used in conjunction with the STOS windows.

In order to turn the clipping off, simply type:
```text
CLIP OFF
```

