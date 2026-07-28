# STOS commands: sprites

## SPRITE
`SPRITE n,x,y,p` — Displays a sprite on the screen.

- **n**: the number of the sprite, from 1 to 15. This number identifies the sprite in any subsequent calls to the MOVE and ANIM instructions.
- **x**, **y**: the coordinates of the point on the screen where the sprite is to be drawn. Unlike normal screen coordinates, these can take NEGATIVE values: x can vary from -640 to +1280, and y from -400 to +800. This allows you to move the sprite off screen without causing an error.
- **p**: specifies which of the images in bank 1 is to be used for a particular sprite. The only limit to the number of these images is the amount of available memory.

Each sprite has an invisible handle through which it can be manipulated, called a Hot Spot. Whenever a sprite is drawn, its coordinates are specified in terms of the position of this point on the screen. By default the hot spot is set to the top left hand corner of the image, but this can be changed using a special option from the Sprite definer accessory.

The SPRITE command effectively does two separate things: not only does it draw a sprite on the screen, it also determines which image will be associated with each of the 15 sprite numbers.

### Example
A number of example sprites have been placed on the accessory disc. You can load one of these sets using the LOAD instruction like so:

```text
load "fontset.mbk"
```

This loads a collection of sprites which depict the various letters of the alphabet. Now let's display some of these sprites on the screen.

```text
mode 0:rem These sprites are designed for low resolution flash off
palette 0,$777,$444
```

```text
sprite 1,100,100,6:rem Displays a 1 character at 100,100 as sprite 1
sprite 2,10,50,6:rem Displays another sprite with the same image
sprite 1,100,100,7:rem Change sprite 1 from a 1 to a 2
sprite 3,-10,100,5:rem Demonstrates the use of negative coordinates
```

### Gotchas
- You must always use this instruction BEFORE moving or animating a sprite.

## MOVE X
`MOVE X n,m$` — Move a sprite horizontally.

- **n**: the number of a sprite you have previously installed using SPRITE; can range from 1-15.
- **m$**: contains a sequence of commands which together determine both the speed and direction of the sprite.

Defines a list of horizontal movements which will be subsequently performed by sprite number n. Any of the STOS Basic sprites can be moved across the screen using interrupts, without affecting the execution of your Basic program in the slightest. The movements are executed automatically by STOS Basic every 50th of a second (70th for high resolution). There are two main versions of this command, one for horizontal motions (MOVE X), and another for vertical movements (MOVE Y); these can be combined to produce intricate patterns on the screen.

Each instruction in the movement string is split into three separate components:

- **SPEED**: the delay in 50ths of a second between each successive sprite movement. The speed can vary from 1 (very fast) to 32767 (incredibly slow).
- **STEP**: how many pixels the sprite will be moved in each operation. If this step is positive the sprite will move to the right, and if it is negative to the left. The apparent speed of the sprite depends on a combination of the speed and step. Large displacements coupled with a moderate speed will move the sprite quickly but jerkily across the screen; a small step size combined with a high speed will also move the sprite very fast, but the motion will be much smoother. The fastest speeds can be obtained with displacements of about 10 (or -10).
- **COUNT**: the number of steps which will be completed in a single movement. Possible values range from 0 to 32767. If you use a COUNT of 0, the motion will be repeated indefinitely.

These three elements are placed into the movement string using the format `(speed,step,count)`. Any number of these individual movements can be combined into a single MOVE command; they will then be executed in turn, one after another.

Two other directives are available. The L instruction (for loop) jumps back to the start of the list and reruns the entire sequence again from the beginning. The E command stops the sprite whenever it reaches a specific position on the screen; the most common use of this instruction is to halt a sprite which has been defined with a count of zero at a particular point. An endpoint can also be used in conjunction with the L command, which stops the sprite and then executes the series of movements again from the start. An optional starting position can also be added to the movement, written as a number before the first bracket (for example `"100(1,1,0)L200"` starts the sequence at position 100); this returns the sprite back to its original location, and therefore allows you to loop the sprite repeatedly through a precise section of the screen.

### Example
Load a set of sprites from the accessory disc with:

```text
load "fontset.mbk"
```

Now define sprite 1 using the SPRITE instruction like so:

```text
sprite 1,10,100,1
```

We can move this sprite with MOVE X:

```text
move x 1,"(1,3,50)"
```

When we execute the above command, we find to our surprise that nothing happens. This is because we need to first initiate the motion using a special MOVE ON instruction.

```text
move on
```

The sprite now progresses steadily across the screen. Combining movements:

```text
move x 1,"(1,1,100)(1,-1,100)"
move on
```

This moves the sprite from left to right, and back again.

The L instruction:

```text
sprite 1,10,100,5:rem Define Sprite 5
move x 1,"(1,5,60)(1,-5,60)L"
move on
```

The E command:

```text
sprite 1,10,100,5
move x 1,"(1,5,30)E100"
move on
```

Halting a sprite which has been defined with a count of zero at a particular point:

```text
sprite 1,10,100,5
move x 1,"(1,5,0)E200"
move on
```

