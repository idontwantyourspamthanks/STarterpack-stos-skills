# Menus

STOS Basic provides its own menu system that bypasses GEM. The menus look different from their GEM equivalents but are more powerful and considerably easier to drive from Basic. This chapter walks through defining a menu, turning it on, reading the user's selection, and using the interrupt-driven `ON MENU` statement to manage menus while the rest of the program keeps running.

## Defining a menu

A menu is built from **titles** (the headings across the top of the screen) and **options** (the lines that drop down beneath each title). Both are defined with [`menu$`](../commands/menus.md).

Titles are numbered 1 to 10 from the left. Set one with `menu$(x)=title$`, where `x` is the title number and the optional trailing arguments `paper,pen` set the colours of the entry. Each title then takes a list of options with a second form of the same command, `menu$(x,y)=option$`, where `y` is the option's position beneath title `x`:

```stos
10 menu$(1)="ACTION"
20 menu$(2)="MOUSE"
30 menu$(1,1)="Quit"
40 menu$(2,1)="Arrow"
50 menu$(2,2)="Hand"
60 menu$(2,3)="Clock"
```

Title strings are often padded with surrounding spaces (for example `" ACTION "`) to give each heading a consistent width on screen.

## Turning the menu on

Defining the titles and options displays nothing until the menu is explicitly activated with [`menu on`](../commands/menus.md):

```stos
70 menu on
```

`MENU ON` accepts two optional arguments — `MENU ON [border][,mode]`:

- **border** — a border style from 1 to 16.
- **mode** — `1` for a drop-down menu, which opens as soon as the mouse touches the title; or `2` for a pull-down menu, which also requires the left mouse button. Drop-down is the default.

For example, `menu on 5,2` starts a pull-down menu with border style 5.

Three companion instructions control a running menu:

- [`menu off`](../commands/menus.md) — permanently removes the menu and clears it from memory.
- [`menu freeze`](../commands/menus.md) — temporarily suspends the menu so it can be restarted later with `menu on`. Handy for protecting the menu line while drawing to the screen.
- `menu$(title,option) off` and `menu$(title,option) on` — disable or re-enable an individual option. A disabled entry is ignored when clicked.

STOS stores every menu definition in memory bank 15, so reserve that bank only when menus are not in use.

## Reading a selection

When the user chooses an option, two reserved variables are updated:

- [`mnbar`](../commands/menus.md) — the number of the title that was selected.
- [`mnselect`](../commands/menus.md) — the number of the option beneath that title.

A simple polling loop reads them directly:

```stos
90 OPTION=mnbar:CHOICE=mnselect
100 print "Title Number ";OPTION;" Selection Number ";CHOICE
110 goto 90
```

In a real program you test the combination and act on it:

```stos
100 if OPTION=1 and CHOICE=1 then menu off:stop
110 if OPTION=2 and CHOICE<>0 then change mouse CHOICE
120 goto 90
```

## Handling selections with ON MENU

Polling a large menu with `IF...THEN` chains quickly becomes unwieldy. [`on menu`](../commands/menus.md) dispatches to one of a list of line numbers depending on which title the user selected, and it does so through an interrupt — so the rest of the program can continue working at the same time.

`ON MENU GOTO line1 [,line2]...` is broadly equivalent to `ON MNBAR GOTO line1 [,line2]...`, but with one crucial difference: `ON MENU` is checked roughly 50 times a second by an interrupt (the same mechanism that drives the sprite commands), so the dispatch keeps firing even while the program is busy elsewhere.

The interrupt must be explicitly armed with `ON MENU ON`, and disarmed with `ON MENU OFF`. The following program defines a single ACTION menu, then loops endlessly incrementing a counter; yet every time the user picks COUNT the current total is printed, and QUIT halts the program:

```stos
10 T=0
20 menu$(1)="ACTION"
30 menu$(1,1)="COUNT"
40 menu$(1,2)="QUIT"
50 menu on
60 on menu goto 90
70 on menu on
80 T=T+1:goto 80
90 if mnselect=1 then locate 0,1:print T:goto 60
100 if mnselect=2 then stop
```

Without line 70 the dispatch would be checked only once and the menu would appear dead. One constraint: while `ON MENU` is active, the surrounding code must not perform input or output to the screen — the menu interrupt manages the screen, and mixing in your own I/O causes conflicts.

For menus with several titles, a single dispatch line routes each title to its own routine:

```stos
150 on menu goto 200,400,600
160 on menu on
170 goto 170
```

Line 170 exists purely to give STOS something to do while waiting. Each routine reads `mnselect`, acts on the option, then jumps back to line 150 to re-arm the dispatch.

## Techniques from the Doodle example

The chapter builds a small drawing program to demonstrate several practical patterns.

### Coloured bars as options

Setting an option's `paper` colour and leaving its text as spaces produces a solid coloured bar instead of a text entry. The Doodle COLOUR menu draws its whole palette this way:

```stos
80 menu$(3)="COLOUR"
90 for I=1 to 16
100 menu$(3,I)="      ",I-1,0
110 next I
```

Each option is six spaces with `paper=I-1`, producing sixteen coloured bars that the user clicks like any other option.

### Protecting the menu while drawing

Drawing operations can collide with the menu line and corrupt it. [`menu freeze`](../commands/menus.md) suspends the menu for the duration of the drawing loop, and `limit mouse` confines the pointer to the area below the menu bar so the user cannot draw over the titles:

```stos
200 menu freeze:rem Switch off menu
220 limit mouse 0,22 to 300,180
```

Restart the menu with `menu on` and lift the limit with a bare `limit mouse` once the drawing loop ends.

### Icons in place of text

Any title or option can be loaded from an icon bank: `menu$(1)=icon$(2)` loads title 1 with icon 2, and `menu$(2,1)=icon$(3)` sets option 1 of title 2 to icon 3. After loading `ICON.MBK` from the editor, the Doodle pen-sizes menu is replaced with three circle icons:

```stos
50 menu$(2,1)=icon$(3):rem Small circle
60 menu$(2,2)=icon$(2):rem Medium-sized circle
70 menu$(2,3)=icon$(1):rem Large circle
```

Icons are then selected with the mouse exactly like text options.

## Troubleshooting

- **The menu flickers and dies every time you open it.** The menu has been defined out of sequence — check the title and option numbers.
- **The menu does not appear.** You probably forgot the `menu on` command.
- **`ON MENU` does not fire.** Check that `on menu on` has been executed, and that the program is not attempting screen input or output while the interrupt is active.
