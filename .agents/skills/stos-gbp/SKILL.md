---
name: stos-gbp
description: STOS Basic programming with the GBP extension (Neil Halliday / GBP Software, V4.7) - FASTWIPE and mirror graphics, packer unpacking (D CRUNCH), GBP file banks, printer/special-key utilities, STE sound (EPLAY/DAC volume) and cookies. Use ONLY when the user has said the GBP extension is installed/loaded; vanilla STOS does not have these commands.
---

# The GBP extension

The GBP extension (Neil Halliday / GBP Software, 1992-1995) is a utility
grab-bag: fast screen clearing and mirroring, unpacking for the common packer
formats (Speed Packer, Atomik, Ice, Automation, Fire), GBP file banks for
storing many files in one memory bank, printer/special-key utilities, and a
set of STE commands (hardware samples, DAC volume/treble/bass, cookie jar,
light pen).

## GATE - read first

These commands exist ONLY when the GBP extension is installed and loaded.
Vanilla STOS does not have them. If the user has not said the extension is
loaded, ask - or use vanilla STOS (see the stos-syntax skill). The ste.md
commands additionally need STE hardware.

The extension ships in this repo: `extensions/gbp/Extensions/Stos/GBP.EXP`
(interpreter, goes in the STOS folder), plus the GBP_BANK.ACB bank-builder
accessory. The compiler version was registered-only and is not included.
Documented from the official shareware manual (`extensions/gbp/GBP.DOC`),
with the inventory verified against the V4.7 binary's token table.

## Key concepts

- ALL address parameters are actual addresses - `start(bank)`, never a bare
  bank number (the manual is emphatic: pass `start(10)`, not `10`).
- D CRUNCH unpacks Speed Packer 2/3, Atomik 2.5, Ice 2.11/2.40, Automation v5
  and Fire v2.0 in place (a0->a0): the packed data is OVERWRITTEN, so reserve
  the bank at the ORIGINAL (unpacked) file length. PAKTYPE identifies the
  format, PAKSIZE gives the unpacked length.
- GBP file banks (built with the GBP_BANK.ACB accessory) store many files in
  one memory bank; FSTART/FLENGTH/FOFFSET locate them.
- FASTWIPE is the author's original routine that inspired Missing Link's WIPE.
- Related: STE extension DAC commands (stos-ste) overlap the GBP STE set; the
  Blitter extension (stos-blitter) is the other fast-copy option.

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (misc, file, graphics, ste).
- Source discrepancies (undocumented PERCENT, JAR vs V4.7, SETPRT
  function/procedure conflict): `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-ste, stos-blitter,
  stos-maestro, stos-3d.