An endpoint in conjunction with the L command:

```text
sprite 1,10,100,5
move x 1,"(1,5,30)L100"
move on
```

### Gotchas
- MOVE X alone does not start the motion: nothing happens until you initiate the movement with MOVE ON.
- Endpoints will only work if the x coordinate of the sprite exactly reaches the value you originally designated in the instruction. If the increment is badly chosen, the sprite will leap past the endpoint in a single step, and the test will therefore always fail.

**See also:** MOVE ON, MOVE Y, MOVE FREEZE, MOVON, ANIM, SPRITE, UPDATE

## MOVE Y
`MOVE Y n,m$` — Move a sprite vertically.

- **n**: the number of a sprite you have previously installed using SPRITE; can range from 1-15.
- **m$**: the movement string, using the same format as MOVE X.

This instruction complements the MOVE X command by enabling you to move a sprite through a complex series of vertical manoeuvres. The movement string uses an identical format to MOVE X, except that positive displacements now correspond to a downward motion, and negative steps to an upward movement.

### Example
Load a set of sprites and install sprite 1, then loop it vertically:

```text
load "fontset.mbk":rem Load sprites from accessory disc
sprite 1,100,10,5:rem Install sprite
move y 1,"10(1,1,180)L":rem Loop sprite from 10,10 to 190,10 continually
```

The leading 10 is the optional starting position (see MOVE X): the sprite starts at y=10, moves down 1 pixel per step for 180 steps (to y=190), and the L directive loops the movement indefinitely.

An up-and-down movement:

```text
sprite 1,100,100,1
move y 1,"(1,4,25)(1,-4,25)":rem moves sprite up and down
```

### Combining horizontal and vertical movements
Any list of horizontal and vertical movements may be combined with ease. Split the movement into separate horizontal and vertical components, and then assign these to individual MOVE X and MOVE Y instructions.

```text
new
load "fontset.mbk":rem From accessory disc
sprite 1,0,0,22
move x 1,"(1,4,79)(1,-4,79)L"
move y 1,"(1,4,49)(1,-4,49)L"
move on
```

A larger example — an exploding title:

```text
new
load "fontset.mbk"
5 rem Exploding Title
10 cls: click off
20 for I=1 to 10
30 read C : sprite I,I*16+80,100,C:rem Install sprites in centre of screen
35 rem Set alternate characters moving in different vertical directions
40 if I mod 2=0 then V$="(1,-2,0)" else V$="(1,2,0)"
45 rem Set left half moving left and right half moving right
50 if I<6 then H$="(1,-2,0)" else H$="(1,2,0)"
55 rem Set up Vertical and Horizontal components
60 move x I,H$: move y I,V$
70 next I
80 wait key : boom : move on:rem Wait for a keypress and move sprites
85 rem Image Numbers of Sprites which make up title
90 data 40,41,36,40,18,23,22,40,30,24
```

**See also:** MOVE X, MOVE ON, ANIM, SPRITE

## MOVE ON/OFF
`MOVE ON/OFF [n]` — Start or stop sprite movements.

- **n**: optional, a sprite number from 1-15 selecting a single sprite to start or stop.

Before any sprite movements you have defined with the MOVE X and MOVE Y commands will be performed, they need to be initiated with this instruction. If *n* is omitted then all the movement sequences you have currently assigned will be activated simultaneously.

Similarly, MOVE OFF stops the movements of the sprites in exactly the same way.

### Gotchas
- Do not confuse MOVE ON with the MOVON function.

**See also:** MOVE X, MOVE Y, OFF

## MOVE FREEZE
`MOVE FREEZE [n]` — Temporarily suspend sprite movements.

- **n**: optional, the number of a single sprite you wish to freeze.

This command can be used to temporarily halt some or all of the sprites which are currently moving. They can be restarted again using MOVE ON.

### Example
```text
load "fontset.mbk":rem From accessory disc
sprite 1,0,0,1
move x 1,"(1,4,64)(1,-4,64)L"
move on
move freeze
move on
```

## MOVON
`x=MOVON(n)` — Return whether a sprite is currently in motion.

- **n**: the number of the sprite to test.
- **x**: receives a non-zero value if sprite *n* is currently moving, or 0 (FALSE) if it is stationary.

This function returns a non-zero number if sprite number *n* is currently in motion and 0 (FALSE) if it is stationary.

### Example
```text
load "fontset.mbk":rem From accessory disc
move x 1,"(1,4,0)":move on
print movon(1)
move off
print movon(1)
```

### Gotchas
- Do not confuse with the MOVE ON command.

## X SPRITE
`x1=X SPRITE(n)` — Get the current X coordinate of a sprite.

- **n**: the number of the sprite (1-15).
- **x1**: receives the current X coordinate of sprite *n*.

Returns the current X coordinate of sprite *n*. This command is frequently used as a way of detecting whether a sprite has collided with the edge of the ST's screen.

### Example
```text
load "fontset.mbk"
sprite 1,0,40,1
move x 1,"10(1,1,0)L320"
move on
for i=1 to 100:locate 0,0:print x sprite(1):next i
```

