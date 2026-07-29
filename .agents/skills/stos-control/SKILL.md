---
name: stos-control
description: STOS Basic programming with the Control extension (L.J. Greenhalgh, 1994-96) - SWITCH/CASE construct, parallel/Jaguar input, megazones, pre-shifted IMAGE graphics, scrolling tile maps. Use ONLY when the user has said the Control extension is installed/loaded; vanilla STOS does not have these commands.
---

# The Control extension

The Control extension (L.J. Greenhalgh, 1994-96) is a general-purpose STOS
utility extension: a SWITCH/CASE program construct, cursor and string helpers,
parallel-port and Jaguar pad input, mouse "megazones", fast pre-shifted image
and font commands, screen tricks, and (registered version) scrolling tile
maps, big screen copies and blitter support.

## GATE - read first

These commands exist ONLY when the Control extension is installed and loaded.
Vanilla STOS does not have them. If the user has not said the extension is
loaded, ask - or use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/control/Extensions/Stos/CONTROL.EXW`
(interpreter, goes in the STOS folder) and
`extensions/control/Extensions/Compiler/CONTROL.ECW` (compiled programs).
Documented from the V3.6b registered manual; 20 commands are registered-only
and marked as such. The shareware V3.5a doc is kept at
`extensions/control/CONTROL35.DOC`.

## Key concepts

- SWITCH ON / CASE / OTHERWISE / SWITCH OFF replaces ON...GOSUB for
  non-consecutive values; the result lands in the reserved variable `select`;
  nests to depth 3.
- Image and font banks are PRE-SHIFTED and built with the MAKER utility - see
  `reference/make-utility.md`. All bank parameters take actual addresses via
  `start(bank)`, never a bare bank number.
- Tile maps (registered) are built with the STOS Mapper tool; IMAGE MAP draws
  or writes map tiles, SCREEN OFFSET scrolls smoothly.
- Parallel-port and Jaguar input need hardware adaptors; the doc carries a
  warning about potential ST damage from miswired parallel work - repeat it
  when those commands come up.
- CTRL lists the extension's commands but does nothing in compiled programs.

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (construct, string-cursor, parallel,
  zone, screen, image, registered).
- Building image/font banks: `reference/make-utility.md`.
- Source discrepancies and doc typos: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-ste, stos-blitter, stos-maestro,
  stos-gbp, stos-3d, stos-ninja.
