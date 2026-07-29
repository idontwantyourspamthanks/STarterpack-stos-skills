---
name: stos-maestro
description: STOS Basic programming with the STOS Maestro sound extension (Mandarin, 1989) - interrupt-driven sample playback, pitch-shifted notes, loops/reverse/sweep effects, and cartridge recording. Use ONLY when the user has said the Maestro extension is installed/loaded; vanilla STOS does not have these commands.
---

# STOS Maestro

STOS Maestro (Mandarin Software, 1989, by Jon Wheatman of New Dimensions) is
the classic sample-sound extension: up to 32 named samples per memory bank
played back on interrupt (independent of the program), with speed, loop,
reverse and sweep effects, plus raw-sample playback from any address.
Recording requires the Maestro Plus sampler cartridge.

## GATE - read first

These commands exist ONLY when the Maestro extension is installed and loaded.
Vanilla STOS does not have them. If the user has not said the extension is
loaded, ask - or use vanilla STOS (see the stos-syntax skill). Recording
commands (SAMRECORD, SAMTHRU, SAMPLE) additionally need the Maestro Plus
cartridge - they are marked as such.

The extension ships in this repo: `extensions/maestro/Extensions/Stos/MAESTRO.EXD`
(interpreter, goes in the STOS folder) and
`extensions/maestro/Extensions/Compiler/MAESTRO.ECD` (compiled programs), plus
the MAESTRO.ACB sample-bank creator accessory. Documented from the official
scanned manual (kept at `extensions/maestro/stos_maestro_manual.pdf`).

## Key concepts

- Always `click off` first - the keyboard click interferes with the sampler;
  the usual idiom is `10 click off` / `20 sound init`.
- Samples live in a memory bank (default 5), up to 32 per bank, made with the
  MAESTRO.ACB accessory; `SAMBANK n` switches banks. `.SAM` files start with
  a `JON` header (see `reference/formats.md`).
- Playback is interrupt-driven: it keeps going while your program does other
  things. It is incompatible with STOS MUSIC - use `music freeze` before and
  `music on` after.
- `SAMSPEED AUTO` reads the rate encoded in the bank by the Maestro sampler
  program and ERRORS on foreign samples (e.g. anything made with SAMRECORD);
  `SAMSPEED MANUAL` returns to the last `SAMSPEED n`.
- Loop/reverse/sweep only affect FUTURE playback - `SAMSTOP` for the current
  sample.
- Related: the Missing Link's DIGIPLAY also plays raw samples (stos-missing-link
  skill); the STE extension's DAC is the STE alternative (stos-ste skill).

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (playback, speed, modes, cartridge).
- .SAM/.MBK file formats and the playback engine: `reference/formats.md`.
- Source discrepancies: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-ste, stos-blitter,
  stos-gbp, stos-3d.