**See also:** Y SPRITE, X MOUSE, Y MOUSE

## Y SPRITE
`y1=Y SPRITE(n)` — Get the current Y coordinate of a sprite.

- **n**: the number of the sprite (1-15).
- **y1**: receives the current Y coordinate of sprite *n*.

This is very similar to the X SPRITE instruction, except that it returns the Y coordinate rather than the X coordinate. This command is often utilised to check whether a missile has passed off the top or bottom of the screen.

### Example
```text
load "fontset.mbk"
sprite 2,0,0,35
move y 2,"0(1,1,0)L200"
move on
for i=1 to 100:locate 0,0:print y sprite(2):next i
```

A further example of this function can be found in the section on collision.

**See also:** X SPRITE, X MOUSE, Y MOUSE

## LIMIT SPRITE
`LIMIT SPRITE x1,y1 TO x2,y2` — Limit sprites to a specific area of the screen.

- **x1**, **y1**: the top left corner of the zone.
- **x2**, **y2**: the point diagonally opposite.

Defines the area of the screen on which the sprites will be displayed. Whenever they move outside this area, they will disappear from the screen. Note that unlike LIMIT MOUSE, this command does NOT limit the actual movements of the sprites, only their visibility.

All the X coordinates used in this command are automatically rounded down to their nearest multiple of 16.

### Example
```text
load "fontset.mbk"
sprite 1,0,0,1
move x 1,"0(1,1,0)L320"
move y 1,"0(1,1,0)L200"
move on
limit sprite 100,50 TO 200,150
```

In order to return the sprites to normal, simply enter a LIMIT SPRITE command with no parameters:

```text
limit sprite
```

**See also:** LIMIT MOUSE, CLIP

## ANIM
`ANIM n,a$` — Animate a sprite.

- **n**: the number of the sprite to be animated.
- **a$**: a list of animation commands to be carried out.

This enables you to page through a chain of sprite images one after another. This sequence will be executed at the same time as your sprite is being displayed, even if it is also being moved using MOVE.

The string *a$* contains the set of instructions to the ANIM command. Each operation is split into two separate components enclosed between brackets:

- **IMAGE**: the image number of the sprite to be displayed during each step of the animation.
- **DELAY**: the amount of time the image will be held on the screen before the next image is displayed. This delay is input in units of a 50th of a second (70th for monochrome systems).

### Example
A typical example:

```text
anim 1,"(1,10)(2,10)"
```

This would display image number 1 for 10/50 of a second (1/5 of a second), and then flick to image number 2.

Just as with the MOVE instruction, there is also an L directive which enables you to repeat these animations:

```text
anim 1,"(1,10)(2,10)L"
```

For a real example, we can use some of the sequences utilized by Zoltar. Before we can play with these sprites, we first need to grab them out of the game. Load Zoltar from the Game disc, place a fresh disc in the drive, and save the sprite bank in a separate file:

```text
load "\zoltar\zoltar.bas"
save "zsprites.mbk",1
new
load "zsprites.mbk"
```

To list the images currently available, type the following small routine:

```text
10 mode 0:cls: flash off
20 palette $0,$222,$333,$444,$555,$777,$7,$47,$770,$350,$300,$500,$700,$515,$770,$777
30 for i=1 to 30:sprite 1,100,100,i:print i:wait key:next i
```

Note that the palette command in line 20 was discovered by searching through Zoltar with `search "palette $"`.

If you run this program you will see that images 14 to 18 form a rather nice explosion. Animate it by replacing line 30 with:

```text
120 sprite 3,100,100,14:anim 3,"(14,2)(15,2)(16,2)(17,2)(18,2)":anim on
```

Add an L instruction to repeat the animation more clearly:

```text
120 sprite 3,100,100,14:anim 3,"(14,2)(15,2)(16,2)(17,2)(18,2)L":anim on
```

The large line number 120 is used to allow the program to be expanded later. Another interesting arrangement can be created using images 2 and 3, which combine to produce one of Zoltar's wiggling missiles. Animate and move it up the screen:

```text
30 sprite 1,160,198,2:anim 1,"(2,1)(3,1)L":anim on
40 move y 1,"196(1,-4,50)L":move on
```

The spaceship sprites are groups of three sprites starting from image 19. Add one of these ships:

```text
50 sprite 2,0,40,9 : anim 2,"(19,4)(20,4)(21,4)L"
60 move x 2,"(1,4,80)(1,-4,80)L" : move on 2:anim on
```

When you run this program, the missile fires and the ship moves from left to right. Save it for later (it will be modified in the section on collision):

```text
save "ship.bas"
```

**See also:** ANIM ON/OFF, ANIM FREEZE, MOVE, SPRITE

## ANIM ON/OFF
`ANIM ON/OFF [n]` — Start or stop an animation.

- **n**: optional, the number of an individual sprite to be animated.

Used to activate a series of animations defined using the ANIM command. If *n* is omitted then all the animation sequences you have created will be initiated at the same time.

ANIM OFF [*n*] stops one or all of the animations begun by ANIM ON.

