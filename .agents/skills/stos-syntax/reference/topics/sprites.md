# Sprites

STOS Basic can move and animate up to 15 sprites at once, entirely independently of the Basic program that controls them. While your code gets on with its work, sprites whizz around the screen under interrupt control. This chapter covers how those sprites are drawn, installed, moved, animated and tested for collisions, and how the mouse and joystick feed into the same system.

All sprites are held in memory bank 1 as a list of numbered images. Each of the 15 runtime sprites can display any of these images, and can switch between them for animation. The chapter therefore splits into two halves: the **sprite definer**, which creates the images in bank 1, and the **sprite commands**, which drive the 15 live sprites around the screen.

## The sprite definer

Sprites are drawn in a dedicated accessory, loaded either as a program or — preferably, if memory allows — as an accessory so you can pop into it from the editor with `<HELP><F1>`:

```text
load "sprite.acb":rem Load as a program (run with RUN)
accnew:accload "sprite":rem Load as an accessory
```

The main definer runs in low resolution only. A second editor, `SPRITE2.ACB`, works in all three resolutions, uses less memory, and is the natural choice for designing mouse pointers (which exist in every resolution); it lacks some of the main editor's drawing tools but can still produce striking results. On startup the definer grabs any sprites already in use by your program, so you can edit them in place.

The screen splits into six areas: the **system menu** (load/save, change size, animation), the **drawing area**, the **scroll zone**, the **colour window** (separate colours for the left and right mouse buttons), the **tools section** (points, lines, hollow and filled boxes/circles/ellipses, fill patterns, undo, reduce, zoom, reverse, invert, rotate) and the **selection window** listing the images currently held in the bank. The general drawing technique is universal: hold the left button down while moving the mouse to size an object, release to assign that object to the pointer, then click to stamp copies; click the right button to drop the object.

When a sprite is finished it must be copied into the bank with the **store** menu's put or insert options before saving. There are quick keyboard shortcuts: down-arrow twice puts the edited sprite, up-arrow twice gets one from the bank, right-arrow puts the current sprite and fetches the next, and left-arrow puts and fetches the previous. The definer can also grab images straight from Degas or Neochrome pictures, or from any binary file — a commercial game, say — via the grab-from-program option, which loads the file in 16k chunks and lets you page through it at a chosen screen width until something recognisable appears.

Each sprite carries a **hot spot**: the handle by which it is positioned. It defaults to the top-left corner but can be moved anywhere inside the image. Sprites range from 16×2 to 64×64 pixels, with width set in 16-pixel steps. The finished bank is saved to disc with the file menu's save/save-as options, or copied directly into the current program with **quit & grab** (accessory mode only).

## Displaying a sprite

`SPRITE n,x,y,p` installs sprite number `n` (1-15) at coordinates `x,y` showing image `p` from bank 1. Coordinates may be negative — `x` runs from -640 to +1280 and `y` from -400 to +800 — so a sprite can move off-screen without error. `SPRITE` does two jobs at once: it draws the sprite *and* ties image `p` to sprite `n`, so it must always be issued before any `MOVE` or `ANIM` on that sprite. Changing the image number on an already-installed sprite simply swaps the picture.

```stos
10 mode 0:flash off:palette 0,$777,$444
20 load "fontset.mbk"
30 sprite 1,100,100,6:rem Image 6 at 100,100 as sprite 1
40 sprite 2,10,50,6:rem Same image as a second sprite
50 sprite 3,-10,100,5:rem Negative coordinates are legal
```

## Movement

`MOVE X n,m$` and `MOVE Y n,m$` drive sprite `n` along a path described by the movement string `m$`. The motion happens automatically every 50th of a second (70th in high resolution), independently of the Basic program. In `MOVE X` positive steps move right and negative left; in `MOVE Y` positive moves down and negative up. The movement string is a sequence of triplets in the format `(speed,step,count)`:

- **speed** — delay in 50ths of a second between steps; 1 is fast, 32767 is glacially slow.
- **step** — pixels moved per step. Large steps look fast but jerky; a step of about 10 with a high speed is both fast and smooth.
- **count** — number of steps; 0 repeats forever.

Triplets chain together and run in sequence. Two single-letter directives extend the string:

- **`L`** — loop: jump back to the start of the list and repeat the whole sequence.
- **`Epos`** — endpoint: halt the sprite when its coordinate reaches `pos` (for example `E200`). An endpoint combined with `L` stops the sprite and then restarts the sequence from the beginning. An optional starting coordinate may be placed *in front* of the list, which the sprite snaps back to on each loop.

No movement takes place until it is started with `MOVE ON` (or `MOVE ON n` for a single sprite). `MOVE OFF [n]` stops it outright; `MOVE FREEZE [n]` pauses it without losing the sequence, and is restarted with `MOVE ON`. `MOVON(n)` returns non-zero if sprite `n` is still moving, and `X SPRITE(n)` / `Y SPRITE(n)` return its current coordinates — handy for telling whether a missile has flown off the screen.

```stos
10 load "fontset.mbk"
20 sprite 1,10,100,1
30 move x 1,"(1,1,100)(1,-1,100)":rem Right 100, then left 100
40 move on
```

Looping a sprite between two positions, with a starting coordinate and an endpoint:

```stos
10 sprite 1,100,100,1
20 move x 1,"100(1,1,0)L200":rem Forever from x=100 to x=200
30 move on
```

