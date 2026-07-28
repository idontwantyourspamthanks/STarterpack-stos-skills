# STOS commands: text-windows

## PEN
`PEN index` — Set colour of text.

- **index**: a colour number; allowable values depend on the current graphics mode.

The PEN instruction allows you to specify the colour of any text which will subsequently be displayed in the current window. This colour can be chosen from one of up to 16 different colours. As you might expect, the number of colours available varies between the different graphics modes.

| Mode | Allowable index numbers |
| --- | --- |
| 0 (Low) | 0-15 |
| 1 (Medium) | 0-3 |
| 2 (High) | 0-1 |

As a default, the pen colour is set to index number 1.

### Example
```text
new
10 mode 0
20 for I=0 to 15
30 pen I
40 print "Pen number ";I;space$(10)
50 next I
60 pen 1
```

**See also:** COLOUR, PALETTE, PAPER

## PAPER
`PAPER index` — Set colour of background of text.

- **index**: a colour number from 0-15 (0-3 in medium resolution).

PAPER designates a colour to be used as the background for the text.

### Example
```text
new
10 mode 0
20 for I=0 to 15
30 paper I
40 print "Paper number ";I;space$(10)
50 next I
60 wait key
70 default
```

On startup the background of a window is set to colour 0.

**See also:** PEN, COLOUR, PALETTE

## INVERSE ON/OFF
`INVERSE ON/OFF` — Enter inverse mode.

- `INVERSE ON` — Swaps the text and background colours specified by PEN and PAPER, inverting any new text which is printed on the current window.
- `INVERSE OFF` — Returns to normal text rendering.

### Example
```text
new
10 print "This is some text in normal mode"
20 inverse on
30 print "This is some inverted text"
40 inverse off
```

**See also:** SHADE, UNDER, WRITING

## SHADE ON/OFF
`SHADE ON/OFF` — Shade all subsequent text.

- `SHADE ON` — Highlights any new text on a window by reducing the brightness of the characters with a mask.
- `SHADE OFF` — Returns to unshaded text.

### Example
```text
new
10 mode 1
20 print "Normal Text"
30 shade on
40 print "Shaded Text"
50 shade off
```

**See also:** UNDER, INVERSE, WRITING

## UNDER ON/OFF
`UNDER ON/OFF` — Set underline mode.

- `UNDER ON` — Causes the text in the current window to be underlined.
- `UNDER OFF` — Returns to non-underlined text.

### Example
```text
UNDER ON
? "UNDERLINED"
UNDERLINED
UNDER OFF
? "NORMAL"
NORMAL
```

**See also:** SHADE, INVERSE, WRITING

## WRITING
`WRITING effect` — Change text writing mode.

- **effect**: the writing mode to be used for all future text output.

The WRITING command allows you to change the writing mode used for all future text output.

| Writing mode | Effect |
| --- | --- |
| 1 | Replacement mode (Default) |
| 2 | OR mode. All characters are merged on the screen with a logical OR. |
| 3 | XOR mode. Characters combined with background using XOR. |

### Example
```text
new
5 mode 0
10 bar 0,0 to 319,199
20 print "Normal text"
30 writing 2
40 print "OR mode"
50 writing 3
60 print "XOR mode"
70 wait key
80 default
```

### Gotchas
- Do NOT confuse WRITING with GR WRITING.

**See also:** GR WRITING

## LOCATE
`LOCATE x,y` — Position the cursor.

- **x**, **y**: the text coordinates of the new cursor position.

LOCATE sets the current cursor position to the coordinates x and y. This sets the starting point for all future text operations on the screen. LOCATE uses a special type of coordinates known as text coordinates. These are measured in units of a single character, relative to the top left hand corner of the current window. So the coordinates 10,10 refer to a point 10 characters down from the top of the window, and 10 characters across from the left.

### Example
```text
locate 10,10:print "Hi"
```

The possible range of these coordinates varies depending on the dimensions of the window you are using, and the size of the character set. Here is a small table showing the size of the screen in text coordinates in each of the three graphics modes.

| Mode | X range | Y range |
| --- | --- | --- |
| 0 | 0-39 | 0-24 |
| 1 | 0-79 | 0-24 |
| 2 | 0-79 | 0-24 |

## XTEXT
`t=XTEXT(x)` — Convert an x coordinate from graphic format to text.

- **x**: a normal X coordinate ranging from 0-639 (0-319 in low res).
- **t**: the returned text coordinate relative to the current window.

