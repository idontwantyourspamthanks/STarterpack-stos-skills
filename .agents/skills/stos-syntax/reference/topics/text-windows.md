# Text and windows

STOS Basic can display up to 13 windows at once, each with its own colours, character set, and cursor. This chapter covers text attributes, cursor positioning, the windowing system, scrolling, and custom character sets and icons.

## Text attributes

Every window carries its own attributes. [`PEN`](../commands/text-windows.md#pen) sets the foreground colour of subsequent text; [`PAPER`](../commands/text-windows.md#paper) sets the background. Both take a colour index whose range depends on resolution (0-15 low, 0-3 medium, 0-1 high). Defaults are pen 1, paper 0.

```stos
10 mode 0
20 for I=0 to 15
30 pen I
40 print "Pen number ";I;space$(10)
50 next I
```

Four toggles modify how new text is drawn. [`INVERSE ON`](../commands/text-windows.md#inverse) swaps pen and paper. [`SHADE ON`](../commands/text-windows.md#shade) dims text with a brightness mask. [`UNDER ON`](../commands/text-windows.md#under) underlines text. [`WRITING`](../commands/text-windows.md#writing) selects the pixel blend mode: 1 = replace (default), 2 = OR, 3 = XOR. OR and XOR overlay text on a drawn background without erasing it.

```stos
5 mode 0
10 bar 0,0 to 319,199
20 print "Normal text"
30 writing 2
40 print "OR mode"
50 writing 3
60 print "XOR mode"
70 wait key
```

## Positioning the cursor

[`LOCATE`](../commands/text-windows.md#locate) moves the text cursor to coordinates x, y measured in characters from the top-left of the current window. Ranges vary with mode: low gives 0-39 x 0-24, medium and high give 0-79 x 0-24.

```text
locate 10,10:print "Hi"
```

Four functions convert between text and graphic (pixel) coordinates. [`XTEXT`](../commands/text-windows.md#xtext) and [`YTEXT`](../commands/text-windows.md#ytext) take a graphic coordinate and return the text equivalent relative to the current window (negative if outside). [`XGRAPHIC`](../commands/text-windows.md#xgraphic) and [`YGRAPHIC`](../commands/text-windows.md#ygraphic) convert the other way. This lets you track the mouse in text units:

```stos
10 cls:print "Move the mouse about!"
20 repeat
30 X=xtext(x mouse):if X<0 then 60
40 Y=ytext(y mouse):if Y<0 then 60
50 locate X,Y:print "*":rem Print * at mouse pointer
60 until mouse key:rem Exit when a button is clicked
70 default
```

[`HOME`](../commands/text-windows.md#home) sends the cursor to 0,0. [`CDOWN`](../commands/text-windows.md#cdown), [`CUP`](../commands/text-windows.md#cup), [`CLEFT`](../commands/text-windows.md#cleft) and [`CRIGHT`](../commands/text-windows.md#cright) nudge it one character in each direction. The variables [`XCURS`](../commands/text-windows.md#xcurs) and [`YCURS`](../commands/text-windows.md#ycurs) return the current text position. [`SET CURS`](../commands/text-windows.md#set-curs) resizes the flashing cursor; [`CURS ON`](../commands/text-windows.md#curs)/[`OFF`](../commands/text-windows.md#curs) toggles it. [`SQUARE`](../commands/text-windows.md#square) draws a bordered rectangle at the cursor position using one of the 16 border styles.

## Formatting output

[`CENTRE`](../commands/text-windows.md#centre) prints a string centred on the current cursor line. [`TAB(n)`](../commands/text-windows.md#tab) pads the cursor right by n columns (it expands to CHR$(9) characters), useful for columnar layouts with PRINT. [`SCRN`](../commands/text-windows.md#scrn) is a function returning the ASCII code of the character at text coordinates x, y in the current window.

## Creating windows

[`WINDOPEN`](../commands/text-windows.md#windopen) creates a window. Windows are numbered 1-13; minimum size is 3 x 3 characters. The three forms are:

```text
WINDOPEN n,x1,y1,w,h
WINDOPEN n,x1,y1,w,h,border
WINDOPEN n,x1,y1,w,h,border,set
```

Coordinates x1, y1 and dimensions w, h are in text units using the window's own character size. Border (1-16) selects a frame style; set selects a character set (1-3 built in, 4-16 user-defined). The example below opens five windows, each with its own paper colour and border:

```stos
5 mode 0
10 for I=1 to 5
20 windopen I,1,1+(I-1)*5,39,4,I
30 paper I:ink I+10
40 print "Window ";I;" "
50 next I
```

[`WINDOW n`](../commands/text-windows.md#window) activates and redraws a window - use it when windows overlap. [`QWINDOW n`](../commands/text-windows.md#qwindow) activates without redrawing and is much faster, but only safe when the window has not been overwritten. [`WINDON`](../commands/text-windows.md#windon) returns the active window number. [`WINDMOVE`](../commands/text-windows.md#windmove) relocates a window and its contents to new coordinates. [`WINDEL n`](../commands/text-windows.md#windel) deletes a window; if it was current, the next-lowest becomes active and is redrawn. [`CLW`](../commands/text-windows.md#clw) clears the interior to the current paper colour. [`BORDER n`](../commands/text-windows.md#border) changes the border style; `BORDER` with no argument redraws the frame and erases any title. [`TITLE a$`](../commands/text-windows.md#title) sets a centred title bar.

## Scrolling window contents

[`SCROLL ON`](../commands/text-windows.md#scroll)/[`OFF`](../commands/text-windows.md#scroll) controls what happens when the cursor passes the bottom edge: ON scrolls everything up and starts a new line (the default); OFF wraps the cursor back to the top. [`SCROLL UP`](../commands/text-windows.md#scroll-up) moves the area above the cursor up one line, erasing the top line. [`SCROLL DOWN`](../commands/text-windows.md#scroll-down) moves the area below the cursor down one line, overwriting the bottom line.

## Custom character sets

Each window can use a different character set. Three system sets are built in: 8x8 for low, 8x8 for medium, and 8x16 for high resolution. You create your own with the **FONTS.ACB** accessory:

```text
accnew: accload "FONTS.ACB"
```

Access it from the editor with Help+F1. Choose a character in the selection window (left button), edit it in the edit window (left button sets a pixel, right button clears), then install it back in the selection window (right button). Save the set as a `.MBK` file or use **Quit & Grab** to load it straight into bank 5 of your program. Available character sizes:

| Size | Modes |
| --- | --- |
| 8x8 | All |
| 8x16 | High and medium |
| 16x8 | High only |
| 16x16 | High only |

To use a saved set in a program, check its file size with `DIR "*.MBK"`, round up generously, then reserve and load it:

```stos
10 reserve as set 5,4000
20 load "FONT1.MBK",5
```

User-defined sets are numbered 4 upwards in the order they are reserved (the first becomes set 4, the next set 5, and so on), regardless of the bank numbers used. Pass the set number as the last argument to [`WINDOPEN`](../commands/text-windows.md#windopen):

```stos
10 windopen 1,1,1,38,23,1,4
20 for I=32 to 255
30 print chr$(I);
40 next I
50 wait key
```

[`CHARLEN(n)`](../commands/text-windows.md#charlen) returns the byte length of set n (1-3 system, 4-16 user), handy for sizing a bank before loading. [`CHARCOPY s TO b`](../commands/text-windows.md#charcopy) copies set s into bank b - useful for duplicating a system set before modifying it.

The three default sets live on the system disc as `\STOS\8X8.CR0` (low), `\STOS\8X8.CR1` (medium) and `\STOS\8X16.CR2` (high). Overwriting one with `BSAVE` changes the font STOS loads at boot. Up to six extra sets can also be auto-loaded at startup (extensions `.CR4`-`.CR9`, accessed as set numbers 4-9).

## Icons

Icons are 16x16 graphics stored in bank 2 and printed at the cursor like ordinary characters. [`ICON$(n)`](../commands/text-windows.md#icon) returns a string containing `CHR$(27)` followed by `CHR$(n)`; printing it draws icon n. A demo set is provided in `ICONDEMO.MBK`.

```stos
10 load "ICON.MBK"
20 for X=0 to 19
30 for Y=0 to 4
40 locate X*2,Y*2
50 print icon$(X*5+Y+1)
60 next Y
70 next X
```

Build your own icons with the **ICONS.ACB** accessory (`accload "ICONS.ACB"`). It works like the font definer: select an icon from the selection window, edit it in the edit window, install it with the right button, then save to disc or Quit & Grab into bank 2.
