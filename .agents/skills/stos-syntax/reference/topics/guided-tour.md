# Guided tour

STOS Basic is one of the most powerful versions of Basic ever written for the Atari ST, with strong support for sprites, screen manipulation and music. Three sample games written entirely in STOS Basic are supplied on the games disc and can be listed and amended like any other program; although STOS is heavily games-oriented it is equally suited to applications such as educational software.

> [!NOTE]
> Make a backup of the STOS package before doing anything else. Mandarin will replace a damaged disc for a nominal handling charge, but you will be without STOS while it is re-duplicated.

The rest of this chapter is a brief tour of the main features; the full command references begin in Chapter 4.

## Sprites

The sprite commands move and animate sprites using simple Basic instructions — no poking into the ST's memory is needed. STOS also ships with a Sprite Editor accessory that can be resident in memory and summoned with two keystrokes to design, test and modify sprites.

Load some example sprites from the accessory disc, then display one with [`SPRITE`](../commands/sprites.md). Up to 15 sprites can be on screen at once:

```text
mode 0
load "animals1.mbk"
sprite 1,100,100,1
for A=1 to 15:sprite A,1,A*10,A:wait key:next A
```

> [!NOTE] Unverified: the OCR on printed page 3 reads `sprite A,1,A#10,A`; `A*10` is reconstructed to give a sensible spread of y coordinates.

### Moving and animating sprites

[`MOVE X`](../commands/sprites.md) and [`MOVE Y`](../commands/sprites.md) drive sprites across the screen using interrupts, so movement happens independently of the running Basic program. Place a sprite, start a movement, then prove the program still executes:

```text
sprite 1,10,100,1
move x 1,"(1,3,100)(1,-3,100)L"
move on
for A=1 to 10000:P=P+1:next A:print P
```

The octopus keeps moving while the FOR...NEXT loop runs. [`ANIM`](../commands/sprites.md) cycles a sprite through a list of images, also via interrupts, and combines with `MOVE` for smooth animated motion:

```text
sprite 1,100,100,1
box 100,100 to 132,132
anim 1,"(1,10)(2,10)(3,10)(4,10)L"
anim on
```

The full sprite command set (`SPRITE`, `MOVE`, `ANIM`, `PUT SPRITE`, `GET SPRITE`, `COLLIDE`, `ZONE`, `UPDATE`, etc.) is documented in Chapter 4.

## Manipulating the screen

STOS can scroll, copy and resize parts of the screen. A title picture can be loaded straight into the current screen with `load "\stos\pic.pi1"`. Compressed screens (produced by the Screen Compactor accessory) load into one of STOS's 16 memory banks and are expanded with [`UNPACK`](../commands/screen.md):

```text
load "backgrnd.mbk",11
unpack 11,back
```

`physic` and `back` are the physical and sprite-background screens; drawing into `back` lets sprites move over the picture without erasing it. Colour 2 flashes by default — turn it off with `flash off`. This tiny program uses [`APPEAR`](../commands/screen.md) to fade between screens using one of 79 effects:

```stos
10 mode 0: flash off: unpack 11,back
20 appear back,rnd(78)+1
30 wait key: goto 10
```

[`REDUCE`](../commands/screen.md) shrinks the screen to a quarter size; [`ZOOM`](../commands/screen.md) magnifies a section; [`SCREEN COPY`](../commands/screen.md) blits rectangles at high speed; [`DEF SCROLL`](../commands/screen.md) and [`SCROLL`](../commands/screen.md) define and run scrolling zones. The full set (`APPEAR`, `FADE`, `SCREEN SWAP`, `PACK`, `WAIT VBL`, etc.) is in Chapter 7.

## Graphics

STOS supports the usual `CIRCLE`, `BOX` and `POLYGON` operations, plus the ability to change graphics resolution at any time with a single [`MODE`](../commands/graphics.md) instruction:

```stos
10 mode 0: print "Low resolution"
20 print "Press a key to change graphics modes"
30 wait key: mode 1
40 print "Medium resolution"
```

[`SHIFT`](../commands/graphics.md) continuously rotates the palette (stop with `shift off`), and [`FLASH`](../commands/graphics.md) animates a colour through up to 16 changes, again via interrupts:

```text
flash 1,"(000,5)(333,5)(666,5)(777,5)(555,5)(222,5)"
```

The full graphics instruction set (`PLOT`, `DRAW`, `CIRCLE`, `POLYGON`, `PAINT`, `INK`, `PALETTE`, `CLIP`, etc.) is in Chapter 6.

## Mouse and joystick

The STOS mouse pointer is itself a specialised sprite, so its shape can be changed with [`CHANGE MOUSE`](../commands/sprites.md). Built-in shapes use small numbers; sprites loaded into memory are referenced by image number plus four:

```text
change mouse 2
load "sprdemo.mbk"
change mouse 4
```

The pointer position is read with the `X MOUSE` and `Y MOUSE` functions — wrapped in a loop, it continually reports the coordinates:

```stos
10 locate 0,0: print x mouse,y mouse: goto 10
```

Joystick directions are tested directly with the `JLEFT`, `JRIGHT`, `JUP`, `JDOWN` and `FIRE` conditions:

```stos
10 if jleft then print "LEFT"
20 if jright then print "RIGHT"
30 if jup then print "UP"
40 if jdown then print "DOWN"
50 if fire then boom : goto 10
```

## Music and sound

A Music Editor accessory (resident like the Sprite Editor) is included for creating soundtracks. Load a tune and play it — music runs independently of the rest of the program. [`TEMPO`](../commands/music-sound.md) changes speed, [`TRANSPOSE`](../commands/music-sound.md) changes pitch, and `music off` stops playback:

```text
load "music.mbk"
music 2
tempo 10
transpose 30
music off
```

For simple effects, `BOOM`, `SHOOT` and `BELL` produce predefined noises; `NOISE`, `ENVEL`, `PLAY` and `VOLUME` give raw access to the sound chip. See Chapter 5 for the full set.

## Text, windows and fonts

STOS has its own windowing system (it is not GEM-based) with 16 border styles, and each window can use a different character set. A window is opened with `WINDOPEN` and deleted with `WINDEL`; `WINDOW` moves the cursor between open windows and `DEFAULT` clears them all. After loading new fonts (`font1.mbk`, `font2.mbk`, `font3.mbk`), four windows can each display a different character set:

```stos
10 windopen 1,0,0,9,4,4,3: rem One of 3 system sets
20 windopen 2,10,0,9,4,4,4: rem First new set
30 windopen 3,20,0,9,4,4,5: rem Second new set
40 windopen 4,30,0,9,4,4,6: rem Third new set
50 input "Window ";W
60 window W: goto 50
```

A Font Definer accessory is supplied for creating character sets. STOS also supports 16x16 icons printed with [`ICON$`](../commands/text-windows.md) — for example, `print icon$(N)` prints icon N from a loaded icon bank. Chapter 8 covers the full text and window instruction set.

## Pull-down menus

STOS menus are driven by interrupts and can be built from text or icons. Define a title and items in the [`MENU$`](../commands/menus.md) array, switch the menu on, and read selections with [`MNSELECT`](../commands/menus.md):

```stos
10 menu$(1)="Menu "
20 menu$(1,1)="Item1"
30 menu$(1,2)="Item2"
40 menu$(1,3)="Item3"
50 menu on
60 A=mnselect: if A<>0 then print "You chose Item number",A
70 goto 60
```

Chapter 9 documents the menu commands in full.
