# STOS commands: menus

## MENU$
`MENU$(x)=title$ [,paper,pen]` — Set a menu title.

- **x**: the number of the menu whose title you wish to create (1 to 10).
- **title$**: the title of your menu.
- **paper**, **pen**: the colours of the heading and background respectively.

Before you can incorporate one of these menus into a program, you first need to define the menu titles which will be displayed on the screen. The menus are given numbers from 1 to 10 starting from the left hand corner of the screen.

### Example
```text
new
10 menu$ (1)="ACTION "
20 menu$ (2)="MOUSE"
```

### Gotchas
- If the menus are defined out of sequence, the menu will flicker and die every time you try to call it with the mouse. Check the menu definitions.

**See also:** MENU$(x,y)

## MENU$(x,y)
`MENU$(x,y)=OPTION$ [paper,pen]` — Set a menu option.

- **x**, **y**: the title number and the option number of the menu line.
- **option$**: the menu text. You can use any string you like for this purpose.

You can now specify a list of options to be associated with each of the titles defined with MENU$ using this second form of the MENU$ command.

### Example
Continues the previous MENU$ example:
```stos
25 rem Action menu
30 menu$ (1,1)="Quit"
35 rem Mouse menu
40 menu$ (2,1)="Arrow"
50 menu$ (2,2)="Hand"
60 menu$ (2,3)="Clock"
```

If you try to run this program as it stands, nothing happens. The reason for this is that STOS Basic first requires you to use a special command to start your new menu running.

**See also:** MENU$

## MENU ON
`MENU ON [border][,mode]` — Turn on menu interrupt.

- **border**: can range from 1 to 16.
- **mode**: 1 for a drop-down menu, or 2 for a pull-down menu.

MENU ON starts the new menu running. STOS Basic supports two distinct types of menu: drop-down menus, which are selected whenever the mouse touches the menu line, and pull-down menus, which also require you to press the left mouse button as well. MENU ON also lets you choose any one of 16 different borders for your menus.

### Example
```stos
70 menu on
```
To generate a pull-down menu with border type 5:
```stos
70 MENU ON 5,2
```

### Gotchas
- If the menu doesn't appear in your program, you may have forgotten to use the MENU ON command.

**See also:** MENU OFF, MENU FREEZE

## MENU OFF
`MENU OFF` — Stop menu interrupt.

MENU OFF permanently switches off the entire menu and clears the menu from the ST's memory.

**See also:** MENU ON, MENU FREEZE

## MENU FREEZE
`MENU FREEZE` — Freeze menu interrupt.

MENU FREEZE temporarily freezes the action of the menu. The menu can be restarted with MENU ON.

**See also:** MENU ON, MENU OFF

## MENU$(title,option) OFF
`MENU$(title,option) OFF` — Disable a menu option.

This instruction disables one of the list of menu items under *title*. Any further attempts to call this entry are completely ignored.

**See also:** MENU$(title,option) ON

## MENU$(title,option) ON
`MENU$(title,option) ON` — Enable a menu option.

Reverses the effect of MENU$(title,option) OFF.

### Gotchas
- STOS stores all your menus in bank number 15. This bank should therefore only be reserved when these menus are not required in your program.

**See also:** MENU$(title,option) OFF

## MNBAR
`MNBAR` — Reserved variable holding the selected menu title number.

MNBAR holds a number denoting the menu title you have chosen. Together with MNSELECT, it lets you read which entry the user has highlighted with the mouse.

### Example
```stos
90 OPTION=mnbar : CHOICE=mnselect
100 print "Title Number ";OPTION; " Selection Number";CHOICE
110 goto 90
```
If you run this program, the title number and the option number you have selected will be displayed to the screen. This code can be expanded into a real program by replacing lines 100 onwards:
```stos
100 if OPTION=1 and CHOICE=1 then menu off : stop
110 if OPTION=2 and CHOICE<>0 then change mouse CHOICE
120 goto 90
```
Line 100 tests the menu to see if you have decided to exit from the program. The action of line 110 is to check whether you wish to swap the mouse pointer. It can then use this information to alter the pointer type with a CHANGE MOUSE instruction.

**See also:** MNSELECT, ON MENU

## MNSELECT
`MNSELECT` — Reserved variable holding the selected menu option number.

MNSELECT contains the number of the specific option you have highlighted with the mouse. It is read together with MNBAR to determine which menu entry was chosen.

**See also:** MNBAR, ON MENU

## ON MENU
`ON MENU GOTO line1 [,line2]...` — Conditional menu jump.

The last example was fairly simple. But supposing you wanted to write a routine with a larger and more complicated series of menus. In this case, your program would need to use a long list of IF...THEN statements to deal with each and every possibility. Inevitably this would make your program both unwieldy and hard to change. It would therefore be better if there was an easier way of handling these menus.

Fortunately STOS Basic includes a special ON MENU statement which provides you with a painless method of managing even the largest menus. It does this by automatically jumping to one of a list of line numbers, depending on the title you have chosen.

`ON MENU GOTO line1 [,line2]...`

is broadly equivalent to the line:

`ON MNBAR GOTO line1[,line2]...`

One major difference between the above instruction and ON MENU is that ON MENU is performed using interrupts. This allows your program to execute another task at the same time as your menus are being tested.

### Example
```text
new
10 T=0
20 menu$ (1)=" ACTION"
30 menu$ (1,1)="COUNT"
40 menu$ (1,2)="QUIT"
50 menu on
60 on mnbar goto 90
80 T=T+1 : goto 80
90 if mnselect=1 then locate 0,1 : print T : goto 60
100 if mnselect=2 then stop
```

When you run this program, it first creates a menu, and then checks whether this menu has been accessed. It now reaches line 80 and repeatedly adds 1 to the variable T. Since line 60 is never executed again, playing around with the menu has no effect whatsoever. Try replacing line 60 with:
```stos
60 on menu goto 90
70 on menu on
```
In this case the menu will function perfectly, despite the fact that the program is still stuck at line 80. Furthermore, every time you choose COUNT, you will find that the value of the variable T has increased.

This appears to prove that line 80 is running at the same time as line 60. What is really happening is that the menus are being tested by STOS Basic 50 times a second using an interrupt similar to that utilised by the sprite commands. The entire process is set in motion by the ON MENU ON instruction. As you might expect, there's also a ON MENU OFF command which turns the menus off.

### Gotchas
- You can use this ON MENU routine in conjunction with any sequence of Basic instructions you like, providing they make no attempt to input or output information to the screen while ON MENU is active.
- If ON MENU doesn't work, check whether there is an ON MENU ON statement. Also make sure the program isn't attempting to perform Input or Output to the screen while ON MENU is active.

**See also:** MNBAR, MNSELECT

