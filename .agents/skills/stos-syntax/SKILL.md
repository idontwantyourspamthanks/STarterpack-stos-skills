---
name: stos-syntax
description: Write, edit, review, or debug STOS Basic code for the Atari ST. Use whenever producing .bas/.ASC listings, answering STOS syntax questions, or fixing STOS errors. STOS is NOT Visual Basic, GFA Basic, or Amiga BASIC - never guess syntax; look it up in the bundled reference.
---

# STOS Basic syntax

You are writing STOS Basic (Atari ST, Mandarin/Jawx 1988, version 2.5).
All authoritative documentation is bundled under `reference/` in this skill -
use it instead of memory or outside knowledge.

## Hard rules for generated code

- **Variables are INTEGER by default** — fractional values are silently
  truncated. Suffix with `#` for floats (`DX#`, `VEL#`) and `$` for strings.
  Anything involving physics, trig tables, scaling or damping MUST use `#`
  variables, including arrays (`dim DX#(15)`). This also applies to reading
  fractional `data` into an array.
- **PLOT/DRAW do not clip** — off-screen coordinates throw
  *Illegal function call*. Clamp to 0-319 / 0-199 (MODE 0) before drawing
  shapes that extend past a screen edge.
- **Execution falls through line numbers** — never number a subroutine
  between a loop body and its `NEXT`, and keep all subroutines behind an
  `END` (or `GOTO`) so the main flow cannot fall into them.
- **CLEAR KEY at every screen/state transition** — buffered keypresses
  (menu dismissals, TOS auto-repeat) otherwise fire in the next context.
- Plain ASCII only. No smart quotes, no Unicode, no UTF-8 BOM.
- Every line must have a line number, flush at column 0 (no leading
  whitespace before the number). No blank lines.
- One statement per line unless `:` separation is genuinely clearer.
  Comment with `REM` or a leading `'`. Keep lines <= ~80 columns.
- String literals use straight double quotes (`"`).
- 8.3 upper-case filenames; load with a bare filename, e.g. `load "HELLO.ASC"`.
- Target low resolution (`MODE 0`, 320x200, 16 colours) unless told otherwise;
  avoid STE-only commands unless the user is on an STE.
- Keep snippets small and self-contained so they can be synced and RUN directly.

## Editorial policy (binding)

- This reference already contains the project owner's verified corrections to
  the 1988 manual - for example ENVEL max speed 65535, `listbank` (not
  `listbanks`), CHANGE MOUSE image numbers, 8 address and 8 data registers
  (A0-A7, D0-D7), the move-string optional start position before the first
  bracket, 1 radian = about 57 degrees. NEVER "fix" the reference back toward
  the printed manual.
- Never invent syntax. If something is not in the reference, say so instead of
  guessing. STOS is not VB, GFA Basic, or Amiga BASIC.
- Resolutions of known manual errors/ambiguities are recorded in
  `reference/errata-response.md`; open items in `reference/errata.md`.

## How to look things up

- Syntax of a specific command or function: find it in `reference/index.md`,
  then follow the link to `reference/commands/<topic>.md` (topic files group
  commands: screen, sprites, sound, strings, files, memory-banks, menus,
  graphics, editor, text-windows, other-commands, appendix-d, appendix-e).
- Concepts and how-tos (sprites, music, screens, windows, memory banks, menus,
  the editor): read `reference/topics/<topic>.md`.
- Compiling programs to run-only .PRG files: `reference/compiler.md`.
- Sprites: the MOVE X entry in `reference/commands/sprites.md` documents
  move strings; a supplementary guide informed it (see `reference/SOURCE.md`).
- Move strings for MOVE X/MOVE Y: (speed,step,count) tuples in brackets, L to
  loop, E to stop at a position, optional start position before the first
  bracket - see the MOVE X entry in `reference/commands/sprites.md`.
- The Missing Link extension (BOB, JOEY, TILE, DIGIPLAY, MANY BOB...): if -
  and only if - the user has that extension installed, see the
  stos-missing-link skill.
- The Misty extension (SKOPY, FASTCOPY, DOT, COL, MOUSEOFF...): if - and only
  if - the user has that extension installed, see the stos-misty skill.
- The Control extension (SWITCH/CASE, IMAGE PUT, megazones, tile maps...):
  if - and only if - the user has that extension installed, see the
  stos-control skill.
- The STE extension (DAC sound, hardware scrolling, six joysticks...): if -
  and only if - the user is on an STE with that extension installed, see
  the stos-ste skill.
- The Blitter extension (blit copy/cls, CPU-independent block copies...): if
  - and only if - the machine has a blitter and that extension is
  installed, see the stos-blitter skill.
- The Maestro extension (sample playback, SAMPLAY/SAMRAW...): if - and
  only if - that extension is installed, see the stos-maestro skill.
- The GBP extension (FASTWIPE, D CRUNCH, GBP file banks...): if - and only
  if - that extension is installed, see the stos-gbp skill.
- The STOS 3D extension (Td 3D worlds...): if - and only if - that
  extension is installed, see the stos-3d skill.

## Verified starter snippet

```stos
10 mode 0 : hide
20 ink 1 : paper 0 : cls
30 locate 0,4 : centre "Hello, STOS!"
40 wait key
50 end
```