This function takes a normal X coordinate and converts it to a text coordinate relative to the current window. If the screen coordinate lies outside the window then a negative value is returned.

### Example
```text
new
10 cls:print "Move the mouse about!"
20 repeat
30 X=xtext(x mouse): if X<0 then 60
40 Y=ytext(y mouse): if Y<0 then 60
50 locate X,Y: print "*":rem Print * at current mouse pointer.
60 until mouse key:rem Exit when a mouse button is clicked.
70 default
```

**See also:** YTEXT, LOCATE, WINDOPEN, XGRAPHIC, YGRAPHIC

## YTEXT
`t=YTEXT(y)` — Convert a y coordinate from a graphic format to text.

- **y**: a coordinate ranging from 0-199 (0-399 in high res).
- **t**: the returned text coordinate relative to the current window.

YTEXT converts a graphic y coordinate into a text coordinate relative to the current window. See XTEXT for more details.

**See also:** XTEXT, YGRAPHIC, XGRAPHIC, LOCATE

## XGRAPHIC
`g=XGRAPHIC(x)` — Convert an x coordinate from text format to graphic.

- **x**: a text coordinate ranging from 0 to the width of the current window.
- **g**: the returned absolute screen coordinate.

The XGRAPHIC function is effectively the inverse of XTEXT, in that it takes a text coordinate ranging from 0 to the width of the current window and converts it into an absolute screen coordinate. Note that there's also an equivalent function for Y coordinates called YGRAPHIC.

### Example
```text
new
5 mode 0 :ink 1
10 windopen 1,3,3,30,10
20 print xgraphic(0),ygraphic(0)
30 draw xgraphic(0),ygraphic(0) to xgraphic(27),ygraphic(7)
40 wait key
50 windel 1
```

**See also:** XTEXT, YTEXT, YGRAPHIC

## YGRAPHIC
`g=YGRAPHIC(y)` — Convert a y coordinate from text format to graphic coordinate.

- **y**: a text coordinate relative to the current window.
- **g**: the returned absolute screen coordinate.

This function converts a coordinate in text format relative to the current window into an absolute screen coordinate.

**See also:** XGRAPHIC, XTEXT, YTEXT

## SQUARE
`SQUARE wx,hy,border` — Draw a rectangle at the current cursor position.

- **wx**: the width of the rectangle in characters.
- **hy**: the height of the rectangle in characters.
- **border**: any of the 16 possible border types used by the windows (see BORDER).

SQUARE draws a rectangle wx characters wide by hy characters high at the cursor position. wx and hy can range from 3 to the size of the current window. After this instruction has been executed, the text cursor is placed at the top left corner of the new box.

### Example
```stos
10 square 10,10,3
20 print "Square "
```

A slightly larger example, which shows off all the 15 different border types:

```stos
10 cls
20 for I=1 to 15
30 locate I*2,20-I
40 square I+3,I+3,I
50 next I
60 goto 60
```

**See also:** BORDER, XTEXT, YTEXT

## HOME
`HOME` — Cursor home.

HOME moves the text cursor to the top left hand corner of the current window (coordinates 0,0).

### Example
```stos
10 cls
20 locate 10,10
30 print "Demonstration of "
40 home
50 print "HOME"
```

**See also:** LOCATE, XCURS, YCURS

## CDOWN
`CDOWN` — Cursor down.

CDOWN pushes the text cursor down one line. The same effect can also be achieved using the line `print chr$(10)`.

### Example
```text
print "Example":cdown:cdown:print "of cdown"
```

**See also:** CUP, CLEFT, CRIGHT

## CUP
`CUP` — Cursor up.

CUP moves the text cursor up by a line, in the same way that CDOWN shifts it down. This instruction is logically identical to the line `print chr$(11);`.

### Example
```text
print "Example":cup:cup:print "of cup"
```

**See also:** CLEFT, CDOWN, CRIGHT

## CLEFT
`CLEFT` — Cursor left.

The CLEFT instruction displaces the text cursor one character to the left. Note that CLEFT is equivalent to `PRINT CHR$(3)`.

### Example
```text
print "Example":cleft:cleft:print "of cleft"
```

**See also:** CUP, CRIGHT, CDOWN

## CRIGHT
`CRIGHT` — Cursor right.

CRIGHT has the opposite effect as CLEFT and moves the cursor one place to the right. An identical effect can be achieved using the line `print chr$(9)`.

### Example
```text
print "Example":cright:cright:print "of cright"
```