## ANIM FREEZE
`ANIM FREEZE [n]` — Freeze an animation.

- **n**: optional, the number of a single animation sequence to suspend.

This command temporarily pauses the current animations on the screen. If the optional *n* is included, only a single animation sequence will be suspended. Otherwise all the animations will be frozen. They can be restarted again with the ANIM ON instruction.

## CHANGE MOUSE
`CHANGE MOUSE m` — Change the shape of the mouse pointer.

- **m**: a number selecting the mouse shape. Values 1-3 select the built-in defaults; values greater than 3 select an image stored in the sprite bank, with the image number given by the expression l=m-3.

This allows you to completely redesign the shape of the mouse at any time. Three forms are already installed into the system as a default, and are given the numbers 1 through 3:

| m | Shape |
|---|---|
| 1 | Arrow. (Default) |
| 2 | Pointing Hand |
| 3 | Clock |

If you specify a value of *m* greater than 3, this is assumed to refer to an image stored in the sprite bank. The number of this image is determined using the expression l=m-3. So image number one would be installed by a value of four, and image two would be signified by a five.

### Example
Load the sprites from the file `fontset` on the accessory disc:

```text
load "fontset.mbk"
```

Assign image 5 to the mouse:

```text
change mouse 8
```

Set the mouse to a capital S:

```text
change mouse 43
```

Another powerful option is to change the default definitions for the mouse which are stored on the disc, in the file `/STOS/MOUSE.SPR` on the systems disc. You can replace these with another set like this:

- Define three sets of sprites, for EACH resolution. If you only want to affect one resolution, it's best to modify the sprites in `SPRDEMO.MBK` (from the accessory disc), as this already contains a bank of sprites in the correct format.
- Load these sprites into bank 1 using either LOAD or the QUIT and GRAB options from the Sprite definer.
- Place a copy of the STOS Basic system disc in the drive. DO NOT USE THE ORIGINAL SYSTEMS DISC FOR THIS PURPOSE!

Now type:

```text
bsave "\stos\mouse.spr",start(1) to start(1)+length(1)
```

Whenever you subsequently load STOS Basic, the new mouse pointers will be automatically utilized by the system.

**See also:** HIDE, SHOW, X MOUSE, Y MOUSE, MOUSE KEY, LIMIT MOUSE

## X MOUSE
`x1=X MOUSE` — Get the X coordinate of the mouse pointer.

- **x1**: receives the current X coordinate of the mouse pointer.

This function returns the current X coordinate of the mouse pointer.

### Example
```text
new
10 home
20 print x mouse
30 wait vbl:rem Stop print interfering with mouse pointer
40 if inkey$="" then 20:rem Wait for keypress from keyboard
```

## Y MOUSE
`y1=Y MOUSE` — Get the Y coordinate of the mouse pointer.

- **y1**: receives the current Y coordinate of the mouse pointer.

This function simply returns the current Y coordinate of the mouse pointer.

### Example
```text
new
10 home
20 print y mouse
30 wait vbl:rem Stop print interfering with mouse pointer
40 if inkey$="" then 20:rem Wait for keypress from keyboard
```

## MOUSE KEY
`k=MOUSE KEY` — Get the status of the mouse buttons.

- **k**: receives a value indicating which mouse button(s) are currently pressed.

Enables you to quickly test whether one or both of the mouse buttons have been pressed. It returns one of the following four numbers depending on the current state of the keys:

| Value | Meaning |
|---|---|
| 0 | No button has been pressed |
| 1 | Left button pressed |
| 2 | Right button pressed |
| 3 | Both buttons pressed |

### Example
```stos
10 if mouse key = 1 then print "Left button"
20 if mouse key = 2 then print "Right button"
30 if mouse key = 3 then print "Left and Right button"
40 goto 10
```

**See also:** X MOUSE, Y MOUSE

## LIMIT MOUSE
`LIMIT MOUSE x1,y1 TO x2,y2` — Limit the mouse to a section of the screen.

- **x1**, **y1**: the top left hand corner of the box.
- **x2**, **y2**: the point diagonally opposite.

Restricts the mouse to the rectangular area defined by the coordinates (x1,y1) and (x2,y2). Note that LIMIT MOUSE always repositions the mouse pointer at the centre of the box. Also, unlike LIMIT SPRITE, the mouse is completely trapped inside this zone and cannot be moved anywhere else on the screen.

### Example
```text
limit mouse 50,50 to 250,150
```

In order to restore the mouse to normal, simply use the instruction with no parameters:

```text
limit mouse
```

## HIDE
`HIDE` / `HIDE ON` — Remove mouse pointer from the screen.

This command permits you to remove the mouse pointer from the screen at any
time. A count of the number of occasions you have called this function is
automatically kept by the system. This number needs to be matched by an equal
number of SHOW instructions before the mouse will be returned for your use.
There's another version of this instruction which can be accessed with HIDE ON.
This ignores the count completely and ALWAYS hides the mouse.

### Example
```text
hide
hide
show
show
show
show
hide on
```

