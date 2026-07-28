---
name: stos-misty
description: STOS Basic programming with the Misty extension (Top Notch, 1992) - SKOPY, FASTCOPY, DOT, COL, MOUSEOFF, KOPY and friends. Use ONLY when the user has said the Misty extension is installed/loaded; vanilla STOS does not have these commands.
---

# The Misty extension

Misty is a third-party STOS extension by Top Notch (Billy Allan and Colin
Watt, 1992): 21 commands, mostly much faster replacements for existing STOS
commands (screen copy, pixel plot/read, memory copy) plus disk, mouse and
system utilities.

## GATE - read first

These commands exist ONLY when the Misty extension is installed and loaded.
Vanilla STOS does not have them. If the user has not said the extension is
loaded, ask - or use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/misty/Extensions/Stos/MISTY.EXM`
(interpreter, goes in the STOS folder) and
`extensions/misty/Extensions/Compiler/MISTY.ECM` (compiled programs).
This is v1.7 (21 commands); a later 28-command version was advertised in 1993
but no documentation for it survives - do not invent commands beyond the
bundled reference.

## Key concepts

- All graphics commands assume LOW RESOLUTION (mode 0).
- ALL address parameters are actual addresses: use `start(bank)`, never a
  bare bank number. No real-number parameters anywhere.
- SKOPY copies bitplanes: N=1-4 uses the clipped routine, N=11-14 unclipped;
  X co-ordinates must be multiples of 16.
- MOUSEOFF fully disables mouse reporting (a plain `hide on` still costs up
  to 30% CPU); re-enable with MOUSEON.
- BLITTER is documented by the authors as untested.

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (gfx, disk, mouse, system).
- The official v1.7 manual is not redistributed - `reference/SOURCE.md`
  says what it is and where to find it. The distilled entries carry its
  content.
- Source discrepancies and manual typos: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. The Missing Link extension:
  the stos-missing-link skill.