## XCURS
`XCURS` — Variable holding the X coordinate of the text cursor.

XCURS is a variable which returns the X coordinate of the text cursor (in text format).

### Example
```text
locate 10,0:print XCURS
10
```

## YCURS
`YCURS` — Variable holding the Y coordinate of the cursor.

YCURS returns the Y coordinate of the text cursor (in text format).

### Example
```text
locate 0,10:print ycurs
10
```

## SET CURS
`SET CURS top,base` — Set text cursor size.

- **top**: the topmost point of the cursor.
- **base**: the bottom of the cursor.

The SET CURS instruction allows you to change the size of the text cursor. These values can range from 1 to the maximum height of a character (normally 8 in medium and low resolution).

### Example
```text
set curs 1,8
```

## CURS ON/OFF
`CURS ON/OFF` — Enable/disable text cursor.

- `CURS ON` — Enables the flashing text cursor.
- `CURS OFF` — Removes the flashing cursor from the current window by deactivating colour number 2.

Since the action of colour 2 is not restricted to a single window, any pictures drawn in this colour will immediately cease flashing. Similarly, the flashing cursors in every other window will also be frozen.

## CENTRE
`CENTRE a$` — Print a line of text centred on the screen.

- **a$**: the string to be printed.

CENTRE takes the string in a$ and prints it in the centre of the screen. This text is printed on the line currently occupied by the text cursor.

### Example
```text
new
10 locate 0,1
20 centre "This is a centered TITLE"
30 locate 0,3
40 centre "And this is another one"
```

## TAB
`TAB(n)` — Move the cursor to the right.

- **n**: the number of places to move the text cursor right.

TAB is often used in conjunction with the PRINT instruction to space out a line of text on the screen. The action of the TAB is to move the text cursor n places to the right before the next print operation. It does this by generating a string of CHR$(9) characters.

### Example
```text
print tab(10);"Example: of TAB"
```
```text
Example of TAB
```
TAB can also be assigned to a string variable for later use:
```text
X$=tab(15)
print X$;"15 spaces to the right"
```
```text
               15 spaces to the right
```

**See also:** PRINT, CRIGHT

## SCRN
`SCRN(x,y)` — Return the character on the screen at a specific coordinate.

- **x**, **y**: the text coordinates relative to the current window.

SCRN is a function which returns an Ascii character to be found at the text coordinates x and y relative to the current window.

### Example
```text
new
10 locate 0,0
20 print "Hello"
30 locate 0,10
40 for I=0 to 5
50 print chr$(scrn(I,0));" ";scrn(I,0)
60 next I
```

**See also:** LOCATE, PRINT

## WINDOPEN
`WINDOPEN n,x1,y1,w,h[,border][,set]` — Create a window.

- **n**: the number of the window to be opened; permissible values range from 1-13.
- **x1**, **y1**: the text coordinates to the top left hand corner of the new window.
- **w**, **h**: the size in characters of the new window. The minimum size of these windows is 3 by 3.
- **border**: chooses one of 16 possible border styles for the new window. See BORDER for more details.
- **set**: indicates which character set is to be used; a number from 1 to 16 depending on the sets currently installed in the ST's memory.

The WINDOPEN instruction enables you to create a window on the ST's screen. There are three possible formats to this statement:

- `WINDOPEN n,x1,y1,w,h`
- `WINDOPEN n,x1,y1,w,h,border`
- `WINDOPEN n,x1,y1,w,h,border,set`

The default values for the system sets 1 to 3 are:

| Set | Size | Notes |
| --- | --- | --- |
| 1 | 8x8 pixels | Default set for low resolution |
| 2 | 8x8 pixels | Default set for medium resolution |
| 3 | 8x16 pixels | Default set for high resolution |

You can happily use all of these sets in each of the three resolutions. Set three in particular can be especially effective on a colour monitor as it provides you with a useful set of large characters.

Note that the text coordinates x1,y1 and the window size w,h use the new character sizes. You can also use the font definition accessory to create your own character sets. These sets are given numbers ranging from 4-16. See the separate section on character sets for more details.

### Example
```text
new
10 windopen 1,1,1,39,20 : rem Open a large window
20 windopen 2,10,10,20,5,10 : rem Small window with border 10
30 windopen 3,20,15,20,4,0,1 : rem Open a window using character set one
40 windopen 4,3,10,30,5,3,2 : rem Window with set 2 and border 3
50 windopen 5,10,3,20,5,5,3 : rem Window with set 3 and border 5
```