An endpoint fires only when the coordinate lands exactly on `pos`; if the step size skips over the value the sprite sails past and the test never succeeds. Horizontal and vertical movements are independent, so issue a `MOVE X` and a `MOVE Y` for the same sprite to get diagonal or curved paths. `LIMIT SPRITE x1,y1 TO x2,y2` clips sprite *visibility* to a rectangle (x coordinates are rounded to a multiple of 16) without restricting movement; `LIMIT SPRITE` with no arguments restores the whole screen.

## Animation

`ANIM n,a$` cycles sprite `n` through a chain of images. The animation string holds pairs `(image,delay)`, where `delay` is in 50ths of a second. As with `MOVE`, the `L` directive repeats the whole sequence, and nothing runs until `ANIM ON` starts it. Animation runs concurrently with movement, so a sprite can walk and travel at the same time. `ANIM OFF [n]` stops it and `ANIM FREEZE [n]` pauses it. The sprite definer's animate menu builds these strings interactively and prints the exact `ANIM` string for the effect you create — note it down for use in your program.

```stos
10 anim 1,"(1,10)(2,10)":rem Image 1 for 0.2s, then image 2
20 anim 1,"(1,10)(2,10)L":rem ...and repeat forever
30 anim on
```

## Mouse and joystick

The easiest way to give the player control of a sprite is to attach one to the mouse with `CHANGE MOUSE m`. Values 1-3 select the built-in arrow, pointing hand and clock; any value above 3 takes an image from bank 1, numbered `m-3` — so `m=4` is image 1, `m=5` is image 2, and `m=8` is image 5. The default pointers live in `\STOS\MOUSE.SPR` on the system disc and can be replaced wholesale with `bsave`.

Once a sprite is on the mouse, `X MOUSE` and `Y MOUSE` report its position and `MOUSE KEY` returns the button state (0 none, 1 left, 2 right, 3 both). `LIMIT MOUSE x1,y1 TO x2,y2` traps the pointer inside a rectangle and recentres it; `LIMIT MOUSE` alone releases it. `HIDE` and `SHOW` are counted — each `HIDE` needs a matching `SHOW` — while `HIDE ON` and `SHOW ON` are absolute overrides. A hidden mouse still reports its position.

For the joystick, `JOY` returns a binary value whose bits encode up/down/left/right/fire. The named functions are easier in practice: `JLEFT`, `JRIGHT`, `JUP`, `JDOWN` and `FIRE` each return TRUE (-1) or FALSE (0), ready to drop into an `IF`:

```stos
10 if jleft then print "LEFT"
20 if jright then print "RIGHT"
```

## Collision detection

`COLLIDE(n,w,h)` tests whether any other sprite overlaps a box of width `w` and height `h` rooted at sprite `n`'s hot spot (`n` ranges 0-15, with 0 meaning the mouse). It returns a binary number with one bit per sprite — bit 1 for sprite 1, bit 5 for sprite 5, and so on — which you test with `BTST`. The practical shortcut is to print the value at the moment of collision, note the number, then test for it directly:

```stos
100 if collide(2,10,10)=6 then boom
```

For collisions with irregular background shapes, `DETECT(n)` returns the colour of the pixel currently under sprite `n`'s hot spot. Border an object with a known colour and test for it to catch collisions that a rectangular box would miss:

```stos
60 c=detect(1)
70 if c=2 then boom
```

## Zones

`SET ZONE z,x1,y1 TO x2,y2` defines one of up to 128 numbered rectangles. `ZONE(n)` then returns the number of the zone that sprite `n` (0 for the mouse) currently occupies, or 0 for none — a simple way to build clickable screen regions or detect when a sprite enters an area. Overlapping zones cannot all be reported: `ZONE` returns only the first match. `RESET ZONE [z]` erases a single zone, or every zone when called with no argument.

## Priorities and the background screen

By default sprites are drawn in reverse sprite-number order, so the mouse — effectively sprite 0 — always passes in front of everything. `PRIORITY ON` switches to Y-coordinate ordering instead: the sprite with the larger y coordinate is drawn in front, producing a cheap perspective effect (a sprite at y=100 passes in front of one at y=99). `PRIORITY OFF` restores the default. For the best illusion, place each sprite's hot spot at its base so the y coordinate reflects where the sprite stands.

Every moved sprite is backed by a copy of the whole screen held in memory, so the background and the visible screen must agree. By default all graphics commands draw to both; `AUTOBACK OFF` draws to the visible screen only, which speeds up graphics considerably but lets sprites smear the picture underneath (because the background lacks the new drawing). `AUTOBACK ON` restores safe operation. If a program uses neither sprites nor the mouse, switching autoback off is a free speed-up.

## Beyond 15 sprites

The 15-sprite limit applies only to *moving* sprites. `PUT SPRITE n` stamps a static copy of sprite `n` at its current position onto the screen — the live sprite itself is unaffected — so you can litter the screen with dozens of images. `GET SPRITE x,y,i[,mask]` goes the other way: it grabs a rectangle from the screen back into an existing image `i` (whose size is fixed by its original definition in the bank), which you can then drive as a live sprite. The optional `mask` sets the transparent colour (default 0). Chaining `PUT SPRITE` to populate the screen and `GET SPRITE` to awaken a few images at a time is the standard trick for flocks of invaders that only appear to break the limit.

Finally, a few housekeeping commands round out the set. `UPDATE OFF` suspends the automatic redraw of moved sprites — they keep moving internally, and a bare `UPDATE` forces a redraw at the current position, while `UPDATE ON` returns to normal. `REDRAW` redraws every sprite whether it has changed or not. `OFF` strips all sprites from the screen and halts their movement (bound to `f10` by default, and the usual way to recover after breaking out of a program with Control+C). `FREEZE` pauses both sprites and music together, and `UNFREEZE` resumes them.