### Gotchas
- HIDE only makes the mouse pointer invisible. It does NOT deactivate it fully.
  You can therefore readily use the X MOUSE and Y MOUSE functions to read the
  position of the mouse, even if it is totally hidden from view.

**See also:** SHOW

## SHOW
`SHOW` / `SHOW ON` — Activate the mouse pointer.

This redisplays the mouse hidden with the HIDE instruction. As with HIDE
there's also a version of SHOW which shows the mouse, no matter how many HIDE
commands have been executed. This is called using SHOW ON.

### Example
```text
show on
```

**See also:** HIDE

## JOY
`d=JOY` — Read joystick.

This function returns a binary number which represents the current status of
the joystick. Each of these bits is set to 1 if the test proves positive and
otherwise zero:

- Bit 0: joystick moved up
- Bit 1: joystick moved down
- Bit 2: joystick moved left
- Bit 3: joystick moved right
- Bit 4: fire button pressed

If you are not familiar with this binary notation you can also access each of
the directions individually with the functions JLEFT, JRIGHT, JUP, JDOWN, and
FIRE.

### Example
Load the fontset from the accessory disc:
```text
load "fontset.mbk":rem From accessory disc
```
Then enter the program below. Note that it uses the variable S to set the
sensitivity of the joystick. Reasonable values range from 1 (low) to 5
(incredibly high).
```stos
10 rem Move a sprite with a joystick
20 rem Set direction arrays
30 dim DX(15),DY(15)
40 S=2 : X1=160 : Y1=100
50 for I=1 to 15 : read X,Y : DX(I)=X*S : DY(I)=Y*S : next I
60 sprite 1,X1,Y1,40 : J=joy and 15 : X1=X1+DX(J) : Y1=Y1+DY(J) : if joy>15 then X1=160 : Y1=100 : goto 60 else 60
70 data 0,-1,0,1,0,0,-1,0,-1,-1,-1,1
80 data 0,0,1,0,1,-1,1,1,0,0,0,0,0,0,0,0,0,0
```

### Gotchas
- The joystick must be placed in the right joystick socket.

**See also:** JLEFT, JRIGHT, JUP, JDOWN, FIRE

## JLEFT
`x=JLEFT` — Test joystick movement left.

JLEFT returns a value of TRUE (-1) if the joystick has been moved left,
otherwise FALSE (0). It can be used in an IF..THEN statement.

### Example
```text
if jleft then print "LEFT"
```

## JRIGHT
`x=JRIGHT` — Test joystick movement right.

JRIGHT tests the joystick and returns TRUE (-1) if it has been moved right,
otherwise it returns a value of FALSE (0).

**See also:** JLEFT, JUP, JDOWN

## JUP
`x=JUP` — Test joystick movement up.

JUP returns TRUE (-1) if the joystick has been moved up, otherwise FALSE (0).

**See also:** JRIGHT, JLEFT, JDOWN

## JDOWN
`x=JDOWN` — Test joystick movement down.

The JDOWN function returns the value TRUE (-1) if the joystick has been pulled
down, otherwise it returns FALSE (0).

**See also:** JRIGHT, JLEFT, JUP

## FIRE
`x=FIRE` — Test fire button state.

This function only returns a value of TRUE (-1) if the fire button on the
joystick has been pressed.

**See also:** JUP, JDOWN, JLEFT, JRIGHT, JOY

## COLLIDE
`t=COLLIDE(n,w,h)` — Detect collisions between two sprites.

- **n**: the sprite you wish to check; can range from 0-15, with 0 denoting the
  mouse pointer
- **w, h**: determine the sensitivity of the test; think of them as the width
  and height of a rectangular box starting from the Hot Spot of the sprite

This provides you with an easy way of testing to see whether two or more
sprites have collided on the screen. Whenever another sprite enters the box
defined by w and h, a collision will be detected.

t is a number in binary format which holds a list of the sprites which have
collided with sprite number n. Each bit in this number represents the status of
the equivalent sprite. So bit 1 indicates sprite 1, bit 5 denotes sprite 5 and
so on. If a collision occurs between sprite n and another sprite, the bit at
the appropriate point is set to 1. You can test for these bits using the BTST
function. If you're not technically minded, you can save yourself some trouble
by adding a statement which prints the value whenever a collision takes place,
and then test for the number printed:

### Example
```text
print collide(1,10,10)
```
```stos
100 if collide(2,10,10)=6 then boom
```

Here's an example of this function in action. If you've saved the program used
in the section on ANIM, you can load it with `load "ship.bas"`. Otherwise you
will first need to create the file zsprites.mbk in the following way:
```text
load "\zoltar\zoltar.bas":rem From the games disc
save "zsprites.mbk"
new
load "zsprites.mbk"
```