In order to test these windows you can use the WINDOW function like so:
```text
window 2
window 4
window 1
window 3
window 5
```

Here is another example which opens five windows on the screen, each with its own separate set of attributes:
```text
5 mode 0
10 for I=1 to 5
20 windopen I,1,1+(I-1)*5,39,4,I
30 paper I:ink I+10
40 print "Window ";I;" "
50 next I
```

As before, you can flick between these windows using `window`:
```text
window 3
```

**See also:** WINDEL, WINDOW, QWINDOW, WINDCOPY, WINDON, WINDMOVE

## TITLE
`TITLE a$` — Define a title for the current window.

- **a$**: the title string.

The TITLE instruction sets the top line of the current window to the title string in a$. If the length of this string is less than the width of the window, then it is centred. This title will now be displayed along with the window, until it is deleted by using the BORDER command with no parameters.

### Example
```text
new
5 mode 0
10 windopen 5,1,1,20,10
20 title "Window number 5"
30 wait key
40 border
50 wait key
60 windel 5
```

**See also:** BORDER, WINDEL, WINDOPEN, WINDMOVE, WINDOW

## BORDER
`BORDER n` — Set the border of the current window.

- **n**: the border style; can take values ranging from 1 to 16.

This instruction allows you to choose from one of 16 possible borders for the current window. These borders are made up from the Ascii characters 192 to 255 and can be readily changed using the FONTS.ACB accessory.

### Example
```text
new
default
10 windopen 5,5,5,20,10
20 title "Window number 5"
30 wait key
40 for I=1 to 16:border I:wait 5:next I
50 windel 5
```

### Gotchas
- If you use the BORDER command on its own (with no parameter), the current border is redrawn, and any title associated with the current window is erased.

## WINDOW
`WINDOW n` — Activate window.

- **n**: the window number to activate.

WINDOW sets the current window to window number n. It then redraws the window along with any of its contents. This instruction should normally only be used when a number of windows overlap on the screen. If this is not the case then it makes rather more sense to use the QWINDOW statement which activates the window without redrawing it as this command is much faster than WINDOW.

### Example
```text
new
10 for I=1 to 13
20 windopen I,I+5,I+2,20,8
30 next I
```

Now type in the lines:
```text
run
window 5
window 10
```

Press undo twice to revert the screen to normal.

**See also:** QWINDOW, WINDEL, WINDOPEN, WINDON, WINDCOPY

## QWINDOW
`QWINDOW n` — Activate window without redrawing it.

- **n**: the window number to activate.

This function sets the current window to window number n, but does not redraw the window. It should therefore only be used if you're absolutely sure that the window has not been overwritten by something else.

### Example
```text
new
10 for I=1 to 5
20 windopen I,1,I*4,15,4 : windopen I+5,20,I*4,15,4
30 next I
run
qwindow 1
qwindow 5
qwindow 8
```

Note that because QWINDOW does not have to redraw the contents of the window, it is considerably faster than the equivalent WINDOW command. Further examples of this instruction can be found in the accessories supplied with the package. These can be examined using SEARCH:
```text
load "FONTS.ACB"
search "qwindow"
```

## WINDON
`WINDON` — Variable containing number of the current window.

WINDON returns the number of the currently active window.

### Example
```text
new
10 windopen rnd(12)+1,10,10,10,10
20 print "Window number ";windon," Activated"
```

**See also:** WINDOW, QWINDOW, WINDOPEN

## WINDMOVE
`WINDMOVE x1,y1` — Move a window.

- **x1**, **y1**: the text coordinates of the new top left corner of the window.

WINDMOVE moves both the current window and its contents to a new part of the screen specified by the text coordinates x1,y1. These coordinates are based on the character size of the window which is to be moved.

### Example
```text
WINDOPEN 1,0,2,30,10
WINDMOVE 5,3
```

**See also:** WINDOW, QWINDOW, WINDON, WINDOPEN

## WINDEL
`WINDEL n` — Delete a window.

- **n**: the window number to delete.

This function deletes the window number n, and erases it from the screen. If the window to be deleted is the current window, then the current window will be set to the window with the next lowest number, and this will be redrawn automatically.

### Example
```text
new
10 for I=1 to 13
20 windopen I,I+5,I+2,10,10
30 next I
40 for I=1 to 13
50 wait key
60 windel I
70 next I
```

