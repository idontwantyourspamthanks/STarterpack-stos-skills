---
name: stos-ninja
description: STOS Basic programming with the Ninja Tracker extension (L.J. Greenhalgh, V1.05) - background ProTracker mod playback on STE/TT/Falcon. Use ONLY when the user has said they are on STE/TT/Falcon hardware (1 meg) AND the extension is installed/loaded; other machines and vanilla STOS do not have these commands.
---

# The Ninja Tracker extension

Ninja Tracker (L.J. Greenhalgh, 1994/95, V1.05) plays 4-channel ProTracker
mods and most chip music formats in the background while your STOS program
runs - no pre-conversion needed (unlike STOS Tracker): load the mod into a
memory bank and play it.

## GATE - read first

These commands exist ONLY on STE/TT/Falcon hardware with at least 1 meg AND
when the extension is installed and loaded. A plain ST or vanilla STOS does
not have them. If the user has not said they meet both conditions, ask - or
use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/ninja/Extensions/Stos/TRACKER.EXT`
(interpreter, goes in the STOS folder) and
`extensions/ninja/Extensions/Compiler/TRACKER.ECT` (compiled programs).
Documented from the author's official TRACKER.DOC.

## Key concepts

- Load the mod into a bank (at least 20K larger than the mod - the player
  needs workspace), then `TRACK PLAY` starts it. The same command STOPS it
  too (toggle).
- Do NOT stop and restart a mod - it screws up. Reload it instead.
- Frequency values: 5000, 8500, 12000, 14000, 21000 (default 16 khz; higher
  = better sound, less CPU left for your program).
- The keyboard cannot be read normally while a mod plays - use `TRACK KEY`
  (reads $FFFC02) or Misty's HARDKEY.
- `TRACK INFO` (command list) exists only in the interpreter, not compiled.
- Sample playback alternatives: Maestro (stos-maestro) for samples on any ST,
  the STE extension's DAC (stos-ste), Missing Link's DIGIPLAY
  (stos-missing-link).

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (playback, system).
- Source discrepancies: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-ste, stos-blitter,
  stos-maestro, stos-gbp, stos-3d.
