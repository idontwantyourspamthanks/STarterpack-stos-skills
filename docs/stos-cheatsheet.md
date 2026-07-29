# STOS Basic cheatsheet (for this environment)

## The loop
1. Edit `src/hello.bas` (or any `src/*.bas`) in VS Code. Plain text, **every line
   numbered, flush at column 0, no blank lines**.
2. `Ctrl+Shift+B` (runs *STOS: sync + launch*) — or `./scripts/sync.sh` to just
   convert/copy. This writes `dev/gemdos/<NAME>.ASC` (drive **C:**).
3. In the Hatari window, at the `Ok` prompt:
   ```
   new
   load "HELLO.ASC"
   run
   ```
   `NEW` first because `LOAD` of an `.ASC` *merges* into whatever is in memory.
   At boot the default folder **is** the C: root (the loader ends with
   `Dsetpath("\")`), so a bare filename works — no `C:` and no `\` needed (handy,
   since those keys are awkward on the UK TOS keyboard). If you ever change the
   folder mid-session, `print dir$` shows the current one.

## File extensions (LOAD / SAVE)
| ext | meaning |
|-----|---------|
| `.BAS` | tokenized program (the native format; magic header `Lionpoulos\0`) |
| `.ASC` | plain ASCII listing — **this is what your editor source becomes** |
| `.PRG` | run-only program, launchable from the GEM desktop |
| `.ACB` | accessory (load with `accload "..."`, appears under HELP) |
| `.PI1/PI2/PI3` | Degas screen, low/med/high res |
| `.NEO` | Neochrome low-res screen |
| `.MBK` / `.MBS` | one memory bank / all banks |
| `.VAR` | current variables |

## Commands used by the bundled examples (syntax from the manual)
- `MODE n` — `0` = low res 320x200x16, `1` = medium 640x200x4 (no `2` via MODE).
- `CLS` — clear screen with current `PAPER`.
- `INK n` / `PAPER n` — set pen / background colour index.
- `COLOUR n,$rgb` — set palette index `n` to a 12-bit RGB value (e.g. `$770`).
- `LOCATE x,y` — cursor to column `x`, row `y`.
- `CENTRE a$` — print `a$` centred on the *current* row (so `LOCATE 0,r` first).
- `PRINT ...` — `;` suppresses newline, `,` tabs.
- `HIDE` / `SHOW` — hide / show the mouse pointer.
- `WAIT VBL` — wait one vertical blank (~1/50 s PAL). `WAIT KEY` — wait for a key.
- `FOR v = a TO b [STEP s] ... NEXT v`
- `IF cond THEN statement`  (single line).
- `GOTO n` / `GOSUB n` / `RETURN` / `END` / `STOP`.
- `REM ...` or a leading `'` — comment.  `:` — statement separator on one line.
- `NEW` / `RUN` / `LIST` / `DIR "pattern"` / `LOAD` / `SAVE`.

For anything not listed (sprites, music, windows, blitter, strings like `MID$`/`VAL`),
consult `Stos and Compiler/STOS Manual.pdf` — do not guess; STOS is not VB/GFA/Amiga
BASIC. The compiler is documented in `STOS Compiler-User Guide.pdf`.

## Atari filesystem rules
- **8.3 names**, upper-case is safest (`sync.sh` upper-cases for you).
- GEMDOS paths use `\`, but you rarely need them here: at boot the default folder is
  the C: root, so a bare name like `HELLO.ASC` is enough. Hatari matches names
  case-insensitively.
- This `TOS_1_04.img` is a **UK** keyboard: `Shift+2` = `"`, `Shift+3` = `£`.

## sync.sh gotchas it already handles
UTF-8 BOM stripped; non-ASCII transliterated to ASCII; tabs → spaces; trailing spaces
and blank lines removed; line endings → CRLF (what STOS's own `SAVE "x.ASC"`
writes; override with `STOS_EOL` only if a different STOS build disagrees).
It **warns** (does not fail) on a line that has no leading line number.

## Installing extensions
Extensions live in slot letters A–Z (last letter of the `.EX?`/`.EC?` name) — two
extensions can never share a slot. Install with `scripts/install-extension.sh`:
bare = list available + slots, `NAME...` = install those, `--all` = install all
(conflicts skipped with a warning). Interpreter files land in `dev/gemdos/STOS/`,
compiler files in `dev/gemdos/COMPILER/`. **Run after `scripts/setup.sh`** — setup
rebuilds `dev/gemdos`, wiping installed extensions. Boot banners confirm what loaded.

Known conflicts: `3D.EXS` vs `LINK3.EXS` (both slot S). The recovered `MISTY.EXM`
crashes the boot when Missing Link is present (fine alone; suspected truncated file).

## Verified snippet (verbatim from the manual)
```
10 if mode=2 then stop
20 if mode=0 then mode=1
30 centre "Medium Resolution"
40 locate 0,4 : centre "Press a key"
50 wait key
60 mode 0
70 centre "Low resolution"
80 wait key
```

## Turning a Degas PI1 picture into sprites

STOS loads Degas low-res pictures natively, so a PI1 can become a sprite bank
with no external format knowledge. The in-STOS recipe (uses a seeded bank 1,
because `GET SPRITE` needs an existing image of the target size):

```
10 mode 0 : hide : flash off
20 load "seed.mbk"              : rem bank 1 with a placeholder of the right size
30 reserve as screen 5
40 load "art.pi1",5             : rem picture into screen bank 5
50 screen copy 5 to logic
60 get sprite 0,0,1             : rem grab screen rect into image 1 (mask colour defaults to 0)
70 save "sprite.mbk",1
```

For batch use, `tools/pi1-to-sprite.py` does the whole job host-side - slices a
PI1 into a regular grid and writes a `.MBK` directly, no STOS session needed:

```
python3 tools/pi1-to-sprite.py art.pi1 -o sprites.mbk \
    --cell-w 16 --cell-h 16 --cols 20 --rows 12 --mask 0
```

`--cell-w` must be a multiple of 16 (the ST's strip width); `--mask` is the
colour index treated as transparent (default 0). Run `--selftest` to confirm
the binary format matches STOS's own output byte-for-byte (against the
`tools/fixtures/GRAB.MBK` fixture STOS authored via GET SPRITE). The on-disc
layout is documented in `docs/stos-sprite-bank-format.md`.