You can now enter the program below:
```stos
5 rem Initialize screen
10 mode 0 : cls : flash off
15 rem Set colours
20 palette $0,$222,$333,$444,$555,$777,$7,$47,$770,$350,$300,$500,$700,$515,$770,$777
25 rem Move and Animate Ship
30 sprite 2,0,40,19 : anim 2,"(19,4)(20,4)(21,4)L" : anim on 2
40 move x 2,"(1,6,80)(1,-6,80)L" : move on 2
45 rem Wait for a key press
50 wait key
55 rem Fire Missile
60 sprite 1,160,198,2 : anim 1,"(2,1)(3,1)L" : anim on
70 move y 1,"196(1,-4,60)" : move on
75 rem Test for collision
80 if collide(1,10,10)=6 then boom : goto 110
85 rem Test Missile to see if it flies off the top of the screen
90 if y sprite(1)<0 then 50
95 rem Jump Back to test
100 goto 80
105 rem Explosion
110 sprite 3,x sprite(2),40,14
120 anim 3,"(14,2)(15,2)(16,2)(17,2)(18,2)" : anim on : move off : sprite 1,-100,100,2 : sprite 2,-100,100,9 : sprite 3,-100,100,14
```

Add the following lines to the program above to incorporate a user-controlled
ship with the CHANGE MOUSE command:
```stos
21 limit mouse 0,150 to 319,198:rem Limit mouse to lower part of screen
41 change mouse 10 : rem Change mouse to picture of a ship
50 repeat : until mouse key : MX=x mouse : MY=y mouse : rem Wait for mouse button
60 sprite 1,MX,MY+4,2 : anim 1,"(2,1)(3,1)L" : anim on
130 move off : sprite 1,-100,100,2 : sprite 2,-100,100,9
140 sprite 3,-100,100,14 : goto 30
```

This gives you a ship which can be moved around with the mouse, which can fire
a missile when you press on the mouse key. You could easily detect collisions
with this ship in a similar way, just by adding a line such as:
```stos
81 if collide(0,10,10)<>1 then boom
```

## SET ZONE
`SET ZONE z,x1,y1 TO x2,y2` — Set a zone for testing.

- **z**: a number from 1-128 which represents the zone to be created
- **x1, y1**: coordinates of the top left hand corner of the rectangle
- **x2, y2**: coordinates of the bottom right hand corner of the rectangle

Defines one of 128 rectangular zones which can then be tested using the ZONE
command for the presence of either the mouse or a sprite.

**See also:** ZONE, RESET ZONE

## ZONE
`t=ZONE(n)` — Tests a sprite to see if it is in a zone.

- **n**: the sprite to search for; can range from 0 to 15, with the mouse
  being indicated by sprite number zero as usual

This searches for the presence of sprite n in the list of the zones defined
using SET ZONE. After the function has been called, t will hold either the
number of the zone where the sprite was detected or a value of zero.

### Example
```stos
5 rem Muzak
6 rem Reset zones and clear screen
10 reset zone : cls back : cls physic : mode 0
15 rem Set note type
20 volume 16 : envel 9,5000
25 rem Set fill style to hollow
30 set paint 0,1,0
40 for I=0 to 7 : for J=0 to 7
45 rem Draw box
50 box I*39,J*24 to (I+1)*39,(J+1)*24
55 rem Define zones
60 set zone I*8+J+1,I*39,J*24 to (I+1)*39,(J+1)*24
70 next J : next I
75 rem Test zone and play note
80 if zone(0) then play zone(0)+20,30
90 goto 80
```

### Gotchas
- ZONE only returns the FIRST zone which the sprite was found in. If two or
  more zones overlap, it is not possible to determine any other zones the
  sprite is also inside.

**See also:** SET ZONE, RESET ZONE

## RESET ZONE
`RESET ZONE [z]` — Erase a zone.

- **z**: optional zone number; if included, then only this zone will be reset

This command erases any of the zones created by SET ZONE. If the optional z is
omitted, all the zones will be deleted.

## DETECT
`c=DETECT(n)` — Find colour of pixel underneath sprite.

- **n**: the sprite to test; can range from 0 to 15, with a value of 0
  representing the mouse pointer

This is a very useful command which allows you to ascertain the colour of the
background pixel underneath sprite n. After the function has executed, c is
returned containing the colour of the point on the background screen underneath
the Hot Spot of the sprite. By bordering an object with a specific colour, and
then testing for this with DETECT, you can easily spot any collisions between
an irregular area and the sprite. Another possible application would be to
detect the collision of a laser beam with a sprite. This beam could be easily
created using the normal DRAW or POLYLINE commands.

### Example
```text
load "zsprites.mbk":rem See COLLIDE for full details of how to create this
```
```stos
10 rem Detect demo
20 key off : mode 0 : set line $FFFF,6,0,0
30 ink 2 : arc 160,198,150,0,1800 : ink 0
40 sprite 1,rnd(314)+2,0,2 : wait vbl
50 move y 1,"(1,4,1)L" : move on
60 C=detect(1)
65 if C=2 then wait vbl : XS=x sprite(1) : YS=y sprite(1) : box XS,YS-6 to XS+2,YS-2 : boom : goto 40
70 if y sprite(1)<200 then 60 else 40
```

## PUT SPRITE
`PUT SPRITE n` — Put a copy of a sprite on the screen.

- **n**: the number of the sprite to copy

