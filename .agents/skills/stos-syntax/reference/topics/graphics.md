# Graphics

STOS Basic may not be GEM-based, but it exposes a wide set of graphical primitives similar to those offered by the GEM VDI — points, lines, rectangles, circles, arcs and polygons — plus a group of commands designed specifically to let a single program run well in all three ST resolutions. You can even switch between low and medium resolution partway through a program.

## Resolution and multi-mode graphics

The ST's hardware offers three graphics modes, chosen with `MODE`:

| Mode | Resolution | Colours | Colour indices |
| --- | --- | --- | --- |
| 0 | Low | 16 from 512 | 0–15 |
| 1 | Medium | 4 from 512 | 0–3 |
| 2 | High | 2 | 0–1 |

`MODE n` takes 0 or 1; mode 2 needs the high-resolution monitor and is entered automatically, so `MODE 2` is not valid and `MODE` errors out on a mono monitor. The companion `MODE` function returns the current mode, letting a program adapt at start-up:
```stos
10 if mode=2 then stop:rem This program will not work in high resolution
20 if mode=0 then mode=1: rem Enter medium resolution
30 centre "Medium Resolution"
40 locate 0,4:centre "Press a key"
50 wait key
60 locate 0,4:centre "Press a key"
70 centre "Low resolution"
80 wait key
```

The catch when writing one program for all three modes is the differing screen size. STOS supplies two read-only variables for this: `DIVX` and `DIVY`, the current width and height as a fraction of the mono screen:

| Mode | DIVX | DIVY |
| --- | --- | --- |
| 0 | 2 | 2 |
| 1 | 1 | 2 |
| 2 | 1 | 1 |

Treat the screen as a virtual 640×400 and divide every coordinate by `DIVX`/`DIVY`. The line below draws a rounded box that fills the screen in any mode:
```text
rbox 0,0 to 639/divx,399/divy
```

## Colours and the palette

