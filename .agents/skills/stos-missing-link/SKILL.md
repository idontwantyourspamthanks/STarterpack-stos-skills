---
name: stos-missing-link
description: STOS Basic programming with The Missing Link extension (Top Notch, 1993) - BOB, JOEY, TILE, DIGIPLAY, MANY BOB and friends. Use ONLY when the user has said the Missing Link extension is installed/loaded; vanilla STOS does not have these commands.
---

# The Missing Link extension

The Missing Link is a third-party STOS extension by Top Notch (Colin Watt and
Billy Allan, 1993): ~70 faster/extra commands, mostly for games (pre-shifted
sprites, mapping, file handling, sound).

## GATE - read first

These commands exist ONLY when the Missing Link extension is installed and
loaded. Vanilla STOS does not have them. If the user has not said the
extension is loaded, ask - or use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/misslink/Extensions/Stos/`
(`LINK1.EXQ`, `LINK2.EXR`, `LINK3.EXS` for the interpreter) and
`extensions/misslink/Extensions/Compiler/` (`LINK1.ECQ`, `LINK2.ECR`,
`LINK3.ECS` for compiled programs).

## Key concepts

- BOBs and JOEYs are pre-shifted sprites: much faster than SPRITE, no 15-sprite
  limit, but more memory. JOEY is the single-colour variant.
- Image numbers start from 0: sprite 1 becomes bob 0 when converted.
- BOB/tile banks and digibanks are produced by the MAKE utility - see
  `reference/make-utility.md`.
- Graphics commands can target back, physic, logic, or any memory bank -
  pass `start(bank)` for banks.
- Some commands require the registered version; entries are marked
  "Registered version only."

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (sprites, mapping, text, gfx,
  palette, files, sound, joystick, misc).
- Converting sprites/samples for use with BOB/TILE/DIGIPLAY:
  `reference/make-utility.md`.
- Sources used for the distilled entries: `reference/SOURCE.md`.
- Source discrepancies: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. The Misty extension (SKOPY,
  FASTCOPY...): if - and only if - that extension is installed, the
  stos-misty skill. The Control extension: if - and only if - that extension
  is installed, the stos-control skill. The STE extension: if - and only if
  - the user is on an STE with it installed, the stos-ste skill. The
  Blitter extension: if - and only if - the machine has a blitter and it is
  installed, the stos-blitter skill. The Maestro extension: if - and only
  if - it is installed, the stos-maestro skill.
