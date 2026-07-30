---
name: stos-workflow
description: The edit -> sync -> run -> debug loop for STOS Basic programs in the Hatari emulator on Linux. Use when the user wants to run, test, or debug a STOS program, or pastes a STOS runtime error.
---

# STOS workflow (Hatari)

## The loop

1. Edit `src/*.bas` as plain text: every line numbered, flush at column 0,
   no blank lines, pure ASCII.
2. Run `scripts/sync.sh` (bundled here as `reference/sync.sh`). It writes
   `dev/gemdos/<NAME>.ASC` - the emulated C: drive - after stripping UTF-8
   BOMs, transliterating non-ASCII to ASCII, converting tabs to spaces, and
   removing trailing spaces and blank lines; output uses CRLF line endings.
   It warns (does not fail) on a line with no leading line number.
3. In the Hatari window (launch with `scripts/hatari.sh`, bundled as
   `reference/hatari.sh`), at the `Ok` prompt:

   ```text
   new
   load "HELLO.ASC"
   run
   ```

   `NEW` first because loading an `.ASC` MERGES into whatever is in memory.
   At boot the default folder is the C: root, so a bare filename works - no
   `C:` and no `\` needed. If the folder was changed, `print dir$` shows it.

## When a program errors

The user will paste the STOS error and line number. Fix only that; keep
changes minimal. Re-run `scripts/sync.sh` after every edit, then `NEW` /
`LOAD` / `RUN` again.

## File extensions (LOAD / SAVE)

| ext | meaning |
|-----|---------|
| `.BAS` | tokenized program (native format) |
| `.ASC` | plain ASCII listing - what your editor source becomes |
| `.PRG` | run-only program, launchable from the GEM desktop |
| `.ACB` | accessory (load with `accload "..."`, appears under HELP) |
| `.PI1/PI2/PI3` | Degas screen, low/med/high res |
| `.NEO` | Neochrome low-res screen |
| `.MBK` / `.MBS` | one memory bank / all banks |
| `.VAR` | current variables |

## Atari filesystem and keyboard

- 8.3 names, upper-case is safest; Hatari matches names case-insensitively.
- GEMDOS paths use `\`, but you rarely need them (default folder is C: root).
- The bundled TOS 1.04 ROM is a UK keyboard: `Shift+2` = `"`, `Shift+3` = pound
  sign.

## Reference copies in this skill

- `reference/sync.sh` - the converter (run from the repo, not from here)
- `reference/hatari.sh` - the emulator launcher (same)
- `reference/cheatsheet.md` - the full human cheatsheet with more detail

## Extensions (installing them)

STOS extensions live in slot letters A-Z (the last letter of the `.EX?` /
`.EC?` filename); two extensions can never share a slot. To install one into
the emulated C: drive, copy it into `dev/gemdos/STOS/` (interpreter `.EX?`)
and `dev/gemdos/COMPILER/` (compiler `.EC?`). `scripts/install-extension.sh`
does this for you:

- `scripts/install-extension.sh` - list available extensions and their slots
- `scripts/install-extension.sh NAME ...` - install specific extensions
- `scripts/install-extension.sh --all` - install everything, skipping slot
  conflicts with a warning

Run it AFTER `scripts/setup.sh` (setup rebuilds `dev/gemdos` from scratch, so
extensions must be reinstalled afterwards). At boot, STOS prints a banner for
each extension it loaded - check the boot screen when something misbehaves.

Known conflicts in this repo: `3D.EXS` (STOS 3D) and `LINK3.EXS` (Missing
Link part 3) both want slot S - only one can be installed. And the recovered
MISTY.EXM crashes the boot when Missing Link is also present (it boots alone;
suspected truncated file, under investigation).

## Compiling a program

The compiler is the `COMPILER.ACB` accessory (setup.sh puts it on the C:
root). Flow: `new`, `load "x.asc"`, `list` (verify the program is actually in
memory), `save "x.bas"` (the compiler only eats tokenized .BAS - never .ASC),
`accnew : accload "compiler.acb"`, open the COMPILER accessory from the HELP
menu, DEST BASIC, COMPILE, then `accnew : load "x.cmp" : run`.

Gotchas (all verified in this project):

- "Nothing to compile" means the save happened with EMPTY memory - STOS
  writes an 80-byte header-only .BAS without complaint. Always `list` before
  saving.
- HELP is Print Screen, which hosts capture; `dev/keymap.txt` maps Scroll
  Lock to it and hatari.sh picks it up automatically.
- DEST BASIC makes .CMP (runs inside STOS); DEST GEM makes a standalone .PRG
  (+40-80k, unlistable).
- Compiled programs using extensions need the compiler-form `.EC?` files in
  `dev/gemdos/COMPILER/` (install-extension.sh handles it).
- Full theory in the `reference/` of the stos-syntax skill
  (`compiler.md`).
