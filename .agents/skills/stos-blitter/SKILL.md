---
name: stos-blitter
description: STOS Basic programming with the Blitter extension (NuBlitter v1.1, Asa Burrows) on blitter-equipped hardware (STE or Mega ST) - CPU-independent block copies, halftone fills, skew/mask/logical operations. Use ONLY when the user has said the machine has a blitter AND the extension is installed/loaded; other machines do not have these commands.
---

# The Blitter extension (NuBlitter)

NuBlitter v1.1 (Asa Burrows / Architect & Line, 1992) drives the Atari
blitter chip from STOS: screen clears and copies that run independently of
the main CPU, plus word-level control (increments, counts, endmasks) and the
full halftone/skew/logical-operation feature set.

## GATE - read first

These commands exist ONLY on blitter-equipped hardware (STE, or ST/Mega ST
with a blitter chip) AND only when the extension is installed and loaded. If
the user has not said they have both, ask - or use vanilla STOS (see the
stos-syntax skill). `blit busy` checks for a blitter (though see its Gotcha:
the doc gives it two meanings).

The extension ships in this repo: `extensions/blitter/Extensions/Stos/BLITTER.EXG`
(interpreter, goes in the STOS folder) and
`extensions/blitter/Extensions/Compiler/BLITTER.ECG` (compiled programs).
The command inventory was verified against the token table inside BLITTER.EXG
itself. Note: a DIFFERENT blitter extension by STORM/Neil Halliday also
exists with different command names - this skill covers the NuBlitter binary
only. See `reference/errata.md`.

## Key concepts

- The blitter works independently of the CPU: start it with `blit it` and
  your program can do other work while it copies.
- Easy path: `blit cls` (clear) and `blit copy` (block copy, regions rounded
  to 16-pixel X boundaries, op 1-14 boolean table where 3 = straight copy and
  6 = XOR/transparent).
- Power path: set source/dest addresses, X/Y increments, counts and endmasks
  word by word, then `blit it`. Wrong setup crashes the machine - the doc
  says so itself.
- `blit hog` monopolizes the machine and breaks STOS's interrupts - avoid it.
- The extension is by the same author as the STE extension; they complement
  each other (stos-ste skill).

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (setup, masks, operations, copy,
  control).
- Source discrepancies (the BLIT BUSY double meaning, undocumented BLIT
  REMAIN, the STORM-vs-NuBlitter split): `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-ste, stos-maestro,
  stos-gbp.
