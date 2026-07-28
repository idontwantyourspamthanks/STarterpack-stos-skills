# Appendix D: Machine code interface

Appendix D documents the bridge between STOS Basic and the 68000: how to load assembly-language routines, how to pass values in and out through the processor's registers, and how to invoke the ST's operating-system TRAPs directly. Used carefully these facilities give you "complete control over the inner workings of your STOS Basic programs"; used carelessly they will crash the machine. STOS Basic is powerful enough that you will rarely need them, but a few lines of machine code can work wonders in a hot loop.

## The four-step workflow for CALL

[`CALL address`](../commands/appendix-d.md) executes any assembly-language program held in the ST's memory. `address` may be either an absolute memory location or the number of one of STOS Basic's 16 memory banks. The manual gives a four-step recipe.

**1. Reserve some memory.** Allocate a bank with `RESERVE AS DATA`. This only needs doing once, because DATA banks are saved automatically along with your Basic program. A completely relocatable routine may instead be stashed in a string variable.

**2. Load the program.** The file must be in TOS relocatable format and the extension must be `.PRG`; anything else raises an error.

**3. Pass any input parameters** through the pseudo-registers [`DREG`](../commands/appendix-d.md) and [`AREG`](../commands/appendix-d.md) (see below).

**4. Call the routine**, by bank number or by absolute address.

```stos
10 reserve as data 7,10000
20 load "file.prg",7
30 dreg(0)=100:dreg(1)=200:rem Pass two parameters
40 call 7
```

### Rules your routine must follow

- It may alter any 68000 register **except A7** (the stack pointer).
- It must always end with an `RTS` instruction.
- It must never call the Gemdos memory-management traps `SETBLOCK`, `MALLOC`, `MFREE`, `KEEPPROCESS` or anything else that reshuffles memory.
- Never `CALL` a GEM program — the system will crash completely.

## Passing values with AREG and DREG

[`AREG(r)`](../commands/appendix-d.md) and [`DREG(r)`](../commands/appendix-d.md) are arrays of pseudo-variables that mirror the 68000's address and data registers. Whenever [`CALL`](../commands/appendix-d.md) or [`TRAP`](../commands/appendix-d.md) runs, STOS copies these arrays into the real registers; when the routine returns, any new values in those registers are copied back out. They are your two-way mailbox between Basic and machine code.

- `AREG` is an array of **eight** pseudo-variables holding a copy of the eight address registers; `r` ranges 0–7 and the array is loaded into A0–A7.
- `DREG` is an array of **eight** elements holding a copy of the data registers; `r` ranges 0–7 for registers D0–D7.

Here is the manual's mouse-positioning example, which loads three data registers and then invokes TRAP 5:
```stos
10 dreg(0)=44:dreg(1)=100:dreg(2)=100
20 trap 5:rem Move mouse to 100,100
```

## Calling the operating system with TRAP

[`TRAP n,parameters`](../commands/appendix-d.md) invokes one of the 68000's trap functions — effectively a library of assembly routines reachable from a single instruction. `n` runs from 0 to 15, and the traps installed under STOS are:

- **0, 1, 13, 14** — the Gemdos functions.
- **3, 5, 6, 7** — the STOS functions.

A full list of Gemdos functions "can be found in any good book of machine-code programming on the ST."

### Specifying parameters

The optional `parameters` are pushed onto the 68000's stack before the trap runs, and default to **word** size. You override the size explicitly:

- `W,expression` — word
- `L,expression` — long word

A neat shortcut: include a string variable such as `A$` and only its **address** is pushed onto the stack, with STOS automatically appending a `chr$(0)` so the string arrives in the C-style, null-terminated format the OS expects. You can also feed values in through [`AREG`](../commands/appendix-d.md) and [`DREG`](../commands/appendix-d.md) instead of the stack — so prefix any long-word parameter with `L,` when a function needs one.

```stos
10 trap 14,33,4:rem Set printer type to EPSON
```

### The TRAP #4 STOS function library

TRAP #4 is the gateway to an expanded version of Gemdos built into STOS. Unlike plain Gemdos, parameters are passed in registers rather than on the stack: the **function number goes in D0**, other data in D1 and A0, and results come back in the same registers. All other registers are preserved. The library spans $00–$1F plus a special `$FFFF` install hook, grouped roughly as follows.

| Group | Functions |
| --- | --- |
| Console I/O | $00 SCONIN, $01 SCONIN ECHO, $02 SCONOUT, $03 READLINE, $05 SPRINT LINE, $06 SPRINT VID |
| Printer | $04 SPRT, $19 ASCII dump |
| Screen | $0F CLS, $10 LOCATE, $11 BREAK (register dump) |
| Files & disc | $0C EXIST, $12 READ, $13 WRITE, $14 CHDRIVE, $15 CHDIR, $16 MKDIR, $17 RMDIR, $18 KILL, $1A FLOPR, $1B FLOPW |
| Conversion | $07 BINHEX, $08 HEXBIN, $09 BINDEC, $0A DECBIN, $0B UPPER |
| 32-bit maths | $1C MUL32, $1D DIV32, $1E DIV64 |
| User routines | $FFFF SET USER, $1F USER |

Two representative assembly snippets from the manual show the calling pattern. SCONOUT ($02) prints a single character held in D1:
```text
MOVE #2,D0
MOVE #"B",D1
TRAP #4
RTS
```
LOCATE ($10) moves the text cursor; the X and Y coordinates are packed into the top and bottom halves of D1:
```text
MOVE #$10,D0
MOVE #$000A0006,D1
TRAP #4
RTS
```

## Gotchas

- TRAP is effectively raw machine code. The manual warns bluntly: "if you play around with the TRAP instruction indiscriminately you will almost certainly CRASH the ST."
- A routine reached via [`CALL`](../commands/appendix-d.md) must return with `RTS` and must never re-enter the Gemdos memory manager — reserve what you need from Basic instead.
- Keep your routine in TOS relocatable `.PRG` format; other extensions are rejected, and a GEM `.PRG` will crash the system if `CALL`ed.
- The default TRAP parameter size is a word; reach for the `L,` prefix whenever a function expects a long word.

**See also:** [`CALL`](../commands/appendix-d.md), [`AREG`](../commands/appendix-d.md), [`DREG`](../commands/appendix-d.md), [`TRAP`](../commands/appendix-d.md).
