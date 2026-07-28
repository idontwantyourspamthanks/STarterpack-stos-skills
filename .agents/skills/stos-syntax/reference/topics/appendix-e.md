# Appendix E: The STOS Basic Traps

STOS Basic is built in a modular way. Each family of features — windows, sprites, floating-point maths, music — lives in its own file on the STOS system disc and is installed into memory whenever STOS boots. Assembly-language programmers can call the same routines STOS uses internally by firing a 68000 TRAP instruction at them, giving "unprecedented access to the heart of the STOS Basic system." The manual warns that this is also a very easy way to crash the machine.

The four extension files and their TRAP numbers:

- **WINDOWS.BIN** — TRAP #3 (text, cursors, windows, coordinate conversion)
- **SPRITES.BIN** — TRAP #5 (sprites, mouse, screen effects)
- **FLOAT.BIN** — TRAP #6 (IEEE 64-bit floating point)
- **MUSIC.BIN** — TRAP #7 (music and sound effects)

## Calling conventions

Each TRAP expects a function number in a register, plus any parameters in D0/D1/A0 (or D1–D4 for floating point). Results come back in D0 and A0. The function-number register differs between TRAPs — easy to forget:

| TRAP | Function no. in | Parameter registers | Corrupted registers |
| --- | --- | --- | --- |
| #3 Windows | D7 | D0, D1, A0 | (some functions redraw all sprites) |
| #5 Sprites | D0 | D1–D4, A0 | D0, D1, A0 |
| #6 Float | D0 | D1–D2 (and D3–D4 for two-param ops) | D0–D4, A0–A1 |
| #7 Music | D0 | D1, A0 | D0, A0 |

> [!NOTE] Unverified: the source lists TRAP #3's function number in D7, which is unusual (D7 is conventionally a callee-saved register on the 68000). Transcribed as printed.

The window TRAP has one extra side-effect to know about — several of its functions automatically redraw every sprite on screen. Wrap them with `UPDATE OFF` from Basic first to suppress this.

## Window functions (TRAP #3)

Roughly forty functions, numbered 0–39. They fall into several groups:

- **Text output** — `CHROUT` (0), `PRINT STRING` (1), `LOCATE` (2), `CENTRE` (18), `TEST SCREEN` (5)
- **Colours** — `SET PAPER` (3), `SET PEN` (4), `BORDER` (30)
- **Window management** — `INIT WINDOW` (6), `WINDON` (8), `DEL WINDOW` (9), `QWINDOW` (16, quick activate), `MOVE WINDOW` (24), `TITLE` (31), `GET CURRENT` (13)
- **Cursors** — `FIX CURSOR` (14), `SMALL CURSOR` (22), `TALL CURSOR` (23), `GET CURSOR` (17)
- **Editor helpers** — `AUTO INS` (20), `JOIN` (21)
- **Character sets** — `GET CHARSET` (28), `SET CHARSET` (29), `SET ICON ADR` (26)
- **Coordinate conversion** — `XGRAPHIC`/`VGRAPHIC` (35/36) text to graphic; `XTEXT`/`YTEXT` (37/38) graphic to text
- **Drawing** — `SQUARE` (39) draws a bordered rectangle at the current cursor position
- **Miscellany** — `INIT MODE` (10), `GET BUFFER` (11), `WINDCOPY` (12), `SET BACK` (19), `AUTOBACK ON/OFF` (32/33)

Two of these — `STOP INTER` (7) and `START INTER` (15) — manage the window interrupts and are marked **DO NOT CALL**.

## Sprite functions (TRAP #5)

TRAP #5 talks to STOS's SPRITE MANAGER — the interrupt-driven process that handles movement and animation. The first three functions (`INIT MODE`, `CHANGE BANK`, `CHANGE LIMITS`) are unnamed in the source listing; subsequent functions are numbered 4–47:

- **Setup** — `CHANGE BANK` (new sprite bank address in A0), `CHANGE LIMITS` (sprite display area), `CHANGE BACK` (27, new background address)
- **Display** — `SPRITES ON/OFF` (7, all sprites), `SPRITE ON/OFF` (8, single sprite), `SPRITE` (9, draw one), `PUT SPRITE` (35), `ICON` (34), `DRAW SPRITES` (29)
- **Movement & animation** — `MOVES ON/OFF` (10), `MOVE ON/OFF` (11), `MOVE INIT` (12), `ANIMS ON/OFF` (13), `ANIM ON/OFF` (14), `INIT ANIM` (15), `UPDATE` (16), `MOVON` (45, is-sprite-moving test)
- **Mouse** — `SHOW` (17), `HIDE` (18), `CHANGE MOUSE` (19), `MOUSE` (20, get coords), `MOUSEKEY` (21), `DRAW MOUSE` (24), `STOP MOUSE` (28), `MOVE MOUSE` (44), `LIMIT MOUSE` (32)
- **Screen effects** — `SCREEN TO BACK` (22), `BACK TO SCREEN` (23), `SCREEN COPY` (33), `REDUCE` (38), `ZOOM` (42), `APPEAR` (43, screen fade), `SHIFT` (46, palette rotation), `INIT FLASH`/`FLASH` (39/40), `REDRAW` (47)
- **Zones** — `SET ZONE` (25), `ZONE` (26), `INIT ZONE` (36)

`START INTER` (30) and `STOP INTER` (31) control the sprite interrupts and are flagged **DO NOT USE** and **NEVER USE THIS FUNCTION!** respectively.

## Floating-point library (TRAP #6)