Before drawing you choose an ink with `INK index`. The index refers to one of the slots above (0–15 in low res, 0–3 in medium, 0–1 in high). Index 2 is slightly unusual: by default it flashes on and off several times a second (see [Colour animation](#colour-animation-flash-and-shift)).

Each index holds a colour chosen from a palette of 512. `COLOUR index,$RGB` loads one slot; `$RGB` is a three-digit hex value whose digits (0–7) set the red, green and blue components:

| Components | Hex | Colour |
| --- | --- | --- |
| R=0 G=0 B=0 | `$000` | Black |
| R=7 G=0 B=0 | `$700` | Bright red |
| R=7 G=7 B=0 | `$770` | Yellow |
| R=0 G=7 B=0 | `$070` | Green |
| R=4 G=0 B=7 | `$407` | Violet |
| R=7 G=7 B=7 | `$777` | White |
| R=3 G=3 B=3 | `$333` | Grey |

Changing a colour updates every pixel already drawn in that index immediately — `colour 5,$770` turns all index-5 graphics yellow the moment it runs. `=COLOUR(index)` reads a slot back, and `PALETTE` installs a whole set of colours in one line:
```text
palette $000,$700,$070,$007,$770,$077,$707,$777
```
A `PALETTE` list can hold up to the mode's colour limit — 16 in low res, 4 in medium, 2 in high (where `palette $777,$000` inverts the mono screen).

## Drawing primitives

The building blocks are `PLOT x,y[,index]` (a single point, defaulting to the current ink) and its matching function `c=POINT(x,y)` (the colour at a point). `DRAW` comes in two forms: `DRAW x1,y1 TO x2,y2` draws a line between two points, and `DRAW TO x3,y3` continues from the end of the last line drawn. For speed `DRAW` is locked to a single line type and ignores `SET LINE`.

The hollow shapes are `BOX x1,y1 TO x2,y2` (a rectangle) and `RBOX` (identical, but with rounded corners — handy for Mac-style borders). `POLYLINE x1,y1 TO x2,y2 TO x3,y3 ...` chains line segments in one statement; to close a shape, repeat the first coordinate as the last. `POLYLINE`, unlike `DRAW`, does honour `SET LINE`.

```stos
10 mode 0
20 plot rnd(319),rnd(199),rnd(15)
30 goto 20
```

## Curves: arcs, circles and ellipses

`ARC x,y,r,startangle,endangle` draws part of a circle. Angles are measured in tenths of a degree (0–3600), anti-clockwise from 3 o'clock, so 900 points to 12 o'clock. A full circle is simply `arc x,y,r,0,3600`. `EARC` is the elliptical version, taking two radii r1 (horizontal) and r2 (vertical): `earc x,y,r1,r2,0,3600` draws a whole ellipse, and when r1 equals r2 it degenerates to a circle.

The filled counterparts are `CIRCLE x,y,r`, `PIE x,y,r,start,end` (a solid wedge — the filled analogue of `ARC`), `ELLIPSE x,y,r1,r2` and `EPIE x,y,r1,r2,start,end`. The manual illustrates `PIE` with a disc-space meter: read `DFREE`, scale it into the 0–3600 range, then draw two `PIE` wedges back-to-back — one for free space, one for used.

## Line styles

`SET LINE mask,thickness,startpoint,endpoint` controls every outline command except `DRAW` and `POINT` (use `POLYLINE`, `BOX`, `RBOX`, `ARC` or `EARC` to see the effect). `mask` is a 16-bit bitmap — `%1111111111111111` is solid, `%1111000011110000` is dotted, and values between 0 and 65535 give almost endless variations; `thickness` runs 1–40; the two endpoint styles are 0=SQUARED, 1=ARROWED, 2=ROUNDED.

## Filled shapes and patterns

`BAR x1,y1 TO x2,y2` draws a filled rectangle, `RBAR` its rounded-corner twin, and `POLYGON` the filled version of `POLYLINE`. `PAINT x,y` is contour fill: give it a point inside an enclosed outline and it floods the surrounding region in the current ink. The outline must be unbroken — a dotted mask such as `%1111000011110000` leaves gaps and the fill leaks out across the screen. (`PAINT` is the STOS equivalent of the `FILL` found in other Basics; STOS's own `FILL` does something quite different, so don't confuse them.)

The fill appearance is set with `SET PAINT type,pattern,border`. The first argument picks the family:

- **0** — not filled (outline only).
- **1** — solid, in the current ink.
- **2** — one of 24 dotted patterns (`pattern` 1–24).
- **3** — one of 12 lined patterns (`pattern` 1–12).
- **4** — a user-defined pattern (see `SET PATTERN`).

For types 0, 1 and 4, set `pattern` to 1. `border` is 0 or 1; a border of 1 outlines the filled area in the current ink.

`SET PATTERN address` supplies the bitmap used by type 4. Each pattern is 16×16 pixels and occupies 16 two-byte words per colour plane; it can live in a string, an integer array or a sprite bank, with its address passed in via `VARPTR`. The easy route is to design the pattern as a 16×16 sprite in the sprite editor and point `SET PATTERN` at that sprite's image data.

The full worked example of this address arithmetic is given in the `SET PATTERN` command entry; the manual defers the underlying detail to the technical reference in Chapter 12.

## Colour animation: FLASH and SHIFT

`FLASH index,"(colour,delay)(colour,delay)..."` cycles a single index through a list of colours under interrupt. `delay` is in 50ths of a second and `colour` is the usual `$RGB` value; up to 16 colour changes are allowed per `FLASH`. `flash 1,"($007,10)($000,10)"` flips index 1 between blue and black every fifth of a second. `FLASH OFF` stops all flashing — worth calling before loading pictures, since index 2 flashes by default at startup.

`SHIFT delay[,start]` rotates the entire palette through the colour indices (the famous Neochrome waterfall). `delay` is again in 50ths of a second; the optional `start` leaves the lower indices untouched and defaults to 1. `shift 10` is a typical call.

## Writing modes (GR WRITING)

By default new graphics overwrite whatever sits underneath. `GR WRITING mode` changes how new pixels combine with existing ones:

- **1 — Replace.** The default; new drawing overwrites the screen.
- **2 — Transparent.** Only non-zero pixels of the new drawing are plotted; zero-coloured parts are skipped.
- **3 — XOR.** New and existing pixels are exclusive-ORed, so overlapping areas change colour. Drawing the same object twice in XOR mode erases it — a quick way to wipe complex polygons from the screen.
- **4 — Inverse transparent.** The opposite of mode 2; only zero-coloured pixels of the new drawing are plotted.

The `GR` prefix distinguishes this from `WRITING`, which governs text output — take care not to confuse the two. The manual's demo loops `GR WRITING` through modes 1–4, each time drawing a filled bar and a filled circle to show the difference.

## Polymarkers

`POLYMARK x1,y1;x2,y2;...` plots a list of markers — crosses, diamonds, squares and so on — in the current ink, the GEM VDI polymarker facility brought into STOS. The default marker is a dot. `SET MARK type,size` chooses the shape and size: six marker types and eight sizes stepping in 11-pixel increments from 6 to 83 pixels wide. The manual notes that the square markers are especially handy for laying out large grids with a few lines of code.

## Clipping

`CLIP x1,y1 TO x2,y2` confines all subsequent graphics to a rectangle; anything drawn outside is trimmed to fit. It is often paired with STOS windows. Turn it off again with `CLIP OFF`.
