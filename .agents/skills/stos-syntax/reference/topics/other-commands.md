# Other commands

This chapter rounds up the STOS Basic commands that are not covered by the specialist chapters on sprites, music, windows and so on — control flow, keyboard input, screen and printer I/O, file and disc access, mathematics, string manipulation and direct memory operations. Most of these will be familiar from other dialects of Basic; the sections below highlight the patterns and STOS-specific quirks worth knowing, and cross-reference the individual command entries.

## Control flow and error handling

The core control-flow commands work as in most Basics: [`GOTO`](../commands/other-commands.md#goto), [`GOSUB`](../commands/other-commands.md#gosub)/[`RETURN`](../commands/other-commands.md#return) for jumps and subroutines, [`FOR...NEXT`](../commands/other-commands.md#for-next) for counted loops, and the conditional [`WHILE...WEND`](../commands/other-commands.md#while-wend) (test at top) and [`REPEAT...UNTIL`](../commands/other-commands.md#repeat-until) (test at bottom). A `GOSUB` may be abandoned early with [`POP`](../commands/other-commands.md#pop), which discards the pending return address. `GOTO` and `GOSUB` both accept a computed expression (e.g. `goto JUMP*2+20`) — the manual warns this is slow, easy to get wrong, and breaks `RENUM`. STOS allows up to 10 nested `FOR...NEXT` loops, but does *not* allow the combined `NEXT I,R1,R2` form found in some Basics: each loop needs its own `NEXT`. [`STOP`](../commands/other-commands.md#stop) returns to the editor and can be resumed with `CONT`; [`END`](../commands/other-commands.md#end) cannot.

Any error normally dumps you back at the editor. To intercept it, set up a trap with [`ON ERROR GOTO`](../commands/other-commands.md#on-error-goto) before the code that may fail. Inside the trap, inspect [`ERRN`](../commands/other-commands.md#errn) and [`ERRL`](../commands/other-commands.md#errl) for the error number and line, then continue with one of the three forms of [`RESUME`](../commands/other-commands.md#resume):

```stos
10 on error goto 50
20 input "Input a positive number";N
30 print "The square root of ";N;" is ";sqr(N)
40 goto 20
50 print "I'm afraid you can only take the square root of a positive number"
60 N=abs(N)
70 resume 10
```

`RESUME` retries the failing statement, `RESUME NEXT` skips to the statement after it, and `RESUME line` jumps to a specific line. Never use `GOTO` to leave an error trap — always use `RESUME`. Disable the trap with `ON ERROR GOTO 0`. [`ERROR`](../commands/other-commands.md#error) `n` raises an error from your own code; the common form is `error errn`, which re-throws an error after your trap has decided it cannot cope. The Control+C interrupt can be disabled with [`BREAK OFF`](../commands/other-commands.md#break) for protected programs; the manual warns against running a protected program without a backup, since a tight loop with no Break leaves no way out.

## Keyboard input and screen output

For quick key polling use [`INKEY$`](../commands/other-commands.md#inkey), which returns the empty string if nothing is pressed. Cursor and function keys have no Ascii value; [`SCANCODE`](../commands/other-commands.md#scancode) exposes the hardware code of the last key. [`FKEY`](../commands/other-commands.md#fkey) returns 1–20 directly when a function key is pressed (shifted keys are 11–20), which is cleaner than decoding scancodes by hand and pairs naturally with `ON FKEY GOSUB`. Always call [`CLEAR KEY`](../commands/other-commands.md#clear-key) at the start of any routine that uses `INKEY$` so stale keystrokes do not leak through from the editor. The ten function keys can be reprogrammed with [`KEY`](../commands/other-commands.md#key), strings can be injected into the keyboard buffer with [`PUT KEY`](../commands/other-commands.md#put-key) (handy for issuing a direct-mode command after a program ends), and [`WAIT KEY`](../commands/other-commands.md#wait-key) halts until the next press. [`KEY SPEED`](../commands/other-commands.md#key-speed) tunes the auto-repeat delay and rate (both in 50ths of a second).

[`INPUT`](../commands/other-commands.md#input) reads variables from the keyboard, [`LINE INPUT`](../commands/other-commands.md#line-input) separates values with Return rather than comma, and [`PRINT`](../commands/other-commands.md#print) outputs as in any other Basic. Formatted output uses `PRINT USING format$;variable list` with a format string built from the characters `~`, `#`, `+`, `-`, `.`, `;` and `^`. The `~` substitutes characters from a string; `#` specifies digit positions; `+`/`-` control sign output; `.` and `;` set decimal alignment; `^` forces exponential form.

[`FIX`](../commands/other-commands.md#fix) `n` sets the default precision for real-number output: `0<n<16` decimal places, `n>16` proportional with trailing zeros removed, `n<0` exponential with `ABS(n)` digits after the point.

## Files: sequential and random access

STOS treats disc files as either sequential (read or written in order, one direction at a time) or random access (record-by-record). The sequential pattern is always: open, transfer with `PRINT#`/`INPUT#`, close.

```stos
10 open out #1,"birthday.seq"
20 input "Input the name of your friend";F$
30 if F$="" then close #1: end
40 input F$;"'s birthday is";B$
50 print #1,F$;",";B$
60 goto 20
```

[`OPEN OUT`](../commands/other-commands.md#open-out) creates a new file (clobbering any existing one) for writing via [`PRINT#`](../commands/other-commands.md#print-hash); [`OPEN IN`](../commands/other-commands.md#open-in) opens an existing file for reading via [`INPUT#`](../commands/other-commands.md#input-hash) or [`LINE INPUT#`](../commands/other-commands.md#line-input-hash). [`CLOSE`](../commands/other-commands.md#close) flushes the buffer — forgetting it loses everything. [`EOF`](../commands/other-commands.md#eof) tests for end of file, [`LOF`](../commands/other-commands.md#lof) returns file length, and [`POF`](../commands/other-commands.md#pof) reads or sets the current position (which works even on sequential files, giving a crude form of random access). Reading back the file above typically uses a `REPEAT...UNTIL EOF(#1)` loop.

Random-access files use [`OPEN #channel,"R",file$`](../commands/other-commands.md#open) and require you to declare a fixed record layout up front with [`FIELD #`](../commands/other-commands.md#field). The field names double as ordinary string variables: assign to them, then call [`PUT #`](../commands/other-commands.md#put-hash) to write at a record number, or [`GET #`](../commands/other-commands.md#get-hash) to load that record back into the fields.

```stos
10 open #1,"R","names.ran"
20 field #1,15 as SURNAME$,15 as NAME$,10 as AREA$,10 as TEL$
30 input "Record number";N
40 get #1,N
50 print "Name: ";NAME$,SURNAME$
60 close #1
```

A single `FIELD` can hold up to 16 fields totalling 65535 bytes. Records must be written in some kind of order — you cannot `PUT` to record 5 if records 1–4 do not yet exist.

The same `OPEN #` command also opens devices: `"MIDI"` for the MIDI port, `"AUX"` for the RS232 port, `"PRT"` for a parallel printer. All the usual input/output statements (`PRINT#`, `INPUT#`, `LINE INPUT#`, `INPUT$`) work with these channels. [`PORT(#channel)`](../commands/other-commands.md#port) returns true if input is waiting.

## Directories and disc management

[`DIR`](../commands/other-commands.md#dir) lists files, optionally with a path string of drive, folder, wildcards (`*` matches up to eight characters, `?` matches one) and an optional `/W` for wide output. [`DIR$`](../commands/other-commands.md#dir-string) is a reserved variable that gets or sets the current directory. To enumerate a directory programmatically, call [`DIR FIRST$`](../commands/other-commands.md#dir-first)(path$,flag) and then [`DIR NEXT$`](../commands/other-commands.md#dir-next) until it returns the empty string — each call yields a 45-character parameter block holding the filename, length, date, time and file type. `flag` is a bitmask that selects which file types to include (read-only, hidden, system, volume label, folder, and so on); passing `-1` returns everything. [`PREVIOUS`](../commands/other-commands.md#previous) moves up one directory level.

The remaining commands are predictable: [`MKDIR`](../commands/other-commands.md#mkdir)/[`RMDIR`](../commands/other-commands.md#rmdir) create and delete folders, [`KILL`](../commands/other-commands.md#kill) erases files (and supports wildcards — be careful, there is no undo), [`RENAME`](../commands/other-commands.md#rename) renames a single file (erroring if the target already exists), [`DFREE`](../commands/other-commands.md#dfree) reports free bytes on the current disc, and [`DRIVE`](../commands/other-commands.md#drive)/[`DRIVE$`](../commands/other-commands.md#drive-string)/[`DRVMAP`](../commands/other-commands.md#drvmap) get or set the current drive. [`FILESELECT$`](../commands/other-commands.md#fileselect)(path$[,title$[,border]]) pops up a GEM-style file selector and returns the chosen path or an empty string.

## Strings, time and randomness

The string library covers the usual transformations — [`UPPER$`](../commands/other-commands.md#upper)/[`LOWER$`](../commands/other-commands.md#lower), [`FLIP$`](../commands/other-commands.md#flip) to reverse a string, [`SPACE$`](../commands/other-commands.md#space) and [`STRING$`](../commands/other-commands.md#string) for repeating characters, [`CHR$`](../commands/other-commands.md#chr)/[`ASC`](../commands/other-commands.md#asc) for code conversion, [`LEN`](../commands/other-commands.md#len), [`VAL`](../commands/other-commands.md#val)/[`STR$`](../commands/other-commands.md#str), and [`HEX$`](../commands/other-commands.md#hex)/[`BIN$`](../commands/other-commands.md#bin) for base conversion — together with the slicing functions [`LEFT$`](../commands/other-commands.md#left)/[`RIGHT$`](../commands/other-commands.md#right)/[`MID$`](../commands/other-commands.md#mid) documented earlier in the manual. Do not confuse `UPPER$`/`LOWER$` (which convert a string) with the editor directives `UPPER`/`LOWER` (which change listing case).

[`TIME$`](../commands/other-commands.md#time) and [`DATE$`](../commands/other-commands.md#date) are reserved string variables maintained by STOS in `"HH:MM:SS"` and `"DD/MM/YYYY"` format. The underlying counter is [`TIMER`](../commands/other-commands.md#timer), a reserved variable incremented once every 50th of a second; assign zero to it to benchmark a section of code. [`WAIT`](../commands/other-commands.md#wait) `n` suspends the program for `n` 50ths of a second — interrupt-driven functions such as `MOVE` and `MUSIC` keep running during the wait. [`RND`](../commands/other-commands.md#rnd)(n) returns a random integer from 0 to n inclusive; a negative n repeats the last value, which is useful when debugging.

## Maths and user-defined functions

The trig functions ([`SIN`](../commands/other-commands.md#sin), [`COS`](../commands/other-commands.md#cos), [`TAN`](../commands/other-commands.md#tan) and their arc and hyperbolic variants) work in radians; [`DEG`](../commands/other-commands.md#deg) and [`RAD`](../commands/other-commands.md#rad) convert between the two, and [`PI`](../commands/other-commands.md#pi) is the constant. The rest of the maths library is straightforward: [`SQR`](../commands/other-commands.md#sqr), [`ABS`](../commands/other-commands.md#abs), [`INT`](../commands/other-commands.md#int), [`SGN`](../commands/other-commands.md#sgn), [`LOG`](../commands/other-commands.md#log) (base 10), [`LN`](../commands/other-commands.md#ln) (natural), [`EXP`](../commands/other-commands.md#exp), [`MAX`](../commands/other-commands.md#max)/[`MIN`](../commands/other-commands.md#min) and [`SWAP`](../commands/other-commands.md#swap).

[`DEF FN`](../commands/other-commands.md#def-fn) defines a single-line function and [`FN`](../commands/other-commands.md#fn) calls it. Variables in the parameter list are local to the call and different types can be mixed. The manual notes that the `DEF FN` statement must appear in the program before the function is used. The remaining commands in the chapter — [`REM`](../commands/other-commands.md#rem), [`DATA`](../commands/other-commands.md#data)/[`READ`](../commands/other-commands.md#read)/[`RESTORE`](../commands/other-commands.md#restore), [`LET`](../commands/other-commands.md#let), [`TRUE`](../commands/other-commands.md#true)/[`FALSE`](../commands/other-commands.md#false)/[`NOT`](../commands/other-commands.md#not) — behave as in any other Basic; note that STOS `DATA` allows expressions involving variables, evaluated at the moment of `READ`.

## Memory, bit operations and the printer

Direct memory access uses byte/word/longword pairs: [`PEEK`](../commands/other-commands.md#peek)/[`POKE`](../commands/other-commands.md#poke), [`DEEK`](../commands/other-commands.md#deek)/[`DOKE`](../commands/other-commands.md#doke), [`LEEK`](../commands/other-commands.md#leek)/[`LOKE`](../commands/other-commands.md#loke). Word and longword addresses must be even or the ST throws an address error. `PEEK` runs in supervisor mode, so any address is fair game (you can safely `print peek(0)`). [`VARPTR`](../commands/other-commands.md#varptr) returns the address of a variable; for a string, the length lives at `DEEK(VARPTR(A$)-2)`. [`COPY`](../commands/other-commands.md#copy) `start,finish TO destination` moves a block quickly, [`FILL`](../commands/other-commands.md#fill) `start TO finish,longword` writes a repeating pattern, and [`HUNT`](../commands/other-commands.md#hunt)(`start TO end, A$`) searches for a byte string. All three accept bank numbers as well as literal addresses.

Bit-level operations mirror the 68000 instruction set: [`ROL`](../commands/other-commands.md#rol)/[`ROR`](../commands/other-commands.md#ror) `x,y` rotate the value in variable `y` by `x` places, with an optional `.b`/`.w`/`.l` size suffix (default `.l`). [`BTST`](../commands/other-commands.md#btst)/[`BSET`](../commands/other-commands.md#bset)/[`BCHG`](../commands/other-commands.md#bchg)/[`BCLR`](../commands/other-commands.md#bclr) `x,y` test, set, toggle or clear bit `x` of variable `y`. In all cases `y` must be a simple variable, not an expression.

For hardcopy, [`LPRINT`](../commands/other-commands.md#lprint) and [`LLIST`](../commands/other-commands.md#llist) are the printer equivalents of `PRINT` and `LIST`, [`LDIR`](../commands/other-commands.md#ldir) dumps the current directory to the printer, [`HARDCOPY`](../commands/other-commands.md#hardcopy) does a graphics screen dump (identical to `Alt+Help` in the editor), and [`WINDCOPY`](../commands/other-commands.md#windcopy) dumps just the active text window — much faster, since it is text only.