This gives assembly programmers the full STOS floating-point maths library. Numbers use the **IEEE 64-bit format** with a range of 10E-307 to 10E+308 — the wide-precision format STOS Basic used prior to v2.4 (the compiler's separate single-precision system is described in the STOS Compiler User Guide).

The function number goes in D0. The first parameter goes in D1–D2 (D1 = low word, D2 = high word); a second parameter, if needed, goes in D3–D4 the same way. The result always lands in D0–D1. The library corrupts D0–D4 and A0–A1 — far more registers than the other TRAPs — so anything you need to keep must be saved first.

Operations ($00–$1C):

- **Arithmetic** — $00 ADFL, $01 SBFL, $02 MLFL, $03 DVFL, $1C POWFL (X^Y)
- **Trigonometric** — $04 SINFL, $05 COSFL, $06 TANFL, $15 ASINFL, $16 ACOSFL, $17 ATANFL
- **Hyperbolic** — $18 SINHFL, $19 COSFL, $1A TANFL
- **Logs & exponential** — $07 EXPFL, $08 LOGFL (natural), $09 LOG10FL (base 10)
- **Roots & integers** — $0A SQRFL, $1B INTFL
- **Conversions** — $0B ATOFL (string to float), $0C FLTOA (float to string), $0D FLTOIN (float to integer), $0E INTOFL (integer to float)
- **Comparisons** — $09 EQFL, $10 NEFL, $11 GTFL, $12 GEFL, $13 LTFL, $14 LEFL — each returns 1 in D0 if true, 0 otherwise

> [!NOTE] Unverified: values above are as printed. The manual is internally inconsistent here — `$09 EQFL` duplicates the `$09` of LOG10FL, and `$19 COSFL` / `$1A TANFL` (described as "Calculate the hyperbolic cos/tan") duplicate the names of the $05/$06 trigonometric functions.

### ADFL example

The manual's $00 ADFL example shows the layout:
```text
MOVE    #0,D0
MOVE.L  #$3FF19999,D1    ; First no in D1-D2
MOVE.L  #$9999999A,D2
MOVE.L  D1,D3            ; Copy 1st no into
MOVE.L  D3,D4            ; 2nd no
TRAP    #6
RTS
```
On return D0.L and D1.L together hold the result.

### FLTOA example

$0C FLTOA converts a floating-point number to an ASCII string. As well as the standard D1–D2 input it takes a digit count in D3 and a buffer pointer in A0:
```text
MOVE.L  #$3FF19999,D1    ; Load 1.1 into D1-D2
MOVE.L  #$9999999A,D2
MOVE    #$C,D0
LEA     BUF(PC),A0
MOVE.W  #$0031,D3        ; 1 Digit after the DP
TRAP    #6
MOVE    #5,D0            ; Print the number on the
TRAP    #4               ; screen.
RTS
BUF:    BDF 1000,0
```

> [!NOTE] Unverified: the manual ends the FLTOA example with `BUF: BDF 1000,0`, transcribed verbatim as printed. Separately, the manual prints the second constant in this example as `#99999999A,D2`; it is transcribed above as `#$9999999A,D2` to match the same 1.1 value in the ADFL example on the previous page.

## Music generator (TRAP #7)

The music TRAP is independent of the rest of STOS Basic and corrupts only D0 and A0. Eleven functions:

- **0 INIT SOUND** — reset sound generator and kill music
- **1 START MUSIC** — begin playback; A0 = address of music
- **2 STOP VOICE** / **3 RESTART VOICE** — pause/resume a single voice; D1 = voice number
- **4 FREEZE** / **5 UNFREEZE** — freeze/resume all music
- **6 CHANGE TEMPO** — D1 = new speed (0–100)
- **7 START INTER** / **8 STOP INTER** — interrupt control; **DO NOT USE**
- **9 TRANSPOSE** — D1 = number of semitones
- **10 GET VOICE** — D1 = voice number; returns current position in D0

## PSG: the sound chip from Basic

The PSG function is the Basic-level interface to the same sound chip driven by the music TRAP. `PSG(r)` reads or writes one of 14 sound registers (0–13) — pitch, noise, volume, envelope shape — by treating them as a Basic array. Assigning to `PSG(r)` immediately loads the value into the chip.

```text
print psg(1)
```

> [!NOTE] Unverified: the OCR of the PSG register table on page 266 is heavily corrupted (stray `CVJ CO`, `LO CO`, `GO`, `CO`, `o` fragments where the register numbers should be). The clean version is in the PSG entry in `dev/pdf-pages/out/batch-15.md` and is not reproduced here.

`PSG` is flagged as **DANGEROUS** in the manual: the sound chip is shared with the ST's floppy-disc system, and careless writes can damage the disc in the current drive.

## Gotchas

- The window TRAP (#3) carries the function number in **D7**, not D0 like the others.
- Several window functions redraw every sprite on screen — wrap them with `UPDATE OFF` from Basic first.
- Calling a function from machine code while Basic is using the same subsystem can produce "unforeseen errors" — be especially careful around the sprite and music managers.
- The interrupt-control functions in each TRAP (`STOP INTER`, `START INTER`) are explicitly marked **DO NOT USE** — they exist for STOS's own initialisation.
- `PSG` writes can corrupt the disc system; the manual describes the function as DANGEROUS.
- The floating-point TRAP #6 corrupts D0–D4 and A0–A1, far more registers than the other TRAPs — save anything you need first.

**See also:** Appendix D (Machine code interface), `TRAP`, `CALL`, `PSG`.
