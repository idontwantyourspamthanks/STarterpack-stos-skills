# STOS Starter Pack

A VS Code + Hatari starter project for writing **STOS Basic** games and demos
for the Atari ST. Edit plain-text `.bas` files in VS Code, press
`Ctrl+Shift+B`, and your program boots into STOS in the Hatari emulator ready
to `run`.

It also ships five AI-agent skills (in `.agents/skills/`) that give an AI
assistant deep, verified knowledge of STOS Basic and the most popular
extensions — handy whether or not you code with an AI.

## What's in the box

```
.vscode/          tasks: Ctrl+Shift+B = sync + launch
.agents/skills/   stos-syntax, stos-workflow, stos-missing-link, stos-misty, stos-control
scripts/          setup.sh, sync.sh, hatari.sh
src/hello.bas     starter program
examples/         a bigger example
docs/             cheatsheet + setup notes
dev/              emulator runtime dirs (created on first setup)
```

## You must supply (not redistributable)

STOS itself, the TOS ROM, and the Misty/Missing Link extension binaries are
copyrighted and are **not** in this pack. You need your own copies (from your
original disks, or the copies archived all over the Atari community):

1. **STOS + compiler**, laid out like this (this is the layout the original
   STOS disks and most archives use):

   ```
   Stos and Compiler/
   ├── BASIC208.TOS      ← the STOS loader
   ├── STOS/             ← interpreter + data files
   ├── ACB/              ← accessories
   ├── COMPILER/         ← the compiler
   └── AUTOEXEC.BAS      ← optional
   ```

   Drop that folder in the project root. Different name or location? Set
   `STOS_RAW=/path/to/it` when running setup.

2. **A TOS ROM image** at `tos/TOS_1_04.img` (TOS 1.04 recommended; 1.02,
   1.06, 1.62 and 2.06 also work). Override with `STOS_TOS_SRC=/path/to.rom`.
   Note the UK keyboard layout on these ROMs: `Shift+2` = `"`.

3. **Extensions (optional)**: if you own Misty or The Missing Link, copy the
   extension files into the emulated drive after setup — interpreter versions
   (e.g. `MISTY.EXM`, `LINK1.EXQ`…) into `dev/gemdos/STOS/`, compiler versions
   (e.g. `MISTY.ECM`, `LINK1.ECQ`…) into `dev/gemdos/COMPILER/`.

## Quickstart

Dependencies (Debian/Ubuntu names): `sudo apt install hatari mtools python3`
(bash, sed, awk, iconv are already on any Linux).

```bash
scripts/setup.sh      # builds dev/gemdos (the emulated C: drive) + boot media
scripts/hatari.sh     # boots Hatari straight into STOS
```

Then, in the STOS window, at the `Ok` prompt:

```
new
load "HELLO.ASC"
run
```

Day to day you won't even do that: edit `src/hello.bas`, press
`Ctrl+Shift+B` in VS Code (sync + launch), then `new` / `load "HELLO.ASC"` /
`run` in STOS. `NEW` matters: loading an `.ASC` file *merges* into whatever is
in memory.

## How the drive layout works

There is no floppy image to build. Hatari's GEMDOS feature exposes the host
folder `dev/gemdos/` to the emulated ST as hard drive **C:**. `scripts/setup.sh`
copies your STOS system there (`BASIC208.TOS`, `STOS/`, `ACB/`, `COMPILER/`),
and `scripts/sync.sh` writes your converted programs there as `<NAME>.ASC`.

- Hatari auto-starts `C:\BASIC208.TOS` (the STOS loader) at boot.
- At the `Ok` prompt the default folder is the C: root, so a bare
  `load "HELLO.ASC"` works — no `C:` or `\` needed.
- `dev/disks/blank-a.st` (created by setup) is just a blank drive A: so TOS
  doesn't sit searching an empty drive.
- `dev/roms/tos.img` is staged from your `tos/` image by setup.

More detail in `docs/setup-notes.md` and `docs/stos-cheatsheet.md`.

## The AI skills

If you use an AI coding assistant that discovers `.agents/skills/`:

- **stos-syntax** — the whole STOS manual, distilled and verified: every
  command, corrected examples, known manual errata (with resolutions).
- **stos-workflow** — this repo's edit → sync → run → debug loop.
- **stos-missing-link** — The Missing Link extension (~70 commands), from the
  official Top Notch docs. Gated: only activates when you say the extension
  is installed.
- **stos-misty** — the Misty extension (21 commands), from the official v1.7
  manual. Gated the same way.
- **stos-control** — the Control extension (56 commands): the SWITCH/CASE
  construct, parallel/Jaguar pad input, megazones, pre-shifted graphics, and
  scrolling tile maps. From the official V3.6b manual, gated the same way.

The reference material in these skills was distilled from the STOS manual and
the extensions' official documentation. Verbatim source documents are not
redistributed; each skill's `reference/SOURCE.md` says what they were and
where to find them. Errata and their resolutions are included, so the AI
won't repeat the printed manual's own bugs.

## Licence

The pack's original content (scripts, skills, build tooling) is MIT — see
`LICENSE`. The distilled knowledge base is derived from the STOS manual and
extension documentation, whose copyrights remain with their owners; it is
provided for educational use. STOS, TOS, and the extension binaries are not
part of this pack and remain the property of their respective owners.