**See also:** WINDOPEN, WINDMOVE, WINDOW, QWINDOW, WINDON, WINDCOPY

## CLW
`CLW` — Clear the current window.

CLW erases the contents of the current window and replaces it with a block of the current PAPER colour. Note that you can perform a CLW instruction from the editor by pressing the Clr key (or Shift+Home).

### Example
```text
clw:rem Clears window 0.
```

## SCROLL UP
`SCROLL UP` — Scroll the current window up.

This instruction moves a section of the current window above the text cursor one line up. Anything on the top line of the window is erased.

### Example
```text
scroll up:scroll up:scroll up
```

### Gotchas
- Not to be confused with DEF SCROLL.

**See also:** SCROLL DOWN, SCROLL

## SCROLL ON/OFF
`SCROLL ON/OFF` — Switch window scrolling on and off.

- `SCROLL OFF` — Turns off the scrolling. Whenever the cursor reaches past the bottom of the screen it will now reappear from the top.
- `SCROLL ON` — Restarts the scrolling. A new line is now automatically inserted when the cursor attempts to reach past the bottom of the screen.

### Example
```text
scroll off
```

### Gotchas
- Do NOT confuse this function with DEF SCROLL.

**See also:** SCROLL UP, SCROLL DOWN

## SCROLL DOWN
`SCROLL DOWN` — Scroll the current window down one line.

SCROLL DOWN scrolls the area below the text cursor one line down. As a natural consequence of this instruction, the bottom line of the window will be overwritten.

### Example
```text
scroll down:scroll down:scroll down
```

**See also:** SCROLL UP, SCROLL

## RESERVE AS SET
`RESERVE AS SET n,len` — Reserve a bank of memory for a character set.

- **n**: the bank number to reserve.
- **len**: the size of the bank in bytes.

This reserves len bytes of space in bank number n for a character set. This set can now be loaded into the bank using a line like `load "FONT1.MBK",n`.

### Example
```text
reserve as set 5,4000
load "FONT1.MBK",5
```

Note that the bank defined using this command is permanent and will be automatically included with your current program when you save it to the disc. The file FONT1.MBK is one of three example character sets supplied with the package. Each additional set is given a unique number ranging between four and nine. The first character set you defined is denoted by the number four, the second by five and so on.

Supposing, for example, you reserve some space for three character sets like so:
```text
RESERVE AS SET 6,4000
RESERVE AS SET 8,4000
RESERVE AS SET 5,4000
```

These sets would be accessed using the numbers: 4 for bank 6, 5 for bank 8, 6 for bank 5. The size of these banks has been set to 4,000 bytes.

You can calculate how large a character set is using the CHARLEN function.

## CHARLEN
`CHARLEN(n)` — Get the length of a character set.

- **n**: the character set number. Numbers 1 to 3 represent the system sets, and numbers 4 to 16 represent supplementary sets created using FONTS.ACB.

This function returns the length of a character set specified by the number n.

### Example
```text
? charlen(1)
```

**See also:** RESERVE

## CHARCOPY
`CHARCOPY s TO b` — Copy a character set into a particular bank.

- **s**: the source character set. Values of 1 to 3 correspond to the system sets, and numbers 4 to 16 denote user-defined sets.
- **b**: the destination bank number.

The CHARCOPY instruction copies character set s to bank number b.

### Example
```text
reserve as set 5,charlen(1)
```
Reserve bank 5 as a set of the same length as system set 1.
```text
charcopy 1 to 5
```
Copy system set 1 into bank 5.

**See also:** CHARLEN, RESERVE

## ICON$
`ICON$(n)` — Generate an icon at the current cursor position.

- **n**: the number of the icon to draw.

The STOS Basic icons are a group of useful 16 by 16 characters, stored in bank number 2. These icons can be output to the screen at the current cursor position using PRINT. This allows you to use them to create complicated backgrounds for your games. You can also incorporate icons directly into a menu. See Chapter 9 for more details. A special set of icons is provided for your use in the file ICONDEMO.MBK.

In order to output an icon to the screen you simply print a string containing a CHR$(27) character followed by CHR$(n), where n is the number of the icon you wish to draw. This string can be generated directly using the ICON$ function.

### Example
```text
new
load "ICON.MBK"
10 forX=0 to 19
20 for Y=0 TO 4
30 locate X*2, Y*2
40 print icon$(X*5+Y+1)
50 next Y
60 next X
```

The following two lines are equivalent:
```text
print chr$(27)+chr$(5)
print icon$(5)
```

