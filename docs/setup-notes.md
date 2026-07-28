# Setup notes — how this STOS dev environment works

## The one-paragraph version
You edit plain-text STOS in VS Code (`src/*.bas`). `scripts/sync.sh` converts it to
the form STOS can read and drops it on an emulated hard drive (`dev/gemdos`, seen by
the ST as **C:**). `scripts/hatari.sh` boots Hatari, which auto-starts the STOS
interpreter and lands you at the `Ok` prompt. You type `load "HELLO.ASC"` then `run`.
That is the whole loop.

## Why a GEMDOS hard drive instead of floppies
The raw STOS materials ship as loose files (~680 KB across `STOS/`, `ACB/`,
`COMPILER/`) — too big for one 720 KB floppy, which is why STOS originally came on
three discs. A GEMDOS host directory exposed as a hard drive (`-d/--harddrive`) has
no size limit, needs no `mtools` image-building, and is just a normal folder you can
inspect. STOS reads/writes it through ordinary GEMDOS calls (the loader already
proves this by loading its extensions from the `\STOS\` folder).

## How boot works
- `-d dev/gemdos` makes that folder drive **C:**.
- `--auto 'C:\BASIC208.TOS'` makes Hatari hand TOS a virtual INF so the loader runs
  automatically after the desktop appears — no boot sector, no `\AUTO\` folder needed.
- `--disk-a dev/disks/blank-a.st` puts a *present but non-bootable* floppy in A:.
  Its only job is to stop TOS spinning on an empty drive A (the long white screen you
  see with no disk inserted). A blank `mformat`-made disk is enough; TOS reads sector
  0, sees it is not bootable, and drops straight to the desktop.
- `--fast-boot true` skips the TOS memory test.
- The loader finds the `\STOS\` folder, pulls in `BASIC206.BIN` plus the
  `.EXC/.EXA/.EXF` extensions (COMPILER, PICTURE COMPACTOR, STE), then runs
  `Dsetpath("\")` to reset the current folder to the C: root, and presents the `Ok`
  prompt.

## The .ASC vs .BAS distinction (important)
STOS stores its own programs **tokenized** — every shipped `.BAS` (and `AUTOEXEC.BAS`)
starts with the 11-byte magic `Lionpoulos\0` (Lionet + Sotiropoulos). Plain text from
an editor is **not** that format, so you must use the ASCII route:

- `SAVE "x.BAS"` / `LOAD "x.BAS"` → tokenized program.
- `SAVE "x.ASC"` / `LOAD "x.ASC"` → plain ASCII listing (line numbers + text).

So `sync.sh` writes **`.ASC`** files, and you load them with a bare name, e.g.
`LOAD "HELLO.ASC"`. `LOAD`ing an `.ASC` **merges** into the current program instead of
replacing it, so type `NEW` first if a program is already in memory (a fresh boot is
empty, so `NEW` is only needed on reloads).

## Line endings
`sync.sh` emits **CRLF** (`0x0D 0x0A`) line terminators. This is verified, not
folklore: `SAVE "x.ASC"` inside STOS itself writes CRLF (dump a saved file with
`xxd` to see it), and its ASCII loader rejects anything else — with CR-only or
LF-only input, `LOAD "x.ASC"` reads part of the file, then aborts and misreports
the parse failure as **Disc error**. (An earlier version of these notes claimed
"Atari native = CR"; that assumption was wrong and was itself the cause of the
Disc-error saga.) The `STOS_EOL` variable at the top of `sync.sh` can still flip
the ending (`crlf` / `cr` / `lf`) if some other STOS build ever disagrees.
`sync.sh` also strips a UTF-8 BOM, transliterates non-ASCII to ASCII, drops blank
lines, and warns on any line that does not begin with a line number (the ASCII
loader requires every line to be numbered).

## Paths
A GEMDOS trace of the boot (`hatari --trace gemdos`) shows the loader's last act
is `Dsetpath("\")`, i.e. it leaves STOS's default folder at the **C: root**, and
Hatari matches filenames case-insensitively. So at the `Ok` prompt a bare name is
enough: `load "HELLO.ASC"`. (An earlier note here claimed a `C:` prefix or
backslash triggered Disc error — false; those failures were the line-ending bug
above, misattributed to the path. The bare name remains the simplest form.)
If you ever change the default folder mid-session, `print dir$` shows the current one.

## Keyboard layout
The bundled `tos/TOS_1_04.img` behaves as a **UK** keyboard under Hatari: `Shift+2` =
`"`, `Shift+3` = `£`. Keep that in mind when typing string literals.

## Tunables (environment variables for hatari.sh / setup.sh)
- `STOS_TOS` (default `dev/roms/tos.img`) — TOS ROM; `setup.sh` copies it from
  `STOS_TOS_SRC` (default `tos/TOS_1_04.img`). Other ROMs live in `tos/`.
- `STOS_MACHINE` (default `st`) — set to `ste` if you write STE sound/graphics code.
- `STOS_MEM` (default `1`) — MiB; raise to 2–4 for large programs.
- `STOS_SRC` / `STOS_OUT` — source dir / sync target (defaults `src` / `dev/gemdos`).

## Opt-in: auto-load the compiler on boot
`dev/gemdos/_AUTOEXEC_COMPILER.BAS` is the original third-party autoexec that loads
the compiler accessory at boot. It is deliberately renamed (STOS only auto-runs a file
named exactly `AUTOEXEC.BAS`). To enable it, rename it to `AUTOEXEC.BAS`; the `\ACB`
folder it expects is already on the drive. Leave it renamed for a clean boot straight
into the editor.

## Compile-to-.PRG (power-user path)
Inside STOS, `SAVE "x.PRG"` writes a run-only program that the GEM desktop can launch
directly (after preparing a disc with the `STOSCOPY.ACB` accessory, per the manual).
Placing such a `.PRG` in a boot disk's `\AUTO\` folder auto-runs it. Useful once a
program is finished; the interpret-and-`RUN` loop above is friendlier while editing.

## What was verified, and how
- STOS boots to the `Ok` prompt with the exact `hatari.sh` flags — confirmed by
  recording a short Hatari AVI and inspecting a frame (the splash + `Ok` prompt).
- The synced `.ASC` **loads and runs in STOS** — verified live end to end: STOS's own
  `SAVE "REF.ASC"` produced a CRLF file (the format ground truth), a CRLF test
  listing loaded with a full-file read in the GEMDOS trace, and `src/hello.bas`
  (synced by `sync.sh`) loaded (641/641 bytes read) and ran its demo to completion.
- `--monitor rgb` in `hatari.sh` forces a colour monitor regardless of the host's
  global `~/.config/hatari/hatari.cfg` — a mono setting there (`nMonitorType = 0`)
  makes TOS boot high-res, and `MODE 0` then fails with *Resolution not allowed*.
- The boot-time current folder (C: root) and case-insensitive name matching were
  confirmed host-side via `hatari --trace gemdos`.
- The live `LOAD`/`RUN` is confirmed by *you* at the keyboard (the loop is meant to be
  human-driven; there is intentionally no fragile headless key-injection harness).
