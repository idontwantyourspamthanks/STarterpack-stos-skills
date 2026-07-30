# STOS performance patterns

How to make STOS Basic games fast, distilled from building MLROID in this
project. The two laws: **performance = command count × bytes moved per
frame**, in that order. Everything below follows from them.

## 1. Compile

The STOS Compiler (`COMPILER.ACB`) is the largest single speed multiplier and
composes with everything else here. Interpreted is for development, compiled
is for shipping. See the compiling section of the cheatsheet for the flow and
gotchas (tokenized `.BAS` only, `list` before `save`, DEST BASIC vs GEM).

## 2. Fewer, bigger commands

Interpreter overhead is per command, not per byte. One call that does a whole
job beats a loop of small calls:

- `MANY BOB` (Missing Link, registered) plots an entire array of bobs in one
  call — image, x, y and status arrays — instead of one `BOB` per rock.
- `MANY ADD`/`MANY INC`/`MANY DEC` apply arithmetic to whole arrays in one call.
- `BCOPY`, `KOPY` (Misty), `FASTCOPY` (Misty) for block moves instead of
  peek/poke loops.

## 3. Bobs, not sprites

Vanilla STOS sprites are software-rendered (max 15, slow). Missing Link bobs
are pre-shifted (~25 16x16 per VBL, no limit). Convert art with MAKE.BAS.
Sprite-formatted art and bob-formatted art are different formats — see
`topics/mbk-format.md` and `make-utility.md`.

## 4. Never repaint the whole frame

Clearing 32 KB every frame is fine for asteroids, wrong for anything with a
background. The real pattern is **incremental redraw**:

- Tilemap games: scroll the map one tile column per step and only redraw
  objects that moved. Missing Link's `WORLD`/`LANDSCAPE` and Control's
  `SET MAP`/`IMAGE MAP`/`SCREEN OFFSET` exist for exactly this.
- Double-buffer (`logic=back` + draw + `screen swap`) only what changed, not
  the whole screen, when you can.

## 5. Move bulk work off the CPU

The Blitter extension runs copies independently of the processor: `BLIT COPY`
for screen-sized moves and fills, then do other work while it runs. Bulk
memory jobs belong to the blitter, not to interpreted loops.

## 6. Music on interrupt, at a sane rate

Tracker music (Ninja Tracker) plays in the background but costs CPU per frame
proportional to the rate. Use the lowest frequency that sounds acceptable
(8500 Hz is fine for most games; 21000 Hz is a luxury). Maestro samples are
likewise interrupt-driven.

## 7. Integer math and lookup tables

STOS variables are INTEGER by default — floats are the slow path and must be
opted into with `#`. Use integer math wherever possible, and precompute
anything transcendental into `data` tables (direction tables beat `sin`/`cos`
in a loop every time).

## 8. Death by a thousand cuts

Small savings that add up:

- `autoback off` when not using STOS sprites (halves graphics work; turns off
  the draw-to-both-screens behaviour).
- Throttle text: only `print` the score when it changes (text rendering is
  expensive).
- `key off` to kill the function-key display line.
- Clip drawing to the play area instead of full-screen operations.
- `hide` the mouse if you don't need it (`mouseoff` in Misty goes further and
  stops mouse processing entirely).
