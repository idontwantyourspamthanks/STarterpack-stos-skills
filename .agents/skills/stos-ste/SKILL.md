---
name: stos-ste
description: STOS Basic programming with the STE extension (Asa Burrows) on Atari STE hardware - six joysticks, light gun, 4096-colour palette, DAC sample sound, single-pixel hardware scrolling. Use ONLY when the user has said they are on an STE AND the extension is installed/loaded; vanilla ST and vanilla STOS do not have these commands.
---

# The STE extension

The STE extension (Asa Burrows, 1991/92) gives STOS access to Atari STE
hardware: six joystick ports, light gun/pen, the 4096-colour palette, the
DAC stereo sample player with microwire volume/treble/bass, and single-pixel
hardware scrolling.

## GATE - read first

These commands exist ONLY on STE hardware AND only when the STE extension is
installed and loaded. A plain ST (or vanilla STOS on any machine) does not
have them. If the user has not said they are on an STE with the extension
loaded, ask - or use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/ste/Extensions/Stos/STE_EXTN.EXF`
(interpreter, goes in the STOS folder) and
`extensions/ste/Extensions/Compiler/STE_EXTN.ECF` (compiled programs).
Documented from Asa Burrows' official manual (`extensions/ste/STOS_STE.DOC`);
a bigger registered manual existed but does not survive online.

Note: the related BLITTER extension (BLITTER.EX*, slot G) is a SEPARATE
extension and is NOT covered here.

## Key concepts

- `STE()` returns 1 on STE hardware, 0 otherwise - use it to make one program
  that detects the machine and enables STE extras conditionally.
- Six joystick ports; the light gun/pen button reads via `FSTICK(3)`.
  `STICKS ON` enables twin-stick interrupts and disables the mouse.
- `E COLOUR`/`E PALETTE` take hex RGB values ($fff = white) across 4096
  colours (the ST has 512). `E COLOR` (one U) is the function form - STOS
  forbids a command and function sharing a name.
- DAC plays raw stereo samples; convert Maestro-format samples with
  `DAC CONVERT`. Speed 0-4 = 6/12.5/25/50 Khz; volumes 0-12 (the doc and
  tutorials disagree on ranges - see `reference/errata.md`).
- Hardware scrolling is single-pixel: set up `HARD SCREEN SIZE` /
  `HARD PHYSIC`, switch on `HARD INTER ON`, then animate with
  `HARD SCREEN OFFSET`. STOS turns scrolling off automatically on error.

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (system, joystick, lightgun,
  palette, dac, scrolling).
- Source discrepancies and open questions: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-blitter, stos-maestro,
  stos-gbp.