Simply places a copy of sprite number n at its current position on the screen.
Note that the sprite you have copied is completely unaffected by this
instruction. Although you are confined to 15 moving sprites, PUT SPRITE and GET
SPRITE make it easy enough to produce the illusion of dozens of actual sprites
on the screen: create a number of copies of a sprite at once, and then just
grab the ones you wish to actually move around, as and when you need them. You
can add animation to these fake sprites using the SCREEN COPY and SCREEN SWAP
instructions.

### Example
Load the sprites in the file ZSPRITES.MBK (see COLLIDE for details):
```text
load "zsprites.mbk"
```
Then type in the following small program. It fills the screen with dozens of
copies of a single spaceship. You can turn these ships back into movable
sprites a few at a time, using GET SPRITE.
```stos
10 palette $0,$222,$333,$444,$555,$777,$7,$47,$770,$350,$300,$500,$700,$515,$770,$777
20 I=8 : mode 0 : cls : flash off : hide
30 wait vbl : sprite 1,I,22,1 : rem Draw ship on the screen
40 move x 1,"0(1,8,0)E320" : move on : wait vbl
50 X=x sprite(1) : if X mod 16=8 then put sprite 1 : wait vbl
60 if X=320 then I=I+16 else 50
70 if I<192 then 30 else 90
80 goto 50
90 limit mouse : sprite 1,-100,0,22 : wait key
```

**See also:** WAIT VBL, MOVE

## GET SPRITE
`GET SPRITE x,y,i [,mask]` — Load a section of the screen into the sprite bank.

- **x, y**: the start of the rectangular area to be captured
- **i**: the number of the image to be loaded; MUST refer to an image which
  already exists in the sprite bank. The size of the new image is taken from
  the original dimensions you specified using the sprite editor. The Hot Spot
  of the sprite is automatically set to the point x,y.
- **mask**: optional; specifies which colour in the new sprite is to be
  treated as transparent. If omitted, it is set to zero.

This instruction enables you to grab any images off the screen and turn them
into sprites. By changing the mask to a different colour you can generate a
number of interesting effects. This is because the mask colour is effectively
ORed with the background. A mask of zero will therefore simply display the area
underneath the sprite in the normal way. Otherwise the OR operation will
invariably change the colour of any of the background which shows through the
sprite.

### Example
Place the accessory disc in the drive and type `load "sprdemo.mbk"`, then
enter the following small program. It borrows one of the images in the
SPRDEMO file and loads it with the section of the screen underneath the mouse,
then assigns this sprite to the mouse:
```stos
10 Rem Big Mouse
20 repeat:until mouse key
30 hide
40 get sprite X mouse,Y mouse,2: change mouse 8:show
```

A slightly more interesting example involving some sprites which have been
placed on the screen with PUT SPRITE. Load the file ZSPRITES.MBK from your
disc (see COLLIDE for details of how this data can be created) with
`load "zsprites.mbk"`, then enter the program:
```stos
10 rem Set colours
20 palette $0,$222,$333,$444,$555,$777,$7,$47,$770,$350,$300,$500,$700,$515,$770,$777
25 rem Define Array P
30 dim P(20)
35 rem Reset Screen
40 hide : off : cls physic : cls back : ink 0
50 rem Copy 20 sprites on the screen
60 sprite 1,8,10,22 : rem Draw ship on the screen
70 move x 1,"8(1,4,0)E320" : move on
80 X=x sprite(1) : if X mod 16=4 then put sprite 1 : wait vbl
90 if X=320 then move off : goto 100 else 80
100 sprite 1,400,10,23 : wait key
105 rem Choose a sprite which hasn't moved
110 S=rnd(18)+1 : if P(S)=1 then 110 else P(S)=1
120 rem Get sprite
130 get sprite S*16+4,10,21
135 rem Move sprite down
140 sprite 1,S*16+4,10,21 : move y 1,"(1,4,50)" : move on
145 rem Erase sprites
150 bar S*16-4,2 to S*16+12,18
155 rem Test if sprite still falling
160 if movon(1)=0 then 110 else 160
```

This program places 20 copies of a spaceship on the screen and then animates
each one in turn in an apparent violation of the 16 sprite limit. With a
little more work you could easily expand the above technique to move up to 15
sprites at a time.

### Gotchas
- WARNING! This command will only work if the rectangle you are attempting to
  grab is completely inside the borders of the screen.
- The mask has a rather different action in monochrome mode. All monochrome
  sprites are given a special border on the screen. The thickness of this
  outline is usually set to a width of one pixel, but you can increase it by
  including a higher value as part of the mask.

## PRIORITY ON/OFF
`PRIORITY ON/OFF` — Toggle between the two sprite priority modes.

The priority of a sprite determines how sprites are displayed when they overlap on the screen: sprites with the higher priority always appear in front of sprites with a lower one. Normally, sprite priority is assumed to be in REVERSE order to the sprite numbers, so you should remember this fact when assigning numbers to your sprites. The mouse is effectively sprite number zero and therefore has the highest priority of all, which is why the mouse always passes in front of any other sprites on the screen.

`PRIORITY ON` activates an alternative priority system: the highest priority is given to the sprites with the largest Y coordinate. So a sprite at 100 would pass above a sprite at 99 and behind a sprite at 101. In practice this option allows you to create a useful illusion of perspective.

For the most effective results, it's usually best to position the Hot Spot of the sprite at its base, because the Y coordinates used by this command relate to the position of the Hot Spot on the screen. `PRIORITY OFF` can be used to reset the priority back to normal.

### Example
```text
load "zsprites.mbk":rem See COLLIDE for details
```

```stos
1 rem Test of priority
5 mode 0:cls:flash off:hide
10 priority off:rem Set normal mode
20 sprite 1,160,100,22:sprite 2,100,94,2
30 sprite 3,100,108,19
40 move x 2,"0(1,2,160)L":move x 3,"320(1,-2,160)L":move on
50 wait key
60 priority on:rem Set Y mode
```

In the normal mode both of the moving sprites pass below the ship in the centre. When you select the Y priority with `PRIORITY ON`, the sprites are now ranked in order of their increasing Y coordinates: sprite 3 moves above sprite 1, and sprite 2 passes behind it.

## AUTOBACK ON/OFF
`AUTOBACK ON/OFF` — Toggle whether graphics commands draw to both the physical screen and the sprite background.

Whenever a sprite is moved across the screen, it obscures some sections of the graphics and reveals others. This requires a copy of the area underneath the sprite to be held in the ST's memory. Rather than allocating a separate chunk of memory for each sprite, STOS Basic keeps a copy of the entire screen to serve as a background for the sprites. One important consequence of this approach is that the background screen and the normal screen must always contain exactly the same image — if they don't, the sprite will tend to corrupt the area of the screen underneath when it is moved. For this reason, all STOS Basic's graphics commands usually operate on both screens simultaneously.

The AUTOBACK command toggles between two drawing modes. As a default, all graphics are sent to both the sprite background and the physical screen. The autoback feature can be turned off using the AUTOBACK OFF instruction, which leads to a substantial speed improvement in most of the graphics commands. Similarly the original mode can be reactivated with a call to AUTOBACK ON. Furthermore, if your program doesn't use either the mouse pointer or the sprites, you can speed up all the graphics operations a great deal by just switching off the autoback feature using AUTOBACK OFF.

### Example
```text
cls
autoback on:rem Set automatic background
circle 100,100,100:rem Draws a filled circle on both screens
```
Now move the mouse around on the circle. As you can see, the circle remains unchanged.

Let's try drawing the circle with AUTOBACK turned off:
```text
cls
autoback off
circle 100,100,100:rem Draws a filled circle only on PHYSICAL screen.
```
If you now move the mouse on the circle, the circle will be steadily erased. This is because the sections underneath the mouse are being copied from a background screen in which the circle does not exist. By choosing the contents of the background and physical screen carefully, you can produce a number of interesting effects.

**See also:** BACK, PHYSIC, LOGIC

## UPDATE
`UPDATE` — Control the automatic redrawing of sprites.

Usually any sprites you draw on the screen will be automatically redisplayed whenever they are animated or moved. This feature can be temporarily halted using `UPDATE OFF`. When the updates are not active, the SPRITE, MOVE and ANIM commands apparently have no effect. In reality, they are still being operated on by the sprite instructions, but the results are simply not being displayed on the screen. You can force any sprites which have moved to be redrawn at their current positions using the `UPDATE` command like this:
```text
update
```

Three forms:

- `UPDATE OFF` — Turns off the automatic updating of the sprites. Any movements or animations appear to be suspended.
- `UPDATE` — Redraws any sprites which have changed at their new positions. This command can occasionally be substituted for the normal WAIT VBL after a PUT SPRITE instruction, as it is much faster.
- `UPDATE ON` — Returns the sprite updating to normal.

### Example
```text
new
load "sprdemo.mbk":rem Load some sprites
sprite 1,100,100,1:rem Install sprite at 100,100
move x 1,"(1,1,100)(1,-1,100)L":rem Move the sprite to and fro
move on
update off:rem Stop updates
```
Remember that whilst the sprite is not being updated, it is still moving. We can demonstrate this by updating the position with:
```text
update
```
To see how the sprite is progressing across the screen, type in this instruction several more times. We can now return the sprite movements to normal with:
```text
update
```

## REDRAW
`REDRAW` — Redraw all sprites at their current positions.

Redraws all the sprites at their current positions on the screen. Unlike UPDATE, it takes no account of whether the sprite has been changed since the last update.

## OFF
`OFF` — Turn off all sprites and sprite movements.

This turns off all the sprite movements and animations, and removes the sprites from the screen. It is often used to reset the editor after you have broken out of a program with Control+C. As a default it is assigned to function key f10.

## FREEZE
`FREEZE` — Temporarily halt all sprite and music operations.

Temporarily halts the actions of all the sprite commands and stops any music which is currently being played. To restart these activities again, simply type in the line:
```text
unfreeze
```

## UNFREEZE
`UNFREEZE` — Resume sprite and music operations halted by FREEZE.

Resumes any sprite movements and music halted by FREEZE.

